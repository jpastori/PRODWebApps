<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processequiptypeinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory Equipment Type --->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Hardware Inventory - Equipment Type</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSEQUIPTYPE EQ "ADD" OR FORM.PROCESSEQUIPTYPE EQ "MODIFY">
	<CFQUERY name="ModifyEquipmentTypes" datasource="#application.type#HARDWARE">
		UPDATE	EQUIPMENTTYPE
		SET		EQUIPMENTTYPE = UPPER('#FORM.EQUIPMENTTYPE#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	EQUIPTYPEID = #val(Cookie.EQUIPTYPEID)#
	</CFQUERY>
	<CFIF FORM.PROCESSEQUIPTYPE EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/equiptypeinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/equiptypeinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSEQUIPTYPE EQ "DELETE" OR FORM.PROCESSEQUIPTYPE EQ "CANCELADD">
	<CFQUERY name="DeleteEquipmentTypes" datasource="#application.type#HARDWARE">
		DELETE FROM	EQUIPMENTTYPE
		WHERE 		EQUIPTYPEID = #val(Cookie.EQUIPTYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSEQUIPTYPE EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/equiptypeinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>