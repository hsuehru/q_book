class CreatePublishCompanies < ActiveRecord::Migration
  def change
    create_table :publish_companies do |t|
      t.string :name, :limit => "50"
      t.text :address
      t.text :manager_sales_id_list
      t.text :sales_id_list
      t.text :author_id_list
      t.string :tel, :limit => "15"
      t.string :fax, :limit => "15"
      t.string :email, :limit => "100"

      t.timestamps null: false
    end
  end
end
