<template>
	<v-container fluid>
		<v-row align="center" justify="center" no-gutters>
			<v-col cols="12">
				<v-card>
					<v-card-title>
						History
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
						:items="history"
						:search="search"
						:loading="loading"
						loading-text="Loading... Please wait"
					></v-data-table>
				</v-card>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
export default {
	data() {
		return {
			search: '',
			loading: true,
			headers: [
				{ text: 'Dataset', value: 'dataset' },
				{ text: 'Dataset Id', value: 'dataset_id' },
				{ text: 'Date', value: 'date' },
				{ text: 'Email', value: 'email' },
				{ text: 'Image', value: 'imageName' },
				{ text: 'Reviewed', value: 'isHumanChecked' },
				{ text: 'Verified', value: 'isVerified' },
				{ text: 'Object', value: 'object' },
				{ text: 'Reviewed At', value: 'reviewedAt' },
				{ text: 'User ID', value: 'user_id' },
				{ text: 'ID', value: '_id' },
			],
			history: [],
		}
	},

	methods: {
		async fetchHistory() {
			try {
				const { data } = await this.$axios.get(
					'http://localhost:3001/api/v1/images/history'
				)
				this.history = data
				this.loading = false
			} catch (error) {
				alert(error)
				this.loading = false
			}
		},
	},

	mounted() {
		this.fetchHistory()
	},
}
</script>
