const express = require('express');
const emojis = require('./emojis');
const users = require('./users')
const images = require('./images')
const auth = require('./auth')

const router = express.Router();

router.get('/', (req, res) => {
	res.json({
		message: 'API - 👋🌎🌍🌏'
	});
});

router.use('/emojis', emojis);
router.use('/users', users);
router.use('/images', images);
router.use('/auth', auth);

module.exports = router;