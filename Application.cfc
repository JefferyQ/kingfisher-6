<cfcomponent output="false">
	<!--- 
		Set up Application variables 
	--->
	<cfscript>
		// Application Variables
		this.name = 'kingfisher';
		this.applicationTimeout = createTimeSpan(0,0,20,0);
		this.clientManagement = true;
		this.loginStorage = 'session';
		this.sessionManagement = true;
		this.sessionTimeout = createTimeSpan(0,0,20,0);
		this.setClientCookies = true;
		this.setDomainCookies = true;
		this.scriptProtect = 'all';
	</cfscript>
	
	<!--- Run when application starts up --->
	<cffunction name="onApplicationStart" returnType="boolean" output="false">	
		<cfscript>
			// Set up the data source
			Application.DataSource = 'kingfisher_admin';
			//Application.DataSource = 'touchtap_kingfi';
			
			// Detect the site root 
			if (CGI.server_name EQ 'localhost') 
					Application.SiteRoot = 'http://localhost:' & CGI.SERVER_PORT & '/kingfisher';
			else 
				Application.SiteRoot = 'tbc';
			
			// Mail Variables (TBC)
			Application.MailTo = 'andy@raiseatree.co.uk';
			Application.MailFrom = 'Raise A Tree <hello@raiseatree.co.uk>';
			Application.MailServer = 'smtp.gmail.com';
			Application.MailPort = '465';
			Application.MailUser = 'hello@raiseatree.co.uk';
			Application.MailPwd = 'manutd88';
		</cfscript>
			
		<cfreturn true>
	</cffunction>
	
	<cffunction name="onRequestStart" output="yes" returntype="any">
		<cfargument type="string" name="targetPage" required="true" />
	
		<!--- Look for a URL or FORM submission to process --->
		<cfif (IsDefined("URL") AND StructCount(URL) GTE 1) 
			OR IsDefined("FORM") AND StructCount(FORM) GTE 1>
			
			<!--- Create the data structure for sending to the controller --->
			<cfset data = StructNew()>
			
			<!--- Detect which structure we're dealing with --->
			<cfif StructCount(FORM) GTE 1>
				<cfset data = Duplicate(FORM)>
			<cfelse>
				<cfset data = Duplicate(URL)>
			</cfif>
			
			<!--- Check to see we have a cmd --->
			<cfif StructKeyExists(data,"cmd")>
				<!--- Serialise the data --->
				<cfset data = SerializeJSON(data)>
				
				<!--- Package off to the controller and then handle the response --->
				<cfset rtn = createObject("component","controller.index").init(data)>
				
				<!--- Check whether it's json and deserialize if so --->
				<cfif IsJSON(rtn)>
					<cfset rtn = DeserializeJSON(rtn)>
				</cfif>
				
				<!--- Check the response result --->
				<cfif rtn.result EQ true>
					
					<!--- 
						Action was successful, check for a redirect... 
					--->
					<cfif StructKeyExists(rtn,"redirect")>
						
						<!---
							Redirect exists, forward the user
						--->	
						<cflocation addtoken="no" url="#rtn.redirect#">
					
					<cfelse>
						
						<!--- 
							No redirect, set success message 
						--->
						<cfif IsDefined("rtn.message")>
							<cfset SESSION.success = rtn.message>
						</cfif>
					
					</cfif>
				<cfelse>
					<cfset SESSION.error = rtn.message>
				</cfif>
			<cfelse>
				<!--- TODO - Handle this properly --->
				<!---<cfoutput>ERROR!</cfoutput>--->
			</cfif>
			
		</cfif>
		
		<cflogin> 
			<cfif (NOT(IsDefined("SESSION.cfauthorization_kingfisher"))) AND 
					(FindNoCase('index.cfm',CGI.SCRIPT_NAME) EQ 0) AND
					(FindNoCase('client-entry.cfm',CGI.SCRIPT_NAME) EQ 0) AND
					(FindNoCase('client-thanks.cfm',CGI.SCRIPT_NAME) EQ 0) AND
					(FindNoCase('approve.cfm',CGI.SCRIPT_NAME) EQ 0)>
				<cflocation addtoken="no" url="index.cfm">
				<cfabort> 
			</cfif>
		</cflogin>
			
		<cfreturn true>
	</cffunction>
	
	<cffunction name="onMissingTemplate" output="yes" returnType="boolean">
		<cfargument name="targetpage" required="yes" type="string">
		
		<cfoutput>Can't find page</cfoutput>
		
		<!---<cflocation addtoken="no" url="index.cfm?targetPage=#ARGUMENTS.targetPage#">--->
		
		<cfreturn true>
	</cffunction>

	<!--- Runs on error --->
	<!---<cffunction name="onError" returnType="void" output="yes">
		<cfargument name="exception" required="true">
		<cfargument name="eventname" type="string" required="true">
		
		<cfif #CGI.SERVER_NAME# EQ 'localhost'>
			<cfdump var="#ARGUMENTS.exception#">
		<cfelse>
			<!---<cfif IsDefined("SESSION.uID") AND IsNumeric(SESSION.uID)>
				<cfinvoke component="includes.cfc.user" method="getUserDetails" returnvariable="rsGetUser">
					<cfinvokeargument name="uID" value="#SESSION.uID#">
				</cfinvoke>
			</cfif>
			
			<!--- Email the error through --->
			<cfmail to="#Application.MailTo#" 
				from="#Application.MailFrom#" 
				subject="Error on Raise A Tree Utopian" 
				server="#Application.MailServer#" 
				port="465" 
				useSSL="true"
				username="#Application.MailUser#" 
				password="#Application.MailPwd#" 
				type="html">
					<cfoutput><p><strong>Page:</strong> #Application.SiteRoot#/#GetFileFromPath(GetTemplatePath())#</p></cfoutput>
					<cfoutput><p><strong>Message:</strong> #ARGUMENTS.exception.message#</p></cfoutput>
					<cfif IsDefined("ARGUMENTS.exception.sql")>
						<cfoutput><p><strong>SQL:</strong> #ARGUMENTS.exception.message#</p></cfoutput>
					</cfif>
					<cfoutput><p><strong>Stack Trace:</strong> #ARGUMENTS.exception.stacktrace#</p></cfoutput>
					<cfif IsDefined("SESSION.uID") AND IsNumeric(SESSION.uID)>
						<cfoutput><p><strong>uID:</strong> #rsGetUser.uID#</p></cfoutput>
						<cfoutput><p><strong>Username:</strong> #rsGetUser.studentLogin#</p></cfoutput>
						<!---<cfoutput><p><strong>Password:</strong> #decrypt(rsGetUser.password, Application.PasswordKey)#</p></cfoutput>--->
					<cfelse>
						<p>User not defined</p>
					</cfif>
			</cfmail>
				
			<!--- Forward the user --->
			<cflocation url="#Application.SiteRoot#/error.cfm" addtoken="no">--->
		</cfif>
	</cffunction>--->
</cfcomponent>