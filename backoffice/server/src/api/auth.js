const express = require('express')
const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt')
const User = require('../models/user')
const mongoose = require('mongoose')

const router = express.Router()

/**
 * Basic CRUD functionality for image
 * (Create, Read, Update, Delete).
 * Auth API must be separate this is just
 * for handling image.
 */

// Register new user
router.post('/register', async (req, res) => {
	// Generate salt
	const salt = bcrypt.genSaltSync(10)

	// Hash the user password
	const hashedPassword = bcrypt.hashSync(req.body.password, salt)

	// Create a User object
	const user = new User({
		email: req.body.email,
		firstName: req.body.firstName,
		lastName: req.body.lastName,
		userType: req.body.userType,
		password: hashedPassword,
	})

	// Save User in the database
	await user.save()

	return res.json(user)
})

/**
 * Handles login functionality. Uses JWT for authentication.
 * WIP: Discuss login expiration time for JWT as well as
 * the checks for a valid person.
 */
router.post('/login', async (req, res) => {
	const user = await User.findOne({
		email: req.body.email,
	})

	// Check credentials
	if (bcrypt.compareSync(req.body.password, user.password) && user !== undefined) {
		// Sign user's email with jwt token
		const token = jwt.sign({ email: req.body.email }, process.env.ACCESS_TOKEN, { expiresIn: '15m' })

		// Create session user
		const response = {
			firstName: user.firstName,
			lastName: user.lastName,
			email: user.email,
			id: user._id,
			token,
		}

		return res.json({ response })
	}
	if (!bcrypt.compareSync(req.body.password, user.password))
		throw new Error('Λάθος κωδικός')

	if (user === undefined)
		throw new Error('Δεν υφίσταται χρήστης με αυτό το email')
})

/**
 * This handles the check for user's JWT if exist and if
 * it is valid. Front logs user out in case something's wrong
 */
router.get('/fetchUser', (req, res) => {
	const authHeader = req.headers['authorization']
	const token = authHeader && authHeader.split(' ')[1]
	if (token === null) return res.send('fail')

	jwt.verify(token, process.env.ACCESS_TOKEN, async (err, user) => {
		if (err)
			return res.sendStatus(403)

		const userResponse = await User.findOne({ email: user.email })

		return res.json({ user: userResponse })
	})
})

/**
 * This is only to drop a single collection
 * and it is only for dev purposes.
 * Remove on production.
 */
router.get('/drop/:name', (req, res) => {
	mongoose.connection.db.dropCollection(
		req.params.name,
		function (err, result) {
			if (err !== null) return res.json(err)

			return res.json(result)
		}
	)
})

module.exports = router
