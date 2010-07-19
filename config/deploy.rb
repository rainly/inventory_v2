default_run_options[:pty] = true
set :application, "Inventory"
set :domain, "inventory.cycomsoft.com"
set :deploy_via, :remote_cache
set :deploy_to, "/opt/rails-apps/inventory/"
set :repository,  "."

set :user, "deployer"
set :scm, :git
set :scm_passphrase, "deployer"
set :repository, "git@github.com:rahmat-budiharso/inventory_v2.git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :use_sudo, false
set :copy_startegy, "checkout"
set :copy_compression, :gzip

role :web, "inventory.cycomsoft.com"                          # Your HTTP server, Apache/etc
role :app, "inventory.cycomsoft.com"                          # This may be the same as your `Web` server
role :db,  "inventory.cycomsoft.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

after "deploy:update_code", :touch_restart_txt

desc "touch restart.txt file to restart passenger"
task :touch_restart_txt, :role => :app do
  run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
end

depend :local, :command, "git"
depend :remote, :gem, "rails", "2.3.8"
depend :remote, :gem, "will_paginate"
depend :remote, :gem, "authlogic"
depend :remote, :gem, "searchlogic"
depend :remote, :gem, "subdomain-fu"
depend :remote, :gem, "cancan"
depend :remote, :gem, "slim_scrooge"
depend :remote, :gem, "formtastic"
depend :remote, :gem, "chronic"
depend :remote, :gem, "prawn"
depend :remote, :gem, "haml"
depend :remote, :gem, "spreadsheet"
# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
