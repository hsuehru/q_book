class CreateReportTable1s < ActiveRecord::Migration
  def change
    create_table :report_table_1s do |t|
      t.integer :report_from
      t.integer :report_to
      t.integer :post_table_number
      t.integer :post_table_id
      t.integer :reply_table_number
      t.integer :reply_table_id
      t.text :reason

      t.timestamps null: false
    end
  end
end
