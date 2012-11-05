class Block < ActiveRecord::Base
  belongs_to :region

  validates_presence_of :left
  validates_presence_of :bottom

  set_rgeo_factory_for_column(:point, Mercator::FACTORY.projection_factory)

  def as_json(options={})
    super({ except: [:point, :created_at, :updated_at] }.merge(options))
  end

  def point_geographic
    Mercator::FACTORY.unproject(self.point)
  end
end
