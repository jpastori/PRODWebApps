<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processservices.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Special Collections - Services --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Special Collections - Services</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSERVICES EQ "ADD" OR FORM.PROCESSSERVICES EQ "MODIFY">
	<CFQUERY name="ModifyServices" datasource="#application.type#SPECIALCOLLECTIONS">
		UPDATE	SERVICES
		SET		SERVICENAME = '#FORM.SERVICENAME#'
		WHERE	(SERVICEID = #val(Cookie.SERVICEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSERVICES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/services.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/services.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSERVICES EQ "DELETE" OR FORM.PROCESSSERVICES EQ "CANCELADD">
	<CFQUERY name="DeleteServices" datasource="#application.type#SPECIALCOLLECTIONS">
		DELETE FROM	SERVICES 
		WHERE 		SERVICEID = #val(Cookie.SERVICEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSERVICES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/services.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>