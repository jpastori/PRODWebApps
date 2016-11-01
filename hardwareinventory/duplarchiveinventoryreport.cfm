<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: duplarchiveinventoryreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Duplicate From Archive To Inventory Records Report --->
<!-- Last modified by John R. Pastori on 07/12/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/duplarchiveinventoryreport.cfm">
<CFSET CONTENT_UPDATED = "July 12, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Duplicate From Archive To Inventory Records Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY>

<CFOUTPUT>

<!--- 
******************************************************************************************************
* The following code is the report generation process for Duplicate Inventory/Archive Records Report.*
******************************************************************************************************
 --->

<CFQUERY name="LookupArchive" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	IA.HARDWAREID, IA.BARCODENUMBER
	FROM		INVENTORYARCHIVE IA
	WHERE	IA.HARDWAREID > 0
	ORDER BY	IA.BARCODENUMBER
</CFQUERY>

<CFSET linecount = 0>

<!--- 
*****************************************************************************************************
* The following code is the Inventory Salvage Report for Duplicate Inventory/Archive Records Report.*
*****************************************************************************************************
 --->
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TH align="center"><H1>Duplicate From Archive To Inventory Records Report</H1></TH>
	</TR>
	
</TABLE>
<BR />
<TABLE width="100%" align="LEFT">
	<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="10">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" valign="BOTTOM">Bar Code Number</TH>
		<TH align="CENTER" valign="BOTTOM">State Found Number</TH>
		<TH align="CENTER" valign="BOTTOM">Serial Number</TH>
		<TH align="CENTER" valign="BOTTOM">Division Number</TH>
		<TH align="CENTER" valign="BOTTOM">Equipment Type</TH>
		<TH align="CENTER" valign="BOTTOM">Date Received</TH>
		<TH align="left" valign="BOTTOM">Customer</TH>
		<TH align="CENTER" valign="BOTTOM">Location Name</TH>
		<TH align="CENTER" valign="BOTTOM">Date Checked</TH>
		<TH align="left" valign="BOTTOM">Comments</TH>
	</TR>
<CFLOOP query="LookupArchive">

	<CFQUERY name="LookupInventory" datasource="#application.type#HARDWARE">
		SELECT	HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTLOCATIONID,
				LOC.LOCATIONID, LOC.LOCATIONNAME, HI.EQUIPMENTTYPEID, ET.EQUIPTYPEID, ET.EQUIPMENTTYPE,
				TO_CHAR(HI.DATERECEIVED, 'DD-MON-YYYY HH24:MI:SS') AS DATERECEIVED, HI.CUSTOMERID, CUST.CUSTOMERID,
				CUST.FULLNAME, HI.COMMENTS, TO_CHAR(HI.DATECHECKED, 'DD-MON-YYYY HH24:MI:SS')AS DATECHECKED
		FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET, FACILITIESMGR.LOCATIONS LOC
		WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#LookupArchive.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID
		ORDER BY	HI.BARCODENUMBER
	</CFQUERY>

	<CFIF #LookupInventory.RecordCount# GT 0>
		<CFSET linecount = linecount + 1>
	<TR>
		<TD align="left" valign="TOP" nowrap><DIV>#LookupInventory.BARCODENUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupInventory.STATEFOUNDNUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupInventory.SERIALNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupInventory.DIVISIONNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupInventory.EQUIPMENTTYPE#</DIV></TD>
		<TD align="left" valign="MIDDLE"><DIV>#DateFormat(LookupInventory.DATERECEIVED, "MM/DD/YYYY")#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupInventory.FULLNAME#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupInventory.LOCATIONNAME#</DIV></TD>
		<TD align="left" valign="MIDDLE"><DIV>#DateFormat(LookupInventory.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
		<TD align="left" valign="MIDDLE"><DIV>#LookupInventory.COMMENTS#</DIV></TD>
	</TR>
	<TR>
		<TD colspan="11"><HR width="100%" size="5" noshade /></TD>
	</TR>
	</CFIF>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="10"><H2>#linecount# Duplicate Barcodes were found in the Inventory Table.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="10">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="10">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>