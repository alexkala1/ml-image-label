<template>
	<v-container>
		<v-row justify="center" align="center">
			<v-col cols="12" md="6">
				<v-text-field
					outlined
					v-model="search"
					append-icon="mdi-magnify"
					placeholder="Search"
					@input="searchImages"
				>
				</v-text-field>
			</v-col>
		</v-row>
		<v-row justify="center">
			<v-col cols="2"> </v-col>
			<v-col cols="10">
				<v-row justify="space-between" align="center">
					<v-col cols="3">
						<v-select
							filled
							rounded
							item-value="imageFilters"
							v-model="imageFilter"
							:items="imageFilters"
							label="Images"
							placeholder="Select..."
							@change="getAllImages(imageFilter)"
						></v-select>
					</v-col>
					<v-col cols="2">
						<v-pagination
							v-model="page"
							class="my-4"
							total-visible="7"
							:length="paginationLength"
							@input="changePage(page)"
							circle
						></v-pagination>
					</v-col>
				</v-row>
			</v-col>
			<v-row justify="center">
				<v-col cols="2">
					<h3 class="heading text-center font-weight-light py-5">
						Datasets and labels
					</h3>
					<div v-for="dataset in datasets" :key="dataset.id">
						<v-select
							deletable-chips
							chips
							multiple
							:items="dataset.labels"
							v-model="selectedLabels"
							:label="dataset.name"
							@input="showFilterButton()"
						>
						</v-select>
					</div>
					<div class="d-flex justify-center">
						<v-btn
							v-if="filterButton"
							rounded
							color="primary"
							@click="sortByFilter"
						>
							Search
						</v-btn>
					</div>
				</v-col>
				<v-col cols="10">
					<v-row
						justify="center"
						v-if="images.length > 0 && !loading"
					>
						<v-col
							cols="12"
							sm="6"
							md="3"
							v-for="image in images"
							:key="image.id"
						>
							<v-skeleton-loader
								:loading="loading"
								:transition="transition"
								type="card, actions"
							>
								<v-card class="mx-auto">
									<v-img
										class="white--text align-end"
										height="400px"
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
										<v-card-title>{{
											image.imageName
										}}</v-card-title>
									</v-img>
									<v-card-text class="text--primary">
										<h3>
											ID:
											<span class="font-weight-light">
												{{ image._id }}
											</span>
										</h3>
										<h3>
											Labels:
											<span class="font-weight-light">
												{{ image.object['label'] }}
											</span>
										</h3>
										<h3>
											Created at:
											<span class="font-weight-light">
												{{ properDate(image.date) }}
											</span>
										</h3>
										<h3>
											Uploaded by:
											<span class="font-weight-light">
												{{ image.email }}
											</span>
										</h3>
									</v-card-text>
									<v-card-actions>
										<v-btn
											color="primary"
											text
											:to="'/review/' + image._id"
										>
											Review
										</v-btn>
									</v-card-actions>
								</v-card>
							</v-skeleton-loader>
						</v-col>
					</v-row>
					<v-row justify="center" align="center" v-else>
						<v-col cols="12">
							<p class="display-1 text-center">No data!</p>
							<div class="d-flex justify-center">
								<v-btn
									rounded
									large
									color="primary"
									@click="resetImages"
									>Reset all filters</v-btn
								>
							</div>
						</v-col>
					</v-row>
					<v-row justify="center" align="center">
						<v-col cols="12">
							<v-pagination
								v-model="page"
								class="my-4"
								total-visible="7"
								:length="paginationLength"
								@input="changePage(page)"
								circle
							></v-pagination>
						</v-col>
					</v-row>
				</v-col>
			</v-row>
		</v-row>
	</v-container>
</template>

<script>
import moment from 'moment'

export default {
	data() {
		return {
			loading: true,
			page: 1,
			transition: 'scale-transition',
			allImages: [],
			imageFilter: 'In review',
			imageFilters: ['In review', 'All Images', 'Verified', 'Rejected'],
			images: [],
			filteredImages: [],
			paginationLength: '',
			search: '',
			datasets: [],
			selectedLabels: [],
			filterButton: false,
		}
	},

	methods: {
		async getAllImages(filter) {
			const { data } = await this.$axios.get(
				'http://localhost:3001/api/v1/images/allImages'
			)

			this.allImages = data

			switch (filter) {
				case 'All Images':
					this.filteredImages = this.allImages
					this.paginationLength = Math.ceil(
						this.filteredImages.length / 10
					)
					this.images = this.filteredImages.slice(0, 10)
					this.loading = false
					break

				case 'Verified':
					this.filteredImages = this.allImages.filter((image) => {
						return image.isVerified && image.isHumanChecked
					})
					this.paginationLength = Math.ceil(
						this.filteredImages.length / 10
					)
					this.images = this.filteredImages.slice(0, 10)
					this.loading = false
					break

				case 'Rejected':
					this.filteredImages = this.allImages.filter((image) => {
						return (
							image.isVerified === false && image.isHumanChecked
						)
					})
					this.paginationLength = Math.ceil(
						this.filteredImages.length / 10
					)
					this.images = this.filteredImages.slice(0, 10)
					this.loading = false
					break

				default:
					this.filteredImages = this.allImages.filter((image) => {
						return image.isHumanChecked === false
					})
					this.paginationLength = Math.ceil(
						this.filteredImages.length / 10
					)
					this.images = this.filteredImages.slice(0, 10)
					this.loading = false
					break
			}

			this.selectedLabels = []
		},

		changePage(page) {
			this.images = this.allImages.filter((image, i) => {
				return i >= (page - 1) * 10 && i < page * 10
			})
		},

		properDate(date) {
			return moment(date).format('MMMM Do YYYY, h:mm:ss a')
		},

		searchImages(e) {
			if (!this.search) {
				this.images = this.allImages.slice(0, 10)
			}

			this.images = this.allImages.filter((image) => {
				return (
					image.imageName
						.toLowerCase()
						.indexOf(this.search.toLowerCase()) > -1 ||
					image.object.label
						.toLowerCase()
						.indexOf(this.search.toLowerCase()) > -1 ||
					image.dataset
						.toLowerCase()
						.indexOf(this.search.toLowerCase()) > -1
				)
			})
		},

		showFilterButton() {
			this.filterButton = true
		},

		async fetchDatasets() {
			const { data } = await this.$axios.get(
				'http://localhost:3001/api/v1/datasets'
			)

			this.datasets = data
		},

		resetImages() {
			this.selectedLabels = []
			this.getAllImages('In review')
		},

		sortByFilter() {
			this.imageFilter = 'All Images'
			this.loading = true
			this.filteredImages = []

			this.selectedLabels.forEach((label) => {
				this.allImages.forEach((image) => {
					if (image.object['label'] === label) {
						this.filteredImages.push(image)
					}
				})
			})
			this.paginationLength = Math.ceil(this.filteredImages.length / 10)
			this.images = this.filteredImages.slice(0, 10)
			this.loading = false
			this.filterButton = false
		},
	},

	async mounted() {
		this.getAllImages(), await this.fetchDatasets()
	},
}
</script>
