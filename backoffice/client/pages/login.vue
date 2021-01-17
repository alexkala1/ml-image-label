<template>
	<v-row class="align-center justify-center wrap">
		<v-snackbar
			v-model="snackbar"
			top
			right
			:color="snackbarColor"
			vertical
			elevation="24"
		>
			{{ message }}

			<template v-slot:action="{ attrs }">
				<v-btn text v-bind="attrs" @click="snackbar = false">
					Close
				</v-btn>
			</template>
		</v-snackbar>
		<v-col cols="12" lg="5" md="6" class="pr-3 pl-6">
			<v-card rounded raised outlined>
				<v-card-title class="justify-center py-5 my-5">
					<h2
						class="font-weight-light text-center"
						style="word-break: break-word"
					>
						Login to my Image-Labeling-Backoffice
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
			snackbar: false,
			snackbarColor: '',
			message: '',
		}
	},
	methods: {
		async submit() {
			let { data } = await this.$auth.loginWith('local', {
				data: this.login,
			})

			try {
				await this.$auth.setUserToken(data.response.token)

				this.snackbar = true
				this.snackbarColor = 'green'
				this.message = 'Login Successful'

				location.reload()
			} catch (error) {
				this.message = data.error
				this.snackbar = true
				this.snackbarColor = 'red'
			}
		},
	},
}
</script>
