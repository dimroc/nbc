RGeo::Cartesian::BoundingBox.class_eval do
  def step(step)
    (min_x..max_x).step(step) do |x|
      (min_y..max_y).step(step) do |y|
        yield Cartesian.preferred_factory().point(x,y)
      end
    end
  end
end
