<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcampusmailcodes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data Campus Mail Codes Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Campus Mail Codes Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCAMPUSMAILCODES EQ "ADD" OR FORM.PROCESSCAMPUSMAILCODES EQ "MODIFY">
	<CFQUERY name="ModifyCampusMailCodes" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	CAMPUSMAILCODES
		SET		CAMPUSMAILCODE = '#FORM.CAMPUSMAILCODE#'
		WHERE	(CAMPUSMAILCODEID = #val(Cookie.CAMPUSMAILCODEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCAMPUSMAILCODES EQ "ADD">
		<H1>Data ADDED! </H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/campusmailcodes.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED! </H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/campusmailcodes.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCAMPUSMAILCODES EQ "DELETE" OR FORM.PROCESSCAMPUSMAILCODES EQ "CANCELADD">
	<CFQUERY name="DeleteCampusMailCodes" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	CAMPUSMAILCODES 
		WHERE		CAMPUSMAILCODEID = #val(Cookie.CAMPUSMAILCODEID)#
	</CFQUERY>
	<H1>Data DELETED! </H1>
	<CFIF FORM.PROCESSCAMPUSMAILCODES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/campusmailcodes.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>