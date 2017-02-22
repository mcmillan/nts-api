class Station
  NTS_URL = 'https://www.nts.live'.freeze

  STREAM_URLS = {
    'one' => 'http://stream-relay-geo.ntslive.net/stream',
    'two' => 'http://stream-relay-geo.ntslive.net/stream2'
  }.freeze

  LISTING_PAGE_URLS = {
    'one' => '/schedule/listing_xhr/1?ajax=true&timezone=Europe%2FLondon',
    'two' => '/schedule/listing_xhr/2?ajax=true&timezone=Europe%2FLondon'
  }.freeze

  attr_reader :name

  def initialize(name:)
    @name = name
  end

  def stream_url
    @stream_url ||= URI.join(NTS_URL, STREAM_URLS.fetch(name))
  end

  def current_show
    shows.find(&:now?)
  end

  def to_json(*args)
    {
      name: name.upcase,
      show: current_show,
      streamUrl: stream_url
    }.to_json(*args)
  end

  private

  def listing_page_url
    @listing_page_url ||= URI.join(NTS_URL, LISTING_PAGE_URLS.fetch(name))
  end

  def listing_page_document
    @listing_page_document ||= Nokogiri::HTML.parse(
      HTTParty.get(listing_page_url).body
    )
  end

  def shows
    @shows ||= listing_page_document
               .css('.listing-container:first li.show')
               .map do |s|
                 from, to = s.css('.time').first.content.strip.split(' - ')
                 url = s.css('.title a').first['href']
                 title = s.css('.title').first.content.strip
                 Show.new(
                   from: from,
                   to: to,
                   url: URI.join(NTS_URL, url).to_s,
                   title: title
                 )
               end
  end
end
