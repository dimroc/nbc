window.Graphics.BlockMesh = class BlockMesh extends THREE.Mesh
  constructor: (block) ->
    @block = block
    geometry = new THREE.CubeGeometry( 200*block.left, 200*block.top, 200 )
    material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } )

    super(geometry, material)

  animate: ->
    @rotation.x += 0.01
    @rotation.y += 0.02
