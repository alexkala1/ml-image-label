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
router.post('/', async (req, res, next) => {

	const image = new Image({
		email: req.params.email,
		user_id: req.params.user_id,
		dataset: req.params.dataset,
		dataset_id: req.params.dataset_id,
		image: req.params.image,
		imageName: req.params.imageName,
		isVerified: false,
		object: req.params.object,
		date: Date.now()
	})

	await image.save();

	return res.json(image)
})

// Fetch user history
router.get('/verified/:admin_id', async (req, res, next) => {
	try {
		const images = await Image.find({ verifiedBy: req.params.admin_id })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all rejected images
router.get('/rejected', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: false })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all rejected images from a user
router.get('/rejected/:user_id', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true, id: req.params.user_id })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all verified images
router.get('/verified', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all verified images from a user
router.get('/verified/:user_id', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true, id: req.params.user_id })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get Image by id
router.get('/:_id', async (req, res, next) => {
	try {
		const image = await Image.findById(req.params._id)

		return res.json(image)
	} catch (error) {
		return res.json(error)
	}
})
// Verify an image
router.put('/:_id', async (req, res, next) => {
	try {
		const image = await Image.findById(req.params._id)
		image.isVerified = true

		await image.save()

		return res.json(image)
	} catch (error) {
		return res.json(error)
	}
})

// Delete image by id
router.delete('/:_id', async (req, res, next) => {
	try {
		const image = await Image.findOneAndRemove(req.params._id)

		return res.json(image)
	} catch (error) {
		return res.json(error)
	}
})

module.exports = router;