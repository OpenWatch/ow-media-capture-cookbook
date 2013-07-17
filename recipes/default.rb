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
    :app_root => node['ow_media_capture']['app_root'],
    :run_script => node['ow_media_capture']['run_script'],
    :log_path => node['ow_media_capture']['log_dir'] + node['ow_media_capture']['app_log_file']
    })
end

# Make log dir
directory node['ow_media_capture']['log_dir'] do
  owner node['nginx']['user']
  group node['ow_media_capture']['service_user_gid']
  mode "770" 
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
    :app_domain => node['ow_media_capture']['app_domain'],
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

