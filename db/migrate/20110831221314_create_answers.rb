class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :body
    end
    create_citier_view(Answer)
  end
end
