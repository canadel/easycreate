class CreateInwxDomains < ActiveRecord::Migration
  def change
    create_table :inwx_domains do |t|
      t.string  :domain
      t.timestamps
    end
  end
end
