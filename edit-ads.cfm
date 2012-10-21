<!--- Cheeky request to get city names --->
<cfscript>
	// Get the list of cities
	cities = StructNew();
	cities.ReturnFormat = 'Struct';
	cities.cmd = 'GetCities';
	cityList = CreateObject("component","controller.index").init(cities);
	
	// Get the list of categories
	data = StructNew();
	data.ReturnFormat = 'Struct';
	data.cmd = 'GetCategories';
	obj = CreateObject("component","controller.index").init(data);
	
	// Get the Entries
	data = StructNew();
	data.ReturnFormat = 'struct';
	data.cmd = 'ViewAds';
	data.adID = URL.adID;
	ad = CreateObject("component","controller.index").init(data);
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Edit Advert - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder" class="overflow">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
		<div class="fr">
			<h1 class="fr">Edit Advert</h1>
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
	<div id="entryForm" class="fr">
		<cfoutput>
			<h2 class="fl">Edit Advert</h2>
			<cfform name="frmAddEntry" method="post" class="cb greyBox overflow" enctype="multipart/form-data">
				<p>
					<label>Select Category:</label><br/>
					<cfselect name="catID" class="textInput" query="obj.data" display="category_name" value="catID">
						<cfif IsDefined("ad.data.catID") AND IsNumeric(ad.data.catID)><option selected value="#ad.data.catID#">#ad.data.category_name#</option><cfelse><option selected value="">Main City Sponsor</option></cfif>
						<option>Main City Sponsor</option>
					</cfselect>
				</p>
				<p>
					<label>Advert Image</label><br/>
					<input type="file" name="img" class="textInput darkPink " />
				</p>
				<p>
					<label>Current Advert</label><br />
					<cfif FileExists(ExpandPath('public/images/adverts/#ad.data.img#'))>
						<img src="public/images/adverts/#ad.data.img#" />
					</cfif>
				</p>
				<p>
					<label>Advert URL:</label><br/>
					<textarea name="url" class="textInput textArea darkPink " required placeholder="Advert URL (the link to load when clicked)">#ad.data.url#</textarea>
				</p>
				<p>
					<input type="hidden" name="APIToken" value="raiseatree12" />
					<input type="hidden" name="cmd" value="EditAd" />
					<input type="hidden" name="adID" value="#ad.data.adID#" />
					<input type="submit" name="btnSubmit" value="Save" class="fl bigPinkBtn" />
				</p>
			</cfform>
		</cfoutput>
	</div>
</div>
</body>
</html>