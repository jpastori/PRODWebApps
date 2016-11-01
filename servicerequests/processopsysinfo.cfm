<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processopsysinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests Operating Systems --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Operating Systems</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSOPSYS EQ "ADD" OR FORM.PROCESSOPSYS EQ "MODIFY">
	<CFQUERY name="ModifyOperatingSystems" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	OPSYS
		SET		OPSYSNAME = UPPER('#FORM.OPSYSNAME#')
		WHERE	(OPSYSID = #val(Cookie.OPSYSID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSOPSYS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/opsysinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/opsysinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSOPSYS EQ "DELETE" OR FORM.PROCESSOPSYS EQ "CANCELADD">
	<CFQUERY name="DeleteOperatingSystems" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	OPSYS
		WHERE		OPSYSID = #val(Cookie.OPSYSID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSOPSYS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/opsysinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>