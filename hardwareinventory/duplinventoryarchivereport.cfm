<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: duplinventoryarchivereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Duplicate From Inventory To Archive Records Report --->
<!-- Last modified by John R. Pastori on 09/24/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/duplinventoryarchivereport.cfm">
<CFSET CONTENT_UPDATED = "September 24, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Duplicate From Inventory To Archive Records Report</TITLE>
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

<CFIF IsDefined('URL.HARDWAREIDS')>

	<CFQUERY name="LookupInventory" datasource="#application.type#HARDWARE" blockfactor="100">
        SELECT		HI.HARDWAREID, HI.BARCODENUMBER
        FROM		HARDWAREINVENTORY HI
        WHERE		HI.HARDWAREID IN ( #URL.HARDWAREIDS# )
        ORDER BY	HI.BARCODENUMBER
    </CFQUERY>
    
 <CFELSE>
 
    <CFQUERY name="LookupArchiveLocations" datasource="#application.type#FACILITIES" blockfactor="100">
        SELECT		LOC.LOCATIONID, LOC.ARCHIVELOCATION
        FROM		LOCATIONS LOC
        WHERE		LOC.LOCATIONID > 0 AND
                    LOC.ARCHIVELOCATION = 'YES'
        ORDER BY	LOC.LOCATIONID
    </CFQUERY>
    
    <CFQUERY name="LookupInventory" datasource="#application.type#HARDWARE" blockfactor="100">
        SELECT		HI.HARDWAREID, HI.BARCODENUMBER
        FROM		HARDWAREINVENTORY HI
        WHERE		EQUIPMENTLOCATIONID IN (#ValueList(LookupArchiveLocations.LOCATIONID)#)
        ORDER BY	HI.BARCODENUMBER
    </CFQUERY>

</CFIF>

<CFSET linecount = 0>

<!--- 
*****************************************************************************************************
* The following code is the Inventory Salvage Report for Duplicate Inventory/Archive Records Report.*
*****************************************************************************************************
 --->
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TH align="center"><H1>Duplicate From Inventory To Archive Records Report</H1></TH>
	</TR>
	
</TABLE>
<BR />
<TABLE width="100%" align="LEFT">
	<TR>
	<CFIF IsDefined('URL.HARDWAREIDS')>
    	 <TD align="left">
           <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
        </TD>
    <CFELSE>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="10">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</CFIF>
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
<CFLOOP query="LookupInventory">

	<CFQUERY name="LookupArchive" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	IA.BARCODENUMBER, IA.STATEFOUNDNUMBER, IA.SERIALNUMBER, IA.DIVISIONNUMBER, IA.EQUIPMENTLOCATIONID,
				LOC.LOCATIONID, LOC.LOCATIONNAME, IA.EQUIPMENTTYPEID, ET.EQUIPTYPEID, ET.EQUIPMENTTYPE,
				TO_CHAR(IA.DATERECEIVED, 'DD-MON-YYYY HH24:MI:SS') AS DATERECEIVED, IA.CUSTOMERID, CUST.CUSTOMERID,
				CUST.FULLNAME, IA.COMMENTS, TO_CHAR(IA.DATECHECKED, 'DD-MON-YYYY HH24:MI:SS')AS DATECHECKED
		FROM		INVENTORYARCHIVE IA, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET, FACILITIESMGR.LOCATIONS LOC
		WHERE	IA.BARCODENUMBER = <CFQUERYPARAM value="#LookupInventory.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				IA.CUSTOMERID = CUST.CUSTOMERID AND
				IA.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				IA.EQUIPMENTLOCATIONID = LOC.LOCATIONID
		ORDER BY	IA.BARCODENUMBER
	</CFQUERY>

	<CFIF #LookupArchive.RecordCount# GT 0>
		<CFSET linecount = linecount + 1>
	<TR>
		<TD align="left" valign="TOP" nowrap><DIV>#LookupArchive.BARCODENUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupArchive.STATEFOUNDNUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupArchive.SERIALNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupArchive.DIVISIONNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupArchive.EQUIPMENTTYPE#</DIV></TD>
		<TD align="left" valign="MIDDLE"><DIV>#DateFormat(LookupArchive.DATERECEIVED, "MM/DD/YYYY")#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupArchive.FULLNAME#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupArchive.LOCATIONNAME#</DIV></TD>
		<TD align="left" valign="MIDDLE"><DIV>#DateFormat(LookupArchive.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
		<TD align="left" valign="MIDDLE"><DIV>#LookupArchive.COMMENTS#</DIV></TD>
	</TR>
	<TR>
		<TD colspan="11"><HR width="100%" size="5" noshade /></TD>
	</TR>
	</CFIF>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="10"><H2>#linecount# Duplicate Barcodes were found in the Archive Table.</H2></TH>
	</TR>
	<TR>
    <CFIF IsDefined('URL.HARDWAREIDS')>
    	 <TD align="left">
           <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="2" />
        </TD>
    <CFELSE>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="10">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</CFIF>
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