class CreateARecords < ActiveRecord::Migration
  def change
    create_table :a_records do |t|
      t.integer :inwx_domain_id
      t.string  :entry
      t.timestamps
    end
  end
end
