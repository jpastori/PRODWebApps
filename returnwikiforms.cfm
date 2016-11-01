<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: returnwikiforms.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/06/2012 --->
<!--- Date in Production: 09/06/2012 --->
<!--- Module: Instruction - Return to Page Originally Called From --->
<!-- Last modified by John R. Pastori on 06/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.eduu">
<cfset DOCUMENT_URI = "/#application.type#apps/returnwikiforms.cfm">
<cfset CONTENT_UPDATED = "June 30, 2016">

<html>
<head>
	<title>Instruction - Return to Page Originally Called From</title>
</head>

<body>

<cfoutput>
	<cfset SESSION.RETURNINDEX = "">
	<cfif #SESSION.ORIGINSERVER# EQ "LFOLKSWIKI">
     	<cfset SESSION.RETURNINDEX = "#SESSION.ORIGINSERVER#">
		<meta http-equiv="Refresh" content="0; URL=https://lfolkswiki.sdsu.edu/index.php/Forms">
          <cfexit>
	<cfelseif #SESSION.ORIGINSERVER# EQ "FORMS">
     	<cfset SESSION.RETURNINDEX = "#SESSION.ORIGINSERVER#">
		<meta http-equiv="Refresh" content="0; URL=https://lfolks.sdsu.edu/PRODapps/forms/index.cfm">
          <cfexit>
     <cfelseif #SESSION.ORIGINSERVER# EQ "ROHAN">
     	<cfset SESSION.RETURNINDEX = "#SESSION.ORIGINSERVER#">
		<meta http-equiv="Refresh" content="0; URL=http://www-rohan.sdsu.edu/~infosys/ist/requests.html">
          <cfexit>
     <cfelseif #SESSION.ORIGINSERVER# EQ "JOEL">
     	<cfset SESSION.RETURNINDEX = "#SESSION.ORIGINSERVER#">
		<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/joelssrindex.cfm">
          <cfexit>
	<cfelse>
     	<cfset SESSION.RETURNINDEX = "BLANK">
		<meta http-equiv="Refresh" content="0; URL=#Cookie.INDEXDIR#/index.cfm?logout=No">
          <cfexit>
	</cfif>
     
</cfoutput>

</body>
</html>