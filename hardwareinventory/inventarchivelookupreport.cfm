<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventarchivelookupreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Archive Lookup Report for IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventarchivelookupreport.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF #URL.ARCHIVE# EQ 'FORWARD'>
		<TITLE>Inventory To Archive Confirmation</TITLE>
	<CFELSE>
		<TITLE>Archive To Inventory Confirmation</TITLE>
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
		Confirmation screen and re-enter your selection criteria."
	<SCRIPT language="JavaScript">
		<!-- 
		alert("More than 1000 records were selected and this is not allowed by ORACLE. Close this screen, Click Cancel on the 
		Modify screen and re-enter your selection criteria.");
		--> 
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF IsDefined('URL.ARCHIVE') AND URL.ARCHIVE EQ "FORWARD">
	<CFSET TABLENAME ='HARDWAREINVENTORY'>
<CFELSE>
	<CFSET TABLENAME ='INVENTORYARCHIVE'>
</CFIF>

<CFQUERY name="LookupArchiveLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ARCHIVELOCATION
	FROM		LOCATIONS LOC
	WHERE	LOC.ARCHIVELOCATION = 'YES'
	ORDER BY	LOC.LOCATIONID
</CFQUERY>

<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.EQUIPMENTLOCATIONID,
			LOC.LOCATIONID, LOC.LOCATIONNAME, HI.EQUIPMENTTYPEID, ET.EQUIPTYPEID, ET.EQUIPMENTTYPE, HI.REQUISITIONNUMBER,
			HI.PURCHASEORDERNUMBER, HI.COMMENTS, HI.MODIFIEDBYID, MOD.CUSTOMERID, MOD.FULLNAME AS MODNAME, HI.DATECHECKED
	FROM		#TABLENAME# HI, EQUIPMENTTYPE ET, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS MOD
	WHERE	HI.HARDWAREID IN (#URL.HARDWAREIDS#) AND
			HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
			HI.EQUIPMENTLOCATIONID IN (#ValueList(LookupArchiveLocations.LOCATIONID)#) AND
			HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
			HI.MODIFIEDBYID = MOD.CUSTOMERID
	ORDER BY	HI.BARCODENUMBER
</CFQUERY>

<!--- 
**************************************************************************
* The following code is the Archive Lookup Report for Hardware Inventory *
**************************************************************************
 --->
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TH align="center">
			<CFIF #URL.ARCHIVE# EQ 'FORWARD'>
				<H1>Inventory To Archive Lookup Report
			<CFELSE>
				<H1>Archive To Inventory Lookup Report
			</CFIF>
		</TH>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" align="LEFT">
	<TR>
          <TD align="LEFT" colspan="5">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
          </TD>
     </TR>
	<TR>
		<TH align="CENTER" colspan="5"><H2>#ListHardware.RecordCount# hardware records were selected.</H2></TH>
	</TR>

<CFLOOP query="ListHardware">

	<TR>
		<TH align="CENTER">Bar Code Number</TH>
		<TH align="CENTER">State Found Number</TH>
		<TH align="CENTER">Serial Number</TH>
		<TH align="CENTER">Equipment Type</TH>
		<TH align="CENTER">Location Name</TH>
	</TR>
	<TR>
		<TD align="CENTER" valign="TOP" nowrap><DIV>#ListHardware.BARCODENUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.STATEFOUNDNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.SERIALNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.EQUIPMENTTYPE#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.LOCATIONNAME#</DIV></TD>
	</TR>
	<TR>
		<TH align="CENTER">Requisition Number</TH>
		<TH align="CENTER">Purchase Order Number</TH>
		<TH align="CENTER">Modified By</TH>
		<TH align="CENTER">Date Checked</TH>
		<TH align="CENTER">Comments</TH>
	</TR>
	<TR>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.REQUISITIONNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.PURCHASEORDERNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.MODNAME#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#DateFormat(ListHardware.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.COMMENTS#</DIV></TD>
	</TR>
	<TR>
		<TD colspan="5"><HR /></TD>
	</TR>
</CFLOOP>
	<TR>
		<TD colspan="5"><HR width="100%" size="5" noshade /></TD>
	</TR>
     <TR>
          <TD align="left" colspan="5">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="2" />
          </TD>
     </TR>
	<TR>
		<TH align="CENTER" colspan="5"><H2>#ListHardware.RecordCount# hardware records were selected.</H2></TH>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>