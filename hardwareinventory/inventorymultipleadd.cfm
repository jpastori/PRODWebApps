<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventorymultipleadd.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Multiple Record Add to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 07/08/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventorymultipleadd.cfm">
<CFSET CONTENT_UPDATED = "July 08, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Multiple Record Add to IDT Hardware Inventory</TITLE>
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

		if (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.selectedIndex == "0" && (document.HARDWAREINVENTORY.TYPENAME.value == "" 
		 || document.HARDWAREINVENTORY.TYPENAME.value == " ")) {
			alertuser (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.name +  ",  An Equipment Type MUST be selected!");
			document.HARDWAREINVENTORY.EQUIPMENTTYPEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.selectedIndex > "0" && !document.HARDWAREINVENTORY.TYPENAME.value == "") {
			alertuser (document.HARDWAREINVENTORY.EQUIPMENTTYPEID.name +  ",  Only one Equipment Type can be entered!");
			document.HARDWAREINVENTORY.EQUIPMENTTYPEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.DESCRIPTIONID.selectedIndex == "0" && (document.HARDWAREINVENTORY.DESCRIPTIONNAME.value == ""
		 || document.HARDWAREINVENTORY.DESCRIPTIONNAME.value == " ")) {
			alertuser (document.HARDWAREINVENTORY.DESCRIPTIONID.name +  ",  An Equipment Description MUST be selected!");
			document.HARDWAREINVENTORY.DESCRIPTIONID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.DESCRIPTIONID.selectedIndex > "0" && !document.HARDWAREINVENTORY.DESCRIPTIONNAME.value == "") {
			alertuser (document.HARDWAREINVENTORY.DESCRIPTIONID.name +  ",  Only one Equipment Description can be entered!");
			document.HARDWAREINVENTORY.DESCRIPTIONID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNAMEID.selectedIndex == "0" && (document.HARDWAREINVENTORY.MODELNAME.value == ""
		 || document.HARDWAREINVENTORY.MODELNAME.value == " ")) {
			alertuser (document.HARDWAREINVENTORY.MODELNAMEID.name +  ",  A Model Name MUST be selected!");
			document.HARDWAREINVENTORY.MODELNAMEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNAMEID.selectedIndex > "0" && !document.HARDWAREINVENTORY.MODELNAME.value == "") {
			alertuser (document.HARDWAREINVENTORY.MODELNAMEID.name +  ",  Only one Model Name can be entered!");
			document.HARDWAREINVENTORY.MODELNAMEID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNUMBERID.selectedIndex == "0" && (document.HARDWAREINVENTORY.MODELNUMBER.value == ""
		 || document.HARDWAREINVENTORY.MODELNUMBER.value == " ")) {
			alertuser (document.HARDWAREINVENTORY.MODELNUMBERID.name +  ",  A Model Number MUST be selected!");
			document.HARDWAREINVENTORY.MODELNUMBERID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.MODELNUMBERID.selectedIndex > "0" && !document.HARDWAREINVENTORY.MODELNUMBER.value == "") {
			alertuser (document.HARDWAREINVENTORY.MODELNUMBERID.name +  ",  Only one Model Number can be entered!");
			document.HARDWAREINVENTORY.MODELNUMBERID.focus();
			return false;
		}

		if (document.HARDWAREINVENTORY.SPEEDNAMEID.selectedIndex > "0" && !document.HARDWAREINVENTORY.SPEEDNAME.value == "") {
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

		if ((document.HARDWAREINVENTORY.ATTACHEDTO1.selectedIndex > "0" && document.HARDWAREINVENTORY.ATTACHEDTO2.selectedIndex > "0"
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
			alertuser (document.HARDWAREINVENTORY.MODIFIEDBYID.name +  ",  A Modfied By Name MUST be Selected!");
			document.HARDWAREINVENTORY.MODIFIEDBYID.focus();
			return false;
		}
	}


	function validateLookupField() {

		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = document.LOOKUP.BARCODENUMBER.value;
			document.LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if (document.LOOKUP.BARCODENUMBER.value.length != 17) {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  A 17 character Bar Code Number MUST be entered! Spaces are counted.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}
	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF URL.PROCESS EQ "NEWADD">
	<CFSET session.RecordAddsStructure = StructCopy(session.DefaultRecordAddsStructure)>
	<CFSET URL.PROCESS = "REQUESTBARCODE">
</CFIF>

<CFIF URL.PROCESS EQ "REQUESTBARCODE">
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.HARDWAREINVENTORY.STATEFOUNDNUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
**********************************************************************************************
* The following code is the Lookup Screen for Multiple Record Add to IDT Hardware Inventory. *
**********************************************************************************************
 --->

<CFIF URL.PROCESS EQ "REQUESTBARCODE">

	<CFINCLUDE template="/include/coldfusion/formheader.cfm">

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<TH align="center"><H1>Add Preliminary Info in IDT Hardware Inventory - Multiple Record</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TD align="center"><H4>*Red fields marked with asterisks are required!</H4></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left" width="50%">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/hardwareinventory/inventorymultipleadd.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="BARCODENUMBER">*New Bar Code Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="2"></TD>
		</TR>
		<TR>
		<TH align="left" width="50%"><LABEL for="STATEFOUNDNUMBER">New State Found Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left" width="50%">
               	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
			</TD>
          </TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left" width="50%">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

<CFIF URL.PROCESS EQ "LOOKUP">
	<CFSET BARCODEEXISTS = "NO">
	<CFSET STATEFOUNDNUMBEREXISTS = "NO">
	<CFQUERY name="LookupHardwareBarCode" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREID, BARCODENUMBER
		FROM		HARDWAREINVENTORY
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#FORM.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	<CFIF #LookupHardwareBarCode.RecordCount# GT 0>
		<CFSET BARCODEEXISTS = "YES">
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
		<SCRIPT language="JavaScript">
			<!-- 
				alert("The Bar Code and State Found Number already exist.   Enter a New Bar Code and State Found Number.");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultipleadd.cfm?PROCESS=REQUESTBARCODE" />
	<CFELSEIF BARCODEEXISTS EQ "YES">
		<SCRIPT language="JavaScript">
			<!-- 
				alert("The Bar Code already exists. Enter a New Bar Code");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultipleadd.cfm?PROCESS=REQUESTBARCODE" />
	<CFELSEIF STATEFOUNDNUMBEREXISTS EQ "YES">
		<SCRIPT language="JavaScript">
			<!-- 
				alert("The State Found Number already exists.   Enter a New State Found Number.");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultipleadd.cfm?PROCESS=REQUESTBARCODE" />
	<CFELSE>
		<CFSET URL.PROCESS = "REQUESTADD">
	</CFIF>
</CFIF>


<!--- 
*********************************************************************************
* The following code is the Multiple Record Add Process for Hardware Inventory. *
*********************************************************************************
 --->

<CFIF URL.PROCESS EQ "REQUESTADD">
	<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
				HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, HI.MACADDRESS, HI.EQUIPMENTTYPEID, HI.DESCRIPTIONID, 
				HI.MODELNAMEID, HI.MODELNUMBERID, HI.SPEEDNAMEID, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, HI.WARRANTYVENDORID,
				HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID, HI.CUSTOMERID, HI.COMMENTS,
				HI.OWNINGORGID, HI.MODIFIEDBYID, HI.DATECHECKED, HI.IPADDRESS,
				CUST.FULLNAME || ' - ' || HI.BARCODENUMBER AS LOOKUPKEY
		FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	HI.CUSTOMERID = CUST.CUSTOMERID
		ORDER BY	LOOKUPKEY
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

	<CFQUERY name="ListHardwareWarranty" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY
		ORDER BY	HARDWAREWARRANTYID
	</CFQUERY>

	<CFQUERY name="ListHardwareAttachedTo" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HARDWAREINVENTORY.HARDWAREID, HARDWAREINVENTORY.BARCODENUMBER,
				EQUIPMENTTYPE.EQUIPMENTTYPE || ' - ' || HARDWAREINVENTORY.BARCODENUMBER AS ATTACHEDHARDWARE
		FROM		HARDWAREINVENTORY, EQUIPMENTTYPE
		WHERE	HARDWAREINVENTORY.EQUIPMENTTYPEID = EQUIPTYPEID
		ORDER BY	ATTACHEDHARDWARE
	</CFQUERY>

	<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		WHERE	(CURRENTFISCALYEAR = 'YES')
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 300 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 20
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER, LOCATIONNAME
		FROM		LOCATIONS
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="ListManufacturers" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		ORDER BY	VENDORNAME
	</CFQUERY>

	<CFQUERY name="ListWarrantyVendors" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		ORDER BY	VENDORNAME
	</CFQUERY>

	<CFQUERY name="ListWarrantyVendorContacts" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VENDORCONTACTID, VENDORID, CONTACTNAME, PHONENUMBER, FAXNUMBER, EMAILADDRESS
		FROM		VENDORCONTACTS
		WHERE	VENDORID = #ListWarrantyVendors.VENDORID#
		ORDER BY	VENDORID
	</CFQUERY>

	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, GROUPS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
		SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
		FROM		ORGCODES
		ORDER BY	ORGCODE
	</CFQUERY>

	<CFINCLUDE template="/include/coldfusion/formheader.cfm">

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add Multiple Record Info in IDT Hardware Inventory</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(HARDWAREID) AS MAX_ID
		FROM		HARDWAREINVENTORY
	</CFQUERY>
	<CFSET FORM.HARDWAREID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFSET FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
	<CFSET FORM.FISCALYEARID = #ListCurrentFiscalYear.FISCALYEARID#>
	<CFCOOKIE name="HARDWAREID" secure="NO" value="#FORM.HARDWAREID#">
	<CFQUERY name="AddHardwareInventoryID" datasource="#application.type#HARDWARE">
		INSERT INTO	HARDWAREINVENTORY (HARDWAREID, CREATIONDATE, BARCODENUMBER, FISCALYEARID, DATECHECKED)
		VALUES		(#val(Cookie.HARDWAREID)#, TO_DATE('#FORM.CREATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
					'#FORM.BARCODENUMBER#', #val(FORM.FISCALYEARID)#, TO_DATE('#FORM.CREATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
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
			</TD>
</CFFORM>
		</TR>
     </TABLE>
	   
	<FIELDSET>
	<LEGEND>Equipment</LEGEND>
<CFFORM name="HARDWAREINVENTORY" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm" method="POST" ENABLECAB="Yes">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH align="left" width="50%"><LABEL for="BARCODENUMBER">Bar Code Number</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="STATEFOUNDNUMBER">State Found Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="#FORM.BARCODENUMBER#" align="LEFT" required="No" size="18" tabindex="2">
			</TD>
		<CFIF IsDefined('FORM.STATEFOUNDNUMBER')>
			<TD align="left" width="50%"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="#UCASE(FORM.STATEFOUNDNUMBER)#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
		<CFELSE>
			<TD align="left" width="50%"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
		</CFIF>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="SERIALNUMBER">Serial Number</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="DIVISIONNUMBER">Division Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
               	<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="4">
               </TD>
			<TD align="left" width="50%" nowrap>
				<CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="#StructFind(session.RecordAddsStructure, "DIVISIONNUMBER")#" align="LEFT" required="No" size="50" tabindex="5">
			</TD>
		</TR>
          <TR>
			<TH align="left" width="50%"><H4><LABEL for="EQUIPMENTTYPEID">*Equipment Type</LABEL></H4></TH>
			<TH align="left" width="50%"><H4><LABEL for="DESCRIPTIONID">*Description</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="EQUIPMENTTYPEID" id="EQUIPMENTTYPEID" size="1" query="ListEquipmentTypes" value="EQUIPTYPEID" display="EQUIPMENTTYPE" selected="#StructFind(session.RecordAddsStructure, "EQUIPMENTTYPEID")#" required="No" tabindex="6"></CFSELECT><BR />
				<CFINPUT type="Text" name="TYPENAME" id="EQUIPMENTTYPEID" value="" align="LEFT" required="No" size="50" tabindex="7">
			</TD>
			<TD align="left" width="50%">
				<CFSELECT name="DESCRIPTIONID" id="DESCRIPTIONID" size="1" query="ListEquipmentDescriptions" value="EQUIPDESCRID" display="EQUIPMENTDESCRIPTION" selected="#StructFind(session.RecordAddsStructure, "DESCRIPTIONID")#" required="No" tabindex="8"></CFSELECT><BR />
				<CFINPUT type="Text" name="DESCRIPTIONNAME" id="DESCRIPTIONID" value="" align="LEFT" required="No" size="50" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="MODELNAMEID">*Model</LABEL></H4></TH>
			<TH align="left" width="50%"><H4><LABEL for="MODELNUMBERID">*Model Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="MODELNAMEID" id="MODELNAMEID" size="1" query="ListModelNames" value="MODELNAMEID" display="MODELNAME" selected="#StructFind(session.RecordAddsStructure, "MODELNAMEID")#" required="No" tabindex="10"></CFSELECT><BR />
				<CFINPUT type="Text" name="MODELNAME" id="MODELNAMEID" value="" align="LEFT" required="No" size="50" tabindex="11">
			</TD>
			<TD align="left" width="50%">
				<CFSELECT name="MODELNUMBERID" id="MODELNUMBERID" size="1" query="ListModelNumbers" value="MODELNUMBERID" display="MODELNUMBER" selected="#StructFind(session.RecordAddsStructure, "MODELNUMBERID")#" required="No" tabindex="12"></CFSELECT><BR />
				<CFINPUT type="Text" name="MODELNUMBER" id="MODELNUMBERID" value="" align="LEFT" required="No" size="50" tabindex="13">
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="SPEEDNAMEID">Speed</LABEL></TH>
			<TH align="left" width="50%">Size</TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<CFSELECT name="SPEEDNAMEID" id="SPEEDNAMEID" size="1" query="ListSpeedNames" value="SPEEDNAMEID" display="SPEEDNAME" selected="#StructFind(session.RecordAddsStructure, "SPEEDNAMEID")#" required="No" tabindex="14"></CFSELECT><BR />
				<CFINPUT type="Text" name="SPEEDNAME" id="SPEEDNAMEID" value="" align="LEFT" required="No" size="50" tabindex="15">
			</TD>
			<TD align="left" width="50%" valign="TOP">
				<CFLOOP index="Counter" from=1 to=6>
					<CFSET TAB = #Counter# + 15>
					<LABEL for="SIZENAMEID#Counter#" class="LABEL_hidden">Size #Counter#</LABEL>
					<CFSELECT name="SIZENAMEID#Counter#" id="SIZENAMEID#Counter#" size="1" query="ListSizeNames" value="SIZENAMEID" display="SIZENAME" selected="#StructFind(session.RecordAddsStructure, "SIZENAMEID#Counter#")#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
				<LABEL for="SIZENAME1" class="LABEL_hidden">Size Name 1</LABEL>
				<CFINPUT type="Text" name="SIZENAME1" id="SIZENAMEID1" value="" align="LEFT" required="No" size="50" tabindex="22"><BR />
				<LABEL for="SIZENAME2" class="LABEL_hidden">Size Name 2</LABEL>
				<CFINPUT type="Text" name="SIZENAME2" id="SIZENAMEID2" value="" align="LEFT" required="No" size="50" tabindex="23"><BR />
				<LABEL for="SIZENAME3" class="LABEL_hidden">Size Name 3</LABEL>
				<CFINPUT type="Text" name="SIZENAME3" id="SIZENAMEID3" value="" align="LEFT" required="No" size="50" tabindex="24"><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Interfaces</TH>
			<TH align="left" width="50%">Peripherals</TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<CFLOOP index="Counter" from=1 to=6>
					<CFSET TAB = #Counter# + 24>
					<LABEL for="INTERFACENAMEID#Counter#" class="LABEL_hidden">Computer Interface #Counter#</LABEL>
					<CFSELECT name="INTERFACENAMEID#Counter#" id="INTERFACENAMEID#Counter#" size="1" query="ListInterfaces" value="INTERFACENAMEID" display="INTERFACENAME" selected="#StructFind(session.RecordAddsStructure, "INTERFACENAMEID#Counter#")#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
				<LABEL for="INTERFACENAME1" class="LABEL_hidden">Computer Interface Name 1</LABEL>
				<CFINPUT type="Text" name="INTERFACENAME1" id="INTERFACENAMEID1" value="" align="LEFT" required="No" size="50" tabindex="31"><BR />
				<LABEL for="INTERFACENAME2" class="LABEL_hidden">Computer Interface Name 2</LABEL>
				<CFINPUT type="Text" name="INTERFACENAME2" id="INTERFACENAMEID2" value="" align="LEFT" required="No" size="50" tabindex="32"><BR />
				<LABEL for="INTERFACENAME3" class="LABEL_hidden">Computer Interface Name 3</LABEL>
				<CFINPUT type="Text" name="INTERFACENAME3" id="INTERFACENAMEID3" value="" align="LEFT" required="No" size="50" tabindex="33"><BR />
			</TD>
			<TD align="left" width="50%" valign="TOP">
				<CFLOOP index="Counter" from=1 to=6>
					<CFSET TAB = #Counter# + 33>
					<LABEL for="PERIPHERALNAMEID#Counter#" class="LABEL_hidden">Computer Peripheral #Counter#</LABEL>
					<CFSELECT name="PERIPHERALNAMEID#Counter#" id="PERIPHERALNAMEID#Counter#" size="1" query="ListPeripherals" value="PERIPHERALNAMEID" display="PERIPHERALNAME" selected="#StructFind(session.RecordAddsStructure, "PERIPHERALNAMEID#Counter#")#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
				<LABEL for="PERIPHERALNAME1" class="LABEL_hidden">Computer Peripheral Name 1</LABEL>
				<CFINPUT type="Text" name="PERIPHERALNAME1" id="PERIPHERALNAME1" value="" align="LEFT" required="No" size="50" tabindex="40"><BR />
				<LABEL for="PERIPHERALNAME2" class="LABEL_hidden">Computer Peripheral Name 2</LABEL>
				<CFINPUT type="Text" name="PERIPHERALNAME2" id="PERIPHERALNAME2" value="" align="LEFT" required="No" size="50" tabindex="41"><BR />
				<LABEL for="PERIPHERALNAME3" class="LABEL_hidden">Computer Peripheral Name 3</LABEL>
				<CFINPUT type="Text" name="PERIPHERALNAME3" id="PERIPHERALNAME3" value="" align="LEFT" required="No" size="50" tabindex="42"><BR />
			</TD>
		</TR>
          <TR>
               <TH align="left" width="50%">Equipment Attached To</TH>
               <TH align="left" width="50%">&nbsp;&nbsp;</TH>
          </TR>
          <TR>
               <TD align="left" width="50%">
                    <CFLOOP index="Counter" from=1 to=2>
					<CFSET TAB = #Counter# + 42>
					<LABEL for="ATTACHEDTO#Counter#" class="LABEL_hidden">Equipment Attached To #Counter#</LABEL>
					<CFSELECT name="ATTACHEDTO#Counter#" id="ATTACHEDTO#Counter#" size="1" query="ListHardwareAttachedTo" value="HARDWAREID" display="ATTACHEDHARDWARE" selected="#StructFind(session.RecordAddsStructure, "ATTACHEDTO#Counter#")#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
				</CFLOOP>
               </TD>
               <TD align="left" width="50%">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
			<TH align="left" width="50%"><LABEL for="EQUIPMENTLOCATIONID">Location</LABEL></TH>
			<TH align="left" width="50%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="EQUIPMENTLOCATIONID" id="EQUIPMENTLOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#StructFind(session.RecordAddsStructure, "EQUIPMENTLOCATIONID")#" required="No" tabindex="45"></CFSELECT>
			</TD>
			<TD align="left" width="50%">&nbsp;&nbsp;</TD>
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
			<TD align="left" width="50%"><CFINPUT type="Text" name="MACHINENAME" id="MACHINENAME" value="" align="LEFT" required="No" size="50" tabindex="46"></TD>
			<TD align="left" width="50%">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="MACADDRESS">MAC Address</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="IPADDRESS">IP Address</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="MACADDRESS" id="MACADDRESS" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="47"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="" align="LEFT" required="No" size="15" maxlength="15" tabindex="48"></TD>

		</TR>
          <TR>
			<TH align="left" width="50%"><LABEL for="AIRPORTID">Airport/WIFI ID</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="BLUETOOTHID">Bluetooth ID</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%"><CFINPUT type="Text" name="AIRPORTID" id="AIRPORTID" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="49"></TD>
			<TD align="left" width="50%"><CFINPUT type="Text" name="BLUETOOTHID" id="BLUETOOTHID" value="" align="LEFT" required="No" size="15" maxlength="15" tabindex="50"></TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Purchasing and Warranty</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TH align="left" width="50%"><LABEL for="REQUISITIONNUMBER">Req.Number</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="PURCHASEORDERNUMBER">P. O. Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="REQUISITIONNUMBER" id="REQUISITIONNUMBER" value="#StructFind(session.RecordAddsStructure, "REQUISITIONNUMBER")#" align="LEFT" required="No" size="20" tabindex="51">
			</TD> 
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="PURCHASEORDERNUMBER" id="PURCHASEORDERNUMBER" value="#StructFind(session.RecordAddsStructure, "PURCHASEORDERNUMBER")#" align="LEFT" required="No" size="20" tabindex="52">
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%">Fiscal Year</TH>
			<TH align="left" width="50%"><LABEL for="OWNINGORGID">Owning Org. Code</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<INPUT type="hidden" name="FISCALYEARID" value="#FORM.FISCALYEARID#" />
				#ListCurrentFiscalYear.FISCALYEAR_4DIGIT#
			</TD>
			<TD align="left" width="50%" valign="TOP">
				<CFSELECT name="OWNINGORGID" id="OWNINGORGID" size="1" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" selected="#StructFind(session.RecordAddsStructure, "OWNINGORGID")#" required="No" tabindex="53"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="DATERECEIVED">Date Received</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="WARRANTYEXPIRATIONDATE">Warr. Expiration Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="DATERECEIVED" id="DATERECEIVED" value="#DateFormat(StructFind(session.RecordAddsStructure, "DATERECEIVED"), "MM/DD/YYYY")#" align="LEFT" required="No" size="15" tabindex="54">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'HARDWAREINVENTORY','controlname': 'DATERECEIVED'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
			<TD align="left" width="50%" valign="TOP">
				<CFINPUT type="Text" name="WARRANTYEXPIRATIONDATE" id="WARRANTYEXPIRATIONDATE" value="#DateFormat(StructFind(session.RecordAddsStructure, "WARRANTYEXPIRATIONDATE"), "MM/DD/YYYY")#" align="LEFT" required="NO" size="15" tabindex="55">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'HARDWAREINVENTORY','controlname': 'WARRANTYEXPIRATIONDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="MANUFACTURERID">Manufacturer</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="DELLEXPRESSSERVICE">DELL Express Service</LABEL></TH>
		</TR>
			<TR>
			<TD align="left" width="50%">
				<CFSELECT name="MANUFACTURERID" id="MANUFACTURERID" size="1" query="ListManufacturers" value="VENDORID" display="VENDORNAME" selected="#StructFind(session.RecordAddsStructure, "MANUFACTURERID")#" required="No" tabindex="56"></CFSELECT>
			</TD>
			<TD align="left" width="50%">
				<CFINPUT type="Text" name="DELLEXPRESSSERVICE" id="DELLEXPRESSSERVICE" value="#StructFind(session.RecordAddsStructure, "DELLEXPRESSSERVICE")#" align="LEFT" required="No" size="50" tabindex="57">
			</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="WARRANTYVENDORID">Warr. Vendor</LABEL></TH>
               <TH align="left" width="50%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="WARRANTYVENDORID" id="WARRANTYVENDORID" size="1" query="ListWarrantyVendors" value="VENDORID" display="VENDORNAME" selected="#StructFind(session.RecordAddsStructure, "WARRANTYVENDORID")#" required="No" tabindex="58"></CFSELECT>
			</TD>
               <TD align="left" width="50%">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="WARRANTYRESTRICTIONS">Warr. Restrictions</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="WARRANTYCOMMENTS">Warr. Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="WARRANTYRESTRICTIONS" id="WARRANTYRESTRICTIONS" value="#StructFind(session.RecordAddsStructure, "WARRANTYRESTRICTIONS")#" align="LEFT" required="NO" size="50" maxlength="600" tabindex="59">
			</TD>
			<CFSET FORM.WARRANTYCOMMENTS = "">
			<TD align="left" width="50%" valign="TOP"><CFTEXTAREA name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="60">#StructFind(session.RecordAddsStructure, "WARRANTYCOMMENTS")#</CFTEXTAREA></TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Customer and Modifier</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TH align="left" width="50%"><LABEL for="CUSTOMERID">Customer</LABEL></TH>
			<TH align="left" width="50%"><LABEL for="COMMENTS">Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#StructFind(session.RecordAddsStructure, "CUSTOMERID")#" required="No" tabindex="61"></CFSELECT>
			</TD>
			<TD align="left" width="50%"><CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="62">#StructFind(session.RecordAddsStructure, "COMMENTS")#</CFTEXTAREA></TD>
		</TR>
		<TR>
			<TH align="left" width="50%"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
			<TH align="left" width="50%">Date Checked (Creation Date)</TH>
		</TR>
		<TR>
			<TD align="left" width="50%" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="63"></CFSELECT>
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
			<TD align="left" width="50%">
               	<INPUT type="hidden" name="PROCESSHARDWAREINVENTORY" value="ADDMULTIPLE" />
                    <INPUT type="image" src="/images/buttonAddMultiple.jpg" value="ADDMULTIPLE" alt="Add Multiple" tabindex="64" />
               </TD>
		</TR>
     </TABLE>
</CFFORM>
	</FIELDSET>
	<BR />
	<TABLE width="100%" align="LEFT">
<CFFORM action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm" method="POST">
			<TD align="left" width="50%">
				<INPUT type="hidden" name="PROCESSHARDWAREINVENTORY" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="65" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>