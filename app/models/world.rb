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
    regions.each do |region|
      region.generate_blocks(block_length)
    end
    regions.flat_map(&:blocks)
  end
end
