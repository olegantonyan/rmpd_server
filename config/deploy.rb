# config valid only for current version of Capistrano
lock '3.11.0'

set :application, 'rmpd_server'
set :repo_url, 'git@bitbucket.org:slon-ds/rmpd_server.git'
set :user, 'badmotherfucker'
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, %w{config/database.yml config/config.yml}
set :branch, ENV['BRANCH'] || 'master'

set :rbenv_path, "/home/#{fetch(:user)}/.rbenv"
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :rollbar_token, YAML.load_file(File.expand_path('../secrets.yml', __FILE__))[fetch(:rails_env) || 'production']['rollbar_token']
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

#set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
#set :default_environment, {
#  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
#}


#set :pty, true
#set :use_sudo, false

#set :rbenv_type, :user
#set :rbenv_ruby, '2.2.2'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  namespace :puma do
    task :restart do
      on roles(:app) do |host|
        execute "sudo systemctl restart rmpd_server"
      end
    end
  end

  namespace :sidekiq do
    task :restart do
      on roles(:app) do |host|
        execute "sudo systemctl stop 'rmpd_server_sidekiq@*' --no-block"
        execute "sudo systemctl daemon-reload" # unit file could be changed in new deploy
        execute "sudo systemctl start 'rmpd_server_sidekiq@#{Time.now.utc.strftime('%Y%m%d%H%M%S')}-#{rand(10000000)}'"
      end
    end
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == %x[git rev-parse origin/"#{fetch(:branch)}"]
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  before :starting,     'check_revision'
  after  :finishing,    'compile_assets'
  after  :finishing,    'cleanup'
  after  :finishing,    'deploy:puma:restart'
  after  :finishing,    'deploy:sidekiq:restart'

  task :put_branch do
    on roles(:app) do
      execute "cd #{release_path} && echo #{fetch(:branch)} > BRANCH"
    end
  end
  before 'deploy:puma:restart', 'deploy:put_branch'
end
