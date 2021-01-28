const mongoose = require('mongoose')

const datasetSchema = mongoose.Schema({
	name: {
		required: true,
		unique: true,
		type: String
	}
})

module.exports = mongoose.model('Dataset', datasetSchema)
