<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddtypename.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2008 --->
<!--- Date in Production: 06/23/2008 --->
<!--- Module: Process Information to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 06/23/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFQUERY name="GetEquipmentTypes" datasource="#application.type#HARDWARE">
	SELECT	EQUIPTYPEID, EQUIPMENTTYPE
	FROM	 	EQUIPMENTTYPE
	WHERE 	EQUIPMENTTYPE = <CFQUERYPARAM value="UPPER(#FORM.TYPENAME#)" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	EQUIPMENTTYPE
</CFQUERY>

<CFIF #GetEquipmentTypes.RecordCount# EQ 0>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(EQUIPTYPEID) AS MAX_ID
		FROM		EQUIPMENTTYPE
	</CFQUERY>
	<CFSET FORM.EQUIPMENTTYPEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFQUERY name="AddEquipmentTypes" datasource="#application.type#HARDWARE">
		INSERT INTO	EQUIPMENTTYPE (EQUIPTYPEID, EQUIPMENTTYPE)
		VALUES		(#val(FORM.EQUIPMENTTYPEID)#, UPPER('#FORM.TYPENAME#'))
	</CFQUERY>
<CFELSE>
	<CFSET FORM.EQUIPMENTTYPEID = #GetEquipmentTypes.EQUIPTYPEID#>
</CFIF>