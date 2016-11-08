namespace :sidekiq do
  desc 'Clear all Sidekiq queues'
  task clear: :environment do
    puts Sidekiq.redis(&:flushdb)
  end
end
