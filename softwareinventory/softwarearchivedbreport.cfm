<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwarearchivedbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/22/2016 --->
<!--- Date in Production: 09/22/2016 --->
<!--- Module: IDT Software Archive Report --->
<!-- Last modified by John R. Pastori on 09/22/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwarearchivedbreport.cfm">
<cfset CONTENT_UPDATED = "September 22, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<title>IDT Software Archive Report</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<script language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Software Archive Report";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateLookupFields() {
		if (document.LOOKUP.REPORTCHOICE[0].checked == "0" && document.LOOKUP.REPORTCHOICE[1].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[2].checked == "0"  && document.LOOKUP.REPORTCHOICE[3].checked == "0") {
			alertuser ("You must choose one of the four reports!");
			document.LOOKUP.REPORTCHOICE[0].focus();
			return false;
		}

		if (document.LOOKUP.REPORTCHOICE[3].checked > "0" && document.LOOKUP.RECORDKEYS.value == "") {
			alertuser ("You MUST enter either a series of Record Keys or a range of Record Keys in the text box!");
			document.LOOKUP.RECORDKEYS.focus();
			return false;
		}
	}

//
</script>
<!--Script ends here -->
</head>

<cfoutput>
<cfif NOT IsDefined('URL.PROCESS')>
	<cfset CURSORFIELD = "document.LOOKUP.REPORTCHOICE[2].focus()">
<cfelse>
	<cfset CURSORFIELD = "">
</cfif>
<body onLoad="#CURSORFIELD#">

<!--- 
**********************************************************************************
* The following code is the Look Up Process for the IDT Software Archive Report. *
**********************************************************************************
 --->

<cfif NOT IsDefined("URL.PROCESS")>

	<cfquery name="LookupSoftwareArchiveTitles" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SIA.SOFTWINVENTID, SIA.CREATIONDATE, SIA.TITLE, SIA.VERSION, SIA.CATEGORYID, SIA.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SIA.PRODDESCRIPTION, SIA.PURCHREQLINEID, PR.REQNUMBER, SIA.FISCALYEARID, SIA.RECVDDATE, SIA.PRODSTATUSID, SIA.PHONESUPPORT, SIA.WEBSUPPORT,
				SIA.FAXSUPPORT, SIA.SUPPORTCOMMENTS, SIA.QTYORDERED, SIA.LICENSETYPEID, SIA.QTYLICENSED, SIA.UPGRADESTATUSID, SIA.TOSSSTATUSID,
				SIA.CDKEY, SIA.PRODUCTID, MANUFWARRVENDORID, SIA.MODIFIEDBYID, SIA.MODIFIEDDATE,
				SIA.TITLE || ' - ' || SIA.VERSION || ' - ' || PP.PRODUCTPLATFORMNAME || ' - ' || PR.REQNUMBER AS LOOKUPKEY
		FROM		SOFTWAREARCHIVE SIA, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	SIA.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SIA.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	LOOKUPKEY
	</cfquery>

	<cfquery name="LookupSoftwareArchiveRecordKeys" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SIA.SOFTWINVENTID, SIA.CREATIONDATE, SIA.TITLE, SIA.VERSION, SIA.CATEGORYID, SIA.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SIA.PRODDESCRIPTION, SIA.PURCHREQLINEID, PR.REQNUMBER, SIA.FISCALYEARID, SIA.RECVDDATE, SIA.PRODSTATUSID, SIA.PHONESUPPORT, SIA.WEBSUPPORT,
				SIA.FAXSUPPORT, SIA.SUPPORTCOMMENTS, SIA.QTYORDERED, SIA.LICENSETYPEID, SIA.QTYLICENSED, SIA.UPGRADESTATUSID, SIA.TOSSSTATUSID,
				SIA.CDKEY, SIA.PRODUCTID, MANUFWARRVENDORID, SIA.MODIFIEDBYID, SIA.MODIFIEDDATE,
				SIA.SOFTWINVENTID || ' - ' || SIA.TITLE AS LOOKUPKEY
		FROM		SOFTWAREARCHIVE SIA, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	SIA.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SIA.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	SIA.SOFTWINVENTID, SIA.TITLE
	</cfquery>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Select Data for IDT Software Archive Report Lookup</h1></td>
		</tr>
	</table>

	<table width="100%" align="LEFT">
		<tr>
			<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
