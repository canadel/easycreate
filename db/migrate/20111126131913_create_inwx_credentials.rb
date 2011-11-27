class CreateInwxCredentials < ActiveRecord::Migration
  def change
    create_table :inwx_credentials do |t|
      t.string  :username
      t.string  :password
      t.timestamps
    end
  end
end
