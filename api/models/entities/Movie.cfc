/**
* Movie Bean
*/
component extends="quick.models.BaseEntity" accessors="true" table="my_movies" {

	property name="id" column="my_movies_id";
	property name="title" column="title";
	property name="imdbID" column="imdb_id";
	property name="poster" column="poster";
	property name="userID" column="user_id";

	function user() {
		return belongsTo( "User" );
	 }

}