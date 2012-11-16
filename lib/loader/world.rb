class Loader::World
  class << self
    def from_shapefile(shapefile, mappings={"name" => "name"})
      require 'rgeo/shapefile'

      world = World.new
      factory = Mercator::FACTORY.projection_factory
      RGeo::Shapefile::Reader.open(shapefile, factory: factory) do |file|
        raise ArgumentError, "File contains no records" if file.num_records == 0

        file.each do |record|
          region_attributes = map_shapefile_attrs_to_region_attrs(mappings, record.attributes)
          attrs = region_attributes.merge(geometry: record.geometry)

          region = world.regions.build(attrs)
          region.regenerate_threejs
          populate_neighborhoods(region)
        end
      end

      world
    end

    private

    def map_shapefile_attrs_to_region_attrs(mappings, fields)
      attributes = {}
      fields.each do |(k, v)|
        map = mappings[k]
        attributes[map] = v if map
      end
      attributes
    end

    def populate_neighborhoods(region)
      return unless region.geometry
      region.neighborhoods = Neighborhood.in_geometry(region.geometry)
    end
  end
end
