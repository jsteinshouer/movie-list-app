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
		//getInstance( "MigrationService@cfmigrations" ).runAllMigrations( "up" );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Test MyMovies Resource", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			aroundEach( function( spec, suite ){

				transaction {

					// execute the spec
			     	arguments.spec.body();

			     	transaction action="rollback";
				}

			} );

			describe( "GET /mymovies/:id", function(){

				it( "should get something from your movie list", function(){

					var movie = getInstance( "Movie" ).create( {
						"title": "Drop Dead Fred",
						"poster": "https://m.media-amazon.com/images/M/MV5BMDNkZWIzZjktYWNkMi00MTQ2LWIyMTgtMmJhOGRiZDZlNmU4XkEyXkFqcGdeQXVyNTUyMzE4Mzg@._V1_SX300.jpg",
						"imdbID": "tt0101775"
					});

					var event = get( route = "/api/mymovies/" & movie.getID()  );

					
					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().id ).toBe( movie.getID() );
					expect(	response.getData().title ).toBe( "Drop Dead Fred" );
					expect(	response.getData().imdbID ).toBe( "tt0101775" );

				});

			});


			describe( "GET /mymovies", function(){

				it( "should list existing items on the movie list", function(){

					var myMovieList = getInstance( "Movie" );

					var movieListCount = myMovieList.all().len();
					myMovieList.create( {
						"title": "Test 1",
						"poster": "",
						"imdbID": "1234"
					});
					myMovieList.create( {
						"title": "Test 2",
						"poster": "",
						"imdbID": "4567"
					});

					var event = get( route = "/api/mymovies" );

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().len() ).toBe( movieListCount + 2 );
					expect(	response.getData()[movieListCount + 1].imdbID ).toBe( "1234" );

				});

			});


			describe( "POST /mymovies", function(){

				it( "should create a new item on the movie list", function(){

					var event = post(
						route = "/api/mymovies",
						params = {
							"title": "Drop Dead Fred",
							"poster": "https://m.media-amazon.com/images/M/MV5BMDNkZWIzZjktYWNkMi00MTQ2LWIyMTgtMmJhOGRiZDZlNmU4XkEyXkFqcGdeQXVyNTUyMzE4Mzg@._V1_SX300.jpg",
							"imdbID": "tt0101775"
						}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 201 );
					expect(	response.getData().id ).toBeGT( 0 );
					expect(	response.getData().title ).toBe( "Drop Dead Fred" );
					expect(	response.getData().imdbID ).toBe( "tt0101775" );
				});

			});

			describe( "PUT /mymovies/:id", function(){

				it( "should update an existing item on the to watch list", function(){
					
					var movieListItem = getInstance( "Movie" ).create( {
						"title": "Test 1",
						"poster": "/test/path/poster.jpg",
						"imdbID": "1234"
					});

					var event = put(
						route = "/api/mymovies/#movieListItem.getID()#",
						params = {
							title = "My new title",
							poster = "/test/path/poster2.jpg",
							imdbID = "1234"
						}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().id ).toBe( movieListItem.getID() );
					expect(	response.getData().title ).toBe( "My new title" );
					expect(	response.getData().poster ).toBe( "/test/path/poster2.jpg" );
				});

			});


			describe( "DELETE /mymovies/:id", function(){

				it( "should delete an item from the to watch list", function(){

					var movielistItem = getInstance( "Movie" ).create( {
						"title": " Drop dead Fred",
						"poster": "https://m.media-amazon.com/images/M/MV5BMDNkZWIzZjktYWNkMi00MTQ2LWIyMTgtMmJhOGRiZDZlNmU4XkEyXkFqcGdeQXVyNTUyMzE4Mzg@._V1_SX300.jpg",
						"imdbID": "tt0101775"
					});

					var event = delete(
						route = "/api/mymovies/#movielistItem.getID()#"
					);

					var response 	= event.getPrivateValue( "response" );

					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	getInstance( "Movie" ).find( movielistItem.getID() ) ).toBeNull();
				});

			});


		});

	}

}