class Loader::Neighborhood
  class << self
    def from_shapefile(shapefile)
      require 'rgeo/shapefile'

      factory = Mercator::FACTORY.projection_factory
      RGeo::Shapefile::Reader.open(shapefile, factory: factory) do |file|
        raise ArgumentError, "File contains no records" if file.num_records == 0

        file.each do |record|
          Neighborhood.create!(name: record["NTAName"],
                               borough: record["BoroName"],
                               geometry: record.geometry)

        end
      end
    end

    def populate_neighbors
      Neighborhood.find_each do |neighborhood|
        neighborhood.neighbors.clear
        neighborhood.neighbors << neighborhood.neighborhoods_with_intersecting_geometry
      end
    end

    def write_json
      puts "Writing neighborhoods.json"

      directory = "public/static/"
      FileUtils.mkdir_p directory
      output_file = "#{directory}neighborhoods.json"

      File.open(output_file, "w") do |file|
        file.write Neighborhood.all.to_json
      end
    end

    def write_building_perimeters_json
      directory = "public/static/neighborhoods/"
      FileUtils.mkdir_p directory

      Neighborhood.find_each do |neighborhood|
        output_file = "#{directory}#{neighborhood.slug}.json"
        puts "Writing building perimeters: #{output_file}"

        File.open(output_file, "w") do |file|
          file.write neighborhood.building_perimeters_json
        end
      end
    end
  end
end
