<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processspublicdesk.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/31/2008 --->
<!--- Date in Production: 10/31/2008 --->
<!--- Module: Process Information to Web Reports - Public Desk --->
<!-- Last modified by John R. Pastori on 10/31/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Public Desk</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSPUBLICDESK#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSPUBLICDESK#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSPUBLICDESK#, 1) EQ 0)>
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyPublicDesk" datasource="#application.type#WEBREPORTS">
		UPDATE	PUBLICDESK
		SET		TOPICID = #val(FORM.TOPICID)#,
				SUBTOPICID = #val(FORM.SUBTOPICID)#,
				CONTACTTIMEID = #val(FORM.CONTACTTIMEID)#,
				CONTACTID = #val(FORM.CONTACTID)#,
				IDTOPTIONS = '#FORM.IDTOPTIONS#',
				PUBDESKOPTIONS = '#FORM.PUBDESKOPTIONS#',
				CIRCNOTIFY = '#FORM.CIRCNOTIFY#',
				IDTNOTIFY = '#FORM.IDTNOTIFY#',
				CIRCCALLORDER = '#FORM.CIRCCALLORDER#',
				IDTCALLORDER = '#FORM.IDTCALLORDER#',
				MGMTCALLORDER = '#FORM.MGMTCALLORDER#',
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY')
		WHERE	PUBLICDESKID = #val(Cookie.PUBLICDESKID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>

<CFIF FORM.PROCESSPUBLICDESK EQ "ADD">
	<H1>Data ADDED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/publicdesk.cfm?PROCESS=ADD" />
</CFIF>

<CFIF FORM.PROCESSPUBLICDESK EQ "MODIFY">
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/publicdesk.cfm?PROCESS=MODIFYDELETE" />
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSPUBLICDESK#, 1) NEQ 0 OR FORM.PROCESSPUBLICDESK EQ "CANCELADD">

	<CFQUERY name="DeletePublicDesk" datasource="#application.type#WEBREPORTS">
		DELETE FROM	PUBLICDESK
		WHERE 		PUBLICDESKID = #val(Cookie.PUBLICDESKID)#
	</CFQUERY>

	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPUBLICDESK EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/publicdesk.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>