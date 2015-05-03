class CreateForumMangers < ActiveRecord::Migration
  def change
    create_table :forum_mangers do |t|
      t.references :author
      t.references :book_series

      t.timestamps null: false
    end
  end
end
