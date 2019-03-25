# config valid only for current version of Capistrano
lock '3.11.0'

set :application, 'rmpd_server'
set :repo_url, 'git@bitbucket.org:slon-ds/rmpd_server.git'
set :user, 'rmpd'
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, %w{config/database.yml config/config.yml}
set :branch, ENV['BRANCH'] || 'master'

namespace :deploy do
  namespace :puma do
    task :restart do
      on roles(:app) do |host|
        execute "sudo systemctl daemon-reload" # unit file could be changed in new deploy
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

    task clear: :environment do
      on roles(:app) do |host|
        puts Sidekiq.redis(&:flushdb)
      end
    end
  end

  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == %x[git rev-parse origin/"#{fetch(:branch)}"]
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts 'Run `git push` to sync changes'
        exit
      end
    end
  end

  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end

  task :put_branch do
    on roles(:app) do
      execute "cd #{release_path} && echo #{fetch(:branch)} > BRANCH"
    end
  end

  before 'starting',                  'check_revision'
  before 'deploy:puma:restart',       'deploy:put_branch'
  before 'deploy:assets:precompile',  'deploy:yarn_install'
  after  'finishing',                 'cleanup'
  after  'finishing',                 'deploy:puma:restart'
  after  'finishing',                 'deploy:sidekiq:restart'
end
