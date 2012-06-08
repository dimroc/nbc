class RegionGenerator
  class << self
    def generate(name, width, height)
      raise ArgumentError.new("name is required for region") unless name.present?
      region = Region.new(name: name)
      (0..width).each do |left|
        (0..height).each do |top|
          region.blocks << Block.new(left: left, top: top)
        end
      end

      region.save
      region
    end
  end
end
