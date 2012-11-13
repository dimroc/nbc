class Neighborhood < ActiveRecord::Base
  validates_presence_of :name, :borough, :point

  class << self
    def for_region(region)
      find_by_sql(<<-SQL)
      SELECT n.* AS result FROM neighborhoods n, regions r WHERE
        ST_Contains(
          ST_GeomFromEWKB(r.geometry),
          ST_GeomFromEWKB(n.point))
        AND r.id = #{region.id}
      SQL
    end
  end
end
