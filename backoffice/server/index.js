const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser")
const morgan = require("morgan");
const helmet = require("helmet");

require("dotenv").config();

const messages = require('./db/MessageModel')

const app = express();

app.use(helmet());
app.use(morgan("dev"));
app.use(cors());
app.use(express.json());
app.use(bodyParser.urlencoded({
    extended: false
}))
app.use(bodyParser.json())

app.get('/messages', (req, res) => {
	messages.getAllMessages().then((messages) => {
		res.json(messages)
	})
})

app.post('/messages/new', (req, res) => {
	console.log(req.body)
	messages.createMessage(req.body).then((message) => {
		res.json(message)
	}).catch((error) => {
		res.status(500)
		res.json(error)
	})
})

const port = process.env.port || 3001

app.listen(port, () => {
    console.log(`listening at http://localhost:${port}`);
});