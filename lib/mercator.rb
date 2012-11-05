# reference: http://www.daniel-azuma.com/blog/archives/164
class Mercator
  SRID = 3785

  # Create a simple mercator factory. This factory itself is
  # geographic (latitude-longitude) but it also contains a
  # companion projection factory that uses EPSG 3785.
  FACTORY = RGeo::Geographic.simple_mercator_factory

  class << self
    def to_geographic(geometry)
      FACTORY.unproject geometry
    end

    def to_projected(geometry)
      FACTORY.project geometry
    end
  end
end
