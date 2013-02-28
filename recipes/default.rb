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

# Upstart service config file
template "/etc/init/" + node['ow_media_capture']['service_name'] + ".conf" do
    source "upstart.conf.erb"
    owner node['ow_media_capture']['service_user'] 
    group node['ow_media_capture']['service_user_gid'] 
    variables({
    :service_user => node['ow_media_capture']['service_user'],
    :app_root => node['ow_media_capture']['app_root'] + '/current',
    :run_script => node['ow_media_capture']['run_script'],
    :log_path => node['ow_media_capture']['log_path']
    })
end

# Register capture app as a service
service node['ow_media_capture']['service_name'] do
  provider Chef::Provider::Service::Upstart
  action :enable
end

# Make directory for ssl credentials
directory node['ow_media_capture']['ssl_dir'] do
  owner node['nginx']['user']
  group node['nginx']['group']
  recursive true
  action :create
end

# SSL certificate and key
cookbook_file node['ow_media_capture']['ssl_dir'] + node['ow_media_capture']['ssl_cert']  do
  source "star_openwatch_net.crt"
  owner node['nginx']['user']
  group node['nginx']['group']
  mode 0600
  action :create
end

ssl_key = Chef::EncryptedDataBagItem.load(node['ow_media_capture']['ssl_databag_name'] , node['ow_media_capture']['ssl_databag_item_name'] )

file node['ow_media_capture']['ssl_dir'] + node['ow_media_capture']['ssl_key'] do
  owner node['nginx']['user']
  group node['nginx']['group']
  content ssl_key['*.openwatch.net']
  mode 0600
  action :create
end

# Make Nginx log dirs
directory node['ow_media_capture']['log_dir'] do
  owner node['nginx']['user']
  group node['nginx']['group']
  recursive true
  action :create
end

# Nginx config file
template node['nginx']['dir'] + "/sites-enabled/media_capture.nginx" do
    source "media_capture.nginx.erb"
    owner node['nginx']['user']
    group node['nginx']['group']
    variables({
    :http_listen_port => node['ow_media_capture']['http_listen_port'],
    :app_domain => node[:fqdn],
    :https_listen_port => node['ow_media_capture']['https_listen_port'],
    :ssl_cert => node['ow_media_capture']['ssl_dir'] + node['ow_media_capture']['ssl_cert'],
    :ssl_key => node['ow_media_capture']['ssl_dir'] + node['ow_media_capture']['ssl_key'],
    :app_root => node['ow_media_capture']['app_root'],
    :access_log => node['ow_media_capture']['log_dir'] + node['ow_media_capture']['access_log'],
    :error_log => node['ow_media_capture']['log_dir'] + node['ow_media_capture']['error_log'],
    :proxy_pass => node['ow_media_capture']['proxy_pass']
    })
    notifies :restart, "service[nginx]"
    action :create
end

include_recipe "ow_media_capture::sync"

