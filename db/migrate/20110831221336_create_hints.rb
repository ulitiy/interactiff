class CreateHints < ActiveRecord::Migration
  def change
    create_table :hints do |t|
      t.text :body
      t.references :task
    end
    create_citier_view(Hint)
    add_index :hints, :task_id
  end
end
