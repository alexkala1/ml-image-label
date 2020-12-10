<template>
	<v-app dark>
		<Header v-if="$auth.loggedIn"/>
		<v-main>
			<v-container fill-height fluid>
				<nuxt />
			</v-container>
		</v-main>
		<Footer />
	</v-app>
</template>

<script>
export default {
	data() {
		return {}
	},
}
</script>
<style scoped>
#app {
  font-family: "Nunito";
}
</style>
