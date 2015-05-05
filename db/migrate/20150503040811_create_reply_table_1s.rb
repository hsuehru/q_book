class CreateReplyTable1s < ActiveRecord::Migration
  def change
    create_table :reply_table_1s do |t|
      t.integer :post_table_number
      t.integer :post_table_id
      t.text :content
      t.references :author
      t.integer :member_table_number
      t.integer :member_table_id
      t.string :poster_nickname, :limit => "20"

      t.timestamps null: false
    end
  end
end
