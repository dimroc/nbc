class App.Block extends App.Model
  @configure 'Block', 'id', 'region_id', 'top', 'left'
  @extend Spine.Model.Ajax

  @belongsTo "region", "App.Region"

  validate: ->
    @errors = {}
    @appendErrors(top: "top is required") unless @top
    @appendErrors(left: "left is required") unless @left
