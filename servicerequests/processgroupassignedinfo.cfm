<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processgroupassignedinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests - Group Assigned --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Group Assigned</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSGROUPASSIGNED EQ "ADD" OR FORM.PROCESSGROUPASSIGNED EQ "MODIFY">
	<CFQUERY name="ModifyGroupAssigned" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	GROUPASSIGNED
		SET		GROUPNAME = UPPER('#FORM.GROUPNAME#')
		WHERE	(GROUPID = #val(Cookie.GROUPID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSGROUPASSIGNED EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/groupassignedinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/groupassignedinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSGROUPASSIGNED EQ "DELETE" OR FORM.PROCESSGROUPASSIGNED EQ "CANCELADD">
	<CFQUERY name="DeleteGroupAssigned" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	GROUPASSIGNED
		WHERE		GROUPID = #val(Cookie.GROUPID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSGROUPASSIGNED EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/groupassignedinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>