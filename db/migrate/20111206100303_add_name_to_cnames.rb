class AddNameToCnames < ActiveRecord::Migration
  def change
    add_column :cname_records, :name, :string
  end
end