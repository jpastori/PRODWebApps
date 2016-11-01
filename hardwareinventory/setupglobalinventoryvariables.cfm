<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: setupglobalinventoryvariables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2008 --->
<!--- Date in Production: 06/23/2008 --->
<!--- Module: Set Up Hardware Inventory Global Inventory Variables --->
<!-- Last modified by John R. Pastori on 06/23/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFPARAM name="session.SELECTFIELD" default="">
<CFPARAM name = "FORM.BARCODENUMBER" default = "3 0650 00">
<CFPARAM name = "FORM.STATEFOUNDNUMBER" default = "">
<CFPARAM name = "FORM.SERIALNUMBER" default = "">
<CFPARAM name = "FORM.DIVISIONNUMBER" default = "">
<CFPARAM name = "FORM.CLUSTERNAME" default = ""> 
<CFPARAM name = "FORM.MACHINENAME" default = "">
<CFPARAM name = "FORM.EQUIPMENTLOCATIONID" default = 0>
<CFPARAM name = "FORM.WALLJACKID" default = 0>
<CFPARAM name = "FORM.MACADDRESS" default = "">
<CFPARAM name = "FORM.EQUIPMENTTYPEID" default = 0>
<CFPARAM name = "FORM.DESCRIPTIONID" default = 0>
<CFPARAM name = "FORM.MODELNAMEID" default = 0>
<CFPARAM name = "FORM.MODELNUMBERID" default = 0>
<CFPARAM name = "FORM.SPEEDNAMEID" default = 0>
<CFLOOP index="Counter" from=1 to=6>
	<CFPARAM name = "FORM.SIZENAMEID#Counter#" default = 0>
</CFLOOP>
<CFLOOP index="Counter" from=1 to=6>
	<CFPARAM name = "FORM.INTERFACENAMEID#Counter#" default = 0>
	<CFPARAM name = "FORM.PERIPHERALNAMEID#Counter#" default = 0>
</CFLOOP>
<CFPARAM name = "FORM.MANUFACTURERID" default = 0>
<CFPARAM name = "FORM.DELLEXPRESSSERVICE" default = "">
<CFPARAM name = "FORM.WARRANTYVENDORID" default = 0>
<CFPARAM name = "FORM.WARRANTYRESTRICTIONS" default = "">
<CFPARAM name = "FORM.WARRANTYEXPIRATIONDATE" default = "">
<CFLOOP index="Counter" from=1 to=6>
	<CFPARAM name = "FORM.ATTACHEDTO#Counter#" default = 0>
</CFLOOP>
<CFPARAM name = "FORM.WARRANTYCOMMENTS" default = "">
<CFPARAM name = "FORM.REQUISITIONNUMBER" default = "">
<CFPARAM name = "FORM.PURCHASEORDERNUMBER" default = "">
<CFPARAM name = "FORM.DATERECEIVED" default = "">
<CFPARAM name = "FORM.FISCALYEARID" default = 0>
<CFPARAM name = "FORM.CUSTOMERID" default = 0>
<CFPARAM name = "FORM.COMMENTS" default = "">
<CFPARAM name = "FORM.OWNINGORGID" default = 2>
<CFPARAM name = "FORM.MODIFIEDBYID" default = #Client.CUSTOMERID#> 

