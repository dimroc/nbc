class AddGeometryToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :geometry, :geometry, geographic: true
    add_index :regions, :geometry, spatial: true
  end
end
