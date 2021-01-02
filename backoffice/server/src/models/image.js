const mongoose = require('mongoose')
const Schema = mongoose.Schema

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
    "imageName": {
        required: true,
        type: String
    },
    "isVerified": {
        required: true,
        type: Boolean
    },
    /**
     * We need to have the user search for the
     * appropriate label and if it does not exist 
     * then he creates a new one. So we connect 
     * the Schema for the label with the schema for
     * the image in order for the program to be able
     * to search through all the labels separately
     */
    "object": {
        required: true,
        type: [{
            label: {
                type: Schema.Types.ObjectId,
                ref: 'Label'
            },
            bbox: {
                type: [{
                    x: {
                        required: true,
                        type: Number
                    },
                    y: {
                        required: true,
                        type: Number
                    },
                    width: {
                        required: true,
                        type: Number
                    },
                    height: {
                        required: true,
                        type: Number
                    }
                }],
            }
        }]
    },
    date: {
        required: true,
        type: Date
    },
    verifiedBy: {
        required: false,
        type: String
    }
})

module.exports = mongoose.model('Image', imageSchema)
