<template>
	<v-row align="center" justify="center">
		<v-col cols="12" sm="12" md="10">
			<v-card>
				<v-card-title>
					All-time Approved Images
					<v-spacer></v-spacer>
					<v-text-field
						v-model="search"
						append-icon="mdi-magnify"
						label="Search"
						single-line
						hide-details
					></v-text-field>
				</v-card-title>
				<v-data-table
					:headers="headers"
					:items="approvedImages"
					:search="search"
					:loading="loading"
					loading-text="Loading... Please wait"
				></v-data-table>
			</v-card>
		</v-col>
	</v-row>
</template>

<script>
export default {
	data() {
		return {
			search: '',
			loading: true,
			headers: [],
			approvedImages: [],
		}
	},

	methods: {
		async getApprovedImages() {
			const response = await this.$axios.get('http://localhost:3001/api/v1/images/approved')
			console.log(response)
			this.loading = false;
		}
	},

	mounted() {
		this.getApprovedImages()
	}
}
</script>
