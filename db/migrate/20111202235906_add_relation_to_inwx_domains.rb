class AddRelationToInwxDomains < ActiveRecord::Migration
  def change
    add_column :inwx_domains, :user_id, :integer
  end
end