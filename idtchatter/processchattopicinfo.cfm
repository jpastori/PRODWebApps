<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processchattopicinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/28/2011 --->
<!--- Date in Production: 06/28/2011 --->
<!--- Module: Process Information to IDT Chatter - Chat Topics --->
<!-- Last modified by John R. Pastori on 06/28/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Chatter - Chat Topics</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCHATTOPICS EQ "ADD" OR FORM.PROCESSCHATTOPICS EQ "MODIFY">
	<CFQUERY name="ModifyChatTopics" datasource="#application.type#IDTCHATTER">
		UPDATE	IDTCHATTOPICS
		SET		TOPICINFO = UPPER('#FORM.TOPICINFO#')
		WHERE	(TOPICID = #val(Cookie.TOPICID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCHATTOPICS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/idtchatter/chattopicinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/idtchatter/chattopicinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCHATTOPICS EQ "DELETE" OR FORM.PROCESSCHATTOPICS EQ "CANCELADD">
	<CFQUERY name="DeleteChatTopics" datasource="#application.type#IDTCHATTER">
		DELETE FROM	IDTCHATTOPICS
		WHERE		TOPICID = #val(Cookie.TOPICID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSCHATTOPICS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/idtchatter/chattopicinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/idtchatter/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>