require 'bundler/capistrano'

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

task :production do
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


namespace :db do
 desc "Load production data into development database"
 task :fetch_remote_db, :roles => :db, :only => { :primary => true } do
   require 'yaml'
   
   pdb_file = capture "cat #{deploy_to}/current/config/database.yml"
   pdb = YAML::load(pdb_file)
   ddb = YAML::load_file('config/database.yml')

   filename = "dump.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql"

   on_rollback do 
     delete "/tmp/#{filename}" 
     delete "/tmp/#{filename}.gz" 
   end
   cmd = "mysqldump -u #{pdb['production']['username']} --password=#{pdb['production']['password']} #{pdb['production']['database']} > /tmp/#{filename}"
   puts "Dumping remote database"
   run(cmd) do |channel, stream, data|
     puts data
   end

   # compress the file on the server
   puts "Compressing remote data"
   run "gzip -9 /tmp/#{filename}"
   puts "Fetching remote data"
   get "/tmp/#{filename}.gz", "dump.sql.gz"

   # build the import command
   # no --password= needed if password is nil. 
   if ddb['development']['password'].nil?
     cmd = "mysql -u #{ddb['development']['username']} #{ddb['development']['database']} < dump.sql"
   else
     cmd = "mysql -u #{ddb['development']['username']} --password=#{ddb['development']['password']} #{ddb['development']['database']} < dump.sql"
   end

   # unzip the file. Can't use exec() for some reason so backticks will do
   puts "Uncompressing dump"
   `gzip -d dump.sql.gz`
   puts "Executing : #{cmd}"
   `#{cmd}`
   puts "Cleaning up"
   `rm -f dump.sql`

   puts "Be sure to run rake db:migrate to ensure your database schema is up to date!"
 end
end
