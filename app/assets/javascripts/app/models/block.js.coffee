class App.Block extends App.Model
  @configure 'Block'
  @extend Spine.Model.Ajax

  @belongsTo "region", "App.Region"

  validate: ->
    @errors = {}
    @appendErrors(top: "top is required") unless @top
    @appendErrors(left: "left is required") unless @left
