module.exports = {
    assetsDir: "assets",
	devServer: {
		port: 3000,
		proxy: 'http://movie-app-api:8080'
	}
}