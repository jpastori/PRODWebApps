<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpriorityinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests Priority --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Priority</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPRIORITY EQ "ADD" OR FORM.PROCESSPRIORITY EQ "MODIFY">
	<CFQUERY name="ModifyPriority" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	PRIORITY
		SET		PRIORITYNAME = UPPER('#FORM.PRIORITYNAME#')
		WHERE	(PRIORITYID = #val(Cookie.PRIORITYID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPRIORITY EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/priorityinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/priorityinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPRIORITY EQ "DELETE" OR FORM.PROCESSPRIORITY EQ "CANCELADD">
	<CFQUERY name="DeletePriority" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	PRIORITY
		WHERE		PRIORITYID = #val(Cookie.PRIORITYID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPRIORITY EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/priorityinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>