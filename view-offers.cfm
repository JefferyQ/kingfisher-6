<cfparam name="URL.catID" default="5">

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
	data.cmd = 'GetOffers';
	data.showAll = 'true';
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
			<h1 class="fr">View Offers</h1>
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
			<cfif IsDefined("obj.data")>
				<cfif IsDefined("URL.message") AND URL.message EQ 'EditedOffer'>
					<div class="box successBox cb">Offer Edited Successfully</div>
				<cfelseif IsDefined("URL.message") AND URL.message EQ 'AddedOffer'>
					<div class="box successBox cb">Offer Added Successfully</div>
				<cfelseif IsDefined("URL.message") AND URL.message EQ 'DeletedOffer'>
					<div class="box successBox cb">Offer Deleted Successfully</div>
				</cfif>
				
				<h2 class="fl">Offers</h2>
			
				<div class="cb greyBox overflow">
					<cfloop query="obj.data">
						<div class="entry cb overflow">
							<div class="offerDates fl">
								<p><span class="grey block">Start Date:</span> #DateFormat(obj.data.date_start,'mm/dd/yyyy')# </p>
								<p><span class="grey block">End Date:</span> #DateFormat(obj.data.date_finish,'mm/dd/yyyy')# </p>
							</div>
							<div class="offerContent fr">
								<h3>#obj.data.title#</h3>
								<p><span class="grey"><strong>Offer Code:</strong></span> #obj.data.offer_code#</p>
								<p>#obj.data.offer_desc#</p>
								<span class="fr">
									<div class="smlButton fr"><a href="view-offers.cfm?cmd=DeleteOffer&offerID=#obj.data.offerID#&#CGI.QUERY_STRING#&apiToken=raiseatree12" class="confirmDelete">Delete</a></div>
									<div class="smlButton fr"><a href="edit-offer.cfm?offerID=#obj.data.offerID#">Edit</a></div>
								</span>
							</div>
						</div>
						<cfif obj.data.CurrentRow NEQ obj.data.RecordCount><hr/></cfif>
					</cfloop>
				</div><br/>
			<cfelse>
				<p>No Offers Found</p>
			</cfif>
			<div class="bigPinkBtnText cb"><a href="add-offer.cfm" class="darkPink capitalise noUnderline">Add Offer</a></div>
		</cfoutput>
	</div>
</div>
</body>
</html>