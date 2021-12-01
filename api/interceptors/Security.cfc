/**
 * Security Interceptor
 */
component extends="coldbox.system.Interceptor"{

    property name="handlerService" inject="coldbox:handlerService";
    property name="securityService" inject="provider:security.SecurityService";


    function configure(){}
    
    /**
	 * Use preProcess to check authorization 
	 *
	 * @event
	 * @interceptData
	 * @rc
	 * @prc
	 * @buffer
	 */
	function preProcess( event, interceptData, rc, prc, buffer ){

        var handlerBean = handlerService.getHandlerBean( event.getCurrentEvent() );
        handlerService.getHandler( handlerBean, arguments.event );
        var securedHandler = handlerBean.getHandlerMetadata("secured", false);

        if ( isBoolean(securedHandler) && securedHandler ) {
            var authResult = securityService.checkAuthCookie();
            if ( authResult.validAccessToken ) {
                prc.authorizedUsername = authResult.username;
            }
            else {
                arguments.event.getResponse()
                    .setError( true )
                    .setStatusCode( 401 )
                    .setStatusText( "Unauthorized" )
                    .setData({});
                event.renderData(
                    type            = arguments.prc.response.getFormat(),
                    data            = arguments.prc.response.getDataPacket(),
                    contentType     = arguments.prc.response.getContentType(),
                    statusCode      = arguments.prc.response.getStatusCode(),
                    statusText      = arguments.prc.response.getStatusText(),
                    location        = arguments.prc.response.getLocation(),
                    isBinary        = arguments.prc.response.getBinary(),
                    jsonCallback    = arguments.prc.response.getJsonCallback(),
                    jsonQueryFormat = arguments.prc.response.getJsonQueryFormat()
                ).noExecution();
            }
        }

    }
}