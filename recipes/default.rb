#
# Cookbook Name:: ow_media_capture
# Recipe:: default
#
# Copyright 2013, The OpenWatch Corporation, FPC
#
# All rights reserved - Do Not Redistribute
#

# Register capture as a service

# Currently only supports Upstart on Ubuntu
# TODO: Check out runit to make this platform-agnostic

if node['capture']['method'] == 'create'
	# Register capture app as a service
	service node['capture']['service_name'] do
	  provider Chef::Provider::Service::Upstart
	  action :enable
	end

	## Upstart service config file
	template "/etc/init/" + node['capture']['service_name'] + ".conf" do
  	  source "upstart.conf.erb"
  	  variables({
    	:service_user => node['capture']['service_user'],
    	:app_root => node['capture']['app_root'],
    	:run_script => node['capture']['run_script'],
    	:log_path => node['capture']['log_path']
  	  })
  end


end

# Establish ssh wrapper for the git user

ssh_key = Chef::EncryptedDataBagItem.load("ssh-deploy", "git")

git_ssh_wrapper "ow-github" do
  user node['capture']['git_user']
  group node['capture']['git_user']
  ssh_key_data ssh_key['id_rsa']
end

# Checkout and Deploy NodeMediaCapture application
# See Chef's deploy resource docs: 
# http://wiki.opscode.com/display/chef/Deploy+Resource
deploy_revision node['capture']['app_root'] do
  repo node['capture']['git_url']
  revision repo node['capture']['git_rev'] # or "<SHA hash>" or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  user node['capture']['git_user']
  enable_submodules true
  migrate false
  shallow_clone true
  action :deploy # or :rollback
  git_ssh_wrapper node['capture']['git_ssh_wrapper']
  scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion

  notifies :restart, "service["+ node['capture']['service_name'] +"]"

  before_restart do
    # create default.yaml
    template node['capture']['app_root'] + node['capture']['config_path'] do
        source "default.yaml.erb"
        variables({
        :incoming_tmp => node['capture']['incoming_tmp'],
        :temp_bucket => node['capture']['temp_bucket'],
        :temp_reject_bucket => node['capture']['temp_reject_bucket'],
        :site_domain => node['capture']['site_domain'],
        :port => node['capture']['app_port'],
        :tablename => node['capture']['couch_table_name'],

        :process_api_scheme => node['capture']['process_api_scheme'],
        :process_api_url => node['capture']['process_api_url'],

        :django_api_user => node['capture']['api_user'],
        :django_api_password => node['capture']['api_password'],
        :django_api_url => node['capture']['api_url'],
        })
    end

  end

end
