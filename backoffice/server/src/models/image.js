const mongoose = require('mongoose')

const imageSchema = mongoose.Schema({
    "email": {
        required: true,
        type: String,
    },
    "user_id": {
        required: true,
        type: String,
    },
    "dataset": {
        required: true,
        type: String,
    },
    "dataset_id": {
        required: true,
        type: String,
    },
    "image": {
        data: Buffer,
        contentType: String
    },
    "isVerified": {
        required: true,
        type: Boolean
    }
    // "object": [
    //     { "Label": "doc", "bbox": [x, y, width, height] },
    //     { "Label": "bicycle", "bbox": [x, y, width, height] },
    //     { "Label": "truck", "bbox": [x, y, width, height] }
    // ]
})

module.exports = mongoose.model('Image', imageSchema)
