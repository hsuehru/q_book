class CreateCategoryItems < ActiveRecord::Migration
  def change
    create_table :category_items do |t|
      t.string :name, :null => false
      t.references :category

      t.timestamps null: false
    end
  end
end
