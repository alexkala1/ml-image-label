<template>
	<v-container fill-height>
		<v-row justify="center">
			<v-col cols="6">
				<div>
					<v-text-field
						label="Username"
						persisted-hint
						rounded
						outlined
						solo
						type="text"
						name="username"
						v-model="form.username"
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
  auth: false,
	name: "Register",
	components: {},
	data() {
		return {
			form: {
				username: "",
				password: "",
			},
			showError: false,
		};
	},
	methods: {
		async submit() {
			this.$router.push("/login");
		},
	},
};
</script>
