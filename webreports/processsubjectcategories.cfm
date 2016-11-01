<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsubjectcategories.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Article DB Site Subject Categories --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Web Reports - Article DB Site Subject Categories</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSUBJECTCATEGORIES EQ "ADD" OR FORM.PROCESSSUBJECTCATEGORIES EQ "MODIFY">
	<CFQUERY name="ModifySubjectCategories" datasource="#application.type#WEBREPORTS">
		UPDATE	SUBJECTCATEGORIES
		SET		SUBJECTCATNAME = '#FORM.SUBJECTCATNAME#',
				SUBJECTCATURL = '#FORM.SUBJECTCATURL#',
				SUBJECTCATCOMMENTS = '#FORM.SUBJECTCATCOMMENTS#'
		WHERE	(SUBJECTCATID = #val(Cookie.SUBJECTCATID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSUBJECTCATEGORIES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/subjectcategories.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/subjectcategories.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSUBJECTCATEGORIES EQ "DELETE" OR FORM.PROCESSSUBJECTCATEGORIES EQ "CANCELADD">
	<CFQUERY name="DeleteSubjectCategories" datasource="#application.type#WEBREPORTS">
		DELETE FROM	SUBJECTCATEGORIES
		WHERE		SUBJECTCATID = #val(Cookie.SUBJECTCATID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSUBJECTCATEGORIES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/subjectcategories.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>