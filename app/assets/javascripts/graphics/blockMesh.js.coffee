window.Graphics.BlockMesh = class BlockMesh extends THREE.Mesh
  HEIGHT = WIDTH = 50
  DEPTH = 10
  GUTTER_LENGTH = 20

  constructor: (block) ->
    @block = block
    geometry = new THREE.CubeGeometry(WIDTH, HEIGHT, DEPTH)
    material = new THREE.MeshLambertMaterial()

    super(geometry, material)
    @position.x = (WIDTH + GUTTER_LENGTH) * block.left
    @position.y = (HEIGHT + GUTTER_LENGTH) * -block.top

  animate: ->
    @rotation.x += 0.01
    @rotation.y += 0.01
