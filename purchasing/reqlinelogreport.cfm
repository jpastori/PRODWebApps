<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: reqlinelogreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/29/2012 --->
<!--- Date in Production: 07/29/2012 --->
<!--- Module: IDT Purchase Requisitions - Req Line Log Report --->
<!-- Last modified by John R. Pastori on 07/29/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/reqlinelogreport.cfm">
<CFSET CONTENT_UPDATED = "July 29, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchase Requisitions - Req Line Log Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Purchasing";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateLookupFields() {
		if (document.LOOKUP.REPORTCHOICE[0].checked == "0" && document.LOOKUP.REPORTCHOICE[1].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[2].checked == "0"  && document.LOOKUP.REPORTCHOICE[3].checked == "0") {
			alertuser ("You must choose one of the four (4) reports!");
			document.LOOKUP.REPORTCHOICE[0].focus();
			return false;
		}

		if (document.LOOKUP.REPORTCHOICE[3].checked > "0" && document.LOOKUP.COMPLETIONDATE.value == "") {
			alertuser ("You MUST enter either a specific Completion date series of Completion dates or a range of Completion dates in the text box!");
			document.LOOKUP.COMPLETIONDATE.focus();
			return false;
		}
	}
//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
******************************************************************************************************
* The following code is the Look Up Process for the IDT Purchase Requisitions - Req Line Log Report. *
******************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFQUERY name="LookupPurchReqFiscalYear" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	DISTINCT PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	PR.FISCALYEARID = FY.FISCALYEARID
		ORDER BY	FY.FISCALYEAR_2DIGIT
	</CFQUERY>

	<CFQUERY name="LookupSRNumbers" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.SALESORDERNUMBER, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT,
				PR.REQUESTERID, CUST.FULLNAME, PR.COMPLETIONDATE,
				PR.SALESORDERNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT || ' - ' || CUST.FULLNAME AS LOOKUPKEY
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	PR.REQUESTERID = CUST.CUSTOMERID AND
				PR.FISCALYEARID = FY.FISCALYEARID
		ORDER BY	PR.SERVICEREQUESTNUMBER DESC
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Select Data for IDT Purchase Requisitions - Req Line Log Report Lookup</H1>
			</TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)<BR /><BR /></COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/purchasing/reqlinelogreport.cfm?PROCESS=LOOKUP" method="POST">
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
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1: </LABEL>&nbsp;&nbsp;<LABEL for="FISCALYEARID">Specific Fiscal Year</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="LookupPurchReqFiscalYear" value="FISCALYEARID" selected="0" display="FISCALYEAR_2DIGIT" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE2">REPORT 2: </LABEL>&nbsp;&nbsp;<LABEL for="SERVICEREQUESTNUMBER">Specific SR Number</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SERVICEREQUESTNUMBER"id="SERVICEREQUESTNUMBER" size="1" query="LookupSRNumbers" value="SERVICEREQUESTNUMBER" selected="0" display="SERVICEREQUESTNUMBER" required="no" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" checked align="LEFT" required="No" tabindex="7">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE3">REPORT 3:</LABEL> &nbsp;&nbsp;
                    <LABEL for="COMPLETEFLAG">Purchase Req Completed</LABEL>
                    <LABEL for="COMPLETEDFISCALYEARID">for a specific 2-digit Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="COMPLETEFLAG" id="COMPLETEFLAG" size="1" tabindex="8">
					<OPTION selected value="0">Select an Option</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
                    &nbsp;&nbsp;&nbsp;&nbsp;
				<CFSELECT name="COMPLETEDFISCALYEARID" id="COMPLETEDFISCALYEARID" size="1" query="LookupPurchReqFiscalYear" value="FISCALYEARID" selected="0" display="FISCALYEAR_2DIGIT" required="No" tabindex="9"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="10">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE4">REPORT 4: &nbsp;&nbsp;Purchase Req By Completion Date</LABEL><BR />
				<LABEL for="COMPLETIONDATE">(1) a single Completion Date <BR /><BR /> OR (2) a series of Completion dates separated <BR />
				by commas,NO spaces<BR /><BR /> OR (3) two Completion dates separated by a<BR />
				semicolon for range.</LABEL>
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="Text" name="COMPLETIONDATE" id="COMPLETIONDATE" value="" required="No" size="50" tabindex="11">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
               <TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="12" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="13" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************************************************
