<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>
<cfscript>
	ORMEvictEntity("Category");
	WriteOutput('Evicted Category<br />');
	ORMEvictEntity("City");
	WriteOutput('Evicted City<br />');
	ORMEvictEntity("Entry");
	WriteOutput('Evicted Entry<br />');
	ORMEvictEntity("SubCategory");
	WriteOutput('Evicted SubCategory<br />');
	ORMEvictEntity("User");
	WriteOutput('Evicted User<br />');
	
	ORMCloseSession();
	WriteOutput('Closed ORM Session<br />');
	ORMClearSession();
	WriteOutput('Cleared ORM Session<br />');
	ORMReload();
	WriteOutput('Reloaded ORM');
</cfscript>
</body>
</html>