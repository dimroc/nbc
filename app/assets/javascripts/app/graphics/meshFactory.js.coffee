class App.MeshFactory
  @load_region_model: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    loader = new THREE.JSONLoader()
    color = if region.current_block then 0xdd0000 else 0x000000
    material  = new THREE.MeshBasicMaterial({color:color})

    mesh = null
    loader.createModel(region.threejs.model, (geometry) ->
      mesh = new THREE.Mesh( geometry, material )
    )
    mesh

  @load_region_outlines: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    material = new THREE.LineBasicMaterial({color: 0xffffff, linewidth: 2, opacity: 0.4})
    geometry = new THREE.Geometry()

    lineMeshes = for outline in region.threejs.outlines then do (outline) ->
      lineGeometry = new THREE.Geometry()

      x_points = []
      y_points = []
      x_points.push point for point in outline by 2
      y_points.push point for point in outline[1..] by 2

      points = _.zip(x_points, y_points)
      for point in points then do (point) ->
        lineGeometry.vertices.push(new THREE.Vector3(point[0], point[1], 0))

      new THREE.Line(lineGeometry, material)

  @generate_blocks: (region) ->
    opacity = 0.5
    cubeMaterial = new THREE.MeshLambertMaterial({color: 0xFFFFFF, opacity: opacity})
    currentMaterial = new THREE.MeshLambertMaterial({color: 0xAB1A25, opacity: opacity})
    regionMaterial = new THREE.MeshLambertMaterial({color: 0x009959, opacity: opacity})

    blockMaterial = (block) ->
      if block.id == block.region().current_block
        material = currentMaterial
      else if block.region().current_block
        material = regionMaterial
      else
        material = cubeMaterial

    # Create batched geometry
    geometry = new THREE.Geometry()

    _.each(region.blocks().all(), (block) ->
      cubeGeom = new THREE.CubeGeometry(
        App.Block.WIDTH, App.Block.HEIGHT, App.Block.DEPTH,
        1, 1, 1,
        blockMaterial(block))

      cubeMesh = new THREE.Mesh(cubeGeom)
      cubeMesh.position = block.worldPosition()
      THREE.GeometryUtils.merge(geometry, cubeMesh)
    )

    geometry.mergeVertices()
    new THREE.Mesh(geometry, new THREE.MeshFaceMaterial())
