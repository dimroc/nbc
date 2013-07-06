namespace :twitter do
  desc "Stream tweets from nyc to connected clients"
  task :stream => :environment do
    batch = []
    TwitterService.new.stream_nyc do |tweet|
      print '.'

      response = TweetPresenter.new(tweet)
      PusherService.push_tweet(response.to_json)
      batch << response

      if batch.size >= 10
        PusherService.push_tweets(batch)
        batch.clear
        print 'S'
      end
    end
  end
end
