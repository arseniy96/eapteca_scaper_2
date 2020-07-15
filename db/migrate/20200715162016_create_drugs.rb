class CreateDrugs < ActiveRecord::Migration[5.2]
  def change
    create_table :drugs do |t|
      t.string :name
      t.string :barcode
      t.string :vendor_code
      t.string :description_file
      t.string :substance
      t.string :form
      t.integer :num
      t.string :vendor
      t.string :composition
      t.string :shelf_life
      t.string :brand
      t.boolean :prescription
      t.string :pharm_effect
      t.string :indications
      t.string :contraindications
      t.string :side_effects
      t.string :interaction
      t.string :cours
      t.string :overdose
      t.string :special_instruction
      t.string :release_form
      t.string :storage
      t.string :pregnancy

      t.timestamps
    end
  end
end
