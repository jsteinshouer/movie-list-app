/**
* Validation Result Bean
*/
component accessors="true" {


	/**
	* A collection of error messages
	*/
	property name="errors" type="array";

	/**
	 *
	 * Constructor
	 *
	 */
	function init() {
		variables.errors = [];
	}

	/**
	 *
	 * Add an error message
	 *
	 * @message error message to add to the collection
	 *
	 */
	public void function addError( required string message ) {
		
		errors.append( arguments.message );
	}

	/**
	*
	* Check if the result has errors
	*
	*/
	public boolean function hasErrors() {
		
		return errors.len() > 0;
	}

	/**
	*
	* Generate markup to display errors
	*
	*/
	public string function renderErrors() {
		
		var output = "<ul>";

		for (var error in errors) {
			output &= "<li>" & encodeForHTML(error) & "</li>";
		}

		output &= "</ul>";

		return output;
	}
	

}