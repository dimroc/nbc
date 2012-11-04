class CreateZipCodeMaps < ActiveRecord::Migration
  def change
    create_table :zip_code_maps do |t|
      t.string :zip
      t.string :po_name
      t.string :county

      t.point :point
      t.geometry :geometry
      t.float :shape_length
      t.float :shape_area

      t.timestamps
    end

    add_index(:zip_code_maps, :zip)
  end
end
