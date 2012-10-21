<cfparam name="URL.catID" default="7">

<!--- Cheeky request to get city names --->
<cfscript>	
	// Get the list of cities
	cities = StructNew();
	cities.ReturnFormat = 'Struct';
	cities.cmd = 'GetCities';
	cityList = CreateObject("component","controller.index").init(cities);

	
	// Get the adverts
	data = StructNew();
	data.ReturnFormat = 'struct';
	data.cmd = 'ViewAds';
	data.cID = SESSION.cID;
	obj = CreateObject("component","controller.index").init(data);
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Manage Adverts - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/application.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder" class="overflow">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
		<div class="fr">
			<h1 class="fr">Manage Adverts</h1>
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
	<div id="entryListView" class="fr overflow">
		<cfoutput>
			<cfif IsDefined("URL.message") AND URL.message EQ 'EditedAd'>
				<div class="box successBox">Advert Updated Successfully</div><br />
			<cfelseif IsDefined("URL.message") AND URL.message EQ 'AddedAd'>
				<div class="box successBox">Advert Added Successfully</div><br />
			<cfelseif IsDefined("URL.message") AND URL.message EQ 'DeletedAd'>
				<div class="box successBox">Advert Deleted Successfully</div><br />
			</cfif>
			<div class="bigPinkBtnText cb"><a href="add-ad.cfm" class="darkPink capitalise noUnderline">Add</a></div>
			<cfif obj.data.RecordCount GT 0>
				<div class="cb greyBox overflow">
					<cfloop query="obj.data">
						<div class="entry cb overflow">
							<p>
								<span class="grey block">Category:</span> 
								<cfif IsNumeric(obj.data.catID)>#obj.data.category_name#</a><cfelse>Main City Sponsor</cfif>
							</p>
							<p>
								<span class="grey block">Advert:</span> 
								<cfif FileExists(ExpandPath('public/images/adverts/#obj.data.img#'))>
									<img src="public/images/adverts/#obj.data.img#" />
								</cfif>
							</p>	
							<p>
								<span class="grey block">URL:</span> 
								<cfif obj.data.url GT ''><a href="#obj.data.url#">#obj.data.url#</a><cfelse>Not Set</cfif>
							</p>
							<span class="fr">
								<div class="smlButton fr"><a href="view-ads.cfm?cmd=DeleteAd&adID=#obj.data.adID#&#CGI.QUERY_STRING#" class="confirmDelete">Delete</a></div>
								<div class="smlButton fr"><a href="edit-ads.cfm?adID=#obj.data.adID#">Edit</a></div>
							</span>
						</div>
						<cfif obj.data.CurrentRow NEQ obj.data.RecordCount><hr/></cfif>
					</cfloop>
				</div><br/>
			<cfelse>
				<p>No Adverts Found</p>
			</cfif>
		</cfoutput>
	</div>
</div>
</body>
</html>