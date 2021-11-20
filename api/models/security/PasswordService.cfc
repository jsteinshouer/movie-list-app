
/* 
* Password service
*/
component singleton {

	property name="passwordEstimator" inject="security.PasswordStrengthEstimator";
	property name="wirebox" inject="wirebox";

    /**
	* Check if a password is valid
	*/
	public ValidationResult function validatePassword( required string password ) {

		var validationResult = wirebox.getInstance("util.ValidationResult");

		/* Must be at least 8 characters long */
		if ( arguments.password.len() < 8 ) {
			validationResult.addError("The password must be at least 8 characters.");
		}

		/* Make sure estimator score is not too weak */
		var estimate = passwordEstimator.estimate( arguments.password );
		if ( estimate.getScore() < 2 ) {

			var message = "The password is too weak.";
			if ( estimate.getWarning().len() ) {
				message &= " " & estimate.getWarning();
			}

			message &= " " & estimate.getSuggestions().toList(", ");
			validationResult.addError(message);
		}

		return validationResult;
	}
}