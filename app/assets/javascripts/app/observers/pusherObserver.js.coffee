class App.PusherObserver
  @subscribe: ->
    new App.PusherObserver()

  constructor: ->
    @pusher = new Pusher(Constants.pusher.key)
    @channel = @pusher.subscribe('global')

    @channel.bind('block', @createBlock)
    @channel.bind('tweet', @createTweet)

  createBlock: (data) =>
    console.debug "Server pushing block:", data
    App.Block.refresh([data])

  createTweet: (tweet) =>
    console.debug "Server pushed tweet:", tweet
