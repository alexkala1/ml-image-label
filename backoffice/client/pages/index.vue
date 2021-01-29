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
		<v-row justify="center" v-if="images.length > 0 && !loading">
			<v-col cols="2">
				<v-list-group v-for="dataset in datasets" :key="dataset.id">
					<template v-slot:activator>
						<v-list-item-content class="py-0">
							<v-list-item-title>
								<v-checkbox
									@click="filterByLabels"
									class="px-2"
									:disabled="loading"
									:label="dataset.name"
									:value="dataset.name"
									v-model="datasetsSelected"
								>
								</v-checkbox>
							</v-list-item-title>
						</v-list-item-content>
					</template>

					<v-list-item
						v-for="label in dataset.labels"
						:key="label.id"
						class="px-12"
					>
						<v-checkbox
							class="pt-1 mt-1"
							@click="filterByLabels"
							:disabled="loading"
							v-model="labelsSelected"
							:value="label"
							:label="label"
						></v-checkbox>
					</v-list-item>
				</v-list-group>
			</v-col>
			<v-col cols="10">
				<v-row justify="space-between" align="center" mo-gutters>
					<v-col cols="3">
						<v-select
							filled
							rounded
							item-value="imageFilters"
							v-model="imageFilter"
							:items="imageFilters"
							label="Images"
							placeholder="Select..."
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

				<v-row justify="center">
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
			</v-col>
			<v-row justify="center" align="center">
				<v-pagination
					v-model="page"
					class="my-4"
					total-visible="7"
					:length="paginationLength"
					@input="changePage(page)"
					circle
				></v-pagination>
			</v-row>
		</v-row>
		<v-row justify="center" align="center" v-else>
			<v-col cols="12">
				<p class="display-1 text-center">No data!</p>
			</v-col>
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
			datasetsSelected: [],
			labelsSelected: [],
			allDatasetFilters: [],
			allLabelFilters: [],
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

			this.datasets = data

			data.forEach((dataset) => {
				this.datasetsSelected.push(dataset.name)
				this.allDatasetFilters.push(dataset.name)
				dataset.labels.forEach((label) => {
					this.labelsSelected.push(label)
					this.allLabelFilters.push(label)
				})
			})
		},

		filterByLabels() {
			console.log(this.datasetsSelected, this.labelsSelected)
			return this.datasetsSelected, this.labelsSelected
		},
	},

	async mounted() {
		this.getAllImages(), await this.fetchDatasets()
	},
}
</script>
