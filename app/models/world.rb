class World < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :regions, dependent: :destroy
  has_many :blocks, through: :regions

  validates_presence_of :name
  validates_presence_of :slug

  class << self
    def build_from_shapefile(shapefile, mappings={"name" => "name"})
      require 'rgeo/shapefile'

      world = World.new
      factory = Mercator::FACTORY.projection_factory
      RGeo::Shapefile::Reader.open(shapefile, factory: factory) do |file|
        raise ArgumentError, "File contains no records" if file.num_records == 0

        file.each do |record|
          region_attributes = map_to_region_attributes(mappings, record.attributes)
          world.regions.build(region_attributes.merge(geometry: record.geometry))
        end
      end

      world
    end

    private

    def map_to_region_attributes(mappings, fields)
      attributes = {}
      fields.each do |(k, v)|
        map = mappings[k]
        attributes[map] = v if map
      end
      attributes
    end
  end

  def regenerate_blocks(block_length)
    blocks.clear
    generate_world_blocks_for_regions(block_length)
    calculate_region_positions
    convert_world_blocks_to_region_blocks
  end

  def generate_bounding_box
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    bounding_boxes = regions.each do |region|
      bb.add(region.generate_bounding_box)
    end
    bb
  end

  private

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
    regions.each do |region|
      region_bb = region.generate_bounding_box
      region.left = region_bb.min_x
      region.bottom = region_bb.min_y
    end
  end
end
