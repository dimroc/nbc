class App.BlockPusherObserver
  constructor: ->
    @pusher = new Pusher(Constants.pusher.key)
    @channel = @pusher.subscribe('global')
    @channel.bind('newBlock', @createBlock)

  createBlock: (data) =>
    App.Block.create data

class App.PusherObserver
  @subscribe: ->
    new App.BlockPusherObserver()
