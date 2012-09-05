<cfcomponent>	
	<cffunction name="GetCategories" access="public">
		
		<cfset rtn = StructNew()>
		
		<!--- Get a list of categories --->
		<cfquery name="rsGetCategories" datasource="#Application.DataSource#">
			SELECT * FROM categories
			WHERE category_name <> 'Offers'
			ORDER BY category_name;
		</cfquery>
		
		<cfset rtn.data = rsGetCategories>
		
		<cfreturn rtn>
	</cffunction>
</cfcomponent>