<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processservicetypesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests Service Types --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Service Types</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSERVICETYPES EQ "ADD" OR FORM.PROCESSSERVICETYPES EQ "MODIFY">
	<CFQUERY name="ModifyServiceTypes" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	SERVICETYPES
		SET		SERVICETYPENAME = UPPER('#FORM.SERVICETYPENAME#')
		WHERE	(SERVICETYPEID = #val(Cookie.SERVICETYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSERVICETYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/servicetypesinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/servicetypesinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSERVICETYPES EQ "DELETE" OR FORM.PROCESSSERVICETYPES EQ "CANCELADD">
	<CFQUERY name="DeleteServiceTypes" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	SERVICETYPES
		WHERE		SERVICETYPEID = #val(Cookie.SERVICETYPEID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSERVICETYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/servicetypesinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>