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
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Add New Advert - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder" class="overflow">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
		<div class="fr">
			<h1 class="fr">Add New Advert</h1>
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
			<h2 class="fl">Add New Advert</h2>
			<cfif IsDefined("SESSION.error")><div class="error cb"><cfoutput>#SESSION.error#</cfoutput></div></cfif>
			<cfform name="frmAddEntry" method="post" class="cb greyBox overflow" enctype="multipart/form-data">
				<p>
					<label>Select Category:</label><br/>
					<cfselect name="catID" class="textInput" query="obj.data" display="category_name" value="catID">
						<option selected>Main City Sponsor</option>
					</cfselect>
				</p>
				<p>
					<label>Advert Image</label><br/>
					<input type="file" name="img" class="textInput darkPink " />
				</p>
				<p>
					<label>Advert URL:</label><br/>
					<textarea name="url" class="textInput textArea darkPink " required placeholder="Advert URL (the link to load when clicked)"></textarea>
				</p>
				<p>
					<input type="hidden" name="APIToken" value="raiseatree12" />
					<input type="hidden" name="cmd" value="AddAd" />
					<input type="hidden" name="cID" value="#SESSION.cID#" />
					<input type="submit" name="btnSubmit" value="Add Advert" class="fl bigPinkBtn" />
				</p>
			</cfform>
		</cfoutput>
	</div>
</div>
</body>
</html>