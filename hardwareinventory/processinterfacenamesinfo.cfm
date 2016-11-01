<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processinterfacesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory Interface Names --->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Hardware Inventory - Interface Names</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSINTERFACENAMES EQ "ADD" OR FORM.PROCESSINTERFACENAMES EQ "MODIFY">
	<CFQUERY name="ModifyInterfaceNames" datasource="#application.type#HARDWARE">
		UPDATE	INTERFACENAMELIST
		SET		INTERFACENAME = UPPER('#FORM.INTERFACENAME#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	INTERFACENAMEID = #val(Cookie.INTERFACENAMEID)#
	</CFQUERY>
	<CFIF FORM.PROCESSINTERFACENAMES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/interfacenamesinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/interfacenamesinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSINTERFACENAMES EQ "DELETE" OR FORM.PROCESSINTERFACENAMES EQ "CANCELADD">
	<CFQUERY name="DeleteInterfacenames" datasource="#application.type#HARDWARE">
		DELETE FROM	INTERFACENAMELIST
		WHERE 		INTERFACENAMEID = #val(Cookie.INTERFACENAMEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSINTERFACENAMES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/interfacenamesinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>