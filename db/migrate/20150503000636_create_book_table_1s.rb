class CreateBookTable1s < ActiveRecord::Migration
  def change
    create_table :book_table_1s do |t|
      t.string :name, :null => false
      t.string :isbn, :limit => "13", :null => false
      t.integer :graph_count
      t.text :author_name_list
      t.text :translator_name_list
      t.references :book_series
      t.date :publish_date
      t.references :publish_company
      t.float :rating, :default => 0
      t.integer :rating_count, :default => 0
      t.references :language
      t.references :category
      t.references :category_item
      t.text :content_introduction
      t.integer :page_number
      t.references :classification_type
      t.text :fans_list
      t.integer :fans_count, :default => 0
      t.text :activity_id_list
      t.boolean :active, :default => false

      t.timestamps null: false
    end
    add_index :book_table_1s, [:isbn]
  end
end
