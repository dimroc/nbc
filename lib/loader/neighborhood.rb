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

    def write_building_perimeters_to_file
      directory = "public/static/neighborhoods/"
      FileUtils.mkdir_p directory

      Neighborhood.find_each do |neighborhood|
        output_file = "#{directory}#{neighborhood.slug}.json"
        puts "Writing #{output_file}..."

        File.open(output_file, "w") do |file|
          file.write neighborhood.building_perimeters_json
        end
      end
    end
  end
end
