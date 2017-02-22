class Show
  attr_reader :url

  def initialize(from:, to:, url:, title:)
    @from = from
    @to = to
    @url = url
    @title = title
  end

  def now?
    DateTime.now.between?(from, to)
  end

  def to_json(*args)
    {
      title: title,
      description: description,
      location: location,
      url: url,
      imageUrl: image_url
    }.to_json(*args)
  end

  def from
    hour, minute = split_time(@from)
    datetime_from_hour_and_minute(hour, minute)
  end

  def to
    hour, minute = split_time(@to)
    second = 0
    if hour.zero?
      hour = 23
      minute = 59
      second = 59
    end
    datetime_from_hour_and_minute(hour, minute, second)
  end

  def title
    document.css('.bio .bio__title h1').first.content.strip
  rescue
    @title
  end

  def location
    document.css('.bio .bio__title h2').first.content.strip
  rescue
    nil
  end

  def image_url
    document.css('#bg').first['style'].match(/url\((.*)\)/)[1]
  rescue
    nil # TODO: Change to placeholder image
  end

  def description
    document.css('.bio .description').first.content.strip
  rescue
    nil
  end

  private

  def datetime_from_hour_and_minute(hour, minute, second = 0)
    now = DateTime.now
    DateTime.new(now.year, now.month, now.day, hour, minute, second, now.zone)
  end

  def split_time(time)
    time.split(':').map(&:to_i)
  end

  def document
    @document ||= Nokogiri::HTML.parse(
      HTTParty.get(url).body
    )
  end
end
