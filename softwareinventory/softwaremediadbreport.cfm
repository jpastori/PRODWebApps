<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwaremediadbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: IDT Software Inventory - Media Report --->
<!-- Last modified by John R. Pastori on 07/16/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwaremediadbreport.cfm">
<CFSET CONTENT_UPDATED = "July 16, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Media Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Software Inventory - Media Report";


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
</SCRIPT>
<!--Script ends here -->
</HEAD>

<CFOUTPUT> 
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[2].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">


<!--- 
*******************************************************************************************
* The following code is the Look Up Process for the IDT Software Inventory- Media Report. *
*******************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="LookupSoftwareInventoryTitles" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	DISTINCT M.SOFTWINVENTID, SI.SOFTWINVENTID, SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME, SI.PURCHREQLINEID, PR.REQNUMBER,
				SI.TITLE || ' - ' || SI.VERSION || ' - ' || PP.PRODUCTPLATFORMNAME || ' - ' || PR.REQNUMBER AS LOOKUPKEY
		FROM		MEDIA M, SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL,
				PURCHASEMGR.PURCHREQS PR
		WHERE	((M.SOFTWINVENTID = 0 AND SI.SOFTWINVENTID = 0) OR
				(M.SOFTWINVENTID = SI.SOFTWINVENTID AND
				SI.SOFTWINVENTID > 0)) AND
				(SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID)
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFQUERY name="LookupSoftwareInventoryRecordKeys" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	DISTINCT M.SOFTWINVENTID, SI.SOFTWINVENTID, SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME, SI.PURCHREQLINEID, PR.REQNUMBER,
				SI.SOFTWINVENTID || ' - ' || SI.TITLE AS LOOKUPKEY
		FROM		MEDIA M, SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL,
				PURCHASEMGR.PURCHREQS PR
		WHERE	((M.SOFTWINVENTID = 0 AND SI.SOFTWINVENTID = 0) OR
				(M.SOFTWINVENTID = SI.SOFTWINVENTID AND
				SI.SOFTWINVENTID > 0)) AND
				(SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID)
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Select Data for IDT Software Inventory - Media Report Lookup</H1>
			</TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)<BR /><BR /></COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/softwareinventory/softwaremediadbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>Select one of the four (4) reports below, then click the Select Options button.</COM></TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="2" />
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1: &nbsp;&nbsp;All Software Media Titles</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="TITLE" id="TITLE" value="" required="No" size="40" maxlength="50" tabindex="4"><BR />
				<COM><LABEL for="TITLE">Enter a Word or Exact Phrase in the Title.</LABEL></COM>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE2">REPORT 2:</LABEL> &nbsp;&nbsp;<LABEL for="SOFTWINVENTID1">Specific Software Inventory Title</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SOFTWINVENTID1" id="SOFTWINVENTID1" size="1" query="LookupSoftwareInventoryTitles" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" checked align="LEFT" required="No" tabindex="7">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE3">REPORT 3:</LABEL> &nbsp;&nbsp;<LABEL for="SOFTWINVENTID2">Specific Software Inventory Record Key</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SOFTWINVENTID2" id="SOFTWINVENTID2" size="1" query="LookupSoftwareInventoryRecordKeys" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="9">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE4">REPORT 4:</LABEL> &nbsp;&nbsp;<LABEL for="RECORDKEYS">(1) A series of Software Inventory Record Keys separated by commas,NO spaces <BR /><BR />
				OR (2) two Software Inventory Record Keys separated by a semicolon for range.</LABEL>
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="RECORDKEYS" id="RECORDKEYS" value="" required="No" size="40" maxlength="50" tabindex="10"><BR />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="11" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="12" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

	<CFEXIT>

<CFELSE>

