<cfcomponent>
	<cffunction name="AddOffer" access="public">
		<cfargument name="cID" type="numeric" required="yes">
		<cfargument name="eID" type="numeric" required="yes">
		<cfargument name="offer_code" type="string" required="yes">
		<cfargument name="date_start" type="string" required="yes">
		<cfargument name="date_finish" type="string" required="yes">
		<cfargument name="offer_desc" type="string" required="yes">
		<cfargument name="APIToken" type="string" required="no">
		
		<cfset rtn = StructNew()>
		
		<!--- Check we've received an API Token, otherwise do not delete --->
		<cfif IsDefined("ARGUMENTS.APIToken") AND ARGUMENTS.APIToken EQ 'raiseatree12'>
		
			<!--- Add the city --->
			<cfquery name="rsAddOffer" datasource="#Application.DataSource#">
				INSERT INTO offers (eID,offer_code,date_start,date_finish,offer_desc) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.eID#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.offer_code#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(ARGUMENTS.date_start,'yyyy-mm-dd')#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(ARGUMENTS.date_finish,'yyyy-mm-dd')#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.offer_desc#">);
			</cfquery>
			
			<cfset rtn.result = true>
			<cfset rtn.message = 'Offer added successfully'>
			<cfset rtn.redirect = 'view-offers.cfm?catID=5'>
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Insufficient access to add offer'>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="DeleteOffer" access="public">
		<cfargument name="offerID" type="numeric" required="yes">
		<cfargument name="APIToken" type="string" required="no">
		
		<cfset rtn = StructNew()>

		<!--- Check we've received an API Token, otherwise do not delete --->
		<cfif IsDefined("ARGUMENTS.APIToken") AND ARGUMENTS.APIToken EQ 'raiseatree12'>
			
			<!--- Delete the offer --->
			<cftry>
				<cfquery name="rsDel" datasource="#Application.DataSource#">
					DELETE FROM offers WHERE offerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.offerID#"> LIMIT 1;
				</cfquery>
				
				<cfset rtn.result = true>
				<cfset rtn.message = 'Deleted offer successfully'>
				<cfset rtn.redirect = 'view-offers.cfm?message=DeletedOffer'>
				
				<cfcatch type="any">
					<cfset rtn.result = false>
					<cfset rtn.message = 'Could not delete entry'>
				</cfcatch>
			</cftry>
		
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Insufficient access to deleting offer'>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="EditOffer" access="public">
		<cfargument name="offerID" type="numeric" required="yes">
		<cfargument name="offer_code" type="string" required="yes">
		<cfargument name="date_start" type="date" required="yes">
		<cfargument name="date_finish" type="date" required="yes">
		<cfargument name="offer_desc" type="string" required="yes">
		<cfargument name="APIToken" type="string" required="no">
		
		<!--- Create return --->
		<cfset rtn = StructNew()>
		
		<!--- Check we've received an API Token, otherwise do not delete --->
		<cfif IsDefined("ARGUMENTS.APIToken") AND ARGUMENTS.APIToken EQ 'raiseatree12'>
			
			<!--- Edit the offer --->
			<cftry>
				<cfquery name="rsUpdate" datasource="#Application.DataSource#">
					UPDATE offers 
						SET offer_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.offer_code#">, 
						date_start = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(ARGUMENTS.date_start,'yyyy-mm-dd')#">, 
						date_finish = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(ARGUMENTS.date_finish,'yyyy-mm-dd')#">, 
						offer_desc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.offer_desc#">
					WHERE offerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.offerID#">;
				</cfquery>
				
				<cfset rtn.result = true>
				<cfset rtn.message = 'Edited offer successfully'>
				<cfset rtn.redirect = 'view-offers.cfm?message=EditedOffer'>
				
				<cfcatch type="any">
					<cfset rtn.result = false>
					<cfset rtn.message = 'Could not edit entry'>
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Insufficient access to edit offer'>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="GetOffers" access="public">
		<cfargument name="showAll" type="string" required="no">
		<cfargument name="offerID" type="numeric" required="no">
		<cfargument name="cID" type="numeric" required="no">
		
		<cfset rtn = StructNew()>
		
		<!--- Get the list of offers --->
		<cfquery name="rsGetOffers" datasource="#Application.DataSource#">
			SELECT * FROM entries
				INNER JOIN offers ON offers.eID = entries.eID
			<cfif Not(IsDefined("ARGUMENTS.showAll"))>
				WHERE date_start >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(GetHttpTimeString(now()),'yyyy-mm-dd')#">
				AND date_finish <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(GetHttpTimeString(now()),'yyyy-mm-dd')#">
				AND cID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cID#">
			</cfif>
			<cfif IsDefined("ARGUMENTS.offerID")>
				WHERE offerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.offerID#">
				LIMIT 1	
			</cfif>;
		</cfquery>
		
		<cfif rsGetOffers.RecordCount GT 0>
			<cfset rtn.result = true>
			<cfset rtn.data = rsGetOffers>
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = "Couldn't find any offers to display">
		</cfif>
		
		<cfreturn rtn>
		
	</cffunction>
	
	<cffunction name="RecordView">
		<cfargument name="offerID" type="numeric" required="yes" />
		<cfargument name="uuid" type="string" required="yes" />
		<cfargument name="locale" type="string" required="yes" />
		
		<cftry>
			<!--- Create the return doc --->
			<cfset rtn = StructNew()>
				
			<!--- Work out the date time stamp --->
			<cfset dateTimeStamp = DateFormat(now(),'yyyy-mm-dd') & ' ' & TimeFormat(now(),'HH:MM:SS')>
			
			<!--- Insert into the db --->
			<cfquery name="rsAdd" datasource="#Application.DataSource#">
				INSERT INTO offer_views (offerID,uuID,dateTimeStamp,locale) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.offerID#"/>,  
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="40" value="#ARGUMENTS.uuID#"/>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="40" value="#dateTimeStamp#"/>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="100" value="#ARGUMENTS.locale#"/>)
			</cfquery>
		
			<cfset rtn.result = true>
			<cfset rtn.message = 'View recorded ok'>
			
			<!--- Catch any errors --->
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = 'Could not record view, please try again'>
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
</cfcomponent>