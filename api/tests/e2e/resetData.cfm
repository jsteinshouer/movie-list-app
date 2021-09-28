<cfscript>
    coldboxBaseTest = new coldbox.system.testing.BaseTestCase();
    coldboxBaseTest.setup();
    migrationService = application.cbController.getWirebox().getInstance( "MigrationService@cfmigrations" );
    migrationService.runAllMigrations( "down" );
    migrationService.runAllMigrations( "up" );
    
    // getInstance( "Movie" ).deleteAll();
    // queryExecute("ALTER TABLE tablename AUTO_INCREMENT = 1");

</cfscript>