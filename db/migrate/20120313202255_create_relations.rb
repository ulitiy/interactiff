class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.references :to
      t.references :from
      t.timestamps
      t.references :game
    end
    add_index :relations, :from_id
    add_index :relations, :to_id
    add_index :relations, :game_id
  end
end