<!--- 
*****************************************************************************
* The following code is the Pick Up/Return Items Report Generation Process. *
*****************************************************************************
 --->


	<CFSET REPORTTITLE = ''>
	<CFSET MEDIARECORDCOUNT = 0>
	<CFSET PRINTRECORD = "YES">

	<CFIF #FORM.REPORTCHOICE# EQ 1>
		<CFSET REPORTTITLE = 'REPORT 1:&nbsp;&nbsp;&nbsp;&nbsp;All Software Media Titles'>

		<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	DISTINCT MED.SOFTWINVENTID AS MEDSWID, SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION,
					SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME, SI.FISCALYEARID,
					FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SI.PRODDESCRIPTION,
					SI.RECVDDATE,  SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS,
					SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID
			FROM		MEDIA MED, SOFTWAREINVENTORY SI, PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.FISCALYEARS FY,
					PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	MED.SOFTWINVENTID = SI.SOFTWINVENTID AND
				<CFIF #FORM.TITLE# NEQ ''>
					SI.TITLE LIKE UPPER('%#FORM.TITLE#%') AND
				</CFIF>
					SI.CATEGORYID = PC.PRODCATID AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.FISCALYEARID = FY.FISCALYEARID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFSET REPORTTITLE = 'REPORT 2:&nbsp;&nbsp;&nbsp;&nbsp;Specific Software Inventory Title'>

		<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	DISTINCT MED.SOFTWINVENTID AS MEDSWID, SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION,
					SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME, SI.FISCALYEARID,
					FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SI.PRODDESCRIPTION,
					SI.RECVDDATE,  SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS,
					SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID
			FROM		MEDIA MED, SOFTWAREINVENTORY SI, PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.FISCALYEARS FY,
					PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	MED.SOFTWINVENTID = SI.SOFTWINVENTID AND
					SI.SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID1#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.CATEGORYID = PC.PRODCATID AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.FISCALYEARID = FY.FISCALYEARID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>

		<CFSET REPORTTITLE = 'REPORT 3:&nbsp;&nbsp;&nbsp;&nbsp;Specific Software Inventory Record Key'>
		<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	DISTINCT MED.SOFTWINVENTID AS MEDSWID, SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION,
					SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME,
					SI.PRODPLATFORMID, PP.PRODUCTPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER,
					SI.FISCALYEARID, FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SI.RECVDDATE,
					SI.PRODSTATUSID, PS.STATUSID, PS.STATUSNAME AS PSSTATUS,
					SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED,
					SI.LICENSETYPEID, LT.LICENSETYPEID, LT.LICENSETYPENAME,
					SI.QTYLICENSED, SI.UPGRADESTATUSID, UPGRS.STATUSID, UPGRS.STATUSNAME AS UPGRSTATUS,
					SI.TOSSSTATUSID, TOSS.STATUSID, TOSS.STATUSNAME AS TOSSSTATUS,
					SI.CDKEY, SI.PRODUCTID, SI.MODIFIEDBYID, CUST.CUSTOMERID, CUST.FULLNAME, SI.MODIFIEDDATE
			FROM		MEDIA MED, SOFTWAREINVENTORY SI, PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.FISCALYEARS FY, STATUSES PS,
					LICENSETYPES LT, STATUSES UPGRS, STATUSES TOSS, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	MED.SOFTWINVENTID = SI.SOFTWINVENTID AND
					SI.SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID2#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.CATEGORYID = PC.PRODCATID AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.FISCALYEARID = FY.FISCALYEARID AND
					SI.PRODSTATUSID = PS.STATUSID AND
					SI.LICENSETYPEID = LT.LICENSETYPEID AND
					SI.UPGRADESTATUSID = UPGRS.STATUSID AND
					SI.TOSSSTATUSID = TOSS.STATUSID AND
					SI.MODIFIEDBYID = CUST.CUSTOMERID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SI.SOFTWINVENTID, SI.TITLE, SI.VERSION
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>

		<CFIF #FORM.RECORDKEYS# NEQ ''>
			<CFSET RECORDKEYSLIST = "NO">
			<CFSET RECORDKEYSRANGE = "NO">
			<CFIF FIND(',', #FORM.RECORDKEYS#, 1) NEQ 0>
				<CFSET RECORDKEYSLIST = "YES">
				<CFSET REPORTTITLE = 'REPORT 4:&nbsp;&nbsp;&nbsp;&nbsp;List of Software Inventory Record Keys'>
			<CFELSEIF FIND(';', #FORM.RECORDKEYS#, 1) NEQ 0>
				<CFSET RECORDKEYSRANGE = "YES">
				<CFSET REPORTTITLE = 'REPORT 4:&nbsp;&nbsp;&nbsp;&nbsp;Range of Software Inventory Record Keys'>
				<CFSET FORM.RECORDKEYS = #REPLACE(FORM.RECORDKEYS, ";", ",")#>
			</CFIF>
			<CFIF RECORDKEYSRANGE EQ "YES">
				<CFSET RECORDKEYSARRAY = ListToArray(FORM.RECORDKEYS)>
				<CFLOOP index="Counter" from=1 to=#ArrayLen(RECORDKEYSARRAY)# >
					RECORD KEYS ARRAY FIELD #COUNTER# = #RECORDKEYSARRAY[COUNTER]#<BR /><BR />
				</CFLOOP>
				<CFSET BEGINRECORDKEY = #RECORDKEYSARRAY[1]#>
				BEGIN RECORD KEY = #BEGINRECORDKEY# - 
				<CFSET ENDRECORDKEY = #RECORDKEYSARRAY[2]#>
				END RECORD KEY = #ENDRECORDKEY#<BR /><BR />
			</CFIF>
			FORM RECORD KEYS = #FORM.RECORDKEYS#<BR /><BR />
			RECORDKEYSLIST = #RECORDKEYSLIST#<BR /><BR />
			RECORDKEYSRANGE = #RECORDKEYSRANGE#<BR /><BR />
		</CFIF>

		<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	DISTINCT MED.SOFTWINVENTID AS MEDSWID, SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION,
					SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME,
					SI.PRODPLATFORMID, PP.PRODUCTPLATFORMID, PP.PRODUCTPLATFORMNAME,
					SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER,
					SI.FISCALYEARID, FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SI.RECVDDATE, 
					SI.PRODSTATUSID, PS.STATUSID, PS.STATUSNAME AS PSSTATUS,
					SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED,
					SI.LICENSETYPEID, LT.LICENSETYPEID, LT.LICENSETYPENAME,
					SI.QTYLICENSED, SI.UPGRADESTATUSID, UPGRS.STATUSID, UPGRS.STATUSNAME AS UPGRSTATUS,
					SI.TOSSSTATUSID, TOSS.STATUSID, TOSS.STATUSNAME AS TOSSSTATUS,
					SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, VEN.VENDORID, VEN.VENDORNAME,
					SI.MODIFIEDBYID, CUST.CUSTOMERID, CUST.FULLNAME, SI.MODIFIEDDATE
			FROM		MEDIA MED, SOFTWAREINVENTORY SI, PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.FISCALYEARS FY, STATUSES PS,
					LICENSETYPES LT, STATUSES UPGRS, STATUSES TOSS, PURCHASEMGR.VENDORS VEN, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	MED.SOFTWINVENTID = SI.SOFTWINVENTID AND
				<CFIF RECORDKEYSLIST EQ 'YES'>
					SI.SOFTWINVENTID IN (#FORM.RECORDKEYS#) AND
				</CFIF>
				<CFIF RECORDKEYSRANGE EQ 'YES'>
					(SI.SOFTWINVENTID BETWEEN #val(BEGINRECORDKEY)# AND #val(ENDRECORDKEY)#) AND
				</CFIF>
					SI.CATEGORYID = PC.PRODCATID AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.FISCALYEARID = FY.FISCALYEARID AND
					SI.PRODSTATUSID = PS.STATUSID AND
					SI.LICENSETYPEID = LT.LICENSETYPEID AND
					SI.UPGRADESTATUSID = UPGRS.STATUSID AND
					SI.TOSSSTATUSID = TOSS.STATUSID AND
					SI.MANUFWARRVENDORID = VEN.VENDORID AND
					SI.MODIFIEDBYID = CUST.CUSTOMERID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SI.SOFTWINVENTID, SI.TITLE, SI.VERSION
		</CFQUERY>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>IDT Software Inventory - Media Report
				<H2>#REPORTTITLE#
			</H2></H1></TD>
		</TR>
	</TABLE>
	<BR />

	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwaremediadbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR /><BR />
               </TD>
</CFFORM>
		</TR>

<CFLOOP query="LookupSoftwareInventory">
	<CFIF #FORM.REPORTCHOICE# EQ 4>
		<CFQUERY name="LookupMediaRecord" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SI.SOFTWINVENTID, M.SOFTWINVENTID
			FROM		SOFTWAREINVENTORY SI, MEDIA M
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.SOFTWINVENTID = M.SOFTWINVENTID
		</CFQUERY>
		<CFIF #LookupMediaRecord.RecordCount# GT 0>
			<CFSET PRINTRECORD = "YES">
		<CFELSE>
			<CFSET PRINTRECORD = "NO">
		</CFIF>
	<CFELSE>
		<CFSET PRINTRECORD = "YES">
	</CFIF>
	<CFIF #PRINTRECORD# EQ "YES">
		<TR>
			<TH align="LEFT"><u>Title</u> - #LookupSoftwareInventory.SOFTWINVENTID#</TH>
			<TH align="center"><u>Version</u></TH>
			<TH align="center"><u>Category</u></TH>
			<TH align="center"><u>Platform</u></TH>
			<TH align="center"><u>Fiscal Year</u></TH>
			<TH align="center"><u>Requisition Number</u></TH>
			<TH align="center"><u>Purchase Order Number</u></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP"><DIV><COM>#UCase(LookupSoftwareInventory.TITLE)#</COM></DIV></TD>
			<TD align="center" valign="TOP"><DIV><COM>#LookupSoftwareInventory.VERSION#</COM></DIV></TD>
			<TD align="center" valign="TOP"><DIV><COM>#LookupSoftwareInventory.PRODCATNAME#</COM></DIV></TD>
			<TD align="center" valign="TOP"><DIV><COM>#LookupSoftwareInventory.PRODUCTPLATFORMNAME#</COM></DIV></TD>
			<TD align="center" valign="TOP"><DIV><COM>#LookupSoftwareInventory.FISCALYEAR_4DIGIT#</COM></DIV></TD>
			<TD align="center" valign="TOP"><DIV><COM>#LookupSoftwareInventory.REQNUMBER#</COM></DIV></TD>
			<TD align="center" valign="TOP"><DIV><COM>#LookupSoftwareInventory.PONUMBER#</COM></DIV></TD>
		</TR>
		<TR>
			<TD align="CENTER" colspan="7"><HR /></TD>
		</TR>
		<TR>
			<TH align="center">Part Number</TH>
			<TH align="CENTER" colspan="3">Media Title</TH>
			<TH align="center">Media Type</TH>
			<TH align="center">Media Location</TH>
			<TH align="center">Media Quantity</TH>
		</TR>
	
		<CFQUERY name="LookupSoftwareMediaDetail" datasource="#application.type#SOFTWARE">
			SELECT	SI.TITLE AS SOFTWTITLE, SI.VERSION, M.PARTNUMBER, M.TITLE AS MEDIATITLE, M.MEDIATYPEID, MT.MEDIATYPENAME,
					M.LOCATIONID, SL.STOREDLOCNAME, M.MEDIAQTY 
			FROM		MEDIA M, SOFTWAREINVENTORY SI, MEDIATYPES MT, STOREDLOCATIONS SL
			WHERE	M.MEDIAID > 0 AND
					M.SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					M.SOFTWINVENTID = SI.SOFTWINVENTID AND 
					M.MEDIATYPEID = MT.MEDIATYPEID AND
					M.LOCATIONID = SL.STOREDLOCID
			ORDER BY	SI.TITLE, SI.VERSION, M.TITLE
		</CFQUERY>
	
		<CFLOOP query="LookupSoftwareMediaDetail">
			<CFSET MEDIARECORDCOUNT = #MEDIARECORDCOUNT# + 1>
		<TR>
			<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareMediaDetail.PARTNUMBER#</DIV></TD>
			<TD align="LEFT" valign="TOP" colspan="3"><DIV>#UCase(LookupSoftwareMediaDetail.MEDIATITLE)#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareMediaDetail.MEDIATYPENAME#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareMediaDetail.STOREDLOCNAME#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupSoftwareMediaDetail.MEDIAQTY#</DIV></TD>
		</TR>
		</CFLOOP>
		<TR>
			<TD align="CENTER" colspan="7"><HR size="5" noshade /></TD>
		</TR>
	</CFIF>
</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="7">
				<H2>#MEDIARECORDCOUNT# Software Inventory Media records were selected.
			</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwaremediadbreport.cfm" method="POST">
			<TD align="left" colspan="7">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="CENTER" colspan="7">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>