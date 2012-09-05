<cfcomponent displayname="LeaguesTest"  extends="mxunit.framework.TestCase">	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			mycomponent = createObject("component","kingfisher.model.users"); // Create the object we want to test
		</cfscript>
	</cffunction>
	
	<!--- Tests getClassLeague --->
	<!---<cffunction name="testGetClassLeague" access="public" returntype="void">
		<cfscript>
			actual = mycomponent.getClassLeague(sID);
			assertIsQuery(actual);
		</cfscript>
	</cffunction>--->
	
	<cffunction name="tearDown" access="public" returntype="void">
		
	</cffunction>
</cfcomponent>