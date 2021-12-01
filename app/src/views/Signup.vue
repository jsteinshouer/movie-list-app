<template>
		<div class="bg-grey-lighter min-h-screen flex flex-col">
					<div class="container max-w-lg mx-auto flex-1 flex flex-col items-center px-2 mt-10">
							<div class="bg-white px-6 py-8 rounded shadow-md text-black w-full" v-on:keyup.enter="signup">
									<h1 class="mb-8 text-4xl text-center">Sign up</h1>

									<input 
											type="text"
											class="block border border-grey-light w-full p-3 rounded mb-4"
											name="email"
											placeholder="Email"
											v-model="account.email" />

									<input 
											type="password"
											class="block border border-grey-light w-full p-3 rounded mb-4"
											name="password"
											placeholder="Password"
											v-model="account.password" />
									<input 
											type="password"
											class="block border border-grey-light w-full p-3 rounded mb-4"
											name="confirm_password"
											placeholder="Confirm Password"
											v-model="confirmPassword" />

									<button
											@click="signup" 
											:disabled="loading"
											class="w-full text-center py-3 rounded bg-teal-600 text-white disabled:opacity-80 focus:outline-none my-1"
											:class="{'hover:bg-teal-700': !loading, 'cursor-wait': loading}"
									>{{buttonText}}</button>
									<p class="text-lg text-red-600" data-cy="error-msg">{{errorMessage}}</p>
									<!-- <div class="text-center text-sm text-grey-dark mt-4">
											By signing up, you agree to the 
											<a class="no-underline border-b border-grey-dark text-grey-dark" href="#">
													Terms of Service
											</a> and 
											<a class="no-underline border-b border-grey-dark text-grey-dark" href="#">
													Privacy Policy
											</a>
									</div> -->
							</div>

							<div class="text-grey-dark mt-6">
									Already have an account? 
									<router-link class="no-underline border-b border-blue text-blue" to="/login">
											Log in
									</router-link>.

							</div>
					</div>
			</div>
</template>

<script>
export default {
	name: 'Signup',
	data() {
		return {
			loading: false,
			account: {
				email: "",
				password: ""
			},
			confirmPassword: "",
			errorMessage: ""
		}
	},
	computed: {
		buttonText() {
			return this.loading ? "Processing..." : "Create Account";
		}
	},
	methods: {
		signup() {
			let vm = this;

			if ( this.account.email == "" ) {
				this.errorMessage = "Please provide an email.";
				return false;
			}
			if ( this.account.password.length == 0 ) {
				this.errorMessage = "Please provide a password.";
				return false;
			}

			if ( this.account.password != this.confirmPassword ) {		
				this.errorMessage = "Password and Confirm Password do not match.";
				return false;
			}

			this.loading = true;
			this.axios.post( "/api/signup", this.account )
				.then((response) => {
					vm.loading = false;
					this.$router.push( { name: "SignupConfirmation", params: response.data.data });
				})
				.catch( (error) => {
					vm.errorMessage = error.response.data.messages[0];
					this.loading = false;
				});

		}
	}
}
</script>