<cfform action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)<br /><br /></COM>
			</td>
</cfform>
		</tr>
<cfform name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/softwareinventory/softwarearchivedbreport.cfm?PROCESS=LOOKUP" method="POST">
		<tr>
			<td align="LEFT" valign="TOP" colspan="3"><COM>Select one of the four (4) reports below, then click the Select Options button.</COM></td>
		</tr>
		<tr>
			<td valign="TOP">&nbsp;&nbsp;</td>
			<td align="LEFT" valign="TOP">
               	<input type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="2" />
               </td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" align="LEFT" required="No" tabindex="3">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE1">REPORT 1: &nbsp;&nbsp;All Software Archive Titles</label></th>
			<td align="LEFT" valign="TOP">
				<cfinput type="TEXT" name="TITLE" id="TITLE" value="" required="No" size="40" maxlength="50" tabindex="4"><br />
				<COM><label for="TITLE">Enter a Word or Exact Phrase in the Title.</label></COM>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE2">REPORT 2: &nbsp;&nbsp;</label><label for="SOFTWINVENTID1">Specific Software Archive Title</label></th>
			<td align="LEFT" valign="TOP">
				<cfselect name="SOFTWINVENTID1" id="SOFTWINVENTID1" size="1" query="LookupSoftwareArchiveTitles" value="SOFTWINVENTID" selected ="0" display="LOOKUPKEY" required="No" tabindex="6"></cfselect>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" checked align="LEFT" required="No" tabindex="7">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE3">REPORT 3: </label>&nbsp;&nbsp;<label for="SOFTWINVENTID2">Specific Software Archive Record Key</label></th>
			<td align="LEFT" valign="TOP">
				<cfselect name="SOFTWINVENTID2" id="SOFTWINVENTID2" size="1" query="LookupSoftwareArchiveRecordKeys" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="8"></cfselect>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="LEFT" valign="TOP">
				<cfinput type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="9">
			</td>
			<th align="left" valign="TOP"><label for="REPORTCHOICE4">REPORT 4: </label>&nbsp;&nbsp;<label for="RECORDKEYS">(1) A series of Software Archive Record Keys separated by commas,NO spaces <br /><br />
				OR (2) two Software Archive Record Keys separated by a semicolon for range.</label>
			</th>
			<td align="LEFT" valign="TOP">
				<cfinput type="TEXT" name="RECORDKEYS" id="RECORDKEYS" value="" required="No" size="40" maxlength="50" tabindex="10"><br />
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td valign="TOP">&nbsp;&nbsp;</td>
			<td align="LEFT" valign="TOP">
               	<input type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="11" />
               </td>
		</tr>
</cfform>
		<tr>
			<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
<cfform action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<td align="LEFT" valign="TOP" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="12" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
		<tr>
		<td align="left" valign="TOP" colspan="3"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
<cfexit>

<cfelse>

