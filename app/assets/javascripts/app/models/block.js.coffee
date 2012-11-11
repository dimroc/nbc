class App.Block extends App.Model
  @HEIGHT = @WIDTH = 1.5
  @DEPTH = 2
  @GUTTER_LENGTH = .05
  @OFFSET = new THREE.Vector3(-70, -30, 0)

  @configure 'Block', 'id', 'region_id', 'bottom', 'left', 'point'
  @extend Spine.Model.Ajax

  @belongsTo "region", "App.Region"

  validate: ->
    @errors = {}
    @appendErrors(bottom: "bottom is required") unless @top
    @appendErrors(left: "left is required") unless @left
    @appendErrors(point: "point is required") unless @point

  colorKey: ->
    if @region() then @region().slug else null

  color: ->
    App.ColorMap.fetch(@colorKey())

  worldPosition: ->
    left = @left
    bottom = @bottom

    left += @region().left if @region()
    bottom += @region().bottom if @region()

    original = new THREE.Vector3(
      (App.Block.WIDTH + App.Block.GUTTER_LENGTH) * left,
      (App.Block.HEIGHT + App.Block.GUTTER_LENGTH) * bottom,
      0)
    original.addSelf(Block.OFFSET)
