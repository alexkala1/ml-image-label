<template>
	<v-container fluid>
		<v-row
			justify="center"
			v-for="(dataset, index) in datasets"
			:key="index"
		>
			<v-col cols="4">
				<v-select
					outlined
					rounded
					v-model="Object.values(selectedDatasets[index])[0]"
					:items="Object.values(dataset)[0]"
					:label="Object.keys(dataset)[0]"
					multiple
				>
					<template v-slot:prepend-item>
						<v-list-item ripple @click="toggle(index)">
							<v-list-item-action>
								<v-icon
									:color="
										Object.values(
											selectedDatasets[index]
										)[0].length > 0
											? 'indigo darken-4'
											: ''
									"
								>
									{{
										Object.values(
											selectedDatasets[index]
										)[0].length !==
										Object.values(dataset)[0].length
											? 'mdi-checkbox-blank-outline'
											: 'mdi-close-box'
									}}
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
				{{ Object.values(selectedDatasets[index])[0].length }}
				{{ Object.values(dataset)[0].length }}
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
export default {
	data: () => ({
		datasets: [],
		selectedDatasets: [],
		icon: 'mdi-checkbox-blank-outline',
	}),

	computed: {},

	methods: {
		toggle(index) {
			if (
				Object.values(this.selectedDatasets[index])[0].length ===
				Object.values(this.datasets[index])[0].length
			) {
				Object.values(this.selectedDatasets[index])[0].splice(
					0,
					Object.values(this.selectedDatasets[index])[0].length
				)
				console.log(this.selectedDatasets)
			} else {
				Object.assign(
					this.selectedDatasets[index],
					this.datasets[index]
				)
			}
		},

		async fillDatasets() {
			const { data } = await this.$axios.get(
				'http://localhost:3001/api/v1/datasets'
			)

			data.forEach((dataset) => {
				this.datasets.push({
					[dataset.name]: dataset.labels,
				})
				this.selectedDatasets.push({
					[dataset.name]: [],
				})
			})
		},
	},

	mounted() {
		this.fillDatasets()
	},
}
</script>