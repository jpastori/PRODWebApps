<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: swinventarchivelookupreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Archive Lookup Report for IDT Software Inventory--->
<!-- Last modified by John R. Pastori on on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/swinventarchivelookupreport.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF #URL.ARCHIVE# EQ 'FORWARD' OR #URL.ARCHIVE# EQ 'SIMPLE'>
		<TITLE>Software Inventory To Archive Lookup Report</TITLE>
	<CFELSE>
		<TITLE>Software Archive To Inventory Lookup Report</TITLE>
	</CFIF>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Software Inventory";


//
</SCRIPT>
<!--Script ends here -->

<BODY>

<CFOUTPUT>
<CFIF ListLen(URL.SOFTWAREIDS) GT 1000>
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
	<CFSET TABLENAME ='SOFTWAREINVENTORY'>
<CFELSE>
	<CFSET TABLENAME ='SOFTWAREARCHIVE'>
</CFIF>

<CFQUERY name="ListSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
			SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, PRL.LINENUMBER, PR.PONUMBER, SI.FISCALYEARID, SI.RECVDDATE,
			SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID,
			SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID,
			SI.MODIFIEDDATE, SI.TITLE || ' - ' || SI.VERSION || ' - ' || PP.PRODUCTPLATFORMNAME || ' - ' ||  PR.REQNUMBER AS LOOKUPKEY
	FROM		#TABLENAME# SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
	WHERE	SI.SOFTWINVENTID IN (#URL.SOFTWAREIDS#) AND
			SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
			SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
			PRL.PURCHREQID = PR.PURCHREQID
	ORDER BY	LOOKUPKEY
</CFQUERY>

<!--- 
**************************************************************************
* The following code is the Archive Lookup Report for Software Inventory *
**************************************************************************
 --->
<TABLE width="100%" align="center" border="3">
	<TR>
          <TD align="LEFT" colspan="6">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
          </TD>
     </TR>
	<TR align="center">
		<TH align="center">
			<CFIF #URL.ARCHIVE# EQ 'FORWARD' OR #URL.ARCHIVE# EQ 'SIMPLE'>
				<H1>Inventory To Archive Lookup Report
			<CFELSE>
				<H1>Archive To Inventory Lookup Report
			</CFIF>
		</TH>
	</TR>
</TABLE>
<BR />
<CFSET RECCOUNT = 0>
<TABLE width="100%" align="LEFT">
	<TR>
		<TH align="left">Title</TH>
		<TH align="center">Software Record Number</TH>
		<TH align="center">Version</TH>
		<TH align="center">Platform</TH>
		<TH align="center">Modified By</TH>
		<TH align="center">Modified Date</TH>
	</TR>
<CFLOOP query="ListSoftwareInventory">

	<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SA.SOFTWASSIGNID, SA.SOFTWINVENTID
		FROM		SOFTWAREASSIGNMENTS SA
		WHERE	SA.SOFTWINVENTID = <CFQUERYPARAM value="#ListSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	SA.SOFTWINVENTID
	</CFQUERY>

	<CFIF #LookupSoftwareAssignments.RecordCount# EQ 0>
		<CFSET RECCOUNT = #RECCOUNT# + 1>

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListSoftwareInventory.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFQUERY name="ListUpgradeStatuses" datasource="#application.type#SOFTWARE">
			SELECT	STATUSID, STATUSTYPE, STATUSNAME
			FROM		STATUSES
			WHERE	STATUSID = <CFQUERYPARAM value="#ListSoftwareInventory.UPGRADESTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSTYPE, STATUSNAME
		</CFQUERY>

		<CFQUERY name="ListTossStatuses" datasource="#application.type#SOFTWARE">
			SELECT	STATUSID, STATUSTYPE, STATUSNAME
			FROM		STATUSES
			WHERE	STATUSID = <CFQUERYPARAM value="#ListSoftwareInventory.TOSSSTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSTYPE, STATUSNAME
		</CFQUERY>

	<TR>
		<TD align="left" valign="TOP"><DIV> #ListSoftwareInventory.TITLE#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.SOFTWINVENTID#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.VERSION#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.PRODUCTPLATFORMNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#DateFormat(ListSoftwareInventory.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>
	<TR>
		<TD align="left" valign="TOP"><DIV>#ListSoftwareInventory.REQNUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.LINENUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.PONUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.QTYLICENSED#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListUpgradeStatuses.STATUSNAME#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#ListTossStatuses.STATUSNAME#</DIV></TD>
	</TR>
	<TR>
		<TD align="left" valign="TOP"><DIV>#DateFormat(ListSoftwareInventory.CREATIONDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>
	<TR>
		<TD align="CENTER" colspan="6"><HR noshade /></TD>
	</TR>
	</CFIF>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="6"><H2>#RECCOUNT# Software Inventory records were selected.</H2></TH>
	</TR>
     <TR>
          <TD align="LEFT" colspan="6">
               <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="2" />
          </TD>
     </TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>