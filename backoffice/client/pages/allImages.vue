<template>
	<v-container>
		<v-row justify="center" align="center">
			<v-col cols="4" sm="6" md="3" v-for="i in 10" :key="i">
				<v-skeleton-loader
					:loading="loading"
					:transition="transition"
					type="card, actions"
				>
					<v-card class="mx-auto" max-width="400">
						<v-img
							class="white--text align-end"
							height="200px"
							src="https://cdn.vuetifyjs.com/images/cards/docks.jpg"
						>
							<v-card-title
								>Top 10 Australian beaches</v-card-title
							>
						</v-img>
						<v-card-subtitle class="pb-0"
							>Number {{ i }}</v-card-subtitle
						>
						<v-card-text class="text--primary">
							<div>Whitehaven Beach</div>
							<div>Whitsunday Island, Whitsunday Islands</div>
						</v-card-text>
						<v-card-actions>
							<v-btn color="orange" text> Share </v-btn>
							<v-btn color="orange" text> Explore </v-btn>
						</v-card-actions>
					</v-card>
				</v-skeleton-loader>
			</v-col>
		</v-row>
		<v-row justify="center" align="center" v-if="loading === false">
			<v-pagination
				v-model="page"
				class="my-4"
				:total-visible="7"
				:length="15"
				circle
			></v-pagination>
		</v-row>
		<v-row justify="center" align="center" v-else>
			<v-progress-circular class="my-4" indeterminate>
      </v-progress-circular>
		</v-row>
	</v-container>
</template>

<script>
import Logo from '~/components/Logo.vue'
import VuetifyLogo from '~/components/VuetifyLogo.vue'

export default {
	data() {
		return {
			loading: true,
			page: 1,
			transition: 'scale-transition',
		}
	},
	components: {
		Logo,
		VuetifyLogo,
	},

	methods: {},

	mounted() {
		this.$nextTick(function () {
			window.setInterval(() => {
				this.loading = false
			}, 2000)
		})
	},
}
</script>
