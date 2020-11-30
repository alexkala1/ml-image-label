const Joi = require('joi')
const db = require('./connection')


const schema = Joi.object().keys({
	username: Joi.string().alphanum().min(3).max(30).required(),
	subject: Joi.string().required(),
	message: Joi.string().max(500).required(),
	// imageURL: Joi.string().dataUri()

})

const messages = db.get('messages')

function getAllMessages() {
	return messages.find()
}

function createMessage(message) {
	const result = schema.validate(message, schema)

	if (result.err == null) {
		message.created = new Date();
		return messages.insert(message)
	} else {
		return Promise.reject(result.error)
	}
}

module.exports = {
	getAllMessages,
	createMessage
}