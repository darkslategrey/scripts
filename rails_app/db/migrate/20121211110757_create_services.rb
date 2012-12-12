class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :code
      t.string :libelle

      t.timestamps
    end
  end
end
