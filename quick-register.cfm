<cfif IsDefined("FORM.btnSubmit")>
	<cfset authKeyLocation = expandpath('auth/key.txt')>
	<cffile action="read" file="#authKeyLocation#" variable="authkey">
	
	<cfset theSalt = CreateUUID()>
	<cfset passwordHash = Hash(FORM.password & theSalt, 'SHA-512')>
	
	<cfset salt = encrypt(theSalt,authKey,'CFMX_COMPAT','hex')>
	
	<cfquery name="rsInsert" datasource="#Application.DataSource#">
		INSERT INTO users (email,password,password_salt,roles) VALUES (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#passwordHash#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#salt#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="Admin">);
	</cfquery>
	
	<cfoutput>User added successfully<br /><br /></cfoutput>
</cfif>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>		
<cfform name="frmRegister" action="quick-register.cfm" method="post">
	Email - <cfinput type="text" name="email" required="yes" message="Please enter the email address"><br />
	Password - <cfinput type="password" name="password" required="yes" message="Please enter the password"><br />
	<cfinput type="submit" name="btnSubmit" value="Add User">
</cfform>

</body>
</html>