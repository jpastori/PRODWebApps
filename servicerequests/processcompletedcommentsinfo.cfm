<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcompletedcommentsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests Completed Comments --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Completed Comments</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCOMPLETEDCOMMENTS EQ "ADD" OR FORM.PROCESSCOMPLETEDCOMMENTS EQ "MODIFY">
	<CFQUERY name="ModifyCompletedComments" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	COMPLETEDCOMMENTS
		SET		COMPLETED_COMMENTS = UPPER('#FORM.COMPLETED_COMMENTS#')
		WHERE	(COMPLETED_COMMENTSID = #val(Cookie.COMPLETED_COMMENTSID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCOMPLETEDCOMMENTS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/completedcommentsinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/completedcommentsinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCOMPLETEDCOMMENTS EQ "DELETE" OR FORM.PROCESSCOMPLETEDCOMMENTS EQ "CANCELADD">
	<CFQUERY name="DeleteCompletedComments" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	COMPLETEDCOMMENTS 
		WHERE		COMPLETED_COMMENTSID = #val(Cookie.COMPLETED_COMMENTSID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSCOMPLETEDCOMMENTS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/completedcommentsinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>