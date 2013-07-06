namespace :twitter do
  desc "Stream tweets from nyc to connected clients"
  task :stream => :environment do
    TwitterService.new.stream_nyc do |tweet|
      print '.'
      PusherService.push_tweet(tweet)
    end
  end
end
