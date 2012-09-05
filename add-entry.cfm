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
	data.cmd = 'GetSubCats';
	data.catID = URL.catID;
	obj = CreateObject("component","controller.index").init(data);
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Add New Entry - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder" class="overflow">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
		<div class="fr">
			<h1 class="fr">Add An Entry</h1>
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
			<h2 class="fl">#obj.data.category_name#</h2>
			<div class="bigPinkBtnText fr"><a href="view-entries.cfm?catID=#URL.catID#" class="darkPink capitalise noUnderline">View List</a></div>
			<cfform name="frmAddEntry" method="post" class="cb greyBox overflow" enctype="multipart/form-data">
				<p>
					<label>Entry Title</label><br/>
					<input type="text" name="title" placeholder="Entry Title" required class="textInput darkPink " />
				</p>
				<a href="manage-categories.cfm?catID=#URL.catID#">Add/Delete Sub-Categories</a>
				<p>
					<label>Select Sub-Category</label><br/>
					<cfselect name="scID" multiple="yes" class="textInput" query="obj.data" display="sub_category_name" value="scID">
						<option selected disabled>Select Sub-Category</option>
					</cfselect>
				</p>
				<p>
					<label>Entry Description</label><br/>
					<textarea name="body" class="textInput textArea darkPink " required placeholder="Entry Text"></textarea>
				</p>
				<p>
					<label>Post Code</label><br/>
					<input type="text" name="postcode" required placeholder="Post Code" class="textInput darkPink " />
				</p>
				<p>
					<label>Website URL</label><br/>
					<input type="url" name="website" placeholder="Website Address" class="textInput darkPink " />
				</p>
				<p>
					<label>Contact Email</label><br/>
					<input type="email" name="email" placeholder="Email Address" class="textInput darkPink " />
				</p>
				<p>
					<label>Contact Telephone</label><br/>
					<input type="tel" name="phone" placeholder="Phone Number" class="textInput darkPink " />
				</p>
				<p>
					<label>Entry Image</label><br/>
					<input type="file" name="img" class="textInput darkPink " />
				</p>
				<p>
					<input type="hidden" name="APIToken" value="raiseatree12" />
					<input type="hidden" name="cmd" value="AddEntry" />
					<input type="hidden" name="cID" value="#SESSION.cID#" />
					<input type="hidden" name="catID" value="#URL.catID#" />
					<input type="submit" name="btnSubmit" value="Add Entry" class="fl bigPinkBtn" />
				</p>
			</cfform>
		</cfoutput>
	</div>
</div>
</body>
</html>