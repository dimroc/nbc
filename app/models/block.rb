class Block < ActiveRecord::Base
  BLOCK_TYPES = ["Block::Video"]

  set_rgeo_factory_for_column(:point, Mercator::FACTORY.projection_factory)

  belongs_to :zip_code_map
  belongs_to :neighborhood

  delegate :zip, to: :zip_code_map, allow_nil: true
  delegate :name, :borough, to: :neighborhood, allow_nil: true, prefix: true

  after_save :update_zip_code_callback, :update_neighborhood_callback

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
      point: {
        mercator: [point.x, point.y],
        geographic: [pg.x, pg.y]
      },
      zip_code: zip,
      neighborhood: neighborhood_name,
      borough: neighborhood_borough
    }
  end

  def update_zip_code!
    return unless self.point

    zip_code = ZipCodeMap.intersects(self.point).first
    update_column 'zip_code_map_id', zip_code.id if zip_code
  end

  def update_neighborhood!
    return unless self.point

    neighborhood = Neighborhood.intersects(self.point).first
    update_column 'neighborhood_id', neighborhood.id if neighborhood
  end

  private

  def update_zip_code_callback
    if self.point_changed? && self.point?
      self.update_zip_code!
    end
  end

  def update_neighborhood_callback
    if self.point_changed? && self.point?
      self.update_neighborhood!
    end
  end
end
