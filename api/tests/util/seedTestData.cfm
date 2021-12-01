<cfscript>

    function generateRandomPassword() {
        var charSet = "%^&@!$()_-123456789abcdefghijklmnopqrstuvwxyz".listToArray("");
        var randomString = "";
        for (i = 1; i <= 10; i++) { 
            randomString &= charSet[ randRange(1, charSet.len() ) ];
        }

        return randomString;
    }
    requestBody = getHTTPRequestData().content;
    if (
        len( requestBody ) &&
        isJSON( requestBody )
    ) {
		requestData = deserializeJSON( toString( requestBody ) );
    }
    else {
        requestData = { username: "jane.doe@example.com" };
    }
    coldboxBaseTest = new coldbox.system.testing.BaseTestCase();
    coldboxBaseTest.setAppMapping("/root");
    coldboxBaseTest.setAutowire(true);
    coldboxBaseTest.beforeTests();
    coldboxBaseTest.setup();
    migrationService = coldboxBaseTest.getWirebox().getInstance( "MigrationService@cfmigrations" );
    migrationService.runAllMigrations( "down" );
    migrationService.runAllMigrations( "up" );
    randPassword = generateRandomPassword();
    user = coldboxBaseTest.getWirebox().getInstance( "User" ).create( {
        "email": requestData.username,
        "password": randPassword
    });
    coldboxBaseTest.afterTests();
    cfcontent( type="application/json", reset=true)
    writeOutput( serializeJSON( { "email": user.getEmail(), "password": randPassword } ) );
</cfscript>