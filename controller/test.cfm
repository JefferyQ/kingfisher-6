<!---<cfscript>
	// Create the data to pass in 
	data = StructNew();
	data.ReturnFormat = 'json';
	data.cmd = 'GetEntries';
	data.cID = 1;
	//data.catID = 8;
	
	//WriteDump(data);
	
	// Serialize the input
	data = SerializeJSON(data);
	
	WriteDump(data);

	//temp = CreateObject("component","index").init(data);
	
	// Form the http call url
	readTreeUrl = 'http://www.kingfishercontent.co.uk/controller/index.cfc?method=init&data=' & data;

	WriteDump(readTreeUrl);

	// Fire off the HTTP Call to the web service controller
	myHttp = new Http ( url = readTreeUrl, method="get");
	temp = myHttp.send().getPrefix();
	
	temp = DeserializeJSON(temp);
	WriteDump(temp);
	
	//data = DeserializeJSON(temp);
	//WriteDump(data);
</cfscript>

<!--- invoke a web service call --->
<!---<cfinvoke component="index" method="init" returnvariable="result">
	<cfinvokeargument name="data" value="#data#">
</cfinvoke>

<cfdump var="#result#">--->--->

<cfparam name="URL.cmd" default="GetEntries" />
<cfparam name="URL.ReturnFormat" default="json" />
<cfparam name="SESSION.cID" default="3" />
<cfparam name="URL.catID" default="7" />

<cfscript>
	data = StructNew();
	data.ReturnFormat = URL.ReturnFormat;
	data.cmd = URL.cmd;
	data.cID = SESSION.cID;
	data.catID = URL.catID;
	
	data = SerializeJSON(data);
	
	WRiteDump(data);

	obj = CreateObject("component","index").init(data);
	
	obj = DeserializeJSON(obj);
	WriteDump(obj);
</cfscript>