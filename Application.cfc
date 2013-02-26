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
			
			// Detect the site root 
			if (CGI.server_name EQ 'localhost') 
					Application.SiteRoot = 'http://localhost:' & CGI.SERVER_PORT & '/kingfisher';
			else 
				Application.SiteRoot = 'tbc';
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
			</cfif>
			
		</cfif>
		
		<cflogin> 
			<cfif (NOT(IsDefined("SESSION.cfauthorization_kingfisher"))) AND 
					(FindNoCase('index.cfm',CGI.SCRIPT_NAME) EQ 0) AND
					(FindNoCase('client-entry.cfm',CGI.SCRIPT_NAME) EQ 0) AND
					(FindNoCase('client-thanks.cfm',CGI.SCRIPT_NAME) EQ 0) AND
					(FindNoCase('approve.cfm',CGI.SCRIPT_NAME) EQ 0) AND
					(FindNoCase('test.cfm',CGI.SCRIPT_NAME) EQ 0)>
				<cflocation addtoken="no" url="index.cfm">
				<cfabort> 
			</cfif>
		</cflogin>
			
		<cfreturn true>
	</cffunction>
	
	<cffunction name="onMissingTemplate" output="yes" returnType="boolean">
		<cfargument name="targetpage" required="yes" type="string">
		
		<cfoutput>Can't find page</cfoutput>
		
		<cfreturn true>
	</cffunction>

</cfcomponent>