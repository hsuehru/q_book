class CreateAdministratorTypes < ActiveRecord::Migration
  def change
    create_table :administrator_types do |t|
      t.string :name, :limit => "20"
      
      t.timestamps null: false
    end
  end
end
