<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processequipdescrinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory Equipment Description --->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Equipment Inventory - Equipment Description</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSEQUIPDESCR EQ "ADD" OR FORM.PROCESSEQUIPDESCR EQ "MODIFY">
	<CFQUERY name="ModifyEquipmentDescriptions" datasource="#application.type#HARDWARE">
		UPDATE	EQUIPMENTDESCRIPTION
		SET		EQUIPMENTDESCRIPTION = UPPER('#FORM.EQUIPMENTDESCRIPTION#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	EQUIPDESCRID = #val(Cookie.EQUIPDESCRID)#
	</CFQUERY>
	<CFIF FORM.PROCESSEQUIPDESCR EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/equipdescrinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/equipdescrinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSEQUIPDESCR EQ "DELETE" OR FORM.PROCESSEQUIPDESCR EQ "CANCELADD">
	<CFQUERY name="DeleteEquipmentDescriptions" datasource="#application.type#HARDWARE">
		DELETE FROM	EQUIPMENTDESCRIPTION
		WHERE 		EQUIPDESCRID = #val(Cookie.EQUIPDESCRID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSEQUIPDESCR EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/equipdescrinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>