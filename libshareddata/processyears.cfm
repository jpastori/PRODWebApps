<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processyears.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data Years Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Years Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSYEARS EQ "ADD" OR FORM.PROCESSYEARS EQ "MODIFY">
	<CFQUERY name="ModifyYears" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	YEARS
		SET		YEAR = '#FORM.YEAR#'
		WHERE	(YEARID = #val(Cookie.YEARID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSYEARS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/years.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/years.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSYEARS EQ "DELETE" OR FORM.PROCESSYEARS EQ "CANCELADD">
	<CFQUERY name="DeleteYears" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	YEARS 
		WHERE		YEARID = #val(Cookie.YEARID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSYEARS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/years.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>