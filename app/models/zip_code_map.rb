class ZipCodeMap < ActiveRecord::Base
  set_rgeo_factory_for_column(:point, Mercator::FACTORY.projection_factory)

  def point_geographic
    Mercator.to_geographic self.point
  end
end
