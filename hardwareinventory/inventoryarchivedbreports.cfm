<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventoryarchivedbreports.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Inventory Archive Reports --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventoryarchivedbreports.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Inventory Archive Reports Selection Lookup</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = LOOKUP.BARCODENUMBER.value;
			LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if (document.LOOKUP.LOCATIONID.selectedIndex > "0" && document.LOOKUP.ROOMNUMBER.value != "") {
			alertuser ("You CAN NOT both select a Room Number from the Drop Down and enter a Room Number in the text box!");
			document.LOOKUP.LOCATIONID.focus();
			return false;
		}
	}


	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
****************************************************************************
* The following code is the Look Up Process for Inventory Archive Reports. *
****************************************************************************
 --->

<CFINCLUDE template = "hardwareinventorylookup.cfm">

<!--- 
**************************************************************
* The following code displays the Inventory Archive Reports. *
**************************************************************
 --->

<CFIF (NOT IsDefined('URL.LOOKUPBARCODE')) OR (IsDefined('session.ENDPGM') AND #session.ENDPGM# EQ "YES")>
	<CFEXIT>
<CFELSE>
<CFSWITCH expression = #FORM.REPORTCHOICE#>
	<CFCASE value = 1>
		<CFINCLUDE template="barcodereport.cfm">
	</CFCASE>
	<CFCASE value = 4>
		<CFINCLUDE template="purchasewarrantyreport.cfm">
	</CFCASE>
	<CFDEFAULTCASE>
		<CFINCLUDE template="barcodereport.cfm">
	</CFDEFAULTCASE>
</CFSWITCH>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>