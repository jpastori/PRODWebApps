<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: archiveinventoryinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/04/2011 --->
<!--- Date in Production: 11/04/2011 --->
<!--- Module: Archive Information to IDT Hardware Inventory --->
<!-- Last modified by John R. Pastori on 09/24/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/archiveinventoryinfo.cfm ">
<CFSET CONTENT_UPDATED = "September 24, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory Archive Process</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFSET CHILDREN_FLAG = 'NO'>

<CFQUERY name="LookupArchiveLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT		LOC.LOCATIONID, LOC.ARCHIVELOCATION
	FROM		LOCATIONS LOC
	WHERE		LOC.LOCATIONID > 0 AND
     			LOC.ARCHIVELOCATION = 'YES'
	ORDER BY	LOC.LOCATIONID
</CFQUERY>

<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT		HARDWAREID, TO_CHAR(CREATIONDATE, 'DD-MON-YYYY HH24:MI:SS') AS CREATIONDATE, BARCODENUMBER, STATEFOUNDNUMBER, SERIALNUMBER,
				DIVISIONNUMBER, MACHINENAME, EQUIPMENTLOCATIONID, MACADDRESS, AIRPORTID, BLUETOOTHID, EQUIPMENTTYPEID, DESCRIPTIONID, MODELNAMEID,
				MODELNUMBERID, SPEEDNAMEID, MANUFACTURERID, DELLEXPRESSSERVICE, WARRANTYVENDORID, REQUISITIONNUMBER, PURCHASEORDERNUMBER, 
				TO_CHAR(DATERECEIVED, 'DD-MON-YYYY HH24:MI:SS') AS DATERECEIVED, FISCALYEARID, CUSTOMERID, COMMENTS, OWNINGORGID, MODIFIEDBYID, 	
				TO_CHAR(DATECHECKED, 'DD-MON-YYYY HH24:MI:SS')AS DATECHECKED
	FROM		HARDWAREINVENTORY
	WHERE		EQUIPMENTLOCATIONID IN (#ValueList(LookupArchiveLocations.LOCATIONID)#)
			<CFIF IsDefined('URL.ARCHIVE') AND IsDefined('URL.HARDWAREIDS')>
				AND HARDWAREID IN (#URL.HARDWAREIDS#)
			</CFIF>
	ORDER BY	HARDWAREID
</CFQUERY>

<CFIF #GetHardware.RecordCount# EQ 0>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("Records meeting the selected criteria were Not Found");
		--> 
	</SCRIPT>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	<CFEXIT>
</CFIF>

<CFQUERY name="LookupArchive" datasource="#application.type#HARDWARE" blockfactor="100">
    SELECT		IA.HARDWAREID, IA.BARCODENUMBER
    FROM		INVENTORYARCHIVE IA
    WHERE		IA.HARDWAREID IN (#ValueList(GetHardware.HARDWAREID)#)
    ORDER BY	IA.HARDWAREID
</CFQUERY>

<CFIF #LookupArchive.RecordCount# GT 0>
	<CFSET URL.HARDWAREIDS = #ValueList(LookupArchive.HARDWAREID)#>
	Inventory Archive Hardware IDs = #URL.HARDWAREIDS# <BR><BR>
	<SCRIPT language="JavaScript">
		<!-- 
			window.open("/#application.type#apps/hardwareinventory/duplinventoryarchivereport.cfm?HARDWAREIDS=#URL.HARDWAREIDS#","Print Duplicate Inventory/Archive Records", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
		 -->
	</SCRIPT>
     <CFSET CHILDREN_FLAG = 'YES'>
</CFIF>

<CFQUERY name="LookupAssignedSRHardware" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
     SELECT		SRHA.SRID, SRHA.RETURNINVENTID
     FROM		SRHARDWASSIGNS SRHA
     WHERE		SRHA.RETURNINVENTID IN (#ValueList(GetHardware.HARDWAREID)#)
     ORDER BY	SRHA.RETURNINVENTID
</CFQUERY>

<CFIF #LookupAssignedSRHardware.RecordCount# GT 0>
	<CFSET URL.SRASSIGNHARDWIDS = #ValueList(LookupAssignedSRHardware.RETURNINVENTID)#>
	SR Hardware Assignment IDs = #URL.SRASSIGNHARDWIDS# <BR><BR>
	<SCRIPT language="JavaScript">
		<!-- 
			window.open("/#application.type#apps/hardwareinventory/hwarchivesrhwassignlkuprpt.cfm?SRASSIGNHARDWIDS=#URL.SRASSIGNHARDWIDS#","Print SR Hardware Assignments", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
		 -->
	</SCRIPT>
     <CFSET CHILDREN_FLAG = 'YES'>
</CFIF>

<CFQUERY name="LookupAssignedSoftware" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT		SA.SOFTWASSIGNID, SA.ASSIGNEDHARDWAREID, SA.SOFTWINVENTID
	FROM		SOFTWAREASSIGNMENTS SA
	WHERE		SA.ASSIGNEDHARDWAREID IN (#ValueList(GetHardware.HARDWAREID)#)
	ORDER BY	SA.SOFTWINVENTID, SA.SOFTWASSIGNID
</CFQUERY>

<CFIF #LookupAssignedSoftware.RecordCount# GT 0>
	<CFSET URL.SOFTWASSIGNIDS = #ValueList(LookupAssignedSoftware.SOFTWASSIGNID)#>
	Software Assignment IDs = #URL.SOFTWASSIGNIDS# <BR><BR>
	<SCRIPT language="JavaScript">
		<!-- 
			window.open("/#application.type#apps/hardwareinventory/hwarchiveswassignlkuprpt.cfm?SOFTWASSIGNIDS=#URL.SOFTWASSIGNIDS#","Print Software Assignments", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
		 -->
	</SCRIPT>
     <CFSET CHILDREN_FLAG = 'YES'>
</CFIF>

<CFQUERY name="LookupAssignedWalljacks" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT		WJ.WALLJACKID, WJ.HARDWAREID
	FROM		WALLJACKS WJ
	WHERE		WJ.HARDWAREID IN (#ValueList(GetHardware.HARDWAREID)#)
	ORDER BY	WJ.HARDWAREID
</CFQUERY>

<CFIF #LookupAssignedWalljacks.RecordCount# GT 0>
	<CFSET URL.WALLJACKIDS = #ValueList(LookupAssignedWalljacks.WALLJACKID)#>
	WallJack Assignment IDs = #URL.WALLJACKIDS# <BR><BR>
	<SCRIPT language="JavaScript">
		<!-- 
			window.open("/#application.type#apps/hardwareinventory/hwarchivewalljacklkuprpt.cfm?WALLJACKIDS=#URL.WALLJACKIDS#","Print Wall Jack Assignments", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
		 -->
	</SCRIPT>
     <CFSET CHILDREN_FLAG = 'YES'>
</CFIF>

<CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
    SELECT		TNSWO.TNSWO_ID, TNSWO.WO_TYPE, TNSWO.HW_INVENTORYID
    FROM		TNSWORKORDERS TNSWO
    WHERE		TNSWO.HW_INVENTORYID IN (#ValueList(GetHardware.HARDWAREID)#) AND
        		NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
    ORDER BY	TNSWO.HW_INVENTORYID
</CFQUERY>

<CFIF #LookupTNSWorkOrders.RecordCount# GT 0>
	<CFSET URL.TNSWO_ID = #ValueList(LookupTNSWorkOrders.TNSWO_ID)#>
	TNS Work Order IDs = #URL.TNSWO_ID# <BR><BR>
	<SCRIPT language="JavaScript">
		<!-- 
			window.open("/#application.type#apps/hardwareinventory/hwarchivetnswolkuprpt.cfm?TNSWO_ID=#URL.TNSWO_ID#","Print TNS Work Order Assignments", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
		 -->
	</SCRIPT>
     <CFSET CHILDREN_FLAG = 'YES'>
</CFIF>

<CFIF CHILDREN_FLAG EQ 'YES'>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	<CFEXIT>
</CFIF>

<CFLOOP query="GetHardware">

	<CFTRANSACTION action="begin">
	<CFQUERY name="AddInventoryArchive" datasource="#application.type#HARDWARE">
		INSERT INTO	INVENTORYARCHIVE 
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
		DELETE FROM	HARDWAREINVENTORY
		WHERE 		HARDWAREID = <CFQUERYPARAM value="#GetHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC">
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>

</CFLOOP>

<H1>ARCHIVE PROCESS IS COMPLETE

<CFIF NOT IsDefined('URL.ARCHIVE')>
	<CFSET URL.HARDWAREIDS = #ValueList(GetHardware.HARDWAREID)#>
	Inventory Archive IDs = #URL.HARDWAREIDS#
	<SCRIPT language="JavaScript">
		<!-- 
			window.open("/#application.type#apps/hardwareinventory/inventmultiplelookupreport.cfm?PROCESS=ARCHIVEINVENTORY&HARDWAREIDS=#URL.HARDWAREIDS#","Print_HardWare_IDs", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
		 -->
	</SCRIPT>
</CFIF>

<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
</CFOUTPUT>

</BODY>
</HTML>