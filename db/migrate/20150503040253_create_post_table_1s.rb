class CreatePostTable1s < ActiveRecord::Migration
  def change
    create_table :post_table_1s do |t|
      t.references :book_series
      t.string :subject
      t.text :content
      t.references :author
      t.integer :member_table_number
      t.integer :member_table_id
      t.integer :viewer
      t.boolean :sticky
      t.datetime :last_reply_time

      t.timestamps null: false
    end
  end
end
