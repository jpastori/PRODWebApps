<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processageranges.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Shared Data - Age Ranges --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data - Age Ranges</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSAGERANGES EQ "ADD" OR FORM.PROCESSAGERANGES EQ "MODIFY">
	<CFQUERY name="ModifyAgeRanges" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	AGERANGES
		SET		LIBQUALAGEID = #val(FORM.LIBQUALAGEID)#,
				AGERANGENAME = '#FORM.AGERANGENAME#'
		WHERE	(AGERANGEID = #val(Cookie.AGERANGEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSAGERANGES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/ageranges.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/ageranges.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSAGERANGES EQ "DELETE" OR FORM.PROCESSAGERANGES EQ "CANCELADD">
	<CFQUERY name="DeleteAgeRanges" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	AGERANGES
		WHERE		AGERANGEID = #val(Cookie.AGERANGEID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSAGERANGES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/ageranges.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>