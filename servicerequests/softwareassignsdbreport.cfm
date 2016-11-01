<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwareassignsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/05/2013 --->
<!--- Date in Production: 03/05/2013 --->
<!--- Module: Service Requests - Software Assignments Report --->
<!-- Last modified by John R. Pastori on 05/13/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/softwareassignsdbreport.cfm">
<CFSET CONTENT_UPDATED = "May 13, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Service Requests - Software Assignments Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Service Requests - Software Assignments Report";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}
	
	
	function validateLookupFields() {
		if (document.LOOKUP.REPORTCHOICE[0].checked > "0" && document.LOOKUP.CONFIRMFLAG.selectedIndex == "0") {
			alertuser ("You MUST select a Confirm value from the Drop Down!");
			document.LOOKUP.CONFIRMFLAG.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[2].checked > "0" && document.LOOKUP.SRID3.selectedIndex == "0") {
			alertuser ("You MUST select a Customer/SR value from the Drop Down!");
			document.LOOKUP.SRID4.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[3].checked > "0" && document.LOOKUP.SRID4.selectedIndex == "0") {
			alertuser ("You MUST select a Customer/SR value from the Drop Down!");
			document.LOOKUP.SRID5.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[4].checked > "0" && document.LOOKUP.SRRANGE.value == "") {
			alertuser ("You MUST enter a range of SR Numbers in the text box!");
			document.LOOKUP.SRRANGE.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[5].checked > "0" && document.LOOKUP.HWSWID.selectedIndex == "0") {
			alertuser ("You MUST select a HWSW value from the Drop Down!");
			document.LOOKUP.HWSWID.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[6].checked > "0" && document.LOOKUP.HWSWSERIES.value == "") {
			alertuser ("You MUST enter a series of HWSW values in the text box!");
			document.LOOKUP.HWSWSERIES.focus();
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
****************************************************************************************************
* The following code is the Lookup Process for IDT Service Requests - Software Assignments Report. *
****************************************************************************************************
 --->

<CFQUERY name="LookupCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
     SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
     FROM		FISCALYEARS
     WHERE	(CURRENTFISCALYEAR = 'YES')
     ORDER BY	FISCALYEARID
</CFQUERY>
     
<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		ORDER BY	FISCALYEARID
	</CFQUERY>

     <CFQUERY name="LookupPreviousFiscalYears" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		WHERE	FISCALYEARID < <CFQUERYPARAM value="#LookupCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FISCALYEARID DESC
	</CFQUERY>

	<CFQUERY name="ListSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	UNIQUE SRID
		FROM		SRSOFTWASSIGNS
		ORDER BY	SRID
	</CFQUERY>

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, CUST.FULLNAME,
				CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(SRID = 0 OR 
				SR.SRID IN (#ValueList(ListSoftwareAssignments.SRID)#)) AND
				SR.REQUESTERID = CUST.CUSTOMERID
		ORDER BY	LOOKUPKEY
	</CFQUERY>
     
     <CFQUERY name="LookupPrevYrServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, CUST.FULLNAME,
				CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(SRID = 0 OR 
				SR.SRID IN (#ValueList(ListSoftwareAssignments.SRID)#)) AND
                    SR.FISCALYEARID < <CFQUERYPARAM value="#LookupCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SR.REQUESTERID = CUST.CUSTOMERID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFQUERY name="ListHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
		SELECT	HWSW_ID, HWSW_NAME
		FROM		HWSW
		WHERE	HWSW_ID = 0 OR
				SUBSTR(HWSW_NAME,1,2) = 'SW'
		ORDER BY	HWSW_NAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>SR Lookup - Software Assignments Report</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/softwareassignsdbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="CENTER" valign="TOP" colspan="3"><COM>SELECT ONE OF THE SEVEN (7) REPORTS BELOW</COM></TD>
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
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE1">REPORT 1:</LABEL> &nbsp;&nbsp;
                    <LABEL for="CONFIRMFLAG">Confirm Complete Software Assignment SRs</LABEL>
                    <LABEL for="FISCALYEARID1">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="CONFIRMFLAG" id="CONFIRMFLAG" size="1" tabindex="4">
					<OPTION value="0">Select an Option</OPTION>
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
                    &nbsp;&nbsp;&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID1" id="FISCALYEARID1" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="6">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE2">REPORT 2: &nbsp;&nbsp;All Software Assignment SRs</LABEL>
                    <LABEL for="FISCALYEARID2">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
               	<CFSELECT name="FISCALYEARID2" id="FISCALYEARID2" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="7"></CFSELECT>
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="8">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE3">REPORT 3:</LABEL> &nbsp;&nbsp;
                    <LABEL for="SRID3">Specific Software Assignment SR for the Current Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SRID3" id="SRID3" size="1" query="LookupServiceRequests" value="SRID" selected ="0" display="LOOKUPKEY" required="No" tabindex="9"></CFSELECT>
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="10">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE4">REPORT 4:</LABEL> &nbsp;&nbsp;
                    <LABEL for="SRID4">Specific Software Assignment SR </LABEL>
                    <LABEL for="FISCALYEARID4">for Previous Fiscal Years</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SRID4" id="SRID4" size="1" query="LookupPrevYrServiceRequests" value="SRID" selected ="0" display="LOOKUPKEY" required="No" tabindex="11"></CFSELECT>&nbsp;&nbsp;&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID4" id="FISCALYEARID4" query="LookupPreviousFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID# - 1" tabindex="12"></CFSELECT>
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
               	<LABEL for="REPORTCHOICE5">REPORT 5:</LABEL> &nbsp;&nbsp;
               	<LABEL for="SRRANGE">Range of Software Assignment SRs</LABEL>
                    <LABEL for="FISCALYEARID5">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="SRRANGE" id="SRRANGE" value="" required="No" size="40" maxlength="50" tabindex="14">
				&nbsp;&nbsp;&nbsp;&nbsp;               	
                    <CFSELECT name="FISCALYEARID5" id="FISCALYEARID5" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="15"></CFSELECT><BR />
				<COM>Enter two SR Numbers separated by a semicolon for range;No spaces.</COM>
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="16">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE6">REPORT 6:</LABEL> &nbsp;&nbsp;
                    <LABEL for="HWSWID">Specific SW Type</LABEL>
                    <LABEL for="FISCALYEARID6">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="HWSWID" id="HWSWID" size="1" query="ListHWSW" value="HWSW_ID" selected="0" display="HWSW_NAME" required="no" tabindex="17"></CFSELECT>
				&nbsp;&nbsp;&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID6" id="FISCALYEARID6" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="18"></CFSELECT>
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE7" value="7" align="LEFT" required="No" tabindex="19">
			</TD>
			<TH align="left" valign="TOP" nowrap>
               	<LABEL for="REPORTCHOICE7">REPORT 7:</LABEL> &nbsp;&nbsp;
                    <LABEL for="HWSWSERIES">Series Of SW Types</LABEL>
                    <LABEL for="FISCALYEARID7">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="HWSWSERIES" id="HWSWSERIES" value="" required="No" size="40" maxlength="50" tabindex="20">
				&nbsp;&nbsp;&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID7" id="FISCALYEARID7" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="21"></CFSELECT><BR />
				<COM>Enter a series of HWSW Types separated by commas,NO spaces.</COM>
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>

		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="25" />
               </TD>
		</TR>
          <TR>
			<TD align="CENTER" valign="TOP" colspan="3"><COM>SELECT ONE OF THE SEVEN (7) REPORTS ABOVE</COM></TD>
		</TR>
</CFFORM>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="26" /><BR>
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
*****************************************************************************
* The following code is the Software Assignments Report Generation Process. *
*****************************************************************************
 --->

	<CFSET REPORTTITLE = ''>
     
     	<CFIF #FORM.REPORTCHOICE# EQ 1>

          <CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID1#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>
		
		<CFSET REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;Confirm Complete Software Assignment SRs - #FORM.CONFIRMFLAG# for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="ListSRSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SRID, CONFIRMFLAG
			FROM		SRSOFTWASSIGNS
			WHERE	SRSOFTWASSIGNID > 0 AND
					CONFIRMFLAG = <CFQUERYPARAM value="#FORM.CONFIRMFLAG#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	SRID
		</CFQUERY>

		<CFIF ListSRSoftwareAssignments.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("There are NO Confirm Complete SRs for Software Assignments");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID IN (#ValueList(ListSRSoftwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID1#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER <!---	#REPORTORDER# --->
		</CFQUERY>

	</CFIF>
     
	<CFIF #FORM.REPORTCHOICE# EQ 2>
     
     	<CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID2#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 2:&nbsp;&nbsp;&nbsp;&nbsp;All Software Assignment SRs for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="ListSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SRID
			FROM		SRSOFTWASSIGNS
			WHERE	SRSOFTWASSIGNID > 0
			ORDER BY	SRID
		</CFQUERY>
          
          <CFIF ListSoftwareAssignments.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("There are NO Software Assignments for the selected Fiscal Year.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID IN (#ValueList(ListSoftwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID2#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER <!---	#REPORTORDER# --->
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>
     
     	<CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	(CURRENTFISCALYEAR = 'YES')
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 3:&nbsp;&nbsp;&nbsp;&nbsp;Specific Software Assignment SR for the Current Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID = <CFQUERYPARAM value="#FORM.SRID3#" cfsqltype="CF_SQL_NUMERIC">AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#LookupCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER <!--- #REPORTORDER# --->
		</CFQUERY>
	</CFIF>
     
     <CFIF #FORM.REPORTCHOICE# EQ 4>

		<CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID4#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 4:&nbsp;&nbsp;&nbsp;&nbsp;Specific Software Assignment SR for Previous Fiscal Years: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID = <CFQUERYPARAM value="#FORM.SRID4#" cfsqltype="CF_SQL_NUMERIC">AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID4#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER <!--- #REPORTORDER# --->
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 5>

		<CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID5#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 5: &nbsp;&nbsp;Range of Software Assignment SRs for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
          <CFSET FORM.SRRANGE = #REPLACE(FORM.SRRANGE, ";", ",")#>
		<CFSET BEGINSRRANGE = LISTGETAT(FORM.SRRANGE,1)>
		<CFSET ENDSRRANGE = LISTGETAT(FORM.SRRANGE,2)>
		SR RANGE FIELDS = BEGIN SR RANGE: #BEGINSRRANGE# AND END SR RANGE: #ENDSRRANGE#<BR /><BR />

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SR.SRID, SRSWA.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR, SRSOFTWASSIGNS SRSWA
			WHERE	(SR.SERVICEREQUESTNUMBER >= '#BEGINSRRANGE#' AND 
               		SR.SERVICEREQUESTNUMBER <= '#ENDSRRANGE#') AND
               		(SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID5#" cfsqltype="CF_SQL_NUMERIC"> AND
					SR.SRID = SRSWA.SRID)
			ORDER BY	SR.SERVICEREQUESTNUMBER <!--- #REPORTORDER# --->
		</CFQUERY>

		<CFIF LookupServiceRequests.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The entered SRs are NOT Associated with a Installed/Returned Item.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 6>

		<CFQUERY name="LookupHWSW" datasource="#application.type#SERVICEREQUESTS">
			SELECT	HWSW_ID, HWSW_NAME
			FROM		HWSW
			WHERE	HWSW_ID = <CFQUERYPARAM value="#FORM.HWSWID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	HWSW_NAME
		</CFQUERY>
          
          <CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID6#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>
		
		<CFSET REPORTTITLE = 'REPORT 6: &nbsp;&nbsp;Specific HW Type - #LookupHWSW.HWSW_NAME# for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#' >

		<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS">
			SELECT	UNIQUE SRID, HWSWID
			FROM		SRSOFTWASSIGNS
			WHERE	HWSWID = <CFQUERYPARAM value="#FORM.HWSWID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SRID
		</CFQUERY>
          
          <CFIF LookupSoftwareAssignments.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("There are NO SRs for Software Action:  #LookupHWSW.HWSW_NAME#");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID IN (#ValueList(LookupSoftwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID6#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER <!--- #REPORTORDER# --->
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 7>

          <CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID7#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>
		
		<CFSET REPORTTITLE = 'REPORT 7: &nbsp;&nbsp;Series Of HW Types for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFSET FORM.HWSWSERIES = UCASE(#FORM.HWSWSERIES#)>
		<CFSET FORM.HWSWSERIES = ListQualify(FORM.HWSWSERIES,"'",",","CHAR")>
		HWSW SERIES FIELD = #FORM.HWSWSERIES#<BR /><BR />

		<CFQUERY name="LookupHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="6">
			SELECT	HWSW_ID, HWSW_NAME
			FROM		HWSW
			WHERE	HWSW_ID > 0 AND
					HWSW_NAME IN (#PreserveSingleQuotes(FORM.HWSWSERIES)#)
			ORDER BY	HWSW_NAME
		</CFQUERY>
          
          <CFIF LookupHWSW.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The entered HWSW Type was not SW ADD, SW DEL, SW IMAGE ONLY, OR SW SWAP. Spaces must be included between the words.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SRID, HWSWID
			FROM		SRSOFTWASSIGNS
			WHERE	HWSWID IN (#ValueList(LookupHWSW.HWSW_ID)#) 
			ORDER BY	SRID
		</CFQUERY>

		<CFIF LookupSoftwareAssignments.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("No records of the type entered exists.  Spaces must be included between the words.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID IN (#ValueList(LookupSoftwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID7#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER <!--- #REPORTORDER# --->
		</CFQUERY>

	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>SR - Software Assignments Report</H1>
				<H2>#REPORTTITLE#</H2>
			</TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
          <TR>
          	<TD align="center" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>

     <CFIF #LookupServiceRequests.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
               <!-- 
                    alert("SRs For Selected Fiscal Year Not Found");
               --> 
          </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" />
          <CFEXIT>
     </CFIF>
     
     <CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SRSWA.SRSOFTWASSIGNID, SRSWA.SRID, SR.SERVICEREQUESTNUMBER, SRSWA.HWSWID, HWSW.HWSW_NAME, SRSWA.MODIFIEDBYID, MODBYCUST.FULLNAME AS MODBYNAME,
          		TO_CHAR(SRSWA.HWSWDATE, 'MM/DD/YYYY') AS HWSWDATE, TO_CHAR(SRSWA.HWSWTIME, 'HH:MI:SS AM') AS HWSWTIME, SR.PROBLEM_DESCRIPTION, SRSWA.ASSIGN_SWID,
                    SWAT.SUBCATEGORYID, SWAT.SUBCATEGORYNAME AS ASSIGNSWTITLE, SRSWA.ASSIGN_OTHERPKGTITLE, SRSWA.ASSIGN_VERSION, SRSWA.ASSIGN_INVENTID,
                    ASSIGNHI.BARCODENUMBER AS ASSIGNBARCODE, SRSWA.ASSIGN_CUSTID, ASSIGNCUST.FULLNAME AS ASSIGNNAME, SRSWA.CONFIRMFLAG, SRSWA.IMAGEID, SWI.IMAGENAME,
                    SRSWA.COMFIRMEDBYID, CONFIRMCUST.FULLNAME AS CONFIRMNAME, SRSWA.UNASSIGN_SWID, SWUNAT.SUBCATEGORYID, SWUNAT.SUBCATEGORYNAME AS UNASSIGNSWTITLE,
                    SRSWA.UNASSIGN_OTHERPKGTITLE, SRSWA.UNASSIGN_VERSION, SRSWA.UNASSIGN_INVENTID, UNASSIGNHI.BARCODENUMBER AS UNASSIGNBARCODE, SRSWA.UNASSIGN_CUSTID, 
                    UNASSIGNCUST.FULLNAME AS UNASSIGNNAME, TO_CHAR(SRSWA.CONFIRMEDDATE, 'MM/DD/YYYY') AS CONFIRMDATE, SRSWA.TECHCOMMENTS, SRSWA.CONFIRMCOMMENTS
          FROM		SRSOFTWASSIGNS SRSWA, SERVICEREQUESTS SR, HWSW, LIBSHAREDDATAMGR.CUSTOMERS MODBYCUST, PROBLEMSUBCATEGORIES SWAT, HARDWMGR.HARDWAREINVENTORY ASSIGNHI, 
          		LIBSHAREDDATAMGR.CUSTOMERS ASSIGNCUST, SOFTWMGR.IMAGES SWI, LIBSHAREDDATAMGR.CUSTOMERS CONFIRMCUST, PROBLEMSUBCATEGORIES SWUNAT, HARDWMGR.HARDWAREINVENTORY UNASSIGNHI, 	
                    LIBSHAREDDATAMGR.CUSTOMERS UNASSIGNCUST					
          WHERE	SRSWA.SRSOFTWASSIGNID > 0 AND
          		SRSWA.SRID IN  (#ValueList(LookupServiceRequests.SRID)#) AND
                    SRSWA.SRID = SR.SRID AND
                    SRSWA.HWSWID = HWSW.HWSW_ID AND
               <CFIF #FORM.REPORTCHOICE# EQ 6>
                    SRSWA.HWSWID = #val(FORM.HWSWID)# AND
               </CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 7>
                    SRSWA.HWSWID IN (#ValueList(LookupHWSW.HWSW_ID)#) AND
               </CFIF>
               	SRSWA.MODIFIEDBYID = MODBYCUST.CUSTOMERID AND
               	SRSWA.ASSIGN_SWID = SWAT.SUBCATEGORYID AND
				SRSWA.ASSIGN_INVENTID = ASSIGNHI.HARDWAREID AND
                    SRSWA.ASSIGN_CUSTID = ASSIGNCUST.CUSTOMERID AND
               <CFIF #FORM.REPORTCHOICE# EQ 1>
                    SRSWA.CONFIRMFLAG = '#FORM.CONFIRMFLAG#' AND
               </CFIF>
                    SRSWA.IMAGEID = SWI.IMAGEID  AND
                    SRSWA.COMFIRMEDBYID = CONFIRMCUST.CUSTOMERID AND
                    SRSWA.UNASSIGN_SWID = SWUNAT.SUBCATEGORYID AND
                    SRSWA.UNASSIGN_INVENTID = UNASSIGNHI.HARDWAREID AND
                    SRSWA.UNASSIGN_CUSTID = UNASSIGNCUST.CUSTOMERID
		ORDER BY	SR.SERVICEREQUESTNUMBER, ASSIGNBARCODE
     </CFQUERY>
     
     	<TR>
			<TH align="CENTER" colspan="5">
				<H2>
                    	#LookupSoftwareAssignments.RecordCount# Software Assignment records were selected.
				</H2>
               </TH>
		</TR>
          <TR>
			<TD align="CENTER" colspan="5"><HR width="100%" size="5" noshade /></TD>
		</TR>
          
<CFLOOP query="LookupSoftwareAssignments">
     
     	<TR>
			<TH align="left">SR Number</TH>
			<TH align="left" valign="BOTTOM">HWSW</TH>
               <TH align="left">Modified By</TH>
               <TH align="left">HWSW Date</TH>
               <TH align="left">HWSW Time</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">#LookupSoftwareAssignments.SERVICEREQUESTNUMBER#</TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupSoftwareAssignments.HWSW_NAME#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupSoftwareAssignments.MODBYNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupSoftwareAssignments.HWSWDATE#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupSoftwareAssignments.HWSWTIME#</DIV></TD>
		</TR>
          <TR>
          	<TH align="left" colspan="5">SR Problem Description</TH>
          </TR>
          <TR>               
			<TD align="left" colspan="5">
               	<DIV>#LookupSoftwareAssignments.PROBLEM_DESCRIPTION#</DIV>
               </TD>
          </TR>
          <TR>
          	<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
          	<TH align="left">SW Title Assigned</TH>
			<TH align="left">Version Assigned</TH>
			<TH align="left">Inventory Assigned</TH>
			<TH align="left">Customer Assigned</TH>
               <TH align="left">Confirm</TH>
          </TR>
		<TR>
			<TD align="left" valign="TOP" nowrap>
               	<DIV>#LookupSoftwareAssignments.ASSIGNSWTITLE#</DIV>
			 <CFIF #LookupSoftwareAssignments.ASSIGN_SWID# EQ 83>
                    <DIV> - #LookupSoftwareAssignments.ASSIGN_OTHERPKGTITLE#</DIV>
                </CFIF>
           	</TD>
			<TD align="left" valign="TOP"><DIV>#LookupSoftwareAssignments.ASSIGN_VERSION#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupSoftwareAssignments.ASSIGNBARCODE#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupSoftwareAssignments.ASSIGNNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupSoftwareAssignments.CONFIRMFLAG#</DIV></TD>
		</TR>
          <TR>
			<TH align="left"><H4>IMAGE</H4></TH>
               <TH align="left" colspan="3">&nbsp;&nbsp;</TH>
			<TH align="left">Confirmed By</TH>
		</TR>
 		<TR>
			<TD align="left" valign="TOP" nowrap><DIV><H4>#LookupSoftwareAssignments.IMAGENAME#</H4></DIV></TD>
               <TD align="left" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP"><DIV>#LookupSoftwareAssignments.CONFIRMNAME#</DIV></TD>
		</TR>
         <TR>
			<TH align="left">SW Title UnAssigned</TH>
			<TH align="left" valign="BOTTOM">Version UnAssigned</TH>
               <TH align="left">Inventory UnAssigned</TH>
               <TH align="left">Customer UnAssigned</TH>
               <TH align="left">Confirmed Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
               	<DIV>#LookupSoftwareAssignments.UNASSIGNSWTITLE#</DIV>
          	<CFIF #LookupSoftwareAssignments.UNASSIGN_SWID# EQ 83>
           		<DIV> - #LookupSoftwareAssignments.UNASSIGN_OTHERPKGTITLE#</DIV>
          	</CFIF>
               </TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupSoftwareAssignments.UNASSIGN_VERSION#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupSoftwareAssignments.UNASSIGNBARCODE#</DIV></TD>
          	<TD align="left" valign="TOP"><DIV>#LookupSoftwareAssignments.UNASSIGNNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupSoftwareAssignments.CONFIRMDATE#</DIV></TD>
		</TR>
          <TR>
          	<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
			<TH align="left" valign="BOTTOM" colspan="3">Additional Comments</TH>
          	<TH align="left" colspan="2">Confirm Commments</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3"><DIV>#LookupSoftwareAssignments.TECHCOMMENTS#</DIV></TD>
			<TD align="left" valign="TOP" colspan="2"><DIV>#LookupSoftwareAssignments.CONFIRMCOMMENTS#</DIV></TD>
		</TR>
		<TR>
			<TD align="left" colspan="5"><HR /></TD>
		</TR>
</CFLOOP>
		<TR>
			<TD align="left" colspan="5"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="5">
				<H2>
                    	#LookupSoftwareAssignments.RecordCount# Software Assignment records were selected.
				</H2>
               </TH>
		</TR>
          <TR>
          	<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="11">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>