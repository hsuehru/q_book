class CreateMemberTable1s < ActiveRecord::Migration
  def change
    create_table :member_table_1s do |t|
      t.string :email, :limit => "100"
      t.string :password, :limit => "50"
      t.string :first_name, :limit => "100"
      t.string :last_name, :limit => "100"
      t.string :nickname, :limit => "20"
      t.date :birthday
      t.boolean :gender
      t.boolean :active
      t.string :web_session_id
      t.string :phone_session_id
      t.text :favorite_list
      t.boolean :read_message
      t.datetime :read_message_date

      t.timestamps null: false
    end
  end
end

