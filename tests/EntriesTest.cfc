<cfcomponent displayname="LeaguesTest"  extends="mxunit.framework.TestCase">	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			// Create the object we want to test
			mycomponent = createObject("component","kingfisher.controller.index"); 
			
			// Create the structure used to test each function
			data = StructNew();
			
			// Define some example variables (mostly keys)
			catID = 1;
			scID = 1;
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetEntriesByCategory" access="public" returntype="void">
		<cfscript>
			// Finish creating the input structure for the function
			data.cmd = 'getEntries';
			data.catID = catID;
			data.ReturnFormat = 'JSON';
			data = SerializeJSON(data);
			
			actual = mycomponent.init(data);
			assertString(actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void"></cffunction>
</cfcomponent>