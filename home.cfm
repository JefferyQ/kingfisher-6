<!--- Cheeky request to get city names --->
<cfscript>
	data = StructNew();
	data.ReturnFormat = 'struct';
	data.cmd = 'GetCities';
	obj = CreateObject("component","controller.index").init(data);
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Select or Add City - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder">
	<div id="smallLogo"></div>
	<div id="home" class="greyBox centre">
		<cfform name="frmSelectCity" action="" method="post">
			<cfif IsDefined("SESSION.success")><p class="box successBox"><cfoutput>#SESSION.success#</cfoutput></p></cfif>
			<p>
				<cfselect name="cID" class="selectInput darkPink capitalise" query="obj.data" display="city_name" value="cID" onchange="this.form.submit();">
					<option selected>Select A City</option>
				</cfselect>
				<cfinput type="hidden" name="cmd" value="SelectedCity"/>
			</p>
			<p class="grey centre">OR</p>
			<p><div class="textInputBtn"><a href="add-city.cfm" class="darkPink capitalise noUnderline">Add New City</a></div></p>
		</cfform>
	</div>
</div>
</body>
</html>

<cfif IsDefined("SESSION.success")>
	<cfset StructDelete(SESSION, 'success')>
</cfif>