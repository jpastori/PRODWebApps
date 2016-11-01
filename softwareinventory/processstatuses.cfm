<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processstatuses.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Software Inventory - Status --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Status</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSTATUS EQ "ADD" OR FORM.PROCESSSTATUS EQ "MODIFY">
	<CFQUERY name="ModifyStatus" datasource="#application.type#SOFTWARE">
		UPDATE	STATUSES
		SET		STATUSTYPE = UPPER('#FORM.STATUSTYPE#'),
				STATUSNAME = UPPER('#FORM.STATUSNAME#')
		WHERE	(STATUSID = #val(Cookie.STATUSID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSTATUS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/statuses.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/statuses.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSTATUS EQ "DELETE" OR FORM.PROCESSSTATUS EQ "CANCELADD">
	<CFQUERY name="DeleteStatus" datasource="#application.type#SOFTWARE">
		DELETE FROM	STATUSES 
		WHERE 		STATUSID = #val(Cookie.STATUSID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSTATUS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/statuses.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>