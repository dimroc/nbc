class World < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :regions, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :slug

  class << self
    def build_from_shapefile(shapefile, mappings={"name" => "name"})
      require 'rgeo/shapefile'

      world = World.new
      RGeo::Shapefile::Reader.open(shapefile) do |file|
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

  def generate_blocks(block_length)
    assign_regions_relative_coordinates(block_length)
    regions.each do |region|
      region.generate_blocks(block_length)
    end
    regions.flat_map(&:blocks)
  end

  def generated_bounding_box
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    bounding_boxes = regions.each do |region|
      bb.add(region.generated_bounding_box)
    end
    bb
  end

  private

  def assign_regions_relative_coordinates(block_length)
    # Post process each region's left/bottom coordinates relative to the whole world
    bb = generated_bounding_box
    regions.each do |region|
      region_bb = region.generated_bounding_box

      bb.step(block_length) do |point, x, y|
        if region_bb.contains? point
          region.left = x
          region.bottom = y
          break
        end
      end
    end
  end
end
