class Loader::World
  class << self
    def from_shapefile(shapefile, mappings={"name" => "name"})
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
end
