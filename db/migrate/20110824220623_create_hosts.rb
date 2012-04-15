class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :name
    end
    create_citier_view(Host)
  end
end
