const { Db } = require('mongodb')
const monk = require('monk')
const connectionStream = 'localhost/imageboard'

const db = monk(connectionStream)

module.exports = db