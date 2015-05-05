class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :email, :limit => "100"
      t.string :password, :limit => "50"
      t.string :first_name, :limit => "100"
      t.string :last_name, :limit => "100"
      t.string :nickname, :limit => "20"
      t.references :administrator_type
      t.boolean :active
      t.string :web_session_id

      t.timestamps null: false
    end
  end
end

