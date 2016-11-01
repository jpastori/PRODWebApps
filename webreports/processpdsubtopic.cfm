<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpdsubtopic.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Public Desk SubTopics --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Public Desk SubTopics</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPDSUBTOPIC EQ "ADD" OR FORM.PROCESSPDSUBTOPIC EQ "MODIFY">
	<CFQUERY name="ModifyPDSubTopic" datasource="#application.type#WEBREPORTS">
		UPDATE	PDSUBTOPIC
		SET		SUBTOPIC = '#FORM.SUBTOPIC#'
		WHERE	(SUBTOPICID = #val(Cookie.SUBTOPICID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPDSUBTOPIC EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdsubtopic.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdsubtopic.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPDSUBTOPIC EQ "DELETE" OR FORM.PROCESSPDSUBTOPIC EQ "CANCELADD">
	<CFQUERY name="DeletePDSubTopic" datasource="#application.type#WEBREPORTS">
		DELETE FROM	PDSUBTOPIC 
		WHERE 		SUBTOPICID = #val(Cookie.SUBTOPICID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPDSUBTOPIC EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdsubtopic.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>