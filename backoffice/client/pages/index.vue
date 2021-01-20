<template>
	<v-container>
		<v-row justify="center" align="center">
			<v-col
				cols="4"
				sm="6"
				md="3"
				v-for="(image, i) in images"
				:key="image.id"
			>
				<v-skeleton-loader
					:loading="loading"
					:transition="transition"
					type="card, actions"
				>
					<v-card class="mx-auto" max-width="400">
						<v-img
							class="white--text align-end"
							height="200px"
							:src="`data:image/jpeg;base64,${image.image}`"
						>
							<template v-slot:placeholder>
								<v-row
									class="fill-height ma-0"
									align="center"
									justify="center"
								>
									<v-progress-circular
										indeterminate
									></v-progress-circular>
								</v-row>
							</template>
							<v-card-title>{{ image.imageName }}</v-card-title>
						</v-img>
						<v-card-subtitle class="pb-0"
							>ID: {{ image._id }}</v-card-subtitle
						>
						<v-card-text class="text--primary">
							<div>Created at: {{ image.date }}</div>
							<div>Uploaded by: {{ image.user_id }}</div>
						</v-card-text>
						<v-card-actions>
							<v-btn color="orange" text :to="'/review/' + image._id"> Review </v-btn>
						</v-card-actions>
					</v-card>
				</v-skeleton-loader>
			</v-col>
		</v-row>
		<v-row justify="center" align="center" v-if="loading === false">
			<v-pagination
				v-model="page"
				class="my-4"
				total-visible="7"
				:length="paginationLength"
				@input="changePage(page)"
				circle
			></v-pagination>
		</v-row>
		<v-row justify="center" align="center" v-else>
			<v-progress-circular class="my-4" indeterminate>
			</v-progress-circular>
		</v-row>
	</v-container>
</template>

<script>
export default {
	data() {
		return {
			loading: true,
			page: 1,
			transition: 'scale-transition',
			allImages: [],
			images: [],
			paginationLength: ''
		}
	},

	methods: {
		async getAllImages() {
			const { data } = await this.$axios.get(
				`http://localhost:3001/api/v1/images/nonReviewed`
			)

			this.allImages = data
			this.paginationLength = Math.ceil(data.length / 10)
			this.images = this.allImages.slice(0, 10)
			this.loading = false
		},

		changePage(page) {
			this.images = this.allImages.filter((image, i) => {
				return i >= ((page - 1) * 10) && i < (page * 10)
			})
		}
	},

	mounted() {
		this.getAllImages()
	},
}
</script>
