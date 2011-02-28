require 'faker'

namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		User.create!(:name => "foo bar", :email => "foo@bar.com", :password => "foobar",
								 :password_confirmation => "foobar")
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@gmail.com"
			User.create(:name => name, :email => email, :password => "password", 
									:password_again => "password")
		end
	end
end

