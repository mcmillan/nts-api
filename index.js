const pMemoize = require('p-memoize')
const ms = require('ms')
const getStation = require('./station')


const fetchStations = async () => {
  try {
     const [station1, station2] = await Promise.all([getStation('one'), getStation('two')])
     return { stations: [station1, station2] }
  } catch (err) {
    throw err
  }
}

const memFetchStations = pMemoize(fetchStations, { maxAge: ms('5m') })

module.exports = () => memFetchStations()
