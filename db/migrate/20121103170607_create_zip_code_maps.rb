class CreateZipCodeMaps < ActiveRecord::Migration
  def change
    create_table :zip_code_maps do |t|
      t.string :zip
      t.string :po_name
      t.string :county

      t.point :point, geographic: true
      t.geometry :geometry, geographic: true
      t.float :shape_length
      t.float :shape_area

      t.timestamps
    end

    add_index(:zip_code_maps, :zip)
    add_index(:zip_code_maps, :geometry)
  end
end
