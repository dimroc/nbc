class World < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :regions, dependent: :destroy
  has_many :blocks, through: :regions

  validates_presence_of :name
  validates_presence_of :slug

  def regenerate_blocks(block_length)
    blocks.clear
    generate_world_blocks_for_regions(block_length)
    calculate_region_positions
    convert_world_blocks_to_region_blocks
    generate_region_outline
  end

  def generate_bounding_box
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    bounding_boxes = regions.each do |region|
      bb.add(region.generate_bounding_box)
    end
    bb
  end

  private

  def generate_region_outline
    bb = generate_bounding_box
    offset = OpenStruct.new(x: -bb.min_x, y: -bb.min_y, z: 0)
    regions.each { |region| region.regenerate_threejs offset }
  end

  def generate_world_blocks_for_regions(block_length)
    # Discretize world by stepping along the area block_length a time
    bb = generate_bounding_box
    bb.step(block_length) do |point, x, y|
      region = regions.detect { |region| region.contains? point }
      region.blocks.build(left: x, bottom: y, point: point) if region
    end
  end

  def convert_world_blocks_to_region_blocks
    # Blocks will now be relative to the region
    regions.each do |region|
      region.blocks.each do |block|
        block.left -= region.left
        block.bottom -= region.bottom
      end
    end
  end

  def calculate_region_positions
    regions.each { |region| region.regenerate_coordinates }
  end
end
