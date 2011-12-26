class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :type
      t.integer :x
      t.integer :y
      t.references :parent

      t.timestamps
    end
    add_index :blocks, :parent_id
  end
end
