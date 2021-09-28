component {

	function configure() {
		// Set Full Rewrites
		setFullRewrites( true );

		/**
		 * --------------------------------------------------------------------------
		 * App Routes
		 * --------------------------------------------------------------------------
		 *
		 * Here is where you can register the routes for your web application!
		 * Go get Funky!
		 *
		 */

		// A nice healthcheck route example
		route( "/healthcheck", function( event, rc, prc ) {
			return "Ok!";
		} );

		addNamespace( namespace="api", pattern="/api" );
		// API Echo
		route( "/echo")
			.withNamespace("api")
			.withAction({
				GET: "index" 
			})
			.toHandler("Echo");
		route( "/movie/:imdbID")
			.withNamespace("api")
			.withAction({
				GET: "index" 
			})
			.toHandler("ViewMovie");
		route( "/search")
			.withNamespace("api")
			.withAction({
				GET: "index" 
			})
			.toHandler("Search");		

		resources( resource = "mymovies", namespace="api" );

		// Conventions based routing
		route( ":handler/:action?" ).end();
	}

}
