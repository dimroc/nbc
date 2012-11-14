class Neighborhood < ActiveRecord::Base
  validates_presence_of :name, :borough, :point

  class << self
    def in_geometry(geometry)
      where(<<-SQL)
        ST_Contains(
          ST_GeomFromText('#{geometry.as_text}',#{geometry.srid}),
          ST_GeomFromEWKB(point))
      SQL
    end
  end
end
