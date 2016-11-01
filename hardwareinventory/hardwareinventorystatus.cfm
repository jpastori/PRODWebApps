<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hardwareinventorystatus.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory Status Report --->
<!-- Last modified by John R. Pastori on 09/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/hardwareinventory/hardwareinventorystatus.cfm">
<cfset CONTENT_UPDATED = "September 30, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<cfif IsDefined('URL.PROCESS') AND URL.PROCESS EQ "ARCHIVEINVENTORY">
	<cfset TABLENAME = 'INVENTORYARCHIVE'>
	<cfset SCREENTITLE = 'ARCHIVE'>
	<cfset URL.PARMS = 'PROCESS=ARCHIVEINVENTORY&'>
	<cfset VALIDATELOOKUP = 'return validateArchiveLookupField();'>
<cfelse>
	<cfset TABLENAME ='HARDWAREINVENTORY'>
	<cfset SCREENTITLE = 'INVENTORY'>
	<cfset URL.PARMS = ''>
	<cfset VALIDATELOOKUP = 'return validateInventoryLookupField();'>
</cfif>

<cfoutput>
<html>
<head>
	<title>IDT Hardware #SCREENTITLE# Status Report</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateInventoryLookupField() {
		if (document.LOOKUP.HARDWAREID.selectedIndex == "0"  && document.LOOKUP.BARCODENUMBER.value == "3065000" 
		 && (document.LOOKUP.STATEFOUNDNUMBER.value == ""    || document.LOOKUP.STATEFOUNDNUMBER.value == " ")    
		 && (document.LOOKUP.SERIALNUMBER.value == ""        || document.LOOKUP.SERIALNUMBER.value == " ")
		 && (document.LOOKUP.DIVISIONNUMBER.value == ""      || document.LOOKUP.DIVISIONNUMBER.value == " ")       
		 && (document.LOOKUP.IPADDRESS.value == ""           || document.LOOKUP.IPADDRESS.value == " ")) {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.HARDWAREID.focus();
			return false;
		}

		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = LOOKUP.BARCODENUMBER.value;
			LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if ((document.LOOKUP.BARCODENUMBER.value != "3065000" && LOOKUP.BARCODENUMBER.value != "") &&  document.LOOKUP.BARCODENUMBER.value.length != 17) {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  A 17 character Bar Code Number MUST be entered! Spaces are counted.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

		if (document.LOOKUP.HARDWAREID.selectedIndex > "0" && document.LOOKUP.BARCODENUMBER.value != "3065000") {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  BOTH a dropdown value AND a 17 character Bar Code Number can NOT be entered! Choose one or the other.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

	}

	function validateArchiveLookupField() {
		if (document.LOOKUP.HARDWAREID.selectedIndex == "0"  && document.LOOKUP.BARCODENUMBER.value == "3065000" 
		 && (document.LOOKUP.STATEFOUNDNUMBER.value == ""    || document.LOOKUP.STATEFOUNDNUMBER.value == " ")    
		 && (document.LOOKUP.SERIALNUMBER.value == ""        || document.LOOKUP.SERIALNUMBER.value == " ")) {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.HARDWAREID.focus();
			return false;
		}

		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = LOOKUP.BARCODENUMBER.value;
			LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if ((document.LOOKUP.BARCODENUMBER.value != "3065000" && LOOKUP.BARCODENUMBER.value != "") && document.LOOKUP.BARCODENUMBER.value.length != 17) {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  A 17 character Bar Code Number MUST be entered! Spaces are counted.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

		if (document.LOOKUP.HARDWAREID.selectedIndex > "0" && document.LOOKUP.BARCODENUMBER.value != "3065000") {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  BOTH a dropdown value AND a 17 character Bar Code Number can NOT be entered! Choose one or the other.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

	}

//
</script>
<!--Script ends here -->

</head>

<cfif NOT IsDefined('URL.LOOKUPBARCODE')>
	<cfset CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
<cfelse>
	<cfset CURSORFIELD = "">
</cfif>
<body onLoad="#CURSORFIELD#">

<!--- 
*******************************************************************************************************
* The following code is the Look Up Process for the Specific Record Hardware Inventory Status Report. *
*******************************************************************************************************
 --->

<cfif NOT IsDefined('URL.LOOKUPBARCODE')>

	<cfquery name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER,
				HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
				HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, 
				HI.MACADDRESS, HI.EQUIPMENTTYPEID, HI.DESCRIPTIONID,
				HI.MODELNAMEID, HI.MODELNUMBERID, HI.SPEEDNAMEID, 
				HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, 
				HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, 
				HI.FISCALYEARID, HI.CUSTOMERID, HI.COMMENTS,
				HI.OWNINGORGID, HI.MODIFIEDBYID, HI.DATECHECKED,
			<CFIF NOT IsDefined('URL.PROCESS')>
               	HI.CLUSTERNAME,  
				HI.IPADDRESS,
			</CFIF>
				CUST.FULLNAME || ' - ' || ET.EQUIPMENTTYPE ||' - ' || HI.BARCODENUMBER AS LOOKUPKEY
		FROM		#TABLENAME# HI, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET
		WHERE	HI.CUSTOMERID = CUST.CUSTOMERID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID
		ORDER BY	LOOKUPKEY
	</cfquery>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center"><h1>IDT Hardware #SCREENTITLE# Status Report Lookup</h1></th>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<th align="center"><h2>
				Enter complete values to Lookup a specific record. <br />
				More than one field can be selected except where text and dropdown represent the same field.
			</h2></th>
		</tr>
	</table>
		<br />
	<table width="100%" align="LEFT">
		<tr>
<cfform action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<td align="LEFT">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
<cfform name="LOOKUP" onsubmit="#VALIDATELOOKUP#" action="/#application.type#apps/hardwareinventory/hardwareinventorystatus.cfm?#URL.PARMS#LOOKUPBARCODE=FOUND" method="POST">
		<tr>
			<th align="LEFT"><label for="HARDWAREID">Customer, Type and Bar Code Number</label></th>
		</tr>
		<tr>
			<td>
				<cfselect name="HARDWAREID" id="HARDWAREID" size="1" query="LookupHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" tabindex="2"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="LEFT"><label for="BARCODENUMBER">Or Bar Code Number</label></th>
		</tr>
		<tr>
			<td><cfinput type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="3"></td>
		</tr>
		<tr>
			<th align="LEFT"><label for="STATEFOUNDNUMBER">Or State Found ID Number</label></th>
		</tr>
		<tr>
			<td><cfinput type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="18" tabindex="4"></td>
		</tr>
		<tr>
			<th align="LEFT"><label for="SERIALNUMBER">Or Serial Number</label></th>
		</tr>
		<tr>
			<td><cfinput type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="18" tabindex="5"></td>
		</tr>
	<cfif NOT IsDefined('URL.PROCESS')>
		<tr>
			<th align="LEFT"><label for="DIVISIONNUMBER">Or Division Number</label></th>
		</tr>
		<tr>
			<td><cfinput type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="" align="LEFT" required="No" size="18" tabindex="6"></td>
		</tr>
		<tr>
			<th align="LEFT"><label for="IPADDRESS">Or IP Address</label></th>
		</tr>
		<tr>
			<td><cfinput type="Text" name="IPADDRESS" id="IPADDRESS" value="" align="LEFT" required="No" size="18" tabindex="7"></td>
		</tr>
	</cfif>
		<tr>
			<td align="LEFT">
               	<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="8" />
               </td>
		</tr>
</cfform>
		<tr>
<cfform action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<td align="LEFT">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="9" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
		<tr>
			<td align="LEFT" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

<cfelse>

<!--- 
*******************************************************************************
* The following code is the Specific Record Status Report Hardware Inventory. *
*******************************************************************************
 --->

	<cfquery name="ListHardware" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
				HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, HI.MACADDRESS, HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE, 
                    HI.DESCRIPTIONID, ED.EQUIPMENTDESCRIPTION, HI.MODELNAMEID, MNL.MODELNAME, HI.MODELNUMBERID, MUL.MODELNUMBER,
                    HI.SPEEDNAMEID, SNL.SPEEDNAME, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, HI.WARRANTYVENDORID, HI.REQUISITIONNUMBER, 
                    HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID, HI.CUSTOMERID, HI.COMMENTS, HI.OWNINGORGID, HI.MODIFIEDBYID, HI.DATECHECKED
			<CFIF NOT IsDefined('URL.PROCESS')> 
				, HI.CLUSTERNAME, HI.IPADDRESS, HI.AIRPORTID, HI.BLUETOOTHID
			</CFIF>
		FROM		#TABLENAME# HI, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED, MODELNAMELIST MNL, 
				MODELNUMBERLIST MUL, SPEEDNAMELIST SNL
		WHERE	HARDWAREID > 0 AND
			<CFIF #FORM.HARDWAREID# GT 0>
				HI.HARDWAREID = <CFQUERYPARAM value="#FORM.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
			<CFELSEIF #FORM.BARCODENUMBER# NEQ "3065000" AND #FORM.BARCODENUMBER# NEQ ''>
				HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
			<CFIF #FORM.STATEFOUNDNUMBER# NEQ "">
               	<CFSET FORM.STATEFOUNDNUMBER = #UCase(FORM.STATEFOUNDNUMBER)#>
				HI.STATEFOUNDNUMBER = <CFQUERYPARAM value="#FORM.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
			<CFIF #FORM.SERIALNUMBER# NEQ "">
               	<CFSET FORM.SERIALNUMBER = #UCase(FORM.SERIALNUMBER)#>
				HI.SERIALNUMBER = <CFQUERYPARAM value="#FORM.SERIALNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
			<CFIF IsDefined('FORM.DIVISIONNUMBER') AND #FORM.DIVISIONNUMBER# NEQ "">
               	<CFSET FORM.DIVISIONNUMBER = #UCase(FORM.DIVISIONNUMBER)#>
				HI.DIVISIONNUMBER = <CFQUERYPARAM value="#FORM.DIVISIONNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
			<CFIF IsDefined('FORM.IPADDRESS') AND #FORM.IPADDRESS# NEQ "">
				HI.IPADDRESS = <CFQUERYPARAM value="#FORM.IPADDRESS#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
				HI.MODELNAMEID = MNL.MODELNAMEID AND
				HI.MODELNUMBERID = MUL.MODELNUMBERID AND
				HI.SPEEDNAMEID = SNL.SPEEDNAMEID
		ORDER BY	HI.BARCODENUMBER
	</cfquery>
	<cfif #ListHardware.RecordCount# EQ 0>
		<script language="JavaScript">
			<!-- 
				alert("Inventory Record Not Found");
			--> 
		</script>
		<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/hardwareinventorystatus.cfm?#URL.PARMS#" />
		<cfexit>
	</cfif>

	<cfquery name="ListRoomNumbers" datasource="#application.type#FACILITIES">
		SELECT	LOCATIONID, LOCATIONNAME
		FROM		LOCATIONS
		WHERE	LOCATIONID = <CFQUERYPARAM value="#ListHardware.EQUIPMENTLOCATIONID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	ROOMNUMBER
	</cfquery>

	<cfquery name="ListJackNumbers" datasource="#application.type#FACILITIES">
		SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, WJ.WALLDIRID, WD.WALLDIRNAME,
				WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.ACTIVE, WJ.HARDWAREID, WJ.CUSTOMERID, CUST.FULLNAME, WJ.COMMENTS
		FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WJ.HARDWAREID = <CFQUERYPARAM value="#ListHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WJ.LOCATIONID = LOC.LOCATIONID AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				WJ.WALLDIRID = WD.WALLDIRID AND
				WJ.CUSTOMERID = CUST.CUSTOMERID
		ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER, WD.WALLDIRNAME
	</cfquery>

	<cfquery name="ListManufacturers" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#ListHardware.MANUFACTURERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</cfquery>

	<cfquery name="ListWarrantyVendors" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#ListHardware.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</cfquery>

	<cfquery name="ListWarrantyVendorContacts" datasource="#application.type#PURCHASING">
		SELECT	VENDORCONTACTID, VENDORID, CONTACTNAME, PHONENUMBER, FAXNUMBER, EMAILADDRESS
		FROM		VENDORCONTACTS
		WHERE	VENDORID = <CFQUERYPARAM value="#ListHardware.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORID
	</cfquery>

	<cfquery name="ListCustomers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL
		FROM		CUSTOMERS CUST, UNITS, GROUPS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#ListHardware.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID
		ORDER BY	LASTNAME
	</cfquery>

	<cfquery name="ListHardwareSizes" datasource="#application.type#HARDWARE">
		SELECT	HARDWARESIZES.HARDWARESIZESID, HARDWARESIZES.BARCODENUMBER, HARDWARESIZES.HARDWARESIZENAMEID, SIZENAMELIST.SIZENAME
		FROM		HARDWARESIZES, SIZENAMELIST
		WHERE	HARDWARESIZES.BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND 
				HARDWARESIZES.HARDWARESIZENAMEID = SIZENAMELIST.SIZENAMEID
		ORDER BY	BARCODENUMBER
	</cfquery>

	<cfquery name="ListPCInstalledInterfaces" datasource="#application.type#HARDWARE">
		SELECT	PCINSTALLEDINTERFACES.INTERFACEID, PCINSTALLEDINTERFACES.BARCODENUMBER, PCINSTALLEDINTERFACES.INTERFACENAMEID,
				INTERFACENAMELIST.INTERFACENAME
		FROM		PCINSTALLEDINTERFACES, INTERFACENAMELIST
		WHERE	PCINSTALLEDINTERFACES.BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				PCINSTALLEDINTERFACES.INTERFACENAMEID = INTERFACENAMELIST.INTERFACENAMEID
		ORDER BY	BARCODENUMBER
	</cfquery>

	<cfquery name="ListPCInstalledPeripherals" datasource="#application.type#HARDWARE">
		SELECT	PCINSTALLEDPERIPHERALS.PERIPHERALID, PCINSTALLEDPERIPHERALS.BARCODENUMBER, PCINSTALLEDPERIPHERALS.PERIPHERALNAMEID,
				PERIPHERALNAMELIST.PERIPHERALNAME
		FROM		PCINSTALLEDPERIPHERALS, PERIPHERALNAMELIST
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				PCINSTALLEDPERIPHERALS.PERIPHERALNAMEID = PERIPHERALNAMELIST.PERIPHERALNAMEID
		ORDER BY	BARCODENUMBER
	</cfquery>

	<cfquery name="ListHardwareAttachedTo" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREATTACHEDTO.ATTACHEDTOID, HARDWAREATTACHEDTO.BARCODENUMBER, HARDWAREATTACHEDTO.ATTACHEDTO,
				HARDWAREINVENTORY.BARCODENUMBER AS ATTACHEDBARCODE
		FROM		HARDWAREATTACHEDTO, HARDWAREINVENTORY
		WHERE	HARDWAREATTACHEDTO.BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				HARDWAREATTACHEDTO.ATTACHEDTO = HARDWAREINVENTORY.HARDWAREID
		ORDER BY	BARCODENUMBER
	</cfquery>

	<cfquery name="ListHardwareWarranty" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</cfquery>

	<cfquery name="ListHardwareFiscalYear" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		WHERE	FISCALYEARID = <CFQUERYPARAM value="#ListHardware.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FISCALYEARID
	</cfquery>

	<cfquery name="ListCustomerCategories" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.CATEGORYID, CAT.CATEGORYID, CAT.CATEGORYNAME, CUST.FULLNAME
		FROM		CUSTOMERS CUST, CATEGORIES CAT
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#ListHardware.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.CATEGORYID = CAT.CATEGORYID
		ORDER BY	CUST.FULLNAME
	</cfquery>

	<cfquery name="ListSoftwareKey" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.REQUISITIONNUMBER, PR.PURCHREQID, PR.REQNUMBER, PRL.PURCHREQLINEID, PRL.PURCHREQID,
				SI.SOFTWINVENTID, SI.PURCHREQLINEID
		FROM		HARDWAREINVENTORY HI, PURCHASEMGR.PURCHREQS PR, PURCHASEMGR.PURCHREQLINES PRL, SOFTWMGR.SOFTWAREINVENTORY SI
		WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#ListHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
				HI.REQUISITIONNUMBER = PR.REQNUMBER AND
				PR.PURCHREQID = PRL.PURCHREQID AND
				PRL.PURCHREQLINEID = SI.PURCHREQLINEID
		ORDER BY	SI.SOFTWINVENTID
	</cfquery>

	<cfset SOFTWAREKEYS = ''>
	<cfif #ListSoftwareKey.RecordCount# EQ 1>
		<cfset SOFTWAREKEYS = #ListSoftwareKey.SOFTWINVENTID#>
	</cfif>
	<cfif #ListSoftwareKey.RecordCount# GT 1>
		<cfset SOFTWAREKEYS = #ValueList(ListSoftwareKey.SOFTWINVENTID)#>
	</cfif>

	<cfquery name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
		SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
		FROM		ORGCODES
		WHERE	ORGCODEID =  <CFQUERYPARAM value="#ListHardware.OWNINGORGID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	ORGCODE
	</cfquery>

	<cfquery name="ListMODIFIEDBY" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, LASTNAME, FULLNAME
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</cfquery>
	
	<table width="100%" align="center" border="3">
		<tr align="center">
			<th  align="center"><h1>IDT Hardware #SCREENTITLE# Status Report</h1></th>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<th align= "CENTER">
				Hardware Inventory Key &nbsp; = &nbsp; #ListHardware.HARDWAREID# 
				&nbsp;&nbsp;Created: &nbsp;&nbsp;#DateFormat(ListHardware.CREATIONDATE, "mm/dd/yyyy")#
			</th>
		</tr>
	</table>
	<br />
	<table width="100%" align="left" border="0">
		<tr>
<cfform action="/#application.type#apps/hardwareinventory/hardwareinventorystatus.cfm?#URL.PARMS#" method="POST">
			<td align="left" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
			</td>
</cfform>
		</tr>
		<tr>
			<th align="left">Bar Code Number</th>
			<th align="left">State Found Number</th>
		</tr>
		<tr>
			<td align="left">#ListHardware.BARCODENUMBER#</td>
			<td align="left">#ListHardware.STATEFOUNDNUMBER#</td>
		</tr>
		<tr>
			<th align="left">Serial Number</th>
			<th align="left">Division Number</th>
		</tr>
		<tr>
			<td align="left">#ListHardware.SERIALNUMBER#</td>
			<td align="left">#ListHardware.DIVISIONNUMBER#</td>
		</tr>
	<cfif NOT IsDefined('URL.PROCESS')>	
		<tr>
			<th align="left">Cluster</th>
			<th align="left">Machine</th>
		</tr>
		<tr>
			<td align="left">#ListHardware.CLUSTERNAME#</td>
			<td align="left">#ListHardware.MACHINENAME#</td>
		</tr>
		<tr>
			<th align="left">Location</th>
			<th align="left">Wall Jack</th>
		</tr>
		<tr>
			<td align="left">#ListRoomNumbers.LOCATIONNAME#</td>
		<cfif ListJackNumbers.WALLJACKID GT 0>
			<td align="left">#ListJackNumbers.CLOSET#-#ListJackNumbers.JACKNUMBER#-#ListJackNumbers.PORTLETTER#</td>
		<cfelse>
			<td valign="TOP">&nbsp;&nbsp;</td>
		</cfif>
		</tr>
		<tr>
			<th align="left">Hardware (MAC) Address</th>
			<th align="left">IP Address</th>
		</tr>
		<tr>
			<td align="left">#ListHardware.MACADDRESS#</td>
			<td align="left">#ListHardware.IPADDRESS#</td>
		</tr>
          <tr>
			<th align="left">Airport/WIFI ID</th>
			<th align="left">Bluetooth ID</th>
		</tr>
		<tr>
			<td align="left">#ListHardware.AIRPORTID#</td>
			<td align="left">#ListHardware.BLUETOOTHID#</td>
		</tr>
	<cfelse>
     	<tr>
			<th align="left">&nbsp;&nbsp;</th>
			<th align="left">Machine</th>
		</tr>
          <tr>
			<td align="left">&nbsp;&nbsp;</td>
			<td align="left">#ListHardware.MACHINENAME#</td>
		</tr>
		<tr>
			<th align="left">Location</th>
			<th align="left">Hardware (MAC) Address</th>
		</tr>
		<tr>
			<td align="left">#ListRoomNumbers.LOCATIONNAME#</td>
			<td align="left">#ListHardware.MACADDRESS#</td>
		</tr>
	</cfif>
		<tr>
			<th align="left">Equipment Type</th>
			<th align="left">Description</th>
		</tr>
		<tr>
			<td>#ListHardware.EQUIPMENTTYPE#</td>
			<td>#ListHardware.EQUIPMENTDESCRIPTION#</td>
		</tr>
		<tr>
			<th align="left">Model</th>
			<th align="left">Model Number</th>
		</tr>
		<tr>
			<td>#ListHardware.MODELNAME#</td>
			<td>#ListHardware.MODELNUMBER#</td>
		</tr>
		<tr>
			<th align="left">Speed</th>
			<th align="left">Size</th>
		</tr>
		<tr>
		<cfif ListHardware.SPEEDNAMEID GT 0>
			<td valign="TOP">#ListHardware.SPEEDNAME#</td>
		<cfelse>
			<td valign="TOP">&nbsp;&nbsp;</td>
		</cfif>
			<td valign="TOP">
				<cfloop query="ListHardwareSizes">
					#SIZENAME#<br />
				</cfloop>
			</td>
		</tr>
		<tr>
			<th align="left">Interfaces</th>
			<th align="left">Peripherals</th>
		</tr>
		<tr>
			<td valign="TOP">
				<cfloop query="ListPCInstalledInterfaces">
					#INTERFACENAME#<br />
				</cfloop>
			</td>
			<td valign="TOP">
				<cfloop query="ListPCInstalledPeripherals">
					#PERIPHERALNAME#<br />
				</cfloop>
			</td>
		</tr>
		<tr>
			<th align="left">Manufacturer</th>
			<th align="left">DELL Express Service</th>
		</tr>
		<tr>
			<td align="left">#ListManufacturers.VENDORNAME#</td>
			<td align="left">#ListHardware.DELLEXPRESSSERVICE#</td>
		</tr>
		<tr>
			<th align="left">Warr. Vendor</th>
			<th align="left">Warr. Contact & Phone</th>
		</tr>
		<tr>
			<td align="left" valign="TOP">
				<cfif ListWarrantyVendors.VENDORID GT 0>
					#ListWarrantyVendors.VENDORNAME#
				<cfelse>
					&nbsp;&nbsp;
				</cfif>
			</td>
			<td align="left">
			<cfloop query = "ListWarrantyVendorContacts">
				<cfif ListWarrantyVendors.VENDORID GT 0>
					<cfif #CONTACTNAME# EQ "">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#PHONENUMBER#<br />
					<cfelse>
						#CONTACTNAME#&nbsp;&nbsp;&nbsp;&nbsp;#PHONENUMBER#<br />
					</cfif>
				<cfelse>
					&nbsp;&nbsp;
				</cfif>
			</cfloop>
			</td>
		</tr>
		<tr>
			<th align="left">Warr. Restrictions</th>
			<th align="left">Warr. Expiration Date</th>
		</tr>
		<tr>
		
		<cfif #ListHardwareWarranty.RecordCount# GT 0>
			<td align="left">#ListHardwareWarranty.WARRANTYRESTRICTIONS#</td>
			<td align="left">#DateFormat(ListHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#</td>
		<cfelse>
			<td align="left">&nbsp;&nbsp;</td>
			<td align="left">&nbsp;&nbsp;</td>
		</cfif>
		</tr>
		<tr>
			<th align="left">Warr. Comments</th>
			<th align="left">Equipment Attached To</th>
		</tr>
		<tr>
			<td align="left" valign="TOP">#ListHardwareWarranty.WARRANTYCOMMENTS#</td>
			<td>
				<cfloop query="ListHardwareAttachedTo">
					#ATTACHEDBARCODE#<br />
				</cfloop>
			</td>
		</tr>
		<tr>
			<th align="left">Req.Number</th>
			<th align="left">P. O. Number</th>
		</tr>
		<tr>
			<td align="left">
				#ListHardware.REQUISITIONNUMBER#
			</td>
			<td align="left">
				#ListHardware.PURCHASEORDERNUMBER#
			</td>
		</tr>
		<tr>
			<th align="left">Date Received</th>
			<th align="left">Fiscal Year</th>
		</tr>
		<tr>
			<td align="left">#DateFormat(ListHardware.DATERECEIVED, "MM/DD/YYYY")#</td>
			<td align="left">#ListHardwareFiscalYear.FISCALYEAR_4DIGIT#</td>
		</tr>
		<tr>
			<th align="left">Customer</th>
			<th align="left">
				Unit&nbsp;&nbsp;/&nbsp;&nbsp;Group
			</th>
		</tr>
		<tr>
			<td align="left">#ListCustomers.FULLNAME#</td>
			<td align="left">
				#ListCustomers.UNITNAME#&nbsp;&nbsp;/&nbsp;&nbsp
				#ListCustomers.GROUPNAME#
			</td>
		</tr>
		<tr>
			<th align="left">Phone</th>
			<th align="left">Location</th>
		</tr>
		<tr>
			<td align="left">#ListCustomers.CAMPUSPHONE#</td>
			<td align="left">#ListCustomers.ROOMNUMBER#</td>
		</tr>
		<tr>
			<th align="left">Customer Category</th>
			<th align="left">Owning Org. Code</th>
		</tr>
		<tr>
			<td align="left" valign="TOP">#ListCustomerCategories.CATEGORYNAME#</td>
			<td align="left" valign="TOP">#ListOrgCodes.ORGCODENAME#</td>
		</tr>
		<tr>
			<th align="left">Comments</th>
			<th align="left">SW Key</th>
		</tr>
		<tr>
			<td align="left">#ListHardware.COMMENTS#</td>
			<td align="left">#SOFTWAREKEYS#</td>
		</tr>
		<tr>
			<th align="left">Modified By</th>
			<th align="left">Date Checked</th>
		</tr>
		<tr>
			<td align="left" valign="TOP">#ListModifiedBy.FULLNAME#</td>
			<td align="left">#DateFormat(ListHardware.DATECHECKED, "MM/DD/YYYY")#</td>
		</tr>
		<tr>
<cfform action="/#application.type#apps/hardwareinventory/hardwareinventorystatus.cfm?#URL.PARMS#" method="POST">
			<td align="left" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
			</td>
</cfform>
		</tr>
		<tr>
			<td align="LEFT" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</cfif>

</body>
</html>
</cfoutput>