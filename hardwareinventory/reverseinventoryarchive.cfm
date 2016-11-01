<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: reverseinventoryarchive.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/04/2011 --->
<!--- Date in Production: 11/04/2011 --->
<!--- Module: IDT Hardware Inventory Reverse Archive Process --->
<!-- Last modified by John R. Pastori on on 11/04/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/reverseinventoryarchive.cfm">
<CFSET CONTENT_UPDATED = "November 04, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory Reverse Archive Process</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<!--- 
*******************************************************************************
* The following code is the Specific Record Status Report Hardware Inventory. *
*******************************************************************************
 --->

<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.HARDWAREID, TO_CHAR(HI.CREATIONDATE, 'DD-MON-YYYY HH24:MI:SS') AS CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER,
			HI.SERIALNUMBER, HI.DIVISIONNUMBER, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, HI.MACADDRESS, HI.AIRPORTID, HI.BLUETOOTHID, 
			HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE, HI.DESCRIPTIONID, ED.EQUIPMENTDESCRIPTION, HI.MODELNAMEID, MNL.MODELNAME, HI.MODELNUMBERID,
			MUL.MODELNUMBER, HI.SPEEDNAMEID, SNL.SPEEDNAME, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, HI.WARRANTYVENDORID, HI.REQUISITIONNUMBER,
			HI.PURCHASEORDERNUMBER, TO_CHAR(HI.DATERECEIVED, 'DD-MON-YYYY HH24:MI:SS') AS DATERECEIVED, HI.FISCALYEARID, HI.CUSTOMERID,
			HI.COMMENTS, HI.OWNINGORGID, HI.MODIFIEDBYID, TO_CHAR(HI.DATECHECKED, 'DD-MON-YYYY HH24:MI:SS')AS DATECHECKED
	FROM		INVENTORYARCHIVE HI, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED, MODELNAMELIST MNL, 
			MODELNUMBERLIST MUL, SPEEDNAMELIST SNL
	WHERE	HI.HARDWAREID IN (#URL.HARDWAREIDS#) AND
			HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
			HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
			HI.MODELNAMEID = MNL.MODELNAMEID AND
			HI.MODELNUMBERID = MUL.MODELNUMBERID AND
			HI.SPEEDNAMEID = SNL.SPEEDNAMEID
	ORDER BY	HI.BARCODENUMBER
</CFQUERY>

<CFLOOP query="GetHardware">

	<CFTRANSACTION action="begin">
	<CFQUERY name="AddHardwareInventory" datasource="#application.type#HARDWARE">
		INSERT INTO	HARDWAREINVENTORY
					(HARDWAREID, CREATIONDATE, BARCODENUMBER, STATEFOUNDNUMBER, SERIALNUMBER, DIVISIONNUMBER,
					MACHINENAME, EQUIPMENTLOCATIONID, MACADDRESS, AIRPORTID, BLUETOOTHID, EQUIPMENTTYPEID, DESCRIPTIONID, 
					MODELNAMEID, MODELNUMBERID, SPEEDNAMEID, MANUFACTURERID, DELLEXPRESSSERVICE, WARRANTYVENDORID,
					REQUISITIONNUMBER, PURCHASEORDERNUMBER, DATERECEIVED, FISCALYEARID, CUSTOMERID, COMMENTS,
					OWNINGORGID, MODIFIEDBYID, DATECHECKED)
		VALUES		(#val(GetHardware.HARDWAREID)#, 
					TO_DATE('#GetHardware.CREATIONDATE#', 'DD-MON-YYYY HH24:MI:SS'),
					'#GetHardware.BARCODENUMBER#',
					'#GetHardware.STATEFOUNDNUMBER#',
					'#GetHardware.SERIALNUMBER#',
					'#GetHardware.DIVISIONNUMBER#',
					'#GetHardware.MACHINENAME#',
					#val(GetHardware.EQUIPMENTLOCATIONID)#,
					'#GetHardware.MACADDRESS#',
                         '#GetHardware.AIRPORTID#',
                         '#GetHardware.BLUETOOTHID#',
					#val(GetHardware.EQUIPMENTTYPEID)#,
					#val(GetHardware.DESCRIPTIONID)#,
					#val(GetHardware.MODELNAMEID)#,
					#val(GetHardware.MODELNUMBERID)#,
					#val(GetHardware.SPEEDNAMEID)#,
					#val(GetHardware.MANUFACTURERID)#,
					'#GetHardware.DELLEXPRESSSERVICE#',
					#val(GetHardware.WARRANTYVENDORID)#,
					'#GetHardware.REQUISITIONNUMBER#',
					'#GetHardware.PURCHASEORDERNUMBER#',
					TO_DATE('#GetHardware.DATERECEIVED#', 'DD-MON-YYYY HH24:MI:SS'),
					#val(GetHardware.FISCALYEARID)#,
					#val(GetHardware.CUSTOMERID)#,
					'#GetHardware.COMMENTS#',
					#val(GetHardware.OWNINGORGID)#,
					#val(GetHardware.MODIFIEDBYID)#,
					TO_DATE('#GetHardware.DATECHECKED#', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>

	<CFTRANSACTION action="begin">
	<CFQUERY name="DeleteHardwareInventory" datasource="#application.type#HARDWARE">
		DELETE FROM	INVENTORYARCHIVE
		WHERE 		HARDWAREID = #val(GetHardware.HARDWAREID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>

</CFLOOP>

<H1>INVENTORY REVERSAL COMPLETE!</H1>
<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventoryarchivelookup.cfm?&ARCHIVE=#URL.ARCHIVE#" />
</CFOUTPUT>

</BODY>
</HTML>