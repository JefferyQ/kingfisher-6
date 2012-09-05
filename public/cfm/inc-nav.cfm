<cfparam name="URL.catID" default="0">

<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<!--- Check to see if we are managing the offers page --->
<!---<cfif (URL.catID EQ 5) AND (CurrentPage EQ 'add-entry.cfm')>
	<cfset OffersPage = 'add-offer.cfm'>
	<cfset CurrentPage = 'add-entry.cfm'>
<cfelseif (URL.catID EQ 5) AND (CurrentPage EQ 'view-entries.cfm')>
	<cfset OffersPage = 'view-offers.cfm'>
	<cfset CurrentPage = 'view-entries.cfm'>
<cfelseif (URL.catID EQ 5) AND (CurrentPage EQ 'view-entry.cfm')>
	<cfset OffersPage = 'edit-offer.cfm'>
	<cfset CurrentPage = 'edit-entry.cfm'>
<cfelseif URL.catID EQ 5>
	<cfset OffersPage = CurrentPage>
	<cfset CurrentPage = 'add-entry.cfm'>
<cfelse>
	<cfset OffersPage = 'add-offer.cfm'>
</cfif>--->

<cfoutput>
	<ul>
		<li <cfif URL.catID EQ 7>id="selected"</cfif>><a href="view-entries.cfm?catID=7">Accommodation</a></li>
		<li <cfif URL.catID EQ 2>id="selected"</cfif>><a href="view-entries.cfm?catID=2">Art &amp; Culture</a></li>
		<li <cfif URL.catID EQ 4>id="selected"</cfif>><a href="view-entries.cfm?catID=4">Business &amp; Property</a></li>
		<li <cfif URL.catID EQ 3>id="selected"</cfif>><a href="view-entries.cfm?catID=3">Days Out &amp; Attractions</a></li>
		<li <cfif URL.catID EQ 8>id="selected"</cfif>><a href="view-entries.cfm?catID=8">Eating Out</a></li>
		<li <cfif URL.catID EQ 1>id="selected"</cfif>><a href="view-entries.cfm?catID=1">Nightlife</a></li>
		<li <cfif URL.catID EQ 5>id="selected"</cfif>><a href="view-offers.cfm?catID=5">Offers</a></li>
		<li <cfif URL.catID EQ 6>id="selected"</cfif>><a href="view-entries.cfm?catID=6">Shopping</a></li>
		<li <cfif URL.catID EQ 9>id="selected"</cfif>><a href="view-entries.cfm?catID=9">Sports</a></li>
	</ul>
</cfoutput>