const express = require('express')
const multer = require('multer')
const router = express.Router()

const Image = require('../models/image')

const upload = multer({
	dest: './ uploads /',
	rename: function (fieldname, filename) {
		return filename;
	},
})

/**
 * Basic CRUD functionality for image
 * (Create, Read, Update, Delete).
 * Auth API must be separate this is just
 * for handling image.
 */

// Create new image
router.post('/', upload.single('image'), async (req, res, next) => {

	try {
		const image = new Image({
			email: req.body.email,
			user_id: req.body.user_id,
			image: req.body.image,
			dataset_id: req.body.dataset_id,
			imageName: req.body.imageName,
			isVerified: false,
			isHumanChecked: false,
			object: req.body.object,
			date: Date.now()
		});

		await image.save();

		return res.json(image);
	} catch (error) {
		throw new Error(error)
	}
})

// Get all images
router.get('/allImages', async (req, res, next) => {
	try {
		const images = await Image.find()

		return res.json(images)
	} catch (error) {
		throw new Error(error)
	}
})

// Get all rejected images
router.get('/rejected', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: false, isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		throw new Error(error)
	}
})

// Get all verified images
router.get('/verified', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true, isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		throw new Error(error)
	}
})

// Get all verified images from a user
router.get('/verified/:user_id', async (req, res, next) => {
	try {
		const images = await Image.find({ isVerified: true, id: req.params.user_id, isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		throw new Error(error)
	}
})

// Fetch History
router.get('/history', async (req, res) => {
	try {
		const images = await Image.find({ isHumanChecked: true })

		return res.json(images)
	} catch (error) {
		throw new Error(error)
	}
})

// Get non reviewed images
router.get('/nonReviewed', async (req, res) => {
	try {
		const images = await Image.find({ isHumanChecked: false })

		return res.json(images)
	} catch (error) {
		throw new Error(error)
	}
})

// Get Image by id
router.get('/:_id', async (req, res, next) => {
	try {
		const image = await Image.findById(req.params._id)

		return res.json(image)
	} catch (error) {
		throw new Error(error)
	}
})
// Verify an image
router.put('/verify/:_id', async (req, res, next) => {
	try {
		const image = await Image.findById(req.params._id);
		image.isHumanChecked = true;
		image.reviewedAt = Date.now();
		image.isVerified = true;

		// console.log(image)

		await image.save();

		return res.json(image);
	} catch (error) {
		console.log(error)
		throw new Error(error)
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

		console.log(image)

		return res.json(image);
	} catch (error) {
		throw new Error(error)
	}
})

// Delete image by id
router.delete('/:_id', async (req, res, next) => {
	try {
		const image = await Image.findOneAndRemove(req.params._id)

		return res.json(image)
	} catch (error) {
		throw new Error(error)
	}
})

module.exports = router;