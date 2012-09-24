<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>New Kingfisher Media - Content Management</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<div id="holder">
	<div id="largeLogo" class="centre"></div>
	<div id="login" class="greyBox centre">
		<cfif IsDefined("SESSION.error")><div class="error"><cfoutput>#SESSION.error#</cfoutput></div></cfif>
		<cfform name="frmLogin" method="post">
			<p><label>Email:</label><br /><input type="email" name="email" required placeholder="Email Address" class="textInput darkPink" /></p>
			<p><label>Password:</label><br /><input type="password" name="password" required placeholder="Password" class="textInput darkPink" /></p>
			<p class="overflow">
				<cfinput type="hidden" name="cmd" value="Login" />
				<cfinput type="submit" name="btnSubmit" value="Login" class="fr bigPinkBtn" />
			</p>
		</cfform>
	</div>
</div>
</body>
</html>