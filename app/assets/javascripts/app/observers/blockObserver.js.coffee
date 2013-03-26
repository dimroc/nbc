class App.BlockObserver extends Spine.Module
  @extend Spine.Events

  constructor: ->
    App.Block.bind('selected', @handleSelection)

  handleSelection: (selectedBlock) ->
    console.log "selected block:", selectedBlock

singleton = new App.BlockObserver()
