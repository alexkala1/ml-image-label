<template>
	<v-container fluid>
		<v-dialog v-model="loading" persistent width="434">
			<v-card color="primary" class="pa-5 text-center">
				<v-card-title class="white--text justify-center">
					Loading: Please Wait...
				</v-card-title>
				<v-row align="center" justify="center">
					<v-col cols="12" class="text-center">
						<v-progress-circular
							color="white"
							width="7"
							size="70"
							indeterminate
						></v-progress-circular>
					</v-col>
				</v-row>
			</v-card>
		</v-dialog>
		<v-row justify="center">
			<v-col cols="12" md="3">
				<v-card height="100%">
					<v-card-title class="subheading font-weight-bold">
						{{ image.imageName }}
					</v-card-title>

					<v-divider></v-divider>

					<v-list dense>
						<v-list-item>
							<v-list-item-content> ID:</v-list-item-content>
							<v-list-item-content class="align-end">
								{{ image._id }}
							</v-list-item-content>
						</v-list-item>
						<v-list-item>
							<v-list-item-content> E-mail:</v-list-item-content>
							<v-list-item-content class="align-end">
								{{ image.email }}
							</v-list-item-content>
						</v-list-item>
						<v-list-item>
							<v-list-item-content> User ID:</v-list-item-content>
							<v-list-item-content class="align-end">
								{{ image.user_id }}
							</v-list-item-content>
						</v-list-item>
						<v-list-item>
							<v-list-item-content> Dataset:</v-list-item-content>
							<v-list-item-content class="align-end">
								{{ image.dataset }}
							</v-list-item-content>
						</v-list-item>
						<v-list-item>
							<v-list-item-content>
								Dataset ID:</v-list-item-content
							>
							<v-list-item-content class="align-end">
								{{ image.dataset_id }}
							</v-list-item-content>
						</v-list-item>
						<v-list-item>
							<v-list-item-content>
								Is Verified:</v-list-item-content
							>
							<v-list-item-content class="align-end">
								{{ image.isVerified }}
							</v-list-item-content>
						</v-list-item>
						<v-list-item>
							<v-list-item-content>
								Is Reviewed:</v-list-item-content
							>
							<v-list-item-content class="align-end">
								{{ image.isHumanChecked }}
							</v-list-item-content>
						</v-list-item>
						<v-list-item>
							<v-list-item-content> Object:</v-list-item-content>
							<v-list-item-content class="align-end">
								{{ image.object }}
							</v-list-item-content>
						</v-list-item>
						<v-list-item>
							<v-list-item-content> Date:</v-list-item-content>
							<v-list-item-content class="align-end">
								{{ properDate(image.date) }}
							</v-list-item-content>
						</v-list-item>
					</v-list>
				</v-card>
			</v-col>
			<v-col cols="12" md="9">
				<img
					id="theImg"
					:src="`data:image/jpeg;base64,${image.image}`"
					class="grey lighten-2"
				/>
				<canvas id="myCanvas" :width="1000" :height="1000"> </canvas>
				<template v-slot:placeholder>
					<v-row
						class="fill-height ma-0"
						align="center"
						justify="center"
					>
						<v-progress-circular
							indeterminate
							color="grey lighten-5"
						></v-progress-circular>
					</v-row>
				</template>
			</v-col>
			<v-col class="d-flex justify-end">
				<v-btn color="primary" @click="approve()" text class="mr-2"
					>Approve</v-btn
				>
				<v-btn color="primary" @click="reject()" text class="mr-2"
					>Reject</v-btn
				>
			</v-col>
			<v-snackbar
				v-model="snackbar"
				top
				right
				:color="snackbarColor"
				vertical
				elevation="24"
			>
				{{ message }}

				<template v-slot:action="{ attrs }">
					<v-btn text v-bind="attrs" @click="snackbar = false">
						Close
					</v-btn>
				</template>
			</v-snackbar>
		</v-row>
	</v-container>
</template>

<script>
import moment from 'moment'

export default {
	asyncData({ params }) {
		return {
			id: params.id,
		}
	},
	data() {
		return {
			snackbar: false,
			snackbarColor: '',
			message: '',
			image: '',
			loading: true,
			canvasWidth: '',
			canvasHeight: '',
		}
	},
	methods: {
		properDate(date) {
			return moment(date).format('MMMM Do YYYY, h:mm:ss a')
		},

		drawCoords() {
			const imgObject = this.image.object
			var img = document.getElementById('theImg')
			var cnvs = document.getElementById('myCanvas')

			cnvs.style.position = 'absolute'
			cnvs.style.left = img.offsetLeft + 'px'
			cnvs.style.top = img.offsetTop + 'px'
			this.canvasWidth = img.width
			this.canvasHeight = img.height

			console.log(img.width, img.height)
			var ctx = cnvs.getContext('2d')
			ctx.beginPath()
			imgObject.forEach((label) => {
				ctx.fillStyle = '#00ff00'
				ctx.font = '16px Nunito'
				ctx.fillText(label.label, label.bbox[0].x, label.bbox[0].y - 10)
				ctx.rect(
					label.bbox[0].x,
					label.bbox[0].y,
					label.bbox[0].width,
					label.bbox[0].height
				)
				ctx.lineWidth = 3
				ctx.strokeStyle = '#00ff00'
				ctx.stroke()
			})
		},

		async getImage() {
			try {
				const { data } = await this.$axios.get(
					`http://localhost:3001/api/v1/images/${this.$route.params.id}`
				)

				this.image = data
				delete this.image.__v
				this.loading = false
			} catch (error) {
				this.loading = false
				this.snackbar = true
				this.snackbarColor = 'error'
				this.message = error
			}
		},

		async approve() {
			console.log(this.$route.params.id)

			try {
				const response = await this.$axios.put(
					`http://localhost:3001/api/v1/images/verify/${this.$route.params.id}`
				)

				console.log(response)

				this.snackbar = true
				this.snackbarColor = 'green'
				this.message = 'Image Approved!'

				this.$nextTick(function () {
					window.setInterval(() => {
						window.location.href = '/'
					}, 1000)
				})
			} catch (error) {
				this.snackbar = true
				this.snackbarColor = 'error'
				this.message = error
			}
		},

		async reject() {
			try {
				const response = await this.$axios.put(
					`http://localhost:3001/api/v1/images/reject/${this.$route.params.id}`
				)

				this.snackbar = true
				this.snackbarColor = 'green'
				this.message = 'Image Rejected!'

				this.$nextTick(function () {
					window.setInterval(() => {
						window.location.href = '/'
					}, 1000)
				})
			} catch (error) {
				this.snackbar = true
				this.snackbarColor = 'error'
				this.message = error
			}
		},
	},

	async mounted() {
		await this.getImage(), this.drawCoords()
	},
}
</script>

<style>
.v-list-item__content {
	word-break: break-all;
}
</style>
