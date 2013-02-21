name             'ow_media_capture'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures ow_media_capture'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "capture", "Pulls the OpenWatch NodeMediaCapture code, specifies appropriate user permissions to its root, npm installs packages.json, creates default.yaml from the provided template and starts the application as a service"
recipe "capture::sync", "Pulls the specified OpenWatch NodeMediaCapture code, npm installs packages.json, creates default.yaml from the provided template and restarts the application service"

%w{ ubuntu }.each do |os|
  supports os
end

depends "chef-ssh-wrapper"

attribute "capture/app_root",
  :display_name => "App root directory",
  :description => "Location to checkout application to",
  :default => "/var/www/NodeMediaCapture"

attribute "capture/git_user",
  :display_name => "Git user",
  :description => "username to run git commands as",
  :default => "git"

attribute "capture/service_user",
  :display_name => "service user",
  :description => "username to run app service as",
  :default => "media-capture"

attribute "capture/service_name",
  :display_name => "Service name",
  :description => "The name of the service responsible for running the capture app",
  :default => "ow_media_capture"

attribute "capture/git_url",
  :display_name => "Git repository url",
  :description => "URL of the git repository to checkout",
  :default => "git@github.com:OpenWatch/NodeMediaCapture.git"

attribute "capture/git_rev",
  :display_name => "Git revision",
  :description => "Revision to checkout with git. Can be 'HEAD', tag name or a SHA hash",
  :default => "HEAD"

attribute "capture/git_ssh_wrapper",
  :display_name => "Git ssh wrapper location",
  :description => "Output location for shell script to prep git user for connection to OpenWatch's git repo",
  :default => "/tmp/wrap-ssh4git.sh"

attribute "capture/log_path",
  :display_name => "App Log path",
  :description => "An absolute path",
  :default => "/var/log/ow_media_capture.log"

attribute "capture/run_script",
  :display_name => "App run script",
  :description => "Script to have upstart call. A path relative to the app root",
  :default => "run.sh"

