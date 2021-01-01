<template>
	<v-row align="center" justify="center">
		<v-col cols="3">
       <v-card height="700">
              <v-card-title class="subheading font-weight-bold">tost.jpeg</v-card-title>

              <v-divider></v-divider>

              <v-list dense>
                <v-list-item>
                  <v-list-item-content>Uploaded By:</v-list-item-content>
                  <v-list-item-content class="align-end">test@tost.com</v-list-item-content>
                </v-list-item>

                <v-list-item>
                  <v-list-item-content>User ID:</v-list-item-content>
                  <v-list-item-content class="align-end">700cd8ad87d49dda</v-list-item-content>
                </v-list-item>

                <v-list-item>
                  <v-list-item-content>Dataset:</v-list-item-content>
                  <v-list-item-content class="align-end">some dataset(?)</v-list-item-content>
                </v-list-item>

                <v-list-item>
                  <v-list-item-content>Dataset ID:</v-list-item-content>
                  <v-list-item-content class="align-end">d9a86f96cb922191</v-list-item-content>
                </v-list-item>

                <v-list-item>
                  <v-list-item-content>Is Verified:</v-list-item-content>
                  <v-list-item-content class="align-end">Maybe</v-list-item-content>
                </v-list-item>

                <v-list-item>
                  <v-list-item-content>Objects:</v-list-item-content>
                  <!-- Here we loop for each object in array of objects -->
                  <v-list-item-content class="align-end">horse @ 152, 152 250 500, bike  @ 152, 152 250 500</v-list-item-content>
                </v-list-item>

                <v-list-item>
                  <v-list-item-content>Uploaded At:</v-list-item-content>
                  <v-list-item-content class="align-end">{{ properDate() }}</v-list-item-content>
                </v-list-item>
              </v-list>
            </v-card>

    </v-col>
		<v-col cols="9">
			<v-img
        max-height="700"
        contain
				:src="`https://picsum.photos/500/300?image=${id * 5 + 10}`"
				:lazy-src="`https://picsum.photos/10/6?image=${id * 5 + 10}`"
				class="grey lighten-2"
			>
				<template v-slot:placeholder>
					<v-row
						class="fill-height ma-0"
						align="center"
						justify="center"
					>
						<v-progress-circular
							indeterminate
							color="grey lighten-5"
						></v-progress-circular>
					</v-row>
				</template>
			</v-img>
		</v-col>
	</v-row>
</template>

<script>
import moment from 'moment'

export default {
	asyncData({ params }) {
		return {
			id: params.id,
		}
  },
  methods: {
    properDate () {
      return moment().format('MMMM Do YYYY, h:mm:ss a');
    }
  }
}
</script>

<style>
</style>
