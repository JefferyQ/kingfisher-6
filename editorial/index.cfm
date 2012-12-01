<!--- Get a list of cities --->
<cfquery name="rsGetCities" datasource="#Application.DataSource#">
	SELECT * FROM cities ORDER BY city_name ASC;
</cfquery>

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