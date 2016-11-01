<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventmultiplelookupreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/01/2012 --->
<!--- Date in Production: 08/01/2012 --->
<!--- Module: Multiple Record Lookup Report for IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on on 07/17/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventmultiplelookupreport.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'MODIFYLOOP'>
		<TITLE>Multiple Record Modify Loop Lookup Report for IDT Hardware Inventory</TITLE>
	<CFELSEIF URL.PROCESS EQ 'MODIFYMULTIPLE'>
		<TITLE>Multiple Record Modify/Delete Lookup Report for IDT Hardware Inventory</TITLE>
	<CFELSE>
		<TITLE>Inventory Archive Lookup Report for IDT Hardware Inventory</TITLE>
	</CFIF>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";


//
</SCRIPT>
<!--Script ends here -->

<BODY>

<CFOUTPUT>
<CFIF ListLen(URL.HARDWAREIDS) GT 1000>
	<H1>More than 1000 records were selected and this is not allowed by ORACLE. Close this screen, Click Cancel on the 
		Modify screen and re-enter your selection criteria."
	<SCRIPT language="JavaScript">
		<!-- 
		alert("More than 1000 records were selected and this is not allowed by ORACLE. Close this screen, Click Cancel on the Modify screen and re-enter your selection criteria.");
		--> 
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF IsDefined('URL.PROCESS') AND URL.PROCESS EQ "ARCHIVEINVENTORY">
	<CFSET TABLENAME ='INVENTORYARCHIVE'>
<CFELSE>
	<CFSET TABLENAME ='HARDWAREINVENTORY'>
</CFIF>

