class Neighborhood < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  validates_presence_of :name, :borough, :geometry, :slug

  class << self
    def intersects(geom)
      raise ArgumentError, "Must have SRID 3785" unless geom.srid == 3785

      where(<<-SQL, geom.as_text)
        ST_Intersects(ST_AsText(neighborhoods.geometry), ?)
      SQL
      #where(<<-SQL)
        #ST_Contains(
          #ST_GeomFromText('#{geometry.as_text}',#{geometry.srid}),
          #point)
      #SQL
    end
  end
end
