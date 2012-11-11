class ZipCodeMap < ActiveRecord::Base
  set_rgeo_factory_for_column(:point, Mercator::FACTORY.projection_factory)

  class << self
    def build_from_socrata(socrata_row)
      shape = Socrata::Shape.new(socrata_row[9])
      zip_code_map = ZipCodeMap.new(
        zip: socrata_row[10],
        po_name: socrata_row[11],
        county: socrata_row[13],
        point: shape.point.projection,
        geometry: shape.geometry.projection,
        shape_length: socrata_row[17],
        shape_area: socrata_row[18])

        zip_code_map.id = socrata_row[0]
        zip_code_map
    end
  end

  def point_geographic
    Mercator.to_geographic self.point
  end
end
