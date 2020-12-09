const express = require('express')

const router = express.Router()

/**
 * Basic CRUD functionality for image
 * (Create, Read, Update, Delete).
 * Auth API must be separate this is just
 * for handling image.
 */

// Create new image
router.post('/', (req, res, next) => {

})

// Get all images
router.get('/', (req, res, next) => {

})

// Get image by id
router.get('/:id', (req, res, next) => {

})

// Update image by id
router.put('/:id', (req, res, next) => {

})

// Delete image by id
router.delete('/:id', (req, res, next) => {

})

module.exports = router;