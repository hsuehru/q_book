class CreateMemberRatingTable1s < ActiveRecord::Migration
  def change
    create_table :member_rating_table_1s do |t|
      t.string :book_isbn, :limit => "13"
      t.integer :member_table_number
      t.integer :member_table_id
      t.integer :rating

      t.timestamps null: false
    end
  end
end
