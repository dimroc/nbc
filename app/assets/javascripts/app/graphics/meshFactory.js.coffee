class App.MeshFactory
  @create_region: (region) ->
    geometry = new THREE.Geometry()

    _.each(region.blocks().all(), (block) ->
      cubeGeom = new THREE.CubeGeometry(
        App.Block.WIDTH, App.Block.HEIGHT, App.Block.DEPTH,
        1, 1, 1,
        blockMaterial(block))

      cubeMesh = new THREE.Mesh(cubeGeom)
      cubeMesh.position = block.world_position()
      THREE.GeometryUtils.merge(geometry, cubeMesh)
    )

    geometry.mergeVertices()
    new THREE.Mesh(geometry, new THREE.MeshFaceMaterial())


cubeMaterial = new THREE.MeshLambertMaterial({color: 0x111111})
currentMaterial = new THREE.MeshLambertMaterial({color: 0xAB1A25})
regionMaterial = new THREE.MeshLambertMaterial({color: 0x009959})

blockMaterial = (block) ->
  if block.id == block.region().current_block
    material = currentMaterial
  else if block.region().current_block
    material = regionMaterial
  else
    material = cubeMaterial
