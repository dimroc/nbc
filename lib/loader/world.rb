class Loader::World
  class << self
    def generate(options)
      options = OpenStruct.new options
      options.shapefile = "lib/data/shapefiles/#{options.name.downcase}/region" unless options.shapefile
      options.tolerance = 25 unless options.tolerance

      world = from_shapefile(options.name, options.shapefile, options.region_name_key)
      generate_blocks(world, options.block_length)
      generate_outlines(world, 1/options.block_length.to_f, options.tolerance)
      world
    end

    def from_shapefile(name, shapefile, region_name_key="name")
      require 'rgeo/shapefile'

      world = World.new(name: name)
      factory = Mercator::FACTORY.projection_factory
      RGeo::Shapefile::Reader.open(shapefile, factory: factory) do |file|
        raise ArgumentError, "File contains no records" if file.num_records == 0

        file.each do |record|
          region_name = record.attributes[region_name_key.to_s] if region_name_key

          region = world.regions.build(name: region_name, geometry: record.geometry)
          populate_neighborhoods(region)
        end
      end

      world
    end

    def generate_blocks(world, block_length)
      world.blocks.clear
      generate_world_blocks_for_regions(world, block_length)
      calculate_region_positions(world)
      convert_world_blocks_to_region_blocks(world)
    end

    def generate_outlines(world, scale, tolerance)
      bb = world.generate_bounding_box
      offset = OpenStruct.new(x: -bb.min_x, y: -bb.min_y, z: 0)
      world.regions.each { |region| region.regenerate_threejs offset, scale, tolerance }
    end

    private

    def generate_world_blocks_for_regions(world, block_length)
      # Discretize world by stepping along the area block_length a time
      bb = world.generate_bounding_box
      bb.step(block_length) do |point, x, y|
        region = world.regions.detect { |region| region.contains? point }
        region.blocks.build(left: x, bottom: y, point: point) if region
      end
    end

    def convert_world_blocks_to_region_blocks(world)
      # Blocks will now be relative to the region
      world.regions.each do |region|
        region.blocks.each do |block|
          block.left -= region.left
          block.bottom -= region.bottom
        end
      end
    end

    def calculate_region_positions(world)
      world.regions.each { |region| region.regenerate_coordinates }
    end

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
