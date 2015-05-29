class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :email, :limit => "100", :unique => true, :null => false
      t.string :password_digest, :limit => "100"
      t.string :first_name, :limit => "100"
      t.string :last_name, :limit => "100"
      t.string :nickname, :limit => "20"
      t.date :birthday
      t.boolean :gender
      t.text :book_table_isbn_list
      t.boolean :active, :default => true
      t.string :web_session_id, :unique => true

      t.timestamps null: false
    end
      add_index :authors, [:email]
  end
end

