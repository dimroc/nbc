class App.MeshFactory
  @create_world: (world) ->
    geometry = new THREE.Geometry()
    cubeMaterial = new THREE.MeshLambertMaterial({color: 0x111111})

    _.each(world.allBlocks(), (block) ->
      cubeGeom = new THREE.CubeGeometry(
        App.Block.WIDTH, App.Block.HEIGHT, App.Block.DEPTH,
        1, 1, 1,
        cubeMaterial)

      cubeMesh = new THREE.Mesh(cubeGeom)
      cubeMesh.position = block.world_position()
      THREE.GeometryUtils.merge(geometry, cubeMesh)
    )

    geometry.mergeVertices()
    THREE.GeometryUtils.center(geometry)
    new THREE.Mesh(geometry, new THREE.MeshFaceMaterial())
