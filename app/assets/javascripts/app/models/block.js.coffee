class App.Block extends App.Model
  @HEIGHT = @WIDTH = 0.6
  @DEPTH = 0.1
  @GUTTER_LENGTH = .4
  @OFFSET = new THREE.Vector3(0, 0, 0)

  @configure 'Block', 'id', 'region_id', 'point'
  @extend Spine.Model.Ajax
  @url: "#{Constants.apiBasePath}/blocks"

  validate: ->
    @errors = {}
    @appendErrors(point: "point is required") unless @point

  encoded: ->
    @video && @video.url? && @video.url.length > 0

  worldPosition: (world) ->
    mercatorPoint = new THREE.Vector2(@point.mercator[0], @point.mercator[1])
    world.transformMercatorToWorld(mercatorPoint)

  mesh: (world) ->
    App.MeshFactory.generateBlock(world, @)
