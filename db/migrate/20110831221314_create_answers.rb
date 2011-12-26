class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :body
      t.references :task
    end
    create_citier_view(Answer)
    add_index :answers, :task_id
  end
end