<CFSET session.RecordAddsStructure=StructNew()>
<CFSET rc=StructInsert(session.RecordAddsStructure, "DIVISIONNUMBER", "#FORM.DIVISIONNUMBER#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "CLUSTERNAME", "#FORM.CLUSTERNAME#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "MACHINENAME", "#FORM.MACHINENAME#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "EQUIPMENTLOCATIONID", "#FORM.EQUIPMENTLOCATIONID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "WALLJACKID", "#FORM.WALLJACKID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "MACADDRESS", "#FORM.MACADDRESS#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "EQUIPMENTTYPEID", "#FORM.EQUIPMENTTYPEID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "DESCRIPTIONID", "#FORM.DESCRIPTIONID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "MODELNAMEID", "#FORM.MODELNAMEID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "MODELNUMBERID", "#FORM.MODELNUMBERID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "SPEEDNAMEID", "#FORM.SPEEDNAMEID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "SIZENAMEID1", "#FORM.SIZENAMEID1#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "SIZENAMEID2", "#FORM.SIZENAMEID2#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "SIZENAMEID3", "#FORM.SIZENAMEID3#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "SIZENAMEID4", "#FORM.SIZENAMEID4#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "SIZENAMEID5", "#FORM.SIZENAMEID5#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "SIZENAMEID6", "#FORM.SIZENAMEID6#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "INTERFACENAMEID1", "#FORM.INTERFACENAMEID1#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "INTERFACENAMEID2", "#FORM.INTERFACENAMEID2#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "INTERFACENAMEID3", "#FORM.INTERFACENAMEID3#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "INTERFACENAMEID4", "#FORM.INTERFACENAMEID4#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "INTERFACENAMEID5", "#FORM.INTERFACENAMEID5#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "INTERFACENAMEID6", "#FORM.INTERFACENAMEID6#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "PERIPHERALNAMEID1", "#FORM.PERIPHERALNAMEID1#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "PERIPHERALNAMEID2", "#FORM.PERIPHERALNAMEID2#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "PERIPHERALNAMEID3", "#FORM.PERIPHERALNAMEID3#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "PERIPHERALNAMEID4", "#FORM.PERIPHERALNAMEID4#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "PERIPHERALNAMEID5", "#FORM.PERIPHERALNAMEID5#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "PERIPHERALNAMEID6", "#FORM.PERIPHERALNAMEID6#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "MANUFACTURERID", "#FORM.MANUFACTURERID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "DELLEXPRESSSERVICE", "#DELLEXPRESSSERVICE#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "WARRANTYVENDORID", "#FORM.WARRANTYVENDORID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "WARRANTYRESTRICTIONS", "#FORM.WARRANTYRESTRICTIONS#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "WARRANTYEXPIRATIONDATE", "#FORM.WARRANTYEXPIRATIONDATE#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "ATTACHEDTO1", "#FORM.ATTACHEDTO1#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "ATTACHEDTO2", "#FORM.ATTACHEDTO2#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "ATTACHEDTO3", "#FORM.ATTACHEDTO3#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "ATTACHEDTO4", "#FORM.ATTACHEDTO4#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "ATTACHEDTO5", "#FORM.ATTACHEDTO5#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "ATTACHEDTO6", "#FORM.ATTACHEDTO6#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "WARRANTYCOMMENTS", "#FORM.WARRANTYCOMMENTS#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "REQUISITIONNUMBER", "#FORM.REQUISITIONNUMBER#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "PURCHASEORDERNUMBER", "#FORM.PURCHASEORDERNUMBER#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "DATERECEIVED", "#FORM.DATERECEIVED#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "FISCALYEARID", "#FORM.FISCALYEARID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "CUSTOMERID", "#FORM.CUSTOMERID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "COMMENTS", "#FORM.COMMENTS#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "OWNINGORGID", "#FORM.OWNINGORGID#")>
<CFSET rc=StructInsert(session.RecordAddsStructure, "MODIFIEDBYID", "#FORM.MODIFIEDBYID#")>

<CFSET session.DefaultRecordAddsStructure = Duplicate(session.RecordAddsStructure)>

<!--- CODE TO DISPLAY RecordAddsStructure KEYS. --->
<!--- 
<CFSET keysToStruct = StructKeyList(session.RecordAddsStructure,"<LI>")>
<P>Here are the keys to the Original Structure:</P> 
<OL>
	<LI>
		<CFOUTPUT>#keysToStruct#</CFOUTPUT>
</OL>
<CFSET DefaultkeysToStruct = StructKeyList(session.DefaultRecordAddsStructure,"<LI>")>
<P>Here are the keys to the Default Structure:</P> 
<OL>
	<LI>
		<CFOUTPUT>#DefaultkeysToStruct#</CFOUTPUT>
</OL>
 --->