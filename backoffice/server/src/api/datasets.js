const express = require('express')
const router = express.Router()

const Dataset = require('../models/dataset')
const Label = require('../models/label')

/**
 * Since labels and datasets are so closely connected
 * we will use the same API endpoint of dataset in order
 * to handle them both. Basic CRUD functionality of both
 * datasets and labels.
 */

/**
 * Get all the datasets with its "relatives"
 */
router.get('/', async (req, res) => {
	let datasets = await Dataset.find()

	let completeDatasets = await Promise.all(datasets.map(async dataset => {
		let labels = await Label.find({ dataset_id: dataset.id })

		return {
			id: dataset._id,
			name: dataset.name,
			labels: labels.map(label => {
				return label.name
			})
		}
	}))

	return res.json(completeDatasets)
})

/**
 * Get a dataset with its labels by dataset ID
 */
router.get('/dataset/:id', async (req, res) => {
	let datasets = await Dataset.find({ _id: req.params.id })

	let completeDatasets = await Promise.all(datasets.map(async dataset => {
		let labels = await Label.find({ dataset_id: dataset.id })

		return {
			id: dataset._id,
			name: dataset.name,
			labels: labels.map(label => {
				return label.name
			})
		}
	}))

	return res.json(completeDatasets)
})

/**
 * Get a dataset with its labels by dataset ID
 */
router.get('/label/:id', async (req, res) => {
	let labels = await Label.find({ dataset_id: req.params.id })

	return res.json(labels)
})

/**
 * Create new dataset
 */
router.post('/', async (req, res) => {
	let dataset = new Dataset({
		name: req.body.name
	})

	await dataset.save()

	return res.json(dataset)
})

/**
 * Create new label connected to a dataset
 */
router.post('/label', async (req, res) => {
	let label = new Label({
		name: req.body.name,
		dataset_id: req.body.dataset_id
	})

	await label.save()

	return res.json(label)
})

/**
 * Get labels only
 */
router.get('/allLabels', async (req, res) => {
	let labels = await Label.find()

	return res.json(labels)
})

/**
 * get datasets only
 */
router.get('/datasetsOnly', async (req, res) => {
	let datasets = await Dataset.find()

	return res.json(datasets)
})

/**
 * Edit an existing dataset
 */
router.put('/dataset/:id', async (req, res) => {
	let dataset = await Dataset.find(req.params.id)

	dataset.name = req.body.name

	await dataset.save()

	return res.json(dataset)
})

/**
 * Edit an existing label
 */
router.put('/label/:id', async (req, res) => {
	let label = await Label.find(req.params.id)

	label.name = req.body.name

	await label.save()

	return res.json(label)
})

/**
 * Delete an existing dataset
 */
router.delete('/:id', async (req, res) => {
	let dataset = await Dataset.findOneAndRemove(req.params.id)

	return res.json({ message: "Deleted Successfully!" })
})

/**
 * Delete an existing label
 */
router.delete('/label/:id', async (req, res) => {
	let label = await Label.findOneAndRemove(req.params.id)

	return res.json({ message: "Deleted Successfully!" })
})

module.exports = router;