# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdministratorType.create!(:name => "master")
AdministratorType.create!(:name => "normal")
MemberTableOne.create!(:email => "AAA@gmail.com",:password => "QQQ")
MemberTableOne.create!(:email => "AAA2@gmail.com",:password => "QQQ")
MemberTableOne.create!(:email => "AAA3@gmail.com",:password => "QQQ")
MemberTableOne.create!(:email => "AAA4@gmail.com",:password => "QQQ")
MemberTableTwo.create!(:email => "AAA5@gmail.com",:password => "QQQ")
MemberTableTwo.create!(:email => "AAA6@gmail.com",:password => "QQQ")
MemberTableTwo.create!(:email => "AAA7@gmail.com",:password => "QQQ")
MemberTableTwo.create!(:email => "AAA8@gmail.com",:password => "QQQ")
