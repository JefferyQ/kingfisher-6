<cfparam name="URL.cmd" default="GetEntries" type="string" />
<cfparam name="URL.ReturnFormat" default="json" type="string" />
<cfparam name="URL.cID" default="4" type="integer" />
<cfparam name="URL.eID" default="24" type="integer" />
<!---><cfparam name="URL.offerID" default="4" type="integer" />--->
<cfparam name="URL.catID" default="9" type="integer" />
<cfparam name="URL.uuid" default="test-uuid" type="string" />
<cfparam name="URL.locale" default="test-l" type="string" />
<cfparam name="URL.position" default="start" type="string" />

<cfscript>
	data = StructNew();
	data.ReturnFormat = URL.ReturnFormat;
	data.cmd = URL.cmd;
	//data.eID = URL.eID;
	//data.catID = URL.catID;
	//data.offerID = URL.offerID;
	//data.uuid = URL.uuid;
	//data.locale = URL.locale;
	data.cID = URL.cID;
	//if (IsDefined("URL.catID")) data.catID = URL.catID;
	//data.position = URL.position;
	
	data = SerializeJSON(data);
	
	// ONLY DUMP WHEN TESTING OTHERWISE YOU BREAK THE IPHONE
	//WriteDump(data);

	obj = CreateObject("component","index").init(data);
	
	//obj = DeserializeJSON(obj);
	WriteOutput(obj);
	
</cfscript>