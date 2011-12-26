class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :comment
      t.integer :weight
      t.references :game
    end
    create_citier_view(Task)
    add_index :tasks, :game_id
  end
end
