<template>
		<div>
		<li v-for="n in 3" :key="n" class="border-gray-400 flex flex-row mb-2">
			<div class="transition duration-500 shadow ease-in-out transform select-none cursor-pointer bg-white dark:bg-gray-800 rounded-md flex flex-1 items-center p-4">
				<div class="flex flex-col w-16 h-16 justify-center items-center mr-4">
					<a href="#" class="block relative">
						<div class=" bg-gray-200 animate-pulse mx-auto object-cover rounded-full h-16 w-16 "/>
					</a>
				</div>
				<div class="flex-1 pl-1 md:mr-16">
					<div class="bg-gray-200 animate-pulse h-4 w-24 rounded-md"></div>
					<div class="bg-gray-200 animate-pulse h-4 w-16 rounded-md my-3 text-sm"></div>
				</div>
			</div>
		</li>
		</div>
</template>

<script>
export default {

}
</script>

<style>

</style>