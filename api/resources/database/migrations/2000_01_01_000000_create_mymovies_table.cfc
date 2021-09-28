component {

	function up( schema, query ){
		schema.create( "my_movies", function(table) {
			table.increments( "p_my_movies" );
			table.string( "title" );
			table.string( "imdb_id" );
			table.string( "poster" ).nullable();

		} );
	}

	function down( schema, query ){
		schema.drop( "my_movies" );
	}

}
