# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdministratorType.create!(:name => "master")
AdministratorType.create!(:name => "normal")

Administrator.create!(:email => "AAA1@gmail.com", :password=> "QQQ",
  :administrator_type_id => 1)
Administrator.create!(:email => "AAA2@gmail.com", :password=> "QQQ",
  :administrator_type_id => 1)
Administrator.create!(:email => "AAA3@gmail.com", :password=> "QQQ",
  :administrator_type_id => 1)
Administrator.create!(:email => "AAA4@gmail.com", :password=> "QQQ",
  :administrator_type_id => 1)
MemberTableOne.create!(:email => "AAA1@gmail.com",:password => "QQQ")
MemberTableOne.create!(:email => "AAA2@gmail.com",:password => "QQQ")
MemberTableOne.create!(:email => "AAA3@gmail.com",:password => "QQQ")
MemberTableOne.create!(:email => "AAA4@gmail.com",:password => "QQQ")
MemberTableTwo.create!(:email => "AAA5@gmail.com",:password => "QQQ")
MemberTableTwo.create!(:email => "AAA6@gmail.com",:password => "QQQ")
MemberTableTwo.create!(:email => "AAA7@gmail.com",:password => "QQQ")
MemberTableTwo.create!(:email => "AAA8@gmail.com",:password => "QQQ")

@p1=PublishCompany.create!(:name => "出版社A")
@p2=PublishCompany.create!(:name => "出版社B")
@p3=PublishCompany.create!(:name => "出版社C")

BookSalesAccountType.create!(:name => "master")
BookSalesAccountType.create!(:name => "normal")
BookSalesAccountType.create!(:name => "sales")

@bs1=BookSalesAccount.create!(:email => "AAA1@gmail.com", :password => "QQQ",
   :publish_id_list => "1")
@bs2=BookSalesAccount.create!(:email => "AAA2@gmail.com", :password => "QQQ",
   :publish_id_list => "2")
@bs3=BookSalesAccount.create!(:email => "AAA3@gmail.com", :password => "QQQ",
   :publish_id_list => "3")
@p1.update(:manager_master_id_list => @bs1.id)
@p2.update(:manager_master_id_list => @bs2.id)
@p3.update(:manager_master_id_list => @bs3.id)
Author.create!(:email => "AAA1@gmail.com", :password => "QQQ")
Author.create!(:email => "AAA2@gmail.com", :password => "QQQ")
Author.create!(:email => "AAA3@gmail.com", :password => "QQQ")
Author.create!(:email => "AAA4@gmail.com", :password => "QQQ")
