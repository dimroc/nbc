class App.BlockMesh extends THREE.Mesh
  HEIGHT = WIDTH = 50
  DEPTH = 5
  GUTTER_LENGTH = 20

  constructor: (block) ->
    geometry = new THREE.CubeGeometry(WIDTH, HEIGHT, DEPTH)
    material = new THREE.MeshLambertMaterial()

    super(geometry, material)
    @position.x = (WIDTH + GUTTER_LENGTH) * block.left
    @position.y = (HEIGHT + GUTTER_LENGTH) * block.bottom

  animate: ->
    @rotation.y += 0.02
