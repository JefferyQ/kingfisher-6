<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>
<cfscript>
  categories = EntityLoadByPK("Entries", 1);
  writedump(categories);
</cfscript>
</body>
</html>