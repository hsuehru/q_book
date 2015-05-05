class CreateAuthorRequireJoinPublishes < ActiveRecord::Migration
  def change
    create_table :author_require_join_publishes do |t|
      t.references :author
      t.references :publish_company
      t.boolean :confirm, :default => "-1"

      t.timestamps null: false
    end
  end
end
