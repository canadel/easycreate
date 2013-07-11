class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :label
      t.string :description
      t.string :thumbnail
      t.integer :position

      t.timestamps
    end
  end
end
