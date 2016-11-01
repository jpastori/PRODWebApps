<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: updatestructuredata.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2008 --->
<!--- Date in Production: 06/23/2008 --->
<!--- Module: Process Information to IDT Hardware Inventory --->
<!-- Last modified by John R. Pastori on 06/23/2008 using ColdFusion Studio. -->

	<CFSET FORM.DIVISIONNUMBER = UCASE('#FORM.DIVISIONNUMBER#')>
	<CFSET FORM.DELLEXPRESSSERVICE = UCASE('#FORM.DELLEXPRESSSERVICE#')>
	<CFSET FORM.WARRANTYRESTRICTIONS = UCASE('#FORM.WARRANTYRESTRICTIONS#')>
	<CFSET FORM.WARRANTYCOMMENTS = UCASE('#FORM.WARRANTYCOMMENTS#')>
	<CFSET FORM.REQUISITIONNUMBER = UCASE('#FORM.REQUISITIONNUMBER#')>
	<CFSET FORM.PURCHASEORDERNUMBER = UCASE('#FORM.PURCHASEORDERNUMBER#')>
	<CFSET FORM.COMMENTS = UCASE('#FORM.COMMENTS#')>

	<CFSET rc=StructUpdate(session.RecordAddsStructure, "DIVISIONNUMBER", "#FORM.DIVISIONNUMBER#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "EQUIPMENTLOCATIONID", "#FORM.EQUIPMENTLOCATIONID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "EQUIPMENTTYPEID", "#FORM.EQUIPMENTTYPEID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "DESCRIPTIONID", "#FORM.DESCRIPTIONID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "MODELNAMEID", "#FORM.MODELNAMEID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "MODELNUMBERID", "#FORM.MODELNUMBERID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "SPEEDNAMEID", "#FORM.SPEEDNAMEID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "SIZENAMEID1", "#FORM.SIZENAMEID1#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "SIZENAMEID2", "#FORM.SIZENAMEID2#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "SIZENAMEID3", "#FORM.SIZENAMEID3#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "SIZENAMEID4", "#FORM.SIZENAMEID4#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "SIZENAMEID5", "#FORM.SIZENAMEID5#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "SIZENAMEID6", "#FORM.SIZENAMEID6#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "INTERFACENAMEID1", "#FORM.INTERFACENAMEID1#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "INTERFACENAMEID2", "#FORM.INTERFACENAMEID2#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "INTERFACENAMEID3", "#FORM.INTERFACENAMEID3#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "INTERFACENAMEID4", "#FORM.INTERFACENAMEID4#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "INTERFACENAMEID5", "#FORM.INTERFACENAMEID5#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "INTERFACENAMEID6", "#FORM.INTERFACENAMEID6#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "PERIPHERALNAMEID1", "#FORM.PERIPHERALNAMEID1#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "PERIPHERALNAMEID2", "#FORM.PERIPHERALNAMEID2#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "PERIPHERALNAMEID3", "#FORM.PERIPHERALNAMEID3#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "PERIPHERALNAMEID4", "#FORM.PERIPHERALNAMEID4#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "PERIPHERALNAMEID5", "#FORM.PERIPHERALNAMEID5#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "PERIPHERALNAMEID6", "#FORM.PERIPHERALNAMEID6#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "MANUFACTURERID", "#FORM.MANUFACTURERID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "DELLEXPRESSSERVICE", "#FORM.DELLEXPRESSSERVICE#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "WARRANTYVENDORID", "#FORM.WARRANTYVENDORID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "WARRANTYRESTRICTIONS", "#FORM.WARRANTYRESTRICTIONS#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "WARRANTYEXPIRATIONDATE", "#FORM.WARRANTYEXPIRATIONDATE#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "ATTACHEDTO1", "#FORM.ATTACHEDTO1#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "ATTACHEDTO2", "#FORM.ATTACHEDTO2#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "WARRANTYCOMMENTS", "#FORM.WARRANTYCOMMENTS#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "REQUISITIONNUMBER", "#FORM.REQUISITIONNUMBER#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "PURCHASEORDERNUMBER", "#FORM.PURCHASEORDERNUMBER#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "DATERECEIVED", "#FORM.DATERECEIVED#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "FISCALYEARID", "#FORM.FISCALYEARID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "CUSTOMERID", "#FORM.CUSTOMERID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "COMMENTS", "#FORM.COMMENTS#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "OWNINGORGID", "#FORM.OWNINGORGID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "MODIFIEDBYID", "#FORM.MODIFIEDBYID#")>
