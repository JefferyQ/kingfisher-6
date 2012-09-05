<cfparam name="URL.eID" default="1">
<cfparam name="URL.catID" default="7">

<!--- Cheeky request to get city names --->
<cfscript>
	// Get the list of cities
	cities = StructNew();
	cities.ReturnFormat = 'Struct';
	cities.cmd = 'GetCities';
	cityList = CreateObject("component","controller.index").init(cities);
	
	// Get the entry
	data = StructNew();
	data.ReturnFormat = 'struct';
	data.cmd = 'GetEntry';
	data.eID = URL.eID;
	obj = CreateObject("component","controller.index").init(data);
	
	// Get the Category & Sub-Categories
	subcats = StructNew();
	subcats.ReturnFormat = 'struct';
	subcats.cmd = 'GetSubCats';
	subcats.catID = URL.catID;
	objsc = CreateObject("component","controller.index").init(subcats);
	
	// Update the session city in case we're editing a lot of entries at once
	SESSION.cID = obj.data.cID;
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Edit An Entry - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder" class="overflow">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
		<div class="fr">
			<h1 class="fr">Edit Entry</h1>
			<cfform name="frmSelectCity" method="post" class="fr cr">
				<select name="cID" class="darkPink capitalise" value="cID" onChange="this.form.submit();">
					<cfoutput query="cityList.data">
						<option value="#cityList.data.cID#" <cfif obj.data.cID EQ cityList.data.cID>selected</cfif>>#cityList.data.city_name#</option>
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
			<cfif IsDefined("obj.data")>
				<h2 class="fl">#obj.data.title#</h2>
				<cfform name="frmEditEntry" method="post" class="cb greyBox overflow" enctype="multipart/form-data">
					<p>
						<label>Entry Title</label><br/>
						<input type="text" name="title" placeholder="Entry Title" required class="textInput darkPink" value="#obj.data.title#" />
					</p>
					<a href="manage-categories.cfm?catID=#URL.catID#">Add/Delete Sub-Categories</a>
					<p>
						<label>Select Sub-Category</label><br/>
						<cfselect name="scID" multiple="yes" class="textInput" query="objsc.data" display="sub_category_name" value="scID">
							<option selected disabled>Select Sub-Category</option>
						</cfselect>
					</p>
					<p>
						<label>Entry Description</label><br/>
						<textarea name="body" class="textInput textArea darkPink " required placeholder="Entry Text">#obj.data.body#</textarea>
					</p>
					<p>
						<label>Post Code</label><br/>
						<input type="text" name="postcode" required placeholder="Post Code" class="textInput darkPink" value="#obj.data.postcode#" />
					</p>
					<p>
						<label>Website URL</label><br/>
						<input type="url" name="website" placeholder="Website Address" class="textInput darkPink" value="#obj.data.web#" />
					</p>
					<p>
						<label>Contact Email</label><br/>
						<input type="email" name="email" placeholder="Email Address" class="textInput darkPink" value="#obj.data.email#" />
					</p>
					<p>
						<label>Contact Telephone</label><br/>
						<input type="tel" name="phone" placeholder="Phone Number" class="textInput darkPink" value="#obj.data.phone#" />
					</p>
					<p>
						<label>Entry Image</label><br/>
						<input type="file" name="img" class="textInput darkPink" />
					</p>
					<p>
						<strong>Current Image:</strong><br/><br/>
						<cfif IsDefined("obj.data.img") AND obj.data.img GT ''>
							<img src="public/images/thumbnails/#obj.data.img#">
						<cfelse>
							<img src="public/images/thumbnails/placeholder.jpg">
						</cfif>
					</p>
					<p>
						<label>Listing Status</label><br />
						<select name="enabled">
							<option value="1" <cfif obj.data.enabled EQ 1>selected</cfif>>Available</option>
							<option value="0" <cfif obj.data.enabled EQ 0>selected</cfif>>Not Available</option>
						</select>
					</p>
					<p>
						<input type="hidden" name="APIToken" value="raiseatree12" />
						<input type="hidden" name="cmd" value="EditEntry" />
						<input type="hidden" name="eID" value="#obj.data.eID#" />
						<input type="hidden" name="cID" value="#obj.data.cID#" />
						<input type="hidden" name="catID" value="#URL.catID#" />
						<input type="submit" name="btnSubmit" value="Edit Entry" class="fl bigPinkBtn" />
					</p>
				</cfform>
			<cfelse>
				<p>Could not edit entry, please go back to the list</p>
				<div class="bigPinkBtnText"><a href="view-entries.cfm?catID=#URL.catID#" class="darkPink capitalise noUnderline">View List</a></div>
			</cfif>
		</cfoutput>
	</div>
</div>
</body>
</html>