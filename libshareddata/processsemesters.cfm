<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsemesters.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->->
<!--- Module: Process Information to Library Shared Data - Semesters --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data - Semesters</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSEMESTERS EQ "ADD" OR FORM.PROCESSSEMESTERS EQ "MODIFY">
	<CFQUERY name="ModifySemesters" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	SEMESTERS
		SET		SEMESTERNAME = UPPER('#FORM.SEMESTERNAME#')
		WHERE	(SEMESTERID = #val(Cookie.SEMID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSEMESTERS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/semesters.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/semesters.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSEMESTERS EQ "DELETE" OR FORM.PROCESSSEMESTERS EQ "CANCELADD">
	<CFQUERY name="DeleteSemesters" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	SEMESTERS 
		WHERE		SEMESTERID = #val(Cookie.SEMID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSEMESTERS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/semesters.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>