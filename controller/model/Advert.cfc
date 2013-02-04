<cfcomponent>	
	
	<cffunction name="add">
		<cfargument name="cID" type="numeric" required="yes">
		<cfargument name="catID" type="any" required="no">
		
		<cfset rtn = StructNew()>
		
		<!--- Reset the catID if it's the main city sponsor --->
		<cfif ARGUMENTS.catID EQ 'Main City Sponsor'>
			<cfset ARGUMENTS.catID = ''>
		</cfif>
		
		<cftry>
			<cfif IsDefined("ARGUMENTS.img") AND ARGUMENTS.img GT ''>
				<cfset uploadDir = ExpandPath("public/images/adverts")>
				<cffile action="upload" destination="#uploadDir#" nameconflict="makeUnique" accept="image/jpg,image/jpeg,image/pjpeg,image/png,image/gif" filefield="img" result="fileUpload">
				
				<!--- Read the image --->
				<cfimage action="read" source="#uploadDir#/#fileUpload.ServerFile#" name="uploadedImg"/>
				
				<!--- Check if we need to resize --->
				<cfif uploadedImg.width GT 640>
				
					<!--- Resize the original image --->
					<cfimage action="resize" source="#uploadDir#/#fileUpload.ServerFile#" destination="#uploadDir#/#fileUpload.ServerFileName#2x.#fileUpload.ServerFileExt#" overwrite="true" width="640" height="100" />
				
				<cfelse>
					
					<!--- Just rename the uploaded image --->
					<cffile action="rename" source="#uploadDir#/#fileUpload.ServerFile#" destination="#uploadDir#/#fileUpload.ServerFileName#2x.#fileUpload.ServerFileExt#" />
				
				</cfif>
				
				<!--- Create non-retina version --->
				<cfimage action="resize" source="#uploadDir#/#fileUpload.ServerFileName#2x.#fileUpload.ServerFileExt#" destination="#uploadDir#/#fileUpload.ServerFile#" overwrite="true" width="320" height="50" />

			</cfif>
			
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = cfcatch.Message>
				<cfreturn rtn>
			</cfcatch>
				
		</cftry>
		
		<cftry>
		
			<!--- Add the advert --->
			<cfquery name="rsAddAdvert" datasource="#Application.DataSource#">
				INSERT INTO adverts (cID, catID, img, imgRetina, url, startDate, endDate) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cID#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.catID#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileUpload.ServerFile#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileUpload.ServerFileName#2x.#fileUpload.ServerFileExt#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.url#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.startDate#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.endDate#">);
			</cfquery>
			
			<cfset rtn.result = true>
			<cfset rtn.message = 'Advert was added successfully'>
			<cfset rtn.redirect = 'view-ads.cfm?message=AddedAd'>
			
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = cfcatch.Message>
				<cfreturn rtn>
			</cfcatch>
			
		</cftry>
		
		<cfreturn rtn>
	
	</cffunction>

	<cffunction name="delete">
		
		<cfset rtn = StructNew()>
	
		<cfif IsDefined("ARGUMENTS.adID")>
		
			<cftry>
			
				<cfquery name="rsDel" datasource="#Application.DataSource#">
					DELETE FROM adverts WHERE adID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.adID#">	LIMIT 1;
				</cfquery>
				
				<cfset rtn.result = true>
				<cfset rtn.redirect = 'view-ads.cfm?message=DeletedAd'>
				
				<cfcatch type="any">
					<cfset rtn.result = false>
					<cfset rtn.message = cfcatch.Message>
					<cfreturn rtn>
				</cfcatch>
				
			</cftry>
		
		</cfif>
		
		<cfreturn rtn>
	
	</cffunction>

	<cffunction name="edit">
		
		<cfset rtn = StructNew()>
		
		<!--- Reset the catID if it's the main city sponsor --->
		<cfif ARGUMENTS.catID EQ 'Main City Sponsor'>
			<cfset ARGUMENTS.catID = ''>
		</cfif>
		
		<cftry>
			<cfif IsDefined("ARGUMENTS.img") AND ARGUMENTS.img GT ''>
				<cfset uploadDir = ExpandPath("public/images/adverts")>
				<cffile action="upload" destination="#uploadDir#" nameconflict="makeUnique" accept="image/jpg,image/jpeg,image/pjpeg,image/png" filefield="img" result="fileUpload">
				
				<!--- Resize the image --->
				<cfimage action="resize" source="#uploadDir#/#fileUpload.ServerFile#" destination="#uploadDir#/#fileUpload.ServerFileName#2x.#fileUpload.ServerFileExt#" overwrite="true" width="640" height="100" />
				
				<!--- Create non-retina version --->
				<cfimage action="resize" source="#uploadDir#/#fileUpload.ServerFile#" destination="#uploadDir#/#fileUpload.ServerFile#" overwrite="true" width="320" height="50" />

			</cfif>
			
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = cfcatch.Message>
				<cfreturn rtn>
			</cfcatch>
				
		</cftry>
		
		<cftry>
		
			<!--- Update the advert --->
			<cfquery name="rsUpdateAdvert" datasource="#Application.DataSource#">
				UPDATE adverts SET
					catID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.catID#">, 
					<cfif IsDefined("fileUpload.ServerFile")>
						img = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileUpload.ServerFile#">, 
						imgRetina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileUpload.ServerFileName#2x.#fileUpload.ServerFileExt#">, 
					</cfif>
					url = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.url#">, 
					startDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.startDate#">, 
					endDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.endDate#">
				WHERE adID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.adID#">;
			</cfquery>
			
			<cfset rtn.result = true>
			<cfset rtn.message = 'Advert was updated successfully'>
			<cfset rtn.redirect = 'view-ads.cfm?message=EditedAd'>
			
			<cfcatch type="any">
				<cfset rtn.result = false>
				<cfset rtn.message = cfcatch.Message>
				<cfreturn rtn>
			</cfcatch>
			
		</cftry>

		<cfreturn rtn>
	
	</cffunction>

	<cffunction name="view">
		<cfargument name="ReturnFormat" type="any" required="yes">
		<cfargument name="cID" type="numeric" required="no">
		<cfargument name="catID" type="numeric" required="no">
		<cfargument name="adID" type="numeric" required="no">
		<cfargument name="blnDate" type="any" required="no">
		
		<cfset rtn = StructNew()>
		
		<!--- Get a list of adverts --->
		<cfquery name="rsGetAds" datasource="#Application.DataSource#">
			SELECT * FROM adverts
				LEFT JOIN categories ON categories.catID = adverts.catID
			WHERE 
			<cfif IsDefined("ARGUMENTS.cID") AND IsNumeric(ARGUMENTS.cID)>
				cID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.cID#">
			</cfif>
			<cfif IsDefined("ARGUMENTS.adID") AND IsNumeric(ARGUMENTS.adID)>
				adID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.adID#">
			</cfif>
			
			<cfif Not(IsDefined("ARGUMENTS.blnDate"))>
				AND startDate <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(now(), 'yyyy-mm-dd')#">
				AND endDate >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(now(), 'yyyy-mm-dd')#">
			</cfif>
				
			<cfif IsDefined("ARGUMENTS.catID")>
				<cfif ARGUMENTS.catID EQ 0>
					AND adverts.catID IS NULL
				<cfelse>
					AND adverts.catID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.catID#">
				</cfif>
			</cfif>
			<cfif IsDefined("ARGUMENTS.adID") AND IsNumeric(ARGUMENTS.adID)>
				AND adID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.adID#">
			</cfif>
			ORDER BY adverts.catID;
		</cfquery>
		
		<!--- Check if we found at least one record otherwise fill the query with the placeholder --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON' AND rsGetAds.RecordCount EQ 0>
			
			<cfset QueryAddRow(rsGetAds, 1)>
			<cfset QuerySetCell(rsGetAds, 'adID', 'xxx', 1)>
			<cfset QuerySetCell(rsGetAds, 'cID', 'xxx', 1)>
			<cfset QuerySetCell(rsGetAds, 'catID', 'xxx', 1)>
			<cfset QuerySetCell(rsGetAds, 'category_name', 'xxx', 1)>
			<cfset QuerySetCell(rsGetAds, 'img', 'ad-placeholder.png', 1)>
			<cfset QuerySetCell(rsGetAds, 'imgRetina', 'ad-placeholder2x.png', 1)>
			<cfset QuerySetCell(rsGetAds, 'url', 'http://www.kingfishermedia.co.uk', 1)>
		
		<cfelse>
			
			<cfif right(rsGetAds.img,3) EQ 'gif'>
				<cfif findNoCase('kingfishercontent.co.uk', CGI.HTTP_HOST) EQ 0>
					
					<!--- Write the regular image --->
					<cffile action="write" 
						file="#ExpandPath('../../kingfisher/public/images/adverts/html')#/#rsGetAds.adID#.htm" 
						output="<html><body style='margin: 0px'><img src='http://www.kingfishercontent.co.uk/public/images/adverts/#rsGetAds.img#'/></body></html>" 
						nameconflict="overwrite" />
						
					<!--- Write the retina image --->
					<cffile action="write" 
						file="#ExpandPath('../../kingfisher/public/images/adverts/html')#/#rsGetAds.adID#.htm" 
						output="<html><body style='margin: 0px'><img src='http://www.kingfishercontent.co.uk/public/images/adverts/#rsGetAds.imgRetina#'/></body></html>" 
						nameconflict="overwrite" />
				
				<cfelse>
				
					<!--- Write the regular image --->
					<cffile action="write" 
						file="#ExpandPath('../public/images/adverts/html')#/#rsGetAds.adID#.htm" 
						output="<html><body style='margin: 0px'><img src='http://www.kingfishercontent.co.uk/public/images/adverts/#rsGetAds.img#'/></body></html>" 
						nameconflict="overwrite" />
						
					<!--- Write the retina image --->
					<cffile action="write" 
						file="#ExpandPath('../public/images/adverts/html')#/#rsGetAds.adID#.htm" 
						output="<html><body style='margin: 0px'><img src='http://www.kingfishercontent.co.uk/public/images/adverts/#rsGetAds.imgRetina#'/></body></html>" 
						nameconflict="overwrite" />
				
				</cfif>
						
				<cfset QuerySetCell(rsGetAds, 'img', 'html/#rsGetAds.adID#.htm', 1)>
				<cfset QuerySetCell(rsGetAds, 'imgRetina', 'html/#rsGetAds.adID#2x.htm', 1)>
				
			</cfif>
			
		</cfif>
		
		<cfset rtn.data = rsGetAds>
		<cfset rtn.result = true>
		
		<!--- See if we need to wrap up the JSON to return --->
		<cfif ARGUMENTS.ReturnFormat EQ 'JSON'>
			<cfset rtn = SerializeJSON(rtn)>
		</cfif>
		
		<cfreturn rtn>
	</cffunction>

</cfcomponent>