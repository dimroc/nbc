class App.Block extends App.Model
  @configure 'Block', 'id', 'region_id', 'bottom', 'left', 'point'
  @extend Spine.Model.Ajax

  @belongsTo "region", "App.Region"

  validate: ->
    @errors = {}
    @appendErrors(bottom: "bottom is required") unless @top
    @appendErrors(left: "left is required") unless @left
    @appendErrors(point: "point is required") unless @point
