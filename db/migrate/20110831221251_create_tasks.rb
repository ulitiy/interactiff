class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
    end
    create_citier_view(Task)
  end
end
