<cfcomponent>
	<cffunction name="init" access="public" hint="Function that handles all data transfer with the application model">
		<cfargument name="data" type="any" hint="Input JSON string that provides info on request and parameters">
		
		<cfscript>
			if (Not(IsStruct(ARGUMENTS.data))) {
				// Try to deserilize the JSON string 
				try { 
					data = DeserializeJSON(ARGUMENTS.data);
				} catch (Exception ex) {
					// TODO Handle any errors that occur from malformed JSON strings 
					WriteDump(ex);
				}
			}
			
			// Work out the return type
			if (Not(StructKeyExists(data,"ReturnFormat")))
				data.ReturnFormat = 'JSON';
				
			//  Map out the routes through the application 
			try {
				switch (data.cmd) {
					case "AddCity" : {
						// Adds a new city from the form submission
						rtn = createObject("component","model.City").AddCity(data.ReturnFormat,data.city_name,data.APIToken);
						
						break;
					}
					
					case "AddEntry" : {
						// Adds a new entry from the form submission
						rtn = createObject("component","model.Entry").AddEntry(argumentCollection=data);
						
						break;
					}
					
					case "AddOffer" : {
						// Adds a new entry from the form submission
						rtn = createObject("component","model.Offer").AddOffer(argumentCollection=data);
						
						break;
					}
					
					case "AddSubCat" : {
						// Adds a new city from the form submission
						rtn = createObject("component","model.Entry").AddSubCat(argumentCollection=data);
						
						break;
					}
					
					case "ApproveEntry" : {
						// Approves a new listing
						rtn = createObject("component","model.Entry").Approve(argumentCollection=data);
						
						break;
					}
					
					case "ClientEntry" : {
						// Adds a new entry from the form submission
						rtn = createObject("component","model.Entry").AddEntry(argumentCollection=data);
						
						break;
					}
					
					case "DeleteEntry" : {
						// Delete an entry
						rtn = createObject("component","model.Entry").DeleteEntry(argumentCollection=data);
						
						break;
					}
					
					case "DeleteOffer" : {
						// Delete an entry
						rtn = createObject("component","model.Offer").DeleteOffer(argumentCollection=data);
						
						break;
					}
					
					case "DeleteSubCat" : {
						// Adds a new city from the form submission
						rtn = createObject("component","model.Entry").DeleteSubCat(argumentCollection=data);
						
						break;
					}
					
					case "EditEntry" : {
						// Edits an entry
						rtn = createObject("component","model.Entry").EditEntry(argumentCollection=data);
						
						break;
					}
					
					case "EditOffer" : {
						// Edits an entry
						rtn = createObject("component","model.Offer").EditOffer(argumentCollection=data);
						
						break;
					}
					
					case "GetCategories" : {
						// Create the object and initialise the method
						rtn = createObject("component","model.Category").GetCategories(); 
						
						break;
					}
					
					case "GetCities" : {
						// Create the object and initialise the method
						rtn = createObject("component","model.City").GetCities(data.ReturnFormat); 
						
						break;
					}
					
					case "GetEntries" : {
						
						// Check if we are in json mode and remove the catID if so (we don't use it on the iPhone)
						if (IsDefined("data.returnFormat") AND data.returnFormat EQ 'json') {
							StructDelete(data, 'catID');
						}
						
						/* 
							Create the object and initialise the method
						*/
						rtn = createObject("component","model.Entry").GetEntries(argumentCollection=data); 
						
						break;
					}
					
					case "GetEntry" : {
						/* 
							Create the object and initialise the method
						*/
						rtn = createObject("component","model.Entry").GetEntry(argumentCollection=data); 
						
						break;
					}
					
					case "GetOffers" : {
						/* 
							Create the object and initialise the method
						*/
						rtn = createObject("component","model.Offer").GetOffers(argumentCollection=data); 
				
						break;
					}
					
					case "GetSubCats" : {
						
						/*
							Check our input parameter has been supplied
						*/
						//if (Not(IsDefined("data.catID")))
							//data.catID = 1;
							
						/* 
							Create the object and initialise the method
						*/
						rtn = createObject("component","model.Entry").GetSubCats(returnFormat=data.returnFormat, catID=data.catID); 
					
						break;
					}
					
					case "Login" : {
						// Create the object and initialise the method
						rtn = createObject("component","model.User").Login(data.ReturnFormat,data.email,data.password); 
						
						break;
					}
					
					case "RecordEditorialView" : {
						/*
							Records a view against a particular entry
						*/
						rtn = createObject("component","model.Entry").RecordEditorialView(argumentCollection=data); 
						
						break;
					}
					
					case "RecordOfferView" : {
						/*
							Records a view against a particular entry
						*/
						rtn = createObject("component","model.Offer").RecordView(argumentCollection=data); 
						
						break;
					}
					
					case "RecordView" : {
						/*
							Records a view against a particular entry
						*/
						rtn = createObject("component","model.Entry").RecordView(argumentCollection=data); 
						
						break;
					}
					
					case "SelectedCity" : {
						/*
							Forwards the user to the city page
						*/
						rtn = StructNew();
						rtn.result = true;
						rtn.redirect = 'view-entries.cfm';
					
						// Update the selected city in the session
						SESSION.cID = data.cID;
						
						break;
					}
					
					default : {
						// TODO Return an error as the cmd wasn't recognised 
						
						break;
					}
				}
			} catch (Exception ex1) {
				// TODO Handle this exception properly
				WriteDump(ex1);
			}
		</cfscript>
	
		<cfreturn rtn>
	</cffunction>
</cfcomponent>