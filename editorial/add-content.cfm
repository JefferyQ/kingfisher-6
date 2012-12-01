<!--- Get the city --->
<cfquery name="rsGetCities" datasource="#Application.DataSource#">
	SELECT * FROM cities WHERE cID = #FORM.cID# ASC;
</cfquery>

<cfdump var="#rsGetCities#"><cfabort>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>City Management</title>
</head>

<body>

<cfform action="add-content.cfm" method="post">
	
<p>
	City Label:<br />
	<cfinput type="text" name="txtLabel" value="">
</p>

<cfinput type="submit" name="btnSubmit" value="Submit">

</cfform>

</body>
</html>