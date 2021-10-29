<template>
  <div>
	<div v-if="movieLoaded" class="relative bg-white dark:bg-gray-800 p-4">
		<div class="lg:grid lg:grid-flow-row-dense lg:grid-cols-2 lg:items-center">
			<div class="mt-6 -mx-2 md:-mx-12 relative lg:mt-0 col-start-1">
				<img :src="movie.Poster" alt="illustration" class="poster relative mx-auto shadow-lg rounded w-auto"/>
			</div>
			<div class="col-start-2 sm:mt-6">
				<h1 class="title text-4xl leading-8 font-extrabold text-gray-900 dark:text-white tracking-tight sm:leading-9 mb-6">{{movie.Title}}</h1>
				
				<div class="bg-white max-w-2xl shadow overflow-hidden sm:rounded-lg mr-4">
					<div class="border-t border-gray-200">
						<dl>
							<div class="bg-gray-50 px-1 py-4 sm:grid sm:grid-cols-3 sm:px-6">
								<dt class="text-sm font-medium text-gray-500">Plot</dt>
								<dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{{movie.Plot}}</dd>
							</div>
							<div class="bg-gray-50 px-1 py-4 sm:grid sm:grid-cols-3 sm:px-6">
								<dt class="text-sm font-medium text-gray-500">Rating</dt>
								<dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{{movie.Rated}}</dd>
							</div>
							<div class="bg-white px-1 py-4 sm:grid sm:grid-cols-3 sm:px-6">
								<dt class="text-sm font-medium text-gray-500">Released</dt>
								<dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{{movie.Released}}</dd>
							</div>
							<div class="bg-gray-50 px-1 py-4 sm:grid sm:grid-cols-3 sm:px-6">
								<dt class="text-sm font-medium text-gray-500">Runtime</dt>
								<dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{{movie.Runtime}}</dd>
							</div>
							<div class="bg-white px-1 py-4 sm:grid sm:grid-cols-3 sm:px-6">
								<dt class="text-sm font-medium text-gray-500">Actors</dt>
								<dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{{movie.Actors}}</dd>
							</div>
							<div class="bg-gray-50 px-1 py-4 sm:grid sm:grid-cols-3 sm:px-6">
								<dt class="text-sm font-medium text-gray-500">Genre</dt>
								<dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">{{movie.Genre}}</dd>
							</div>
						</dl>
					</div>
				</div>
				<button v-if="myMoviesLoaded" @click="toggleMyList()" data-cy="toggle-my-list" class="text-right flex justify-end flex-shrink-0 px-4 py-2 mt-5 text-xs font-semibold text-white bg-teal-600 rounded-sm shadow-md hover:bg-teal-700 focus:outline-none focus:ring-2 focus:ring-teal-500 focus:ring-offset-2 focus:ring-offset-teal-200">
					{{toggleButtonText}}
				</button>
			</div>
		</div>
	</div>
  </div>
</template>

<script>
export default {
	name: 'ViewMovie',
	data() {
		return {
			imdbID: this.$route.params.imdbID,
			movie: {},
			myMovieID: 0,
			toggleButtonText: 'ADD TO MY LIST',
			movieLoaded: false,
			myMoviesLoaded: false
		}
	},
	mounted() {
		let vm = this;
		
		this.axios.get( "/api/movie/" + this.imdbID )
			.then((response) => {
				vm.movie = response.data.data;
				vm.movieLoaded = true
			})

		this.axios.get( "/api/mymovies" ).then((response) => {
			let myList = response.data.data;
			let myMovie = myList.find( (element) => element.imdbID === vm.imdbID  );
			vm.myMovieID = (typeof myMovie === 'undefined' ) ? 0 : myMovie.id
			this.toggleButtonText = this.onMyList ? 'REMOVE FROM MY LIST' : 'ADD TO MY LIST';
			vm.myMoviesLoaded = true;
		})

	},
	computed: {
		onMyList() {
			return this.myMovieID > 0;
		}
	},
	methods: {
		toggleMyList() {
			if ( this.myMovieID > 0) {
				this.removeFromMovieList();
			}
			else {
				this.addToMovieList();
			}

		},
		addToMovieList() {
			let vm = this;
			vm.toggleButtonText = "ADDING...";
			this.axios.post( "/api/mymovies", this.movie )
				.then((response) => {
					vm.myMovieID = response.data.data.id;
					vm.toggleButtonText = "REMOVE FROM MY LIST";
				})
				.catch( (error) => {
					console.log( error );
				});
		},
		removeFromMovieList() {
			console.log("not implemented")
		}
	}
}
</script>
