<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: duplswarchiveinventoryreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Duplicate From Archive To Inventory Records Report --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/duplswarchiveinventoryreport.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Duplicate From Archive To Inventory Records Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Software Inventory";


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

<CFQUERY name="LookupSoftwareArchive" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	SOFTWINVENTID, TITLE, UPGRADESTATUSID, TOSSSTATUSID, SOFTWINVENTID || ' - ' || TITLE AS KEYTITLE
	FROM		SOFTWAREARCHIVE
	WHERE	SOFTWINVENTID > 0 AND
			UPGRADESTATUSID IN (9, 12, 14) AND
			TOSSSTATUSID IN (6, 7, 8)
	ORDER BY	KEYTITLE
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
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="9">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" valign="BOTTOM">Software Inventory Key</TH>
		<TH align="CENTER" valign="BOTTOM">Title</TH>
		<TH align="CENTER" valign="BOTTOM">Version</TH>
		<TH align="CENTER" valign="BOTTOM">Platform</TH>
		<TH align="CENTER" valign="BOTTOM">Quantity Licensed</TH>
		<TH align="left" valign="BOTTOM">Requisition Number</TH>
		<TH align="CENTER" valign="BOTTOM">P.O. Number</TH>
		<TH align="CENTER" valign="BOTTOM">Upgrade Status</TH>
		<TH align="CENTER" valign="BOTTOM">Toss Status</TH>
	</TR>
	<TR>
		<TD colspan="9"><HR width="100%" size="5" noshade /></TD>
	</TR>
<CFLOOP query="LookupSoftwareArchive">

	<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID,
				SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
				SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE,
				SI.SOFTWINVENTID || ' - ' || SI.TITLE AS KEYTITLE, SI.SOFTWINVENTID || ' - ' || PR.REQNUMBER AS KEYREQ, 
				SI.SOFTWINVENTID || ' - ' || PR.PONUMBER AS KEYPO
		FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftwareArchive.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SI.UPGRADESTATUSID IN (9, 12, 14) AND
				SI.TOSSSTATUSID IN (6, 7, 8) AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	KEYTITLE
	</CFQUERY>

<CFQUERY name="LookupUpgradeStatuses" datasource="#application.type#SOFTWARE" blockfactor="6">
		SELECT	STATUSID, STATUSTYPE, STATUSNAME
		FROM		STATUSES
		WHERE	STATUSID = <CFQUERYPARAM value="#LookupSoftwareInventory.UPGRADESTATUSID#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	STATUSTYPE, STATUSNAME
	</CFQUERY>

	<CFQUERY name="LookupTossStatuses" datasource="#application.type#SOFTWARE" blockfactor="6">
		SELECT	STATUSID, STATUSTYPE, STATUSNAME
		FROM		STATUSES
		WHERE	STATUSID = <CFQUERYPARAM value="#LookupSoftwareInventory.TOSSSTATUSID#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	STATUSTYPE, STATUSNAME
	</CFQUERY>

	<CFIF #LookupSoftwareInventory.RecordCount# GT 0>
		<CFSET linecount = linecount + 1>
	<TR>
		<TD align="CENTER" valign="TOP" nowrap><DIV>#LookupSoftwareInventory.SOFTWINVENTID#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupSoftwareInventory.TITLE#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareInventory.VERSION# - #LookupSoftwareInventory.PRODUCTPLATFORMNAME#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareInventory.PRODUCTPLATFORMNAME#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareInventory.QTYLICENSED#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupSoftwareInventory.REQNUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupSoftwareInventory.PONUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupUpgradeStatuses.STATUSNAME#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupTossStatuses.STATUSNAME#</DIV></TD>
	</TR>
	</CFIF>
</CFLOOP>
	<TR>
		<TD colspan="9"><HR width="100%" size="5" noshade /></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="9"><H2>#linecount# Duplicate Software Records were found in the Inventory Table.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="9">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="9">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>