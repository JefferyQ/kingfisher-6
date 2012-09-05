<cfparam name="URL.catID" default="7">

<cfsetting requesttimeout="600">

<!--- Cheeky request to get city names --->
<cfscript>
	// Get the list of cities
	cities = StructNew();
	cities.ReturnFormat = 'Struct';
	cities.cmd = 'GetCities';
	cityList = CreateObject("component","controller.index").init(cities);
	
	// Get the Category & Sub-Categories
	cats.cmd = 'GetCategories';
	catList = CreateObject("component","controller.index").init(cats);
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Client Entry Form - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
<script type="text/javascript">

/***********************************************
* Textarea Maxlength script- � Dynamic Drive (www.dynamicdrive.com)
* This notice must stay intact for legal use.
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/

function ismaxlength(obj){
var mlength=obj.getAttribute? parseInt(obj.getAttribute("maxlength")) : ""
if (obj.getAttribute && obj.value.length>mlength)
	obj.value=obj.value.substring(0,mlength);
}

</script>

<script language="javascript" type="text/javascript">
$(document).ready(function() {

	// Hide the sub-category box by default
	$(".scBox").hide();

	// Set up a JSON web call to the server when someone chooses a category
	$("#catID").change(function() {
		
		// Clear all the old entries out 
		$('#scID').empty();
		
		var url = "controller/index.cfm?ReturnFormat=json&cmd=getSubCats&catID=" + $("#catID option:selected").val();
		
		// Create a JSON call to the server to request the sub categories
		$.getJSON(url, function(data) {
			console.log(data);
			
			// Loop through the data and extract the data
			for (var i=0; i<data.DATA.DATA.length; i++) {		
				var option = '<option value="' + data.DATA.DATA[i][2] + '">' + data.DATA.DATA[i][4] + '</option>';
				$("#scID").append(option);
			}
			
			// Show the sub-category label & box
			$(".scBox").fadeIn('fast');

		});
	});
	
});

</script>

</head>

<body>
<div id="holder" class="overflow">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
	</div>
	<div id="entryForm">
		<cfoutput>
			<cfif IsDefined("SESSION.error")><div class="error"><cfoutput>#SESSION.error#</cfoutput></div></cfif>
			<h2 class="fl">Client Entry Form</h2>
			<cfform name="frmAddEntry" method="post" id="entryForm" class="cb greyBox overflow" enctype="multipart/form-data">
				<p><img src="public/images/req.png"> Denotes a required field</p>
				<p>
					<label>City or Region<img src="public/images/req.png"></label><br/>
					<cfselect name="cID" class="textInput" query="cityList.data" display="city_name" value="cID"></cfselect>
				</p>
				<p>
					<label>Company Name<img src="public/images/req.png"></label><br/>
					<cfif IsDefined("SESSION.rtn.title")>
						<cfinput type="text" name="title" placeholder="Company Name" class="textInput darkPink" value="#SESSION.rtn.title#" required="true" message="Please enter a company name" />
					<cfelse>
						<cfinput type="text" name="title" placeholder="Company Name" class="textInput darkPink" required="true" message="Please enter a company name" />
					</cfif>
				</p>
				<p>
					<label>Select Category<img src="public/images/req.png"></label><br/>
					<cfselect name="catID" class="textInput" query="catList.data" display="category_name" value="catID" id="catID" required="yes" message="Please select a category to be listed in"><option selected="true"></option></cfselect>
				</p>
				<p class="scBox">
					<label>Select Sub-Category</label><br/>
					<select name="scID" class="textInput" id="scID">
						<option selected="true"></option>
					</select>
				</p>
				<p>
					<label>Entry Description (MAX 100 Words)<img src="public/images/req.png"></label><br/>
					<cfif IsDefined("SESSION.rtn.body")>
						<textarea name="body" class="textInput textArea darkPink" maxlength="650" onkeyup="return ismaxlength(this)" placeholder="Entry Text">#SESSION.rtn.body#</textarea>
					<cfelse>
						<textarea name="body" class="textInput textArea darkPink" maxlength="650" onkeyup="return ismaxlength(this)" placeholder="Entry Text"></textarea>
					</cfif>
				</p>
				<p>
					<label>Post Code (EG AB12 3CD)<img src="public/images/req.png"></label><br/>
					<cfif IsDefined("SESSION.rtn.postcode")>
						<cfinput type="text" name="postcode" placeholder="Post Code" class="textInput darkPink " value="#SESSION.rtn.postcode#" />
					<cfelse>
						<cfinput type="text" name="postcode" placeholder="Post Code" class="textInput darkPink " />
					</cfif>	
				</p>
				<p>
					<label>Website URL</label><br/>
					<cfif IsDefined("SESSION.rtn.website")>
						<cfinput type="text" name="website" placeholder="Website Address" class="textInput darkPink " value="#SESSION.rtn.website#" />
					<cfelse>
						<cfinput type="text" name="website" placeholder="Website Address" value="http://www." class="textInput darkPink " />
					</cfif>
				</p>
				<p>
					<label>Contact Email</label><br/>
					<cfif IsDefined("SESSION.rtn.email")>
						<cfinput type="text" name="email" placeholder="Email Address" class="textInput darkPink " validate="email" message="Please enter a valid email address" value="#SESSION.rtn.email#" />
					<cfelse>
						<cfinput type="text" name="email" placeholder="Email Address" class="textInput darkPink " validate="email" message="Please enter a valid email address" />
					</cfif>
				</p>
				<p>
					<label>Contact Telephone</label><br/>
					<cfif IsDefined("SESSION.rtn.tel")>
						<cfinput type="text" name="phone" placeholder="Phone Number" class="textInput darkPink " value="#SESSION.rtn.tel#" />
					<cfelse>
						<cfinput type="text" name="phone" placeholder="Phone Number" class="textInput darkPink " />
					</cfif>
				</p>
				<p>
					<label>Entry Image JPEG OR PNG (Minimum Width 640px please - LANDSCAPE ONLY)</label><br/>
					<cfinput type="file" name="img" class="textInput darkPink " />
				</p>
				<p>
					Having problems uploading? Contact our production team <a href="mailto:production@kingfishermedia.co.uk">production@kingfishermedia.co.uk</a> or 0191 482 5799
				</p>
				<p>
					<cfinput type="hidden" name="EntryType" value="client" />
					<cfinput type="hidden" name="cmd" value="ClientEntry" />
					<cfinput type="submit" name="btnSubmit" value="Submit" class="fl bigPinkBtn" />
				</p>
			</cfform>
		</cfoutput>
	</div>
</div>
</body>
</html>