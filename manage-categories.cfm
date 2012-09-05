<cfparam name="URL.catID" default="7">

<cfscript>
	// Get the Category & Sub-Categories
	data = StructNew();
	data.ReturnFormat = 'struct';
	data.cmd = 'GetSubCats';
	data.catID = URL.catID;
	obj = CreateObject("component","controller.index").init(data);
</cfscript>

<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="public/css/global.css" />
<title>Add New Entry - Kingfisher Media</title>
<script language="javascript" type="text/javascript" src="public/js/jQuery.min.js"></script>
<script language="javascript" type="text/javascript" src="public/js/application.js"></script>
<script language="javascript" type="text/javascript" src="public/js/Modernizr2-custom.js"></script>
</head>

<body>
<cfoutput>
	<div id="holder">
		<div id="smallLogo"></div>
		<div class="greyBox centre overflow">
			<div class="grid2 fl cb">
				<h2>Add Sub-Category</h2>
				<cfform name="frmAddSubCat" method="post">
					<p>
						<input type="text" name="sub_category_name" placeholder="Sub-Category Name" required class="textInput darkPink" />
					</p>
					<p>
						<input type="hidden" name="cmd" value="AddSubCat" />
						<input type="hidden" name="catID" value="#URL.catID#" />
						<input type="submit" name="btnSubmit" value="Add" class="fl bigPinkBtn" />
					</p>
				</cfform>
			</div>
				
			<div class="grid2 fr">
				<h2 class="cb">Delete Sub Categories</h2>
				<table>
					<tr>
						<th>Sub-Category Name</th>
						<th>Delete?</th>
					</tr>
					<cfloop query="obj.data">
						<tr>
							<td>#obj.data.sub_category_name#</td>
							<td><a href="manage-categories.cfm?cmd=DeleteSubCat&catID=#URL.catID#&scID=#obj.data.scID#" class="confirmDelete">Delete</a></td>
						</tr>
					</cfloop>
				</table>
			</div>
		</div><br/>
		<div class="bigPinkBtnBackText"><a href="add-entry.cfm?catID=#URL.catID#">Back</a></div>
	</div>
</cfoutput>
</body>
</html>