<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processchatsubtopicinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/28/2011 --->
<!--- Date in Production: 06/28/2011 --->
<!--- Module: Process Information to IDT Chatter - Chat Sub-Topics --->
<!-- Last modified by John R. Pastori on 06/28/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Chatter - Chat Sub-Topics</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCHATSUBTOPICS EQ "ADD" OR FORM.PROCESSCHATSUBTOPICS EQ "MODIFY">
	<CFQUERY name="ModifyChatSubTopics" datasource="#application.type#IDTCHATTER">
		UPDATE	IDTCHATSUBTOPICS
		SET		TOPICID = #val(FORM.TOPICID)#,
				SUBTOPICINFO = UPPER('#FORM.SUBTOPICINFO#')
		WHERE	(SUBTOPICID = #val(Cookie.SUBTOPICID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCHATSUBTOPICS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/idtchatter/chatsubtopicinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/idtchatter/chatsubtopicinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCHATSUBTOPICS EQ "DELETE" OR FORM.PROCESSCHATSUBTOPICS EQ "CANCELADD">
	<CFQUERY name="DeleteChatSubTopics" datasource="#application.type#IDTCHATTER">
		DELETE FROM	IDTCHATSUBTOPICS
		WHERE		SUBTOPICID = #val(Cookie.SUBTOPICID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSCHATSUBTOPICS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/idtchatter/chatsubtopicinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/idtchatter/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>