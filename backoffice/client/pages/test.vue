<template>
	<v-container>
		<v-row justify="center">
			<v-col cols="6" v-for="dataset in datasets" :key="dataset.id">
				<v-select
					rounded
					outlined
					multiple
					:items="dataset.labels"
					v-model="selectedDatasets"
					:label="dataset.name"
				>
				</v-select>

				{{ dataset }}
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

			console.log(data)
			this.datasets = data
		},
	},

	mounted() {
		this.fetchDatasets()
	},
}
</script>

<style>
</style>