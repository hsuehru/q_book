class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :email, :limit => "100", :unique => true, :null => false
      t.string :password_digest, :limit => "100", :null => false
      t.string :first_name, :limit => "100"
      t.string :last_name, :limit => "100"
      t.string :nickname, :limit => "20"
      t.references :administrator_type, :null => false
      t.boolean :active, :default => true
      t.string :web_session_id

      t.timestamps null: false
    end
      add_index :administrators, [:email]
  end
end

