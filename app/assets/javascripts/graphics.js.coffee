window.Graphics ?= {}

window.Graphics = class Graphics
  @DEFAULT_OPTIONS: {
    width: 800
    height: 600
  }

  constructor: (options)->
    options = $.extend(true, Graphics.DEFAULT_OPTIONS, options)

    @scene = new THREE.Scene()

    # Create camera
    @camera = new THREE.PerspectiveCamera( 75, options.width / options.height, 1, 10000 )
    @camera.position.z = 1000
    @scene.add( @camera )

    # Create renderer
    @renderer = new THREE.CanvasRenderer()
    @renderer.setSize( options.width, options.height )

  attachToDom: (domElement)->
    $(domElement).append(@renderer.domElement)
    @

  animate: =>
    requestAnimationFrame( => @animate )
    @render()

  render: ->
    @scene.children.forEach (child)->
      if child.geometry
        child.rotation.x += 0.01
        child.rotation.y += 0.02

    console.log("Rendering scene...")
    @renderer.render( @scene, @camera )
    @

  addCube: (block)->
    geometry = new THREE.CubeGeometry( 200*block.left, 200*block.top, 200 )
    material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } )

    mesh = new THREE.Mesh( geometry, material )
    @scene.add( mesh )
    @

  meshes: ->
    _.select(@scene.children, (child) -> return child.geometry)
