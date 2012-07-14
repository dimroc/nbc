window.Graphics ?= {}

window.Graphics = class Graphics
  @DEFAULT_OPTIONS: {
    width: 1000
    height: 600
  }

  constructor: (options)->
    options = $.extend(true, Graphics.DEFAULT_OPTIONS, options)

    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    @scene = new THREE.Scene()

    # Create camera
    @camera = new THREE.PerspectiveCamera( 75, options.width / options.height, 1, 10000 )
    @camera.position.z = 1000
    @scene.add( @camera )

    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize( options.width, options.height )

    if Env.development
      @stats = new Stats()
      document.body.appendChild(@stats.domElement)

  destroy: ->
    console.debug("Destroying graphics...")

    @destroyed = true
    $(@stats.domElement).remove() if @stats
    cancelAnimationFrame

  attachToDom: (domElement)->
    $(domElement).append(@renderer.domElement)
    @

  animate: =>
    @render()
    if @destroyed
      cancelAnimationFrame
      console.warn("Animating after destruction...")
    else
      requestAnimationFrame(@animate)

  render: ->
    @scene.children.forEach (child)->
      if child.geometry
        child.rotation.x += 0.01
        child.rotation.y += 0.02

    @renderer.render( @scene, @camera )
    @stats.update() if @stats
    @

  addCube: (block)->
    geometry = new THREE.CubeGeometry( 200*block.left, 200*block.top, 200 )
    material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } )

    mesh = new THREE.Mesh( geometry, material )
    @scene.add( mesh )
    @

  meshes: ->
    _.select(@scene.children, (child) -> return child.geometry)
