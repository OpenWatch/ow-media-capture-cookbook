# Establish ssh wrapper for the git user

ssh_key = Chef::EncryptedDataBagItem.load("ssh", "git")

# Get group name from gid cause this library is "different"
groups_databag_name = node['ow_users']['groups_databag_name']
groups_item_name = node['ow_users']['groups_databag_item_name']
gids_item = data_bag_item(groups_databag_name, groups_item_name)
gids = gids_item["gids"]

git_ssh_wrapper "ow-github" do
  owner node['ow_media_capture']['git_user']
  group gids[node['ow_media_capture']['service_user_gid'].to_s()]
  ssh_key_data ssh_key['id_rsa']
end

# Checkout and Deploy NodeMediaCapture application
# See Chef's deploy resource docs: 
# http://wiki.opscode.com/display/chef/Deploy+Resource
deploy_revision node['ow_media_capture']['app_root'] do
  repository node['ow_media_capture']['git_url']
  revision node['ow_media_capture']['git_rev'] # or "<SHA hash>" or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  user node['ow_media_capture']['git_user']
  enable_submodules true
  migrate false
  shallow_clone true
  action :deploy # or :rollback
  git_ssh_wrapper node['ow_media_capture']['git_ssh_wrapper']
  scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion

  # notifies :restart, "service["+ node['ow_media_capture']['service_name'] +"]"

end

# create default.yaml
secrets = Chef::EncryptedDataBagItem.load(node['ow_media_capture']['secret_databag_name'], node['ow_media_capture']['secret_item_name'])

template node['ow_media_capture']['app_root'] + node['ow_media_capture']['config_path'] do
    source "default.yaml.erb"
    variables({
    :incoming_tmp => node['ow_media_capture']['incoming_tmp'],
    :temp_bucket => node['ow_media_capture']['temp_bucket'],
    :temp_reject_bucket => node['ow_media_capture']['temp_reject_bucket'],
    :site_domain => node['ow_media_capture']['site_domain'],
    :port => node['ow_media_capture']['app_port'],
    :tablename => node['ow_media_capture']['couch_table_name'],

    :process_api_scheme => node['ow_media_capture']['process_api_scheme'],
    :process_api_url => node['ow_media_capture']['process_api_url'],

    :django_api_user => secrets['django_api_user'],
    :django_api_password => secrets['django_api_password'],
    :django_api_url => node['ow_media_capture']['api_url'],
    })
end

# Install npm packages
bash "npm install" do
  user node['ow_media_capture']['git_user']
  cwd node['ow_media_capture']['app_root'] + '/current'
  code <<-EOH
  npm install forever
  npm install
  EOH
end