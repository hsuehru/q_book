class CreateBookSeries < ActiveRecord::Migration
  def change
    create_table :book_series do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
