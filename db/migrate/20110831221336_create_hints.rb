class CreateHints < ActiveRecord::Migration
  def change
    create_table :hints do |t|
      t.text :body
    end
    create_citier_view(Hint)
  end
end
