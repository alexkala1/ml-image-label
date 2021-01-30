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
				>
					<template v-slot:prepend-item>
						<v-list-item ripple @click="toggle(index)">
							<v-list-item-action>
								<v-icon
									:color="
										selectedAllDatasets === true
											? 'indigo darken-4'
											: ''
									"
								>
									{{ icon }}
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
			icon: '',
		}
	},

	watch: {
		selectedDatasets: function (labels) {
			labels.forEach((label) => {
				console.log(label)
				if (label) this.icon = 'mdi-close-box'
				else this.icon = 'mdi-checkbox-blank-outline'
			})
		},

		icon: function (icon) {
			console.log(icon)
		},
	},

	computed: {
		selectedAllDatasets() {
			this.selectedDatasets.filter((label, index) => {
				// console.log(
				// 	label,
				// 	label.length === this.datasets[index].labels.length
				// )
				return label.length === this.datasets[index].labels.length
			})
		},
	},

	methods: {
		async fetchDatasets() {
			const { data } = await this.$axios.get(
				`http://localhost:3001/api/v1/datasets`
			)

			data.forEach((dataset, index) => {
				this.selectedDatasets[index] = []
			})

			this.datasets = data
		},

		toggle(index) {
			this.$nextTick(() => {
				console.log(this.selectedDatasets[index].length === this.datasets[index].labels.length)
				if (this.selectedDatasets[index].length === this.datasets[index].labels.length) {
					this.selectedDatasets[index] = this.datasets[index].labels.splice()
				} else {
					console.log(this.selectedDatasets[index])
					this.datasets[index].labels.forEach(label => {
						this.selectedDatasets[index].push(label)	
					})
				}
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