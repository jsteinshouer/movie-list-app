
/* 
 * Security service
 */
component singleton {

	property name="wirebox" inject="wirebox";
	property name="bcrypt" inject="@BCrypt";

	/**
	 * Constructor
	 * 
	 * @jwtSecret.inject coldbox:setting:JWT_SECRET
	 * @jwtIssuer.inject coldbox:setting:JWT_ISSUER
	 * @jwtExpirationinMinutes.inject coldbox:setting:JWT_EXP_MIN
	 * @authCookieName.inject coldbox:setting:AUTH_COOKIE_NAME
	 */
	public SecurityService function init(
		required string jwtSecret,
		required string jwtIssuer,
		required string jwtExpirationinMinutes,
		required string authCookieName
	) {

		variables.jwt =  new lib.jwt.JWT( key = jwtSecret, issuer = jwtIssuer );
		variables.JWT_ISSUER = arguments.jwtIssuer;
		variables.JWT_EXP_MIN = arguments.jwtExpirationinMinutes;
		variables.AUTH_COOKIE_NAME = arguments.authCookieName;

		return this;
	}

	/**
	 * Check user credentials
	 */
	public boolean function checkUserCredentials( required string username, required string password ) {

		var validCredentials = false;

		var user = wirebox.getInstance( "User" ).firstWhere( "email", arguments.username );

		if ( isNull( user) ) {
			bcrypt.hashPassword( arguments.password );
			return false;
		}
		else {
			validCredentials = bcrypt.checkPassword( arguments.password, user.getPassword() );
		}

		return validCredentials;
	}

	/**
	 * Check user credentials
	 */
	public void function issueAuthCookie( required string username ) {
		var authTokenPayload = {
			"iss" = JWT_ISSUER,
			"exp" = dateAdd( "n", JWT_EXP_MIN, now() ).getTime(),
			"sub" = arguments.username
		};
		var authToken = jwt.encode( authTokenPayload );
		cfheader( name="Set-Cookie", value="#AUTH_COOKIE_NAME#=#authToken#;path=/;domain=#listFirst( CGI.HTTP_HOST, ':' )#;HTTPOnly" );
	}

	/**
	 * Check auth cookie
	 */
	public struct function checkAuthCookie() {
		var authResult = {
			validAccessToken = false,
			username = ""
		};
		
		if ( structKeyExists( cookie, AUTH_COOKIE_NAME) ) {
			try {
				var payload = jwt.decode( cookie[AUTH_COOKIE_NAME] );
				authResult.validAccessToken = true;
				authResult.username = payload.sub;
			}
			catch (any e) {}
		}

		return authResult;
	}
}