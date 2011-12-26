class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.integer :main_host_id
    end
    create_citier_view(Domain)
    add_index :domains, :main_host_id
  end
end
