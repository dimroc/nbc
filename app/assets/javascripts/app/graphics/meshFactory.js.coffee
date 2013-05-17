class App.MeshFactory
  @loadRegionModel: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    loader = new THREE.JSONLoader()
    color = 0x000000
    material = new THREE.MeshBasicMaterial({color:color})
    material.wireframe = true if Env.boroughs == "wireframe"

    mesh = null
    loader.createModel(region.threejs.model, (geometry) ->
      mesh = new THREE.Mesh( geometry, material )
      mesh.name = "region-#{region.name}"
    )
    mesh

  @loadRegionOutlines: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    material = new THREE.LineBasicMaterial({color: 0x0000FF, linewidth: 1, opacity: 1})

    lineMeshes = for outline in region.threejs.outlines then do (outline) ->
      lineGeometry = new THREE.Geometry()

      xPoints = []
      yPoints = []
      xPoints.push point for point in outline by 2
      yPoints.push point for point in outline[1..] by 2

      points = _.zip(xPoints, yPoints)
      for point in points then do (point) ->
        lineGeometry.vertices.push(new THREE.Vector3(point[0], point[1], 0))

      new THREE.Line(lineGeometry, material)

  @generateBlock: (world, block) ->
    return null unless block

    if block.encoded()
      texture = THREE.ImageUtils.loadTexture(block.userPhotoProxy())
      currentMaterial = new THREE.MeshBasicMaterial({map: texture, opacity: 1})
    else
      currentMaterial = new THREE.MeshBasicMaterial({color: new THREE.Color(0xFF0000), opacity: 1})

    cubeGeom = new THREE.CubeGeometry(App.Block.WIDTH, App.Block.HEIGHT, App.Block.DEPTH)
    cubeMesh = new THREE.Mesh(cubeGeom, currentMaterial)
    cubeMesh.position = block.worldPosition(world)
    cubeMesh

  @generateFromGeoJson: (geoJson) ->
    # http://stackoverflow.com/questions/13442153/errors-extruding-shapes-with-three-js
    switch geoJson.type
      when "MultiPolygon" then MeshFactory.generateFromMultiPolygon(geoJson.coordinates)
      else throw "Cannot generate line from GeoJSON type #{geoJson.type}"

  @generateFromMultiPolygon: (coordinates) ->
    meshes = for polygon in coordinates
      App.MeshFactory.generateFromPolygon(polygon)
    _(meshes).flatten()

  @generateFromPolygon: (polygon) ->
    shape = new THREE.Shape(projectRing(polygon[0]))
    shape.holes = for hole in polygon.slice(1)
      new THREE.Shape(projectRing(hole))

    geom = new THREE.ExtrudeGeometry(shape, { amount: 1.5, bevelEnabled: false })
    new THREE.Mesh(geom, new THREE.MeshLambertMaterial({color: 0x00FF00}) )

projectRing = (ring) ->
  _(ring).map(projectPoint)

projectPoint = (coord) ->
  point = { x: coord[0], y: coord[1] }
  App.World.current().transformMercatorToWorld(point)
