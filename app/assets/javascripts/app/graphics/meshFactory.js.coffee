class App.MeshFactory
  @load_region: (region) ->
    return new THREE.Geometry() unless Object.keys(region.threejs).length > 0

    loader = new THREE.JSONLoader()
    color = if region.current_block then 0xdd0000 else 0x000000
    material  = new THREE.MeshBasicMaterial({color:color})

    mesh = null
    loader.createModel(region.threejs, (geometry) ->
      mesh = new THREE.Mesh( geometry, material )
    )
    mesh

  @generate_blocks: (region) ->
    opacity = 1
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