<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
			HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID, LOC.LOCATIONNAME,
			HI.MACADDRESS, HI.EQUIPMENTTYPEID, ET.EQUIPTYPEID, ET.EQUIPMENTTYPE, HI.DESCRIPTIONID, ED.EQUIPDESCRID,
			ED.EQUIPMENTDESCRIPTION, HI.MODELNAMEID, MNL.MODELNAMEID, MNL.MODELNAME, HI.MODELNUMBERID, MUL.MODELNUMBERID,
			MUL.MODELNUMBER, HI.SPEEDNAMEID, SNL.SPEEDNAMEID, SNL.SPEEDNAME, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE,
			HI.WARRANTYVENDORID, VENDORS.VENDORNAME, HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER, HI.DATERECEIVED,
			HI.FISCALYEARID, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.UNITID, HI.COMMENTS, HI.OWNINGORGID,
			HI.MODIFIEDBYID, MOD.CUSTOMERID, MOD.FULLNAME AS MODNAME, HI.DATECHECKED, HI.IPADDRESS
	FROM		#TABLENAME# HI, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED, MODELNAMELIST MNL, LIBSHAREDDATAMGR.CUSTOMERS CUST,
			MODELNUMBERLIST MUL, SPEEDNAMELIST SNL, PURCHASEMGR.VENDORS VENDORS, FACILITIESMGR.LOCATIONS LOC,
			LIBSHAREDDATAMGR.CUSTOMERS MOD
	WHERE	HI.HARDWAREID IN (#URL.HARDWAREIDS#) AND
			HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
			HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
			HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
			HI.MODELNAMEID = MNL.MODELNAMEID AND
			HI.MODELNUMBERID = MUL.MODELNUMBERID AND
			HI.SPEEDNAMEID = SNL.SPEEDNAMEID AND
			HI.WARRANTYVENDORID = VENDORS.VENDORID AND
			HI.CUSTOMERID = CUST.CUSTOMERID AND
			HI.MODIFIEDBYID = MOD.CUSTOMERID
	ORDER BY	HI.BARCODENUMBER
</CFQUERY>

<!--- 
***************************************************************************************************************
* The following code is used to create the Modify Loop, Multiple Modify/Delete and Archive/Inventory Reports. *
***************************************************************************************************************
 --->
<TABLE width="100%" align="center" border="3">
	<TR align="center">
	<CFIF URL.PROCESS EQ 'MODIFYLOOP'>
		<TH align="center"><H1>Multiple Record Modify Loop Lookup Report</H1></TH>
	<CFELSEIF URL.PROCESS EQ 'MODIFYMULTIPLE'>
		<TH align="center"><H1>Multiple Record Modify/Delete Lookup Report</H1></TH>
	<CFELSE>
		<TH align="center"><H1>Inventory Archive Report</H1></TH>
	</CFIF>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" align="LEFT">
	<TR>
          <TD align="LEFT" colspan="12">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
          </TD>
     </TR>
	<TR>
	
		<TH align="CENTER" colspan="12"><H2>#ListHardware.RecordCount# hardware records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="CENTER" valign="BOTTOM">Bar Code Number</TH>
		<TH align="CENTER" valign="BOTTOM">State Found Number</TH>
		<TH align="CENTER" valign="BOTTOM">Serial Number</TH>
		<TH align="CENTER" valign="BOTTOM">Division Number</TH>
		<TH align="CENTER" valign="BOTTOM">Location Name</TH>
		<TH align="CENTER" valign="BOTTOM">Equipment Type</TH>
		<TH align="CENTER" valign="BOTTOM">Description</TH>
		<TH align="CENTER" valign="BOTTOM">Model</TH>
		<TH align="CENTER" valign="BOTTOM">Model Number</TH>
		<TH align="CENTER" valign="BOTTOM" colspan="2">Warr. Vendor</TH>
          <TH align="CENTER" valign="BOTTOM">Cluster</TH>
	</TR>

<CFLOOP query="ListHardware">
	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	UNITS.UNITID, UNITS.UNITNAME
		FROM		UNITS
		WHERE	UNITS.UNITID = <CFQUERYPARAM value="#ListHardware.UNITID#" cfsqltype="CF_SQL_NUMERIC">
	</CFQUERY>

	<CFQUERY name="LookupHardwareWarranty" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
		FROM		HARDWAREWARRANTY
		WHERE	BARCODENUMBER = <CFQUERYPARAM value="#ListHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BARCODENUMBER
	</CFQUERY>

	<CFQUERY name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
		SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
		FROM		ORGCODES
		WHERE	ORGCODEID = <CFQUERYPARAM value="#ListHardware.OWNINGORGID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	ORGCODE
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

	<TR>
		<TD align="left" valign="TOP" nowrap><DIV>#ListHardware.BARCODENUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListHardware.STATEFOUNDNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.SERIALNUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListHardware.DIVISIONNUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListHardware.LOCATIONNAME#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.EQUIPMENTTYPE#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListHardware.EQUIPMENTDESCRIPTION#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.MODELNAME#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.MODELNUMBER#</DIV></TD>
		<TD align="left" valign="TOP" colspan="2">
		<CFIF ListHardware.WARRANTYVENDORID GT 0>
			<DIV>#ListHardware.VENDORNAME#</DIV>
		<CFELSE>
			&nbsp;&nbsp;
		</CFIF>
		</TD>
          <TD align="CENTER" valign="TOP"><DIV>#ListHardware.CLUSTERNAME#</DIV></TD>
	</TR>
	<TR>
		<TH align="left" valign="TOP">Requisition Number:</TH>
		<TD align="left" valign="TOP">
			<DIV>#ListHardware.REQUISITIONNUMBER#</DIV>
		</TD>
		<TH align="left" valign="TOP">Purchase Order Number:</TH>
		<TD align="left" valign="TOP">
			<DIV>#ListHardware.PURCHASEORDERNUMBER#</DIV>
		</TD>
		<TH align="left" valign="TOP">Customer:</TH>
		<TD align="left" valign="TOP"><DIV>#ListHardware.FULLNAME#</DIV></TD>
		<TH align="left" valign="TOP">Unit:</TH>
		<TD align="left" valign="TOP" colspan="2"><DIV>#LookupUnits.UNITNAME#</DIV></TD>
		<TH align="left" valign="TOP">Owning Org. Code:</TH>
		<TD align="left" valign="TOP" colspan="2"><DIV>#ListOrgCodes.ORGCODENAME#</DIV></TD>
	</TR>
	<TR>
		<TH align="left" valign="TOP">Modified By:</TH>
		<TD align="left" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
		<TH align="left" valign="TOP">Date Checked:</TH>
		<TD align="left" valign="TOP"><DIV>#DateFormat(ListHardware.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
		<TH align="left" valign="TOP">Warr. Comments:</TH>
		<TD align="left" valign="TOP"><DIV>#LookupHardwareWarranty.WARRANTYCOMMENTS#</DIV></TD>
		<TH align="left" valign="TOP">Warr. Expiration Date:</TH>
		<TD align="left" valign="TOP"><DIV>#DateFormat(LookupHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#</DIV></TD>
		<TH align="left" valign="TOP">Warr. Restrictions:</TH>
		<TD align="left" valign="TOP"><DIV>#LookupHardwareWarranty.WARRANTYRESTRICTIONS#</DIV></TD>
		<TH align="left" valign="TOP">Comments:</TH>
		<TD align="left" valign="TOP"><DIV>#ListHardware.COMMENTS#</DIV></TD>
	</TR>
	<TR>
		<TD colspan="12"><HR width="100%" size="5" noshade /></TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="12"><H2>#ListHardware.RecordCount# hardware records were selected.</H2></TH>
	</TR>
     <TR>
          <TD align="left" colspan="12">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="2" />
          </TD>
     </TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>