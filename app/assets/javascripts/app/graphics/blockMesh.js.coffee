class App.BlockMesh extends THREE.Mesh
  HEIGHT = WIDTH = 50
  DEPTH = 5
  GUTTER_LENGTH = 20

  constructor: (block) ->
    geometry = new THREE.CubeGeometry(WIDTH, HEIGHT, DEPTH)
    material = new THREE.MeshLambertMaterial()

    super(geometry, material)

    left = block.left
    bottom = block.bottom

    left += block.region().left if block.region
    bottom += block.region().bottom if block.region

    @position.x = (WIDTH + GUTTER_LENGTH) * left
    @position.y = (HEIGHT + GUTTER_LENGTH) * bottom

  animate: ->
    @rotation.y += 0.02
