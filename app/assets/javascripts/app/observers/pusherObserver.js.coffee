class App.BlockPusherObserver
  constructor: ->
    @pusher = new Pusher(Constants.pusher.key)
    @channel = @pusher.subscribe('global')
    @channel.bind('block', @createBlock)

  createBlock: (data) =>
    console.debug "Server pushing block:", data
    if App.Block.exists(data.id)
      App.Block.refresh([data])
    else
      App.Block.create data

class App.PusherObserver
  @subscribe: ->
    new App.BlockPusherObserver()
