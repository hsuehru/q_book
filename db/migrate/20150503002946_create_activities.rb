class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.text :book_table_isbn_list
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
