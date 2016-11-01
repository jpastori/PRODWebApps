<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lookuproommanufcustinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Add/Modify/Delete/Modify Loop Record Preliminary Info in IDT Hardware Inventory --->
<!-- Last modified by John R. Pastori on on 08/11/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/lookuproommanufcustinfo.cfm">
<CFSET CONTENT_UPDATED = "August 11, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Add/Modify/Delete/Modify Loop Record Preliminary Info in IDT Hardware Inventory</TITLE>
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

		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = document.LOOKUP.BARCODENUMBER.value;
			document.LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if (document.LOOKUP.BARCODENUMBER.value == "3065000" || document.LOOKUP.BARCODENUMBER.value.length != 17) {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  A 17 character Bar Code Number MUST be entered! Spaces are counted.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}
		if (document.LOOKUP.EQUIPMENTLOCATIONID.selectedIndex == "0") {
			alertuser (document.LOOKUP.EQUIPMENTLOCATIONID.name +  ",  A Room Number MUST be Selected!");
			document.LOOKUP.EQUIPMENTLOCATIONID.focus();
			return false;
		}
		if (document.LOOKUP.MANUFACTURERID.selectedIndex == "0") {
			alertuser (document.LOOKUP.MANUFACTURERID.name +  ",  A Manufacturer's Name MUST be Selected!");
			document.LOOKUP.MANUFACTURERID.focus();
			return false;
		}
		if (document.LOOKUP.CUSTOMERID.selectedIndex == "0") {
			alertuser (document.LOOKUP.CUSTOMERID.name +  ",  A Customer's Name MUST be Selected!");
			document.LOOKUP.CUSTOMERID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF IsDefined('URL.ROOMMANUFCUSTCHANGED') AND (URL.PROCESS EQ "MODIFYDELETE" OR URL.PROCESS EQ "MODIFYLOOP")>
	<CFSET CURSORFIELD = "document.LOOKUP.EQUIPMENTLOCATIONID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOCATIONID, ROOMNUMBER, BUILDINGNAMEID
	FROM		LOCATIONS
	ORDER BY	ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListVendors" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT 	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
	FROM		VENDORS
	ORDER BY	VENDORNAME
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

<!--- 
****************************************************************************
* The following code is the Look Up Modify Process for Hardware Inventory. *
****************************************************************************
 --->

<CFIF IsDefined('ROOMMANUFCUSTCHANGED')>
	<CFSET PROGRAMNAME = "hardwareinventoryinfo.cfm">
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF URL.PROCESS EQ 'MODIFYLOOP'>
			<CFSET PROGRAMNAME = "inventorymultiplemodloop.cfm">
			<TD align="center"><H1>Modify Loop Prelim Info in IDT Hardware Inventory</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Prelim Info in IDT Hardware Inventory</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>
	<BR clear="left" />
	<TABLE width="100%" align="LEFT" border="0">
<CFFORM name="LOOKUP" action="/#application.type#apps/hardwareinventory/#PROGRAMNAME#?PROCESS=#URL.PROCESS#&ROOMMANUFCUSTCHANGED=YES&LOOKUPBARCODE=FOUND" method="POST">
		<TR>
			<TH align="left"><H4><LABEL for="EQUIPMENTLOCATIONID">*Room Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD>
				<CFSELECT name="EQUIPMENTLOCATIONID" id="EQUIPMENTLOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#URL.LOCATIONID#" required="No" tabindex="1"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MANUFACTURERID">*Manufacturer</LABEL></TH>
		</TR>
		<TR>
			<TD>
				<CFSELECT name="MANUFACTURERID" id="MANUFACTURERID" size="1" query="ListVendors" value="VENDORID" display="VENDORNAME" selected="#URL.MANUFACTURERID#" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="WARRANTYVENDORID">Warr. Vendor</LABEL></TH>
		</TR>
		<TR>
			<TD>
				<CFSELECT name="WARRANTYVENDORID" id="WARRANTYVENDORID" size="1" query="ListVendors" value="VENDORID" display="VENDORNAME" selected="#URL.WARRANTYVENDORID#" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="CUSTOMERID">*Customer</LABEL></H4></TH>
		</TR>
		<TR>
			<TD>
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#URL.CUSTOMERID#" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="6" />
			</TD>
          </TR>
</CFFORM>
	</TABLE>

<CFELSE>

<!--- 
*************************************************************************
* The following code is the Look Up Add Process for Hardware Inventory. *
*************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH  align="center"><H1>Add Prelim Info in IDT Hardware Inventory</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TD align="center"><H4>*Red fields marked with asterisks are required!</H4></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
		<TR>
			<TH align="LEFT"><H4><LABEL for="BARCODENUMBER">*New Bar Code Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="LEFT"><CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="2"></TD>
		</TR>
		<TR>
		<TH align="left"><LABEL for="STATEFOUNDNUMBER">New State Found Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="LEFT"><H4><LABEL for="EQUIPMENTLOCATIONID">*Room Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="EQUIPMENTLOCATIONID" id="EQUIPMENTLOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="LEFT"><H4><LABEL for="MANUFACTURERID">*Manufacturer</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="MANUFACTURERID" id="MANUFACTURERID" size="1" query="ListVendors" value="VENDORID" display="VENDORNAME" selected="0" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="LEFT"><LABEL for="WARRANTYVENDORID">Warranty Vendor</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="WARRANTYVENDORID" id="WARRANTYVENDORID" size="1" query="ListVendors" value="VENDORID" display="VENDORNAME" selected="0" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="LEFT"><H4><LABEL for="CUSTOMERID">*Customer</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="9" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="10" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>