class Block < ActiveRecord::Base
  belongs_to :region
  delegate :world, to: :region, allow_nil: true

  set_rgeo_factory_for_column(:point, Mercator::FACTORY.projection_factory)

  class << self
    def near(point)
      raise ArgumentError, "Point cannot be nil" unless point
      order(<<-SQL)
        ST_Distance('SRID=#{point.srid};#{point.as_text}', point) ASC
      SQL
    end
  end

  def point_geographic
    Mercator::FACTORY.unproject(self.point)
  end
end
