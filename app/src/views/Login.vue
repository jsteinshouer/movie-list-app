<template>
		<div class="bg-grey-lighter min-h-screen flex flex-col">
					<div class="container max-w-lg mx-auto flex-1 flex flex-col items-center px-2 mt-10">
							<div class="bg-white px-6 py-8 rounded shadow-md text-black w-full" v-on:keyup.enter="login">
									<h1 class="mb-8 text-4xl text-center">Login</h1>

									<input 
											type="text"
											class="block border border-grey-light w-full p-3 rounded mb-4"
											name="email"
											placeholder="Email"
											v-model="account.username" />

									<input 
											type="password"
											class="block border border-grey-light w-full p-3 rounded mb-4"
											name="password"
											placeholder="Password"
											v-on:keyup.enter="signup"
											v-model="account.password" />

									<button
											@click="login"
											:disabled="loading"
											class="w-full text-center py-3 rounded bg-teal-600 text-white disabled:opacity-80 focus:outline-none my-1"
											:class="{'hover:bg-teal-700': !loading, 'cursor-wait': loading}"
									>{{buttonText}}</button>
									<p class="text-lg text-red-600" data-cy="error-msg">{{errorMessage}}</p>
							</div>

							<div class="text-grey-dark mt-6">
									Don't have an account? 
									<router-link class="no-underline border-b border-blue text-blue" to="/signup">
											Signup
									</router-link>.

							</div>
					</div>
			</div>
</template>

<script>
import store from '../store.js';
export default {
	name: 'Signup',
	data() {
		return {
			loading: false,
			account: {
				username: "",
				password: ""
			},
			errorMessage: ""
		}
	},
	computed: {
		buttonText() {
			return this.loading ? "Processing..." : "Login";
		}
	},
	mounted() {
			
	},
	methods: {
		login() {
			let vm = this;

			if ( this.account.username == "" ) {
				this.errorMessage = "Please provide a username.";
				return false;
			}
			if ( this.account.password.length == 0 ) {
				this.errorMessage = "Please provide a password.";
				return false;
			}

			this.loading = true;
			this.axios.post( "/api/authorize", this.account )
				.then((response) => {
					vm.loading = false;
					store.isLoggedIn = response.data.data.isLoggedIn;
					this.$router.push( { name: "MyMovies" }).catch(err => { console.log(err) });
				})
				.catch( (error) => {
					if ( error.response.status === 401 ) {
						vm.errorMessage = "Invalid credentials.";
					}
					else if ( error.response.data.messages.length ) {
						vm.errorMessage = error.response.data.messages[0];
					}
					else {
						vm.errorMessage = "Login failed.";
					}
					vm.loading = false;
				});

		}
	}
}
</script>
