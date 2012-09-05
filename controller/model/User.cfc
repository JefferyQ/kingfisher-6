<cfcomponent>
	<cffunction name="login" access="public" hint="Logs the user in">
		<cfargument name="ReturnFormat" type="string" required="yes">
		<cfargument name="email" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		
		<!--- Create the return structure --->
		<cfset rtn = StructNew()>
		
		<!--- Load the authentication private key --->
		<cfset authKeyLocation = expandpath('auth/key.txt')>
		<cffile action="read" file="#authKeyLocation#" variable="authkey">
		
		<!--- Get the user's account from their email address --->
		<cfquery name="rsGetUser" datasource="#Application.DataSource#">
			SELECT * FROM users WHERE 
			email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.email#">
			LIMIT 1;
		</cfquery>
		
		<!--- Check the email address was found in the db --->
		<cfif rsGetUser.RecordCount EQ 1>
			<!--- Decrypt the salt --->
			<cfset theSalt = decrypt(rsGetUser.password_salt,authKey,'CFMX_COMPAT','hex')>
			<cfset passwordHash = Hash(ARGUMENTS.password & theSalt, 'SHA-512')>
			
			<!--- Check if the password hash matches the one we have in the db --->
			<cfif passwordHash EQ rsGetUser.password>
				<!--- Do the Coldfusion Login stuff --->
				<cflogin idletimeout="1800">
					<cfloginuser name="#rsGetUser.uID#" password="#passwordHash#" roles="#rsGetUser.roles#">
				</cflogin>
				
				<!--- Set the Session stuff --->
				<cfset SESSION.uID = rsGetUser.uID>
			
				<!--- Set the return stuff --->
				<cfset rtn.result = true>
				<cfset rtn.redirect = 'home.cfm'>
			
			<cfelse>
				<cfset rtn.result = false>
				<cfset rtn.message = 'Sorry your password was wrong, please try again.'>
			</cfif>
		
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Sorry email address was wrong, please try again.'>
		</cfif>
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
</cfcomponent>