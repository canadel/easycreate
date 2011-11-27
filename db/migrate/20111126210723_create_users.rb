class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :username
      t.timestamps
    end
    add_column :inwx_credentials, :user_id, :integer
  end
end