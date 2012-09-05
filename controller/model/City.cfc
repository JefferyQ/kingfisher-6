<cfcomponent>
	<cffunction name="AddCity" access="public">
		<cfargument name="ReturnFormat" type="string" required="yes">
		<cfargument name="City_Name" type="string" required="yes">
		<cfargument name="APIToken" type="string" required="no">
		
		<cfset rtn = StructNew()>
		
		<!--- Check we've received an API Token, otherwise do not delete --->
		<cfif IsDefined("ARGUMENTS.APIToken") AND ARGUMENTS.APIToken EQ 'raiseatree12'>
			<!--- Add the city --->
			<cfquery name="rsAddCity" datasource="#Application.DataSource#" result="newCity">
				INSERT INTO cities (city_name) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="50" value="#ARGUMENTS.City_Name#">);
			</cfquery>
			
			<cfset rtn.result = true>
			<cfset rtn.message = 'City added successfully'>
			<cfset SESSION.success = 'City Added Successfully'>
			<cfset rtn.redirect = 'home.cfm'>
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Insufficient access to editing entry'>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
		
	<cffunction name="GetCities" access="public">
		<cfargument name="ReturnFormat" type="string" required="yes">
		
		<cfset rtn = StructNew()>
		
		<!--- Get a list of cities --->
		<cfquery name="rsGetCities" datasource="#Application.DataSource#">
			SELECT * FROM cities
			ORDER BY city_name;
		</cfquery>
		
		<cfset rtn.data = rsGetCities>
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
</cfcomponent>