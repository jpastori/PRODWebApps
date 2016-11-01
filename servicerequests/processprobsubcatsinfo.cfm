<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processprobsubcatsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests Problem Sub-Categories --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Problem Sub-Categories</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPROBLEMSUBCATEGORIES EQ "ADD" OR FORM.PROCESSPROBLEMSUBCATEGORIES EQ "MODIFY">
	<CFQUERY name="ModifyProblemSubCategories" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	PROBLEMSUBCATEGORIES
		SET		SUBCATEGORYLETTERID = #val(FORM.SUBCATEGORYLETTERID)#,
				SUBCATEGORYNAME = UPPER('#FORM.SUBCATEGORYNAME#')
		WHERE	(SUBCATEGORYID = #val(Cookie.SUBCATEGORYID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPROBLEMSUBCATEGORIES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/probsubcatsinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/probsubcatsinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPROBLEMSUBCATEGORIES EQ "DELETE" OR FORM.PROCESSPROBLEMSUBCATEGORIES EQ "CANCELADD">
	<CFQUERY name="DeleteProblemSubCategories" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	PROBLEMSUBCATEGORIES
		WHERE		SUBCATEGORYID = #val(Cookie.SUBCATEGORYID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPROBLEMSUBCATEGORIES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/probsubcatsinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>