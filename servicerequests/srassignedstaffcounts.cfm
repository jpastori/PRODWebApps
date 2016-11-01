<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srassignedstaffcounts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/04/2012 --->
<!--- Date in Production: 10/04/2012 --->
<!--- Module: IDT Service Requests - Assigned Staff Statistic Counts --->
<!-- Last modified by John R. Pastori on 06/27/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/srassignedstaffcounts.cfm">
<CFSET CONTENT_UPDATED = "June 27, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">


<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Assigned Staff Statistic Counts</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Service Requests";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


	function validateLookupFields() {
		if (document.LOOKUP.CUSTOMERID.selectedIndex == "0" ) {
			alertuser ("You must select a Staff Member.");
			document.LOOKUP.CUSTOMERID.focus();
			return false;
		}
		
		if ((document.LOOKUP.REPORTCHOICE[1].checked == "1" || document.LOOKUP.REPORTCHOICE[2].checked == "1")
		 && (document.LOOKUP.BEGINDATE.value == ""         || document.LOOKUP.ENDDATE.value == "")) {
			alertuser ("You must enter a BEGIN DATE and an END DATE if you chose REPORTS 2 or 3!");
			document.LOOKUP.BEGINDATE.focus();
			return false;
		}
	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.CUSTOMERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
********************************************************************************************************
* The following code is the Lookup Process for IDT Service Requests - Assigned Staff Statistic Counts. *
********************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Select Assigned Staff Statistic Counts</H1></TD>
		</TR>
	</TABLE>

<!--- 
******************************************************************************
* The following code is the table creating the selections for the 3 reports. *
******************************************************************************
 --->
 
 	<CFQUERY name="ListStaffCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUSTOMERID, FULLNAME, INITIALS, ACTIVE
          FROM		CUSTOMERS
          WHERE	INITIALS IS NOT NULL AND
                    ACTIVE = 'YES' AND
                    CUSTOMERID > 0
          ORDER BY	FULLNAME
     </CFQUERY>

	<TABLE width="100%" align="LEFT" border="0">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
           <TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
          
     <FIELDSET>
     <LEGEND>Primary Reports</LEGEND>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/srassignedstaffcounts.cfm?PROCESS=LOOKUP" method="POST">
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>SELECT ONE OF THE THREE (3) REPORTS BELOW</COM></TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP"><INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="2" /></TD>
               <TD align="LEFT" >&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
          	<TD align="LEFT" >&nbsp;&nbsp;</TD>
               <TD align="left">
                    <CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" required="No" tabindex="2">
                         <OPTION value="0">Select a Staff Member</OPTION>
                         <CFLOOP query="ListStaffCustomers">
                              <OPTION value="#CUSTOMERID#">#FULLNAME#</OPTION>
                         </CFLOOP>  
                    </CFSELECT>
                    &nbsp;&nbsp;(<COM> For Reports 1, 2 or 3.</COM>)
               </TD>
               <TD align="LEFT" >&nbsp;&nbsp;</TD>
          </TR>
          <TR>
			<TD align="LEFT" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1: Select Assigned Staff Statistic Counts for ALL SRs</LABEL><LABEL for="FISCALYEARID">in a specific Fiscal Year</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" selected="#ListCurrentFiscalYear.FISCALYEARID#" display="FISCALYEAR_4DIGIT" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE2">REPORT 2: Select Assigned Staff Statistic Counts for ALL SRs By Creation Date Range Below</LABEL></TH>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="6">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE3">REPORT 3: Select Assigned Staff Statistic Counts for COMPLETED SRs By Creation Date Range Below</LABEL></TH>
			<TD align="LEFT" >&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" >&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
				<TABLE width="100%" align="LEFT" border="0">
					<TR>
						<TH align="left" valign="TOP"><LABEL for="BEGINDATE">Begin Creation Date (if you chose REPORTS 2 or 3)</LABEL></TH>
						<TH align="left" valign="TOP"><LABEL for="ENDDATE">End Creation Date (if you chose REPORTS 2 or 3)</LABEL></TH>
					</TR>
					<TR>
						<TD align="LEFT" valign="TOP">
							<CFINPUT type="TEXT" name="BEGINDATE" id="BEGINDATE" value="" required="No" size="15" maxlength="25" tabindex="7">
                                   <SCRIPT language="JavaScript">
								new tcal ({'formname': 'LOOKUP','controlname': 'BEGINDATE'});

							</SCRIPT>
						</TD>
						<TD align="LEFT" valign="TOP">
							<CFINPUT type="TEXT" name="ENDDATE" id="ENDDATE" value="" required="No" size="15" maxlength="25" tabindex="8">
                                   <SCRIPT language="JavaScript">
								new tcal ({'formname': 'LOOKUP','controlname': 'ENDDATE'});

							</SCRIPT><BR />
						</TD>
					</TR>
				</TABLE>
			</TD>
               <TD align="LEFT" >&nbsp;</TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP"><INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="9" /></TD>
               <TD valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
</CFFORM>
	</FIELDSET>
	<BR />

     <TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="9" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
               <TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
</CFFORM>
		</TR>
          <TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
********************************************************************************************************
* The following code is the IDT Service Requests - Assigned Staff Statistic Counts Generation Process. *
********************************************************************************************************
 --->

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'PC.CATEGORYNAME, SR.SERVICEREQUESTNUMBER'>
	<CFSET SORTORDER[2] = 'PC.CATEGORYNAME, SR.SERVICEREQUESTNUMBER'>
	<CFSET SORTORDER[3] = 'PC.CATEGORYNAME, SR.SERVICEREQUESTNUMBER'>
	
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>
	<!--- REPORT ORDER = #REPORTORDER#<BR /><BR /> --->
     
     <CFSET DATERANGEREPORT = "NO">
	<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 3>
		<CFSET DATERANGEREPORT = "YES">
		<CFSET BEGINDATE = #DateFormat(FORM.BEGINDATE, "dd/mmm/yyyy")#>
		<CFSET ENDDATE = #DateFormat(FORM.ENDDATE, "dd/mmm/yyyy")#>
		<!--- BEGIN DATE = #BEGINDATE# &nbsp;&nbsp;&nbsp;&nbsp;END DATE = #ENDDATE#<BR /><BR /> --->
	</CFIF>
     

	<CFQUERY name="ListAssignedStaffSRs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	WGA.STAFFCUSTOMERID, WGA.WORKGROUPASSIGNSID, SRSA.STAFF_ASSIGNEDID, CUST.FULLNAME, SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, 
				SR.CREATIONDATE, SR.PROBLEM_CATEGORYID, PC.CATEGORYNAME, PC.CATEGORYLETTER || PC.CATEGORYNAME AS PROBCATEGORY, SR.SRCOMPLETED
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, PROBLEMCATEGORIES PC 
		WHERE	WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
          		WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
          		WGA.WORKGROUPASSIGNSID = SRSA.STAFF_ASSIGNEDID AND
          		SRSA.SRID = SR.SRID AND
				SR.PROBLEM_CATEGORYID = PC.CATEGORYID AND
               <CFIF #FORM.REPORTCHOICE# EQ 1>
               	SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID#" cfsqltype="CF_SQL_VARCHAR"> AND
               </CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 3>
				SR.CREATIONDATE BETWEEN TO_DATE('#BEGINDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATE#', 'DD-MON-YYYY') AND
			</CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 3>
				SR.SRCOMPLETED = 'YES' AND
			</CFIF>
               	NOT SR.SRCOMPLETED = 'VOIDED' AND
               	SRSA.STAFF_ASSIGNEDID > 0
		ORDER BY	#REPORTORDER#
	</CFQUERY>

<!--- 
*******************************************************************************************
* The following code displays the IDT Service Requests - Assigned Staff Statistic Counts. *
*******************************************************************************************
 --->

     <CFSET CATNAME = "">
	<CFSET COLUMN1TITLE = "">
	<CFSET COLUMN2TITLE = "">
     <CFSET COMPAREITEMNAME = "">
     <CFSET COMPAREITEMNAME2 = "">
	<CFSET FIELDNAME = "">
	<CFSET ITEMNAME = "">
     <CFSET ITEMNAME2 = "">
	<CFSET ITEMSRCOUNT = 0>
     <CFSET PROBCATNAME = "">
	<CFSET REPORTTITLE = "">
	<CFSET TOTALSRCOUNT = 0>

	<CFSWITCH expression = #FORM.REPORTCHOICE#>
	
		<CFCASE value = 1>
			<CFSET COLUMN1TITLE = "Problem Category">
			<CFSET COLUMN2TITLE = "Assigned Staff Statistic Counts">
			<CFSET REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")# <BR> for Staff Assignments - #ListAssignedStaffSRs.FULLNAME#">
			<CFSET FIELDNAME = "ListAssignedStaffSRs.PROBCATEGORY">
			<CFSET COMPAREITEMNAME = #ListAssignedStaffSRs.PROBCATEGORY#>
		</CFCASE>
	
		<CFCASE value = 2>
			<CFSET COLUMN1TITLE = "Problem Category">
			<CFSET COLUMN2TITLE = "Assigned Staff Statistic Counts">
			<CFSET REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# <BR> for Staff Assignments - #ListAssignedStaffSRs.FULLNAME#">
			<CFSET FIELDNAME = "ListAssignedStaffSRs.PROBCATEGORY">
			<CFSET COMPAREITEMNAME = #ListAssignedStaffSRs.PROBCATEGORY#>
		</CFCASE>
	
		<CFCASE value = 3>
			<CFSET COLUMN1TITLE = "Problem Category">
			<CFSET COLUMN2TITLE = "Assigned Staff Statistic Counts">
			<CFSET REPORTTITLE = "#COLUMN2TITLE# From #DateFormat(BEGINDATE, "mm/dd/yyyy")# Thru #DateFormat(ENDDATE, "mm/dd/yyyy")# <BR> for Completed Staff Assignments - #ListAssignedStaffSRs.FULLNAME#">
			<CFSET FIELDNAME = "ListAssignedStaffSRs.PROBCATEGORY">
			<CFSET COMPAREITEMNAME = #ListAssignedStaffSRs.PROBCATEGORY#>
		</CFCASE>
	
     	<CFDEFAULTCASE>
			<CFSET COLUMN1TITLE = "Problem Category">
			<CFSET COLUMN2TITLE = "SR Count">
			<CFSET REPORTTITLE = "#COLUMN2TITLE# As Of #DateFormat(Now(), "mm/dd/yyyy")# - #ListAssignedStaffSRs.FULLNAME#">
			<CFSET FIELDNAME = "ListAssignedStaffSRs.PROBCATEGORY">
			<CFSET COMPAREITEMNAME = #ListAssignedStaffSRs.PROBCATEGORY#>
		</CFDEFAULTCASE>
		
	</CFSWITCH>

<!--- REPORT TITLE = #REPORTTITLE#<BR><BR>
COLUMN 1 TITLE = #COLUMN1TITLE#<BR><BR>
COLUMN 2 TITLE = #COLUMN2TITLE#<BR><BR>
FIELD NAME = #Evaluate("#FIELDNAME#")#<BR><BR>
COMPARE ITEM NAME = #COMPAREITEMNAME#<BR><BR> --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>#REPORTTITLE#</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="left" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/srassignedstaffcounts.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR><BR>
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="LEFT" valign="TOP" width="30%">#COLUMN1TITLE#</TH>
			<TH align="LEFT" valign="TOP" width="70%">#COLUMN2TITLE#</TH>
		</TR>
	<CFLOOP query="ListAssignedStaffSRs">
		<CFSET ITEMNAME = #Evaluate("#FIELDNAME#")#>
          <CFIF #FORM.REPORTCHOICE# EQ 9 OR #FORM.REPORTCHOICE# EQ 10>
			<CFSET CATNAME = #Evaluate("#PROBCATNAME#")#>
          </CFIF>
          <CFIF #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
			<CFSET ITEMNAME2 = #Evaluate("#FIELDNAME2#")#>
          </CFIF>
		<CFIF #COMPAREITEMNAME# EQ #ITEMNAME#>
			<!--- COMPARE ITEM NAME = #COMPAREITEMNAME#<BR><BR> --->
			<CFSET ITEMSRCOUNT = #ITEMSRCOUNT# + 1>
			<!--- ITEM SR COUNT = #ITEMSRCOUNT#<BR><BR> --->
		<CFELSE>
		<TR>
			<TD align="LEFT" valign="TOP" width="30%">
				<CFSET TOTALSRCOUNT  = #TOTALSRCOUNT# + #ITEMSRCOUNT#>
			<!--- <BR><BR>TOTAL SR COUNT = #TOTALSRCOUNT# --->
			<CFIF #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
                    #COMPAREITEMNAME# - #COMPAREITEMNAME2#
               </TD>
                    <CFSET COMPAREITEMNAME2 = #ITEMNAME2#>
               <CFELSE>
                    #COMPAREITEMNAME#
               </CFIF>
                    <CFSET COMPAREITEMNAME = #ITEMNAME#>
		<!---	SET NEW ITEM NAME = #COMPAREITEMNAME#<BR><BR> --->
			</TD>
			<TD align="LEFT" valign="TOP" width="70%">
				#NUMBERFORMAT(ITEMSRCOUNT, '___,___')#
				<CFSET ITEMSRCOUNT = 1>
		<!---	RESET ITEM SR COUNT = #ITEMSRCOUNT#<BR><BR> --->
			</TD>
		</TR>
          	<CFIF #FORM.REPORTCHOICE# EQ 9 OR #FORM.REPORTCHOICE# EQ 10> 
               	<CFIF NOT (#COMPARECATNAME# EQ #CATNAME#)>
          <TR>
			<TD colspan="2">
               	&nbsp;&nbsp;
                    	<CFSET COMPARECATNAME = #CATNAME#>
               </TD>
		</TR>
          		</CFIF>
			</CFIF>
		</CFIF>
	</CFLOOP>
		<TR>
          <CFIF #FORM.REPORTCHOICE# EQ 17 OR #FORM.REPORTCHOICE# EQ 18>
			<TD align="LEFT" valign="TOP" width="30%">
               	#ITEMNAME# - #ITEMNAME2#
               </TD>
		<CFELSE>
			<TD align="LEFT" valign="TOP" width="30%">#ITEMNAME#</TD>
          </CFIF>
			<TD align="LEFT" valign="TOP" width="70%">
				#NUMBERFORMAT(ITEMSRCOUNT, '___,___')#
				<CFSET TOTALSRCOUNT = #TOTALSRCOUNT# + #ITEMSRCOUNT#>
			</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="TOP" colspan="2"><H2>Total #COLUMN2TITLE# = #TOTALSRCOUNT#</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/srassignedstaffcounts.cfm" method="POST">
			<TD align="left">
               	<BR><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>