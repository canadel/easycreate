class UpdateARecordTable < ActiveRecord::Migration
  def self.up
    add_column :a_records, :name, :string
  end

  def self.down
    remove_column :a_records, :name
  end
end