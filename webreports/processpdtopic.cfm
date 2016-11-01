<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpdtopic.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Public Desk Topics --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Public Desk Topics</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPDTOPIC EQ "ADD" OR FORM.PROCESSPDTOPIC EQ "MODIFY">
	<CFQUERY name="ModifyPDTopic" datasource="#application.type#WEBREPORTS">
		UPDATE	PDTOPIC
		SET		TOPIC = '#FORM.TOPIC#'
		WHERE	(TOPICID = #val(Cookie.TOPICID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPDTOPIC EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdtopic.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdtopic.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPDTOPIC EQ "DELETE" OR FORM.PROCESSPDTOPIC EQ "CANCELADD">
	<CFQUERY name="DeletePDTopic" datasource="#application.type#WEBREPORTS">
		DELETE FROM	PDTOPIC 
		WHERE 		TOPICID = #val(Cookie.TOPICID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPDTOPIC EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/pdtopic.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>