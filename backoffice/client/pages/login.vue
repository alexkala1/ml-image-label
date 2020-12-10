<template>
	<v-row class="align-center justify-center wrap">
		<v-col cols="12" lg="5" md="6" class="pr-3 pl-6">
			<v-card rounded raised outlined>
				<v-card-title class="justify-center py-5 my-5">
					<h2
						class="font-weight-light text-center"
						style="word-break: break-word"
					>
						Καλωσηρθατε στο my Image-Labeling-Backoffice
					</h2>
				</v-card-title>
				<v-card-text full-height>
					<v-text-field
						prepend-inner-icon="mdi mdi-account"
						label="Email"
						rounded
						outlined
						solo
						type="text"
						name="email"
						v-model="login.email"
					></v-text-field>

					<v-text-field
						prepend-inner-icon="mdi mdi-lock"
						label="Password"
						rounded
						outlined
						solo
						type="password"
						name="password"
						v-model="login.password"
					></v-text-field>
					<v-card-actions class="justify-center">
						<v-btn class="" rounded raised block @click="submit()"
							>Log in
						</v-btn>
					</v-card-actions>
				</v-card-text>
			</v-card>
		</v-col>
	</v-row>
</template>

<script>
export default {
	name: 'Login',
	components: {},
	data() {
		return {
			login: {
				email: '',
				password: '',
			},
			error: '',
		}
	},
	methods: {
		async submit() {
			try {
				let { data } = await this.$auth.loginWith('local', {
					data: this.login,
				})
				await this.$auth.setUserToken(data.response.token)
				this.$router.push('/')
			} catch (error) {
				this.error = error
			}
		},
	},
}
</script>
