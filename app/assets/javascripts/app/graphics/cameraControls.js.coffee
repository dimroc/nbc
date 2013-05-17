# TODO: Break up class into two parts:
# Camera and Mouse (I/O)
class App.CameraControls extends Spine.Module
  @extend Spine.Events

  constructor: (camera, domElement) ->
    THREE.EventTarget.call(@)

    @camera = camera
    @domElement = (if (domElement isnt `undefined`) then domElement else document)
    @projector = new THREE.Projector()

    @enabled = true
    @screen = width: 0, height: 0

    @zoomSpeed = 2.0
    @panSpeed = .3

    @staticMoving = false
    @dynamicDampingFactor = 0.2
    @minDistance = 5.0
    @maxDistance = 300.0

    @eye = @camera.position.clone()
    @target = new THREE.Vector3(@eye.x, @eye.y, 0)

    @zoomStart = @zoomEnd = 0.0
    @panStart = new THREE.Vector2()
    @panEnd = new THREE.Vector2()

    $(@domElement).bind("mousemove", @mousemove)
    $(@domElement).bind("mousedown", @mousedown)
    $(@domElement).bind("mousewheel", @mousewheel)
    @handleResize()

  destroy: ->
    $(@domElement).unbind()

  mousedown: (event) =>
    return unless @enabled
    @mouseIsDown = true

    @panStart = @panEnd = @_getMouseOnScreen(event.clientX, event.clientY)
    document.body.style.cursor = 'move'
    $(@domElement).bind("mouseup", @mouseup)
    false

  mousemove: (event) =>
    return unless @enabled
    @panning = true if @mouseIsDown

    @mouseOnHtmlScreen = @_getMouseOnScreen(event.clientX, event.clientY)
    @panEnd = @mouseOnHtmlScreen.clone()

    # Convert to screen space coordinates (-1 -> 1 instead of 0 -> 1)
    @mouseOnScreen = @mouseOnHtmlScreen.clone().multiplyScalar(2)
    @mouseOnScreen.x -= 1
    @mouseOnScreen.y -= 1
    @mouseOnScreen.y *= -1

    @mouseRay = @_getMouseRay()
    @mouseOnSurface = @_getMouseOnSurface()

  mouseup: (event) =>
    return unless @enabled
    document.body.style.cursor = 'default'
    $(@domElement).unbind("mouseup", @mouseup)

    wasPanning = @panning
    @panning = false
    @mouseIsDown = false

    App.CameraControls.trigger('selectPoint', @mouseOnSurface) unless wasPanning
    false

  mousewheel: (event) =>
    return unless @enabled

    wheelDelta = event.originalEvent.wheelDelta
    delta = wheelDelta / 40

    if delta > 0
      @zoomStart += 0.05
    else
      @zoomStart -= 0.05
    false

  handleResize: =>
    @screen.width = window.innerWidth
    @screen.height = window.innerHeight

    @camera.aspect = window.innerWidth / window.innerHeight
    @camera.lookAt(@target)
    @camera.updateProjectionMatrix()

  handleEvent: (event) =>
    this[event.type] event if typeof this[event.type] is "function"

  _getMouseOnScreen: (clientX, clientY) =>
    new THREE.Vector2(clientX / @screen.width, clientY / @screen.height)

  _getMouseRay: ->
    if @mouseOnScreen?
      # Convert mouse position into a ray pointing into world space
      @projector.pickingRay(@mouseOnScreen.clone(), @camera)

  _getMouseOnSurface: ->
    if @mouseRay?
      ray = @mouseRay
      magnitudeUntilSurface = -ray.origin.z / ray.direction.z
      new THREE.Vector3().add(ray.origin, ray.direction.clone().multiplyScalar(magnitudeUntilSurface))

  mouseToMercator: (world) ->
    if @mouseOnSurface?
      world.transformSurfaceToMercator(@mouseOnSurface)

  mouseToLonLat: (world) ->
    if @mouseOnSurface?
      world.transformSurfaceToLonLat(@mouseOnSurface)

  zoomCamera: ->
    factor = (@zoomEnd - @zoomStart) * -@zoomSpeed
    if factor > 0.001 or factor < -0.001
      if @mouseRay?
        ray = @mouseRay
      else
        ray = new THREE.Ray()
        ray.direction.z = -1

      # Handle z coordinate
      offset = ray.direction.clone().multiplyScalar(factor * 10)
      @eye.z += offset.z

      if @withinZoomDistances()
        # Handle X/Y Coordinate
        pan = @eye.clone().crossSelf(@camera.up).setLength(-offset.x)
        pan.addSelf @camera.up.clone().setLength(offset.y)
        pan.z = 0
        @camera.position.addSelf pan
        @target.addSelf pan

      if @staticMoving
        @zoomStart = @zoomEnd
      else
        @zoomStart += (@zoomEnd - @zoomStart) * @dynamicDampingFactor

  panCamera: ->
    mouseChange = @panEnd.clone().subSelf(@panStart)
    if mouseChange.lengthSq()
      mouseChange.multiplyScalar @eye.length() * @panSpeed
      pan = @eye.clone().crossSelf(@camera.up).setLength(mouseChange.x)
      pan.addSelf @camera.up.clone().setLength(mouseChange.y)
      @camera.position.addSelf pan
      @target.addSelf pan
      if @staticMoving
        @panStart = @panEnd
      else
        @panStart.addSelf mouseChange.sub(@panEnd, @panStart).multiplyScalar(@dynamicDampingFactor)

  withinZoomDistances: ->
    if @eye.z > @maxDistance
      @eye.z = @maxDistance
      false
    else if @eye.z < @minDistance
      @eye.z = @minDistance
      false
    else
      true

  update: ->
    @eye.copy(@camera.position).subSelf @target
    @zoomCamera()
    @panCamera() if @panning
    @camera.position.add @target, @eye
    @camera.lookAt @target
