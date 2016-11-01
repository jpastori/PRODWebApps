<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchreqforms.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: IDT Purchase Requisitions - Purchase Forms Report--->
<!-- Last modified by John R. Pastori on 04/20/2015 using ColdFusion Studio. -->


<CFINCLUDE template = "../programsecuritycheck.cfm">

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Purchasing";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupField() {
		if (document.LOOKUP.PURCHREQID1.selectedIndex == "0"  && document.LOOKUP.PURCHREQID2.selectedIndex == "0"
		 && document.LOOKUP.PURCHREQID3.selectedIndex == "0"  && document.LOOKUP.PURCHREQID4.selectedIndex == "0"
		 && document.LOOKUP.PURCHREQID5.selectedIndex == "0") {
			alertuser ("At least one dropdown field must be selected!");
			document.LOOKUP.PURCHREQID1.focus();
			return false;
		}

		if ((document.LOOKUP.PURCHREQID1.selectedIndex > "0"   && (document.LOOKUP.PURCHREQID2.selectedIndex > "0"
		 ||  document.LOOKUP.PURCHREQID3.selectedIndex > "0"   ||  document.LOOKUP.PURCHREQID4.selectedIndex > "0"
		 ||  document.LOOKUP.PURCHREQID5.selectedIndex > "0")) || (document.LOOKUP.PURCHREQID2.selectedIndex > "0"
		 && (document.LOOKUP.PURCHREQID1.selectedIndex > "0"   || document.LOOKUP.PURCHREQID3.selectedIndex > "0"
		 || document.LOOKUP.PURCHREQID4.selectedIndex > "0"    || document.LOOKUP.PURCHREQID5.selectedIndex > "0"))
		 || (document.LOOKUP.PURCHREQID3.selectedIndex > "0"   && (document.LOOKUP.PURCHREQID1.selectedIndex > "0"
		 ||  document.LOOKUP.PURCHREQID2.selectedIndex > "0"   || document.LOOKUP.PURCHREQID4.selectedIndex > "0"   
		 ||  document.LOOKUP.PURCHREQID5.selectedIndex > "0")) || (document.LOOKUP.PURCHREQID4.selectedIndex > "0"  
		 && (document.LOOKUP.PURCHREQID1.selectedIndex > "0"   ||  document.LOOKUP.PURCHREQID2.selectedIndex > "0"   
		 || document.LOOKUP.PURCHREQID3.selectedIndex > "0"    ||  document.LOOKUP.PURCHREQID5.selectedIndex > "0"))
		 || (document.LOOKUP.PURCHREQID5.selectedIndex > "0"   && (document.LOOKUP.PURCHREQID1.selectedIndex > "0"   
		 ||  document.LOOKUP.PURCHREQID2.selectedIndex > "0"   || document.LOOKUP.PURCHREQID3.selectedIndex > "0"    
		 ||  document.LOOKUP.PURCHREQID4.selectedIndex > "0"))){
			 alertuser ("Only One dropdown field can be selected");
			 document.LOOKUP.PURCHREQID1.focus();
			 return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

<!--- 
***************************************************************************************************
* The following code is the Look Up Process for the IDT Purchase Requisitions - Purchase Reports. *
***************************************************************************************************
 --->
 
     <CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<CFQUERY name="LookupCurrYrReqNumbers" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.REQNUMBER, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, FY.FISCALYEAR_4DIGIT,
				PR.REQUESTERID, CUST.FULLNAME, PR.SERVICEREQUESTNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT || ' - ' || CUST.FULLNAME AS LOOKUPKEY
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(PR.REQUESTERID = CUST.CUSTOMERID AND
				PR.FISCALYEARID = FY.FISCALYEARID) AND ((
			<CFIF (IsDefined('URL.PURCHREQID')) AND (IsDefined('URL.FISCALYEAR') AND #URL.FISCALYEAR# GTE #ListCurrentFiscalYear.FISCALYEARID#)>
                    PR.PURCHREQID = <CFQUERYPARAM value="#URL.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> AND
               </CFIF>
                    NOT REQNUMBER = ' ' AND
                    PR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) OR
                    (PR.PURCHREQID = 0))
		ORDER BY	PR.SERVICEREQUESTNUMBER DESC
	</CFQUERY>
     
     <CFQUERY name="LookupPrevYrReqNumbers" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.REQNUMBER, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, FY.FISCALYEAR_4DIGIT, 
				PR.REQUESTERID, CUST.FULLNAME, PR.SERVICEREQUESTNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT || ' - ' || CUST.FULLNAME AS LOOKUPKEY
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(PR.REQUESTERID = CUST.CUSTOMERID AND
				PR.FISCALYEARID = FY.FISCALYEARID) AND ((
			<CFIF (IsDefined('URL.PURCHREQID')) AND (IsDefined('URL.FISCALYEAR') AND #URL.FISCALYEAR# LT #ListCurrentFiscalYear.FISCALYEARID#)>
                    PR.PURCHREQID = <CFQUERYPARAM value="#URL.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> AND
               </CFIF>
                    NOT REQNUMBER = ' ' AND
                    PR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) OR
                    (PR.PURCHREQID = 0))
		ORDER BY	PR.SERVICEREQUESTNUMBER DESC
	</CFQUERY>

	<CFQUERY name="LookupSalesOrderNumbers" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.SALESORDERNUMBER, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, FY.FISCALYEAR_4DIGIT,
				PR.REQUESTERID, CUST.FULLNAME, PR.SALESORDERNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT || ' - ' || CUST.FULLNAME AS LOOKUPKEY
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	NOT PR.SALESORDERNUMBER = ' ' AND
				PR.REQUESTERID = CUST.CUSTOMERID AND
				PR.FISCALYEARID = FY.FISCALYEARID
		ORDER BY	PR.SERVICEREQUESTNUMBER DESC, PR.SALESORDERNUMBER
	</CFQUERY>

	<CFQUERY name="LookupCurrYrPurchaseOrderNumbers" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.PONUMBER, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, FY.FISCALYEAR_4DIGIT,
				PR.REQUESTERID, CUST.FULLNAME, PR.PONUMBER || ' - ' || FY.FISCALYEAR_2DIGIT || ' - ' || CUST.FULLNAME AS LOOKUPKEY
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(PR.REQUESTERID = CUST.CUSTOMERID AND
				PR.FISCALYEARID = FY.FISCALYEARID) AND
                    ((NOT PR.PONUMBER = ' ' AND 
                    PR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) OR
                    (PR.PURCHREQID = 0))
		ORDER BY	PR.SERVICEREQUESTNUMBER DESC, PR.PONUMBER
	</CFQUERY>
     
     <CFQUERY name="LookupPrevYrPurchaseOrderNumbers" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.PONUMBER, PR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, FY.FISCALYEAR_4DIGIT,
				PR.REQUESTERID, CUST.FULLNAME, PR.PONUMBER || ' - ' || FY.FISCALYEAR_2DIGIT || ' - ' || CUST.FULLNAME AS LOOKUPKEY
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(PR.REQUESTERID = CUST.CUSTOMERID AND
				PR.FISCALYEARID = FY.FISCALYEARID) AND
                    ((NOT PR.PONUMBER = ' ' AND
                    PR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) OR
                    (PR.PURCHREQID = 0))
		ORDER BY	PR.SERVICEREQUESTNUMBER DESC, PR.PONUMBER
	</CFQUERY>

<CFOUTPUT>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>#REPORTTITLE#</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H2>
				Select only one of the five dropdown fields and click the GO button.
			</H2></TH>
		</TR>
	</TABLE>
		<BR />
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="#PROCESSPROGRAM#" method="POST">
		<TR>
			<TH align="LEFT" valign="TOP" width="40%"><LABEL for="PURCHREQID1">Select by SR - FY - Customer For Current Fiscal Year & CFY+1: </LABEL></TH>
			<TD align="LEFT" valign="TOP" width="60%">
               <CFIF IsDefined('URL.PURCHREQID')>
				<CFSELECT name="PURCHREQID1" id="PURCHREQID1" size="1" query="LookupCurrYrReqNumbers" value="PURCHREQID" display="LOOKUPKEY" selected="#URL.PURCHREQID#" required="No" tabindex="2"></CFSELECT>
               <CFELSE>
               	<CFSELECT name="PURCHREQID1" id="PURCHREQID1" size="1" query="LookupCurrYrReqNumbers" value="PURCHREQID" display="LOOKUPKEY" selected="0" required="No" tabindex="2"></CFSELECT>
               </CFIF>
			</TD>
		</TR>
		<TR>
          	<TH align="LEFT" valign="TOP" width="40%"><LABEL for="PURCHREQID2">Or Select by SR - FY - Customer For Previous Fiscal Years: </LABEL></TH>
			<TD align="LEFT" valign="TOP" width="60%">
               <CFIF IsDefined('URL.PURCHREQID')>
               	<CFSELECT name="PURCHREQID2" id="PURCHREQID2" size="1" query="LookupPrevYrReqNumbers" value="PURCHREQID" display="LOOKUPKEY" selected="#URL.PURCHREQID#" required="No" tabindex="3"></CFSELECT>
               <CFELSE>
				<CFSELECT name="PURCHREQID2" id="PURCHREQID2" size="1" query="LookupPrevYrReqNumbers" value="PURCHREQID" display="LOOKUPKEY" selected="0" required="No" tabindex="3"></CFSELECT>
               </CFIF>
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="TOP" width="40%"><LABEL for="PURCHREQID3">Or Select by P. O. Number - FY - Customer For Current Fiscal Year & CFY+1: </LABEL></TH>
			<TD align="LEFT" valign="TOP" width="60%">
				<CFSELECT name="PURCHREQID3" id="PURCHREQID3" size="1" query="LookupCurrYrPurchaseOrderNumbers" value="PURCHREQID" display="LOOKUPKEY" selected="0" required="No" tabindex="4"></CFSELECT>
               </TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="TOP" width="40%"><LABEL for="PURCHREQID4">Or Select by P. O. Number - FY - Customer For Previous Fiscal Years: </LABEL></TH>
			<TD align="LEFT" valign="TOP" width="60%">
				<CFSELECT name="PURCHREQID4" id="PURCHREQID4" size="1" query="LookupPrevYrPurchaseOrderNumbers" value="PURCHREQID" display="LOOKUPKEY" selected="0" required="No" tabindex="5">></CFSELECT>
               </TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
               <TH align="LEFT" valign="TOP" width="40%"><LABEL for="PURCHREQID5">Or Sales Order Number: </LABEL></TH>
          	<TD align="LEFT" valign="TOP" width="60%">
				<CFSELECT name="PURCHREQID5" id="PURCHREQID5" size="1" query="LookupSalesOrderNumbers" value="PURCHREQID" display="LOOKUPKEY" selected="0" required="No" tabindex="6"></CFSELECT><BR />
                    <COM>(This dropdown is used by fiscal year 04/05 and earlier records only.)</COM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
	<CFIF IsDefined('REPORTTYPE') AND #REPORTTYPE# EQ 'FORMS REPORT'>
		<TR>
			<TH align="center" colspan="2"><H2>Click the radio button on the report you want to run. &nbsp;&nbsp;Only one report can be run at a time.</H2></TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="7"><LABEL for="REPORTCHOICE1">IDT Purchase Requisition Request</LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="8"><LABEL for="REPORTCHOICE2">Internal IDT Purchase Requisition Report</LABEL>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="9"><LABEL for="REPORTCHOICE3">Unit Hardware/Software Purchase Request</LABEL>
			</TD>
		</TR>
	</CFIF>
		<TR>
			<TD align="LEFT" colspan="2">
               	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="10" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="11" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

</CFOUTPUT>