const express = require('express')

const router = express.Router()

const Image = require('../models/image')

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
router.get('/non-verified', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: false })
		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all images
router.get('/verified', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true })
		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all images
router.get('/verified', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true })
		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
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