<cfscript>
	// Create a test suite object
	testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
	
	// Add all runnable methods in Raise A Tree
	//testSuite.addAll("kingfisher.tests.EntriesTest");
	
	// Run the tests and save everything in "results"
	results = testSuite.run();

	// Now print the results. Simple\!
	writeOutput(results.getResultsOutput('html'));
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>
</body>
</html>