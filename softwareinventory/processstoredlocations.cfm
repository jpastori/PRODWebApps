<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processstoredlocations.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Software Inventory - Stored Locations --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Stored Locations</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSTOREDLOCATIONS EQ "ADD" OR FORM.PROCESSSTOREDLOCATIONS EQ "MODIFY">
	<CFQUERY name="ModifyStoredLocations" datasource="#application.type#SOFTWARE">
		UPDATE	STOREDLOCATIONS
		SET		STOREDLOCTYPE = UPPER('#FORM.STOREDLOCTYPE#'),
				STOREDLOCNAME = UPPER('#FORM.STOREDLOCNAME#')
		WHERE	(STOREDLOCID = #val(Cookie.STOREDLOCID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSTOREDLOCATIONS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/storedlocations.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/storedlocations.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSTOREDLOCATIONS EQ "DELETE" OR FORM.PROCESSSTOREDLOCATIONS EQ "CANCELADD">
	<CFQUERY name="DeleteStoredLocations" datasource="#application.type#SOFTWARE">
		DELETE FROM	STOREDLOCATIONS 
		WHERE 		STOREDLOCID = #val(Cookie.STOREDLOCID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSTOREDLOCATIONS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/storedlocations.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>