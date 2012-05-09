class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :type
      t.string :title
      #t.string :comment
      t.integer :x
      t.integer :y
      t.references :parent
      t.references :game
      t.references :task

      t.timestamps
    end
    add_index :blocks, :parent_id
    add_index :blocks, :game_id
    add_index :blocks, :task_id
  end
end
