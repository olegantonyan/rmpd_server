namespace :device do
  desc 'Create a new unbound device'
  task :create, [:login, :password] => [:environment] do |_, args|
    Device.create!(login: args.login, password: args.password)
  end
end
