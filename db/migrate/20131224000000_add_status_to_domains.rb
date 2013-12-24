class AddStatusToDomains < ActiveRecord::Migration
  def change
    add_column :inwx_domains, :status, :boolean, :default => false, :null => false
    add_column :inwx_domains, :nameservers, :boolean, :default => false, :null => false
  end
end
