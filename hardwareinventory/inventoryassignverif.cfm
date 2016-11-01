<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventoryassignverif.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory - Assignment Verification --->
<!-- Last modified by John R. Pastori on on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventoryassignverif.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory - Assignment Verification</TITLE>
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


	function submitBarcode() {		 
		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = document.LOOKUP.BARCODENUMBER.value;
			document.LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
			document.LOOKUP.submit();
		}

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
	<CFSET CURSORFIELD = "document.HARDWAREINVENTORY.STATEFOUNDNUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
*********************************************************************************************
* The following code is the Look Up Process for Hardware Inventory Assignment Verification. *
*********************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Lookup for IDT Hardware Inventory - Assignment Verification</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/hardwareinventory/inventoryassignverif.cfm?LOOKUPBARCODE=FOUND" method="POST">
		<TR>
			<TH align="LEFT"><H4><LABEL for="BARCODENUMBER">*Lookup Bar Code Number</LABEL></H4></TH>
		</TR>
          <TR>
			<TD align="LEFT"><CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="" align="LEFT" onKeyUp="submitBarcode();" required="No" size="17" maxlength="17" tabindex="2"></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="3" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
			<TD align="LEFT"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	<CFEXIT>
     
<CFELSE>

<!--- 
********************************************************************************************
* The following code is the Modify Process for Hardware Inventory Assignment Verification. *
********************************************************************************************
 --->


	<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HARDWAREID, CREATIONDATE, BARCODENUMBER, STATEFOUNDNUMBER, SERIALNUMBER, DIVISIONNUMBER,
				CLUSTERNAME, MACHINENAME, EQUIPMENTLOCATIONID, MACADDRESS, AIRPORTID, BLUETOOTHID, EQUIPMENTTYPEID,
				DESCRIPTIONID, MODELNAMEID, MODELNUMBERID, SPEEDNAMEID, MANUFACTURERID, DELLEXPRESSSERVICE, WARRANTYVENDORID,
				REQUISITIONNUMBER, PURCHASEORDERNUMBER, DATERECEIVED, FISCALYEARID, CUSTOMERID, COMMENTS,
				OWNINGORGID, MODIFIEDBYID, DATECHECKED, IPADDRESS
		FROM		HARDWAREINVENTORY
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#FORM.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="GetEquipmentTypes" datasource="#application.type#HARDWARE" blockfactor="13">
		SELECT	EQUIPTYPEID, EQUIPMENTTYPE
		FROM		EQUIPMENTTYPE
          WHERE	EQUIPTYPEID = <CFQUERYPARAM value="#GetHardware.EQUIPMENTTYPEID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	EQUIPMENTTYPE
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
	
	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERS.CUSTOMERID, CUSTOMERS.LASTNAME, CUSTOMERS.FULLNAME, UNITS.UNITNAME, GROUPS.GROUPNAME, CUSTOMERS.CAMPUSPHONE,
				LOCATIONS.ROOMNUMBER, CUSTOMERS.EMAIL
		FROM		CUSTOMERS, UNITS, GROUPS, FACILITIESMGR.LOCATIONS
		WHERE	CUSTOMERS.UNITID = UNITS.UNITID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				CUSTOMERS.LOCATIONID = LOCATIONS.LOCATIONID
		ORDER BY	LASTNAME
	</CFQUERY>
	
	<CFQUERY name="GetHardwareAttachedTo" datasource="#application.type#HARDWARE" blockfactor="6">
		SELECT	ATTACHEDTOID, BARCODENUMBER, ATTACHEDTO
		FROM		HARDWAREATTACHEDTO
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#GetHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFSET DisplayHardwareAttachedToArray=ArrayNew(1)>
	<CFSET StoreHardwareAttachedToKeyArray=ArrayNew(1)>
	<CFSET temp = ArraySet(DisplayHardwareAttachedToArray, 1, 4, 0)> 
	<CFSET temp = ArraySet(StoreHardwareAttachedToKeyArray, 1, 4, 0)>
	<CFLOOP query="GetHardwareAttachedTo">
		<CFSET DisplayHardwareAttachedToArray[CurrentRow]=GetHardwareAttachedTo.ATTACHEDTO[CurrentRow]>
		<CFSET StoreHardwareAttachedToKeyArray[CurrentRow]=GetHardwareAttachedTo.ATTACHEDTOID[CurrentRow]>
	</CFLOOP>

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
			<TH align="center"><H1>Modify Existing Record in IDT Hardware Inventory</H1></TH>
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
<CFFORM action="/#application.type#apps/hardwareinventory/inventoryassignverif.cfm" method="POST">
			<TD align="left" valign="bottom" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="HARDWAREINVENTORY" action="/#application.type#apps/hardwareinventory/processhardwareinventoryinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Bar Code Number</TH>
			<TH align="left"><LABEL for="STATEFOUNDNUMBER">State Found Number</LABEL></TH>
		</TR>
		<TR>
			<CFCOOKIE name="HARDWAREID" secure="NO" value="#GetHardware.HARDWAREID#">
			<TD align="left">
               	<INPUT type="hidden" name="BARCODENUMBER" value="#GetHardware.BARCODENUMBER#" />
               	#GetHardware.BARCODENUMBER#
               </TD>
			<TD align="left"><CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="#GetHardware.STATEFOUNDNUMBER#" align="LEFT" required="No" size="25" maxlength="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="SERIALNUMBER">Serial Number</LABEL></TH>
			<TH align="left"><LABEL for="DIVISIONNUMBER">Division Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="#GetHardware.SERIALNUMBER#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
			<TD align="left"><CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="#GetHardware.DIVISIONNUMBER#" align="LEFT" required="No" size="50" tabindex="4"></TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="CLUSTERNAME">Cluster</LABEL></TH>
			<TH align="left"><LABEL for="EQUIPMENTLOCATIONID">Location</LABEL></TH>
		</TR>
		<TR>
          	<TD align="left"><CFINPUT type="Text" name="CLUSTERNAME" id="CLUSTERNAME" value="#GetHardware.CLUSTERNAME#" align="LEFT" required="No" size="50" tabindex="5"></TD>
			<TD align="left">
               	<CFSELECT name="EQUIPMENTLOCATIONID" id="EQUIPMENTLOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetHardware.EQUIPMENTLOCATIONID#" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left">Equipment Type</TH>
			<TH align="left"><LABEL for="CUSTOMERID">Customer</LABEL></TH>
		</TR>
		<TR>
			<TD>
				#GetEquipmentTypes.EQUIPMENTTYPE#
			</TD>
			<TD>
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#GetHardware.CUSTOMERID#" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="COMMENTS">Comments</LABEL></TH>
			<TH align="left">Equipment Attached To</TH>
		</TR>
		<TR>
               <TD align="left"><CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="8">#GetHardware.COMMENTS#</CFTEXTAREA></TD>
               <TD align="left">
                    <CFLOOP index="Counter" from=1 to=4>
                         <INPUT type="hidden" name="StoreHardwareAttachedToKey#Counter#" value="#StoreHardwareAttachedToKeyArray[Counter]#" />
                         <CFSET TAB = #Counter# + 8>
                         <LABEL for="ATTACHEDTO#Counter#" class="LABEL_hidden">Equipment Attached To #Counter#</LABEL>
                         <CFSELECT name="ATTACHEDTO#Counter#" id="ATTACHEDTO#Counter#" size="1" query="ListHardwareAttachedTo" value="HARDWAREID" display="ATTACHEDHARDWARE" selected="#DisplayHardwareAttachedToArray[Counter]#" required="No" tabindex="#val(TAB)#"></CFSELECT><BR />
                    </CFLOOP>
          	</TD>
		<TR>
			<TH align="left"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
			<TH align="left">Date Checked</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="GetRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="13"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.DATECHECKED = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="DATECHECKED" value="#FORM.DATECHECKED#" />
				#DateFormat(FORM.DATECHECKED, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left" valign="bottom">
               	<INPUT type="hidden" name="PROCESSHARDWAREINVENTORYVERIFY" value="MODIFY" />
                    <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="14" />
			</TD>
		</TR>
</CFFORM>	
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/inventoryassignverif.cfm" method="POST">
			<TD align="left" valign="bottom" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="15" /><BR />
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