class App.MeshFactory
  @create_region: (region) ->
    load_threejs(region)

load_threejs = (region) ->
  return new THREE.Geometry() unless Object.keys(region.threejs).length > 0

  loader = new THREE.JSONLoader()
  color = App.ColorMap.fetch(region.name)
  mesh = null
  loader.createModel(region.threejs, (geometry) ->
    mesh = new THREE.Mesh( geometry, new THREE.MeshBasicMaterial({color:color, side: THREE.DoubleSide}) )
  )
  mesh

generate_blocks = (region) ->
  cubeMaterial = new THREE.MeshLambertMaterial({color: 0xFFFFFF})
  currentMaterial = new THREE.MeshLambertMaterial({color: 0xAB1A25})
  regionMaterial = new THREE.MeshLambertMaterial({color: 0x009959})

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

