/**
* Movie Bean
*/
component extends="quick.models.BaseEntity" accessors="true" table="my_movies" {

	property name="id" column="p_my_movies";
	property name="title" column="title";
	property name="imdbID" column="imdb_id";
	property name="poster" column="poster";

}