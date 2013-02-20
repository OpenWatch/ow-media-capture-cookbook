#
# Cookbook Name:: ow_media_capture
# Recipe:: default
#
# Copyright 2013, The OpenWatch Corporation, FPC
#
# All rights reserved - Do Not Redistribute
#

# Register capture as a service

# Set permissions

if node['capture']['method'] == 'create'
	# Register capture as a service
	# Set permissions
	# Override node['capture']['restart_cmd'] to a start command?
	service node['capture']['service_name'] do
	  provider Chef::Provider::Service::Upstart
	  action :enable
	end

	## Template service config file
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
end

# default-template.yaml -> default.yaml
# Set user permissions

