<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventorymultiplemoddel.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/01/2012 --->
<!--- Date in Production: 08/01/2012 --->
<!--- Module: Multiple Record Modify/Delete in IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on on 07/17/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Multiple Record Modify/Delete in IDT Hardware Inventory</TITLE>
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
		 && (document.LOOKUP.EQUIPMENTTYPE.value == ""          || document.LOOKUP.EQUIPMENTTYPE.value == " ")           
		 && (document.LOOKUP.DESCRIPTION.value == ""			 || document.LOOKUP.DESCRIPTION.value == " ")
		 && (document.LOOKUP.MODELNAME.value == ""              || document.LOOKUP.MODELNAME.value == " ")             
		 && (document.LOOKUP.MODELNUMBER.value == ""            || document.LOOKUP.MODELNUMBER.value == " ")
		 && document.LOOKUP.SPEEDNAMEID.selectedIndex == "0" 
		 && (document.LOOKUP.CLUSTERNAME.value == ""            || document.LOOKUP.CLUSTERNAME.value == " ")   
		 && document.LOOKUP.BUILDINGNAMEID.selectedIndex == "0" && document.LOOKUP.LOCATIONID.selectedIndex == "0"
		 && (document.LOOKUP.MACADDRESS.value == ""             || document.LOOKUP.MACADDRESS.value == " ")
		 && (document.LOOKUP.IPADDRESS.value == ""			 || document.LOOKUP.IPADDRESS.value == " ")
		 && (document.LOOKUP.AIRPORTID.value == ""              || document.LOOKUP.AIRPORTID.value == " ")
		 && (document.LOOKUP.BLUETOOTHID.value == ""			 || document.LOOKUP.BLUETOOTHID.value == " ")
		 && (document.LOOKUP.WARRANTYVENDORNAME.value == ""     || document.LOOKUP.WARRANTYVENDORNAME.value == " ")      
		 && (document.LOOKUP.WARRANTYRESTRICTIONS.value == ""   || document.LOOKUP.WARRANTYRESTRICTIONS.value == " ")
		 && (document.LOOKUP.WARRANTYCOMMENTS.value == ""       || document.LOOKUP.WARRANTYCOMMENTS.value == " ")       
		 && (document.LOOKUP.COMMENTS.value == ""               || document.LOOKUP.COMMENTS.value == " ")
		 && (document.LOOKUP.REQUISITIONNUMBER.value == ""      || document.LOOKUP.REQUISITIONNUMBER.value == " ")
		 && (document.LOOKUP.PURCHASEORDERNUMBER.value == ""    || document.LOOKUP.PURCHASEORDERNUMBER.value == " ")
		 && document.LOOKUP.CUSTOMERID.selectedIndex == "0"     
		 && (document.LOOKUP.CUSTOMERLASTNAME.value == ""       || document.LOOKUP.CUSTOMERLASTNAME.value == " ")
		 && document.LOOKUP.UNITID.selectedIndex == "0"         && (document.LOOKUP.FISCALYEARID.selectedIndex == "0")
		 && document.LOOKUP.OWNINGORGID.selectedIndex == "0"    && document.LOOKUP.MODIFIEDBYID.selectedIndex == "0"   
		 && (document.LOOKUP.DATECHECKED.value == ""            || document.LOOKUP.DATECHECKED.value == " ")) {
			alertuser ("You must enter information in one of the twenty-nine (29) fields!");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = document.LOOKUP.BARCODENUMBER.value;
			document.LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

	}


	function validateReqFields() {
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
	
	
	function setDeleteMultiple() {
		document.HARDWAREINVENTORY.PROCESSHARDWAREINVENTORY.value = "DELETEMULTIPLE";
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
<CFELSE>
	<CFSET CURSORFIELD = "document.HARDWAREINVENTORY.DIVISIONNUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">


<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListBuildings" datasource="#application.type#FACILITIES" blockfactor="13">
	SELECT	BUILDINGNAMEID, BUILDINGNAME
	FROM		BUILDINGNAMES
	ORDER BY	BUILDINGNAME
</CFQUERY>

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOCATIONID, ROOMNUMBER
	FROM		LOCATIONS
	ORDER BY	ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListSpeedNames" datasource="#application.type#HARDWARE" blockfactor="86">
	SELECT	SPEEDNAMEID, SPEEDNAME
	FROM		SPEEDNAMELIST
	ORDER BY	SPEEDNAME
</CFQUERY>

<CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
     SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
     FROM		FISCALYEARS
     ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
	SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
	FROM		ORGCODES
	ORDER BY	ORGCODE
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

<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	UNITID, UNITNAME
	FROM		UNITS
	ORDER BY	UNITNAME
</CFQUERY>

<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID,
			SL.SECURITYLEVELNUMBER, SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 300 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
****************************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Multiple Records in Hardware Inventory. *
****************************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Multiple Record Modify/Delete Lookup in IDT Hardware Inventory</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in partial values to lookup multiple records for Modify/Delete.<BR /> 
				Checking an adjacent checkbox will Negate the selection or data entered.</H2>
			</TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
<BR /><BR /><BR /><BR /><BR />
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm?LOOKUPBARCODE=FOUND" method="POST">
     <FIELDSET>
	<LEGEND>Equipment</LEGEND>
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBARCODENUMBER">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BARCODENUMBER">Bar Code Number </LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESTATEFOUNDNUMBER">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="STATEFOUNDNUMBER">State Found Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBARCODENUMBER" id="NEGATEBARCODENUMBER" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="3">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATEFOUNDNUMBER" id="NEGATESTATEFOUNDNUMBER" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="50" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESERIALNUMBER">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SERIALNUMBER">Serial Number</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDIVISIONNUMBER">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DIVISIONNUMBER">Division Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESERIALNUMBER" id="NEGATESERIALNUMBER" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="50" tabindex="7">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDIVISIONNUMBER" id="NEGATEDIVISIONNUMBER" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="" align="LEFT" required="No" size="50" tabindex="9">
			</TD>
		</TR>
          <TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEEQUIPMENTTYPE">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="EQUIPMENTTYPE">Equipment Type</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDESCRIPTION">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DESCRIPTION">Description</LABEL>
			</TH>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEEQUIPMENTTYPE" id="NEGATEEQUIPMENTTYPE" value="" align="LEFT" required="No" tabindex="10">
			</TD>
		<CFIF IsDefined('URL.EQUIPMENTTYPE')>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="EQUIPMENTTYPE" id="EQUIPMENTTYPE" value="#URL.EQUIPMENTTYPE#" align="LEFT" required="No" size="50" tabindex="11">
			</TD>
		<CFELSE>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="EQUIPMENTTYPE" id="EQUIPMENTTYPE" value="" align="LEFT" required="No" size="50" tabindex="11">
			</TD>
		</CFIF>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDESCRIPTION" id="NEGATEDESCRIPTION" value="" align="LEFT" required="No" tabindex="12">
			</TD>
		<CFIF IsDefined('URL.DESCRIPTION')>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="DESCRIPTION" id="DESCRIPTION" value="#URL.DESCRIPTION#" align="LEFT" required="No" size="50" tabindex="13">
			</TD>
		<CFELSE>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="DESCRIPTION" id="DESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="13">
			</TD>
		</CFIF>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODELNAME">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODELNAME">Model</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODELNUMBER">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODELNUMBER">Model Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODELNAME" id="NEGATEMODELNAME" value="" align="LEFT" required="No" tabindex="14">
			</TD>
		<CFIF IsDefined('URL.MODELNAME')>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="MODELNAME" id="MODELNAME" value="#URL.MODELNAME#" align="LEFT" required="No" size="50" tabindex="15">
			</TD>
		<CFELSE>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="MODELNAME" id="MODELNAME" value="" align="LEFT" required="No" size="50" tabindex="15">
			</TD>
		</CFIF>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODELNUMBER" id="NEGATEMODELNUMBER" value="" align="LEFT" required="No" tabindex="16">
			</TD>
		<CFIF IsDefined('URL.MODELNUMBER')>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="MODELNUMBER" id="MODELNUMBER" value="#URL.MODELNUMBER#" align="LEFT" required="No" size="50" tabindex="17">
			</TD>
		<CFELSE>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="MODELNUMBER" id="MODELNUMBER" value="" align="LEFT" required="No" size="50" tabindex="17">
			</TD>
		</CFIF>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESPEEDNAME">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SPEEDNAMEID">Speed</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECLUSTERNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CLUSTERNAME">Cluster</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESPEEDNAME" id="NEGATESPEEDNAMEID" value="" align="LEFT" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="SPEEDNAMEID" id="SPEEDNAMEID" size="1" query="ListSpeedNames" value="SPEEDNAMEID" display="SPEEDNAME" required="No" tabindex="19"></CFSELECT><BR />
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECLUSTERNAME" id="NEGATECLUSTERNAME" value="" align="LEFT" required="No" tabindex="20">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CLUSTERNAME" id="CLUSTERNAME" value="" align="LEFT" required="No" size="50" tabindex="21">
			</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBUILDING">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BUILDINGNAMEID">Building</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEROOMNUMBER">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="LOCATIONID">Room Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBUILDING" id="NEGATEBUILDING" value="" align="LEFT" required="No" tabindex="22">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="ListBuildings" value="BUILDINGNAMEID" display="BUILDINGNAME" selected="0" required="No" tabindex="23"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEROOMNUMBER" id="NEGATEROOMNUMBER" value="" align="LEFT" required="No" tabindex="24">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="25"></CFSELECT>
			</TD>
		</TR>
     </TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Network</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMACADDRESS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MACADDRESS">MAC Address</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEIPADDRESS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="IPADDRESS">IP Address</LABEL>
			</TH>
		</TR>
		<TR>	
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMACADDRESS" id="NEGATEMACADDRESS" value="" align="LEFT" required="No" tabindex="26">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MACADDRESS" id="MACADDRESS" value="" align="LEFT" required="No" size="18" tabindex="27">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEIPADDRESS" id="NEGATEIPADDRESS" value="" align="LEFT" required="No" tabindex="28">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="" align="LEFT" required="No" size="18" tabindex="29">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAIRPORTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="AIRPORTID">Airport/WIFI ID</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBLUETOOTHID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BLUETOOTHID">Bluetooth ID</LABEL>
			</TH>
		</TR>
          <TR>	
          	<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAIRPORTID" id="NEGATEAIRPORTID" value="" align="LEFT" required="No" tabindex="30">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="AIRPORTID" id="AIRPORTID" value="" align="LEFT" required="No" size="18" tabindex="31">
			</TD>
               <TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBLUETOOTHID" id="NEGATEBLUETOOTHID" value="" align="LEFT" required="No" tabindex="32">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="BLUETOOTHID" id="BLUETOOTHID" value="" align="LEFT" required="No" size="18" tabindex="33">
			</TD>
          </TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Purchasing and Warranty</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUISITIONNUMBER">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUISITIONNUMBER">Req. Number</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPURCHASEORDERNUMBER">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PURCHASEORDERNUMBER">P.O. Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUISITIONNUMBER" id="NEGATEREQUISITIONNUMBER" value="" align="LEFT" required="No" tabindex="34">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="REQUISITIONNUMBER" id="REQUISITIONNUMBER" value="" align="LEFT" required="No" size="50" tabindex="35">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPURCHASEORDERNUMBER" id="NEGATEPURCHASEORDERNUMBER" value="" align="LEFT" required="No" tabindex="36">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="PURCHASEORDERNUMBER" id="PURCHASEORDERNUMBER" value="" required="No" size="50" tabindex="37">
			</TD>
		</TR>
           <TR>
          	<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFISCALYEARID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FISCALYEARID">Fiscal Year</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEOWNINGORGID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="OWNINGORGID">Owning Org. Code</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFISCALYEARID" id="NEGATEFISCALYEARID" value="" align="LEFT" required="No" tabindex="38">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="0" tabindex="39"></CFSELECT>
			</TD>
 			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEOWNINGORGID" id="NEGATEOWNINGORGID" value="" align="LEFT" required="No" tabindex="40">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="OWNINGORGID" id="OWNINGORGID" size="1" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" required="No" tabindex="41"></CFSELECT>
			</TD>              
          </TR>	
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWARRANTYVENDORNAME">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYVENDORNAME">Warr. Vendor</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWARRANTYRESTRICTIONS">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYRESTRICTIONS">Warr. Restrictions</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWARRANTYVENDORNAME" id="NEGATEWARRANTYVENDORNAME" value="" align="LEFT" required="No" tabindex="42">
			</TD>
		<CFIF IsDefined('URL.WARRANTYVENDORNAME')>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="WARRANTYVENDORNAME" id="WARRANTYVENDORNAME" value="#URL.WARRANTYVENDORNAME#" align="LEFT" required="No" size="50" tabindex="43">
			</TD>
		<CFELSE>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="WARRANTYVENDORNAME" id="WARRANTYVENDORNAME" value="" align="LEFT" required="No" size="50" tabindex="43">
			</TD>
		</CFIF>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWARRANTYRESTRICTIONS" id="NEGATEWARRANTYRESTRICTIONS" value="" align="LEFT" required="No" tabindex="44">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="WARRANTYRESTRICTIONS" id="WARRANTYRESTRICTIONS" value="" align="LEFT" required="No" size="50" tabindex="45">
			</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWARRANTYCOMMENTS">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYCOMMENTS">Warr. Comments</LABEL>
			</TH>
			<TH align="LEFT" colspan="2">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEWARRANTYCOMMENTS" id="NEGATEWARRANTYCOMMENTS" value="" align="LEFT" required="No" tabindex="46">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" value="" align="LEFT" required="No" size="50" tabindex="47">
			</TD>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Customer and Modifier</LEGEND>
	<TABLE width="100%" border="0">	
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERID">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERID">Customer</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERLASTNAME">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERLASTNAME">Or Enter a Customer's Last Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERID" id="NEGATECUSTOMERID" value="" align="LEFT" required="No" tabindex="48">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="49"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERLASTNAME" id="NEGATECUSTOMERLASTNAME" value="" align="LEFT" required="No" tabindex="50">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="CUSTOMERLASTNAME" id="CUSTOMERLASTNAME" value="" align="LEFT" required="No" size="17" tabindex="51">
			</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEUNITID">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UNITID">Unit</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Comments</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="52">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="0" required="No" tabindex="53"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="54">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="55">
			</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified By</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDATECHECKED">Negate</LABEL>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DATECHECKED">Enter (1) a single Date Checked or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="56">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="57">
					<OPTION value="0">SELECT A NAME</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDATECHECKED" id="NEGATEDATECHECKED" value="" align="LEFT" required="No" tabindex="58">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="DATECHECKED" id="DATECHECKED" value="" required="No" size="50" tabindex="59">
			</TD>
		</TR>
	 </TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
     <LEGEND>Record Selection</LEGEND>
     <TABLE width="100%" border="0">
     	<TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="60" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" onClick="return setMatchAll();" tabindex="61" />
			</TD>
		</TR>
	</TABLE>

     </FIELDSET>
</CFFORM>
	<BR />
	<TABLE width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="62" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*************************************************************************************************
* The following code is the Multiple Record Modify and Delete Processes for Hardware Inventory. *
*************************************************************************************************
 --->

	<CFQUERY name="GetEquipmentTypes" datasource="#application.type#HARDWARE" blockfactor="13">
		SELECT	EQUIPTYPEID, EQUIPMENTTYPE
		FROM	 	EQUIPMENTTYPE
	<CFIF #FORM.EQUIPMENTTYPE# NEQ "">
		WHERE 	EQUIPMENTTYPE LIKE UPPER('#FORM.EQUIPMENTTYPE#%')
	</CFIF>
		ORDER BY	EQUIPMENTTYPE
	</CFQUERY>
	<CFIF #FORM.EQUIPMENTTYPE# NEQ "" AND #GetEquipmentTypes.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records having the selected EQUIPMENT TYPE were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm?EQUIPMENTTYPE=#FORM.EQUIPMENTTYPE#" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="GetEquipmentDescriptions" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	EQUIPDESCRID, EQUIPMENTDESCRIPTION
		FROM		EQUIPMENTDESCRIPTION
	<CFIF #FORM.DESCRIPTION# NEQ "">
		WHERE	EQUIPMENTDESCRIPTION LIKE UPPER('#FORM.DESCRIPTION#%')
	</CFIF>
		ORDER BY	EQUIPMENTDESCRIPTION
	</CFQUERY>
	<CFIF #FORM.DESCRIPTION# NEQ "" AND #GetEquipmentDescriptions.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records having the selected Description were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm?DESCRIPTION=#FORM.DESCRIPTION#" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="GetModelNames" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	MODELNAMEID, MODELNAME
		FROM		MODELNAMELIST
	<CFIF #FORM.MODELNAME# NEQ "">
		WHERE	MODELNAME LIKE UPPER('#FORM.MODELNAME#%')
	</CFIF>
		ORDER BY	MODELNAME
	</CFQUERY>
	<CFIF #FORM.MODELNAME# NEQ "" AND #GetModelNames.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records having the selected Model Name were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm?MODELNAME=#FORM.MODELNAME#" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="GetModelNumbers" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	MODELNUMBERID, MODELNUMBER
		FROM		MODELNUMBERLIST
	<CFIF #FORM.MODELNUMBER# NEQ "">
		WHERE	MODELNUMBER LIKE UPPER('#FORM.MODELNUMBER#%')
	</CFIF>
		ORDER BY	MODELNUMBER
	</CFQUERY>
	<CFIF #FORM.MODELNUMBER# NEQ "" AND #GetModelNumbers.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records having the selected Model Number were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm?MODELNUMBER=#FORM.MODELNUMBER#" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="GetWarrantyVendors" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
		FROM		VENDORS
	<CFIF #FORM.WARRANTYVENDORNAME# NEQ "">
		WHERE	VENDORNAME LIKE UPPER('#FORM.WARRANTYVENDORNAME#%')
	</CFIF>
		ORDER BY	VENDORNAME
	</CFQUERY>
	<CFIF #FORM.WARRANTYVENDORNAME# NEQ "" AND #GetWarrantyVendors.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records having the selected Warranty Vendor Name were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm?WARRANTYVENDORNAME=#FORM.WARRANTYVENDORNAME#" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="GetWarrantyRestrictions" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HW.HARDWAREWARRANTYID, HW.BARCODENUMBER, HI.HARDWAREID, HI.BARCODENUMBER, HW.WARRANTYRESTRICTIONS,
				HW.WARRANTYEXPIRATIONDATE, HW.WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY HW, HARDWAREINVENTORY HI
		WHERE	HW.BARCODENUMBER = HI.BARCODENUMBER
	<CFIF #FORM.WARRANTYRESTRICTIONS# NEQ "">
				AND HW.WARRANTYRESTRICTIONS LIKE UPPER('%#FORM.WARRANTYRESTRICTIONS#%')
	</CFIF>
		ORDER BY	HW.BARCODENUMBER
	</CFQUERY>
	<CFIF #FORM.WARRANTYRESTRICTIONS# NEQ ""> 
		<CFIF #GetWarrantyRestrictions.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Warranty Restrictions were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" />
			<CFEXIT>
		<CFELSEIF #GetWarrantyRestrictions.RecordCount# GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Warranty Restrictions criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" />
			<CFEXIT>
		</CFIF>
	</CFIF>

	<CFQUERY name="GetWarrantyComments" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HW.HARDWAREWARRANTYID, HW.BARCODENUMBER, HI.HARDWAREID, HI.BARCODENUMBER, HW.WARRANTYRESTRICTIONS,
				HW.WARRANTYEXPIRATIONDATE, HW.WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY HW, HARDWAREINVENTORY HI
		WHERE	HW.BARCODENUMBER = HI.BARCODENUMBER
	<CFIF #FORM.WARRANTYCOMMENTS# NEQ "">
				AND HW.WARRANTYCOMMENTS LIKE '%#FORM.WARRANTYCOMMENTS#%'
	</CFIF>
		ORDER BY	HW.BARCODENUMBER
	</CFQUERY>
	<CFIF #FORM.WARRANTYCOMMENTS# NEQ "" AND #FORM.WARRANTYCOMMENTS# NEQ " ">
		<CFIF #GetWarrantyComments.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Warranty Comments were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" />
			<CFEXIT>
		<CFELSEIF #GetWarrantyComments.RecordCount# GT 1000>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("More than 0ne Thousand Records have been selected meeting your Warranty Comments criteria.  Please resubmit with more specific criteria.");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" />
			<CFEXIT>
		</CFIF>
	</CFIF>

	<CFQUERY name="GetUnits" datasource="#application.type#LIBSHAREDDATA">
		SELECT	UNITS.UNITID, UNITS.UNITNAME, CUST.CUSTOMERID, CUST.UNITID
		FROM		UNITS, CUSTOMERS CUST
		WHERE	UNITS.UNITID = <CFQUERYPARAM value="#FORM.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
				UNITS.UNITID = CUST.UNITID
		ORDER BY	UNITS.UNITNAME
	</CFQUERY>

	<CFIF "#FORM.DATECHECKED#" NEQ ''>
		<CFSET DATECHECKEDLIST = "NO">
		<CFSET DATECHECKEDRANGE = "NO">
		<CFIF FIND(',', #FORM.DATECHECKED#, 1) EQ 0 AND FIND(';', #FORM.DATECHECKED#, 1) EQ 0>
			<CFSET FORM.DATECHECKED = DateFormat(FORM.DATECHECKED, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.DATECHECKED#, 1) NEQ 0>
				<CFSET DATECHECKEDLIST = "YES">
			<CFELSEIF FIND(';', #FORM.DATECHECKED#, 1) NEQ 0>
				<CFSET DATECHECKEDRANGE = "YES">
				<CFSET FORM.DATECHECKED = #REPLACE(FORM.DATECHECKED, ";", ",")#>
			</CFIF>
			<CFSET DATECHECKEDARRAY = ListToArray(FORM.DATECHECKED)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(DATECHECKEDARRAY)# >
				DATECHECKED FIELD = #DATECHECKEDARRAY[COUNTER]#<BR /><BR />
			</CFLOOP>
		</CFIF>
		<CFIF DATECHECKEDRANGE EQ "YES">
			<CFSET BEGINDATECHECKED = DateFormat(#DATECHECKEDARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDDATECHECKED = DateFormat(#DATECHECKEDARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		DATECHECKEDLIST = #DATECHECKEDLIST#<BR /><BR />
		DATECHECKEDRANGE = #DATECHECKEDRANGE#<BR /><BR />
	</CFIF>

	<CFQUERY name="GetRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID,
				SL.SECURITYLEVELNUMBER, SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 300 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 30
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET NEGATEDATELOOP = "AND">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET NEGATEDATELOOP = "OR">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
				HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, LOC.BUILDINGNAMEID, HI.MACADDRESS, HI.AIRPORTID, HI.BLUETOOTHID, 
				HI.EQUIPMENTTYPEID, HI.DESCRIPTIONID, HI.MODELNAMEID, HI.MODELNUMBERID, HI.SPEEDNAMEID, SNL.SPEEDNAME, HI.MANUFACTURERID,
				HI.DELLEXPRESSSERVICE, HI.WARRANTYVENDORID, HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER, HI.DATERECEIVED,
				HI.FISCALYEARID, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.LASTNAME, HI.COMMENTS, HI.OWNINGORGID, HI.MODIFIEDBYID,
				HI.DATECHECKED, HI.IPADDRESS
		FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED,
				MODELNAMELIST MNL, MODELNUMBERLIST MUL, SPEEDNAMELIST SNL, PURCHASEMGR.VENDORS VEND,
				LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS UNITS
		WHERE	((HI.HARDWAREID > 0 AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
				HI.MODELNAMEID = MNL.MODELNAMEID AND
				HI.MODELNUMBERID = MUL.MODELNUMBERID AND
				HI.SPEEDNAMEID = SNL.SPEEDNAMEID AND
				HI.MANUFACTURERID = VEND.VENDORID AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.UNITID = UNITS.UNITID) AND (
			<CFIF #FORM.BARCODENUMBER# NEQ "3065000">
				<CFIF IsDefined("FORM.NEGATEBARCODENUMBER")>
					NOT HI.BARCODENUMBER LIKE '#FORM.BARCODENUMBER#%' #LOGICANDOR#
				<CFELSE>
					HI.BARCODENUMBER LIKE '#FORM.BARCODENUMBER#%'#LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.STATEFOUNDNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATESTATEFOUNDNUMBER")>
					NOT HI.STATEFOUNDNUMBER LIKE UPPER('#FORM.STATEFOUNDNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.STATEFOUNDNUMBER LIKE UPPER('#FORM.STATEFOUNDNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.SERIALNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATESERIALNUMBER")>
					NOT HI.SERIALNUMBER LIKE UPPER('#FORM.SERIALNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.SERIALNUMBER LIKE UPPER('#FORM.SERIALNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.DIVISIONNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEDIVISIONNUMBER")>
					NOT HI.DIVISIONNUMBER LIKE UPPER('#FORM.DIVISIONNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.DIVISIONNUMBER LIKE UPPER('#FORM.DIVISIONNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.BUILDINGNAMEID# GT 0>
				<CFIF IsDefined("FORM.NEGATEBUILDING")>
					NOT (LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)#) #LOGICANDOR#
				<CFELSE>
					LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.LOCATIONID# GT 0>
				<CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
					NOT HI.EQUIPMENTLOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
				<CFELSE>
					HI.EQUIPMENTLOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.MACADDRESS# NEQ "">
				<CFIF IsDefined("FORM.NEGATEMACADDRESS")>
					NOT (HI.MACADDRESS = '#FORM.MACADDRESS#') #LOGICANDOR#
				<CFELSE>
					HI.MACADDRESS = '#FORM.MACADDRESS#' #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.IPADDRESS# NEQ "">
				<CFIF IsDefined("FORM.NEGATEIPADDRESS")>
					NOT (HI.IPADDRESS LIKE '%#FORM.IPADDRESS#%') #LOGICANDOR#
				<CFELSE>
					HI.IPADDRESS LIKE '%#FORM.IPADDRESS#%' #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.AIRPORTID# NEQ "">
				<CFIF IsDefined("FORM.NEGATEAIRPORTID")>
					NOT (HI.AIRPORTID LIKE '%#FORM.AIRPORTID#%') #LOGICANDOR#
				<CFELSE>
					HI.AIRPORTID LIKE '%#FORM.AIRPORTID#%' #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.BLUETOOTHID# NEQ "">
				<CFIF IsDefined("FORM.NEGATEBLUETOOTHID")>
					NOT (HI.BLUETOOTHID LIKE '%#FORM.BLUETOOTHID#%') #LOGICANDOR#
				<CFELSE>
					HI.BLUETOOTHID LIKE '%#FORM.BLUETOOTHID#%' #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.EQUIPMENTTYPE# NEQ "">
				<CFIF IsDefined("FORM.NEGATEEQUIPMENTTYPE")>
					NOT HI.EQUIPMENTTYPEID IN (#ValueList(GetEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
				<CFELSE>
					HI.EQUIPMENTTYPEID IN (#ValueList(GetEquipmentTypes.EQUIPTYPEID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.DESCRIPTION# NEQ "">
				<CFIF IsDefined("FORM.NEGATEDESCRIPTION")>
					NOT HI.DESCRIPTIONID IN (#ValueList(GetEquipmentDescriptions.EQUIPDESCRID)#) #LOGICANDOR#
				<CFELSE>
					HI.DESCRIPTIONID IN (#ValueList(GetEquipmentDescriptions.EQUIPDESCRID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODELNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATEMODELNAME")>
					NOT HI.MODELNAMEID IN (#ValueList(GetModelNames.MODELNAMEID)#) #LOGICANDOR#
				<CFELSE>
					HI.MODELNAMEID IN (#ValueList(GetModelNames.MODELNAMEID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODELNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEMODELNUMBER")>
					NOT HI.MODELNUMBERID IN (#ValueList(GetModelNumbers.MODELNUMBERID)#) #LOGICANDOR#
				<CFELSE>
					HI.MODELNUMBERID IN (#ValueList(GetModelNumbers.MODELNUMBERID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.SPEEDNAMEID# GT 0>
				<CFIF IsDefined("FORM.NEGATESPEEDNAME")>
					NOT (HI.SPEEDNAMEID = #val(FORM.SPEEDNAMEID)#) #LOGICANDOR#
				<CFELSE>
					HI.SPEEDNAMEID = #val(FORM.SPEEDNAMEID)# #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.CLUSTERNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATECLUSTERNAME")>
					NOT HI.CLUSTERNAME LIKE UPPER('#FORM.CLUSTERNAME#%') #LOGICANDOR#
				<CFELSE>
					HI.CLUSTERNAME LIKE UPPER('#FORM.CLUSTERNAME#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.WARRANTYVENDORNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATEWARRANTYVENDORNAME")>
					NOT HI.WARRANTYVENDORID IN (#ValueList(GetWarrantyVendors.VENDORID)#) #LOGICANDOR#
				<CFELSE>
					HI.WARRANTYVENDORID IN (#ValueList(GetWarrantyVendors.VENDORID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.WARRANTYRESTRICTIONS# NEQ "">
				<CFIF IsDefined("FORM.NEGATEWARRANTYRESTRICTIONS")>
					NOT HI.HARDWAREID IN (#ValueList(GetWarrantyRestrictions.HARDWAREID)#) #LOGICANDOR#
				<CFELSE>
					HI.HARDWAREID IN (#ValueList(GetWarrantyRestrictions.HARDWAREID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.WARRANTYCOMMENTS# NEQ "">
				<CFIF IsDefined("FORM.NEGATEWARRANTYCOMMENTS")>
					NOT HI.HARDWAREID IN (#ValueList(GetWarrantyComments.HARDWAREID)#) #LOGICANDOR#
				<CFELSE>
					HI.HARDWAREID IN (#ValueList(GetWarrantyComments.HARDWAREID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.REQUISITIONNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEREQUISITIONNUMBER")>
					NOT HI.REQUISITIONNUMBER LIKE UPPER('#FORM.REQUISITIONNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.REQUISITIONNUMBER LIKE UPPER('#FORM.REQUISITIONNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.PURCHASEORDERNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEPURCHASEORDERNUMBER")>
					NOT HI.PURCHASEORDERNUMBER LIKE UPPER('#FORM.PURCHASEORDERNUMBER#%') #LOGICANDOR#
				<CFELSE>
					HI.PURCHASEORDERNUMBER LIKE UPPER('#FORM.PURCHASEORDERNUMBER#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.CUSTOMERID# GT 0>
				<CFIF IsDefined("FORM.NEGATECUSTOMERID")>
					NOT HI.CUSTOMERID = #val(FORM.CUSTOMERID)# #LOGICANDOR#
				<CFELSE>
					HI.CUSTOMERID = #val(FORM.CUSTOMERID)# #LOGICANDOR#
				</CFIF>
			<CFELSEIF #FORM.CUSTOMERLASTNAME# NEQ "">
				<CFIF IsDefined("FORM.NEGATECUSTOMERNAME")>
					NOT CUST.LASTNAME LIKE UPPER('#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
				<CFELSE>
					CUST.LASTNAME LIKE UPPER('#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.COMMENTS# NEQ "">
				<CFIF IsDefined("FORM.NEGATECOMMENTS")>
					NOT HI.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
				<CFELSE>
					HI.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.UNITID# GT 0>
				<CFIF IsDefined("FORM.NEGATEUNITID")>
					NOT HI.CUSTOMERID IN (#ValueList(GetUnits.CUSTOMERID)#) #LOGICANDOR#
				<CFELSE>
					HI.CUSTOMERID IN (#ValueList(GetUnits.CUSTOMERID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.FISCALYEARID# GT 0>
				<CFIF IsDefined("FORM.NEGATEFISCALYEARID")>
					NOT HI.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
				<CFELSE>
					HI.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.OWNINGORGID# GT 0>
				<CFIF IsDefined("FORM.NEGATEOWNINGORGID")>
					NOT HI.OWNINGORGID LIKE UPPER('%#FORM.OWNINGORGID#%') #LOGICANDOR#
				<CFELSE>
					HI.OWNINGORGID LIKE UPPER('%#FORM.OWNINGORGID#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODIFIEDBYID# GT 0>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
					NOT HI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				<CFELSE>
					HI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.DATECHECKED#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEDATECHECKED")>
					<CFIF DATECHECKEDLIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(DATECHECKEDARRAY)# >
							<CFSET FORMATDATECHECKED =  DateFormat(#DATECHECKEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT HI.DATECHECKED IN TO_DATE('#FORMATDATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS') #NEGATEDATELOOP#
						</CFLOOP>
					<CFELSEIF DATECHECKEDRANGE EQ "YES">
						NOT (HI.DATECHECKED BETWEEN TO_DATE('#BEGINDATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS') AND TO_DATE('#ENDDATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')) #LOGICANDOR#
					<CFELSE>
						NOT HI.DATECHECKED LIKE TO_DATE('#FORM.DATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF DATECHECKEDLIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(DATECHECKEDARRAY)# >
							<CFSET FORMATDATECHECKED = DateFormat(#DATECHECKEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							HI.DATECHECKED IN TO_DATE('#FORMATDATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS') #LOGICANDOR#
						</CFLOOP>
					<CFELSEIF DATECHECKEDRANGE EQ "YES">
							(HI.DATECHECKED BETWEEN TO_DATE('#BEGINDATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS') AND TO_DATE('#ENDDATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')) #LOGICANDOR#
					<CFELSE>
						HI.DATECHECKED LIKE TO_DATE('#FORM.DATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

				HI.MODIFIEDBYID #FINALTEST# 0))
		ORDER BY	HI.HARDWAREID
	</CFQUERY>

	<CFIF #GetHardware.RecordCount# EQ 0>

		<SCRIPT language="JavaScript">
		<!-- 
			alert("Records meeting the selected criteria were Not Found");
		--> 
		</SCRIPT>

		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" />
		<CFEXIT>
	<CFELSE>
		<CFSET URL.HARDWAREIDS = #ValueList(GetHardware.HARDWAREID)#>
		<!--- HARDWARE IDS = #URL.HARDWAREIDS# --->
		<SCRIPT language="JavaScript">
			<!-- 
				window.open("/#application.type#apps/hardwareinventory/inventmultiplelookupreport.cfm?PROCESS=MODIFYMULTIPLE&HARDWAREIDS=#URL.HARDWAREIDS#","Print_HardWare_IDs", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
			 -->
		</SCRIPT>
	</CFIF>

	<CFQUERY name="GetJackNumbers" datasource="#application.type#FACILITIES">
		SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, WJ.WALLDIRID, WD.WALLDIRNAME,
				WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.ACTIVE, WJ.HARDWAREID, WJ.CUSTOMERID, CUST.FULLNAME, WJ.COMMENTS,
				LOC.ROOMNUMBER || ' - ' || WD.WALLDIRNAME || ' - ' || WJ.JACKNUMBER || ' - ' || WJ.PORTLETTER AS KEYFINDER
		FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WJ.HARDWAREID = <CFQUERYPARAM value="#GetHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WJ.LOCATIONID = LOC.LOCATIONID AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				WJ.WALLDIRID = WD.WALLDIRID AND
				WJ.CUSTOMERID = CUST.CUSTOMERID
		ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER, WD.WALLDIRNAME
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

	<CFQUERY name="GetWarrantyVendorContacts" datasource="#application.type#PURCHASING">
		SELECT	VENDORCONTACTID, VENDORID, CONTACTNAME, PHONENUMBER, FAXNUMBER, EMAILADDRESS
		FROM		VENDORCONTACTS
		WHERE	VENDORID = <CFQUERYPARAM value="#GetWarrantyVendors.VENDORID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORID
	</CFQUERY>

	<CFQUERY name="GetHardwareSizes" datasource="#application.type#HARDWARE">
		SELECT	HARDWARESIZES.HARDWARESIZESID, HARDWARESIZES.BARCODENUMBER, HARDWARESIZES.HARDWARESIZENAMEID, SIZENAMELIST.SIZENAME
		FROM		HARDWARESIZES, SIZENAMELIST
		WHERE	HARDWARESIZES.BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND 
				HARDWARESIZES.HARDWARESIZENAMEID = SIZENAMELIST.SIZENAMEID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="GetPCInstalledInterfaces" datasource="#application.type#HARDWARE">
		SELECT	PCINSTALLEDINTERFACES.INTERFACEID, PCINSTALLEDINTERFACES.BARCODENUMBER, PCINSTALLEDINTERFACES.INTERFACENAMEID,
				INTERFACENAMELIST.INTERFACENAME
		FROM		PCINSTALLEDINTERFACES, INTERFACENAMELIST
		WHERE	PCINSTALLEDINTERFACES.BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				PCINSTALLEDINTERFACES.INTERFACENAMEID = INTERFACENAMELIST.INTERFACENAMEID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="GetPCInstalledPeripherals" datasource="#application.type#HARDWARE">
		SELECT	PCINSTALLEDPERIPHERALS.PERIPHERALID, PCINSTALLEDPERIPHERALS.BARCODENUMBER, PCINSTALLEDPERIPHERALS.PERIPHERALNAMEID,
				PERIPHERALNAMELIST.PERIPHERALNAME
		FROM		PCINSTALLEDPERIPHERALS, PERIPHERALNAMELIST
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				PCINSTALLEDPERIPHERALS.PERIPHERALNAMEID = PERIPHERALNAMELIST.PERIPHERALNAMEID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="GetHardwareAttachedTo" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREATTACHEDTO.ATTACHEDTOID, HARDWAREATTACHEDTO.BARCODENUMBER, HARDWAREATTACHEDTO.ATTACHEDTO,
				HARDWAREINVENTORY.BARCODENUMBER AS ATTACHEDBARCODE
		FROM		HARDWAREATTACHEDTO, HARDWAREINVENTORY
		WHERE	HARDWAREATTACHEDTO.BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				HARDWAREATTACHEDTO.ATTACHEDTO = HARDWAREINVENTORY.HARDWAREID
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="GetHardwareWarranty" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Multiple Record Modify/Delete in IDT Hardware Inventory</H1></TH>
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
		<TR>
			<TH align="CENTER"><H2>To modify a field on multiple records, a check in the adjacent checkbox is required.</H2></TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" method="POST">
			<TD align="left" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
<BR /><BR /><BR /><BR /><BR />
<CFFORM name="HARDWAREINVENTORY"  onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm?MULTIPLERECORDS=YES&HARDWAREIDS=#URL.HARDWAREIDS#" method="POST" ENABLECAB="Yes">
     <FIELDSET>
	<LEGEND>Equipment</LEGEND>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Bar Code Number</TH>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">State Found Number</TH>
		</TR>
		<TR>
			<CFCOOKIE name="HARDWAREID" secure="NO" value="#GetHardware.HARDWAREID#">
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">#GetHardware.BARCODENUMBER#</TD>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">#GetHardware.STATEFOUNDNUMBER#</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Serial Number</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="DIVISIONNUMBERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DIVISIONNUMBER">Division Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">#GetHardware.SERIALNUMBER#</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="DIVISIONNUMBERCHANGED" id="DIVISIONNUMBERCHANGED" value="" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="#GetHardware.DIVISIONNUMBER#" required="No" size="50" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="EQUIPMENTTYPECHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<H4><LABEL for="EQUIPMENTTYPEID">*Equipment Type</LABEL></H4>
			</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="EQUIPMENTDESCRIPTIONCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<H4><LABEL for="DESCRIPTIONID">*Equipment Description</LABEL></H4>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="EQUIPMENTTYPECHANGED" id="EQUIPMENTTYPECHANGED" value="" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="EQUIPMENTTYPEID" id="EQUIPMENTTYPEID" size="1" query="ListEquipmentTypes" value="EQUIPTYPEID" display="EQUIPMENTTYPE" selected="#GetHardware.EQUIPMENTTYPEID#" required="No" tabindex="5"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="EQUIPMENTDESCRIPTIONCHANGED" id="EQUIPMENTDESCRIPTIONCHANGED" value="" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="DESCRIPTIONID" id="DESCRIPTIONID" size="1" query="ListEquipmentDescriptions" value="EQUIPDESCRID" display="EQUIPMENTDESCRIPTION" selected="#GetHardware.DESCRIPTIONID#" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="MODELNAMECHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<H4><LABEL for="MODELNAMEID">*Model Name</LABEL></H4>
			</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="MODELNUMBERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<H4><LABEL for="MODELNUMBERID">*Model Number</LABEL></H4>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="MODELNAMECHANGED" VID="MODELNAMECHANGED" ALUE="" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="MODELNAMEID" id="MODELNAMEID" size="1" query="ListModelNames" value="MODELNAMEID" display="MODELNAME" selected="#GetHardware.MODELNAMEID#" required="No" tabindex="9"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="MODELNUMBERCHANGED" id="MODELNUMBERCHANGED" value="" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="MODELNUMBERID" id="MODELNUMBERID" size="1" query="ListModelNumbers" value="MODELNUMBERID" display="MODELNUMBER" selected="#GetHardware.MODELNUMBERID#" required="No" tabindex="11"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="SPEEDNAMECHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SPEEDNAMEID">Speed</LABEL>
			</TH>
		<CFIF GetHardwareSizes.RecordCount GT 0>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Size</TH>
		<CFELSE>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">&nbsp;&nbsp;</TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="SPEEDNAMECHANGED" id="SPEEDNAMECHANGED" value="" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="SPEEDNAMEID" id="SPEEDNAMEID" size="1" query="ListSpeedNames" value="SPEEDNAMEID" display="SPEEDNAME" selected="#GetHardware.SPEEDNAMEID#" required="No" tabindex="13"></CFSELECT>
			</TD>
		<CFIF GetHardwareSizes.RecordCount GT 0>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
				<CFLOOP query="GetHardwareSizes">
					#SIZENAME#<BR />
				</CFLOOP>
			</TD>
		</CFIF>
		</TR>
		<TR>
		<CFIF GetPCInstalledInterfaces.RecordCount GT 0>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Installed Interfaces</TH>
		<CFELSE>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">&nbsp;&nbsp;</TH>
		</CFIF>
		<CFIF GetPCInstalledPeripherals.RecordCount GT 0>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Installed Peripherals</TH>
		<CFELSE>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">&nbsp;&nbsp;</TH>
		</CFIF>
		</TR>
		<TR>
		<CFIF GetPCInstalledInterfaces.RecordCount GT 0>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
				<CFLOOP query="GetPCInstalledInterfaces">
					#INTERFACENAME#<BR />
				</CFLOOP>
			</TD>
		</CFIF>
		<CFIF GetPCInstalledPeripherals.RecordCount GT 0>
			<CFIF GetPCInstalledInterfaces.RecordCount EQ 0>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">&nbsp;&nbsp;</TD>
			</CFIF>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
				<CFLOOP query="GetPCInstalledPeripherals">
					#PERIPHERALNAME#<BR />
				</CFLOOP>
			</TD>
		</CFIF>
		</TR>
          <TR>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Equipment Attached To</TH>
   			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
				<CFLOOP query="GetHardwareAttachedTo">
					#ATTACHEDBARCODE#<BR />
				</CFLOOP>
			</TD>
               <TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
               <TD align="left" valign="BOTTOM" width="45%">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="ROOMNUMBERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="EQUIPMENTLOCATIONID">Equipment Location</LABEL>
			</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="CLUSTERNAMECHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CLUSTERNAME">Cluster</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="ROOMNUMBERCHANGED" id="ROOMNUMBERCHANGED" value="" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="EQUIPMENTLOCATIONID" id="EQUIPMENTLOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetHardware.EQUIPMENTLOCATIONID#" required="No" tabindex="15"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="CLUSTERNAMECHANGED" id="CLUSTERNAMECHANGED" value="" required="No" tabindex="16">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="CLUSTERNAME" id="CLUSTERNAME" value="#GetHardware.CLUSTERNAME#" required="No" size="50" tabindex="17">
			</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Network</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">MAC Address</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="IPADDRESSCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="IPADDRESS">IP Address</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">#GetHardware.MACADDRESS#</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="IPADDRESSCHANGED" id="IPADDRESSCHANGED" value="" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="IPADDRESS" id="IPADDRESS" value="#GetHardware.IPADDRESS#" align="LEFT" required="NO" size="15" tabindex="19">
			</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Purchasing and Warranty</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="REQUISITIONNUMBERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUISITIONNUMBER">Req. Number</LABEL>
			</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="PURCHASEORDERNUMBERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PURCHASEORDERNUMBER">P.O. Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="REQUISITIONNUMBERCHANGED" id="REQUISITIONNUMBERCHANGED" value="" required="No" tabindex="20">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="REQUISITIONNUMBER" id="REQUISITIONNUMBER" value="#GetHardware.REQUISITIONNUMBER#" required="No" size="20" tabindex="21">
			</TD> 
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="PURCHASEORDERNUMBERCHANGED" id="PURCHASEORDERNUMBERCHANGED" value="" required="No" tabindex="22">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="PURCHASEORDERNUMBER" id="PURCHASEORDERNUMBER" value="#GetHardware.PURCHASEORDERNUMBER#" align="LEFT" required="No" size="20" tabindex="23">
			</TD>
		</TR>
		<TR>
			 <TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="FISCALYEARIDCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FISCALYEARID">Fiscal Year</LABEL>
			</TH>
               <TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="OWNINGORGIDCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="OWNINGORGID">Owning Org. Coder</LABEL>
			</TH>
		</TR>
		<TR>
			 <TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="FISCALYEARIDCHANGED" id="FISCALYEARIDCHANGED" value="" required="No" tabindex="24">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#GetHardware.FISCALYEARID#" tabindex="25"></CFSELECT>
			</TD>
               <TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="OWNINGORGIDCHANGED" id="OWNINGORGIDCHANGED" value="" required="No" tabindex="26">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="OWNINGORGID" id="OWNINGORGID" size="1" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" selected="#GetHardware.OWNINGORGID#" required="No" tabindex="27"></CFSELECT>
			</TD>
		</TR>
          <TR>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Date Received</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="WARRANTYEXPIRATIONDATECHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYEXPIRATIONDATE">Warr. Expiration Date</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">#DateFormat(GetHardware.DATERECEIVED, "MM/DD/YYYY")#</TD>
          <CFIF GetHardwareWarranty.RecordCount GT 0>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="WARRANTYEXPIRATIONDATECHANGED" id="WARRANTYEXPIRATIONDATECHANGED" value="" required="No" tabindex="28">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="WARRANTYEXPIRATIONDATE" id="WARRANTYEXPIRATIONDATE" value="#DateFormat(GetHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#" align="LEFT" required="NO" size="15" tabindex="29">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'HARDWAREINVENTORY','controlname': 'WARRANTYEXPIRATIONDATE'});

				</SCRIPT>
				<BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
          <CFELSE>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">&nbsp;&nbsp;</TD>
		</CFIF>
		</TR>
		<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="MANUFACTURERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MANUFACTURERID">Manufacturer</LABEL>
			</TH>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">DELL Express Service</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="MANUFACTURERCHANGED" id="MANUFACTURERCHANGED" value="" required="No" tabindex="30">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="MANUFACTURERID" id="MANUFACTURERID" size="1" query="ListManufacturers" value="VENDORID" display="VENDORNAME" selected="#GetHardware.MANUFACTURERID#" required="No" tabindex="31"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">#GetHardware.DELLEXPRESSSERVICE#</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="WARRANTYVENDORCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYVENDORID">Warr. Vendor</LABEL>
			</TH>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Warr. Contact & Phone</TH>
		</TR>
		<TR>
		<CFIF GetWarrantyVendors.RecordCount GT 0>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="WARRANTYVENDORCHANGED" id="WARRANTYVENDORCHANGED" value="" required="No" tabindex="32">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="WARRANTYVENDORID" id="WARRANTYVENDORID" size="1" query="ListWarrantyVendors" value="VENDORID" display="VENDORNAME" selected="#GetHardware.WARRANTYVENDORID#" required="No" tabindex="33"></CFSELECT>
			</TD>
		<CFELSE>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">&nbsp;&nbsp;</TD>
		</CFIF>
			
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
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
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="WARRANTYRESTRICTIONSCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYRESTRICTIONS">Warr. Restrictions</LABEL>
			</TH>
               <TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="WARRANTYCOMMENTSCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WARRANTYCOMMENTS">Warr. Comments</LABEL>
			</TH>

		</TR>
		<TR>
		<CFIF GetHardwareWarranty.RecordCount GT 0>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="WARRANTYRESTRICTIONSCHANGED" id="WARRANTYRESTRICTIONSCHANGED" value="" required="No" tabindex="34">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="WARRANTYRESTRICTIONS" id="WARRANTYRESTRICTIONS" value="#GetHardwareWarranty.WARRANTYRESTRICTIONS#" align="LEFT" required="NO" size="50" maxlength="600" tabindex="35">
			</TD>
               			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="WARRANTYCOMMENTSCHANGED" id="WARRANTYCOMMENTSCHANGED" value="" required="No" tabindex="36">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFTEXTAREA name="WARRANTYCOMMENTS" id="WARRANTYCOMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="37">#GetHardwareWarranty.WARRANTYCOMMENTS#</CFTEXTAREA>
			</TD>

		<CFELSE>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">&nbsp;&nbsp;</TD>
		</CFIF>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Customer and Modifier</LEGEND>
	<TABLE width="100%" border="0">	
		<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="CUSTOMERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERID">Assigned Customer</LABEL>
			</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="COMMENTSCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Comments</LABEL>
			</TH>
 		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="CUSTOMERCHANGED" id="CUSTOMERCHANGED" value="" required="No" tabindex="38">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#GetHardware.CUSTOMERID#" required="No" tabindex="39"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="COMMENTSCHANGED" id="COMMENTSCHANGED" value="" required="No" tabindex="40">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" required="No" rows="5" cols="60" tabindex="41">#GetHardware.COMMENTS#</CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4>
			</TH>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Date Checked</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="GetRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="42"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
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
			<TD align="left" colspan="4">
               	<INPUT type="hidden" name="PROCESSHARDWAREINVENTORY" value="MODIFYMULTIPLE" />
                    <INPUT type="image" src="/images/buttonModifyMultiple.jpg" value="MODIFYMULTIPLE" alt="Modify Multiple" tabindex="43" />
               </TD>
		</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">
               	<INPUT type="image" src="/images/buttonDeleteMultiple.jpg" value="DELETEMULTIPLE" alt="Delete Multiple" onClick="return setDeleteMultiple();" tabindex="44" />
               </TD>
		</TR>
		</CFIF>
     </TABLE>
	</FIELDSET>
</CFFORM>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" method="POST">
			<TD align="left" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="45" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>