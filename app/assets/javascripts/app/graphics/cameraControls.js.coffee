###
Inspired by the TrackballControl from
@author Eberhard Graether / http://egraether.com/
###
class App.CameraControls
  STATE =
    NONE: -1
    ROTATE: 0
    ZOOM: 1
    PAN: 2

  constructor: (object, domElement) ->
    THREE.EventTarget.call(@)

    @object = object
    @domElement = (if (domElement isnt `undefined`) then domElement else document)
    @enabled = true
    @screen =
      width: 0
      height: 0
      offsetLeft: 0
      offsetTop: 0

    @radius = (@screen.width + @screen.height) / 4
    @rotateSpeed = 1.0
    @zoomSpeed = 0.02
    @panSpeed = 0.3

    @noRotate = false
    @noZoom = false
    @noPan = false

    @staticMoving = false
    @dynamicDampingFactor = 0.2
    @minDistance = 25.0
    @maxDistance = 220.0

    @keys = [65, 83, 68] # A, S, D

    @target = new THREE.Vector3()

    @lastPosition = new THREE.Vector3()
    @state = STATE.PAN
    @eye = new THREE.Vector3()
    @rotateStart = new THREE.Vector3()
    @rotateEnd = new THREE.Vector3()
    @zoomStart = new THREE.Vector2()
    @zoomEnd = new THREE.Vector2()
    @panStart = new THREE.Vector2()
    @panEnd = new THREE.Vector2()

    @changeEvent = type: "change"

    @domElement.addEventListener "mousedown", @mousedown, false
    @domElement.addEventListener "mousewheel", @mousewheel, false
    @domElement.addEventListener "DOMMouseScroll", @mousewheel, false # firefox
    window.addEventListener "keydown", @keydown, false
    window.addEventListener "keyup", @keyup, false
    @handleResize()

  keydown: (event) =>
    return unless @enabled

  keyup: (event) =>
    return  unless @enabled

  mousedown: (event) =>
    return  unless @enabled
    event.preventDefault()
    event.stopPropagation()

    @panStart = @panEnd = @getMouseOnScreen(event.clientX, event.clientY)  if @state is STATE.PAN and not @noPan
    document.addEventListener "mousemove", @mousemove, false
    document.addEventListener "mouseup", @mouseup, false

  mousemove: (event) =>
    return  unless @enabled
    @panEnd = @getMouseOnScreen(event.clientX, event.clientY)  if @state is STATE.PAN and not @noPan

  mouseup: (event) =>
    return  unless @enabled
    event.preventDefault()
    event.stopPropagation()
    document.removeEventListener "mousemove", @mousemove
    document.removeEventListener "mouseup", @mouseup

  mousewheel: (event) =>
    return  unless @enabled
    event.preventDefault()
    event.stopPropagation()
    delta = 0
    if event.wheelDelta # WebKit / Opera / Explorer 9
      delta = event.wheelDelta / 40
    # Firefox
    else delta = -event.detail / 3  if event.detail
    @zoomStart.y += (1 / delta) * 0.05

  handleResize: =>
    @screen.width = window.innerWidth
    @screen.offsetTop = 0
    @radius = (@screen.width + @screen.height) / 4

  handleEvent: (event) =>
    this[event.type] event  if typeof this[event.type] is "function"

  getMouseOnScreen: (clientX, clientY) =>
    new THREE.Vector2((clientX - @screen.offsetLeft) / @radius * 0.5, (clientY - @screen.offsetTop) / @radius * 0.5)

  getMouseProjectionOnBall: (clientX, clientY) =>
    mouseOnBall = new THREE.Vector3((clientX - @screen.width * 0.5 - @screen.offsetLeft) / @radius, (@screen.height * 0.5 + @screen.offsetTop - clientY) / @radius, 0.0)
    length = mouseOnBall.length()
    if length > 1.0
      mouseOnBall.normalize()
    else
      mouseOnBall.z = Math.sqrt(1.0 - length * length)
    @eye.copy(@object.position).subSelf @target
    projection = @object.up.clone().setLength(mouseOnBall.y)
    projection.addSelf @object.up.clone().crossSelf(@eye).setLength(mouseOnBall.x)
    projection.addSelf @eye.setLength(mouseOnBall.z)
    projection

  rotateCamera: ->
    angle = Math.acos(@rotateStart.dot(@rotateEnd) / @rotateStart.length() / @rotateEnd.length())
    if angle
      axis = (new THREE.Vector3()).cross(@rotateStart, @rotateEnd).normalize()
      quaternion = new THREE.Quaternion()
      angle *= @rotateSpeed
      quaternion.setFromAxisAngle axis, -angle
      quaternion.multiplyVector3 @eye
      quaternion.multiplyVector3 @object.up
      quaternion.multiplyVector3 @rotateEnd
      if @staticMoving
        @rotateStart.copy @rotateEnd
      else
        quaternion.setFromAxisAngle axis, angle * (@dynamicDampingFactor - 1.0)
        quaternion.multiplyVector3 @rotateStart

  zoomCamera: ->
    factor = 1.0 + (@zoomEnd.y - @zoomStart.y) * @zoomSpeed
    if factor isnt 1.0 and factor > 0.0
      @eye.multiplyScalar factor
      if @staticMoving
        @zoomStart.copy @zoomEnd
      else
        @zoomStart.y += (@zoomEnd.y - @zoomStart.y) * @dynamicDampingFactor

  panCamera: ->
    mouseChange = @panEnd.clone().subSelf(@panStart)
    if mouseChange.lengthSq()
      mouseChange.multiplyScalar @eye.length() * @panSpeed
      pan = @eye.clone().crossSelf(@object.up).setLength(mouseChange.x)
      pan.addSelf @object.up.clone().setLength(mouseChange.y)
      @object.position.addSelf pan
      @target.addSelf pan
      if @staticMoving
        @panStart = @panEnd
      else
        @panStart.addSelf mouseChange.sub(@panEnd, @panStart).multiplyScalar(@dynamicDampingFactor)

  checkDistances: ->
    if not @noZoom or not @noPan
      @object.position.setLength @maxDistance  if @object.position.lengthSq() > @maxDistance * @maxDistance
      @object.position.add @target, @eye.setLength(@minDistance)  if @eye.lengthSq() < @minDistance * @minDistance

  update: ->
    @eye.copy(@object.position).subSelf @target
    @rotateCamera()  unless @noRotate
    @zoomCamera()  unless @noZoom
    @panCamera()  unless @noPan
    @object.position.add @target, @eye
    @checkDistances()
    @object.lookAt @target
    if @lastPosition.distanceToSquared(@object.position) > 0
      @dispatchEvent @changeEvent
      @lastPosition.copy @object.position