* The following code is the process for IDT Purchase Requisitions - Req Line Log Report generation. *
*****************************************************************************************************
 --->

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'PR.SERVICEREQUESTNUMBER~ PR.REQNUMBER~ PRL.LINENUMBER'>
	<CFSET SORTORDER[2] = 'PR.SERVICEREQUESTNUMBER~ PR.REQNUMBER~ PRL.LINENUMBER'>
	<CFSET SORTORDER[3] = 'PR.SERVICEREQUESTNUMBER~ PR.REQNUMBER~ PRL.LINENUMBER'>
	<CFSET SORTORDER[4] = 'PR.SERVICEREQUESTNUMBER~ PR.REQNUMBER~ PRL.LINENUMBER~ PR.COMPLETIONDATE'>
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

	<CFIF FIND('~', #REPORTORDER#, 1) NEQ 0>
		<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>

		<CFSET COMPLETIONDATELIST = "NO">
		<CFSET COMPLETIONDATERANGE = "NO">
		<CFIF FIND(',', #FORM.COMPLETIONDATE#, 1) EQ 0 AND FIND(';', #FORM.COMPLETIONDATE#, 1) EQ 0>
			<CFSET FORM.COMPLETIONDATE = DateFormat(FORM.COMPLETIONDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.COMPLETIONDATE#, 1) NEQ 0>
				<CFSET COMPLETIONDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.COMPLETIONDATE#, 1) NEQ 0>
				<CFSET COMPLETIONDATERANGE = "YES">
				<CFSET FORM.COMPLETIONDATE = #REPLACE(FORM.COMPLETIONDATE, ";", ",")#>
			</CFIF>
			<CFSET COMPLETIONDATEARRAY = ListToArray(FORM.COMPLETIONDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(COMPLETIONDATEARRAY)# >
				COMPLETION DATE FIELD #COUNTER# = #COMPLETIONDATEARRAY[COUNTER]#<BR /><BR />
			</CFLOOP>
		</CFIF>
		<CFIF COMPLETIONDATERANGE EQ "YES">
			<CFSET BEGINCOMPLETIONDATE = DateFormat(#COMPLETIONDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDCOMPLETIONDATE = DateFormat(#COMPLETIONDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		COMPLETION DATE LIST = #COMPLETIONDATELIST#<BR /><BR />
		COMPLETION DATE RANGE = #COMPLETIONDATERANGE#<BR /><BR />

	</CFIF>

	<CFQUERY name="ListPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PRL.LINEQTY, PRL.PARTNUMBER, PRL.LINEDESCRIPTION, PRL.RECVDDATE,
				PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, PR.REQNUMBER, PR.COMPLETEFLAG, PR.COMPLETIONDATE
		FROM		PURCHREQLINES PRL, PURCHREQS PR, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	PRL.PURCHREQLINEID > 0 AND
				PRL.PURCHREQID = PR.PURCHREQID AND
			<CFIF #FORM.REPORTCHOICE# EQ 1>
				PR.FISCALYEARID = #val(FORM.FISCALYEARID)# AND
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 2>
				PR.SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#' AND
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 3>
				PR.COMPLETEFLAG = '#FORM.COMPLETEFLAG#' AND
                    <CFIF #FORM.COMPLETEDFISCALYEARID# GT 0>
					PR.FISCALYEARID = #val(FORM.COMPLETEDFISCALYEARID)# AND
				</CFIF>
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 4>
				<CFIF COMPLETIONDATELIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(COMPLETIONDATEARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATCOMPLETIONDATE = DateFormat(#COMPLETIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						PR.COMPLETIONDATE = TO_DATE('#FORMATCOMPLETIONDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATCOMPLETIONDATE = DateFormat(#COMPLETIONDATEARRAY[ArrayLen(COMPLETIONDATEARRAY)]#, 'DD-MMM-YYYY')>
					PR.COMPLETIONDATE = TO_DATE('#FORMATCOMPLETIONDATE#', 'DD-MON-YYYY')) AND
				<CFELSEIF COMPLETIONDATERANGE EQ "YES">
					(PR.COMPLETIONDATE BETWEEN TO_DATE('#BEGINCOMPLETIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCOMPLETIONDATE#', 'DD-MON-YYYY')) AND
				<CFELSE>
					PR.COMPLETIONDATE LIKE TO_DATE('#FORM.COMPLETIONDATE#', 'DD-MON-YYYY') AND
				</CFIF>
			</CFIF>
				PR.FISCALYEARID = FY.FISCALYEARID
		ORDER BY	#REPORTORDER#
	</CFQUERY>

	<CFSET CLIENT.REPORTTITLE = ''>
	<CFSET CLIENT.PURCHREQRECORDCOUNT = 0>
	<CFSET CLIENT.SRNUMBER = ''>
	<CFSET CLIENT.REQNUMBER = ''>
	

	<CFIF #FORM.REPORTCHOICE# EQ 1>
		<CFSET CLIENT.REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;Specific Fiscal Year &nbsp;&nbsp; - &nbsp;&nbsp; #ListPurchReqLines.FISCALYEAR_2DIGIT#'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFSET CLIENT.REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;Specific SR Number &nbsp;&nbsp; - &nbsp;&nbsp; #ListPurchReqLines.SERVICEREQUESTNUMBER#'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>
		<CFSET CLIENT.REPORTTITLE = 'REPORT 3: &nbsp;&nbsp;Purchase Req Completed - (#FORM.COMPLETEFLAG# &nbsp;&nbsp; #ListPurchReqLines.FISCALYEAR_2DIGIT#)'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>
		<CFSET CLIENT.REPORTTITLE = 'REPORT 4: &nbsp;&nbsp;Purchase Req By Completed Date - #FORM.COMPLETIONDATE#'>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>IDT Purchase Requisitions - Req Line Log Report
				<H2>#CLIENT.REPORTTITLE#
			</H2></H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" border="0" align="left">
		<TR>
	<CFFORM action="/#application.type#apps/purchasing/reqlinelogreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
	</CFFORM>
		</TR>
	<CFLOOP query="ListPurchReqLines">
		<CFSET CLIENT.PURCHREQRECORDCOUNT = #CLIENT.PURCHREQRECORDCOUNT# + 1>
		<CFIF CLIENT.SRNUMBER NEQ #ListPurchReqLines.SERVICEREQUESTNUMBER#>
			<CFSET CLIENT.SRNUMBER = #ListPurchReqLines.SERVICEREQUESTNUMBER#>
		<TR>
			<TD align="LEFT" colspan="7"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" valign="BOTTOM"><STRONG>SR Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requisition Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Line Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Line Qty</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Line Part Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Line Description</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Received Date</STRONG></TH>
		</TR>
		<TR>
			<TD align="CENTER"><DIV>#ListPurchReqLines.SERVICEREQUESTNUMBER#</DIV></TD>
		<CFELSE>
		</TR><TR>
			<TD align="CENTER"><DIV>&nbsp;&nbsp;</DIV></TD>
		</CFIF>
		<CFIF CLIENT.REQNUMBER NEQ #ListPurchReqLines.REQNUMBER#>
			<CFSET CLIENT.REQNUMBER = #ListPurchReqLines.REQNUMBER#>
			<TD align="CENTER"><DIV>#ListPurchReqLines.REQNUMBER#</DIV></TD>
		<CFELSE>
			<TD align="CENTER"><DIV>&nbsp;&nbsp;</DIV></TD>
		</CFIF>
			<TD align="CENTER"><DIV>#ListPurchReqLines.LINENUMBER#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqLines.LINEQTY#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqLines.PARTNUMBER#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqLines.LINEDESCRIPTION#</DIV></TD>
			<TD align="CENTER"><DIV>#ListPurchReqLines.RECVDDATE#</DIV></TD>
		</TR>
	</CFLOOP>
		
		<TR>
			<TD align="LEFT" colspan="7"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="9">
				<H2>#CLIENT.PURCHREQRECORDCOUNT# Purchase Requisition Line records were selected.
			</H2></TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
	<CFFORM action="/#application.type#apps/purchasing/reqlinelogreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
	</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="7"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>