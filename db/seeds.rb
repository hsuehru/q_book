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

Language.create!(:name => "chinese")
Language.create!(:name => "english")


ClassificationType.create!(:name => "G")
ClassificationType.create!(:name => "PG")
ClassificationType.create!(:name => "PG13")
ClassificationType.create!(:name => "R")


a=Category.create!(:name => "類別A")
b=Category.create!(:name => "類別B")
a.category_items.create(:name => "AAA-1")
a.category_items.create(:name => "AAA-2")
a.category_items.create(:name => "AAA-3")
b.category_items.create(:name => "BBB-1")
b.category_items.create(:name => "BBB-2")
b.category_items.create(:name => "BBB-3")



require 'csv'
csv1=CSV.read("#{Rails.root}/ownFile/csv/first.csv")
csv1.each do |row|
  row.each_with_index do |element, index|
     Category.create(:name => element)
  end
end

csv2 = CSV.read("#{Rails.root}/ownFile/csv/second.csv")
csv2.each do |row|
i=0
row.compact!
row.each do |value|
    if i == 0
      @c = Category.find_by(:name => value.to_s)
    else
      @c.category_items.create(:name => value.to_s)

    end
    i = i + 1
  end
end
