class CreateBookTable1s < ActiveRecord::Migration
  def change
    create_table :book_table_1s do |t|
      t.string :isbn, :limit => "13"
      t.integer :graph_count
      t.string :name
      t.text :author_name_list
      t.text :translator_name_list
      t.references :book_series
      t.date :publish_date
      t.references :publish_company
      t.float :rating
      t.integer :rating_count
      t.references :language
      t.references :category
      t.references :category_item
      t.text :content_introduction
      t.integer :page_number
      t.references :classification_type
      t.text :fans_list
      t.integer :fans_count
      t.text :activity_id_list
      t.boolean :active

      t.timestamps null: false
    end
  end
end
