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
    "isHumanChecked": {
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
                required: true,
                type: String
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
    }
})

module.exports = mongoose.model('Image', imageSchema)
