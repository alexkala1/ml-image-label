<template>
	<v-container fill-height>
		<v-row justify="center">
			<v-col cols="6">
				<div>
					<v-text-field
						label="Email"
						persisted-hint
						rounded
						outlined
						solo
						type="text"
						name="email"
						v-model="form.email"
					></v-text-field>
				</div>
				<div>
					<v-text-field
						label="First Name"
						persisted-hint
						rounded
						outlined
						solo
						type="text"
						name="firstName"
						v-model="form.firstName"
					></v-text-field>
				</div>
				<div>
					<v-text-field
						label="Last Name"
						persisted-hint
						rounded
						outlined
						solo
						type="text"
						name="lastName"
						v-model="form.lastName"
					></v-text-field>
				</div>
				<div>
					<v-text-field
						label="Password"
						persisted-hint
						rounded
						outlined
						solo
						type="password"
						name="password"
						v-model="form.password"
					></v-text-field>
				</div>
				<v-btn rounded @click="submit()">Submit</v-btn>
				<v-alert v-if="showError" id="error"
					>Email already exists</v-alert
				>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
export default {
	name: 'Register',
	components: {},
	data() {
		return {
			form: {
				email: '',
				firstName: '',
				lastName: '',
				userType: 'admin',
				password: '',
			},
			showError: false,
		}
	},
	methods: {
		async submit() {
			const user = await this.$axios.post('/auth/register', this.form)
			console.log(user)
			this.$router.push('/login')
		},
	},
}
</script>
