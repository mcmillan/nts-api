const fetch = require('node-fetch')
const cheerio = require('cheerio')

const STREAM_URLS = {
  one: 'http://stream-relay-geo.ntslive.net/stream',
  two: 'http://stream-relay-geo.ntslive.net/stream2'
}

const DETAILS_URLS = {
  one: 'http://nts.live/schedule?ajax=true',
  two: 'http://nts.live/schedule/2?ajax=true'
}

const getStation = async function (station) {
  const response = await fetch(DETAILS_URLS[station])
  const responseString = await response.text()
  const $ = cheerio.load(responseString)

  const showObj = {
    title: $('.bio__title h1').text() || null,
    description: $('.schedule-text .description').text() || null,
    location: $('.bio__title h2').text() || null,
    url: $('link[rel=canonical]').attr('href') || null,
    imageUrl: $('#profile-container #bg').css('background-image').replace(/^url|[\(\)]/g, '')
  }


  return {
    name: station.toUpperCase(),
    show: showObj,
    streamUrl: STREAM_URLS[station]
  }
}

module.exports = getStation
