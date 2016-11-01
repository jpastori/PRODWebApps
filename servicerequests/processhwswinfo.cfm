<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processhwswinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/15/2012 --->
<!--- Date in Production: 11/15/2012 --->
<!--- Module: Process Information to IDT Service Requests - Hardware/Software --->
<!-- Last modified by John R. Pastori on 11/15/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Hardware/Software</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSHWSW EQ "ADD" OR FORM.PROCESSHWSW EQ "MODIFY">
	<CFQUERY name="ModifyHWSW" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	HWSW
		SET		HWSW_NAME = UPPER('#FORM.HWSW_NAME#'),
          		HWSW_DESCRIPTION = '#FORM.HWSW_DESCRIPTION#'
		WHERE	(HWSW_ID = #val(Cookie.HWSW_ID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSHWSW EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/hwswinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/hwswinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSHWSW EQ "DELETE" OR FORM.PROCESSHWSW EQ "CANCELADD">
	<CFQUERY name="DeleteHWSW" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	HWSW 
		WHERE		HWSW_ID = #val(Cookie.HWSW_ID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSHWSW EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/hwswinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>