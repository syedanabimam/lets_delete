class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.datetime :deleted_at
      t.references :list, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
