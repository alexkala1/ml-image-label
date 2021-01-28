<template>
	<v-container>
		<v-row justify="center">
			<v-col cols="12">
				<v-data-table
					:headers="headers"
					:items="datasets"
					sort-by="calories"
					class="elevation-1"
				>
					<template v-slot:top>
						<v-toolbar flat>
							<v-toolbar-title>Datasets</v-toolbar-title>
							<v-divider class="mx-4" inset vertical></v-divider>
							<v-text-field
								v-model="search"
								append-icon="mdi-magnify"
								label="Search"
								single-line
								hide-details
							></v-text-field>
							<v-spacer></v-spacer>
							<v-dialog v-model="dialog" max-width="500px">
								<template v-slot:activator="{ on, attrs }">
									<v-btn
										color="primary"
										dark
										class="mb-2"
										v-bind="attrs"
										v-on="on"
									>
										New Dataset
									</v-btn>
								</template>
								<v-card>
									<v-card-title>
										<span class="headline">{{
											formTitle
										}}</span>
									</v-card-title>

									<v-card-text>
										<v-container>
											<v-row>
												<v-col cols="12" sm="6" md="6">
													<v-text-field
														v-model="
															editedDataset.name
														"
														label="Dataset name"
													></v-text-field>
												</v-col>
												<v-col cols="12" sm="6" md="6">
													<v-text-field
														v-model="
															editedDataset.label
														"
														append-outer-icon="mdi-plus-circle-outline"
														label="Add Label"
														@click:append-outer="
															close
														"
													>
													</v-text-field>
												</v-col>
											</v-row>
											<v-row justify="center">
												<v-col cols="12">
													<h3>
														Below you can see all th
														labels you put in your
														dataset.
													</h3>
												</v-col>
											</v-row>
											<v-row>
												<v-col cols="8">
													<v-list>
														<v-list-item
															v-for="(
																label, i
															) in newLabels"
															:key="i"
														>
															<v-text-field
																width="150"
																:value="label"
																append-outer-icon="mdi-close"
																@click:append-outer="
																	close
																"
															>
															</v-text-field>
														</v-list-item>
													</v-list>
												</v-col>
											</v-row>
										</v-container>
									</v-card-text>

									<v-card-actions>
										<v-spacer></v-spacer>
										<v-btn
											color="blue darken-1"
											text
											@click="close"
										>
											Cancel
										</v-btn>
										<v-btn
											color="blue darken-1"
											text
											@click="save"
										>
											Save
										</v-btn>
									</v-card-actions>
								</v-card>
							</v-dialog>
							<v-dialog v-model="dialogDelete" max-width="500px">
								<v-card>
									<v-card-title class="headline"
										>Are you sure you want to delete this
										item?</v-card-title
									>
									<v-card-actions>
										<v-spacer></v-spacer>
										<v-btn
											color="blue darken-1"
											text
											@click="closeDelete"
											>Cancel</v-btn
										>
										<v-btn
											color="blue darken-1"
											text
											@click="deleteDatasetConfirm"
											>OK</v-btn
										>
										<v-spacer></v-spacer>
									</v-card-actions>
								</v-card>
							</v-dialog>
						</v-toolbar>
					</template>
					<template v-slot:[`item.actions`]="{ item }">
						<v-icon small class="mr-2" @click="editDataset(item)">
							mdi-pencil
						</v-icon>
						<v-icon small @click="deleteDataset(item)">
							mdi-delete
						</v-icon>
					</template>
					<template v-slot:no-data>
						<v-btn color="primary" @click="fetchDatasets">
							Reset
						</v-btn>
					</template>
				</v-data-table>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
export default {
	data: () => ({
		dialog: false,
		dialogDelete: false,
		headers: [
			{ text: 'ID', value: '_id' },
			{ text: 'Dataset Name', value: 'name' },
			{ text: 'Labels', value: 'labels' },
			{ text: 'Actions', value: 'actions', sortable: false },
		],
		datasets: [],
		newLabels: [],
		editedIndex: -1,
		editedDataset: {
			name: '',
			labels: '',
		},
		defaultDataset: {
			name: '',
			labels: '',
		},
		search: '',
	}),

	computed: {
		formTitle() {
			return this.editedIndex === -1 ? 'New Dataset' : 'Edit Dataset'
		},
	},

	watch: {
		dialog(val) {
			val || this.close()
		},
		dialogDelete(val) {
			val || this.closeDelete()
		},
	},

	created() {
		this.fetchDatasets()
	},

	methods: {
		async fetchDatasets() {
			const datasets = await this.$axios.get(
				'http://localhost:3001/api/v1/datasets'
			)

			this.datasets = await Promise.all(
				datasets.data.map(async (dataset) => {
					const labels = await this.$axios.get(
						`http://localhost:3001/api/v1/datasets/label/${dataset._id}`
					)
					let temptable = []
					labels.data.forEach((label, i) => {
						temptable.push(label.name)
					})

					dataset.labels = temptable
					temptable = []

					console.log(labels.data)

					return await dataset
				})
			)

			console.log(this.datasetsSelected, this.labelsSelected)

			return await this.datasets
		},

		editDataset(item) {
			console.log(item)
			this.newLabels = item.labels
			this.editedIndex = this.datasets.indexOf(item)
			this.editedDataset = Object.assign({}, item)
			this.dialog = true
		},

		deleteDataset(item) {
			this.editedIndex = this.datasets.indexOf(item)
			this.editedDataset = Object.assign({}, item)
			this.dialogDelete = true
		},

		deleteDatasetConfirm() {
			this.datasets.splice(this.editedIndex, 1)
			this.closeDelete()
		},

		close() {
			this.dialog = false
			this.$nextTick(() => {
				this.editedDataset = Object.assign({}, this.defaultDataset)
				this.editedIndex = -1
			})
		},

		closeDelete() {
			this.dialogDelete = false
			this.$nextTick(() => {
				this.editedDataset = Object.assign({}, this.defaultDataset)
				this.editedIndex = -1
			})
		},

		save() {
			if (this.editedIndex > -1) {
				Object.assign(
					this.datasets[this.editedIndex],
					this.editedDataset
				)
			} else {
				this.datasets.push(this.editedDataset)
			}
			this.close()
		},
	},
}
</script>

<style>
</style>