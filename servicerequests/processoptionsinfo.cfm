<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processoptionsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests Options --->
<!-- Last modified by John R. Pastori on 02/03/2009 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Options</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSOPTIONS EQ "ADD" OR FORM.PROCESSOPTIONS EQ "MODIFY">
	<CFQUERY name="ModifyOptions" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	OPTIONS
		SET		OPTIONNAME = UPPER('#FORM.OPTIONNAME#')
		WHERE	(OPTIONID = #val(Cookie.OPTIONID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSOPTIONS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/optionsinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/optionsinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSOPTIONS EQ "DELETE" OR FORM.PROCESSOPTIONS EQ "CANCELADD">
	<CFQUERY name="DeleteOptions" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	OPTIONS
		WHERE		OPTIONID = #val(Cookie.OPTIONID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSOPTIONS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/optionsinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>