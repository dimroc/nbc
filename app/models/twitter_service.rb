require 'uri'

class TwitterService
  ACCESS_TOKEN = ENV['TWITTER_TOKEN'] || "42443871-eIxDorQadnycbYJ2Uq6ZBCCtF0KDsowjYn1Uamk"
  SECRET = ENV['TWITTER_SECRET'] || "jbBvwl82wcmVu8VvFEsf3varRmVrc87iokM5CRVe5X0"

  attr_reader :api_connection, :stream_connection

  def initialize
    Excon.defaults[:ssl_verify_peer] = false
    @api_connection = Excon.new("https://api.twitter.com/")
    @stream_connection = Excon.new("https://stream.twitter.com/")
  end

  def stream_nyc
    stream_connection.get(
      path: "/1.1/statuses/filter.json",
      headers: headers,
      query: URI.encode_www_form(locations: "-74,40,-73,41"),
      response_block: method(:streamer))
  end

  def mentions
    api_connection.get(
      path: "/1.1/statuses/mentions_timeline.json",
      headers: headers,
      query: URI.encode_www_form(count: 2, since_id: 14927799))
  end

  private

  def headers
    {
      'Content-Type' => "application/x-www-form-urlencoded",
      'Authorization' =>
        %Q{OAuth oauth_consumer_key="NCCft7dTpzXWnjOjAft8Q", oauth_nonce="809c6257f309ee780a7dd9e6720e2e54", oauth_signature="f%2BoEBbd3mqENlm1dh2UtlpwH9C8%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1373082165", oauth_token="42443871-eIxDorQadnycbYJ2Uq6ZBCCtF0KDsowjYn1Uamk", oauth_version="1.0"}
    }
  end

  def streamer(chunk, remaining_bytes, total_bytes)
    puts chunk
  end
end
