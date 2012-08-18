class AddGeometryToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :geometry, :geometry
  end
end
