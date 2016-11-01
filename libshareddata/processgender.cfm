<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processgender.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Shared Data - Gender --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data - Gender</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSGENDER EQ "ADD" OR FORM.PROCESSGENDER EQ "MODIFY">
	<CFQUERY name="ModifyGender" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	GENDER
		SET		LIBQUALGENDERID = #val(FORM.LIBQUALGENDERID)#,
				GENDERNAME = '#FORM.GENDERNAME#'
		WHERE	(GENDERID = #val(Cookie.GENDERID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSGENDER EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/gender.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/gender.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSGENDER EQ "DELETE" OR FORM.PROCESSGENDER EQ "CANCELADD">
	<CFQUERY name="DeleteGender" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	GENDER
		WHERE		GENDERID = #val(Cookie.GENDERID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSGENDER EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/gender.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>