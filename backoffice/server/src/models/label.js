const mongoose = require('mongoose')

const labelsSchema = mongoose.Schema({
	name: {
		required: true,
		unique: true,
		type: String
	},
	dataset_id: {
		required: true,
		type: String
	}
})

module.exports = mongoose.model('Labels', labelsSchema)
