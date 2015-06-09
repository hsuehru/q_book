class BookSeries < ActiveRecord::Base
  belongs_to :publish_company
  validates :name, :presence => true, :uniqueness => true
end
