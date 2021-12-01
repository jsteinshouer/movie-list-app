<template>
	<div class="Search container">
		<!-- <div class="mt-3 mb-5 relative rounded-md shadow-sm h-18">
		<input type="text" name="search" id="search" class="h-15 block w-full pl-7 pr-12 sm:text-sm border-gray-500 rounded-md" placeholder="Search">
		</div> -->
		<div class="mb-4 flex flex-col md:flex-row w-3/4 md:w-full max-w-sm md:space-x-3 space-y-3 md:space-y-0 justify-center"  v-on:keyup.enter="search">
			<input id="search" type="text" v-model="keyword" class="rounded-lg border-transparent flex-1 appearance-none border border-gray-300 w-full py-2 px-4 bg-white text-gray-700 placeholder-gray-400 shadow-sm text-base focus:outline-none focus:ring-2 focus:ring-teal-600 focus:border-transparent" placeholder="Search" />
			<button @click="search" data-cy="btn-search" class="flex-shrink-0 px-4 py-2 text-base font-semibold text-white bg-teal-600 rounded-lg shadow-md hover:bg-teal-700 focus:outline-none focus:ring-2 focus:ring-teal-500 focus:ring-offset-2 focus:ring-offset-teal-200" type="submit">
			Search
			</button>
		</div>
		<List>
			<ListLoader v-if="loading" />
			<div v-if="!loading">
			<ListItem v-for="movie in movies" :key="movie.imdbID" :movie="movie" />
			</div>
		</List>
	</div>
</template>

<script>
import List from '@/components/List';
import ListItem from '@/components/ListItem';
import ListLoader from '@/components/ListLoader';
export default {
	name: 'Search',
	data() {
		return {
			keyword: "",
			searchResults: {},
			loading: false
		}
	},
	components: {
		List,
		ListItem,
		ListLoader
	},
	mounted() {
		
	},
	computed: {
		movies() {
			return this.searchResults.Search ? this.searchResults.Search : [];
		}
	},
	methods: {
		search() {
			let vm = this;
			this.loading = true;
			
			this.axios.get( "/api/search?keyword=" + vm.keyword ).then((response) => {
				vm.searchResults = response.data.data;
				this.loading = false;
			})

		}
	}
}
</script>
