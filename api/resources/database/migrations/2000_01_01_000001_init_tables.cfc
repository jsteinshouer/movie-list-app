component {

	function up( schema, query ){
		schema.dropIfExists( "my_movies" );

		schema.create( "app_users", function(table) {
			table.increments( "user_id" );
			table.string( "email" ).unique();
			table.string( "pword" );
		} );

		schema.create( "my_movies", function(table) {
			table.increments( "my_movies_id" );
			table.string( "title" );
			table.string( "imdb_id" );
			table.string( "poster" ).nullable();
			table.unsignedInteger( "user_id" );
   	 		table.foreignKey( "user_id" ).references( "user_id" ).onTable( "app_users" );
		} );
	}

	function down( schema, query ){
		schema.drop( "my_movies" );
		schema.drop( "app_users" );
	}

}
