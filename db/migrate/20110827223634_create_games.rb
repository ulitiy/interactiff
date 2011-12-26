class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.text :description
      t.references :domain
    end
    create_citier_view(Game)
    add_index :games, :domain_id
  end
end
