<cfscript>
    coldboxBaseTest = new coldbox.system.testing.BaseTestCase();
    coldboxBaseTest.setup();
    migrationService = application.cbController.getWirebox().getInstance( "MigrationService@cfmigrations" );
    migrationService.runAllMigrations( "down" );
    migrationService.runAllMigrations( "up" );
</cfscript>