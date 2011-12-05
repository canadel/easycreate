class CreateCnameRecords < ActiveRecord::Migration
  def change
    create_table :cname_records do |t|
      t.integer :inwx_domain_id
      t.string  :entry
      t.timestamps
    end
  end
end
