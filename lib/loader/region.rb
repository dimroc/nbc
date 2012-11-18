class Loader::Region
  class << self
    def generate_blocks(region, block_length)
      raise ArgumentError, "block_length is required" unless block_length

      region.blocks.clear
      bb = region.generate_bounding_box

      bb.step(block_length) do |point, x, y|
        if region.geometry.contains? point
          region.blocks.build(left: x, bottom: y, point: point)
        end
      end if !bb.empty? && block_length
      region.blocks
    end

    def generate_coordinates(region)
      region.left = region.furthest_left
      region.bottom = region.furthest_bottom
    end

    def generate_threejs(region, offset, scale, tolerance)
      simple_geometry = region.simplify_geometry(tolerance)
      if simple_geometry
        threejs = THREEJS::Encoder.from_geometry(simple_geometry)
        threejs = THREEJS::Encoder.offset(threejs, offset, scale)
        region.threejs = threejs
      end
    end
  end
end
