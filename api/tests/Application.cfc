﻿/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component{

	// APPLICATION CFC PROPERTIES
	this.name 				= "ColdBoxTestingSuite" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan( 0, 0, 15, 0 );
	this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );
	this.setClientCookies 	= true;

	// Create testing mapping
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	// Map back to its root
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings["/root"]   = rootPath;
	this.mappings["/models"]   = rootPath & "/models";
	this.mappings[ "/quick" ] = rootPath & "/modules/quick";
	this.mappings[ "/cfmigrations" ] = rootPath & "/modules/cfmigrations";

	this.datasources["MyMovies"] = {
		class: server.system.environment.DB_CLASS
		, bundleName: server.system.environment.DB_BUNDLENAME
		, bundleVersion: server.system.environment.DB_BUNDLEVERSION
		, connectionString: server.system.environment.DB_CONNECTIONSTRING
		, username: server.system.environment.DB_USER
		, password: server.system.environment.DB_PASSWORD
	};
	this.datasource = "MyMovies";

	public void function onRequestEnd() {
		if( !isNull( application.cbController ) ){
			application.cbController.getLoaderService().processShutdown();
		}
		structDelete( application, "cbController" );
		structDelete( application, "wirebox" );
	}
}