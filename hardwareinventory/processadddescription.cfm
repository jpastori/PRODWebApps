<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processadddescription.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory --->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFQUERY name="GetEquipmentDescriptions" datasource="#application.type#HARDWARE">
	SELECT	EQUIPDESCRID, EQUIPMENTDESCRIPTION, MODIFIEDBYID, MODIFIEDDATE
	FROM		EQUIPMENTDESCRIPTION
	WHERE	EQUIPMENTDESCRIPTION = <CFQUERYPARAM value="UPPER(#FORM.DESCRIPTIONNAME#)" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	EQUIPMENTDESCRIPTION
</CFQUERY>

<CFIF #GetEquipmentDescriptions.RecordCount# EQ 0>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(EQUIPDESCRID) AS MAX_ID
		FROM		EQUIPMENTDESCRIPTION
	</CFQUERY>
	<CFSET FORM.DESCRIPTIONID = #val(GetMaxUniqueID.MAX_ID+1)#>
     <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
	<CFQUERY name="AddEquipmentDescriptions" datasource="#application.type#HARDWARE" blockfactor="100">
		INSERT INTO	EQUIPMENTDESCRIPTION (EQUIPDESCRID, EQUIPMENTDESCRIPTION, MODIFIEDBYID, MODIFIEDDATE)
		VALUES		(#val(FORM.DESCRIPTIONID)#, UPPER('#FORM.DESCRIPTIONNAME#'), #val(FORM.MODIFIEDBYID)#, TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
<CFELSE>
	<CFSET FORM.DESCRIPTIONID = #GetEquipmentDescriptions.EQUIPDESCRID#>
</CFIF>