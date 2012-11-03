class ZipCodeMap < ActiveRecord::Base
  class << self
    def build_from_socrata(socrata_row)
      shape = Socrata::Shape.new(socrata_row[9])
      zip_code_map = ZipCodeMap.new(
        zip: socrata_row[10],
        po_name: socrata_row[11],
        county: socrata_row[13],
        point: shape.point,
        geometry: shape.geometry,
        shape_length: socrata_row[17],
        shape_area: socrata_row[18])

        zip_code_map.id = socrata_row[0]
        zip_code_map
    end
  end
end
