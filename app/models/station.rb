class Station
  STREAM_URLS = {
    'one' => 'http://stream-relay-geo.ntslive.net/stream',
    'two' => 'http://stream-relay-geo.ntslive.net/stream2'
  }.freeze

  SCHEDULE_PAGE_URLS = {
    'one' => 'https://www.nts.live/schedule',
    'two' => 'https://www.nts.live/schedule/2'
  }.freeze

  attr_reader :station_name, :episode_name, :episode_description,
              :location_short, :location_long, :image_url

  def initialize(name, info)
    @station_name = name
    @episode_name = info['episode_name']
    @location_short = info['location_short']
    @location_long = info['location_long']
    extract_schedule_page_data
  end

  def stream_url
    STREAM_URLS[station_name]
  end

  def schedule_page_url
    SCHEDULE_PAGE_URLS[station_name]
  end

  def to_json(*args)
    {
      name: station_name,
      episode: {
        name: episode_name,
        description: episode_description,
        imageUrl: image_url
      },
      location: {
        short: location_short,
        long: location_long
      },
      streamUrl: stream_url,
      schedulePageUrl: schedule_page_url
    }.to_json(*args)
  end

  private

  def extract_schedule_page_data
    doc = Nokogiri::HTML(HTTParty.get(schedule_page_url).body)
    @episode_name = doc.css('.bio .bio__title').first.content.strip
    @episode_description = doc.css('.bio .description').first.content.strip
    @image_url = doc.css('#bg').first['style'].match(/url\((.*)\)/)[1]
  rescue
    @image_url = '' # TODO: Make this a placeholder
    @episode_description = 'N/A'
  end
end
