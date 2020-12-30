const mongoose = require('mongoose')

const labelSchema = new mongoose.Schema({
    label: {
        required: true,
        type: String
    }
})

module.exports = mongoose.model('Label', labelSchema)