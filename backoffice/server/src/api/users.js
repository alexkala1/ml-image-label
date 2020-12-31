const express = require('express')
const router = express.Router()

const User = require('../models/user')

/**
 * Basic CRUD functionality for user
 * (Create, Read, Update, Delete).
 * Auth API must be separate this is just
 * for handling user.
 */

// Create new user
router.post('/', async (req, res, next) => {
	const user = new User({
		email: req.body.email,
		firstName: req.body.firstName,
		lastName: req.body.lastName,
		userType: req.body.userType,
	})

	await user.save()

	return res.json(user)
})

// Get all users
router.get('/', async (req, res, next) => {
	try {
		const users = await User.find({})

		return res.json(users)
	} catch (error) {
		return res.json(error)
	}
})

// Get user by id
router.get('/:_id', async (req, res, next) => {
	try {
		const user = await User.findById(req.params._id)
		
		return res.json(user)
	} catch (error) {
		return res.json(error)
	}
})

// Update user by id
router.put('/:id', (req, res, next) => {

})

// Delete user by id
router.delete('/:id', (req, res, next) => {

})

module.exports = router;