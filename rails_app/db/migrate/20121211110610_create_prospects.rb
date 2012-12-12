class CreateProspects < ActiveRecord::Migration
  def change
    create_table :prospects do |t|
      t.string :name
      t.text :addr
      t.string :tel
      t.string :fax
      t.string :mail
      t.string :url
      t.integer :srvc_code
      t.string :srvc_name
      t.string :contact
      t.string :departement

      t.timestamps
    end
  end
end
