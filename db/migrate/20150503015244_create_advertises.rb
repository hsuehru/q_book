class CreateAdvertises < ActiveRecord::Migration
  def change
    create_table :advertises do |t|
      t.string :name
      t.text :url
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
