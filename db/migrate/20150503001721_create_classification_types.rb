class CreateClassificationTypes < ActiveRecord::Migration
  def change
    create_table :classification_types do |t|
      t.string :name, :limit => "5"
      t.text :warning

      t.timestamps null: false
    end
  end
end
