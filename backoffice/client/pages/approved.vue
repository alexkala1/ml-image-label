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
			headers: [
				{ text: 'dataset', value: 'dataset' },
				{ text: 'dataset_id', value: 'dataset_id' },
				{ text: 'date', value: 'date' },
				{ text: 'email', value: 'email' },
				{ text: 'imageName', value: 'imageName' },
				{ text: 'isHumanChecked', value: 'isHumanChecked' },
				{ text: 'isVerified', value: 'isVerified' },
				{ text: 'object', value: 'object' },
				{ text: 'reviewedAt', value: 'reviewedAt' },
				{ text: 'user_id', value: 'user_id' },
				{ text: '__v', value: '__v' },
				{ text: '_id', value: '_id' },
			],
			approvedImages: [],
		}
	},

	methods: {
		async getApprovedImages() {
			const response = await this.$axios.get(
				'http://localhost:3001/api/v1/images/verified'
			)
			console.log(response)
			this.approvedImages = response.data
			this.loading = false
		},
	},

	mounted() {
		this.getApprovedImages()
	},
}
</script>
