class App.MeshFactory
  @loadRegionModel: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    loader = new THREE.JSONLoader()
    color = 0x000000
    material = new THREE.MeshBasicMaterial({color:color})
    material.wireframe = true if Env.wireframe

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
      texture = THREE.ImageUtils.loadTexture(block.userPhoto(), {})
      currentMaterial = new THREE.MeshBasicMaterial({map: texture, opacity: 1})
    else
      currentMaterial = new THREE.MeshBasicMaterial({color: new THREE.Color(0xFF0000), opacity: 1})

    cubeGeom = new THREE.CubeGeometry(App.Block.WIDTH, App.Block.HEIGHT, App.Block.DEPTH)
    cubeMesh = new THREE.Mesh(cubeGeom, currentMaterial)
    cubeMesh.position = block.worldPosition(world)
    cubeMesh

  @generateFromGeoJson: (geoJson) ->
    switch geoJson.type
      when "MultiPolygon" then MeshFactory.generateLinesFromMultiPolygon(geoJson.coordinates)
      else throw "Cannot generate line from GeoJSON type #{geoJson.type}"

  @generateLinesFromMultiPolygon: (coordinates) ->
    # I'm assuming there's only one polygon for now...
    lines = for polygon in coordinates
      App.MeshFactory.generateLinesFromPolygon(polygon)
    _(lines).flatten()

  @generateLinesFromPolygon: (polygon) ->
    material = new THREE.LineBasicMaterial({color: 0x00FF00, linewidth: 1, opacity: 1})

    for ring in polygon
      lineGeometry = new THREE.Geometry()
      for point in ring
        lineGeometry.vertices.push(projectPoint(point))

      new THREE.Line(lineGeometry, material)

projectPoint = (coord) ->
  point = { x: coord[0], y: coord[1] }
  App.World.current().transformMercatorToWorld(point)
