
# System
default['capture']['app_root']      		= "/var/www/NodeMediaCapture"
default['capture']['config_path']       	= "/config/default.yaml"
default['capture']['git_user']      		= "git"
default['capture']['service_user']      	= "media-capture"
default['capture']['service_name']      	= "ow_media_capture"
default['capture']['git_url']      			= "git@github.com:OpenWatch/NodeMediaCapture.git"
default['capture']['git_rev']      			= "HEAD"
default['capture']['git_ssh_wrapper']   	= "/tmp/wrap-ssh4git.sh"
default['capture']['log_path']		    	= "/var/log/ow_media_capture.log"
default['capture']['run_script']	    	= "run.sh"

# NodeMediaCapture
default['capture']['incoming_tmp']			= "/tmp"
default['capture']['temp_bucket']			= "/internment"
default['capture']['temp_reject_bucket']	= "/internment-rejected" 
default['capture']['site_domain']			= "localhost"
default['capture']['app_port']				= 5000
default['capture']['couch_table_name']		= "recordings"

# NodeMediaProcess
default['capture']['process_api_schema']	= "https://"
default['capture']['process_api_url']		= "alpha.openwatch.net/api/"

# Django
default['capture']['django_api_schema']		= "https://"
default['capture']['django_api_url']		= "alpha.openwatch.net/api"
default['capture']['django_api_user']		= "test"
default['capture']['django_api_password']	= "test"
