/*******************************************************************************
*	Integration Test as BDD (CF10+ or Railo 4.1 Plus)
*
*	Extends the integration class: coldbox.system.testing.BaseTestCase
*
*	so you can test your ColdBox application headlessly. The 'appMapping' points by default to
*	the '/root' mapping created in the test folder Application.cfc.  Please note that this
*	Application.cfc must mimic the real one in your root, including ORM settings if needed.
*
*	The 'execute()' method is used to execute a ColdBox event, with the following arguments
*	* event : the name of the event
*	* private : if the event is private or not
*	* prePostExempt : if the event needs to be exempt of pre post interceptors
*	* eventArguments : The struct of args to pass to the event
*	* renderResults : Render back the results of the event
*******************************************************************************/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
		util = new coldbox.system.core.util.Util();
		jwt = new lib.jwt.JWT( key = util.getSystemSetting("JWT_SECRET"), issuer = util.getSystemSetting("JWT_ISSUER") );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Test Authentication", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				structDelete( cookie, util.getSystemSetting( "AUTH_COOKIE_NAME" ), false );
			});

			aroundEach( function( spec, suite ){

				transaction {

					// execute the spec
			     	arguments.spec.body();

			     	transaction action="rollback";
				}

				//delete cookie
				// structDelete( cookie, util.getSystemSetting( "AUTH_COOKIE_NAME" ), false );
				// cfcookie( name = util.getSystemSetting( "AUTH_COOKIE_NAME" ), expires="now" );
				//Reset http response headers
				// to prevent the cookie from being sent to the browser
				getPageContext().getResponse().reset();

			} );

            describe( "POST /authorize", function(){

				it( "should authenticate a user with valid credentials", function(){

					var user = getInstance( "User" ).create( {
						"email": "user@example.com",
						"password": "d*H%frQ^plG"
					});

					var event = post(
						route = "/api/authorize",
						params = {
							"username": "user@example.com",
							"password": "d*H%frQ^plG"
						}
					);

					var response = event.getPrivateValue( "response" );
					
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().isLoggedIn ).toBe( true );
					expect(	response.getData() ).toHaveKey( "expires" );
					
				});


				it( "should issue an auth cookie on successful authentication", function(){

					var user = getInstance( "User" ).create( {
						"email": "user@example.com",
						"password": "d*H%frQ^plG"
					});

					var event = post(
						route = "/api/authorize",
						params = {
							"username": "user@example.com",
							"password": "d*H%frQ^plG"
						}
					);

					var response = event.getPrivateValue( "response" );
					
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().isLoggedIn ).toBe( true );

					var cookies = getPageContext().getResponse().getHeaders("Set-Cookie");
					var authCookieIndex = cookies.find( (i) => { return listFirst(i, "=") == util.getSystemSetting( "AUTH_COOKIE_NAME" ) } );
					expect( authCookieIndex ).toBeGT( 0, "did not find auth cookie" );

					var token = listLast( listFirst( cookies[authCookieIndex], ";"), "=" );
					expect( jwt.decode( token ).sub ).toBe( "user@example.com" );

					
				});
					
                
				it( "should not authenticate a user with invalid credentials", function(){

					var user = getInstance( "User" ).create( {
						"email": "user@example.com",
						"password": "d*H%frQ^plG"
					});

					var event = post(
						route = "/api/authorize",
						params = {
							"username": "user@example.com",
							"password": "notthepassword"
						}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 401 );
	
				});

				it( "should not allow access without a valid authentication cookie", function(){

					var event = get(
						route = "/api/echo",
						params = {}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 401 );
					
				});

				it( "should allow access with a valid authentication cookie", function(){

					var authTokenPayload = {
						"iss" = util.getSystemSetting("JWT_ISSUER"),
						"exp" = dateAdd( "n", util.getSystemSetting("JWT_EXP_MIN"), now() ).getTime(),
						"sub" = "user@example.com"
					};
					var authToken = jwt.encode( authTokenPayload );
					cookie[ util.getSystemSetting( "AUTH_COOKIE_NAME" ) ] = authToken;

					var event = get(
						route = "/api/echo",
						params = {}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					
				});


			});



		});

	}

}