<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventorymultiplemodloop.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: Multiple Record Modify Loop in IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on on 12/05/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventorymultiplemodloop.cfm">
<CFSET CONTENT_UPDATED = "December 05 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Multiple Record Modify Loop in IDT Hardware Inventory</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {		 
		if (document.LOOKUP.BARCODENUMBER.value == "3065000"
		 && (document.LOOKUP.STATEFOUNDNUMBER.value == ""       || document.LOOKUP.STATEFOUNDNUMBER.value == " ")
		 && (document.LOOKUP.SERIALNUMBER.value == ""           || document.LOOKUP.SERIALNUMBER.value == " ")           
		 && (document.LOOKUP.DIVISIONNUMBER.value == ""         || document.LOOKUP.DIVISIONNUMBER.value == " ")
		 && document.LOOKUP.BUILDINGNAMEID.selectedIndex == "0" && document.LOOKUP.LOCATIONID.selectedIndex == "0"
		 && document.LOOKUP.LOCATIONID.selectedIndex == "0"      
		 && (document.LOOKUP.ROOMNUMBER.value == ""             || document.LOOKUP.ROOMNUMBER.value == " ")
		 && (document.LOOKUP.IPADDRESS.value == ""              || document.LOOKUP.IPADDRESS.value == " ")
		 && (document.LOOKUP.AIRPORTID.value == ""               || document.LOOKUP.AIRPORTID.value == " ")
		 && (document.LOOKUP.BLUETOOTHID.value == ""              || document.LOOKUP.BLUETOOTHID.value == " ")  
		 && (document.LOOKUP.EQUIPMENTTYPE.value == ""          || document.LOOKUP.EQUIPMENTTYPE.value == " ")           
		 && (document.LOOKUP.DESCRIPTION.value == ""			 || document.LOOKUP.DESCRIPTION.value == " ")   
		 && document.LOOKUP.CLUSTERNAME.value == ""
		 && (document.LOOKUP.MODELNAME.value == ""              || document.LOOKUP.MODELNAME.value == " ")             
		 && (document.LOOKUP.MODELNUMBER.value == ""            || document.LOOKUP.MODELNUMBER.value == " ")
		 && document.LOOKUP.SPEEDNAMEID.selectedIndex == "0"     
		 && document.LOOKUP.SIZENAMEID.selectedIndex == "0"
		 && document.LOOKUP.INTERFACENAMEID.selectedIndex == "0" 
		 && document.LOOKUP.PERIPHERALNAMEID.selectedIndex == "0"
		 && (document.LOOKUP.REQUISITIONNUMBER.value == ""      || document.LOOKUP.REQUISITIONNUMBER.value == " ")
		 && (document.LOOKUP.PURCHASEORDERNUMBER.value == ""    || document.LOOKUP.PURCHASEORDERNUMBER.value == " ")
		 && (document.LOOKUP.WARRANTYVENDORNAME.value == ""     || document.LOOKUP.WARRANTYVENDORNAME.value == " ")      
		 && (document.LOOKUP.WARRANTYRESTRICTIONS.value == ""   || document.LOOKUP.WARRANTYRESTRICTIONS.value == " ")
		 && (document.LOOKUP.WARRANTYCOMMENTS.value == ""       || document.LOOKUP.WARRANTYCOMMENTS.value == " ")       
		 && (document.LOOKUP.COMMENTS.value == ""               || document.LOOKUP.COMMENTS.value == " ")
		 && document.LOOKUP.CUSTOMERID.selectedIndex == "0"      
		 && (document.LOOKUP.CUSTOMERCATEGORY.value == ""       || document.LOOKUP.CUSTOMERCATEGORY.value == " ")
		 && (document.LOOKUP.CUSTOMERFIRSTNAME.value == ""      || document.LOOKUP.CUSTOMERFIRSTNAME.value == " ")     
		 && (document.LOOKUP.CUSTOMERLASTNAME.value == ""       || document.LOOKUP.CUSTOMERLASTNAME.value == " ")
		 && document.LOOKUP.UNITID.selectedIndex == "0"          
		 && (document.LOOKUP.OWNINGORGID.selectedIndex == "0")
		 && document.LOOKUP.MODIFIEDBYID.selectedIndex == "0"    
		 && (document.LOOKUP.DATECHECKED.value == ""            || document.LOOKUP.DATECHECKED.value == " ")) {
			alertuser ("You must enter information in one of the thiry-three (33) fields!");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

		if (document.LOOKUP.BARCODENUMBER.value.length > 7) {
			var barcode = document.LOOKUP.BARCODENUMBER.value;
			document.LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

	}

	function validateBarcodeDateFields() {

		if (document.HARDWAREINVENTORY.BARCODENUMBER.value.length == 14) {
			var barcode = document.HARDWAREINVENTORY.BARCODENUMBER.value;
			document.HARDWAREINVENTORY.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if (document.HARDWAREINVENTORY.BARCODENUMBER.value.length != 17 || !document.HARDWAREINVENTORY.BARCODENUMBER.value.match(/^\d{1} \d{4} \d{5} \d{4}/)) {
		 	alertuser ("The BarCode must be 17 characters in the format d dddd ddddd dddd and can only contain digits and spaces!");
			document.HARDWAREINVENTORY.BARCODENUMBER.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.selectedIndex == "0") {
			alertuser (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.name +  ",  An Equipment Type MUST be selected!");
			document.HARDWAREINVENTORY.EQUIPMENTTYPEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.DESCRIPTIONID.selectedIndex == "0") {
			alertuser (document.HARDWAREINVENTORY.DESCRIPTIONID.name +  ",  An Equipment Description MUST be selected!");
			document.HARDWAREINVENTORY.DESCRIPTIONID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNAMEID.selectedIndex == "0") {
			alertuser (document.HARDWAREINVENTORY.MODELNAMEID.name +  ",  A Model Name MUST be selected!");
			document.HARDWAREINVENTORY.MODELNAMEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNUMBERID.selectedIndex == "0") {
			alertuser (document.HARDWAREINVENTORY.MODELNUMBERID.name +  ",  A Model Number MUST be selected!");
			document.HARDWAREINVENTORY.MODELNUMBERID.focus();
			return false;
		}

		if (!document.HARDWAREINVENTORY.DATERECEIVED.value == "" && !document.HARDWAREINVENTORY.DATERECEIVED.value == " " 
		 && !document.HARDWAREINVENTORY.DATERECEIVED.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.HARDWAREINVENTORY.DATERECEIVED.name +  ", The desired Date Received MUST be entered in the format MM/DD/YYYY!");
			document.HARDWAREINVENTORY.DATERECEIVED.focus();
			return false;
		}

		if (!document.HARDWAREINVENTORY.WARRANTYEXPIRATIONDATE.value == "" && !document.HARDWAREINVENTORY.WARRANTYEXPIRATIONDATE.value == " " 
		 && !document.HARDWAREINVENTORY.WARRANTYEXPIRATIONDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.HARDWAREINVENTORY.WARRANTYEXPIRATIONDATE.name +  ", The desired Warranty Expiration Date MUST be entered in the format MM/DD/YYYY!");
			document.HARDWAREINVENTORY.WARRANTYEXPIRATIONDATE.focus();
			return false;
		}

	}


	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


	function setNextRecord() {
		document.HARDWAREINVENTORY.PROCESSHARDWAREINVENTORY.value = "NEXTRECORD";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
	<CFSET temp = ArraySet(session.HardwareIDArray, 1, 1, 0)>
	<CFSET session.ArrayCounter = 0>
<CFELSE>
	<CFSET CURSORFIELD = "document.HARDWAREINVENTORY.BARCODENUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
*************************************************************************************************************
* The following code is the Request Look Up Process for Modify Loop Multiple Records in Hardware Inventory. *
*************************************************************************************************************
 --->

<CFINCLUDE template = "hardwareinventorylookup.cfm">

<CFIF (NOT IsDefined('URL.LOOKUPBARCODE')) OR (IsDefined('session.ENDPGM') AND #session.ENDPGM# EQ "YES")>
	<CFEXIT>
<CFELSE>

<!--- 
*****************************************************************************************
* The following code is the Modify Loop Multiple Records Process in Hardware Inventory. *
*****************************************************************************************
 --->

	<CFIF IsDefined('URL.ROOMMANUFCUSTCHANGED')>
		<CFQUERY name="UpdateHardware" datasource="#application.type#HARDWARE">
			UPDATE	HARDWAREINVENTORY
			SET		HARDWAREINVENTORY.EQUIPMENTLOCATIONID = #val(FORM.EQUIPMENTLOCATIONID)#,
					HARDWAREINVENTORY.MANUFACTURERID = #val(FORM.MANUFACTURERID)#,
					HARDWAREINVENTORY.WARRANTYVENDORID = #val(FORM.WARRANTYVENDORID)#,
					HARDWAREINVENTORY.CUSTOMERID = #val(FORM.CUSTOMERID)#
			WHERE	(HARDWAREINVENTORY.HARDWAREID = #val(cookie.HARDWAREID)#)
		</CFQUERY>
		<CFSET FORM.HARDWAREID = cookie.HARDWAREID>
	<CFELSE>
		<CFSET session.ArrayCounter = session.ArrayCounter + 1>
		<CFSET FORM.HARDWAREID = session.HardwareIDArray[session.ArrayCounter]>
	</CFIF>

	<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HARDWAREID, CREATIONDATE, BARCODENUMBER, STATEFOUNDNUMBER, SERIALNUMBER, DIVISIONNUMBER,
				CLUSTERNAME, MACHINENAME, EQUIPMENTLOCATIONID, MACADDRESS, AIRPORTID, BLUETOOTHID, EQUIPMENTTYPEID,
				DESCRIPTIONID, MODELNAMEID, MODELNUMBERID, SPEEDNAMEID, MANUFACTURERID, DELLEXPRESSSERVICE, WARRANTYVENDORID,
				REQUISITIONNUMBER, PURCHASEORDERNUMBER, DATERECEIVED, FISCALYEARID, CUSTOMERID, COMMENTS,
				OWNINGORGID, MODIFIEDBYID, DATECHECKED, IPADDRESS
		FROM		HARDWAREINVENTORY
		WHERE	HARDWAREID = <CFQUERYPARAM value="#FORM.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="ListEquipmentTypes" datasource="#application.type#HARDWARE" blockfactor="13">
		SELECT	EQUIPTYPEID, EQUIPMENTTYPE
		FROM		EQUIPMENTTYPE
		ORDER BY	EQUIPMENTTYPE
	</CFQUERY>

	<CFQUERY name="ListEquipmentDescriptions" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	EQUIPDESCRID, EQUIPMENTDESCRIPTION
		FROM		EQUIPMENTDESCRIPTION
		ORDER BY	EQUIPMENTDESCRIPTION
	</CFQUERY>

	<CFQUERY name="ListModelNames" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	MODELNAMEID, MODELNAME
		FROM		MODELNAMELIST
		ORDER BY	MODELNAME
	</CFQUERY>

	<CFQUERY name="ListModelNumbers" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	MODELNUMBERID, MODELNUMBER
		FROM		MODELNUMBERLIST
		ORDER BY	MODELNUMBER
	</CFQUERY>

	<CFQUERY name="ListSpeedNames" datasource="#application.type#HARDWARE" blockfactor="86">
		SELECT	SPEEDNAMEID, SPEEDNAME
		FROM		SPEEDNAMELIST
		ORDER BY	SPEEDNAME
	</CFQUERY>

	<CFQUERY name="ListSizeNames" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	SIZENAMEID, SIZENAME
		FROM		SIZENAMELIST
		ORDER BY	SIZENAMEID
	</CFQUERY>

	<CFQUERY name="ListInterfaces" datasource="#application.type#HARDWARE" blockfactor="92">
		SELECT	INTERFACENAMEID, INTERFACENAME
		FROM		INTERFACENAMELIST
		ORDER BY	INTERFACENAME
	</CFQUERY>

	<CFQUERY name="ListPeripherals" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	PERIPHERALNAMEID, PERIPHERALNAME
		FROM		PERIPHERALNAMELIST
		ORDER BY	PERIPHERALNAME
	</CFQUERY>

	<CFQUERY name="ListHardwareAttachedTo" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HARDWAREINVENTORY.HARDWAREID, HARDWAREINVENTORY.BARCODENUMBER,
				EQUIPMENTTYPE.EQUIPMENTTYPE || ' - ' || HARDWAREINVENTORY.BARCODENUMBER AS ATTACHEDHARDWARE
		FROM		HARDWAREINVENTORY, EQUIPMENTTYPE
		WHERE	HARDWAREINVENTORY.EQUIPMENTTYPEID = EQUIPTYPEID
		ORDER BY	ATTACHEDHARDWARE
	</CFQUERY>

	<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER, LOCATIONNAME
		FROM		LOCATIONS
		ORDER BY	ROOMNUMBER
	</CFQUERY>
	
	<CFQUERY name="GetRoomNumbers" datasource="#application.type#FACILITIES">
		SELECT	LOCATIONID, ROOMNUMBER, LOCATIONNAME
		FROM		LOCATIONS
		WHERE	LOCATIONID = <CFQUERYPARAM value="#GetHardware.EQUIPMENTLOCATIONID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="GetJackNumbers" datasource="#application.type#FACILITIES">
		SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, WJ.WALLDIRID, WD.WALLDIRNAME,
				WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.ACTIVE, WJ.HARDWAREID, WJ.CUSTOMERID, CUST.FULLNAME, WJ.COMMENTS
		FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WJ.HARDWAREID = <CFQUERYPARAM value="#GetHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WJ.LOCATIONID = LOC.LOCATIONID AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				WJ.WALLDIRID = WD.WALLDIRID AND
				WJ.CUSTOMERID = CUST.CUSTOMERID
		ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER, WD.WALLDIRNAME
	</CFQUERY>

	<CFQUERY name="GetManufacturers" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#GetHardware.MANUFACTURERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</CFQUERY>
	
	<CFQUERY name="ListWarrantyVendors" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		ORDER BY	VENDORNAME
	</CFQUERY>
		
	<CFQUERY name="GetWarrantyVendors" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#GetHardware.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</CFQUERY>
	
	<CFQUERY name="GetWarrantyVendorContacts" datasource="#application.type#PURCHASING">
		SELECT	VENDORCONTACTID, VENDORID, CONTACTNAME, PHONENUMBER, FAXNUMBER, EMAILADDRESS
		FROM		VENDORCONTACTS
		WHERE	VENDORID = <CFQUERYPARAM value="#GetWarrantyVendors.VENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORID
	</CFQUERY>
	
	<CFQUERY name="GetCustomers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERS.CUSTOMERID, CUSTOMERS.LASTNAME, CUSTOMERS.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUSTOMERS.CAMPUSPHONE,
				LOCATIONS.ROOMNUMBER, CUSTOMERS.EMAIL
		FROM		CUSTOMERS, UNITS, GROUPS, FACILITIESMGR.LOCATIONS
		WHERE	CUSTOMERS.CUSTOMERID = <CFQUERYPARAM value="#GetHardware.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUSTOMERS.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUSTOMERS.LOCATIONID = LOCATIONS.LOCATIONID
		ORDER BY	LASTNAME
	</CFQUERY>
	
	<CFQUERY name="GetHardwareSizes" datasource="#application.type#HARDWARE" blockfactor="6">
		SELECT	HARDWARESIZESID, BARCODENUMBER, HARDWARESIZENAMEID
		FROM		HARDWARESIZES
		WHERE	BARCODENUMBER = '#GetHardware.BARCODENUMBER#'
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	
	<CFSET DisplaySizeNameArray=ArrayNew(1)>
	<CFSET StoreSizeNameKeyArray=ArrayNew(1)>
	<CFSET temp = ArraySet(DisplaySizeNameArray, 1, 6, 0)>
	<CFSET temp = ArraySet(StoreSizeNameKeyArray, 1, 6, 0)>
	<CFLOOP query="GetHardwareSizes">
		<CFSET DisplaySizeNameArray[CurrentRow]=GetHardwareSizes.HARDWARESIZENAMEID[CurrentRow]>
		<CFSET StoreSizeNameKeyArray[CurrentRow]=GetHardwareSizes.HARDWARESIZESID[CurrentRow]>
	</CFLOOP>
	
	<CFQUERY name="GetPCInstalledInterfaces" datasource="#application.type#HARDWARE" blockfactor="6">
		SELECT	INTERFACEID, BARCODENUMBER, INTERFACENAMEID
		FROM		PCINSTALLEDINTERFACES
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	<CFSET DisplayInstalledInterfacesArray=ArrayNew(1)>
	<CFSET StoreInstalledInterfacesKeyArray=ArrayNew(1)>
	<CFSET temp = ArraySet(DisplayInstalledInterfacesArray, 1, 6, 0)> 
	<CFSET temp = ArraySet(StoreInstalledInterfacesKeyArray, 1, 6, 0)>
	<CFLOOP query="GetPCInstalledInterfaces">
		<CFSET DisplayInstalledInterfacesArray[CurrentRow]=GetPCInstalledInterfaces.INTERFACENAMEID[CurrentRow]>
		<CFSET StoreInstalledInterfacesKeyArray[CurrentRow]=GetPCInstalledInterfaces.INTERFACEID[CurrentRow]>
	</CFLOOP>
	
	<CFQUERY name="GetPCInstalledPeripherals" datasource="#application.type#HARDWARE" blockfactor="6">
		SELECT	PERIPHERALID, BARCODENUMBER, PERIPHERALNAMEID
		FROM		PCINSTALLEDPERIPHERALS
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	<CFSET DisplayInstalledPeripheralsArray=ArrayNew(1)>
	<CFSET StoreInstalledPeripheralsKeyArray=ArrayNew(1)>
	<CFSET temp = ArraySet(DisplayInstalledPeripheralsArray, 1, 6, 0)> 
	<CFSET temp = ArraySet(StoreInstalledPeripheralsKeyArray, 1, 6, 0)>
	<CFLOOP query="GetPCInstalledPeripherals">
		<CFSET DisplayInstalledPeripheralsArray[CurrentRow]=GetPCInstalledPeripherals.PERIPHERALNAMEID[CurrentRow]>
		<CFSET StoreInstalledPeripheralsKeyArray[CurrentRow]=GetPCInstalledPeripherals.PERIPHERALID[CurrentRow]>
	</CFLOOP>
	
	<CFQUERY name="GetHardwareAttachedTo" datasource="#application.type#HARDWARE" blockfactor="6">
		SELECT	ATTACHEDTOID, BARCODENUMBER, ATTACHEDTO
		FROM		HARDWAREATTACHEDTO
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	<CFSET DisplayHardwareAttachedToArray=ArrayNew(1)>
	<CFSET StoreHardwareAttachedToKeyArray=ArrayNew(1)>
	<CFSET temp = ArraySet(DisplayHardwareAttachedToArray, 1, 6, 0)> 
	<CFSET temp = ArraySet(StoreHardwareAttachedToKeyArray, 1, 6, 0)>
	<CFLOOP query="GetHardwareAttachedTo">
		<CFSET DisplayHardwareAttachedToArray[CurrentRow]=GetHardwareAttachedTo.ATTACHEDTO[CurrentRow]>
		<CFSET StoreHardwareAttachedToKeyArray[CurrentRow]=GetHardwareAttachedTo.ATTACHEDTOID[CurrentRow]>
	</CFLOOP>

	<CFQUERY name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
		SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
		FROM		ORGCODES
		ORDER BY	ORGCODE
	</CFQUERY>

	<CFQUERY name="GetRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 300 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 30
		ORDER BY	CUST.FULLNAME
	</CFQUERY>
	
	<CFQUERY name="GetHardwareWarranty" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	
	<CFQUERY name="GetHardwareFiscalYear" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Multiple Record Modify Loop in IDT Hardware Inventory</H1></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align= "CENTER">
				Hardware Inventory Key &nbsp; = &nbsp; #GetHardware.HARDWAREID# 
				&nbsp;&nbsp;Created: &nbsp;&nbsp;#DateFormat(GetHardware.CREATIONDATE, "mm/dd/yyyy")#
			</TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/inventorymultiplemodloop.cfm?PROCESS=MODIFYLOOP" method="POST">
			<TD align="left" valign="bottom" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
<CFFORM action="/#application.type#apps/hardwareinventory/lookuproommanufcustinfo.cfm?PROCESS=MODIFYLOOP&ROOMMANUFCUSTCHANGED=YES&LOCATIONID=#GetRoomNumbers.LOCATIONID#&WALLJACK=#GetJackNumbers.WALLJACKID#&MANUFACTURERID=#GetManufacturers.VENDORID#&WARRANTYVENDORID=#GetWarrantyVendors.VENDORID#&CUSTOMERID=#GetCustomers.CUSTOMERID#" method="POST">
			<TD align="left" width="50%" valign="top">
               	<INPUT type="image" src="/images/buttonEditRmVendorCust.jpg" value="Change Room/Manuf/Cust" alt="HW Change Room, Manufacturer, Warranty Vendor and Customer" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
	</TABLE>
	   
     <FIELDSET>
     <LEGEND>Equipment</LEGEND>   
<CFFORM name="HARDWAREINVENTORY" onsubmit="return validateBarcodeDateFields();" action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm" method="POST" ENABLECAB="Yes">
     <TABLE width="100%" align="LEFT">
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="BARCODENUMBER">*Bar Code Number</LABEL></H4></TH>
			<TH align="left" width="50%"><LABEL for="STATEFOUNDNUMBER">State Found Number</LABEL></TH>
		</TR>
		<TR>
			<CFCOOKIE name="HARDWAREID" secure="NO" value="#GetHardware.HARDWAREID#">
			<TD align="left" width="50%"><CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="#GetHardware.BARCODENUMBER#" align="LEFT" required="NO" size="18" tabindex="3"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="#GetHardware.STATEFOUNDNUMBER#" align="LEFT" required="No" size="25" maxlength="50" tabindex="4"></TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="SERIALNUMBER">Serial Number</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="DIVISIONNUMBER">Division Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="#GetHardware.SERIALNUMBER#" align="LEFT" required="No" size="25" maxlength="50" tabindex="5"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="#GetHardware.DIVISIONNUMBER#" align="LEFT" required="No" size="50" tabindex="6"></TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="EQUIPMENTTYPEID">*Equipment Type</LABEL></H4></TH>
			<TH align="left" width="50%"><H4><LABEL for="DESCRIPTIONID">*Description</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="EQUIPMENTTYPEID" id="EQUIPMENTTYPEID" size="1" query="ListEquipmentTypes" value="EQUIPTYPEID" display="EQUIPMENTTYPE" selected="#GetHardware.EQUIPMENTTYPEID#" required="No" tabindex="7"></CFSELECT>
			</TD>
			<TD align="left" width="50%">
				<CFSELECT name="DESCRIPTIONID" id="DESCRIPTIONID" size="1" query="ListEquipmentDescriptions" value="EQUIPDESCRID" display="EQUIPMENTDESCRIPTION" selected="#GetHardware.DESCRIPTIONID#" required="No" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="MODELNAMEID">*Model</LABEL></H4></TH>
			<TH align="left" width="50%"><H4><LABEL for="MODELNUMBERID">*Model Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="MODELNAMEID" id="MODELNAMEID" size="1" query="ListModelNames" value="MODELNAMEID" display="MODELNAME" selected="#GetHardware.MODELNAMEID#" required="No" tabindex="9"></CFSELECT>
			</TD>
			<TD align="left" width="50%">
				<CFSELECT name="MODELNUMBERID" id="MODELNUMBERID" size="1" query="ListModelNumbers" value="MODELNUMBERID" display="MODELNUMBER" selected="#GetHardware.MODELNUMBERID#" required="No" tabindex="10"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="SPEEDNAMEID">Speed</LABEL></TH>
			<TH align="left" width="50%">Size</TH>
		</TR>
		<TR>
			<TD valign="TOP">
				<CFSELECT name="SPEEDNAMEID" id="SPEEDNAMEID" size="1" query="ListSpeedNames" value="SPEEDNAMEID" display="SPEEDNAME" selected="#GetHardware.SPEEDNAMEID#" required="No" tabindex="11"></CFSELECT>
			</TD>
			<TD align="left" width="50%" valign="TOP">
				<CFLOOP index="Counter" from=1 to=6>
					<INPUT type="hidden" name="StoreSizeNameKey#Counter#" value="#StoreSizeNameKeyArray[Counter]#" />
					<CFSET TAB = #Counter# + 11>
					<LABEL for="SIZENAMEID#Counter#" class="LABEL_hidden">Size #Counter#</LABEL>
					<CFSELECT name="SIZENAMEID#Counter#" id="SIZENAMEID#Counter#" size="1" query="ListSizeNames" value="SIZENAMEID" display="SIZENAME" selected="#DisplaySizeNameArray[Counter]#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Interfaces</TH>
			<TH align="left" width="50%">Peripherals</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFLOOP index="Counter" from=1 to=6>
					<INPUT type="hidden" name="StoreInstalledInterfacesKey#Counter#" value="#StoreInstalledInterfacesKeyArray[Counter]#" />
					<CFSET TAB = #Counter# + 17>
					<LABEL for="INTERFACENAMEID#Counter#" class="LABEL_hidden">Computer Interface #Counter#</LABEL>
					<CFSELECT name="INTERFACENAMEID#Counter#" id="INTERFACENAMEID#Counter#" size="1" query="ListInterfaces" value="INTERFACENAMEID" display="INTERFACENAME" selected="#DisplayInstalledInterfacesArray[Counter]#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
			</TD>
			<TD align="left" width="50%">
				<CFLOOP index="Counter" from=1 to=6>
					<INPUT type="hidden" name="StoreInstalledPeripheralsKey#Counter#" value="#StoreInstalledPeripheralsKeyArray[Counter]#" />
					<CFSET TAB = #Counter# + 23>
					<LABEL for="PERIPHERALNAMEID#Counter#" class="LABEL_hidden">Computer Peripheral #Counter#</LABEL>
					<CFSELECT name="PERIPHERALNAMEID#Counter#" id="PERIPHERALNAMEID#Counter#" size="1" query="ListPeripherals" value="PERIPHERALNAMEID" display="PERIPHERALNAME" selected="#DisplayInstalledPeripheralsArray[Counter]#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
			</TD>
		</TR>
          <TR>
			<TH align="left" width="50%">Equipment Attached To</TH>
               <TH align="left" width="50%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFLOOP index="Counter" from=1 to=6>
					<INPUT type="hidden" name="StoreHardwareAttachedToKey#Counter#" value="#StoreHardwareAttachedToKeyArray[Counter]#" />
					<CFSET TAB = #Counter# + 29>
					<LABEL for="ATTACHEDTO#Counter#" class="LABEL_hidden">Equipment Attached To #Counter#</LABEL>
					<CFSELECT name="ATTACHEDTO#Counter#" id="ATTACHEDTO#Counter#" size="1" query="ListHardwareAttachedTo" value="HARDWAREID" display="ATTACHEDHARDWARE" selected="#DisplayHardwareAttachedToArray[Counter]#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
			</TD>
               <TD align="left" width="50%">&nbsp;&nbsp;</TD>
		</TR>

          <TR>
			<TH align="left" width="50%">Location</TH>
			<TH align="left" width="50%"><LABEL for="CLUSTERNAME">Cluster</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<INPUT type="hidden" name="EQUIPMENTLOCATIONID" value="#GetRoomNumbers.LOCATIONID#" />
				#GetRoomNumbers.LOCATIONNAME#
			</TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="CLUSTERNAME" id="CLUSTERNAME" value="#GetHardware.CLUSTERNAME#" align="LEFT" required="No" size="50" tabindex="36"></TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Network</LEGEND>
	<TABLE width="100%" border="0">
          <TR>
			<TH align="left" width="50%">Wall Jack</TH>
			<TH align="left" width="50%"><LABEL for="MACHINENAME">Machine</LABEL></TH>
		</TR>
		<TR>
		<CFIF GetJackNumbers.WALLJACKID GT 0>
          	<INPUT type="hidden" name="WALLJACKID" value="#GetJackNumbers.WALLJACKID#" />
			<TD align="left" width="50%">#GetJackNumbers.CLOSET#-#GetJackNumbers.JACKNUMBER#-#GetJackNumbers.PORTLETTER#</TD>
          <CFELSE>
               <TD align="left" width="50%">&nbsp;&nbsp;</TD>
		</CFIF>
			<TD align="left" width="50%"><CFINPUT type="Text" name="MACHINENAME" id="MACHINENAME" value="#GetHardware.MACHINENAME#" align="LEFT" required="No" size="50" tabindex="37"></TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="MACADDRESS">MAC Address</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="IPADDRESS">IP Address</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="MACADDRESS" id="MACADDRESS" value="#GetHardware.MACADDRESS#" align="LEFT" required="No" size="25" maxlength="50"  tabindex="38"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="#GetHardware.IPADDRESS#" align="LEFT" required="No" size="15" maxlength="15" tabindex="39"></TD>
		</TR>
          <TR>
			<TH align="left" width="50%"><LABEL for="AIRPORTID">Airport/WIFI ID</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="BLUETOOTHID">Bluetooth ID</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="AIRPORTID" id="AIRPORTID" value="#GetHardware.AIRPORTID#" align="LEFT" required="No" size="25" maxlength="50" tabindex="40"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="BLUETOOTHID" id="BLUETOOTHID" value="#GetHardware.BLUETOOTHID#" align="LEFT" required="No" size="15" maxlength="15" tabindex="41"></TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Purchasing and Warranty</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
			<TH align="left" width="50%"><LABEL for="REQUISITIONNUMBER">Req. Number</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="PURCHASEORDERNUMBER">P.O. Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="REQUISITIONNUMBER" id="REQUISITIONNUMBER" value="#GetHardware.REQUISITIONNUMBER#" align="LEFT" required="No" size="20" tabindex="42">
			</TD>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="PURCHASEORDERNUMBER" id="PURCHASEORDERNUMBER" value="#GetHardware.PURCHASEORDERNUMBER#" align="LEFT" required="No" size="20" tabindex="43">
			</TD>
		</TR>
          <TR>
			<TH align="left" width="50%"><LABEL for="FISCALYEARID">Fiscal Year</LABEL></TH>
   			<TH align="left" width="50%"><LABEL for="OWNINGORGID">Owning Org. Code</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" query="GetHardwareFiscalYear" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#GetHardware.FISCALYEARID#" tabindex="44"></CFSELECT>
			</TD>
               			<TD align="LEFT" valign="TOP">
				<CFSELECT name="OWNINGORGID" id="OWNINGORGID" size="1" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" selected="#GetHardware.OWNINGORGID#" required="No" tabindex="45"></CFSELECT>
			</TD>

		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="DATERECEIVED">Date Received</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="WARRANTYEXPIRATIONDATE">Warr. Expiration Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="DATERECEIVED" id="DATERECEIVED" value="#DateFormat(GetHardware.DATERECEIVED, "MM/DD/YYYY")#" align="LEFT" required="No" size="50" tabindex="46">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'HARDWAREINVENTORY','controlname': 'DATERECEIVED'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		<CFIF #GetHardwareWarranty.RecordCount# GT 0>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="WARRANTYEXPIRATIONDATE" id="WARRANTYEXPIRATIONDATE" value="#DateFormat(GetHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#" align="LEFT" required="NO" size="15" tabindex="47">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'HARDWAREINVENTORY','controlname': 'WARRANTYEXPIRATIONDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
          <CFELSE>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="WARRANTYEXPIRATIONDATE" id="WARRANTYEXPIRATIONDATE" value="" align="LEFT" required="NO" size="15" tabindex="47">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'HARDWAREINVENTORY','controlname': 'WARRANTYEXPIRATIONDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</CFIF>
		</TR>
     	<TR>
			<TH align="left" width="50%">Manufacturer</TH>
			<TH align="left" width="50%"><LABEL for="DELLEXPRESSSERVICE">DELL Express Service</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<INPUT type="hidden" name="MANUFACTURERID" value="#GetManufacturers.VENDORID#" />
				#GetManufacturers.VENDORNAME#
			</TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="DELLEXPRESSSERVICE" id="DELLEXPRESSSERVICE" value="#GetHardware.DELLEXPRESSSERVICE#" align="LEFT" required="No" size="50" tabindex="48"></TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Warr. Vendor</TH>
			<TH align="left" width="50%">Warr. Contact & Phone</TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<INPUT type="hidden" name="WARRANTYVENDORID" value="#GetWarrantyVendors.VENDORID#" />
				<CFIF GetWarrantyVendors.VENDORID GT 0>
					#GetWarrantyVendors.VENDORNAME#
				<CFELSE>
					&nbsp;&nbsp;
				</CFIF>
			</TD>
			<TD align="left" width="50%">
			<CFLOOP query = "GetWarrantyVendorContacts">
				<CFIF GetWarrantyVendors.VENDORID GT 0>
					<CFIF #CONTACTNAME# EQ "">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#PHONENUMBER#<BR />
					<CFELSE>
						#CONTACTNAME#&nbsp;&nbsp;&nbsp;&nbsp;#PHONENUMBER#<BR />
					</CFIF>
				<CFELSE>
					&nbsp;&nbsp;
				</CFIF>
			</CFLOOP>
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="WARRANTYRESTRICTIONS">Warr. Restrictions</LABEL></TH>
    			<TH align="left" width="50%"><LABEL for="WARRANTYCOMMENTS">Warr. Comments</LABEL></TH>
		</TR>
		<TR>
		
		<CFIF #GetHardwareWarranty.RecordCount# GT 0>
			<TD align="left" width="50%" valign="TOP">
				<INPUT type="hidden" name="HARDWAREWARRANTYID" value="#GetHardwareWarranty.HARDWAREWARRANTYID#" />
				<CFINPUT type="Text" name="WARRANTYRESTRICTIONS" id="WARRANTYRESTRICTIONS" value="#GetHardwareWarranty.WARRANTYRESTRICTIONS#" align="LEFT" required="NO" size="50" maxlength="600" tabindex="49">
			</TD>
               <TD align="left" width="50%" valign="TOP"><CFTEXTAREA name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="50">#GetHardwareWarranty.WARRANTYCOMMENTS#</CFTEXTAREA></TD>
		<CFELSE>
			<TD align="left" width="50%" valign="TOP">
				<INPUT type="hidden" name="HARDWAREWARRANTYID" value=0 />
				<CFINPUT type="Text" name="WARRANTYRESTRICTIONS" id="WARRANTYRESTRICTIONS" value="" align="LEFT" required="NO" size="50" maxlength="600" tabindex="49">
			</TD>
               <TD align="left" width="50%" valign="TOP"><CFTEXTAREA name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="50"></CFTEXTAREA></TD>
		</CFIF>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Customer and Modifier</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
			<TH align="left" width="50%">Customer</TH>
			<TH align="left" width="50%">
				 Unit&nbsp;&nbsp;/&nbsp;&nbsp;Group
			</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<INPUT type="hidden" name="CUSTOMERID" value="#GetCustomers.CUSTOMERID#" />
				#GetCustomers.FULLNAME#
			</TD>
			<TD align="left" width="50%">
				#GetCustomers.UNITNAME#&nbsp;&nbsp;/&nbsp;&nbsp
				#GetCustomers.GROUPNAME#
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Phone</TH>
			<TH align="left" width="50%">Location</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">#GetCustomers.CAMPUSPHONE#</TD>
			<TD align="left" width="50%">#GetCustomers.ROOMNUMBER#</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="COMMENTS">Comments</LABEL></TH>
               <TH align="left" width="50%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
               	<CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="51">#GetHardware.COMMENTS#</CFTEXTAREA>
               </TD>
               <TD align="left" width="50%">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
			<TH align="left" width="50%">Date Checked</TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="GetRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="52"></CFSELECT>
			</TD>
			<TD align="left" width="50%">
				<CFSET FORM.DATECHECKED = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="DATECHECKED" value="#FORM.DATECHECKED#" />
				#DateFormat(FORM.DATECHECKED, "MM/DD/YYYY")#
			</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
    	<LEGEND>Record Processing</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TD align="left" width="50%" valign="bottom">
				<INPUT type="hidden" name="PROCESSHARDWAREINVENTORY" value="MODIFYLOOP" />
               	<INPUT type="image" src="/images/buttonModifyLoop.jpg" value="MODIFYLOOP" alt="Modify Loop" tabindex="53" /><BR />		
				<INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" onClick="return setNextRecord();" tabindex="54" /><BR>
				<COM>(No change including Modified Date Field.)</COM>
			</TD>
</CFFORM>
<CFFORM action="/#application.type#apps/hardwareinventory/lookuproommanufcustinfo.cfm?PROCESS=MODIFYLOOP&ROOMMANUFCUSTCHANGED=YES&LOCATIONID=#GetRoomNumbers.LOCATIONID#&WALLJACK=#GetJackNumbers.WALLJACKID#&MANUFACTURERID=#GetManufacturers.VENDORID#&WARRANTYVENDORID=#GetWarrantyVendors.VENDORID#&CUSTOMERID=#GetCustomers.CUSTOMERID#" method="POST">
			<TD align="left" width="50%" valign="top">
               	<INPUT type="image" src="/images/buttonEditRmVendorCust.jpg" value="Change Room/Manuf/Cust" alt="HW Change Room, Manufacturer, Warranty Vendor and Customer" tabindex="55" />
               </TD>
</CFFORM>
          </tr>
     </table>
     </FIELDSET>
     <BR />
     <TABLE width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/inventorymultiplemodloop.cfm?PROCESS=MODIFYLOOP" method="POST">
			<TD align="left" valign="bottom" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="56" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>