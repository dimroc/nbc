class AddPointToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :point, :point
  end
end
