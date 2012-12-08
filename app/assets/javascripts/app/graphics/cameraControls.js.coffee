class App.CameraControls
  constructor: (camera, domElement) ->
    THREE.EventTarget.call(@)

    @camera = camera
    @domElement = (if (domElement isnt `undefined`) then domElement else document)
    @projector = new THREE.Projector()
    @mouseRayLine = @generateLineForMouseRay()
    @cameraHelper = new THREE.CameraHelper(@camera)

    @enabled = true
    @screen = width: 0, height: 0

    @zoomSpeed = 2.0
    @panSpeed = .3

    @staticMoving = false
    @dynamicDampingFactor = 0.2
    @minDistance = 5.0
    @maxDistance = 300.0

    @eye = new THREE.Vector3(0, 0, 100)
    @target = new THREE.Vector3()

    @zoomStart = @zoomEnd = 0.0
    @panStart = new THREE.Vector2()
    @panEnd = new THREE.Vector2()

    @domElement.addEventListener "mousemove", @mousemove, false
    @domElement.addEventListener "mousedown", @mousedown, false
    @domElement.addEventListener "mousewheel", @mousewheel, false
    @domElement.addEventListener "DOMMouseScroll", @mousewheel, false # firefox
    @handleResize()

  addDebugMeshesToScene: (scene) ->
    scene.add(@mouseRayLine)
    scene.add(@cameraHelper)

  mousedown: (event) =>
    return unless @enabled
    event.preventDefault()
    event.stopPropagation()

    @panning = true
    @panStart = @panEnd = @getMouseOnScreen(event.clientX, event.clientY)
    document.body.style.cursor = 'move'
    @domElement.addEventListener "mouseup", @mouseup, false

  mousemove: (event) =>
    return  unless @enabled
    @mouseOnScreen = @getMouseOnScreen(event.clientX, event.clientY)
    @mouseRay = @getMouseRay()
    @panEnd = @getMouseOnScreen(event.clientX, event.clientY)

  mouseup: (event) =>
    return  unless @enabled
    event.preventDefault()
    event.stopPropagation()
    document.body.style.cursor = 'default'
    @domElement.removeEventListener "mouseup", @mouseup
    @panning = false

  mousewheel: (event) =>
    return  unless @enabled
    event.preventDefault()
    event.stopPropagation()
    delta = 0
    if event.wheelDelta # WebKit / Opera / Explorer 9
      delta = event.wheelDelta / 40
    # Firefox
    else delta = -event.detail / 3  if event.detail

    if delta > 0
      @zoomStart += 0.05
    else
      @zoomStart -= 0.05

  handleResize: =>
    @screen.width = window.innerWidth
    @screen.height = window.innerHeight

    @camera.aspect = window.innerWidth / window.innerHeight
    @camera.lookAt(@target)
    @camera.updateProjectionMatrix()

  handleEvent: (event) =>
    this[event.type] event if typeof this[event.type] is "function"

  getMouseOnScreen: (clientX, clientY) =>
    new THREE.Vector2(clientX / @screen.width, clientY / @screen.height)

  getMouseRay: ->
    if @mouseOnScreen?
      # Convert to screen space coordinates (-1 -> 1 instead of 0 -> 1)
      screenSpaceMouse = @mouseOnScreen.clone().multiplyScalar(2)
      screenSpaceMouse.x -= 1
      screenSpaceMouse.y -= 1
      screenSpaceMouse.y *= -1

      # Convert mouse position into a ray pointing into world space
      @projector.pickingRay(screenSpaceMouse, @camera)

  generateLineForMouseRay: ->
    material = new THREE.LineBasicMaterial({color: 0xFF0000, linewidth: 3})
    geometry = new THREE.Geometry()
    geometry.vertices.push(new THREE.Vector3())
    geometry.vertices.push(new THREE.Vector3())
    new THREE.Line(geometry, material)

  updateMouseRayLine: ->
    if @mouseRayLine? and @mouseRay?
      ray = @mouseRay
      @mouseRayLine.geometry.vertices[0].copy ray.origin

      destination = new THREE.Vector3().add(ray.origin, ray.direction.clone().multiplyScalar(300))
      @mouseRayLine.geometry.vertices[1].copy destination
      @mouseRayLine.geometry.verticesNeedUpdate = true

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
    @updateMouseRayLine()
    @cameraHelper.update()
