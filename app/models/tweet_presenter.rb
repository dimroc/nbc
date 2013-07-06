class TweetPresenter
  attr_accessor :tweet

  def initialize(tweet)
    @tweet = tweet
  end

  def as_json(options = {})
    {
      coordinates: tweet["coordinates"],
      created_at: tweet["created_at"],
      text: tweet["text"]
    }
  end

  def to_json
    as_json.to_json
  end
end
