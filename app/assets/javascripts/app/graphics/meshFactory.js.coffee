class App.MeshFactory
  @create_world: (world) ->
    geometry = new THREE.Geometry()

    _.each(world.allBlocks(), (block) ->
      geometry.vertices.push(block.world_position())
    )

    material = new THREE.ParticleBasicMaterial(
      color: App.ColorMap.fetch(null),
      size: 50
    )

    material.color.setHSV(0,0,0)

    new THREE.ParticleSystem(geometry, material)
