class THREEJS::Encoder
  class << self
    def from_geometry(geometry)
      return nil unless geometry

      models = coerce_to_geometries(geometry).map do |geometry|
        triangles = triangulate(geometry)
        create_model_from_triangles(triangles)
      end

      converge_models(models)
    end

    private

    def converge_models(models)
      final = template

      models.each do |model|
        current_vertex_offset = final[:vertices].count / 3

        final[:faces].concat offset_faces(model[:faces], current_vertex_offset)
        final[:vertices].concat model[:vertices]
      end
      final
    end

    def offset_faces(faces, offset)
      amended_faces = []
      faces.each_with_index do |face, index|
        # Skip over shape identifier, which is every 4th entry starting at 0
        if index % 4 == 0
          amended_faces << face
        else
          amended_faces << face + offset
        end
      end

      amended_faces
    end

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

    def coerce_to_geometries(geometry)
      # Handle multipolygons as well as polygons
      geometries = geometry.respond_to?(:geometry_n) ? geometry : [geometry]
      geometries
    end

    # Crashes if there are any repeated points!
    # Shouldn't be possible with shapefile geometries of NYC
    def triangulate(geometry)
      ring = geometry.exterior_ring

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
