set :application, "easycrate"
set :repository,  "git@dev.time-is-money.org:dumbo_easy_create.git"

set :scm, :git

set :user, "deploy"
set :password, "foiwa39j"

set :deploy_to,   "/home/deploy/#{application}"

ssh_options[:paranoid] = false

default_run_options[:pty] = true
set :sudo_prompt, ""



role :app, "easycrate.time-is-money.org"                          # This may be the same as your `Web` server
role :db,  "easycrate.time-is-money.org", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end