<template>
	<v-app-bar dark app>
		<v-toolbar-title>
			<v-btn text plain to="/"> Image-Labeling-Backoffice </v-btn>
		</v-toolbar-title>
		<v-tabs centered show-arrows>
			<v-tab v-for="route in routes" :key="route.path" :to="route.path">
				{{ route.name }}
			</v-tab>
		</v-tabs>
		<v-btn text @click="logout()">Log Out</v-btn>
	</v-app-bar>
</template>

<script>
export default {
	data() {
		return {
			routes: [
				{
					path: '/approved',
					name: 'Approved Images',
				},
				{
					path: '/rejected',
					name: 'Rejected Images',
				},
				{
					path: '/allImages',
					name: 'All Images',
				},
				{
					path: '/history',
					name: 'History',
				},
			],
		}
	},
	methods: {
		async logout() {
			await this.$auth.logout()
			this.$router.push('/login')
		},
	},
}
</script>
<style scoped>
.v-toolbar__title {
	overflow: visible;
}
</style>