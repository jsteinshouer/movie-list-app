<template>
	<div class="container">
		<List>
			<ListLoader v-if="loading" />
			<div v-if="!loading">
			<ListItem v-for="movie in mymovies" :key="movie.imdbID" :movie="{ Poster: movie.poster, Title: movie.title, imdbID: movie.imdbID, Year: '' }" />
			</div>
		</List>
	</div>
</template>

<script>
import List from '@/components/List';
import ListItem from '@/components/ListItem';
import ListLoader from '@/components/ListLoader';
export default {
	name: 'MyMovies',
	data() {
		return {
			mymovies: [],
			loading: false
		}
	},
	components: {
		List,
		ListItem,
		ListLoader
	},
	mounted() {
		this.loadMovies();
	},
	computed: {

	},
	methods: {
		loadMovies() {
			let vm = this;
			this.loading = true;
			
			this.axios.get( "/api/mymovies" ).then((response) => {
				vm.mymovies = response.data.data;
				this.loading = false;
			})

		}
	}
}
</script>
