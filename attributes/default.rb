#
# Cookbook Name:: ow_media_capture
# Attributes:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under the AGPLv3
#

# Chef repo
default['ow_media_capture']['secret_databag_name'] 		= "secrets"
default['ow_media_capture']['secret_item_name'] 		= "ow_media_capture"

# SSL
default['ow_media_capture']['ssl_databag_name'] 		= "ssl"
default['ow_media_capture']['ssl_databag_item_name'] 		= "ssl"

# System
default['ow_media_capture']['app_root']      		= "/var/www/NodeMediaCapture"
default['ow_media_capture']['config_path']       	= "/config/default.yaml"
default['ow_media_capture']['git_user']      		= "git"
default['ow_media_capture']['service_user']      	= "media-capture"
default['ow_media_capture']['service_user_gid']     = 500
default['ow_media_capture']['service_name']      	= "ow_media_capture"
default['ow_media_capture']['git_url']      		= "git@github.com:OpenWatch/NodeMediaCapture.git"
default['ow_media_capture']['git_rev']      		= "HEAD"
default['ow_media_capture']['git_branch']      		= "v2" # Can't get this working yet
default['ow_media_capture']['git_ssh_wrapper']   	= "/home/git/.ssh/wrappers/ow-github_deploy_wrapper.sh"
default['ow_media_capture']['log_path']		    	= "/var/log/ow_media_capture.log"
default['ow_media_capture']['run_script']	    	= "run.sh"

# Nginx
default['ow_media_capture']['http_listen_port']     = 80
default['ow_media_capture']['https_listen_port']    = 443
default['ow_media_capture']['ssl_dir']				= "/srv/ssl/"
default['ow_media_capture']['ssl_cert']     		= "star_openwatch_net.crt"
default['ow_media_capture']['ssl_key']     			= "star_openwatch_net.key"
default['ow_media_capture']['log_dir']     			= "/var/log/ow/"
default['ow_media_capture']['access_log']     		= "nginx_access_media_capture.log"
default['ow_media_capture']['error_log']     		= "nginx_error_media_capture.log"
default['ow_media_capture']['proxy_pass']     		= "http://localhost:5000"

# NodeMediaCapture
default['ow_media_capture']['incoming_tmp']			= "/tmp"
default['ow_media_capture']['temp_bucket']			= "/internment"
default['ow_media_capture']['temp_reject_bucket']	= "/internment-rejected" 
default['ow_media_capture']['site_domain']			= "localhost"
default['ow_media_capture']['app_port']				= 5000
default['ow_media_capture']['couch_table_name']		= "recordings"

# NodeMediaProcess
default['ow_media_capture']['process_api_schema']	= "https://"
default['ow_media_capture']['process_api_url']		= "alpha.openwatch.net/api/"

# Django
default['ow_media_capture']['django_api_schema']	= "https://"
default['ow_media_capture']['django_api_url']		= "alpha.openwatch.net/api"

