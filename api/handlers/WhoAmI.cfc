/**
 * Reports the currently authenticated user
 */
component extends="coldbox.system.RestHandler" secured="true" {

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
	* Runs before each action
	*/
	any function preHandler( event, rc, prc ){
		prc.user = getInstance("User")
			.where( "email", prc.authorizedUsername )
			.firstOrFail();
	}


	/**
	 * Returns the user that is logged in
	 *
	 * @x-route (GET) /api/whoami
	 */
	function index( event, rc, prc ) {
		event.getResponse().setData( prc.user.getMemento() );
	}

}
