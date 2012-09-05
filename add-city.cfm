<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Add New City - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
		<h1 class="fr">Add A City</h1>
	</div>
	<div id="addCity" class="greyBox centre">
		<cfform name="frmAddCity" action="" method="post" class="overflow">
			<cfif IsDefined("SESSION.error")><div class="error"><cfoutput>#SESSION.error#</cfoutput></div></cfif>
			<p><cfinput type="text" name="city_name" required placeholder="Enter City Name" class="textInput darkPink" /></p>
			<cfinput type="hidden" name="cmd" value="addCity" />
			<cfinput type="hidden" name="APIToken" value="raiseatree12" />
			<cfinput type="submit" name="btnSubmit" value="Add City" class="fr bigPinkBtn" />
		</cfform>
	</div>
</div>
</body>
</html>

<cfif IsDefined("SESSION.error")>
	<cfset StructDelete(SESSION, 'error')>
</cfif>