<!--- 
*****************************************************************************
* The following code is the IDT Software Archive Report Generation Process. *
*****************************************************************************
 --->

	<cfset REPORTTITLE = ''>
	<cfif #FORM.REPORTCHOICE# EQ 1>

		<cfset REPORTTITLE = 'REPORT 1:&nbsp;&nbsp;&nbsp;&nbsp;All Software Archive Titles'>
		<cfquery name="LookupSoftwareArchive" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SIA.SOFTWINVENTID, SIA.CREATIONDATE, SIA.TITLE, SIA.VERSION, SIA.PRODPLATFORMID, PP.PRODUCTPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SIA.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME, SIA.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SIA.RECVDDATE, SIA.WEBSUPPORT,
                         SIA.SUPPORTCOMMENTS, SIA.QTYORDERED, SIA.PRODSTATUSID, PS.STATUSID, PS.STATUSNAME AS PSSTATUS, SIA.LICENSETYPEID, LT.LICENSETYPEID,
					LT.LICENSETYPENAME, SIA.QTYLICENSED, SIA.UPGRADESTATUSID, UPGRS.STATUSID, UPGRS.STATUSNAME AS UPGRSTATUS,
					SIA.TOSSSTATUSID, TOSS.STATUSID, TOSS.STATUSNAME AS TOSSSTATUS
			FROM		SOFTWAREARCHIVE SIA, PRODUCTPLATFORMS PP, PRODUCTCATEGORIES PC, LICENSETYPES LT, STATUSES UPGRS, STATUSES TOSS,
					STATUSES PS, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SIA.SOFTWINVENTID > 0 AND
				<CFIF #FORM.TITLE# NEQ ''>
					SIA.TITLE LIKE UPPER('%#FORM.TITLE#%') AND
				</CFIF>
					SIA.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
                         SIA.CATEGORYID = PC.PRODCATID AND
					SIA.LICENSETYPEID = LT.LICENSETYPEID AND
					SIA.UPGRADESTATUSID = UPGRS.STATUSID AND
					SIA.TOSSSTATUSID = TOSS.STATUSID AND
					SIA.PRODSTATUSID = PS.STATUSID AND
					SIA.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SIA.TITLE, SIA.VERSION
		</cfquery>
	</cfif>

	<cfif #FORM.REPORTCHOICE# EQ 2>

		<cfset REPORTTITLE = 'REPORT 2:&nbsp;&nbsp;&nbsp;&nbsp;Specific Software Archive Title'>
		<cfquery name="LookupSoftwareArchive" datasource="#application.type#SOFTWARE">
			SELECT	SIA.SOFTWINVENTID, SIA.CREATIONDATE, SIA.TITLE, SIA.VERSION,
					SIA.PRODPLATFORMID, PP.PRODUCTPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SIA.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME,
					SIA.PRODDESCRIPTION, SIA.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER,
					SIA.FISCALYEARID, FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SIA.RECVDDATE, 
					SIA.PRODSTATUSID, PS.STATUSID, PS.STATUSNAME AS PSSTATUS,
					SIA.PHONESUPPORT, SIA.WEBSUPPORT, SIA.FAXSUPPORT, SIA.SUPPORTCOMMENTS, SIA.QTYORDERED,
					SIA.LICENSETYPEID, LT.LICENSETYPEID, LT.LICENSETYPENAME,
					SIA.QTYLICENSED, SIA.UPGRADESTATUSID, UPGRS.STATUSID, UPGRS.STATUSNAME AS UPGRSTATUS,
					SIA.TOSSSTATUSID, TOSS.STATUSID, TOSS.STATUSNAME AS TOSSSTATUS,
					SIA.CDKEY, SIA.PRODUCTID, SIA.MANUFWARRVENDORID, VEN.VENDORID, VEN.VENDORNAME,
					SIA.MODIFIEDBYID, CUST.CUSTOMERID, CUST.FULLNAME, SIA.MODIFIEDDATE
			FROM		SOFTWAREARCHIVE SIA, PRODUCTPLATFORMS PP, PRODUCTCATEGORIES PC, LIBSHAREDDATAMGR.FISCALYEARS FY, STATUSES PS,
					LICENSETYPES LT, STATUSES UPGRS, STATUSES TOSS, PURCHASEMGR.VENDORS VEN, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SIA.SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID1#" cfsqltype="CF_SQL_NUMERIC"> AND
					SIA.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SIA.CATEGORYID = PC.PRODCATID AND
					SIA.FISCALYEARID = FY.FISCALYEARID AND
					SIA.PRODSTATUSID = PS.STATUSID AND
					SIA.LICENSETYPEID = LT.LICENSETYPEID AND
					SIA.UPGRADESTATUSID = UPGRS.STATUSID AND
					SIA.TOSSSTATUSID = TOSS.STATUSID AND
					SIA.MANUFWARRVENDORID = VEN.VENDORID AND
					SIA.MODIFIEDBYID = CUST.CUSTOMERID AND
					SIA.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SIA.TITLE, SIA.VERSION
		</cfquery>
	</cfif>

	<cfif #FORM.REPORTCHOICE# EQ 3>

		<cfset REPORTTITLE = 'REPORT 3:&nbsp;&nbsp;&nbsp;&nbsp;Specific Software Archive Record Key'>
		<cfquery name="LookupSoftwareArchive" datasource="#application.type#SOFTWARE">
			SELECT	SIA.SOFTWINVENTID, SIA.CREATIONDATE, SIA.TITLE, SIA.VERSION,
					SIA.PRODPLATFORMID, PP.PRODUCTPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SIA.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME,
					SIA.PRODDESCRIPTION, SIA.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER,
					SIA.FISCALYEARID, FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SIA.RECVDDATE,
					SIA.PRODSTATUSID, PS.STATUSID, PS.STATUSNAME AS PSSTATUS,
					SIA.PHONESUPPORT, SIA.WEBSUPPORT, SIA.FAXSUPPORT, SIA.SUPPORTCOMMENTS, SIA.QTYORDERED,
					SIA.LICENSETYPEID, LT.LICENSETYPEID, LT.LICENSETYPENAME,
					SIA.QTYLICENSED, SIA.UPGRADESTATUSID, UPGRS.STATUSID, UPGRS.STATUSNAME AS UPGRSTATUS,
					SIA.TOSSSTATUSID, TOSS.STATUSID, TOSS.STATUSNAME AS TOSSSTATUS,
					SIA.CDKEY, SIA.PRODUCTID, SIA.MANUFWARRVENDORID, VEN.VENDORID, VEN.VENDORNAME,
					SIA.MODIFIEDBYID, CUST.CUSTOMERID, CUST.FULLNAME, SIA.MODIFIEDDATE
			FROM		SOFTWAREARCHIVE SIA, PRODUCTPLATFORMS PP, PRODUCTCATEGORIES PC, LIBSHAREDDATAMGR.FISCALYEARS FY, STATUSES PS,
					LICENSETYPES LT, STATUSES UPGRS, STATUSES TOSS, PURCHASEMGR.VENDORS VEN, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SIA.SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID2#" cfsqltype="CF_SQL_NUMERIC"> AND
					SIA.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SIA.CATEGORYID = PC.PRODCATID AND
					SIA.FISCALYEARID = FY.FISCALYEARID AND
					SIA.PRODSTATUSID = PS.STATUSID AND
					SIA.LICENSETYPEID = LT.LICENSETYPEID AND
					SIA.UPGRADESTATUSID = UPGRS.STATUSID AND
					SIA.TOSSSTATUSID = TOSS.STATUSID AND
					SIA.MANUFWARRVENDORID = VEN.VENDORID AND
					SIA.MODIFIEDBYID = CUST.CUSTOMERID AND
					SIA.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SIA.SOFTWINVENTID, SIA.TITLE, SIA.VERSION
		</cfquery>
	</cfif>

	<cfif #FORM.REPORTCHOICE# EQ 4>

		<cfif #FORM.RECORDKEYS# NEQ ''>
			<cfset RECORDKEYSLIST = "NO">
			<cfset RECORDKEYSRANGE = "NO">
			<cfif FIND(',', #FORM.RECORDKEYS#, 1) NEQ 0>
				<cfset RECORDKEYSLIST = "YES">
				<cfset REPORTTITLE = 'REPORT 4:&nbsp;&nbsp;&nbsp;&nbsp;List of Software Archive Record Keys'>
			<cfelseif FIND(';', #FORM.RECORDKEYS#, 1) NEQ 0>
				<cfset RECORDKEYSRANGE = "YES">
				<cfset REPORTTITLE = 'REPORT 4:&nbsp;&nbsp;&nbsp;&nbsp;Range of Software Archive Record Keys'>
				<cfset FORM.RECORDKEYS = #REPLACE(FORM.RECORDKEYS, ";", ",")#>
			</cfif>
			<cfif RECORDKEYSRANGE EQ "YES">
				<cfset RECORDKEYSARRAY = ListToArray(FORM.RECORDKEYS)>
<!--- 
				<CFLOOP index="Counter" from=1 to=#ArrayLen(RECORDKEYSARRAY)# >
					RECORD KEYS ARRAY FIELD #COUNTER# = #RECORDKEYSARRAY[COUNTER]#<BR /><BR />
				</CFLOOP>
 --->
				<cfset BEGINRECORDKEY = #RECORDKEYSARRAY[1]#>
				<!--- BEGIN RECORD KEY = #BEGINRECORDKEY# -  --->
				<cfset ENDRECORDKEY = #RECORDKEYSARRAY[2]#>
				<!--- END RECORD KEY = #ENDRECORDKEY#<BR /><BR /> --->
			</cfif>
<!--- 
			FORM RECORD KEYS = #FORM.RECORDKEYS#<BR /><BR />
			RECORDKEYSLIST = #RECORDKEYSLIST#<BR /><BR />
			RECORDKEYSRANGE = #RECORDKEYSRANGE#<BR /><BR />
 --->
		</cfif>

		<cfquery name="LookupSoftwareArchive" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SIA.SOFTWINVENTID, SIA.CREATIONDATE, SIA.TITLE, SIA.VERSION, SIA.PRODPLATFORMID, PP.PRODUCTPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SIA.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME, SIA.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SIA.RECVDDATE, SIA.WEBSUPPORT,
					SIA.SUPPORTCOMMENTS, SIA.QTYORDERED, SIA.PRODSTATUSID, PS.STATUSID, PS.STATUSNAME AS PSSTATUS, SIA.LICENSETYPEID,
					LT.LICENSETYPEID, LT.LICENSETYPENAME, SIA.QTYLICENSED, SIA.UPGRADESTATUSID, UPGRS.STATUSID, UPGRS.STATUSNAME AS UPGRSTATUS,
					SIA.TOSSSTATUSID, TOSS.STATUSID, TOSS.STATUSNAME AS TOSSSTATUS
			FROM		SOFTWAREARCHIVE SIA, PRODUCTPLATFORMS PP, PRODUCTCATEGORIES PC, LICENSETYPES LT, STATUSES UPGRS, STATUSES TOSS,
					STATUSES PS, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SIA.SOFTWINVENTID > 0 AND
				<CFIF RECORDKEYSLIST EQ 'YES'>
					SIA.SOFTWINVENTID IN (#FORM.RECORDKEYS#) AND
				</CFIF>
				<CFIF RECORDKEYSRANGE EQ 'YES'>
					(SIA.SOFTWINVENTID BETWEEN #val(BEGINRECORDKEY)# AND #val(ENDRECORDKEY)#) AND
				</CFIF>
					SIA.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
                         SIA.CATEGORYID = PC.PRODCATID AND
					SIA.LICENSETYPEID = LT.LICENSETYPEID AND
					SIA.UPGRADESTATUSID = UPGRS.STATUSID AND
					SIA.TOSSSTATUSID = TOSS.STATUSID AND
					SIA.PRODSTATUSID = PS.STATUSID AND
					SIA.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SIA.SOFTWINVENTID, SIA.TITLE, SIA.VERSION
		</cfquery>
	</cfif>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center">
				<h1>IDT Software Archive Report
				<h2>#REPORTTITLE#
			</h2></h1></td>
		</tr>
	</table>
	<br />
	<table border="0">
		<tr>
	<cfform action="/#application.type#apps/softwareinventory/softwarearchivedbreport.cfm" method="POST">
			<td align="left">
               	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </td>
	</cfform>
		</tr>
		<tr>
			<th align="CENTER" colspan="3">
				<h2>#LookupSoftwareArchive.RecordCount# Software Archive records were selected.
			</h2></th>
		</tr>
	<cfloop query="LookupSoftwareArchive">
		<tr>
			<th align="left">Title - #LookupSoftwareArchive.SOFTWINVENTID#</th>
			<th align="left">Version - Product Platform</th>
			<th align="left">Software Category</th>
		</tr>
		<tr>
			<td align="left">#LookupSoftwareArchive.TITLE#</td>
			<td align="left">#LookupSoftwareArchive.VERSION# - #LookupSoftwareArchive.PRODUCTPLATFORMNAME#</td>
			<td align="left">#LookupSoftwareArchive.PRODCATNAME#</td>
		</tr>
	
		<cfquery name="GetPurchReqLines" datasource="#application.type#PURCHASING">
			SELECT	PURCHREQLINEID, PURCHREQID, LINENUMBER, LINEQTY, LINEDESCRIPTION, PARTNUMBER, RECVDDATE, LICENSESTATUSID
			FROM		PURCHREQLINES
			WHERE	PURCHREQLINEID = <CFQUERYPARAM value="#LookupSoftwareArchive.PURCHREQLINEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PURCHREQLINEID, LINENUMBER
		</cfquery>
	
		<cfquery name="GetPurchReqs" datasource="#application.type#PURCHASING">
			SELECT	PURCHREQID, FISCALYEARID, REQNUMBER, PONUMBER, VENDORID, PURCHREQUNITID, PURCHASEJUSTIFICATION
			FROM		PURCHREQS
			WHERE	PURCHREQID = <CFQUERYPARAM value="#GetPurchReqLines.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	REQNUMBER, PONUMBER
		</cfquery>
	
		<tr>
			<th align="left">Requisition Number</th>
			<th align="left">Purchase Order Number</th>
			<th align="left">Received Date</th>
		</tr>
		<tr>
			<td align="left" valign="TOP"><div><COM>#GetPurchReqs.REQNUMBER#</COM></div></td>
			<td align="left" valign="TOP"><div><COM>#GetPurchReqs.PONUMBER#</COM></div></td>
			<td align="left" valign="TOP">#DateFormat(LookupSoftwareArchive.RECVDDATE, "MM/DD/YYYY")#</td>
		</tr>
		<tr>
			<th align="left">Upgrade Status</th>
			<th align="left">Toss Status</th>
			<th align="left">Title Status</th>
			
		</tr>
		<tr>
			<td align="left" valign="TOP">#LookupSoftwareArchive.UPGRSTATUS#</td>
			<td align="left" valign="TOP">#LookupSoftwareArchive.TOSSSTATUS#</td>
			<td align="left" valign="TOP">#LookupSoftwareArchive.PSSTATUS#</td>
			
		</tr>
		<tr>
			<th align="left">Quantity Ordered</th>
			<th align="left">Quantity Licensed</th>
			<th align="left">License Type</th>
		</tr>
		<tr>
			<td align="left" valign="TOP">#LookupSoftwareArchive.QTYORDERED#</td>
			<td align="left" valign="TOP">#LookupSoftwareArchive.QTYLICENSED#</td>
			<td align="left" valign="TOP">#LookupSoftwareArchive.LICENSETYPENAME#</td>
		</tr>
		<tr>
			<th align="left" colspan="3">Support Comments</th>
		</tr>
		<tr>
			<td align="left" valign="TOP" colspan="3">#LookupSoftwareArchive.SUPPORTCOMMENTS#</td>
		</tr>
	<cfif #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 3>
		<tr>
			<th align="left">Man/Warr Vendor</th>	
			<th align="left" valign="TOP">Warranty Phone Support</th>
			<th align="left" valign="TOP">Warranty Fax Support</th>
		</tr>
		<tr>
			<td align="left" valign="TOP">#LookupSoftwareArchive.VENDORNAME#</td>
			<td align="left" valign="TOP">#LookupSoftwareArchive.PHONESUPPORT#</td>
			<td align="left" valign="TOP">#LookupSoftwareArchive.FAXSUPPORT#</td>
		</tr>
		<tr>
			<th align="left" valign="TOP" colspan="3">Warranty Web Support</th>
		</tr>
		<tr>
			<td align="left" valign="TOP" colspan="3">#LookupSoftwareArchive.WEBSUPPORT#</td>
		</tr>
		<tr>
			<th align="left">Purchase Vendor</th>
			<th align="left">Fiscal Year</th>
			<th align="left">Purch-License Status</th>
		</tr>

		<cfquery name="GetPurchaseVendor" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS
			FROM		VENDORS
			WHERE	VENDORID = #val(GetPurchReqs.VENDORID)#
			ORDER BY	VENDORNAME
		</cfquery>

		<cfquery name="GetLicenseStatus" datasource="#application.type#PURCHASING">
			SELECT	LICENSESTATUSID, LICENSESTATUSNAME
			FROM		LICENSESTATUS
			WHERE	LICENSESTATUSID = <CFQUERYPARAM value="#GetPurchReqLines.LICENSESTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	LICENSESTATUSNAME
		</cfquery>

		<tr>
			<td align="left" valign="TOP">#GetPurchaseVendor.VENDORNAME#</td>
			<td align="left">#LookupSoftwareArchive.FISCALYEAR_4DIGIT#</td>
			<td align="left" valign="TOP">#GetLicenseStatus.LICENSESTATUSNAME#</td> 
		</tr>

		<cfquery name="GetUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	UNITID, UNITNAME, CAMPUSMAILCODEID, GROUPID, DEPARTMENTID, SUPERVISORID
			FROM		UNITS
			WHERE	UNITS.UNITID = #val(GetPurchReqs.PURCHREQUNITID)#
			ORDER BY	UNITNAME
		</cfquery>

		<tr>
			<th align="left">Req. Unit</th>
			<th align="left" colspan="2">Purchase Justification</th>
		</tr>
		<tr>
			<td align="left" valign="TOP">#GetUnits.UNITNAME#</td>
			<td align="left" valign="TOP" colspan="2">#GetPurchReqs.PURCHASEJUSTIFICATION#</td>
		</tr>
		<tr>
			<th align="left" colspan="3">Product Description</th>
		</tr>
		<tr>
			<td align="left" valign="TOP" colspan="3">#LookupSoftwareArchive.PRODDESCRIPTION#</td>
		</tr>
		<tr>
			<th align="left">Record Creation Date</th>
			<th align="left">CD Key</th>
			<th align="left">Product ID</th>
		</tr>
		<tr>
			<td align="left">#DateFormat(LookupSoftwareArchive.CREATIONDATE, "MM/DD/YYYY")#</td>
			<td align="left" valign="TOP">#LookupSoftwareArchive.CDKEY#</td>
			<td align="left" valign="TOP">#LookupSoftwareArchive.PRODUCTID#</td>
		</tr>
		<tr>
			<th align="left">Modified By</th>
			<th align="left">Modified Date</th>
			<th align="left">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="left" valign="TOP">#LookupSoftwareArchive.FULLNAME#</td>
			<td align="left" valign="TOP">#DateFormat(LookupSoftwareArchive.MODIFIEDDATE, "MM/DD/YYYY")#</td>
			<td align="left">&nbsp;&nbsp;</td>
		</tr>
	</cfif>
		<tr>
			<td align="CENTER" colspan="3"><hr noshade /></td>
		</tr>
	</cfloop>
		<tr>
			<th align="CENTER" colspan="3">
				<h2>#LookupSoftwareArchive.RecordCount# Software Archive records were selected.</h2>
			</th>
		</tr>
		<tr>
	<cfform action="/#application.type#apps/softwareinventory/softwarearchivedbreport.cfm" method="POST">
			<td align="left">
               	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
	</cfform>
		</tr>
		<tr>
			<td colspan="3">
				<cfinclude template="/include/coldfusion/footer.cfm">
			</td>
		</tr>
	</table>
</cfif>

</body>
</cfoutput>
</html>