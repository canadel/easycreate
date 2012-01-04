class AddIdToRecordTables < ActiveRecord::Migration
  def self.up
    add_column :a_records, :inwx_id, :integer
    add_column :cname_records, :inwx_id, :integer
  end

  def self.down
    remove_column :cname_records, :inwx_id
    remove_column :a_records, :inwx_id
  end
end