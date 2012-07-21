require 'geo_ruby'
require 'geo_ruby/shp'

class ShapefileHelper
  extend GeoRuby::SimpleFeatures
  extend GeoRuby::Shp4r

  class << self
    def generate(shapefile="tmp/generated_shapefile")
      shpfile = ShpFile.create(shapefile,
                               ShpType::POLYGON,
                               [Dbf::Field.new("Name","C",10)])

      shpfile.transaction do |tr|
        polygon = Polygon.from_coordinates([[[0,0],[0,10],[10,10],[10,0]]])
        tr.add(ShpRecord.new(polygon, "Name" => "Generated Square"))
      end

      shpfile.close
    end
  end
end
