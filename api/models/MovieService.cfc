/**
 * Service to interact with the OMDB API
 * 
 */
component singleton=true accessors=true {

	variables.API_URL="https://www.omdbapi.com/";

	property name="apiKey" inject="coldbox:setting:OMDB_API_KEY";
	
	
	public struct function searchMovies( required string keyword ) {
		var searchURL = API_URL & "?apiKey=" & getAPIKey() & "&s=" & arguments.keyword;
		var httpResponse = "";
		cfhttp( url = searchURL, result="httpResponse"  );

		return deserializeJSON(httpResponse.fileContent);
	}

	public struct function getByImdbID( required string imdbID ) {
		var requestURL = API_URL & "?apiKey=" & getAPIKey() & "&i=" & arguments.imdbID;
		var httpResponse = "";
		cfhttp( url = requestURL, result="httpResponse"  );

		return deserializeJSON(httpResponse.fileContent);
	}
}