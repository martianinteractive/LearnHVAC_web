set :application, "LearnHVAC Web"
set :keep_releases, 5
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :repository,  "git@github.com:martianinteractive/LearnHVAC_web.git"
set :branch, 'rails3'
set :scm, 'git'
set :user, 'deploy'
set :deploy_to, "/var/www/v2.learnhvac.org"
set :rails_env, "production"
ssh_options[:port] = 8888
set :use_sudo, false

task :v2 do
  role :app, "learnhvac.org"
  role :web, "learnhvac.org"
  role :db,  "learnhvac.org", :primary => true
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

namespace :bundler do
  desc "Run bundler, installing gems"
  task :install do
    run("cd #{release_path} && /usr/local/bin/bundle install --without=development test")
  end
end

after "deploy:update_code", "bundler:install"
