class App.PusherObserver
  @subscribe: ->
    new App.PusherObserver()

  constructor: ->
    @pusher = new Pusher(Constants.pusher.key)
    @channel = @pusher.subscribe('global')

    @channel.bind('tweets', @createTweets)
    #@channel.bind('tweet', @createTweet)
    @channel.bind('block', @createBlock)

  createBlock: (data) =>
    console.debug "Server pushing block:", data
    App.Block.refresh([data])

  createTweet: (tweet) =>
    console.debug "Server pushed tweet:", tweet

  createTweets: (tweets) =>
    console.debug "Server pushed tweets:", tweets
    worldPositions = for tweet in tweets
      ll =
        lon: tweet.coordinates.coordinates[0],
        lat: tweet.coordinates.coordinates[1]

      App.World.current().transformLonLatToWorld(ll)

    console.debug "World locations:", worldPositions
    App.WorldRenderer.instance().setTweets(worldPositions)
