class AddPointToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :point, :point, geographic: true
    add_index :blocks, :point, spatial: true
  end
end
