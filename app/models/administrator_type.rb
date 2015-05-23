class AdministratorType < ActiveRecord::Base
  has_many :administrators
  validates :name, :presence => true, :length => { :maximum => 20 }
  validates :name, :uniqueness => { :case_sensitive => false }
end
