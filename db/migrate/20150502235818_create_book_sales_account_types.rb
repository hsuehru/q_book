class CreateBookSalesAccountTypes < ActiveRecord::Migration
  def change
    create_table :book_sales_account_types do |t|
      t.string :name, :limit => "20"

      t.timestamps null: false
    end
  end
end
