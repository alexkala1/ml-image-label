const app = require('./app');
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/imageLabel', {
	useNewUrlParser: true,
	useUnifiedTopology: true
})
	.then(() => console.log('Database Connected'))
	.catch(err => console.log(err));

mongoose.set('useFindAndModify', false);
mongoose.set('useCreateIndex', true);

const port = process.env.PORT || 5000;
app.listen(port, () => {
	/* eslint-disable no-console */
	console.log(`Listening: http://localhost:${port}`);
	/* eslint-enable no-console */
});