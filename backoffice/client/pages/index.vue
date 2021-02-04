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
			<v-col cols="2">
				<h3 class="heading text-center font-weight-light py-5">
					Datasets and labels
				</h3>
			</v-col>
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
					<div v-for="(dataset, index) in datasets" :key="dataset.id">
						<v-select
							deletable-chips
							chips
							multiple
							:items="dataset.labels"
							v-model="selectedDatasets[index]"
							:label="dataset.name"
						>
							<template v-slot:prepend-item>
								<v-list-item ripple @click="toggle(index)">
									<v-list-item-action>
										<v-icon
											:color="
												selectedDatasets[index]
													.length ===
												dataset.labels.length
													? 'indigo darken-4'
													: ''
											"
										>
											{{
												selectedDatasets[index]
													.length ===
												dataset.labels.length
													? 'mdi-close-box'
													: 'mdi-checkbox-blank-outline'
											}}
										</v-icon>
									</v-list-item-action>
									<v-list-item-content>
										<v-list-item-title>
											Select All
										</v-list-item-title>
									</v-list-item-content>
								</v-list-item>
								<v-divider></v-divider>
							</template>
						</v-select>
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
												{{ image.object[0].label }}
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
			paginationLength: '',
			search: '',
			datasets: [],
			selectedDatasets: [],
			labelsSelected: [],
			allDatasetFilters: [],
			allLabelFilters: [],
		}
	},

	watch: {
		selectedDatasets: function (labels) {
			let filter = []
			labels.forEach((label) => {
				if (label.length !== 0) {
					filter.push(label)
				}
			})

			if (filter.length === 0) {
				this.paginationLength = Math.ceil(this.allImages.length / 10)
				this.images = this.allImages.slice(0, 10)
			} else {
				this.images = this.allImages.filter((image) => {
					return image.object[0].label.indexOf(filter)
				})
				console.log(filter)
			}
			return labels
		},
	},

	methods: {
		async getAllImages(filter) {
			switch (filter) {
				case 'All Images':
					let getAll = await this.$axios.get(
						'http://localhost:3001/api/v1/images/allImages'
					)
					this.allImages = getAll.data
					this.paginationLength = Math.ceil(getAll.data.length / 10)
					this.images = this.allImages.slice(0, 10)
					this.loading = false
					break

				case 'Verified':
					let getVerified = await this.$axios.get(
						'http://localhost:3001/api/v1/images/verified'
					)
					this.allImages = getVerified.data
					this.paginationLength = Math.ceil(
						getVerified.data.length / 10
					)
					this.images = this.allImages.slice(0, 10)
					this.loading = false
					break

				case 'Rejected':
					let getRejected = await this.$axios.get(
						'http://localhost:3001/api/v1/images/rejected'
					)
					this.allImages = getRejected.data
					this.paginationLength = Math.ceil(
						getRejected.data.length / 10
					)
					this.images = this.allImages.slice(0, 10)
					this.loading = false
					break

				default:
					let { data } = await this.$axios.get(
						'http://localhost:3001/api/v1/images/nonReviewed'
					)
					this.allImages = data
					this.paginationLength = Math.ceil(data.length / 10)
					this.images = this.allImages.slice(0, 10)
					this.loading = false
					break
			}
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
						.indexOf(this.search.toLowerCase()) > -1
				)
			})
		},

		async fetchDatasets() {
			const { data } = await this.$axios.get(
				'http://localhost:3001/api/v1/datasets'
			)

			data.forEach((dataset, index) => {
				this.selectedDatasets[index] = []
			})

			this.datasets = data
		},

		filterByLabels() {
			return this.datasetsSelected, this.labelsSelected
		},

		toggle(index) {
			this.$nextTick(() => {
				if (
					this.selectedDatasets[index].length ===
					this.datasets[index].labels.length
				) {
					this.selectedDatasets[index] = this.datasets[
						index
					].labels.splice()
				} else {
					this.datasets[index].labels.forEach((label) => {
						this.selectedDatasets[index].push(label)
					})
				}
			})
		},
	},

	async mounted() {
		this.getAllImages(), await this.fetchDatasets()
	},
}
</script>
