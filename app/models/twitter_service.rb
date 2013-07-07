require 'uri'

class TwitterService
  OAUTH_TOKEN =  ENV['TWITTER_OAUTH_TOKEN'] || "42443871-eIxDorQadnycbYJ2Uq6ZBCCtF0KDsowjYn1Uamk"
  OAUTH_SECRET = ENV['TWITTER_OAUTH_SECRET'] || "jbBvwl82wcmVu8VvFEsf3varRmVrc87iokM5CRVe5X0"

  CONSUMER_KEY = ENV["TWITTER_CONSUMER_KEY"] || "NCCft7dTpzXWnjOjAft8Q"
  CONSUMER_SECRET = ENV["TWITTER_CONSUMER_SECRET"] || "7O4Hvxx7CUg0Hyl0GVs83gXbxUs8GmG4wJXERzg5c"

  def stream_nyc
    path = "https://stream.twitter.com/1.1/statuses/filter.json"
    query = { locations: "-74.3,40.462,-73.65,40.95" }

    streamer = Proc.new { |chunk| yield JSON.parse(chunk) }

    Excon.get(
      path,
      headers: headers(path, query),
      query: URI.encode_www_form(query),
      response_block: streamer)
  end

  private

  def headers(path, query)
    {
      'Content-Type' => "application/x-www-form-urlencoded",
      'Authorization' => oauth_header(path, query)
    }
  end

  def oauth_header(path, query)
    options = {
      consumer_key: CONSUMER_KEY,
      consumer_secret: CONSUMER_SECRET,
      token: OAUTH_TOKEN,
      token_secret: OAUTH_SECRET,
    }

    SimpleOAuth::Header.new(:get, path, query, options)
  end
end
