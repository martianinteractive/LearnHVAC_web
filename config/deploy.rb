default_run_options[:pty] = true
set :application, "learnhvac"
set :keep_releases, 5
set :deploy_via, :remote_cache
set :repository,  "git@github.com:martianinteractive/LearnHVAC_web.git"
set :branch, "forum_style"
set :scm_username, "learnhvac"
set :scm, "git"
set :user, "learnhvac"
set :use_sudo, false
set(:deploy_to) {"/home/learnhvac/#{rails_env}"}

role :app, "rentcloud.com"
role :web, "rentcloud.com"
role :db,  "rentcloud.com", :primary => true

after "deploy", "deploy:cleanup"

task :production do
  set :rails_env, "production"
end

namespace(:deploy) do
  desc "setup the server's database.yml file" 
  task :after_update_code do
    run "rm -rf #{release_path}/config/database.yml && ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Configure and restart the passenger"
  task :restart, :roles => :app do
    run "touch #{release_path}/tmp/restart.txt"
  end
  
end