/**
* User Bean
*/
component extends="quick.models.BaseEntity" accessors="true" table="app_users" {

    property name="bcrypt" inject="@BCrypt" persistent="false";

	property name="id" column="user_id";
	property name="email" column="email";
	property name="password" column="pword";

    function movies() {
       return hasMany( "Movie" );
    }

    public User function setPassword( required string password ){
		return assignAttribute( "password", bcrypt.hashPassword( arguments.password ) );
	}

    public struct function getMemento(){
		return { "id": variables.getID(), "email" : variables.getEmail() };
	}

}