// postcss.config.js
// module.exports = {
// 	plugins: {
// 		tailwindcss: {},
// 		autoprefixer: {},
// 	}
// }

module.exports = {
	plugins: [
		require('autoprefixer'),
		require('tailwindcss')
	]
};