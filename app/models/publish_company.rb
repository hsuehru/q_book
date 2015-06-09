class PublishCompany < ActiveRecord::Base
  has_many :author_require_join_publishes
  has_many :book_series
  validates :name, :presence => true,
                   :length =>{ :maximum => 50},
                   :uniqueness => { :case_sensitive => false } 
  validates :email, :format => { :with => /\A[^@]+@[^@]+\z/ },
                    :allow_nil => true,
                    :length => { :maximum => 100 },
                    :uniqueness => { :case_sensitive => false }
end
