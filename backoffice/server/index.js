const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser")
const morgan = require("morgan");
const helmet = require("helmet");

require("dotenv").config();

const app = express();

app.use(helmet());
app.use(morgan("tiny"));
app.use(cors());
app.use(express.json());
app.use(bodyParser.urlencoded({
    extended: false
}))
app.use(bodyParser.json())

app.listen(port, () => {
    console.log(`listening at http://localhost:3000`);
});