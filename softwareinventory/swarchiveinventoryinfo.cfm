<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: swarchiveinventoryinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: IDT Software Inventory Archive Process --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/swarchiveinventoryinfo.cfm ">
<CFSET CONTENT_UPDATED = "June 24, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory Archive Process</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFQUERY name="GetSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	SOFTWINVENTID, TO_CHAR(CREATIONDATE, 'DD-MON-YYYY HH24:MI:SS') AS CREATIONDATE, TITLE, VERSION, CATEGORYID,
			PRODPLATFORMID, PRODDESCRIPTION, PURCHREQLINEID, FISCALYEARID, TO_CHAR(RECVDDATE, 'DD-MON-YYYY HH24:MI:SS') AS RECVDDATE,
			PRODSTATUSID, PHONESUPPORT, WEBSUPPORT, FAXSUPPORT, SUPPORTCOMMENTS, QTYORDERED, LICENSETYPEID, QTYLICENSED, UPGRADESTATUSID,
			TOSSSTATUSID, CDKEY, PRODUCTID, MANUFWARRVENDORID, MODIFIEDBYID, TO_CHAR(MODIFIEDDATE, 'DD-MON-YYYY HH24:MI:SS')AS MODIFIEDDATE
	FROM		SOFTWAREINVENTORY
	WHERE	UPGRADESTATUSID IN (9, 12, 14) AND
			TOSSSTATUSID IN (6, 7, 8)
		<CFIF IsDefined('URL.ARCHIVE') AND IsDefined('URL.SOFTWAREIDS')>
			AND SOFTWINVENTID IN (#URL.SOFTWAREIDS#)
		</CFIF>
	ORDER BY	SOFTWINVENTID
</CFQUERY>

<CFIF #GetSoftwareInventory.RecordCount# EQ 0>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("Records meeting the selected criteria were Not Found");
		--> 
	</SCRIPT>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	<CFEXIT>
</CFIF>

<CFLOOP query="GetSoftwareInventory">

	<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SA.SOFTWASSIGNID, SA.SOFTWINVENTID
		FROM		SOFTWAREASSIGNMENTS SA
		WHERE	SA.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	SA.SOFTWINVENTID
	</CFQUERY>

<CFIF #LookupSoftwareAssignments.RecordCount# GT 0>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("SOFTWARE RECORD: #GetSoftwareInventory.SOFTWINVENTID# - #GetSoftwareInventory.TITLE# has #LookupSoftwareAssignments.RecordCount# Software Assignment Records associated with it and CANNOT be sent to Archive. Click OK to bypass this record.");
		--> 
	</SCRIPT>
<CFELSE>
	<CFTRANSACTION action="begin">
	<CFQUERY name="AddSoftwareArchive" datasource="#application.type#SOFTWARE">
		INSERT INTO	SOFTWAREARCHIVE 
					(SOFTWINVENTID, CREATIONDATE, TITLE, VERSION, CATEGORYID, PRODPLATFORMID, PRODDESCRIPTION, PURCHREQLINEID,
					FISCALYEARID, RECVDDATE, PRODSTATUSID, PHONESUPPORT, WEBSUPPORT, FAXSUPPORT, SUPPORTCOMMENTS, QTYORDERED,
					LICENSETYPEID, QTYLICENSED, UPGRADESTATUSID, TOSSSTATUSID, CDKEY, PRODUCTID, MANUFWARRVENDORID,
					MODIFIEDBYID, MODIFIEDDATE)
		VALUES		(#val(GetSoftwareInventory.SOFTWINVENTID)#, 
					TO_DATE('#GetSoftwareInventory.CREATIONDATE#', 'DD-MON-YYYY HH24:MI:SS'),
					'#GetSoftwareInventory.TITLE#',
					'#GetSoftwareInventory.VERSION#',
					#val(GetSoftwareInventory.CATEGORYID)#,
					#val(GetSoftwareInventory.PRODPLATFORMID)#,
					'#GetSoftwareInventory.PRODDESCRIPTION#',
					#val(GetSoftwareInventory.PURCHREQLINEID)#,
					#val(GetSoftwareInventory.FISCALYEARID)#,
					TO_DATE('#GetSoftwareInventory.RECVDDATE#', 'DD-MON-YYYY HH24:MI:SS'),
					#val(GetSoftwareInventory.PRODSTATUSID)#,
					'#GetSoftwareInventory.PHONESUPPORT#',
					'#GetSoftwareInventory.WEBSUPPORT#',
					'#GetSoftwareInventory.FAXSUPPORT#',
					'#GetSoftwareInventory.SUPPORTCOMMENTS#',
					#val(GetSoftwareInventory.QTYORDERED)#,
					#val(GetSoftwareInventory.LICENSETYPEID)#,
					#val(GetSoftwareInventory.QTYLICENSED)#,
					#val(GetSoftwareInventory.UPGRADESTATUSID)#,
					#val(GetSoftwareInventory.TOSSSTATUSID)#,
					'#GetSoftwareInventory.CDKEY#',
					'#GetSoftwareInventory.PRODUCTID#',
					#val(GetSoftwareInventory.MANUFWARRVENDORID)#,
					#val(GetSoftwareInventory.MODIFIEDBYID)#,
					TO_DATE('#GetSoftwareInventory.MODIFIEDDATE#', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>

	<CFTRANSACTION action="begin">
	<CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SOFTWARE">
		DELETE FROM	SOFTWAREASSIGNMENTS
		WHERE 		SOFTWAREASSIGNMENTS.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
	</CFQUERY>

	<CFQUERY name="DeleteSoftwareManuals" datasource="#application.type#SOFTWARE">
		DELETE FROM	MANUALS
		WHERE 		MANUALS.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
	</CFQUERY>

	<CFQUERY name="DeleteSoftwareMedia" datasource="#application.type#SOFTWARE">
		DELETE FROM	MEDIA
		WHERE 		MEDIA.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
	</CFQUERY>

	<CFQUERY name="DeleteSoftwareOtherItems" datasource="#application.type#SOFTWARE">
		DELETE FROM	OTHERITEMS
		WHERE 		OTHERITEMS.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
	</CFQUERY>

	<CFQUERY name="DeleteSoftwareInventory" datasource="#application.type#SOFTWARE">
		DELETE FROM	SOFTWAREINVENTORY
		WHERE 		SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>
</CFLOOP>

<H1>ARCHIVE PROCESS IS COMPLETE

<CFIF #URL.ARCHIVE# EQ 'SIMPLE'>
	<CFSET URL.SOFTWAREIDS = #ValueList(GetSoftwareInventory.SOFTWINVENTID)#>
	Inventory Archive IDs = #URL.SOFTWAREIDS#
	<SCRIPT language="JavaScript">
		<!-- 
			window.open("/#application.type#apps/softwareinventory/swinventarchivelookupreport.cfm?ARCHIVE=SIMPLE&SOFTWAREIDS=#URL.SOFTWAREIDS#","Print_Software_IDs", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
		 -->
	</SCRIPT>
</CFIF>

<META http-equiv="Refresh" content="0; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
</CFOUTPUT>

</BODY>
</HTML>