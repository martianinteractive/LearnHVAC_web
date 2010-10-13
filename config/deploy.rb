set :application, "LearnHVAC Web"
set :keep_releases, 5
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :repository,  "git@github.com:martianinteractive/LearnHVAC_web.git"
set :branch, 'rails3'
set :scm, 'git'
set :user, 'deploy'
set :deploy_to, "/var/www/app.learnhvac.org"
set :rails_env, "production"
# ssh_options[:port] = 8888
set :use_sudo, false

task :app do
  role :app, "app.learnhvac.org"
  role :web, "app.learnhvac.org"
  role :db,  "app.learnhvac.org", :primary => true
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
  
  desc "Bundle and minify the JS and CSS files"
  task :generate_assets, :roles => :web do
    root_path = File.expand_path(File.dirname(__FILE__) + '/..')
    assets_path = "#{root_path}/public/minified"
    run_locally "jammit #{root_path}/config/assets.yml"
    top.upload assets_path, "#{current_release}/public", :via => :scp, :recursive => true
  end
end
after("deploy:update_code", "deploy:generate_assets")

namespace :bundler do
  desc "Run bundler, installing gems"
  task :install do
    run("cd #{release_path} && /usr/local/bin/bundle install")
  end
end

# after "deploy:update_code", "bundler:install"
