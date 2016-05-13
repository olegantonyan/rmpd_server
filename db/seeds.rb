# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.find_by_email('demo@demo.demo')
  user = User::Registration.new(email: 'demo@demo.demo', password: 'demodemo', displayed_name: 'Demo User', company_title: 'Demo')
  user.save!
  user.confirm
end
