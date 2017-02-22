require 'sinatra'
require 'httparty'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'

NOW_PLAYING_URL = 'https://www.nts.live/schedule/nowPlaying'.freeze
STREAM_URLS = {
  'one' => 'http://stream-relay-geo.ntslive.net/stream',
  'two' => 'http://stream-relay-geo.ntslive.net/stream2'
}.freeze

before do
  expires 120, :public, :must_revalidate
end

get '/api/live' do
  stations = HTTParty
             .get(NOW_PLAYING_URL, 'User-Agent' => 'github.com/mcmillan/nts-api')
             .parsed_response
             .deep_transform_keys { |k| k.camelize(:lower) }
             .map { |k, v| v.merge(name: k, streamUrl: STREAM_URLS.fetch(k)) }

  content_type :json
  { stations: stations }.to_json
end
