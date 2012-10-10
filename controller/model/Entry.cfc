<cfcomponent>
	<cffunction name="AddEntry" access="public">
		<cfargument name="cID" type="numeric" required="yes">
		<cfargument name="catID" type="numeric" required="yes">
		<cfargument name="scID" type="numeric" required="no">
		<cfargument name="postcode" type="string" required="yes">
		<cfargument name="website" type="string" required="no">
		<cfargument name="email" type="string" required="no">
		<cfargument name="phone" type="string" required="no">
		<cfargument name="img" type="string" required="no">
		<cfargument name="APIToken" type="string" required="no">
		<cfargument name="EntryType" type="string" required="no">
		<cfargument name="ordernumber" type="any" required="no">
		
		<cfsetting requesttimeout="600">
		
		<!--- Form the return structure --->
		<cfset rtn = StructNew()>
		
		<!--- Check we've received an API Token, otherwise do not delete --->
		<cfif (IsDefined("ARGUMENTS.APIToken") AND ARGUMENTS.APIToken EQ 'raiseatree12') 
				OR (IsDefined("ARGUMENTS.EntryType") AND ARGUMENTS.EntryType EQ 'Client')>
		
			<cftry>				
				<!--- Start by getting the lat/lon from Google --->
				<cfset address = "http://maps.googleapis.com/maps/api/geocode/json?address=" &  replace(ARGUMENTS.postCode,' ','+','ALL') & "&sensor=false">
				<cfhttp url="#address#" result="google" />
				<cfset data = DeserializeJSON(google.FileContent)>
				<cfset lat = data.results[1].geometry.location.lat>
				<cfset lng = data.results[1].geometry.location.lng>
			
				<cfcatch type="any">
					<cfset rtn.result = false>
					<cfset rtn.message = 'Sorry - your post code was invalid, please try again'>
					<cfset StructAppend(rtn, ARGUMENTS)>
					<cfset SESSION.rtn = rtn>
					<cfreturn rtn>
				</cfcatch>
			
			</cftry>
			
			<cftry>
				<!--- Next turn the image into a blob --->
				<cfif IsDefined("ARGUMENTS.img") AND ARGUMENTS.img GT ''>
					<cfset uploadDir = ExpandPath("public/images")>
					<cffile action="upload" destination="#uploadDir#" nameconflict="makeUnique" accept="image/jpg,image/jpeg,image/pjpeg,image/png" filefield="img" result="fileUpload">		
					<!--- Resize the image --->
					<cfimage action="resize" source="#uploadDir#/#fileUpload.ServerFile#" destination="#uploadDir#/#fileUpload.ServerFile#" overwrite="true" width="640" height="" />
					<!--- Create thumbnail --->
					<cfimage action="resize" source="#uploadDir#/#fileUpload.ServerFile#" destination="#uploadDir#/thumbnails/#fileUpload.ServerFile#" overwrite="true" width="180" height="" />
				</cfif>
				
				<cfcatch type="any">
					<cfset rtn.result = false>
					<!---<cfset rtn.message = 'Sorry - there was an error uploading your photo - please only upload JPEG files (min-width 640px in landscape format)'>--->
					<cfset rtn.message = 'Sorry - there was an error uploading your photo - #cfcatch.message#'>
					<cfmail to="matthew@kingfishermedia.co.uk" bcc="andy@raiseatree.co.uk" from="no-reply@kingfishercontent.co.uk" subject="Error Adding Listing" server="smtp.gmail.com" useTLS="true" port="587" username="hello@raiseatree.co.uk" password="manutd88" type="html">
						<cfoutput>
							<p><strong>Error Received on Client Listing Page</strong></p>
							<hr/>
							<p><strong>Error Message</strong><br />#cfcatch.message#</p>
							<p><strong>Error Detail</strong><br />#cfcatch.detail#</p>
							<hr/>
							<p><strong>Customer Details:</strong></p>
							<p><strong>Company Name</strong><br />#ARGUMENTS.title#</p>
							<p><strong>Description</strong><br />#ARGUMENTS.body#</p>
							<p><strong>Post Code</strong><br />#ARGUMENTS.postcode#</p>
							<p><strong>Telephone</strong><br />#ARGUMENTS.phone#</p>
							<p><strong>Email</strong><br />#ARGUMENTS.email#</p>
							<p><strong>Website</strong><br />#ARGUMENTS.website#</p>
							<cfif IsDefined("ARGUMENTS.offernumber") AND ARGUMENTS.offernumber GT ''>
								<p><strong>Website</strong><br />#ARGUMENTS.website#</p>
							</cfif>
						</cfoutput>
					</cfmail>
					<cfset StructAppend(rtn, ARGUMENTS)>
					<cfset SESSION.rtn = rtn>
					<cfreturn rtn>
				</cfcatch>
				
			</cftry>
				
			<!--- Check whether we want the listing to go live immediately or be enabled first --->
			<cfif IsDefined("ARGUMENTS.EntryType") AND ARGUMENTS.EntryType EQ 'Client'>
				<cfset enabled = 0>
			<cfelse>
				<cfset enabled = 1>
			</cfif>
				
			<cftry>	
			
				<!--- Now add the data to the db --->
				<cfquery name="rsAdd" datasource="#Application.DataSource#" result="newEntry" timeout="600">
					INSERT INTO entries (cID,catID,scID,title,body,latitude,longitude,web,email,phone,img,postcode,enabled,ordernumber) VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cID#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.catID#">,
						<cfif IsDefined("ARGUMENTS.scID")>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.scID#">,
						<cfelse>
							0,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#REReplace(ARGUMENTS.title,'<[^>]*>','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#REReplace(ARGUMENTS.body,'<[^>]*>','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="12" value="#lat#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="12" value="#lng#">,
						<cfif IsDefined("ARGUMENTS.website")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.website#">,
						<cfelse>
							'',
						</cfif>
						<cfif IsDefined("ARGUMENTS.email")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.email#">,
						<cfelse>
							'',
						</cfif>
						<cfif IsDefined("ARGUMENTS.phone")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.phone#">,
						<cfelse>
							'',
						</cfif>
						<cfif IsDefined("fileUpload.ServerFile")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileUpload.ServerFile#">,
						<cfelse>
							'',
						</cfif>
						<cfif IsDefined("ARGUMENTS.Postcode")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.postcode#">,
						<cfelse>
							'',
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#enabled#">, 
						<cfif IsDefined("ARGUMENTS.ordernumber")>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.ordernumber#">
						<cfelse>
							''
						</cfif>
					);
				</cfquery>
				
				<cfset rtn.result = true>
				<cfset rtn.message = 'Added entry successfully'>
				
				<cfif IsDefined("ARGUMENTS.EntryType") AND ARGUMENTS.EntryType EQ 'Client'>
					<!--- Read back the listing we just added --->
					<cfquery name="entry" datasource="#Application.DataSource#">
						SELECT * FROM entries 
							INNER JOIN cities ON cities.cID = entries.cID
							INNER JOIN categories ON categories.catID = entries.catID
						WHERE eID = <cfqueryparam cfsqltype="cf_sql_integer" value="#newEntry.Generated_Key#"/>
					</cfquery>
					
					<!--- Send an email off for authorisation --->
					<cfmail to="colin@kingfishermedia.co.uk" 
							cc="matthew@kingfishermedia.co.uk" 
							from="no-reply@kingfishercontent.co.uk" 
							subject="#entry.city_name# Listing Received - #ARGUMENTS.title#" 
							replyto="#entry.email#" 
							server="smtp.gmail.com" port="587" usetls="true" 
							username="hello@raiseatree.co.uk" 
							password="manutd88" type="html">
						
						<p>Listing received through Kingfishercontent.co.uk - Details Below:</p>
						<p>---</p>
						
						<p><strong>Order Number</strong><br />
						#entry.ordernumber#</p>
						
						<p><strong>City</strong><br />
						#entry.city_name#</p>
						
						<p><strong>Category</strong><br />
						#entry.category_name#</p>
						
						<p><strong>Title</strong><br />
						#entry.title#</p>
						
						<p><strong>Description</strong><br />
						#entry.body#</p>
						
						<p><strong>Web Address</strong><br />
						#entry.web#</p>
						
						<p><strong>Email Address</strong><br />
						#entry.email#</p>
						
						<p><strong>Phone</strong><br />
						#entry.phone#</p>
						
						<p><strong>Image</strong><br />
						#entry.img#<br />
						<cfif entry.img GT ''><img src="http://www.kingfishercontent.co.uk/public/images/#entry.img#"><cfelse>No Image</cfif></p>
						
						<p><a href="http://www.kingfishercontent.co.uk/approve.cfm?eID=#encrypt(entry.eID, 'raiseatree12','CFMX_COMPAT','hex')#">Approve Listing</p>
						<p><a href="http://www.kingfishercontent.co.uk/edit-entry.cfm?eID=#entry.eID#&catID=#entry.catID#">Edit Listing</p>
						
					</cfmail>
					
					<cfset rtn.redirect = 'client-thanks.cfm'>
				<cfelse>
					<cfset rtn.redirect = 'view-entries.cfm?message=AddedEntry&catID=' & ARGUMENTS.catID>
				</cfif>

				<cfcatch type="any">
					<cfset rtn.result = false>
					<cfset rtn.message = 'Sorry - an unknown error occurred, please try again (note - we have received notification about this issue)'>
					
					<cfmail cc="andy@raiseatree.co.uk"
							from="no-reply@kingfishercontent.co.uk" 
							subject="Error - Kingfisher Content" 
							server="smtp.gmail.com" port="587" usetls="true" 
							username="hello@raiseatree.co.uk" 
							password="manutd88" type="html">
					
						<cfdump var="#cfcatch#" label="Catch">
						<cfdump var="#ARGUMENTS#" label="Arguments">
					
					</cfmail>
					
					<cfreturn rtn>
				
				</cfcatch>
				
			</cftry>
				
			<!--- Delete the session var we used for error reporting, if exists --->
			<cfif IsDefined("SESSION.rtn") OR IsDefined("SESSION.error") >
				<cfset StructDelete(SESSION, "rtn")>
				<cfset StructDelete(SESSION, "error")>
			</cfif>

		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Insufficient access for adding entries'>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="AddSubCat" access="public">
		<cfargument name="catID" type="numeric" required="yes" />
		<cfargument name="sub_category_name" type="string" required="yes" />
		
		<cfset rtn = StructNew()>
		
		<!--- Add the new sub cat --->
		<cftry>
			<cfquery name="rsAdd" datasource="#Application.DataSource#">
				INSERT INTO sub_categories (catID,sub_category_name) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.catID#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.sub_category_name#">);
			</cfquery>
			
			<cfset rtn.result = true>
			<cfset rtn.message = 'Added sub-category successfully'>
			
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = 'Could not add sub category'>
			</cfcatch>
		</cftry>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="Approve">
		<cfargument name="eID" type="numeric" required="yes">
		
		<!--- Approve the listing --->
		<cfquery name="rsApprove" datasource="#Application.DataSource#">
			UPDATE entries SET enabled = 1 WHERE eID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.eID#">
		</cfquery>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="DeleteEntry" access="public">
		<cfargument name="eID" type="numeric" required="yes" />
		<cfargument name="catID" type="numeric" required="no" />
		
		<cfset rtn = StructNew()>

		<!--- Delete the entry --->
		<cftry>
			<cfquery name="rsDel" datasource="#Application.DataSource#">
				DELETE FROM entries WHERE eID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.eID#"> LIMIT 1;
			</cfquery>
			
			<cfset rtn.result = true>
			<cfset rtn.message = 'Deleted entry successfully'>
			
			<cfif IsDefined("ARGUMENTS.catID")>
				<cfset rtn.redirect = 'view-entries.cfm?message=DeletedEntry&catID=' & ARGUMENTS.catID>
			<cfelse>
				<cfset rtn.redirect = 'view-entries.cfm?message=DeletedEntry'>
			</cfif>
			
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = 'Could not delete entry'>
			</cfcatch>
		</cftry>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="DeleteSubCat" access="public">
		<cfargument name="scID" type="numeric" required="yes" />
		<cfargument name="APIToken" type="string" required="yes" />
		
		<cfset rtn = StructNew()>
		
		<!--- Check we've received an API Token, otherwise do not delete --->
		<cfif IsDefined("ARGUMENTS.APIToken") AND ARGUMENTS.APIToken EQ 'raiseatree12'>
		
			<!--- Add the new sub cat --->
			<cftry>
				<cfquery name="rsDel" datasource="#Application.DataSource#">
					DELETE FROM sub_categories WHERE scID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.scID#"> LIMIT 1;
				</cfquery>
				
				<cfset rtn.result = true>
				<cfset rtn.message = 'Deleted sub-category successfully'>
				
				<cfcatch type="any">
					<cfset rtn.result = false>
					<cfset rtn.message = 'Could not delete sub-category'>
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Insufficient access to deleting category'>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="EditEntry" access="public">
		<cfargument name="eID" type="numeric" required="yes">
		<cfargument name="catID" type="numeric" required="yes">
		<cfargument name="scID" type="numeric" required="no">
		<cfargument name="title" type="string" required="yes">
		<cfargument name="body" type="string" required="yes">
		<cfargument name="postcode" type="string" required="yes">
		<cfargument name="website" type="string" required="no">
		<cfargument name="email" type="string" required="no">
		<cfargument name="phone" type="string" required="no">
		<cfargument name="img" type="string" required="no">
		<cfargument name="enabled" type="numeric" required="no">
		<cfargument name="APIToken" type="string" required="no">
		
		<!--- Form the return structure --->
		<cfset rtn = StructNew()>
		
		<!--- Check we've received an API Token, otherwise do not delete --->
		<cfif IsDefined("ARGUMENTS.APIToken") AND ARGUMENTS.APIToken EQ 'raiseatree12'>
		
			<cftry>
				<!--- Start by getting the lat/lon from Google --->
				<cfset address = "http://maps.googleapis.com/maps/api/geocode/json?address=" &  replace(ARGUMENTS.postCode,' ','+','ALL') & "&sensor=false">
				<cfhttp url="#address#" result="google" />
				<cfset data = DeserializeJSON(google.FileContent)>
				<cfset lat = data.results[1].geometry.location.lat>
				<cfset lng = data.results[1].geometry.location.lng>
				
				<!--- Next see if we need to upload a new image --->
				<cfif IsDefined("ARGUMENTS.img") AND ARGUMENTS.img GT ''>
					<cfset uploadDir = ExpandPath("public/images")>
					<cffile action="upload" destination="#uploadDir#" nameconflict="makeUnique" filefield="img" result="fileUpload">		
					<!--- Resize the image --->
					<cfimage action="resize" source="#uploadDir#/#fileUpload.ServerFile#" destination="#uploadDir#/#fileUpload.ServerFile#" overwrite="true" width="640" height="" />
					<!--- Create thumbnail --->
					<cfimage action="resize" source="#uploadDir#/#fileUpload.ServerFile#" destination="#uploadDir#/thumbnails/#fileUpload.ServerFile#" overwrite="true" width="180" height="" />
				</cfif>
				
				<!--- Update the entry --->
				<cfquery name="rsUpdate" datasource="#Application.DataSource#">
					UPDATE entries SET title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.title#">, 
						body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.body#">, 
						latitude = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lat#">, 
						longitude = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lng#">
						<cfif IsDefined("ARGUMENTS.website") AND ARGUMENTS.website GT ''>
							,web = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.website#"> 
						</cfif>
						<cfif IsDefined("ARGUMENTS.email") AND ARGUMENTS.email GT ''>
							,email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.email#">
						</cfif>
						<cfif IsDefined("ARGUMENTS.phone") AND ARGUMENTS.phone GT ''>
							,phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.phone#">
						</cfif>
						<cfif IsDefined("fileUpload.ServerFile") AND fileUpload.ServerFile GT ''>
							,img = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileUpload.ServerFile#">
						</cfif>
						<cfif IsDefined("ARGUMENTS.postcode") AND ARGUMENTS.postcode GT ''>
							,postcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.postcode#">
						</cfif>
						<cfif IsDefined("ARGUMENTS.enabled") AND ARGUMENTS.enabled GT ''>
							,enabled = <cfqueryparam cfsqltype="cf_sql_bit" value="#ARGUMENTS.enabled#">
						</cfif>
					WHERE eID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.eID#">; 
				</cfquery>
				
				<!--- Update the return --->
				<cfset rtn.result = true>
				<cfset rtn.message = 'Updated entry successfully'>
				<cfset rtn.redirect = 'view-entries.cfm?message=EditedEntry&catID=' & ARGUMENTS.catID>
			
				<cfcatch type="any">
					<cfset rtn.result = false>
					<cfset rtn.message = 'Entry could not be updated'>
					<cfdump var="#cfcatch#">
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Insufficient access to editing entry'>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="GetSubCats" access="public">
		<cfargument name="ReturnFormat" required="yes">
		<cfargument name="catID" required="yes" />
		
		<cfset rtn = StructNew()>
		
		<cftry>
			
			<!--- Get the category name and sub-cats from the db --->
			<cfquery name="rsGetCat" datasource="#Application.DataSource#">
				SELECT * FROM categories
					INNER JOIN sub_categories ON sub_categories.catID = categories.catID
				WHERE categories.catID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.catID#">;
			</cfquery>
			
			<cfset rtn.result = true>
			<cfset rtn.data = rsGetCat>
		
			<cfcatch type="any">
				<cflog file="Entry" type="info" text="#cfcatch#">
			</cfcatch>
			
		</cftry>
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
		
	</cffunction>
	
	<cffunction name="GetEntries" access="public">
		<cfargument name="ReturnFormat" type="string" required="yes">
		<cfargument name="cID" type="numeric" required="yes" hint="City ID to return all entries for">
		<cfargument name="catID" type="numeric" required="no" hint="Category ID to return entries for">
		
		<cfset rtn = StructNew()>
		
		<!--- Get a list of entries based on this category --->
		<cfquery name="rsGetEntries" datasource="#Application.DataSource#">
			SELECT * FROM entries
				LEFT OUTER JOIN sub_categories ON sub_categories.scID = entries.scID
				INNER JOIN categories ON categories.catID = entries.catID
				LEFT OUTER JOIN offers ON offers.eID = entries.eID
			WHERE entries.cID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cID#">
			<cfif IsDefined("ARGUMENTS.catID") AND ARGUMENTS.catID NEQ 0> 
				AND categories.catID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.catID#">
			</cfif>
			<cfif IsDefined("ARGUMENTS.ReturnFormat") AND ARGUMENTS.ReturnFormat EQ 'JSON'>
				AND entries.enabled = 1
			</cfif>
		</cfquery>
		
		<!--- Loop through the query and set the offer_code equal to null if no query (to help legacy apps to avoid showing offer available) --->
		<cfloop query="rsGetEntries">
			<cfif rsGetEntries.offer_code EQ "">
				<cfset QuerySetCell(rsGetEntries, "offer_code", "null", CurrentRow)>
			</cfif>
		</cfloop>
		
		<cfif rsGetEntries.RecordCount GT 0>
			<cfset rtn.result = true>
			<cfset rtn.message = 'Request OK'>
			
			<cfset rtn.data = rsGetEntries>
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'No Entries to return'>
		</cfif>
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="GetEntry" access="public">
		<cfargument name="ReturnFormat" type="string" required="yes">
		<cfargument name="eID" type="numeric" required="yes" hint="Entry ID to return data for">
		
		<cfset rtn = StructNew()>
		
		<!--- Get the entry --->
		<cfquery name="rsGetEntry" datasource="#Application.DataSource#">
			SELECT * FROM entries
				LEFT OUTER JOIN sub_categories ON sub_categories.scID = entries.scID
				LEFT OUTER JOIN categories ON categories.catID = sub_categories.catID
			WHERE entries.eID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.eID#">;
		</cfquery>
		
		<cfif rsGetEntry.RecordCount EQ 1>
			<cfset rtn.result = true>
			<cfset rtn.message = 'Request OK'>
			<cfset rtn.data = rsGetEntry>
			
			<!--- Work out the post code of the entry 
			<cfset address = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" & rtn.data.latitude & ',' & rtn.data.longitude & '&sensor=false'>
			<cfhttp url="#address#" result="google" />
			<cfset data = DeserializeJSON(google.FileContent)>
			<cfset rtn.postcode = data.results[1].address_components[1].long_name>--->
		<cfelse>
			<cfset rtn.result = false>
			<cfset rtn.message = 'Entry not found'>
		</cfif>	
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="RecordView">
		<cfargument name="eID" type="numeric" required="yes" />
		<cfargument name="uuid" type="string" required="yes" />
		<cfargument name="locale" type="string" required="yes" />
		
		<cftry>
			<!--- Create the return doc --->
			<cfset rtn = StructNew()>
				
			<!--- Work out the date time stamp --->
			<cfset dateTimeStamp = DateFormat(now(),'yyyy-mm-dd') & ' ' & TimeFormat(now(),'HH:MM:SS')>
			
			<!--- Insert into the db --->
			<cfquery name="rsAdd" datasource="#Application.DataSource#">
				INSERT INTO entry_views (eID,uuID,dateTimeStamp,locale) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.eID#"/>,  
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="40" value="#ARGUMENTS.uuID#"/>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="40" value="#dateTimeStamp#"/>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="10" value="#ARGUMENTS.locale#"/>)
			</cfquery>
		
			<cfset rtn.result = true>
			<cfset rtn.message = 'View recorded ok'>
				
			<!--- Catch any errors --->
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = 'Could not record view, please try again'>
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
	
	<cffunction name="RecordEditorialView">
		<cfargument name="cID" type="numeric" required="yes" />
		<cfargument name="catID" type="numeric" required="yes" />
		<cfargument name="uuid" type="string" required="yes" />
		<cfargument name="locale" type="string" required="yes" />
		<cfargument name="position" type="string" required="yes" />
		
		<cftry>
			<!--- Create the return doc --->
			<cfset rtn = StructNew()>
				
			<!--- Work out the date time stamp --->
			<cfset dateTimeStamp = DateFormat(now(),'yyyy-mm-dd') & ' ' & TimeFormat(now(),'HH:MM:SS')>
			
			<!--- Insert into the db --->
			<cfquery name="rsAdd" datasource="#Application.DataSource#">
				INSERT INTO editorial_views (cID,catID,uuID,dateTimeStamp,locale,position) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cID#"/>,  
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.catID#"/>,  
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="40" value="#ARGUMENTS.uuID#"/>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="40" value="#dateTimeStamp#"/>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="100" value="#ARGUMENTS.locale#"/>, 
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="5" value="#ARGUMENTS.position#"/>)
			</cfquery>
		
			<cfset rtn.result = true>
			<cfset rtn.message = 'View recorded ok'>
				
			<!--- Catch any errors --->
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = 'Could not record view, please try again'>
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>
</cfcomponent>