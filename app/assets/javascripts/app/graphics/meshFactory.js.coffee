class App.MeshFactory
  @loadRegionModel: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    loader = new THREE.JSONLoader()
    color = 0x000000
    material  = new THREE.MeshBasicMaterial({color:color})

    mesh = null
    loader.createModel(region.threejs.model, (geometry) ->
      mesh = new THREE.Mesh( geometry, material )
      mesh.name = "region-#{region.name}"
    )
    mesh

  @loadRegionOutlines: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    material = new THREE.LineBasicMaterial({color: 0xffffff, linewidth: 2, opacity: 1})

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

  @generate_block: (block) ->
    return null unless block
    currentMaterial = new THREE.MeshBasicMaterial({color: new THREE.Color(0xFF0000), opacity: 1})
    cubeGeom = new THREE.CubeGeometry(App.Block.WIDTH, App.Block.HEIGHT, App.Block.DEPTH)
    cubeMesh = new THREE.Mesh(cubeGeom, currentMaterial)
    cubeMesh.position = block.worldPosition()
    cubeMesh

  @generateBlocks: (region) ->
    opacity = 0.8
    currentMaterial = new THREE.MeshLambertMaterial({color: new THREE.Color(0xAB1A25), opacity: opacity})
    cubeMaterial = new THREE.MeshLambertMaterial({color: new THREE.Color(0xFFFFFF), opacity: opacity})
    regionMaterial = new THREE.MeshLambertMaterial({color: new THREE.Color(0x009959), opacity: opacity})

    blockMaterialIndex = (block) ->
      if block.id == block.region().current_block
        0
      else if block.region().current_block
        1
      else
        2

    # Create batched geometry
    geometry = new THREE.Geometry()

    _.each(region.blocks().all(), (block) ->
      cubeGeom = new THREE.CubeGeometry(App.Block.WIDTH, App.Block.HEIGHT, App.Block.DEPTH)
      assignMaterialIndexToFaces(cubeGeom, blockMaterialIndex(block))

      cubeMesh = new THREE.Mesh(cubeGeom)
      cubeMesh.position = block.worldPosition()
      THREE.GeometryUtils.merge(geometry, cubeMesh)
    )

    geometry.mergeVertices()
    faceMaterial = new THREE.MeshFaceMaterial([currentMaterial, regionMaterial, cubeMaterial])

    batchedBlocks = new THREE.Mesh(geometry, faceMaterial)
    batchedBlocks.name = "blocks-region-#{region.name}"
    batchedBlocks

assignMaterialIndexToFaces = (geometry, materialIndex) ->
  face.materialIndex = materialIndex for face in geometry.faces
