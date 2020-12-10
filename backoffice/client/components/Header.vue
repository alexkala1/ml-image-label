<template>
	<v-app-bar dark app>
		<v-toolbar-title>Image-Labeling-Backoffice</v-toolbar-title>
		<v-spacer></v-spacer>
		<h2 flat @click="logout()">Log Out</h2>
	</v-app-bar>
</template>

<script>
export default {
	methods: {
		async logout() {
			await this.$auth.logout()
			this.$router.push('/login')
		},
  },
  mounted() {
    console.log(this.$auth)
  }
}
</script>
