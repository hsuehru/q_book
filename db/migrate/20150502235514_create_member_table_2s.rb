class CreateMemberTable2s < ActiveRecord::Migration
  def change
    create_table :member_table_2s do |t|
      t.string :email, :limit => "100", :unique => true, :null => false
      t.string :password_digest, :limit => "100", :null => false
      t.string :first_name, :limit => "100"
      t.string :last_name, :limit => "100"
      t.string :nickname, :limit => "20"
      t.date :birthday
      t.boolean :gender
      t.boolean :active, :default => true
      t.string :web_session_id, :unique => true
      t.string :phone_session_id, :unique => true
      t.text :favorite_list
      t.boolean :read_message, :default => false
      t.datetime :read_message_date
      t.string :table_number,:limit => "2" , :default => 2

      t.timestamps null: false
    end
      add_index :member_table_2s, [:email]
  end
end
