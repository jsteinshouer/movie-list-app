/**
 * My RESTFul Event Handler
 */
component extends="coldbox.system.RestHandler" secured="true" {



    /**
	* Runs before each action
	*/
	any function preHandler( event, rc, prc ){
		prc.user = getInstance("User")
			.where( "email", prc.authorizedUsername )
			.firstOrFail();
	}

    /**
	* Index
	*/
	any function index( event, rc, prc ){
		prc.response.setData( prc.user.getMovies().map( (i) => { return i.getMemento(); }) );
	}


    /**
	* Read a movie from my movie list
	*/
	any function show( event, rc, prc ){
		prc.response.setData( 
			getInstance( "Movie" )
				.findOrFail( rc.id )
				.getMemento()
		);
	}

    /**
	* Add a new movie to the list
	*/
	any function create( event, rc, prc ){

		var movie = prc.user.movies().create( {
			"title": rc.title,
			"poster": rc.poster,
            "imdbID": rc.imdbID
		});

		prc.response.setData( movie.getMemento() );
		prc.response.setStatusCode( 201 );
	}

    /**
	* Update a movie on the list
	*/
	any function update( event, rc, prc ){

		var movie =prc.user.movies()
			.findOrFail( rc.id )
			.update( {
				"title": rc.title,
				"poster": rc.poster,
                "imdbID": rc.imdbID
			});

		prc.response.setData( movie.getMemento() );
		prc.response.setStatusCode( 200 );
	}

    /**
	* Delete a movie from the list
	*/
	any function delete( event, rc, prc ){

		prc.user.movies()
			.findOrFail( rc.id )
			.delete();

		prc.response.setStatusCode( 200 );
	}


}