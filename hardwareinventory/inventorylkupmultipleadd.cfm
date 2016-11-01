<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventorylkupmultipleadd.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Multiple Record Lookup Add in IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 10/03/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventorylkupmultipleadd.cfm">
<CFSET CONTENT_UPDATED = "October 03, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Multiple Record Lookup Add in IDT Hardware Inventory</TITLE>
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


	function validateLookupField() {
		if (document.LOOKUP.HARDWAREID.selectedIndex == "0"  && document.LOOKUP.BARCODENUMBER.value == "3065000" 
		 && (document.LOOKUP.STATEFOUNDNUMBER.value == ""    || document.LOOKUP.STATEFOUNDNUMBER.value == " ")    
		 && (document.LOOKUP.SERIALNUMBER.value == ""        || document.LOOKUP.SERIALNUMBER.value == " ")) {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.HARDWAREID.focus();
			return false;
		}

		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = document.LOOKUP.BARCODENUMBER.value;
			document.LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if (document.LOOKUP.BARCODENUMBER.value != "3065000" && document.LOOKUP.BARCODENUMBER.value.length != 17) {
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
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF URL.PROCESS EQ "NEWADD">
	<CFSET session.RecordAddsStructure = StructCopy(session.DefaultRecordAddsStructure)>
	<CFSET URL.PROCESS = "REQUESTBARCODE">
</CFIF>

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
***************************************************************************************
* The following code is the Lookup for Multiple Record Add to IDT Hardware Inventory. *
***************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>

	<CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER,
				HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
				HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, 
				HI.MACADDRESS, HI.EQUIPMENTTYPEID, HI.DESCRIPTIONID, 
				HI.MODELNAMEID, HI.MODELNUMBERID, HI.SPEEDNAMEID, 
				HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, 
				HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, 
				HI.FISCALYEARID, HI.CUSTOMERID, HI.COMMENTS,
				HI.OWNINGORGID, HI.MODIFIEDBYID, HI.DATECHECKED, HI.IPADDRESS,
				CUST.FULLNAME || ' - ' || ET.EQUIPMENTTYPE ||' - ' || HI.DIVISIONNUMBER ||' - ' || HI.BARCODENUMBER AS LOOKUPKEY
		FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET
		WHERE	HI.CUSTOMERID = CUST.CUSTOMERID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Multiple Record Lookup Add in IDT Hardware Inventory</H1></TH>
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
		<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/hardwareinventory/inventorylkupmultipleadd.cfm?PROCESS=REQUESTBARCODE&LOOKUPBARCODE=FOUND" method="POST">
		<TR>
			<TH align="LEFT"><LABEL for="HARDWAREID">Customer, Type, Division Number and Bar Code Number</LABEL></TH>
		</TR>
		<TR>
			<TD>
				<CFSELECT name="HARDWAREID" size="1" id="HARDWAREID" query="LookupHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="LEFT"><LABEL for="BARCODENUMBER">Or Bar Code Number</LABEL></TH>
		</TR>
		<TR>
			<TD><CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="LEFT"><LABEL for="STATEFOUNDNUMBER">Or State Found Number</LABEL></TH>
		</TR>
		<TR>
			<TD><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="18" tabindex="4"></TD>
		</TR>
		<TR>
			<TH align="LEFT"><LABEL for="SERIALNUMBER">Or Serial Number</LABEL></TH>
		</TR>
		<TR>
			<TD><CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="18" tabindex="5"></TD>
		</TR>
		<TR>
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="6" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="7" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*******************************************************************************
* The following code is the Specific Record Status Report Hardware Inventory. *
*******************************************************************************
 --->

	<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
				HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, HI.MACADDRESS, HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE,
				HI.DESCRIPTIONID, ED.EQUIPMENTDESCRIPTION, HI.MODELNAMEID, MNL.MODELNAME, HI.MODELNUMBERID,
				MUL.MODELNUMBER, HI.SPEEDNAMEID, SNL.SPEEDNAME, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, 
				HI.WARRANTYVENDORID, HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID,
				HI.CUSTOMERID, HI.COMMENTS, HI.OWNINGORGID, HI.MODIFIEDBYID, HI.DATECHECKED, HI.IPADDRESS
		FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED, MODELNAMELIST MNL, 
				MODELNUMBERLIST MUL, SPEEDNAMELIST SNL
		WHERE	HARDWAREID > 0 AND
			<CFIF #FORM.HARDWAREID# GT 0>
				HI.HARDWAREID = <CFQUERYPARAM value="#FORM.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
			<CFELSEIF #FORM.BARCODENUMBER# NEQ "3065000">
				HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
			<CFIF #FORM.STATEFOUNDNUMBER# NEQ "">
				HI.STATEFOUNDNUMBER = <CFQUERYPARAM value="#FORM.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
			<CFIF #FORM.SERIALNUMBER# NEQ "">
				HI.SERIALNUMBER = <CFQUERYPARAM value="#FORM.SERIALNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
			</CFIF>
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
				HI.MODELNAMEID = MNL.MODELNAMEID AND
				HI.MODELNUMBERID = MUL.MODELNUMBERID AND
				HI.SPEEDNAMEID = SNL.SPEEDNAMEID
		ORDER BY	HI.BARCODENUMBER
	</CFQUERY>
	<CFIF #ListHardware.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Inventory Record Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorylkupmultipleadd.cfm?PROCESS=NEWADD" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, LOCATIONNAME
		FROM		LOCATIONS
		WHERE	LOCATIONID = <CFQUERYPARAM value="#ListHardware.EQUIPMENTLOCATIONID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="ListManufacturers" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#ListHardware.MANUFACTURERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</CFQUERY>

	<CFQUERY name="ListWarrantyVendors" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#ListHardware.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</CFQUERY>

	<CFQUERY name="ListWarrantyVendorContacts" datasource="#application.type#PURCHASING">
		SELECT	VENDORCONTACTID, VENDORID, CONTACTNAME, PHONENUMBER, FAXNUMBER, EMAILADDRESS
		FROM		VENDORCONTACTS
		WHERE	VENDORID = <CFQUERYPARAM value="#ListHardware.WARRANTYVENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORID
	</CFQUERY>

	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL
		FROM		CUSTOMERS CUST, UNITS, GROUPS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#ListHardware.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID
		ORDER BY	LASTNAME
	</CFQUERY>

	<CFQUERY name="ListHardwareSizes" datasource="#application.type#HARDWARE">
		SELECT	HARDWARESIZES.HARDWARESIZESID, HARDWARESIZES.BARCODENUMBER, HARDWARESIZES.HARDWARESIZENAMEID AS SIZENAMEID, SIZENAMELIST.SIZENAME
		FROM		HARDWARESIZES, SIZENAMELIST
		WHERE	HARDWARESIZES.BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND 
				HARDWARESIZES.HARDWARESIZENAMEID = SIZENAMELIST.SIZENAMEID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="ListPCInstalledInterfaces" datasource="#application.type#HARDWARE">
		SELECT	PCINSTALLEDINTERFACES.INTERFACEID, PCINSTALLEDINTERFACES.BARCODENUMBER, PCINSTALLEDINTERFACES.INTERFACENAMEID,
				INTERFACENAMELIST.INTERFACENAME
		FROM		PCINSTALLEDINTERFACES, INTERFACENAMELIST
		WHERE	PCINSTALLEDINTERFACES.BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				PCINSTALLEDINTERFACES.INTERFACENAMEID = INTERFACENAMELIST.INTERFACENAMEID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="ListPCInstalledPeripherals" datasource="#application.type#HARDWARE">
		SELECT	PCINSTALLEDPERIPHERALS.PERIPHERALID, PCINSTALLEDPERIPHERALS.BARCODENUMBER, PCINSTALLEDPERIPHERALS.PERIPHERALNAMEID,
				PERIPHERALNAMELIST.PERIPHERALNAME
		FROM		PCINSTALLEDPERIPHERALS, PERIPHERALNAMELIST
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				PCINSTALLEDPERIPHERALS.PERIPHERALNAMEID = PERIPHERALNAMELIST.PERIPHERALNAMEID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="ListHardwareAttachedTo" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREATTACHEDTO.ATTACHEDTOID, HARDWAREATTACHEDTO.BARCODENUMBER, HARDWAREATTACHEDTO.ATTACHEDTO,
				HARDWAREINVENTORY.BARCODENUMBER AS ATTACHEDBARCODE
		FROM		HARDWAREATTACHEDTO, HARDWAREINVENTORY
		WHERE	HARDWAREATTACHEDTO.BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				HARDWAREATTACHEDTO.ATTACHEDTO = HARDWAREINVENTORY.HARDWAREID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="ListHardwareWarranty" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="ListHardwareFiscalYear" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		WHERE	(FISCALYEARID = <CFQUERYPARAM value="#ListHardware.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">)
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="ListModifiedBy" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, LASTNAME, FULLNAME
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

<!--- 
*************************************************************************************
* The following code sets the values for all the fields in the RecordAddsStructure. *
*************************************************************************************
 --->

	<CFSET rc=StructInsert(session.RecordAddsStructure, "STATEFOUNDNUMBER", "#ListHardware.STATEFOUNDNUMBER#")>
	<CFSET rc=StructInsert(session.RecordAddsStructure, "SERIALNUMBER", "#ListHardware.SERIALNUMBER#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "DIVISIONNUMBER", "#ListHardware.DIVISIONNUMBER#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "EQUIPMENTLOCATIONID", "#ListHardware.EQUIPMENTLOCATIONID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "EQUIPMENTTYPEID", "#ListHardware.EQUIPMENTTYPEID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "DESCRIPTIONID", "#ListHardware.DESCRIPTIONID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "MODELNAMEID", "#ListHardware.MODELNAMEID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "MODELNUMBERID", "#ListHardware.MODELNUMBERID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "SPEEDNAMEID", "#ListHardware.SPEEDNAMEID#")>
	<CFSET Counter = 0>
	<CFLOOP query="ListHardwareSizes">
		<CFSET Counter = Counter + 1>
		<CFSET rc=StructUpdate(session.RecordAddsStructure, "SIZENAMEID#Counter#", "#ListHardwareSizes.SIZENAMEID#")>
	</CFLOOP>
	<CFSET Counter = 0>
	<CFLOOP query="ListPCInstalledInterfaces">
		<CFSET Counter = Counter + 1>
		<CFSET rc=StructUpdate(session.RecordAddsStructure, "INTERFACENAMEID#Counter#", "#ListPCInstalledInterfaces.INTERFACENAMEID#")>
	</CFLOOP>
	<CFSET Counter = 0>
	<CFLOOP query="ListPCInstalledPeripherals">
		<CFSET Counter = Counter + 1>
		<CFSET rc=StructUpdate(session.RecordAddsStructure, "PERIPHERALNAMEID#Counter#", "#ListPCInstalledPeripherals.PERIPHERALNAMEID#")>
	</CFLOOP>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "MANUFACTURERID", "#ListHardware.MANUFACTURERID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "DELLEXPRESSSERVICE", "#ListHardware.DELLEXPRESSSERVICE#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "WARRANTYVENDORID", "#ListHardware.WARRANTYVENDORID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "WARRANTYRESTRICTIONS", "#ListHardwareWarranty.WARRANTYRESTRICTIONS#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "WARRANTYEXPIRATIONDATE", "#ListHardwareWarranty.WARRANTYEXPIRATIONDATE#")>
	<CFSET Counter = 0>
	<CFLOOP query="ListHardwareAttachedTo">
		<CFSET Counter = Counter + 1>
		<CFSET rc=StructUpdate(session.RecordAddsStructure, "ATTACHEDTO#Counter#", "#ListHardwareAttachedTo.ATTACHEDTO#")>
	</CFLOOP>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "WARRANTYCOMMENTS", "#ListHardwareWarranty.WARRANTYCOMMENTS#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "REQUISITIONNUMBER", "#ListHardware.REQUISITIONNUMBER#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "PURCHASEORDERNUMBER", "#ListHardware.PURCHASEORDERNUMBER#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "DATERECEIVED", "#ListHardware.DATERECEIVED#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "FISCALYEARID", "#ListHardware.FISCALYEARID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "CUSTOMERID", "#ListHardware.CUSTOMERID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "COMMENTS", "#ListHardware.COMMENTS#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "OWNINGORGID", "#ListHardware.OWNINGORGID#")>
	<CFSET rc=StructUpdate(session.RecordAddsStructure, "MODIFIEDBYID", "#ListHardware.MODIFIEDBYID#")>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultipleadd.cfm?PROCESS=REQUESTBARCODE" />
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>