class Block < ActiveRecord::Base
  BLOCK_TYPES = ["Block::Video"]

  set_rgeo_factory_for_column(:point, Mercator::FACTORY.projection_factory)

  class << self
    def near(point)
      raise ArgumentError, "Point cannot be nil" unless point
      order(<<-SQL)
        ST_Distance('SRID=#{point.srid};#{point.as_text}', point) ASC
      SQL
    end
  end

  def as_json(options={})
    inclusion = { only: [:id] }

    super(options.merge(inclusion)).merge(point_as_json)
  end

  def point_geographic
    Mercator::FACTORY.unproject(self.point)
  end

  def point_as_json
    pg = point_geographic
    {
      point:
      {
        mercator: [point.x, point.y],
        geographic: [pg.x, pg.y]
      }
    }
  end
end
