const express = require('express')
const multer = require('multer')
const upload = multer({dest: 'uploads/'})

const router = express.Router()

const Image = require('../models/image')

/**
 * Basic CRUD functionality for image
 * (Create, Read, Update, Delete).
 * Auth API must be separate this is just
 * for handling image.
 */

// Create new image
router.post('/',upload.single('image') , async (req, res, next) => {

	console.log(req.file)
	console.log(req.body)
	const image = new Image({
		email: req.body.email,
		user_id: req.body.user_id,
		dataset: req.body.dataset,
		dataset_id: req.body.dataset_id,
		image: req.body.image,
		imageName: req.body.imageName,
		isVerified: false,
		isHumanChecked: false,
		object: req.body.object,
		date: Date.now()
	});

	await image.save();

	return res.json(image);
})

// Fetch user history
router.get('/verified/:user_id', async (req, res, next) => {
	try {
		const images = await Image.find({ verifiedBy: req.params.user_id, isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all rejected images
router.get('/rejected', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: false, isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all rejected images from a user
router.get('/rejected/:user_id', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true, id: req.params.user_id, isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all verified images
router.get('/verified', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true, isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get all verified images from a user
router.get('/verified/:user_id', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true, id: req.params.user_id, isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		return res.json(error)
	}
})

// Get non reviewed images
router.get('/nonReviewed', async (req, res) => {
	try {
		const images = await Image.find({ isHumanChecked: false })

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
router.put('/verify/:_id', async (req, res, next) => {
	try {
		const image = await Image.findById(req.params._id);
		image.isHumanChecked = true;
		image.reviewedAt = Date.now();
		image.isVerified = true;

		await image.save();

		return res.json(image);
	} catch (error) {
		return res.json(error);
	}
})

// Reject an image
router.put('/reject/:_id', async (req, res, next) => {
	try {
		const image = await Image.findById(req.params._id);
		image.isHumanChecked = true;
		image.reviewedAt = Date.now();
		image.isVerified = false;

		await image.save();

		return res.json(image);
	} catch (error) {
		return res.json(error);
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