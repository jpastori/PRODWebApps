<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: duplswinventoryarchivereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Duplicate From Inventory To Archive Records Report --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/duplswinventoryarchivereport.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Duplicate From Inventory To Archive Records Report</TITLE>
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

<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	SOFTWINVENTID, TITLE, UPGRADESTATUSID, TOSSSTATUSID, SOFTWINVENTID || ' - ' || TITLE AS KEYTITLE
	FROM		SOFTWAREINVENTORY
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
		<TH align="center"><H1>Duplicate From Inventory To Archive Records Report</H1></TH>
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
<CFLOOP query="LookupSoftwareInventory">

	<CFQUERY name="LookupSoftwareArchive" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SA.SOFTWINVENTID, SA.CREATIONDATE, SA.TITLE, SA.VERSION, SA.CATEGORYID, SA.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SA.PRODDESCRIPTION, SA.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SA.FISCALYEARID, SA.RECVDDATE, SA.PRODSTATUSID,
				SA.PHONESUPPORT, SA.WEBSUPPORT, SA.FAXSUPPORT, SA.SUPPORTCOMMENTS, SA.QTYORDERED, SA.LICENSETYPEID, SA.QTYLICENSED,
				SA.UPGRADESTATUSID, SA.TOSSSTATUSID, SA.CDKEY, SA.PRODUCTID, SA.MANUFWARRVENDORID, SA.MODIFIEDBYID, SA.MODIFIEDDATE,
				SA.SOFTWINVENTID || ' - ' || SA.TITLE AS KEYTITLE, SA.SOFTWINVENTID || ' - ' || PR.REQNUMBER AS KEYREQ, 
				SA.SOFTWINVENTID || ' - ' || PR.PONUMBER AS KEYPO
		FROM		SOFTWAREARCHIVE SA, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	SA.SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SA.UPGRADESTATUSID IN (9, 12, 14) AND
				SA.TOSSSTATUSID IN (6, 7, 8) AND
				SA.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SA.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	KEYTITLE
	</CFQUERY>

	<CFQUERY name="LookupUpgradeStatuses" datasource="#application.type#SOFTWARE" blockfactor="6">
		SELECT	STATUSID, STATUSTYPE, STATUSNAME
		FROM		STATUSES
		WHERE	STATUSID = <CFQUERYPARAM value="#LookupSoftwareArchive.UPGRADESTATUSID#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	STATUSTYPE, STATUSNAME
	</CFQUERY>

	<CFQUERY name="LookupTossStatuses" datasource="#application.type#SOFTWARE" blockfactor="6">
		SELECT	STATUSID, STATUSTYPE, STATUSNAME
		FROM		STATUSES
		WHERE	STATUSID = <CFQUERYPARAM value="#LookupSoftwareArchive.TOSSSTATUSID#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	STATUSTYPE, STATUSNAME
	</CFQUERY>

	<CFIF #LookupSoftwareArchive.RecordCount# GT 0>
		<CFSET linecount = linecount + 1>
	<TR>
		<TD align="CENTER" valign="TOP" nowrap><DIV>#LookupSoftwareArchive.SOFTWINVENTID#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupSoftwareArchive.TITLE#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareArchive.VERSION#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareArchive.PRODUCTPLATFORMNAME#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareArchive.QTYLICENSED#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupSoftwareArchive.REQNUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LookupSoftwareArchive.PONUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupUpgradeStatuses.STATUSNAME#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#LookupTossStatuses.STATUSNAME#</DIV></TD>
	</TR>
	</CFIF>
</CFLOOP>
	<TR>
		<TD colspan="9"><HR width="100%" size="5" noshade /></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="9"><H2>#linecount# Duplicate Software Records were found in the Archive Table.</H2></TH>
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