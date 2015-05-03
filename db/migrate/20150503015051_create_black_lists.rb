class CreateBlackLists < ActiveRecord::Migration
  def change
    create_table :black_lists do |t|
      t.integer :member_table_number
      t.integer :member_table_id
      t.references :book_series
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
