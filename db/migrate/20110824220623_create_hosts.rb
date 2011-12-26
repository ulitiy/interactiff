class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :name
      t.references :domain
      t.references :main_host

      t.timestamps
    end

    add_index :hosts, :domain_id
    add_index :hosts, :main_host_id
  end
end
