class CreateBookSalesAccounts < ActiveRecord::Migration
  def change
    create_table :book_sales_accounts do |t|
      t.string :email, :limit => "100", :unique => true, :null => false
      t.string :password_digest, :limit => "100"
      t.string :first_name, :limit => "100"
      t.string :last_name, :limit => "100"
      t.string :nickname, :limit => "20"
      t.date :birthday
      t.text :publish_id_list
      t.references :book_sales_account_type
      t.boolean :active, :default => true
      t.string :web_session_id

      t.timestamps null: false
    end
    add_index :book_sales_accounts, [:email]
  end
end
