/**
 * My RESTFul Event Handler
 */
component extends="coldbox.system.RestHandler" {

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	/**
	 * Dafault action to load the client app
	 */
	function index( event, rc, prc ) {
		event.setView( view = "main/index", noLayout = true );
	}

	/**
	* Run when app starts
	*/
	any function onAppStart( event, rc, prc ) {
		getInstance( "MigrationService@cfmigrations" ).runAllMigrations( "up" ) 
	}

}
