<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processperipheralnamesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory Peripheral Names --->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Hardware Inventory - Peripheral Names</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPERIPHERALNAMES EQ "ADD" OR FORM.PROCESSPERIPHERALNAMES EQ "MODIFY">
	<CFQUERY name="ModifyPeripheralNames" datasource="#application.type#HARDWARE">
		UPDATE	PERIPHERALNAMELIST
		SET		PERIPHERALNAME = UPPER('#FORM.PERIPHERALNAME#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	PERIPHERALNAMEID = #val(Cookie.PERIPHERALNAMEID)#
	</CFQUERY>
	<CFIF FORM.PROCESSPERIPHERALNAMES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPERIPHERALNAMES EQ "DELETE" OR FORM.PROCESSPERIPHERALNAMES EQ "CANCELADD">
	<CFQUERY name="DeletePeripheralNames" datasource="#application.type#HARDWARE">
		DELETE FROM	PERIPHERALNAMELIST
		WHERE 		PERIPHERALNAMEID = #val(Cookie.PERIPHERALNAMEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPERIPHERALNAMES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>