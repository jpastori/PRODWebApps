<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processprobcatsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests Problem Categories --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Problem Categories</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPROBLEMCATEGORIES EQ "ADD" OR FORM.PROCESSPROBLEMCATEGORIES EQ "MODIFY">
	<CFQUERY name="ModifyProblemCategories" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	PROBLEMCATEGORIES
		SET		CATEGORYLETTER = UPPER('#FORM.CATEGORYLETTER#'),
				CATEGORYNAME = UPPER('#FORM.CATEGORYNAME#')
		WHERE	(CATEGORYID = #val(Cookie.CATEGORYID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPROBLEMCATEGORIES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/probcatsinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/probcatsinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPROBLEMCATEGORIES EQ "DELETE" OR FORM.PROCESSPROBLEMCATEGORIES EQ "CANCELADD">
	<CFQUERY name="DeleteProblemCategories" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	PROBLEMCATEGORIES
		WHERE		CATEGORYID = #val(Cookie.CATEGORYID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPROBLEMCATEGORIES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/probcatsinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>