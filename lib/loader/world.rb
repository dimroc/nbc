class Loader::World
  class << self
    def from_yml!(path, specific_world=nil)
      yaml = YAML::load(File.open(path))

      if specific_world
        configurations = yaml["worlds"].select do |config|
          config["name"].downcase == specific_world.downcase.gsub('_', ' ').gsub('-', ' ')
        end

        raise ArgumentError, "No worlds named #{specific_world}" if configurations.empty?
      else
        configurations = yaml["worlds"]
      end

      configurations.each do |config|
        name = config["name"].titleize

        puts "Generating #{name}..."
        world = generate(config)
        World.find_by_slug(name.downcase.gsub(' ','-')).try(:destroy) # Destroy old
        world.save!
      end
    end

    def generate(options)
      options = OpenStruct.new options
      options.shapefile = "lib/data/shapefiles/#{options.name.downcase.gsub(' ', '_')}/region" unless options.shapefile
      options.tolerance = 25 unless options.tolerance

      world = from_shapefile(options.name, options.shapefile, options.region_name_key)
      generate_outlines(world, 1/options.inverse_scale.to_f, options.tolerance)

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

    def generate_outlines(world, scale, tolerance)
      bb = world.generate_bounding_box
      offset = Hashie::Mash.new(x: -bb.min_x, y: -bb.min_y, z: 0)
      world.regions.each do |region|
        Loader::Region.generate_threejs(region, offset, scale, tolerance)
      end
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
