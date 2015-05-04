# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Company.create(title: Company::DEMO_TITLE)
Role.create(name: 'root')
Role.create(name: 'guest')

#demouser = User.create(email: User::DEMO_EMAIL, password: User::DEMO_PASSWORD, displayed_name: 'Демо')
#demouser.skip_confirmation!
#demouser.save