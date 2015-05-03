class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :member_table_number
      t.integer :member_table_id

      t.timestamps null: false
    end
  end
end
