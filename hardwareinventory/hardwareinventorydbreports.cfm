<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hardwareinventorydbreports.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory Departmental & Unit/Customer Reports --->
<!-- Last modified by John R. Pastori on 03/26/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm">
<CFSET CONTENT_UPDATED = "March 26, 2015">

<CFIF (FIND('wiki', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "WIKI")>
	<CFSET SESSION.ORIGINSERVER = "WIKI">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSEIF (FIND('#application.type#apps/forms', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "FORMS")>
	<CFSET SESSION.ORIGINSERVER = "FORMS">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSE>
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET SESSION.ORIGINSERVER = "">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
</CFIF>

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory Departmental & Unit/Customer Report Selection Lookup</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		if ((document.LOOKUP.REPORTCHOICE[0].checked == "0"      && document.LOOKUP.REPORTCHOICE[1].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[3].checked == "0"       && document.LOOKUP.REPORTCHOICE[4].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[5].checked == "0"       && document.LOOKUP.REPORTCHOICE[6].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[7].checked == "0"       && document.LOOKUP.REPORTCHOICE[8].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[9].checked == "0"       && document.LOOKUP.REPORTCHOICE[11].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[12].checked == "0"      && document.LOOKUP.REPORTCHOICE[13].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[14].checked == "0"      && document.LOOKUP.REPORTCHOICE[15].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[16].checked == "0")
		 && (document.LOOKUP.BARCODENUMBER.value == "3065000"
		 && document.LOOKUP.STATEFOUNDNUMBER.value == ""         && document.LOOKUP.SERIALNUMBER.value == ""
		 && document.LOOKUP.DIVISIONNUMBER.value == ""           && document.LOOKUP.BUILDINGNAMEID.selectedIndex == "0"
		 && document.LOOKUP.LOCATIONID.selectedIndex == "0"      && document.LOOKUP.ROOMNUMBER.value == ""
		 && document.LOOKUP.MACADDRESS.value == ""               && document.LOOKUP.IPADDRESS.value == ""
		 && document.LOOKUP.AIRPORTID.value == ""                && document.LOOKUP.BLUETOOTHID.value == ""
		 && document.LOOKUP.EQUIPMENTTYPE.value == ""            
		 && document.LOOKUP.DESCRIPTION.value == ""              && document.LOOKUP.CLUSTERNAME.value == ""
		 && document.LOOKUP.MODELNAME.value == ""                && document.LOOKUP.MODELNUMBER.value == ""
		 && document.LOOKUP.SPEEDNAMEID.selectedIndex == "0"     && document.LOOKUP.SIZENAMEID.selectedIndex == "0"
		 && document.LOOKUP.INTERFACENAMEID.selectedIndex == "0" && document.LOOKUP.PERIPHERALNAMEID.selectedIndex == "0"
		 && document.LOOKUP.REQUISITIONNUMBER.value == ""        && document.LOOKUP.PURCHASEORDERNUMBER.value == ""
		 && document.LOOKUP.DATERECEIVED.value == ""			  && document.LOOKUP.WARRANTYEXPIRATIONDATE.value == ""
		 && document.LOOKUP.WARRANTYRESTRICTIONS.value == ""     && document.LOOKUP.WARRANTYVENDORNAME.value == ""
		 && document.LOOKUP.WARRANTYCOMMENTS.value == ""         && document.LOOKUP.COMMENTS.value == ""
		 && document.LOOKUP.FISCALYEARID.selectedIndex == "0"    
		 && document.LOOKUP.CUSTOMERID.selectedIndex == "0"      && document.LOOKUP.CUSTOMERCATEGORY.value == ""
		 && document.LOOKUP.CUSTOMERFIRSTNAME.value == ""        && document.LOOKUP.CUSTOMERLASTNAME.value == ""
		 && document.LOOKUP.UNITID.selectedIndex == "0"          && document.LOOKUP.UNITNUMBER.value == ""
		 && document.LOOKUP.OWNINGORGID.selectedIndex == "0"     && document.LOOKUP.MODIFIEDBYID.selectedIndex == "0"
		 && document.LOOKUP.DATECHECKED.value == "")) {
			alertuser ("You must enter information in one of the thirty-eight (38) fields!");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

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
*****************************************************************************
* The following code is the Look Up Process for Hardware Inventory Reports. *
*****************************************************************************
 --->

<CFINCLUDE template = "hardwareinventorylookup.cfm">

<!--- 
***************************************************************
* The following code displays the Hardware Inventory Reports. *
***************************************************************
 --->

<CFIF (NOT IsDefined('URL.LOOKUPBARCODE')) OR (IsDefined('session.ENDPGM') AND #session.ENDPGM# EQ "YES")>
	<CFEXIT>
<CFELSE>
<CFSWITCH expression = #FORM.REPORTCHOICE#>
	<CFCASE value = 1>
		<CFINCLUDE template="barcodereport.cfm">
	</CFCASE>
	<CFCASE value = 2>
		<CFINCLUDE template="opcounttypedescr.cfm">
	</CFCASE>
	<CFCASE value = 3>
		<CFINCLUDE template="nonopcounttypedescr.cfm">
	</CFCASE>
	<CFCASE value = 4>
		<CFINCLUDE template="purchasewarrantyreport.cfm">
	</CFCASE>
	<CFCASE value = 5>
		<CFIF #FORM.IPADDRESS# NEQ "" OR #FORM.MACADDRESS# NEQ "" >
			<CFINCLUDE template="networkipaddressreport.cfm">
		<CFELSE>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("A partial IP address or a full MAC Address MUST be entered in either the IP Address or MAC Address text box for this report to run.");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" />
		</CFIF>
	</CFCASE>
	<CFCASE value = 6>
		<CFIF #FORM.ROOMNUMBER# NEQ "">
			<CFINCLUDE template="statefoundidsurveyreport.cfm">
		<CFELSE>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("At least one room must be entered in the Room Number Text Box for this report to run.");
					document.LOOKUP.ROOMNUMBER.focus();
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" />
		</CFIF>
	</CFCASE>
	<CFCASE value = 7>
		<CFINCLUDE template="speedsizesreport.cfm">
	</CFCASE>
	<CFCASE value = 8>
		<CFINCLUDE template="interfperphreport.cfm">
	</CFCASE>
	<CFCASE value = 9>
		<CFINCLUDE template="unitcurrentassignedreport.cfm">
	</CFCASE>
	<CFCASE value = 10>
		<CFINCLUDE template="currentassignedreport.cfm">
	</CFCASE>
	<CFCASE value = 11>
		<CFINCLUDE template="divisioncurrassignedreport.cfm">
	</CFCASE>
     <CFCASE value = 12>
		<CFINCLUDE template="statefoundnumcurrassignrpt.cfm">
	</CFCASE>
	<CFCASE value = 13>
		<CFINCLUDE template="custhardwarereport.cfm">
	</CFCASE>
	<CFCASE value = 14>
		<CFINCLUDE template="publicuseprintersreport.cfm">
	</CFCASE>
	<CFCASE value = 15>
		<CFINCLUDE template="publicusebytypelocreport.cfm">
	</CFCASE>
     <CFCASE value = 16>
		<CFINCLUDE template="publicusebytypelocreport.cfm">
	</CFCASE>
	<CFDEFAULTCASE>
		<CFINCLUDE template="barcodereport.cfm">
	</CFDEFAULTCASE>
</CFSWITCH>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>