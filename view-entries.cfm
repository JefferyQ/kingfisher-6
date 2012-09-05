<cfparam name="URL.catID" default="7">

<!--- Cheeky request to get city names --->
<cfscript>	
	// Get the list of cities
	cities = StructNew();
	cities.ReturnFormat = 'Struct';
	cities.cmd = 'GetCities';
	cityList = CreateObject("component","controller.index").init(cities);

	
	// Get the Category & Sub-Categories
	data = StructNew();
	data.ReturnFormat = 'struct';
	data.cmd = 'GetEntries';
	data.catID = URL.catID;
	data.cID = SESSION.cID;
	obj = CreateObject("component","controller.index").init(data);
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>View Entries - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/application.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder" class="overflow">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
		<div class="fr">
			<h1 class="fr">View Entries</h1>
			<cfform name="frmSelectCity" method="post">
				<select name="cID" class="darkPink capitalise" value="cID" onChange="this.form.submit();">
					<cfoutput query="cityList.data">
						<option value="#cityList.data.cID#" <cfif SESSION.cID EQ cityList.data.cID>selected</cfif>>#cityList.data.city_name#</option>
					</cfoutput>
				</select>
				<cfinput type="hidden" name="cmd" value="SelectedCity"/>
			</cfform>
		</div>
	</div>
	<div id="entryList" class="fl">
		<cfinclude template="public/cfm/inc-nav.cfm">
	</div>
	<div id="entryListView" class="fr">
		<cfoutput>
			<cfif IsDefined("URL.message") AND URL.message EQ 'EditedEntry'>
				<div class="box successBox">Entry Edited Successfully</div>
			<cfelseif IsDefined("URL.message") AND URL.message EQ 'AddedEntry'>
				<div class="box successBox">Entry Added Successfully</div>
			<cfelseif IsDefined("URL.message") AND URL.message EQ 'DeletedEntry'>
				<div class="box successBox">Entry Deleted Successfully</div>
			</cfif>
			<cfif IsDefined("obj.data")>
				<h2 class="fl">#obj.data.category_name#</h2>
			
				<div class="cb greyBox overflow">
					<cfloop query="obj.data">
						<div class="entry cb overflow">
							<cfif IsDefined("obj.data.img") AND obj.data.img GT ''>
								<img src="public/images/thumbnails/#obj.data.img#" class="fl entryImg">
							<cfelse>
								<img src="public/images/thumbnails/placeholder.jpg" class="fl entryImg">
							</cfif>
							<div class="entryContent fr">
								<h3>#obj.data.title# - <cfif obj.data.enabled EQ 1><span class="green">Live</span><cfelse><span class="red">Not Live</span></cfif></h3>
								<p>#obj.data.body#</p>
								<p><span class="grey block">Website:</span> <cfif obj.data.web GT ''><a href="#obj.data.web#" target="_blank">#obj.data.web#</a><cfelse>Not Set</cfif></p>
								<p><span class="grey block">Email:</span> <cfif obj.data.email GT ''><a href="mailto:#obj.data.email#">#obj.data.email#</a><cfelse>Not Set</cfif></p>
								<p><span class="grey block">Telephone:</span> <cfif obj.data.phone GT ''>#obj.data.phone#<cfelse>Not Set</cfif></p>
								<span class="fr">
									<div class="smlButton fr"><a href="view-entries.cfm?cmd=DeleteEntry&eID=#obj.data.eID#&#CGI.QUERY_STRING#" class="confirmDelete">Delete</a></div>
									<div class="smlButton fr"><a href="edit-entry.cfm?eID=#obj.data.eID#&catID=#URL.catID#">Edit</a></div>
								</span>
							</div>
						</div>
						<cfif obj.data.CurrentRow NEQ obj.data.RecordCount><hr/></cfif>
					</cfloop>
				</div><br/>
			<cfelse>
				<p>No Entries Found</p>
			</cfif>
			<div class="bigPinkBtnText cb"><a href="add-entry.cfm?catID=#URL.catID#" class="darkPink capitalise noUnderline">Add Entry</a></div>
		</cfoutput>
	</div>
</div>
</body>
</html>