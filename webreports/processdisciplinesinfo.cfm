<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processdisciplinesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Disciplines --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Disciplines </TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSDISCIPLINES EQ "ADD" OR FORM.PROCESSDISCIPLINES EQ "MODIFY">
	<CFQUERY name="UpdateDisciplines" datasource="#application.type#WEBREPORTS">
		UPDATE	DISCIPLINES
		SET		DISCIPLINENAME = '#FORM.DISCIPLINENAME#'
		WHERE	(DISCIPLINEID = #val(Cookie.DISCIPLINEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSDISCIPLINES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/disciplinesinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/disciplinesinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSDISCIPLINES EQ "DELETE" OR FORM.PROCESSDISCIPLINES EQ "CANCELADD">
	<CFQUERY name="DeleteDisciplines" datasource="#application.type#WEBREPORTS">
		DELETE FROM	DISCIPLINES
		WHERE 		DISCIPLINEID = #val(Cookie.DISCIPLINEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSDISCIPLINES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/disciplinesinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>