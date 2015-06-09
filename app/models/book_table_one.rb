class BookTableOne < ActiveRecord::Base
  self.table_name = "book_table_1s"
  validates :name, :presence => true
  validates :isbn, :uniqueness => true, :presence => true
  validates :publish_date, :presence => true
  validates :language_id, :presence => true
  validates :category_id, :presence => true
  validates :classification_type_id, :presence => true
  validates_numericality_of :isbn, :only_integer => true
  validates_numericality_of :graph_count, :only_integer => true
  validates_numericality_of :page_number, :only_integer => true
  validates_length_of :isbn, :in =>10..13
  
  
end
