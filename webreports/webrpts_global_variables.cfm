<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: webrpts_global_variables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/24/2010 --->
<!--- Date in Production: 01/24/2010 --->
<!--- Module: Web Reports Application Global Variables Page --->
<!-- Last modified by John R. Pastori on 01/24/2010 using ColdFusion Studio: -->

<!--- SET SESSION VARIABLES --->
<CFSET session.ABSENCEREQUESTIDArray = ArrayNew(1)>

<!--- 
	This variable is used to check if a program is being called from the /files/ directory or a program is 
	being called from the forms/ directory.
 --->
<CFSET SESSION.ORIGINSERVER = "">

<!--- SET APPLICATION VARIABLES --->
<CFIF NOT IsDefined('application.type')>
	<CFPARAM name="application.type" default="PROD">
	<CFSET application.type = "PROD">
</CFIF>
<CFSET application.webreports_initialized = 1>
<CFSET application.initialized = 1>