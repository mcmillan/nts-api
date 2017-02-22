class LiveInformationService
  NOW_PLAYING_URL = 'https://www.nts.live/schedule/nowPlaying'.freeze

  def self.stations(now_playing_url = NOW_PLAYING_URL)
    new(now_playing_url).stations
  end

  def initialize(now_playing_url = NOW_PLAYING_URL)
    @now_playing_url = now_playing_url
  end

  def stations
    HTTParty
      .get(NOW_PLAYING_URL, 'User-Agent' => 'github.com/mcmillan/nts-api')
      .parsed_response
      .map { |k, v| Station.new(k, v['now']) }
  end
end
