class PusherService
  class << self
    def push_block(block)
      with_error_handling do
        Pusher.trigger('global', 'block', block.as_json)
      end
    end

    def push_tweet(tweet)
      with_error_handling do
        Pusher.trigger('global', 'tweet', tweet)
      end
    end

    def push_tweets(tweets)
      with_error_handling do
        Pusher.trigger('global', 'tweets', tweets)
      end
    end

    def initialized?
      Pusher.app_id && Pusher.key && Pusher.secret
    end

    private

    # Contingency method as defined in exceptional ruby
    def with_error_handling
      if initialized?
        yield
      else
        Rails.logger.warn "Pusher is uninitialized!"
      end
    rescue Pusher::Error => e
      Rails.logger.warn "Unable to push to clients\n#{e.message}"
    end
  end
end
