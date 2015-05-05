class CreateBookSeries < ActiveRecord::Migration
  def change
    create_table :book_series do |t|
      t.string :name
      t.references :publish_company
      t.text :author_id_list

      t.timestamps null: false
    end
  end
end
