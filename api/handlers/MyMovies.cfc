/**
 * My RESTFul Event Handler
 */
component extends="coldbox.system.RestHandler" {

    /**
	* Index
	*/
	any function index( event, rc, prc ){
		prc.response.setData( getInstance( "Movie" ).asMemento().all() );
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

		var movie = getInstance( "Movie" ).create( {
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

		var movie = getInstance( "Movie" )
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

		getInstance( "Movie" )
			.findOrFail( rc.id )
			.delete();

		prc.response.setStatusCode( 200 );
	}


}