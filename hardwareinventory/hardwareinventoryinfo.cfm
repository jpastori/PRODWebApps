<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hardwareinventoryinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Add/Modify/Delete Information in IDT Hardware Inventory --->
<!-- Last modified by John R. Pastori on 10/03/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm">
<CFSET CONTENT_UPDATED = "October 03, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Single Record Info in IDT Hardware Inventory</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Existing Record Info in IDT Hardware Inventory</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JAVASCRIPT">
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {

		if (document.HARDWAREINVENTORY.BARCODENUMBER.value.length == 14) {
			var barcode = document.HARDWAREINVENTORY.BARCODENUMBER.value;
			document.HARDWAREINVENTORY.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if (document.HARDWAREINVENTORY.BARCODENUMBER.value == "3065000" || document.HARDWAREINVENTORY.BARCODENUMBER.value.length != 17
		 || !document.HARDWAREINVENTORY.BARCODENUMBER.value.match(/^\d{1} \d{4} \d{5} \d{4}/)){
		 	alertuser ("The BarCode must be 17 characters in the format d dddd ddddd dddd and can only contain digits and spaces!");
			document.HARDWAREINVENTORY.BARCODENUMBER.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.selectedIndex == "0" && document.HARDWAREINVENTORY.TYPENAME != null
		 && (document.HARDWAREINVENTORY.TYPENAME.value == "" || document.HARDWAREINVENTORY.TYPENAME.value == " ")) {
			alertuser (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.name +  ",  An Equipment Type MUST be selected!");
			document.HARDWAREINVENTORY.EQUIPMENTTYPEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.selectedIndex > "0" && document.HARDWAREINVENTORY.TYPENAME != null
		 && !document.HARDWAREINVENTORY.TYPENAME.value == "") {
			alertuser (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.name +  ",  Only one Equipment Type can be entered!");
			document.HARDWAREINVENTORY.EQUIPMENTTYPEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.DESCRIPTIONID.selectedIndex == "0" && document.HARDWAREINVENTORY.DESCRIPTIONNAME != null
		 && (document.HARDWAREINVENTORY.DESCRIPTIONNAME.value == "" || document.HARDWAREINVENTORY.DESCRIPTIONNAME.value == " ")) {
			alertuser (document.HARDWAREINVENTORY.DESCRIPTIONID.name +  ",  An Equipment Description MUST be selected!");
			document.HARDWAREINVENTORY.DESCRIPTIONID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.DESCRIPTIONID.selectedIndex > "0" && document.HARDWAREINVENTORY.DESCRIPTIONNAME != null
		 && !document.HARDWAREINVENTORY.DESCRIPTIONNAME.value == "") {
			alertuser (document.HARDWAREINVENTORY.DESCRIPTIONID.name +  ",  Only one Equipment Description can be entered!");
			document.HARDWAREINVENTORY.DESCRIPTIONID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNAMEID.selectedIndex == "0" && document.HARDWAREINVENTORY.MODELNAME != null
		 && (document.HARDWAREINVENTORY.MODELNAME.value == "" || document.HARDWAREINVENTORY.MODELNAME.value == " ")) {
			alertuser (document.HARDWAREINVENTORY.MODELNAMEID.name +  ",  A Model Name MUST be selected!");
			document.HARDWAREINVENTORY.MODELNAMEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNAMEID.selectedIndex > "0" && document.HARDWAREINVENTORY.MODELNAME != null
		 && !document.HARDWAREINVENTORY.MODELNAME.value == "") {
			alertuser (document.HARDWAREINVENTORY.MODELNAMEID.name +  ",  Only one Model Name can be entered!");
			document.HARDWAREINVENTORY.MODELNAMEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNUMBERID.selectedIndex == "0" && document.HARDWAREINVENTORY.MODELNUMBER != null
		 && (document.HARDWAREINVENTORY.MODELNUMBER.value == "" || document.HARDWAREINVENTORY.MODELNUMBER.value == " ")) {
			alertuser (document.HARDWAREINVENTORY.MODELNUMBERID.name +  ",  A Model Number MUST be selected!");
			document.HARDWAREINVENTORY.MODELNUMBERID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNUMBERID.selectedIndex > "0" && document.HARDWAREINVENTORY.MODELNUMBER != null
		 && !document.HARDWAREINVENTORY.MODELNUMBER.value == "") {
			alertuser (document.HARDWAREINVENTORY.MODELNUMBERID.name +  ",  Only one Model Number can be entered!");
			document.HARDWAREINVENTORY.MODELNUMBERID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.SPEEDNAMEID.selectedIndex > "0" && document.HARDWAREINVENTORY.SPEEDNAME != null
		 && !document.HARDWAREINVENTORY.SPEEDNAME.value == "") {
			alertuser (document.HARDWAREINVENTORY.SPEEDNAMEID.name +  ",  Only one Speed Name can be entered!");
			document.HARDWAREINVENTORY.SPEEDNAMEID.focus();
			return false;
		}

		if ((document.HARDWAREINVENTORY.SIZENAMEID1.selectedIndex > "0" && document.HARDWAREINVENTORY.SIZENAMEID2.selectedIndex > "0"
		   && document.HARDWAREINVENTORY.SIZENAMEID3.selectedIndex > "0" && document.HARDWAREINVENTORY.SIZENAMEID4.selectedIndex > "0")
		   && (document.HARDWAREINVENTORY.SIZENAME1.value != "" || document.HARDWAREINVENTORY.SIZENAME2.value != "" 
		   || document.HARDWAREINVENTORY.SIZENAME3.value != "")) {
			alertuser (document.HARDWAREINVENTORY.SIZENAMEID1.name +  ",  All 4 Size Name records have been entered! No more are allowed.");
			document.HARDWAREINVENTORY.SIZENAMEID1.focus();
			return false;
		}

		if ((document.HARDWAREINVENTORY.INTERFACENAMEID1.selectedIndex > "0" && document.HARDWAREINVENTORY.INTERFACENAMEID2.selectedIndex > "0"
		   && document.HARDWAREINVENTORY.INTERFACENAMEID3.selectedIndex > "0" && document.HARDWAREINVENTORY.INTERFACENAMEID4.selectedIndex > "0"
		   && document.HARDWAREINVENTORY.INTERFACENAMEID6.selectedIndex > "0" && document.HARDWAREINVENTORY.INTERFACENAMEID6.selectedIndex > "0")
		   && (document.HARDWAREINVENTORY.INTERFACENAME1.value != "" || document.HARDWAREINVENTORY.INTERFACENAME2.value != "" 
		   || document.HARDWAREINVENTORY.INTERFACENAME3.value != "")) {
			alertuser (document.HARDWAREINVENTORY.INTERFACENAMEID1.name +  ",  All 6 Interface Name records have been entered! No more are allowed.");
			document.HARDWAREINVENTORY.INTERFACENAMEID1.focus();
			return false;
		}

		if ((document.HARDWAREINVENTORY.PERIPHERALNAMEID1.selectedIndex > "0" && document.HARDWAREINVENTORY.PERIPHERALNAMEID2.selectedIndex > "0"
		   && document.HARDWAREINVENTORY.PERIPHERALNAMEID3.selectedIndex > "0" && document.HARDWAREINVENTORY.PERIPHERALNAMEID4.selectedIndex > "0"
		   && document.HARDWAREINVENTORY.PERIPHERALNAMEID6.selectedIndex > "0" && document.HARDWAREINVENTORY.PERIPHERALNAMEID6.selectedIndex > "0")
		   && (document.HARDWAREINVENTORY.PERIPHERALNAME1.value != "" || document.HARDWAREINVENTORY.PERIPHERALNAME2.value != "" 
		   || document.HARDWAREINVENTORY.PERIPHERALNAME3.value != "")) {
			alertuser (document.HARDWAREINVENTORY.PERIPHERALNAMEID1.name +  ",  All 6 Peripheral Name records have been entered! No more are allowed.");
			document.HARDWAREINVENTORY.PERIPHERALNAMEID1.focus();
			return false;
		}

		if ((document.HARDWAREINVENTORY.ATTACHEDTO1 != null && document.HARDWAREINVENTORY.ATTACHEDTO1.selectedIndex > "0" && document.HARDWAREINVENTORY.ATTACHEDTO2.selectedIndex > "0"
		   && document.HARDWAREINVENTORY.ATTACHEDTO3.selectedIndex > "0" && document.HARDWAREINVENTORY.ATTACHEDTO4.selectedIndex > "0"
		   && document.HARDWAREINVENTORY.ATTACHEDTO6.selectedIndex > "0" && document.HARDWAREINVENTORY.ATTACHEDTO6.selectedIndex > "0")
		   && (document.HARDWAREINVENTORY.ATTACHEDBARCODE1.value != "" || document.HARDWAREINVENTORY.ATTACHEDBARCODE2.value != "" 
		   || document.HARDWAREINVENTORY.ATTACHEDBARCODE3.value != "")) {
			alertuser (document.HARDWAREINVENTORY.ATTACHEDTO1.name +  ",  All 6 Attached-Barcode records have been entered! No more are allowed.");
			document.HARDWAREINVENTORY.ATTACHEDTO1.focus();
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

		if (document.HARDWAREINVENTORY.MODIFIEDBYID.selectedIndex == "0") {
			alertuser (document.HARDWAREINVENTORY.MODIFIEDBYID.name +  ",  A Modified By Name MUST be Selected!");
			document.HARDWAREINVENTORY.MODIFIEDBYID.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.HARDWAREID.selectedIndex == "0"  && document.LOOKUP.BARCODENUMBER.value == "3065000" 
		 && document.LOOKUP.STATEFOUNDNUMBER.value == ""     && document.LOOKUP.SERIALNUMBER.value == "" 
		 && document.LOOKUP.DIVISIONNUMBER.value == ""       && document.LOOKUP.IPADDRESS.value == "") {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.HARDWAREID.focus();
			return false;
		}

		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = LOOKUP.BARCODENUMBER.value;
			LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if ((!document.LOOKUP.BARCODENUMBER.value == "3065000" && !document.LOOKUP.BARCODENUMBER.value == "") && !document.LOOKUP.BARCODENUMBER.value.length == 17) {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  A 17 character Bar Code Number MUST be entered! Spaces are counted.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

		if (document.LOOKUP.HARDWAREID.selectedIndex > "0" && document.LOOKUP.BARCODENUMBER.value.length > 7) {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  BOTH a dropdown value AND  a 17 character Bar Code Number can NOT be entered! Choose one or the other.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}
	}

	function validateBarcodeDateFields() {
		if (document.HARDWAREINVENTORY.BARCODENUMBER.value.length != 17 || !document.HARDWAREINVENTORY.BARCODENUMBER.value.match(/^\d{1} \d{4} \d{5} \d{4}/)){
		 	alertuser ("The BarCode must be 17 characters in the format d dddd ddddd dddd and can only contain digits and spaces!");
			document.HARDWAREINVENTORY.BARCODENUMBER.focus();
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
	
	
	function setDelete() {
		document.HARDWAREINVENTORY.PROCESSHARDWAREINVENTORY.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPBARCODE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
<CFELSEIF URL.PROCESS EQ 'ADD'>
	<CFSET CURSORFIELD = "document.HARDWAREINVENTORY.STATEFOUNDNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.HARDWAREINVENTORY.BARCODENUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
***************************************************************************
* The following code determines how an inventory record will be selected. *
***************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<CFSET BARCODEEXISTS = "NO">
	<CFSET STATEFOUNDNUMBEREXISTS = "NO">
	<CFIF IsDefined('FORM.BARCODENUMBER') AND #FORM.BARCODENUMBER# NEQ "3 0650 00">
		<CFQUERY name="LookupHardwareBarCode" datasource="#application.type#HARDWARE">
			SELECT	HARDWAREID, BARCODENUMBER
			FROM		HARDWAREINVENTORY
			WHERE	BARCODENUMBER = <CFQUERYPARAM value="#FORM.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	BARCODENUMBER
		</CFQUERY>
		<CFIF #LookupHardwareBarCode.RecordCount# GT 0>
			<CFSET BARCODEEXISTS = "YES">
		</CFIF>
	</CFIF>

	<CFIF IsDefined('FORM.STATEFOUNDNUMBER') AND #FORM.STATEFOUNDNUMBER# NEQ "">
		<CFQUERY name="LookupStateFoundNumber" datasource="#application.type#HARDWARE">
			SELECT	HARDWAREID, BARCODENUMBER, STATEFOUNDNUMBER
			FROM		HARDWAREINVENTORY
			WHERE	STATEFOUNDNUMBER = <CFQUERYPARAM value="#FORM.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	BARCODENUMBER
		</CFQUERY>
		<CFIF #LookupStateFoundNumber.RecordCount# GT 0>
			<CFSET STATEFOUNDNUMBEREXISTS = "YES">
			<H4>State Found Number exists in Bar Code:  #LookupStateFoundNumber.BARCODENUMBER#
		</CFIF>
	</CFIF>

	<CFIF BARCODEEXISTS EQ "YES" AND STATEFOUNDNUMBEREXISTS EQ "YES">
		<CFSET URL.LOOKUPBARCODE = "FOUND">
		<CFSET URL.PROCESS = "MODIFYDELETE">
		<CFSET FORM.HARDWAREID = 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("The Bar Code and State Found Number already exist. Switching to Modify Screen.");
			--> 
		</SCRIPT>
	<CFELSEIF BARCODEEXISTS EQ "YES">
		<CFSET URL.LOOKUPBARCODE = "FOUND">
		<CFSET URL.PROCESS = "MODIFYDELETE">
		<CFSET FORM.HARDWAREID = 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("The Bar Code already exists.  Switching to Modify Screen.");
			--> 
		</SCRIPT>
	<CFELSEIF STATEFOUNDNUMBEREXISTS EQ "YES">
		<CFSET URL.LOOKUPBARCODE = "FOUND">
		<CFSET URL.PROCESS = "MODIFYDELETE">
		<SCRIPT language="JavaScript">
			<!-- 
				alert("The State Found Number already exists.  Switching to Modify Screen.");
			--> 
		</SCRIPT>
	</CFIF>
</CFIF>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<BR clear="left" />

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

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
	ORDER BY	SIZENAME
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

<CFQUERY name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
	SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
	FROM		ORGCODES
	ORDER BY	ORGCODE
</CFQUERY>

<!--- 
****************************************************************
* The following code is the ADD Process for Hardware Inventory *
****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<CFQUERY name="ListHardwareWarranty" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY
		ORDER BY	HARDWAREWARRANTYID
	</CFQUERY>

	<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	(CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID) AND
				((CUST.CUSTOMERID = 0) OR 
          		(CUST.ACTIVE = 'YES' AND
				DBS.DBSYSTEMNUMBER = 300 AND
				SL.SECURITYLEVELNUMBER >= 30))
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES">
		SELECT	LOCATIONID, LOCATIONNAME
		FROM		LOCATIONS
		WHERE	LOCATIONID =  <CFQUERYPARAM value="#FORM.EQUIPMENTLOCATIONID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="ListManufacturers" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#FORM.MANUFACTURERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</CFQUERY>

	<CFQUERY name="ListWarrantyVendors" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#FORM.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</CFQUERY>

	<CFQUERY name="ListWarrantyVendorContacts" datasource="#application.type#PURCHASING">
		SELECT	VENDORCONTACTID, VENDORID, CONTACTNAME, PHONENUMBER, FAXNUMBER, EMAILADDRESS
		FROM		VENDORCONTACTS
		WHERE	VENDORID = <CFQUERYPARAM value="#FORM.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORID
	</CFQUERY>

	<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		WHERE	(CURRENTFISCALYEAR = 'YES')
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, GROUPS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Single Record Info in IDT Hardware Inventory</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(HARDWAREID) AS MAX_ID
		FROM		HARDWAREINVENTORY
	</CFQUERY>
	<CFSET FORM.HARDWAREID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFSET FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
	<CFCOOKIE name="HARDWAREID" secure="NO" value="#FORM.HARDWAREID#">
	<CFQUERY name="AddHardwareInventoryID" datasource="#application.type#HARDWARE">
		INSERT INTO	HARDWAREINVENTORY (HARDWAREID, CREATIONDATE, BARCODENUMBER, DATECHECKED)
		VALUES		(#val(Cookie.HARDWAREID)#, TO_DATE('#FORM.CREATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
					'#FORM.BARCODENUMBER#', TO_DATE('#FORM.CREATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align= "CENTER">
				Hardware Inventory Key &nbsp; = &nbsp; #FORM.HARDWAREID# &nbsp;&nbsp;Created: &nbsp;&nbsp;#DateFormat(FORM.CREATIONDATE, "mm/dd/yyyy")#
			</TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm" method="POST">
			<TD align="left" width="50%">
				<INPUT type="hidden" name="PROCESSHARDWAREINVENTORY" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    <BR /><BR />
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	   
	<FIELDSET>
	<LEGEND>Equipment</LEGEND>     
<CFFORM name="HARDWAREINVENTORY" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm" method="POST" ENABLECAB="Yes">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH align="left" width="50%">Bar Code Number</TH>
			<TH align="left" width="50%"><LABEL for="STATEFOUNDNUMBER">State Found Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<INPUT type="hidden" name="BARCODENUMBER" value="#FORM.BARCODENUMBER#" />
				#FORM.BARCODENUMBER#
			</TD>
			<CFIF IsDefined('FORM.STATEFOUNDNUMBER')>
				<TD align="left" width="50%"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="#UCASE(FORM.STATEFOUNDNUMBER)#" align="LEFT" required="No" size="25" maxlength="50" tabindex="2"></TD>
			<CFELSE>
				<TD align="left" width="50%"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="2"></TD>
			</CFIF>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="SERIALNUMBER">Serial Number</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="DIVISIONNUMBER">Division Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="" align="LEFT" required="No" size="50" tabindex="4"></TD>
		</TR>	
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="EQUIPMENTTYPEID">*Equipment Type</LABEL></H4></TH>
			<TH align="left" width="50%"><H4><LABEL for="DESCRIPTIONID">*Description</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="EQUIPMENTTYPEID" id="EQUIPMENTTYPEID" size="1" query="ListEquipmentTypes" value="EQUIPTYPEID" display="EQUIPMENTTYPE" required="No" tabindex="5"></CFSELECT><BR />
				<CFINPUT type="Text" name="TYPENAME" id="EQUIPMENTTYPEID" value="" align="LEFT" required="No" size="50" tabindex="6">
			</TD>
			<TD align="left" width="50%">
				<CFSELECT name="DESCRIPTIONID" size="1"  id="DESCRIPTIONID" query="ListEquipmentDescriptions" value="EQUIPDESCRID" display="EQUIPMENTDESCRIPTION" required="No" tabindex="7"></CFSELECT><BR />
				<CFINPUT type="Text" name="DESCRIPTIONNAME" id="DESCRIPTIONID" value="" align="LEFT" required="No" size="50" tabindex="8">
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="MODELNAMEID">*Model</LABEL></H4></TH>
			<TH align="left" width="50%"><H4><LABEL for="MODELNUMBERID">*Model Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="MODELNAMEID" id="MODELNAMEID" size="1" query="ListModelNames" value="MODELNAMEID" display="MODELNAME" required="No" tabindex="9"></CFSELECT><BR />
				<CFINPUT type="Text" name="MODELNAME" id="MODELNAMEID" value="" align="LEFT" required="No" size="50" tabindex="10">
			</TD>
			<TD align="left" width="50%">
				<CFSELECT name="MODELNUMBERID" id="MODELNUMBERID" size="1" query="ListModelNumbers" value="MODELNUMBERID" display="MODELNUMBER" required="No" tabindex="11"></CFSELECT><BR />
				<CFINPUT type="Text" name="MODELNUMBER" id="MODELNUMBERID" value="" align="LEFT" required="No" size="50" tabindex="12">
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="SPEEDNAMEID">Speed</LABEL></TH>
			<TH align="left" width="50%">Size</TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<CFSELECT name="SPEEDNAMEID" id="SPEEDNAMEID" size="1" query="ListSpeedNames" value="SPEEDNAMEID" display="SPEEDNAME" required="No" tabindex="13"></CFSELECT><BR />
				<CFINPUT type="Text" name="SPEEDNAME" id="SPEEDNAMEID" value="" align="LEFT" required="No" size="50" tabindex="14">
			</TD>
			<TD align="left" width="50%" valign="TOP">
				<CFLOOP index="Counter" from=1 to=6>
					<CFSET TAB = #Counter# + 14>
					<LABEL for="SIZENAMEID#Counter#" class="LABEL_hidden">Size #Counter#</LABEL>
					<CFSELECT name="SIZENAMEID#Counter#" id="SIZENAMEID#Counter#" size="1" query="ListSizeNames" value="SIZENAMEID" display="SIZENAME" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
				<LABEL for="SIZENAME1" class="LABEL_hidden">Size Name 1</LABEL>
				<CFINPUT type="Text" name="SIZENAME1" id="SIZENAMEID1" value="" align="LEFT" required="No" size="50" tabindex="21"><BR />
				<LABEL for="SIZENAME2" class="LABEL_hidden">Size Name 2</LABEL>
				<CFINPUT type="Text" name="SIZENAME2" id="SIZENAMEID2" value="" align="LEFT" required="No" size="50" tabindex="22"><BR />
				<LABEL for="SIZENAME3" class="LABEL_hidden">Size Name 3</LABEL>
				<CFINPUT type="Text" name="SIZENAME3" id="SIZENAMEID3" value="" align="LEFT" required="No" size="50" tabindex="23"><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Interfaces</TH>
			<TH align="left" width="50%">Peripherals</TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<CFLOOP index="Counter" from=1 to=6>
					<CFSET TAB = #Counter# + 23>
					<LABEL for="INTERFACENAMEID#Counter#" class="LABEL_hidden">Computer Interface #Counter#</LABEL>
					<CFSELECT name="INTERFACENAMEID#Counter#" id="INTERFACENAMEID#Counter#" size="1" query="ListInterfaces" value="INTERFACENAMEID" display="INTERFACENAME" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
				<LABEL for="INTERFACENAME1" class="LABEL_hidden">Computer Interface Name 1</LABEL>
				<CFINPUT type="Text" name="INTERFACENAME1" id="INTERFACENAMEID1" value="" align="LEFT" required="No" size="50" tabindex="30"><BR />
				<LABEL for="INTERFACENAME2" class="LABEL_hidden">Computer Interface Name 2</LABEL>
				<CFINPUT type="Text" name="INTERFACENAME2" id="INTERFACENAMEID2" value="" align="LEFT" required="No" size="50" tabindex="31"><BR />
				<LABEL for="INTERFACENAME3" class="LABEL_hidden">Computer Interface Name 3</LABEL>
				<CFINPUT type="Text" name="INTERFACENAME3" id="INTERFACENAMEID3" value="" align="LEFT" required="No" size="50" tabindex="32"><BR />
			</TD>
			<TD align="left" width="50%" valign="TOP">
				<CFLOOP index="Counter" from=1 to=6>
					<CFSET TAB = #Counter# + 32>
					<LABEL for="PERIPHERALNAMEID#Counter#" class="LABEL_hidden">Computer Peripheral #Counter#</LABEL>
					<CFSELECT name="PERIPHERALNAMEID#Counter#" id="PERIPHERALNAMEID#Counter#" size="1" query="ListPeripherals" value="PERIPHERALNAMEID" display="PERIPHERALNAME" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
				<LABEL for="PERIPHERALNAME1" class="LABEL_hidden">Computer Peripheral Name 1</LABEL>
				<CFINPUT type="Text" name="PERIPHERALNAME1" id="PERIPHERALNAME1" value="" align="LEFT" required="No" size="50" tabindex="39"><BR />
				<LABEL for="PERIPHERALNAME2" class="LABEL_hidden">Computer Peripheral Name 2</LABEL>
				<CFINPUT type="Text" name="PERIPHERALNAME2" id="PERIPHERALNAME2" value="" align="LEFT" required="No" size="50" tabindex="40"><BR />
				<LABEL for="PERIPHERALNAME3" class="LABEL_hidden">Computer Peripheral Name 3</LABEL>
				<CFINPUT type="Text" name="PERIPHERALNAME3" id="PERIPHERALNAME3" value="" align="LEFT" required="No" size="50" tabindex="41"><BR />
			</TD>
		</TR>
          <TR>
			<TH align="left" width="50%">Location</TH>
			<TH align="left" width="50%"><LABEL for="CLUSTERNAME">Cluster</LABEL></TH>
		</TR>
		<TR>
			<INPUT type="hidden" name="EQUIPMENTLOCATIONID" value="#ListRoomNumbers.LOCATIONID#" />
			<TD align="left" width="50%">#ListRoomNumbers.LOCATIONNAME#</TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="CLUSTERNAME" id="CLUSTERNAME" value="" align="LEFT" required="No" size="50" tabindex="42"></TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Network</LEGEND>
	<TABLE width="100%" border="0">
           <TR>
			<TH align="left" width="50%"><LABEL for="MACHINENAME">Machine</LABEL></TH>
			<TH align="left" width="50%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="MACHINENAME" id="MACHINENAME" value="" align="LEFT" required="No" size="50" tabindex="43"></TD>
			<TD align="left" width="50%">&nbsp;&nbsp;</TD>
		</TR>
    	<TR>
			<TH align="left" width="50%"><LABEL for="MACADDRESS">MAC Address</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="IPADDRESS">IP Address</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="MACADDRESS" id="MACADDRESS" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="44"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="" align="LEFT" required="No" size="15" maxlength="15" tabindex="45"></TD>

		</TR>
          <TR>
			<TH align="left" width="50%"><LABEL for="AIRPORTID">Airport/WIFI ID</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="BLUETOOTHID">Bluetooth ID</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="AIRPORTID" id="AIRPORTID" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="46"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="BLUETOOTHID" id="BLUETOOTHID" value="" align="LEFT" required="No" size="15" maxlength="15" tabindex="47"></TD>
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
				<CFINPUT type="Text" name="REQUISITIONNUMBER" id="REQUISITIONNUMBER" value="" align="LEFT" required="No" size="20" tabindex="48">
			</TD> 
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="PURCHASEORDERNUMBER" id="PURCHASEORDERNUMBER" value="" align="LEFT" required="No" size="20" tabindex="49">
			</TD>
		</TR>
          <TR>
			<TH align="left" width="50%">Fiscal Year</TH>
			<TH align="left" width="50%"><LABEL for="OWNINGORGID">Owning Org. Code</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<INPUT type="hidden" name="FISCALYEARID" value="#ListCurrentFiscalYear.FISCALYEARID#" />
				#ListCurrentFiscalYear.FISCALYEAR_4DIGIT#
			</TD>
               <TD align="left" width="50%" valign="TOP">
				<CFSELECT name="OWNINGORGID" id="OWNINGORGID" size="1" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" selected="2" required="No" tabindex="50"></CFSELECT>
			</TD>
		</TR>
          
          <TR>
			<TH align="left" width="50%"><LABEL for="DATERECEIVED">Date Received</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="WARRANTYEXPIRATIONDATE">Warr. Expiration Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<CFINPUT type="Text" name="DATERECEIVED" id="DATERECEIVED" value="" align="LEFT" required="No" size="15" tabindex="51">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'HARDWAREINVENTORY','controlname': 'DATERECEIVED'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
			<TD align="left" width="50%" valign="TOP">
				<CFINPUT type="Text" name="WARRANTYEXPIRATIONDATE" id="WARRANTYEXPIRATIONDATE" value="" align="LEFT" required="NO" size="15" tabindex="52">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'HARDWAREINVENTORY','controlname': 'WARRANTYEXPIRATIONDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Manufacturer</TH>
			<TH align="left" width="50%"><LABEL for="DELLEXPRESSSERVICE">DELL Express Service</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<INPUT type="hidden" name="MANUFACTURERID" value="#ListManufacturers.VENDORID#" />
				#ListManufacturers.VENDORNAME#
			</TD>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="DELLEXPRESSSERVICE" id="DELLEXPRESSSERVICE" value="" align="LEFT" required="No" size="50" tabindex="53">
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Warr. Vendor</TH>
			<TH align="left" width="50%">Warr. Contact & Phone</TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<INPUT type="hidden" name="WARRANTYVENDORID" value="#ListWarrantyVendors.VENDORID#" />
				<CFIF ListWarrantyVendors.VENDORID GT 0>
					#ListWarrantyVendors.VENDORNAME#
				<CFELSE>
					&nbsp;&nbsp;
				</CFIF>
			</TD>
			<TD align="left" width="50%">
			<CFLOOP query = "ListWarrantyVendorContacts">
				<CFIF ListWarrantyVendors.VENDORID GT 0>
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
			<TD align="left" width="50%" valign="TOP">
               	<CFINPUT type="Text" name="WARRANTYRESTRICTIONS" id="WARRANTYRESTRICTIONS" value="" align="LEFT" required="NO" size="50" maxlength="600" tabindex="54">
               </TD>
			<TD align="left" width="50%" valign="TOP">
               	<CFTEXTAREA name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="55"></CFTEXTAREA>
               </TD>
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
				<INPUT type="hidden" name="CUSTOMERID" value="#ListCustomers.CUSTOMERID#" />
				#ListCustomers.FULLNAME#
			</TD>
			<TD align="left" width="50%">
				#ListCustomers.UNITNAME#&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;
				#ListCustomers.GROUPNAME#
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Phone</TH>
			<TH align="left" width="50%">Location</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">#ListCustomers.CAMPUSPHONE#</TD>
			<TD align="left" width="50%">#ListCustomers.ROOMNUMBER#</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="COMMENTS">Comments</LABEL></TH>
               <TH align="left" width="50%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
               	<CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="PHYSICAL" required="No" rows="5" cols="60" tabindex="56"></CFTEXTAREA>
               </TD>
               <TD align="left" width="50%">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
			<TH align="left" width="50%">Date Checked (Creation Date)</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="57"></CFSELECT>
			</TD>
			<TD align="left" width="50%">
				#DateFormat(FORM.CREATIONDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
    	<LEGEND>Record Processing</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSHARDWAREINVENTORY" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="58" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>
	</FIELDSET>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSHARDWAREINVENTORY" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="59" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
	
<CFELSE>

<!--- 
********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Hardware Inventory. *
********************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Lookup for Modify/Delete Existing Record Info in IDT Hardware Inventory</H1></TH>
			</TR>
		</TABLE>
	
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H2>
					Enter complete values to Lookup a specific record. <BR />
					More than one field can be selected except where text and dropdown represent the same field.
				</H2></TH>
			</TR>
		</TABLE>

		<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER,
					HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
					HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, 
					HI.MACADDRESS, HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE,
					HI.DESCRIPTIONID, HI.MODELNAMEID, HI.MODELNUMBERID, 
					HI.SPEEDNAMEID, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE,
					HI.WARRANTYVENDORID, HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER,
					HI.DATERECEIVED, HI.FISCALYEARID, HI.CUSTOMERID, HI.COMMENTS,
					HI.OWNINGORGID, HI.MODIFIEDBYID, HI.DATECHECKED, HI.IPADDRESS,
					CUST.FULLNAME || ' - ' || ET.EQUIPMENTTYPE ||' - ' || HI.DIVISIONNUMBER ||' - ' || HI.BARCODENUMBER AS LOOKUPKEY
			FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET
			WHERE	HI.CUSTOMERID = CUST.CUSTOMERID AND
					HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<BR />
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" width="50%">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPBARCODE=FOUND" method="POST">
			<TR>
				<TH align="left" width="50%"><LABEL for="HARDWAREID">Customer, Type, Division Number and Bar Code Number</LABEL></TH>
			</TR>
			<TR>
				<TD>
					<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" width="50%"><LABEL for="BARCODENUMBER">Or Bar Code Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" width="50%"><CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="17" maxlength="17" tabindex="3"></TD>
			</TR>
			<TR>
				<TH align="left" width="50%"><LABEL for="STATEFOUNDNUMBER">Or State Found Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" width="50%"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="18" tabindex="4"></TD>
			</TR>
			<TR>
				<TH align="left" width="50%"><LABEL for="SERIALNUMBER">Or Serial Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" width="50%"><CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="18" tabindex="5"></TD>
			</TR>
			<TR>
				<TH align="left" width="50%"><LABEL for="DIVISIONNUMBER">Or Division Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" width="50%"><CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="" align="LEFT" required="No" size="18" tabindex="6"></TD>
			</TR>
			<TR>
				<TH align="left" width="50%"><LABEL for="IPADDRESS">Or IP Address</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" width="50%"><CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="" align="LEFT" required="No" size="15" tabindex="7"></TD>
			</TR>
			<TR>
				<TD align="left" width="50%">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="8" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" width="50%">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="9" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	<CFELSE>

<!--- 
*********************************************************************************
* The following code is the Modify and Delete Processes for Hardware Inventory. *
*********************************************************************************
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
		</CFIF>

		<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE">
			SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
					HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, HI.MACADDRESS, HI.AIRPORTID, HI.BLUETOOTHID, HI.EQUIPMENTTYPEID,
					HI.DESCRIPTIONID, HI.MODELNAMEID, HI.MODELNUMBERID, HI.SPEEDNAMEID, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE,
					HI.WARRANTYVENDORID, HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID,
					HI.CUSTOMERID, HI.COMMENTS, HI.OWNINGORGID, HI.MODIFIEDBYID, HI.DATECHECKED, HI.IPADDRESS
			FROM		HARDWAREINVENTORY HI
			WHERE	HI.HARDWAREID > 0 AND
			<CFIF #FORM.HARDWAREID# GT 0>
					HI.HARDWAREID = <CFQUERYPARAM value="#FORM.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
			<CFELSEIF #FORM.BARCODENUMBER# NEQ "3065000" AND #FORM.BARCODENUMBER# NEQ "">
					HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
			<CFIF IsDefined('FORM.STATEFOUNDNUMBER') AND #FORM.STATEFOUNDNUMBER# NEQ "">
					HI.STATEFOUNDNUMBER = UPPER('#FORM.STATEFOUNDNUMBER#') AND
			</CFIF>
			<CFIF IsDefined('FORM.SERIALNUMBER') AND #FORM.SERIALNUMBER# NEQ "">
					HI.SERIALNUMBER = UPPER('#FORM.SERIALNUMBER#') AND
			</CFIF>
			<CFIF IsDefined('FORM.DIVISIONNUMBER') AND #FORM.DIVISIONNUMBER# NEQ "">
					HI.DIVISIONNUMBER = UPPER('#FORM.DIVISIONNUMBER#') AND
			</CFIF>
			<CFIF IsDefined('FORM.IPADDRESS') AND #FORM.IPADDRESS# NEQ "">
					HI.IPADDRESS = <CFQUERYPARAM value="#FORM.IPADDRESS#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
					HI.MODIFIEDBYID > 0
			ORDER BY	HI.HARDWAREID
		</CFQUERY>

		<CFIF #GetHardware.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Inventory Record Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm?PROCESS=MODIFYDELETE" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="GetRoomNumbers" datasource="#application.type#FACILITIES">
			SELECT	LOCATIONID, LOCATIONNAME
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

		<CFQUERY name="GetWarrantyVendors" datasource="#application.type#PURCHASING">
			SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
			FROM		VENDORS
			WHERE	VENDORID = <CFQUERYPARAM value="#GetHardware.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	VENDORNAME
		</CFQUERY>

		<CFQUERY name="GetWarrantyVendorContacts" datasource="#application.type#PURCHASING">
			SELECT	VENDORCONTACTID, VENDORID, CONTACTNAME, PHONENUMBER, FAXNUMBER, EMAILADDRESS
			FROM		VENDORCONTACTS
			WHERE	VENDORID = <CFQUERYPARAM value="#GetHardware.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	VENDORID
		</CFQUERY>

		<CFQUERY name="GetCustomers" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUST.CAMPUSPHONE,
					LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
			FROM		CUSTOMERS CUST, UNITS, GROUPS, FACILITIESMGR.LOCATIONS LOC
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetHardware.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CUST.UNITID = UNITS.UNITID AND
					UNITS.GROUPID = GROUPS.GROUPID AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
					CUST.ACTIVE = 'YES'
			ORDER BY	LASTNAME
		</CFQUERY>

		<CFQUERY name="GetHardwareSizes" datasource="#application.type#HARDWARE" blockfactor="6">
			SELECT	HARDWARESIZESID, BARCODENUMBER, HARDWARESIZENAMEID
			FROM		HARDWARESIZES
			WHERE	BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
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

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Modify/Delete Existing Record Info in IDT Hardware Inventory</H1></TH>
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
	   
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" width="50%">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                         <BR /><BR />
				</TD>
</CFFORM>
<CFFORM action="/#application.type#apps/hardwareinventory/lookuproommanufcustinfo.cfm?PROCESS=#URL.PROCESS#&ROOMMANUFCUSTCHANGED=YES&LOCATIONID=#GetRoomNumbers.LOCATIONID#&WALLJACK=#GetJackNumbers.WALLJACKID#&MANUFACTURERID=#GetManufacturers.VENDORID#&WARRANTYVENDORID=#GetWarrantyVendors.VENDORID#&CUSTOMERID=#GetCustomers.CUSTOMERID#" method="POST">
				<TD align="left" width="50%" valign="top">
                    	<INPUT type="image" src="/images/buttonEditRmVendorCust.jpg" value="Change Room/Manuf/Cust" alt="HW Change Room, Manufacturer, Warranty Vendor and Customer" tabindex="2" />
                    </TD>
</CFFORM>
			</TR>
		</TABLE>
	   
		<FIELDSET>
		<LEGEND>Equipment</LEGEND>   
		<TABLE width="100%" align="LEFT">
<CFFORM name="HARDWAREINVENTORY" onsubmit="return validateBarcodeDateFields();" action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left" width="50%"><H4><LABEL for="BARCODENUMBER">*Bar Code Number</LABEL></H4></TH>
				<TH align="left" width="50%"><LABEL for="STATEFOUNDNUMBER">State Found Number</LABEL></TH>
			</TR>
			<TR>
				<CFCOOKIE name="HARDWAREID" secure="NO" value="#GetHardware.HARDWAREID#">
				<TD align="left" width="50%"><CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="#GetHardware.BARCODENUMBER#" align="LEFT" required="No" size="17" maxlength="17" tabindex="3"></TD>
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
				<TH align="left" width="50%"><LABEL for="EQUIPMENTTYPEID">Equipment Type</LABEL></TH>
				<TH align="left" width="50%"><LABEL for="DESCRIPTIONID">Description</LABEL></TH>
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
				<TH align="left" width="50%"><LABEL for="MODELNAMEID">Model</LABEL></TH>
				<TH align="left" width="50%"><LABEL for="MODELNUMBERID">Model Number</LABEL></TH>
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
				<TD align="left" width="50%" valign="TOP">
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
				<TD align="left" width="50%"><CFINPUT type="Text" name="MACADDRESS" id="MACADDRESS" value="#GetHardware.MACADDRESS#" align="LEFT" required="No" size="25" maxlength="50" tabindex="38"></TD>
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
				<TD>
					<CFINPUT type="Text" name="REQUISITIONNUMBER" id="REQUISITIONNUMBER" value="#GetHardware.REQUISITIONNUMBER#" align="LEFT" required="No" size="20" tabindex="42">
				</TD>
				<TD>
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
				<TD align="left" width="50%" valign="TOP">
					<CFSELECT name="OWNINGORGID" size="1" id="OWNINGORGID" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" selected="#GetHardware.OWNINGORGID#" required="No" tabindex="45"></CFSELECT>
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
					<CFINPUT type="Text" name="WARRANTYEXPIRATIONDATE" id="WARRANTYEXPIRATIONDATE" value="#DateFormat(GetHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#" align="LEFT" required="NO" size="50" tabindex="47">
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
				<TD align="left" width="50%" valign="TOP"><CFTEXTAREA name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" wrap="PHYSICAL" required="No" rows="5" cols="60" tabindex="50">#GetHardwareWarranty.WARRANTYCOMMENTS#</CFTEXTAREA></TD>
			<CFELSE>
				<TD align="left" width="50%" valign="TOP">
					<INPUT type="hidden" name="HARDWAREWARRANTYID" value=0 />
					<CFINPUT type="Text" name="WARRANTYRESTRICTIONS" id="WARRANTYRESTRICTIONS" value="" align="LEFT" required="NO" size="50" maxlength="600" tabindex="49">
				</TD>
				<TD align="left" width="50%" valign="TOP"><CFTEXTAREA name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" wrap="PHYSICAL" required="No" rows="5" cols="60" tabindex="50"></CFTEXTAREA></TD>
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
				<TD align="left" width="50%">
                    	<INPUT type="hidden" name="PROCESSHARDWAREINVENTORY" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="53" /><BR /><BR /><BR />
			<CFIF #Client.DeleteFlag# EQ "Yes">
					<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="54" /><BR /><BR />
			</CFIF>
				</TD>
</CFFORM>

<CFFORM action="/#application.type#apps/hardwareinventory/lookuproommanufcustinfo.cfm?PROCESS=#URL.PROCESS#&ROOMMANUFCUSTCHANGED=YES&LOCATIONID=#GetRoomNumbers.LOCATIONID#&WALLJACK=#GetJackNumbers.WALLJACKID#&MANUFACTURERID=#GetManufacturers.VENDORID#&WARRANTYVENDORID=#GetWarrantyVendors.VENDORID#&CUSTOMERID=#GetCustomers.CUSTOMERID#" method="POST">
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
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" width="50%" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="56" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>