require 'spec_helper'

describe User do

	before(:each) do 
		@attr = { :name => "Example User", 
							:email => "user@example.com",
							:password => "foobar", 
							:password_confirmation => "foobar" 
						}
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end

	it "should require a name" do
		noname = User.new(@attr.merge(:name => ""))
		noname.should_not be_valid
	end

	it "should require an email" do
		nomail = User.new(@attr.merge(:email=> ""))
		nomail.should_not be_valid
	end

	it "should reject too long names" do
		n = 'a' * 51
		u = User.new(@attr.merge(:name => n))
		u.should_not be_valid
	end

	it "should accept valid email addresses" do
		addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		addresses.each do |a|
			u = User.new(@attr.merge(:email => a))
			u.should be_valid
		end
	end

	it "should reject invalid email addresses" do
		addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
		addresses.each do |a| 
			u = User.new(@attr.merge(:email => a))
			u.should_not be_valid
		end
	end

	it "should reject duplicate email addresses" do
		User.create!(@attr)
		u = User.create(@attr)
		u.should_not be_valid
	end

	it "should reject email addresses identical up to case" do
		uc = @attr[:email].upcase
		User.create!(@attr)
		u = User.new(@attr.merge(:email => uc))
			u.should_not be_valid
	end

	describe "password valiations" do
		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
		end

		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
		end

		it "should reject short passwords" do
			p = "a" * 5
			User.new(@attr.merge(:password => p, :password_confirmation => p)).should_not be_valid
		end

		it "should reject long passwords" do
			p = 'b' * 41
			User.new(@attr.merge(:password => p, :password_confirmation => p)).should_not be_valid
		end
	end

	describe "password encryption" do
	 	before(:each) do
			@user = User.create(@attr)
		end

		it "should have an encrypted password" do
			@user.should respond_to(:encrypted_password)
		end

		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end

		it "should be true if the passwords match" do
			@user.has_password?(@attr[:password]).should be_true
		end

		it "should be false if the passwords do not match" do
			@user.has_password?("assman").should be_false
		end
	end

	describe "admin attribute" do
		
		before(:each) do
			@user = User.create(@attr)
		end

		it 'should respond to admin' do
			@user.should respond_to(:admin)
		end

		it 'should not be admin by default' do
			@user.should_not be_admin
		end

		it 'should be convertible to admin' do
			@user.toggle!(:admin)
			@user.should be_admin
		end
	end
end
