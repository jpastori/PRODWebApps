<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: reverseswinventoryarchive.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2011 --->
<!--- Date in Production: 08/03/2011 --->
<!--- Module: IDT Software Inventory Reverse Archive Process --->
<!-- Last modified by John R. Pastori on on 08/03/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/reverseswinventoryarchive.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory Reverse Archive Process</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<!--- 
*******************************************************************************
* The following code is the Specific Record Status Report Software Inventory. *
*******************************************************************************
 --->

<CFQUERY name="GetSoftwareArchive" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	SI.SOFTWINVENTID, TO_CHAR(SI.CREATIONDATE, 'DD-MON-YYYY HH24:MI:SS')AS CREATIONDATE, SI.TITLE, SI.VERSION,
			SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER,
			PR.PONUMBER, SI.FISCALYEARID, TO_CHAR(SI.RECVDDATE, 'DD-MON-YYYY HH24:MI:SS')AS RECVDDATE, SI.PRODSTATUSID,
			SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
			SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, 
			TO_CHAR(MODIFIEDDATE, 'DD-MON-YYYY HH24:MI:SS')AS MODIFIEDDATE,
			SI.SOFTWINVENTID || ' - ' || SI.TITLE AS KEYTITLE, SI.SOFTWINVENTID || ' - ' || PR.REQNUMBER AS KEYREQ, 
			SI.SOFTWINVENTID || ' - ' || PR.PONUMBER AS KEYPO
	FROM		SOFTWAREARCHIVE SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
	WHERE	SI.SOFTWINVENTID IN (#URL.SOFTWAREIDS#) AND
			SI.UPGRADESTATUSID IN (9, 12, 14) AND
			SI.TOSSSTATUSID IN (6, 7, 8) AND
			SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
			SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
			PRL.PURCHREQID = PR.PURCHREQID
	ORDER BY	KEYTITLE
</CFQUERY>

<CFLOOP query="GetSoftwareArchive">

	<CFTRANSACTION action="begin">
	<CFQUERY name="AddSoftwareInventory" datasource="#application.type#SOFTWARE">
		INSERT INTO	SOFTWAREINVENTORY
					(SOFTWINVENTID, CREATIONDATE, TITLE, VERSION, CATEGORYID, PRODPLATFORMID, PRODDESCRIPTION, PURCHREQLINEID,
					FISCALYEARID, RECVDDATE, PRODSTATUSID, PHONESUPPORT, WEBSUPPORT, FAXSUPPORT, SUPPORTCOMMENTS, QTYORDERED,
					LICENSETYPEID, QTYLICENSED, UPGRADESTATUSID, TOSSSTATUSID, CDKEY, PRODUCTID, MANUFWARRVENDORID,
					MODIFIEDBYID, MODIFIEDDATE)
		VALUES		(#val(GetSoftwareArchive.SOFTWINVENTID)#, 
					TO_DATE('#GetSoftwareArchive.CREATIONDATE#', 'DD-MON-YYYY HH24:MI:SS'),
					'#GetSoftwareArchive.TITLE#',
					'#GetSoftwareArchive.VERSION#',
					#val(GetSoftwareArchive.CATEGORYID)#,
					#val(GetSoftwareArchive.PRODPLATFORMID)#,
					'#GetSoftwareArchive.PRODDESCRIPTION#',
					#val(GetSoftwareArchive.PURCHREQLINEID)#,
					#val(GetSoftwareArchive.FISCALYEARID)#,
					TO_DATE('#GetSoftwareArchive.RECVDDATE#', 'DD-MON-YYYY HH24:MI:SS'),
					#val(GetSoftwareArchive.PRODSTATUSID)#,
					'#GetSoftwareArchive.PHONESUPPORT#',
					'#GetSoftwareArchive.WEBSUPPORT#',
					'#GetSoftwareArchive.FAXSUPPORT#',
					'#GetSoftwareArchive.SUPPORTCOMMENTS#',
					#val(GetSoftwareArchive.QTYORDERED)#,
					#val(GetSoftwareArchive.LICENSETYPEID)#,
					#val(GetSoftwareArchive.QTYLICENSED)#,
					#val(GetSoftwareArchive.UPGRADESTATUSID)#,
					#val(GetSoftwareArchive.TOSSSTATUSID)#,
					'#GetSoftwareArchive.CDKEY#',
					'#GetSoftwareArchive.PRODUCTID#',
					#val(GetSoftwareArchive.MANUFWARRVENDORID)#,
					#val(GetSoftwareArchive.MODIFIEDBYID)#,
					TO_DATE('#GetSoftwareArchive.MODIFIEDDATE#', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>

	<CFTRANSACTION action="begin">
	<CFQUERY name="DeleteSoftwareInventory" datasource="#application.type#SOFTWARE">
		DELETE FROM	SOFTWAREARCHIVE
		WHERE 		SOFTWINVENTID = #val(GetSoftwareArchive.SOFTWINVENTID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>

</CFLOOP>

<H1>INVENTORY REVERSAL COMPLETE!</H1>
<META http-equiv="Refresh" content="0; URL=/#application.type#apps/softwareinventory/swinventoryarchivelookup.cfm?&ARCHIVE=REVERSE" />
</CFOUTPUT>

</BODY>
</HTML>