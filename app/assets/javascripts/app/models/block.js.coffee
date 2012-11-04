class App.Block extends App.Model
  @HEIGHT = @WIDTH = 25
  @DEPTH = 100
  @GUTTER_LENGTH = 10

  @configure 'Block', 'id', 'region_id', 'bottom', 'left', 'point'
  @extend Spine.Model.Ajax

  @belongsTo "region", "App.Region"

  validate: ->
    @errors = {}
    @appendErrors(bottom: "bottom is required") unless @top
    @appendErrors(left: "left is required") unless @left
    @appendErrors(point: "point is required") unless @point

  color_key: ->
    if @region() then @region().slug else null

  color: ->
    App.ColorMap.fetch(@color_key())

  world_position: ->
    left = @left
    bottom = @bottom

    left += @region().left if @region()
    bottom += @region().bottom if @region()

    new THREE.Vector3(
      (App.Block.WIDTH + App.Block.GUTTER_LENGTH) * left,
      (App.Block.HEIGHT + App.Block.GUTTER_LENGTH) * bottom,
      0)
