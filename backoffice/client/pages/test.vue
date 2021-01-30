<template>
	<v-container>
		<v-row justify="center">
			<v-col
				cols="6"
				v-for="(dataset, index) in datasets"
				:key="dataset.id"
			>
				<v-select
					rounded
					outlined
					multiple
					:items="dataset.labels"
					v-model="selectedDatasets[index]"
					:label="dataset.name"
					@input="test(selectedDatasets)"
				>
					<template v-slot:prepend-item>
						<v-list-item ripple @click="toggle(index)">
							<v-list-item-action>
								<v-icon
									:color="
										selectedDatasets[index].length > 0
											? 'indigo darken-4'
											: ''
									"
								>
									{{ selectedDatasets[index].length > 0 ? 'mdi-close-box' : 'mdi-checkbox-blank-outline' }}
								</v-icon>
							</v-list-item-action>
							<v-list-item-content>
								<v-list-item-title>
									Select All
								</v-list-item-title>
							</v-list-item-content>
						</v-list-item>
						<v-divider class="mt-2"></v-divider>
					</template>
				</v-select>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
export default {
	data() {
		return {
			datasets: [],
			selectedDatasets: [],
		}
	},

	methods: {
		async fetchDatasets() {
			const { data } = await this.$axios.get(
				`http://localhost:3001/api/v1/datasets`
			)
			
			data.forEach((dataset, index) => {
				this.selectedDatasets[index] = []
			});
			this.datasets = data
		},

		test(test) {
			console.log(test)
		},

		toggle(index) {
			this.$nextTick(() => {
				if (this.selectedDatasets[index].length > 0) {
					this.selectedDatasets[index] = []
				} else {
					this.selectedDatasets[index] = this.datasets[index].labels.slice()
				}
				console.log(this.selectedDatasets)
			})
		},
	},

	mounted() {
		this.fetchDatasets()
	},
}
</script>

<style>
</style>