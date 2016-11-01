<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchcountreports.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: IDT Purchase Requisitions - Purchase Count Reports --->
<!-- Last modified by John R. Pastori on 05/17/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/purchcountreports.cfm">
<CFSET CONTENT_UPDATED = "May 17, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchase Requisitions - Purchase Count Reports</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Purchasing";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateLookupFields() {
		if (document.LOOKUP.REPORTCHOICE[0].checked == "0" && document.LOOKUP.REPORTCHOICE[1].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[2].checked == "0" && document.LOOKUP.REPORTCHOICE[3].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[4].checked == "0" && document.LOOKUP.REPORTCHOICE[5].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[6].checked == "0") {
			alertuser ("You must choose one of the seven (7) reports!");
			document.LOOKUP.REPORTCHOICE[0].focus();
			return false;
		}

		if (document.LOOKUP.REPORTCHOICE[0].checked > "0" && document.LOOKUP.FISCALYEARID1.selectedIndex == "0") {
				alertuser ("You MUST select a specific Fiscal Year from the dropdown box!");
				document.LOOKUP.FISCALYEARID1.focus();
				return false;
		}

		if (document.LOOKUP.REPORTCHOICE[1].checked > "0" && document.LOOKUP.REQFILEDDATE2.value == "") {
			alertuser ("You MUST enter either a specific Requisition Filed Date, a series of Requisition Filed Dates or a range of Requisition Filed Dates in the text box!");
			document.LOOKUP.REQFILEDDATE2.focus();
			return false;
		}

		if (document.LOOKUP.REPORTCHOICE[2].checked > "0" && document.LOOKUP.FISCALYEARID3.selectedIndex == "0") {
			alertuser ("A Fiscal Year MUST be selected!");
			document.LOOKUP.FISCALYEARID3.focus();
			return false;
		}

		if (document.LOOKUP.REPORTCHOICE[3].checked > "0" && document.LOOKUP.REQFILEDDATE4.value == "") {
			alertuser ("You MUST enter either a specific Requisition Filed Date, a series of Requisition Filed Dates or a range of Requisition Filed Dates in the text box!");
			document.LOOKUP.REQFILEDDATE4.focus();
			return false;
		}

		if (document.LOOKUP.REPORTCHOICE[4].checked > "0" && document.LOOKUP.FUNDACCTID5.selectedIndex == "0") {
			alertuser ("You MUST select a specific Fund Account from the dropdown box!");
			document.LOOKUP.FUNDACCTID5.focus();
			return false;
		}

		if (document.LOOKUP.REPORTCHOICE[5].checked > "0") {
			if (document.LOOKUP.FUNDACCTID6.selectedIndex == "0") {
				alertuser ("You MUST select a specific Fund Account from the dropdown box!");
				document.LOOKUP.FUNDACCTID6.focus();
				return false;
			}
			if (document.LOOKUP.FISCALYEARID6.selectedIndex == "0") {
				alertuser ("You MUST select a specific Fiscal Year from the dropdown box!");
				document.LOOKUP.FISCALYEARID6.focus();
				return false;
			}
		}

		if (document.LOOKUP.REPORTCHOICE[6].checked > "0") {
			if (document.LOOKUP.FUNDACCTID7.selectedIndex == "0") {
				alertuser ("You MUST select a specific Fund Account from the dropdown box!");
				document.LOOKUP.FUNDACCTID7.focus();
				return false;
			}
			if (document.LOOKUP.REQFILEDDATE7.value == "") {
				alertuser ("You MUST enter either a specific Requisition Filed Date, a series of Requisition Filed Dates or a range of Requisition Filed Dates in the text box!");
				document.LOOKUP.REQFILEDDATE7.focus();
				return false;
			}
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
*********************************************************************************************************
* The following code is the Look Up Process for the IDT Purchase Requisitions - Purchase Count Reports. *
*********************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="LookupPurchReqFiscalYear" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	DISTINCT PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	PR.FISCALYEARID = FY.FISCALYEARID
		ORDER BY	FY.FISCALYEAR_2DIGIT
	</CFQUERY>

	<CFQUERY name="ListFundAccts" datasource="#application.type#PURCHASING" blockfactor="15">
		SELECT	FUNDACCTID, FUNDACCTNAME
		FROM		FUNDACCTS
		ORDER BY	FUNDACCTNAME
	</CFQUERY>
     
     <CFQUERY name="ListBudgetTypes" datasource="#application.type#PURCHASING" blockfactor="15">
          SELECT	BUDGETTYPEID, BUDGETTYPENAME
          FROM		BUDGETTYPES
          ORDER BY	BUDGETTYPENAME
     </CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Select Data for IDT Purchase Requisitions - <BR>Purchase Count Reports Lookup</H1>
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/purchasing/purchcountreports.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">
                    <COM>
                         Select one of the seven (7) reports below, then click the Select Options button.<BR>
                         (The first two (2) reports assume that a matching Service Request exists in the SR Database Application.)
                    </COM>
              </TD>
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
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" CHECKED align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE1">REPORT 1: &nbsp;&nbsp;Purchase Req</LABEL>
				<LABEL for="FISCALYEARID1">for a Specific Fiscal Year</LABEL> By Problem Sub-Categories
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FISCALYEARID1" id="FISCALYEARID1" size="1" query="LookupPurchReqFiscalYear" value="FISCALYEARID" selected="0" display="FISCALYEAR_2DIGIT" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE2">REPORT 2: &nbsp;&nbsp;Purchase Req By Problem Sub-Categories</LABEL>
				<LABEL for="REQFILEDDATE2"> and <BR />(1) a single Filed Date <BR /><BR /> OR (2) a series of Filed Dates separated <BR />
				by commas,NO spaces<BR /><BR /> OR (3) two Filed Dates separated by a<BR />
				semicolon for range.</LABEL>
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="Text" name="REQFILEDDATE2" id="REQFILEDDATE2" value="" required="No" size="35" tabindex="6"><BR>
                    <COM>&nbsp;Date Format: MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="3"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="9">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE3">REPORT 3: &nbsp;&nbsp;Purchase Req</LABEL>
				<LABEL for="FISCALYEARID3">for a Specific Fiscal Year</LABEL> by Fund/Budget Type
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FISCALYEARID3" id="FISCALYEARID3" size="1" query="LookupPurchReqFiscalYear" value="FISCALYEARID" selected="0" display="FISCALYEAR_2DIGIT" required="No" tabindex="10"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="11">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE4">REPORT 4: &nbsp;&nbsp;Purchase Req By Fund/Budget Type</LABEL>
				<LABEL for="REQFILEDDATE4"> and<BR />(1) a single Filed Date <BR /><BR /> OR (2) a series of Filed Dates separated <BR />
				by commas,NO spaces<BR /><BR /> OR (3) two Filed Dates separated by a<BR />
				semicolon for range.</LABEL>
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="Text" name="REQFILEDDATE4" id="REQFILEDDATE4" value="" required="No" size="35" tabindex="12"><BR>
                    <COM>&nbsp;Date Format: MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="13">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE5">REPORT 5: &nbsp;&nbsp;Purchase Req</LABEL>
				<LABEL for="FUNDACCTID5">By Specific Fund Account Only</LABEL>
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FUNDACCTID5" id="FUNDACCTID5" size="1" query="ListFundAccts" value="FUNDACCTID" display="FUNDACCTNAME" required="No" tabindex="14"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="15">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE6">REPORT 6: &nbsp;&nbsp;Purchase Req</LABEL>
                    <LABEL for="FISCALYEARID6">for a Specific Fiscal Year</LABEL>
				<LABEL for="FUNDACCTID6">By Specific Fund</LABEL>/<LABEL for="BUDGETTYPEID6">Budget Type</LABEL>			
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FUNDACCTID6" id="FUNDACCTID6" size="1" query="ListFundAccts" value="FUNDACCTID" display="FUNDACCTNAME" required="No" tabindex="16"></CFSELECT>&nbsp;&nbsp;
				<CFSELECT name="FISCALYEARID6" id="FISCALYEARID6" size="1" query="LookupPurchReqFiscalYear" value="FISCALYEARID" selected="0" display="FISCALYEAR_2DIGIT" required="No" tabindex="17"></CFSELECT><BR>
                    <CFSELECT name="BUDGETTYPEID6" id="BUDGETTYPEID6" size="1" query="ListBudgetTypes" value="BUDGETTYPEID" display="BUDGETTYPENAME" required="No" tabindex="18"></CFSELECT>

			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE7" value="7" align="LEFT" required="No" tabindex="19">
			</TD>
			<TH align="left" valign="TOP">
				<LABEL for="REPORTCHOICE7">REPORT 7: &nbsp;&nbsp;Purchase Req</LABEL>
				<LABEL for="FUNDACCTID7">By Specific Fund</LABEL>/<LABEL for="BUDGETTYPEID7">Budget Type</LABEL>
				<LABEL for="REQFILEDDATE7">and <BR />(1) a single Filed Date <BR /><BR /> OR (2) a series of Filed Dates separated <BR />
				by commas,NO spaces<BR /><BR /> OR (3) two Filed Dates separated by a<BR />
				semicolon for range.</LABEL>
			</TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FUNDACCTID7" id="FUNDACCTID7" size="1" query="ListFundAccts" value="FUNDACCTID" display="FUNDACCTNAME" required="No" tabindex="20"></CFSELECT>&nbsp;&nbsp;
				<CFINPUT type="Text" name="REQFILEDDATE7" id="REQFILEDDATE7" value="" required="No" size="35" tabindex="21"><BR>
                    <CFSELECT name="BUDGETTYPEID7" id="BUDGETTYPEID7" size="1" query="ListBudgetTypes" value="BUDGETTYPEID" display="BUDGETTYPENAME" required="No" tabindex="22"></CFSELECT>   
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <COM>Date Format: MM/DD/YYYYY </COM><BR>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
               <TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="23" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="24" /><BR />
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
********************************************************************************************************
* The following code is the process for IDT Purchase Requisitions - Purchase Count Reports generation. *
********************************************************************************************************
 --->

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'PSC.SUBCATEGORYNAME~ PR.SERVICEREQUESTNUMBER'>
	<CFSET SORTORDER[2] = 'PSC.SUBCATEGORYNAME~ PR.SERVICEREQUESTNUMBER'>
	<CFSET SORTORDER[3] = 'FA.FUNDACCTNAME~ BT.BUDGETTYPENAME~ PR.SERVICEREQUESTNUMBER'>
	<CFSET SORTORDER[4] = 'FA.FUNDACCTNAME~ BT.BUDGETTYPENAME~ PR.SERVICEREQUESTNUMBER'>
	<CFSET SORTORDER[5] = 'FA.FUNDACCTNAME~ PR.PONUMBER'>
	<CFSET SORTORDER[6] = 'FA.FUNDACCTNAME~ BT.BUDGETTYPENAME~ PR.SERVICEREQUESTNUMBER'>
	<CFSET SORTORDER[7] = 'FA.FUNDACCTNAME~ BT.BUDGETTYPENAME~ PR.SERVICEREQUESTNUMBER'>
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

	<CFIF FIND('~', #REPORTORDER#, 1) NEQ 0>
		<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>
	</CFIF>
	
	<CFIF IsDefined('FORM.FISCALYEARID#EVALUATE(FORM.REPORTCHOICE)#')>
		<CFSET CLIENT.FIELDNAME = "FORM.FISCALYEARID#EVALUATE(FORM.REPORTCHOICE)#">
		<CFSET FORM.FISCALYEARID = "#EVALUATE(CLIENT.FIELDNAME)#">
		<CFSET CLIENT.FISCALYEARID = "#EVALUATE(CLIENT.FIELDNAME)#">
	</CFIF>
	<CFIF IsDefined('FORM.FUNDACCTID#EVALUATE(FORM.REPORTCHOICE)#')>
		<CFSET CLIENT.FIELDNAME = "FORM.FUNDACCTID#EVALUATE(FORM.REPORTCHOICE)#">
		<CFSET FORM.FUNDACCTID = "#EVALUATE(CLIENT.FIELDNAME)#">
	</CFIF>
     
     <CFIF IsDefined('FORM.BUDGETTYPEID#EVALUATE(FORM.REPORTCHOICE)#')>
		<CFSET CLIENT.FIELDNAME = "FORM.BUDGETTYPEID#EVALUATE(FORM.REPORTCHOICE)#">
		<CFSET FORM.BUDGETTYPEID = "#EVALUATE(CLIENT.FIELDNAME)#">
	</CFIF>
	
	<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 7>

		<CFSET REQFILEDDATELIST = "NO">
		<CFSET REQFILEDDATERANGE = "NO">
		<CFSET CLIENT.FIELDNAME = "FORM.REQFILEDDATE#EVALUATE(FORM.REPORTCHOICE)#">
		<CFSET FORM.REQFILEDDATE = "#EVALUATE(CLIENT.FIELDNAME)#">
		<CFIF FIND(',', #FORM.REQFILEDDATE#, 1) EQ 0 AND FIND(';', #FORM.REQFILEDDATE#, 1) EQ 0>
			<CFSET FORM.REQFILEDDATE = DateFormat(FORM.REQFILEDDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.REQFILEDDATE#, 1) NEQ 0>
				<CFSET REQFILEDDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.REQFILEDDATE#, 1) NEQ 0>
				<CFSET REQFILEDDATERANGE = "YES">
				<CFSET FORM.REQFILEDDATE = #REPLACE(FORM.REQFILEDDATE, ";", ",")#>
			</CFIF>
			<CFSET REQFILEDDATEARRAY = ListToArray(FORM.REQFILEDDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(REQFILEDDATEARRAY)# >
				REQFILED DATE FIELD #COUNTER# = #REQFILEDDATEARRAY[COUNTER]#<BR /><BR />
			</CFLOOP>
		</CFIF>
		<CFIF REQFILEDDATERANGE EQ "YES">
			<CFSET BEGINREQFILEDDATE = DateFormat(#REQFILEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDREQFILEDDATE = DateFormat(#REQFILEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		REQFILED DATE LIST = #REQFILEDDATELIST#<BR /><BR />
		REQFILED DATE RANGE = #REQFILEDDATERANGE#<BR /><BR />
	</CFIF>
	<CFIF #FORM.REPORTCHOICE# LT 3>
		<CFQUERY name="ListPurchReqs" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, SR.SERVICEREQUESTNUMBER, PC.CATEGORYNAME, PSC.SUBCATEGORYNAME,
					PR.CREATIONDATE, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, PR.REQUESTERID, CUST.FULLNAME, PR.PURCHREQUNITID, U.UNITNAME,
					PR.FUNDACCTID, PR.BUDGETTYPEID, PR.TOTAL, PR.REQNUMBER, PR.PONUMBER, PR.REQFILEDDATE, PR.CANCELLATION
			FROM		PURCHREQS PR, SRMGR.SERVICEREQUESTS SR, SRMGR.PROBLEMCATEGORIES PC, SRMGR.PROBLEMSUBCATEGORIES PSC,
					LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY, LIBSHAREDDATAMGR.UNITS U
			WHERE	PR.PURCHREQID > 0 AND
               		PR.REQUESTERID > 0 AND
               		PR.SERVICEREQUESTNUMBER = SR.SERVICEREQUESTNUMBER AND
					SR.PROBLEM_CATEGORYID = PC.CATEGORYID AND
					SR.PROBLEM_SUBCATEGORYID = PSC.SUBCATEGORYID AND
					PR.REQUESTERID = CUST.CUSTOMERID AND
					PR.FISCALYEARID = FY.FISCALYEARID AND
					PR.PURCHREQUNITID = U.UNITID AND
				<CFIF #FORM.REPORTCHOICE# EQ 1>
					PR.FISCALYEARID = #val(FORM.FISCALYEARID)# AND
				</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 2>
			<CFIF REQFILEDDATELIST EQ "YES">
				<CFSET ARRAYCOUNT = (ArrayLen(REQFILEDDATEARRAY) - 1)>
					(
				<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
					<CFSET FORMATREQFILEDDATE = DateFormat(#REQFILEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					PR.REQFILEDDATE = TO_DATE('#FORMATREQFILEDDATE#', 'DD-MON-YYYY') OR
				</CFLOOP>
				<CFSET FORMATREQFILEDDATE = DateFormat(#REQFILEDDATEARRAY[ArrayLen(REQFILEDDATEARRAY)]#, 'DD-MMM-YYYY')>
					PR.REQFILEDDATE = TO_DATE('#FORMATREQFILEDDATE#', 'DD-MON-YYYY')) AND
			<CFELSEIF REQFILEDDATERANGE EQ "YES">
					(PR.REQFILEDDATE BETWEEN TO_DATE('#BEGINREQFILEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQFILEDDATE#', 'DD-MON-YYYY')) AND
			<CFELSE>
					PR.REQFILEDDATE LIKE TO_DATE('#FORM.REQFILEDDATE#', 'DD-MON-YYYY') AND
			</CFIF>
		</CFIF>
					SR.PROBLEM_CATEGORYID = 2 AND
                         PR.CANCELLATION = 'NO'
			ORDER BY	#REPORTORDER# 
		</CFQUERY>
	<CFELSE>
		<CFQUERY name="ListPurchReqs" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.CREATIONDATE, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, PR.REQUESTERID, CUST.FULLNAME,
					PR.PURCHREQUNITID, U.UNITNAME, PR.FUNDACCTID, FA.FUNDACCTNAME, PR.BUDGETTYPEID, BT.BUDGETTYPEID, BT.BUDGETTYPENAME, PR.TOTAL,
                         PR.REQNUMBER, PR.PONUMBER, PR.PURCHASEJUSTIFICATION, PR.RECVCOMMENTS, PR.COMPLETIONDATE, PR.REQFILEDDATE, PR.CANCELLATION
			FROM		PURCHREQS PR, FUNDACCTS FA, BUDGETTYPES BT, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY, LIBSHAREDDATAMGR.UNITS U
			WHERE	PR.PURCHREQID > 0 AND
               		PR.REQUESTERID > 0 AND
				<CFIF #FORM.REPORTCHOICE# GT 4 AND #FORM.REPORTCHOICE# LT 8>
					PR.FUNDACCTID = #val(FORM.FUNDACCTID)# AND
				</CFIF>
                    <CFIF #FORM.REPORTCHOICE# EQ 6 OR #FORM.REPORTCHOICE# EQ 7>
                    	PR.BUDGETTYPEID = #val(FORM.BUDGETTYPEID)# AND
                    </CFIF>
				<CFIF #FORM.REPORTCHOICE# EQ 3 OR #FORM.REPORTCHOICE# EQ 6>
					PR.FISCALYEARID = #val(FORM.FISCALYEARID)# AND
				</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 4 OR #FORM.REPORTCHOICE# EQ 7>
			<CFIF REQFILEDDATELIST EQ "YES">
				<CFSET ARRAYCOUNT = (ArrayLen(REQFILEDDATEARRAY) - 1)>
					(
				<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
					<CFSET FORMATREQFILEDDATE = DateFormat(#REQFILEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
					PR.REQFILEDDATE = TO_DATE('#FORMATREQFILEDDATE#', 'DD-MON-YYYY') OR
				</CFLOOP>
				<CFSET FORMATREQFILEDDATE = DateFormat(#REQFILEDDATEARRAY[ArrayLen(REQFILEDDATEARRAY)]#, 'DD-MMM-YYYY')>
					PR.REQFILEDDATE = TO_DATE('#FORMATREQFILEDDATE#', 'DD-MON-YYYY')) AND
			<CFELSEIF REQFILEDDATERANGE EQ "YES">
					(PR.REQFILEDDATE BETWEEN TO_DATE('#BEGINREQFILEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQFILEDDATE#', 'DD-MON-YYYY')) AND
			<CFELSE>
					PR.REQFILEDDATE LIKE TO_DATE('#FORM.REQFILEDDATE#', 'DD-MON-YYYY') AND
			</CFIF>
		</CFIF>
					PR.FUNDACCTID = FA.FUNDACCTID AND
                         PR.BUDGETTYPEID = BT.BUDGETTYPEID AND
					PR.REQUESTERID = CUST.CUSTOMERID AND
					PR.FISCALYEARID = FY.FISCALYEARID AND
					PR.PURCHREQUNITID = U.UNITID AND
                         PR.CANCELLATION = 'NO'
			ORDER BY	#REPORTORDER# DESC
		</CFQUERY>
	</CFIF>

	<CFSET REPORTTITLE = ''>
	<CFSET PURCHREQRECORDCOUNT = 0>
	<CFSET SUBCATCOUNT = 0>
	<CFSET FAPRICETOTALCOUNT = 0.00>
	<CFSET PRICETOTALCOUNT = 0.00>

	<CFIF #FORM.REPORTCHOICE# EQ 1>
		<CFSET REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;Purchase Req By Problem Sub-Categories for a Specific FY &nbsp;&nbsp; - &nbsp;&nbsp; #ListPurchReqs.FISCALYEAR_2DIGIT#'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFSET REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;Purchase Req By Problem Sub-Categories and Filed Date &nbsp;&nbsp; - &nbsp;&nbsp; #FORM.REQFILEDDATE#'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>
		<CFSET REPORTTITLE = 'REPORT 3: &nbsp;&nbsp;Purchase Req by Fund/Budget Type for a Specific FY &nbsp;&nbsp; - &nbsp;&nbsp; #ListPurchReqs.FISCALYEAR_2DIGIT#'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>
		<CFSET REPORTTITLE = 'REPORT 4: &nbsp;&nbsp;Purchase Req By Fund/Budget Type and Filed Date &nbsp;&nbsp; - &nbsp;&nbsp; #FORM.REQFILEDDATE#'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 5>
		<CFSET REPORTTITLE = 'REPORT 6: &nbsp;&nbsp;Purchase Req By Specific Fund Account Only &nbsp;&nbsp; - &nbsp;&nbsp; #ListPurchReqs.FUNDACCTNAME#'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 6>
		<CFSET REPORTTITLE = 'REPORT 6: &nbsp;&nbsp;Purchase Req By Specific Fund/Budget Type and a Specific FY &nbsp;&nbsp; <BR>&nbsp;&nbsp; #ListPurchReqs.FUNDACCTNAME# &nbsp;&nbsp; #ListPurchReqs.FISCALYEAR_2DIGIT#'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 7>
		<CFSET REPORTTITLE = 'REPORT 7: &nbsp;&nbsp;Purchase Req By Specific Fund/Budget Type and Filed Date &nbsp;&nbsp; <BR>&nbsp;&nbsp; #ListPurchReqs.FUNDACCTNAME# &nbsp;&nbsp; #FORM.REQFILEDDATE# '>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>IDT Purchase Requisitions - Purchase Count Reports</H1>
				<H2>#REPORTTITLE#</H2>
			</TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" border="0" align="left">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/purchcountreports.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<CFSET REPORTHEADER = "">
          
<CFLOOP query="ListPurchReqs">

	<CFIF #FORM.REPORTCHOICE# LT 3>
		<CFIF REPORTHEADER NEQ #ListPurchReqs.SUBCATEGORYNAME#>
			<CFIF #PURCHREQRECORDCOUNT# GT 0>
          <TR>
			<TH align="CENTER" colspan="9">
				<H2> #SUBCATCOUNT# Purchase Requisition records for #REPORTHEADER# Sub-Category were selected.</H2>
			</TH>
          </TR>
			</CFIF>
			<CFSET SUBCATCOUNT = 0>
			<CFSET REPORTHEADER = #ListPurchReqs.SUBCATEGORYNAME#>
           <TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
           <TR>
			<TD colspan="5"><HR width="100%" size="5" noshade /></TD>
		</TR>
           <TR>
          	<TH align="CENTER" valign="BOTTOM"><STRONG>SR Number</STRONG></TH>
               <TH align="CENTER" valign="BOTTOM"><STRONG>P. O. Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requisition Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requester</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Unit</STRONG></TH>
		</TR>
		<TR>
			<TD colspan="5"><HR width="100%" size="5" noshade /></TD>
		</TR>
         
		<TR>
			<TH align="left" nowrap colspan="5"><H2>#REPORTHEADER#</H2></TH>
		</TR>
          </CFIF>
          <TR>
			<TD align="CENTER" valign="TOP"><DIV>#ListPurchReqs.SERVICEREQUESTNUMBER#</DIV></TD>
               <TD align="CENTER" valign="TOP"><DIV>#ListPurchReqs.PONUMBER#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListPurchReqs.REQNUMBER#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListPurchReqs.FULLNAME#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListPurchReqs.UNITNAME#</DIV></TD>
          </TR>
          <TR>
			<TD colspan="5"><HR></TD>
		</TR>
		<CFSET SUBCATCOUNT = #SUBCATCOUNT# + 1>

	<CFELSEIF #FORM.REPORTCHOICE# GT 2>
     
     <CFIF #FORM.REPORTCHOICE# EQ 5>
          <CFIF REPORTHEADER NEQ "#ListPurchReqs.FUNDACCTNAME#">    
          	<CFIF #PURCHREQRECORDCOUNT# GT 0>
          <TR>
			<TH align="CENTER" colspan="8">
				<H2> Total Price for Fund Account #REPORTHEADER# is #NumberFormat(FAPRICETOTALCOUNT, '$___,___,___.__')#.</H2>
               </TH>
          </TR>
			</CFIF>
			<CFSET FAPRICETOTALCOUNT = 0.00>
           	<CFSET REPORTHEADER = "#ListPurchReqs.FUNDACCTNAME#">
          <TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
          	<TH align="CENTER" valign="BOTTOM"><STRONG>P. O. Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requisition Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requester</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Purchase Justification</STRONG></TH>
               <TH align="CENTER" valign="BOTTOM">&nbsp;&nbsp;</TD>
               <TH align="CENTER" valign="BOTTOM"><STRONG>Receiving Comments</STRONG></TH>
               <TH align="CENTER" valign="BOTTOM" NOWRAP><STRONG>Completion Date</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM" NOWRAP><STRONG>Total Price</STRONG></TH>
          </TR>
		<TR>
			<TD colspan="8"><HR></TD>
		</TR>
		<TR>
			<TH align="left" nowrap colspan="8"><H2><STRONG>#REPORTHEADER#</STRONG></H2></TH>
		</TR>
          </CFIF>
	<CFELSE>

		<CFIF REPORTHEADER NEQ "#ListPurchReqs.FUNDACCTNAME# / #ListPurchReqs.BUDGETTYPENAME#">
			<CFIF #PURCHREQRECORDCOUNT# GT 0>
          <TR>
			<TH align="CENTER" colspan="8">
				<H2> Total Price for Fund Account #REPORTHEADER# is #NumberFormat(FAPRICETOTALCOUNT, '$___,___,___.__')#.</H2>
               </TH>
          </TR>
			</CFIF>
			<CFSET FAPRICETOTALCOUNT = 0.00>
			<CFSET REPORTHEADER = "#ListPurchReqs.FUNDACCTNAME# / #ListPurchReqs.BUDGETTYPENAME#">
          <TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
          	<TH align="CENTER" valign="BOTTOM"><STRONG>P. O. Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requisition Number</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Requester</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM"><STRONG>Purchase Justification</STRONG></TH>
               <TH align="CENTER" valign="BOTTOM">&nbsp;&nbsp;</TD>
               <TH align="CENTER" valign="BOTTOM"><STRONG>Receiving Comments</STRONG></TH>
               <TH align="CENTER" valign="BOTTOM" NOWRAP><STRONG>Completion Date</STRONG></TH>
			<TH align="CENTER" valign="BOTTOM" NOWRAP><STRONG>Total Price</STRONG></TH>
          </TR>
		<TR>
			<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="left" nowrap colspan="8"><H2><STRONG>#REPORTHEADER#</STRONG></H2></TH>
		</TR>
		</CFIF>
	</CFIF>
          <TR>
			<TD align="CENTER" valign="TOP"><DIV>#ListPurchReqs.PONUMBER#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListPurchReqs.REQNUMBER#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListPurchReqs.FULLNAME#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#ListPurchReqs.PURCHASEJUSTIFICATION#</DIV></TD>
               <TD align="LEFT" valign="TOP"><DIV>&nbsp;&nbsp;</DIV></TD>
               <TD align="LEFT" valign="TOP"><DIV>#ListPurchReqs.RECVCOMMENTS#</DIV></TD>
               <TD align="CENTER" valign="TOP"><DIV>#DateFormat(ListPurchReqs.COMPLETIONDATE, 'MM/DD/YYYY')#</DIV></TD>
			<TD align="LEFT" valign="TOP" NOWRAP>
				<DIV>#NumberFormat(ListPurchReqs.TOTAL, '$___,___,___.__')#</DIV>
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="8"><HR /></TD>
		</TR>
		<CFSET FAPRICETOTALCOUNT = #FAPRICETOTALCOUNT# + #ListPurchReqs.TOTAL#>
		<CFSET PRICETOTALCOUNT = #PRICETOTALCOUNT# + #ListPurchReqs.TOTAL#>
	</CFIF>
	<CFSET PURCHREQRECORDCOUNT = #PURCHREQRECORDCOUNT# + 1>
		
		
</CFLOOP>
	<CFIF #FORM.REPORTCHOICE# LT 3>
		<TR>
			<TH align="CENTER" colspan="5">
				<H2> #SUBCATCOUNT# Purchase Requisition records for #REPORTHEADER# Sub-Category were selected.</H2>
			</TH>
	<CFELSEIF #FORM.REPORTCHOICE# GT 2>
			<TH align="CENTER" colspan="8">
				<H2> Total Price for Fund Account #REPORTHEADER# is #NumberFormat(FAPRICETOTALCOUNT, '$___,___,___.__')#.</H2>
			</TH>
		</TR>
	</CFIF>	
		<TR>
			<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
		</TR>
    <CFIF #FORM.REPORTCHOICE# LT 3>
		<TR>
			<TH align="CENTER" colspan="5">
				<H2>#PURCHREQRECORDCOUNT# Purchase Requisition records were selected.</H2>
			</TH>
		</TR>
	<CFELSE>
     	<TR>
			<TH align="CENTER" colspan="8">
				<H2>#PURCHREQRECORDCOUNT# Purchase Requisition records were selected.</H2>
			</TH>
		</TR>
		<TR>
			<TH align="CENTER" colspan="8">
				<H2> Total Price is #NumberFormat(PRICETOTALCOUNT, '$___,___,___.__')#.</H2>
			</TH>
		</TR>
	</CFIF>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/purchcountreports.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="9"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

</CFIF>

</BODY>
</CFOUTPUT>
</HTML>