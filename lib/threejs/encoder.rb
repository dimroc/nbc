class THREEJS::Encoder
  class << self
    def from_geometry(geometry)
      return nil unless geometry
      ring = coerce_to_exterior_ring(geometry)
      triangles = triangulate_ring(ring)
      create_model_from_triangles(triangles)
    end

    private

    def create_model_from_triangles(triangles)
      model = template

      triangles.each_with_index do |triangle, triangle_index|
        # example triangle: [[-8, 4], [-8, 5], [-4, 4]]

        triangle.each_with_index do |point, point_index|
          index = point_index * 3 + triangle_index * 9
          model[:vertices].push(point[0], point[1], 0)
        end

        index = triangle_index * 3
        # mark face type as triangle with 0
        model[:faces].push(0, index, index + 1, index + 2)
      end

      model
    end

    def coerce_to_exterior_ring(geometry)
      geometry = geometry.respond_to?(:geometry_n) ? geometry[0] : geometry
      geometry.exterior_ring
    end

    # Crashes if there are any repeated points!
    # Shouldn't be possible with shapefile geometries of NYC
    def triangulate_ring(ring)
      input = ring.points.map { |point| [point.x, point.y] }
      input.pop if input.first == input.last
      cdt = Poly2Tri::CDT.new(input)
      cdt.triangulate!
      cdt.triangles
    end

    def template
      {
        metadata: { formatVersion: 3 },

        materials: [],
        vertices:  [],
        normals:   [],
        colors:    [],
        uvs:       [],
        faces:     []
      }
    end
  end
end
