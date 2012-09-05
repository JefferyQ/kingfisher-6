<cfif IsDefined("URL.eID")>

	<!--- Decrypt --->
	<cfset eID = decrypt(URL.eID,'raiseatree12','CFMX_COMPAT','hex')>
	
	<!--- Update the listing --->
	<cfscript>
		data.cmd = 'ApproveEntry';
		data.eID = eID;
		result = CreateObject("component","controller.index").init(data);
	</cfscript>

</cfif>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Entry Approved - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder" class="overflow">
	<div class="overflow">
		<div id="smallLogo" class="fl"></div>
	</div>
	<div id="entryForm">
		<cfoutput>
			<h2>The Entry Is Now Live!</h2>
		</cfoutput>
	</div>
</div>
</body>
</html>