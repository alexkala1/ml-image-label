<template>
	<v-container fluid pa-0 ma-0>
		<v-app-bar dark app>
			<v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>

			<v-toolbar-title>
				<v-btn text plain to="/"> Image-Labeling-Backoffice </v-btn>
			</v-toolbar-title>

		</v-app-bar>
		<v-navigation-drawer
			v-model="drawer"
			app
			absolute
			temporary
			class="d-print-none"
		>
			<v-list-item v-if="$auth.loggedIn">
				<v-list-item-content>
					<v-list-item-title class="title">
						{{ $auth.user.name }} {{ $auth.user.last_name }}
					</v-list-item-title>
					<v-list-item-subtitle>
						{{ $auth.user.email }}
					</v-list-item-subtitle>
				</v-list-item-content>
			</v-list-item>

			<v-divider></v-divider>

			<v-list nav dense>
				<v-list-item-group
					v-model="group"
					active-class="deep-purple--text text--accent-4"
				>
					<v-list-item
						v-for="(route, i) in routes"
						:key="i"
						@click="$router.push({ path: route.path })"
					>
						<v-list-item-title>{{ route.name }}</v-list-item-title>
					</v-list-item>
				</v-list-item-group>
			</v-list>
			<template #append>
				<div class="pa-2">
					<v-btn block rounded color="primary" @click="logout()">
						Logout
					</v-btn>
				</div>
			</template>
		</v-navigation-drawer>
	</v-container>
</template>

<script>
export default {
	data() {
		return {
			drawer: false,
			group: null,
			routes: [
				{
					path: '/',
					name: 'Home',
				},
				{
					path: '/history',
					name: 'History',
				},
				{
					path: '/datasets',
					name: 'Datasets',
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

	watch: {
		group() {
			this.drawer = false
		},
	},
}
</script>
<style scoped>
.v-toolbar__title {
	overflow: visible;
}
</style>