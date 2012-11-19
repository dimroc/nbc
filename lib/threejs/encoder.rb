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

    def offset(threejs, offset, scale=1/700.0)
      threejs = Marshal.load(Marshal.dump(threejs))
      vertices = threejs[:vertices]

      vertices = vertices.map { |coordinate| coordinate * scale }

      threejs[:vertices] = []
      vertices.each_with_index do |coordinate, index|
        if index % 3 == 0 # X COORDINATE
          threejs[:vertices] << coordinate + (offset.x ? offset.x * scale : 0)
        elsif (index-1) % 3 == 0 # Y COORDINATE
          threejs[:vertices] << coordinate + (offset.y ? offset.y * scale : 0)
        else
          threejs[:vertices] << coordinate + (offset.z ? offset.z * scale : 0)
        end
      end

      threejs
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

      exterior = ring.points.map { |point| [point.x, point.y] }
      exterior.pop if exterior.first == exterior.last

      cdt = Poly2Tri::CDT.new(exterior)

      points_so_far = exterior.clone
      geometry.interior_rings.each do |ring|
        interior = ring.points.map { |point| [point.x, point.y] }
        interior.pop if interior.first == interior.last

        cdt.add_hole(interior) if all_are_unique_points(points_so_far, interior)
        points_so_far.concat interior
      end

      cdt.triangulate!
      cdt.triangles
    end

    def all_are_unique_points(points1, points2)
      x1 = points1.values_at(*points1.each_index.select { |p| p.even? })
      x2 = points2.values_at(*points2.each_index.select { |p| p.even? })

      y1 = points1.values_at(*points1.each_index.select { |p| p.odd? })
      y2 = points2.values_at(*points2.each_index.select { |p| p.odd? })

      (x1 & x2).empty? && (y1 & y2).empty?
      (points1 & points2).empty?
    end

    def template
      {
        metadata: { formatVersion: 3.1, generatedBy: "NewBlockCity" },

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
