/**
 * My RESTFul Event Handler
 */
component extends="coldbox.system.RestHandler" secured="true" {

	property name="movieService" inject="MovieService";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};

	/**
	 * Search movie's from OMDB
	 *
	 * @x-route (GET) /api/search
	 * @response-default ~echo/index/responses.json##200
	 */
	function index( event, rc, prc ) {

		event.getResponse().setData( movieService.searchMovies( rc.keyword ) );
	}

}
