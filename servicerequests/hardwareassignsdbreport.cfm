<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hardwareassignsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/05/2013 --->
<!--- Date in Production: 03/05/2013 --->
<!--- Module: Service Requests - Hardware Assignments Report --->
<!-- Last modified by John R. Pastori on 05/20/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm">
<CFSET CONTENT_UPDATED = "May 20, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Service Requests - Hardware Assignments Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Service Requests - Hardware Assignments Report";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}
	
	
	function validateLookupFields() {
		if (document.LOOKUP.REPORTCHOICE[0].checked > "0" && document.LOOKUP.CONFIRMFLAG.selectedIndex == "0") {
			alertuser ("You MUST select a Confirm value from the Drop Down!");
			document.LOOKUP.CONFIRMFLAG.focus();
			return false;
		}

		if (document.LOOKUP.REPORTCHOICE[1].checked > "0" && document.LOOKUP.SALVAGEFLAG.selectedIndex == "0") {
			alertuser ("You MUST select a Salvage value from the Drop Down!");
			document.LOOKUP.SALVAGEFLAG.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[3].checked > "0" && document.LOOKUP.SRID4.selectedIndex == "0") {
			alertuser ("You MUST select a Customer/SR value from the Drop Down!");
			document.LOOKUP.SRID4.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[4].checked > "0" && document.LOOKUP.SRID5.selectedIndex == "0") {
			alertuser ("You MUST select a Customer/SR value from the Drop Down!");
			document.LOOKUP.SRID5.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[5].checked > "0" && document.LOOKUP.SRRANGE.value == "") {
			alertuser ("You MUST enter a range of SR Numbers in the text box!");
			document.LOOKUP.SRRANGE.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[6].checked > "0" && document.LOOKUP.HWSWID.selectedIndex == "0") {
			alertuser ("You MUST select a HWSW value from the Drop Down!");
			document.LOOKUP.HWSWID.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTCHOICE[7].checked > "0" && document.LOOKUP.HWSWSERIES.value == "") {
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
* The following code is the Lookup Process for IDT Service Requests - Hardware Assignments Report. *
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

	<CFQUERY name="ListHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	UNIQUE SRID
		FROM		SRHARDWASSIGNS
		ORDER BY	SRID
	</CFQUERY>

	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, CUST.FULLNAME,
				CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(SRID = 0 OR 
				SR.SRID IN (#ValueList(ListHardwareAssignments.SRID)#)) AND
				SR.REQUESTERID = CUST.CUSTOMERID
		ORDER BY	LOOKUPKEY
	</CFQUERY>
     
     <CFQUERY name="LookupPrevYrServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, CUST.FULLNAME,
				CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(SRID = 0 OR 
				SR.SRID IN (#ValueList(ListHardwareAssignments.SRID)#)) AND
                    SR.FISCALYEARID < <CFQUERYPARAM value="#LookupCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SR.REQUESTERID = CUST.CUSTOMERID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFQUERY name="ListHWSW" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
		SELECT	HWSW_ID, HWSW_NAME
		FROM		HWSW
		WHERE	HWSW_ID = 0 OR
				SUBSTR(HWSW_NAME,1,2) = 'HW'
		ORDER BY	HWSW_NAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>SR Lookup - Hardware Assignments Report</H1></TD>
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="CENTER" valign="TOP" colspan="3"><COM>SELECT ONE OF THE EIGHT (8) REPORTS BELOW</COM></TD>
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
                    <LABEL for="CONFIRMFLAG">Confirm Complete Hardware Assignment SRs</LABEL>
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
               	<LABEL for="REPORTCHOICE2">REPORT 2:</LABEL> &nbsp;&nbsp;
                    <LABEL for="SALVAGEFLAG">Salvaged Hardware Assignment SRs</LABEL>
                    <LABEL for="FISCALYEARID2">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SALVAGEFLAG" id="SALVAGEFLAG" size="1" tabindex="7">
					<OPTION value="0">Select an Option</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION selected value="YES">YES</OPTION>
				</CFSELECT>
                    &nbsp;&nbsp;&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID2" id="FISCALYEARID2" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="9">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE3">REPORT 3: &nbsp;&nbsp;All Hardware Assignment SRs</LABEL>
                    <LABEL for="FISCALYEARID3">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
               	<CFSELECT name="FISCALYEARID3" id="FISCALYEARID3" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="10"></CFSELECT>
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
               	<LABEL for="REPORTCHOICE4">REPORT 4:</LABEL> &nbsp;&nbsp;
                    <LABEL for="SRID4">Specific Hardware Assignment SR for the Current Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SRID4" id="SRID4" size="1" query="LookupServiceRequests" value="SRID" selected ="0" display="LOOKUPKEY" required="No" tabindex="12"></CFSELECT>
			</TD>
		</TR>
          <TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="13">
			</TD>
			<TH align="left" valign="TOP">
               	<LABEL for="REPORTCHOICE5">REPORT 5:</LABEL> &nbsp;&nbsp;
                    <LABEL for="SRID5">Specific Hardware Assignment SR </LABEL>
                    <LABEL for="FISCALYEARID5">for Previous Fiscal Years</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SRID5" id="SRID5" size="1" query="LookupPrevYrServiceRequests" value="SRID" selected ="0" display="LOOKUPKEY" required="No" tabindex="14"></CFSELECT>&nbsp;&nbsp;&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID5" id="FISCALYEARID5" query="LookupPreviousFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID# - 1" tabindex="15"></CFSELECT>
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
               	<LABEL for="SRRANGE">Range of Hardware Assignment SRs</LABEL>
                    <LABEL for="FISCALYEARID6">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="SRRANGE" id="SRRANGE" value="" required="No" size="40" maxlength="50" tabindex="17">
				&nbsp;&nbsp;&nbsp;&nbsp;               	
                    <CFSELECT name="FISCALYEARID6" id="FISCALYEARID6" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="18"></CFSELECT><BR />
				<COM>Enter two SR Numbers separated by a semicolon for range;No spaces.</COM>
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
               	<LABEL for="REPORTCHOICE7">REPORT 7:</LABEL> &nbsp;&nbsp;
                    <LABEL for="HWSWID">Specific HW Type</LABEL>
                    <LABEL for="FISCALYEARID7">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="HWSWID" id="HWSWID" size="1" query="ListHWSW" value="HWSW_ID" selected="0" display="HWSW_NAME" required="no" tabindex="20"></CFSELECT>
				&nbsp;&nbsp;&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID7" id="FISCALYEARID7" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="21"></CFSELECT>
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE8" value="8" align="LEFT" required="No" tabindex="22">
			</TD>
			<TH align="left" valign="TOP" nowrap>
               	<LABEL for="REPORTCHOICE8">REPORT 8:</LABEL> &nbsp;&nbsp;
                    <LABEL for="HWSWSERIES">Series Of HW Types</LABEL>
                    <LABEL for="FISCALYEARID8">for a Specific Fiscal Year</LABEL>
               </TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="TEXT" name="HWSWSERIES" id="HWSWSERIES" value="" required="No" size="40" maxlength="50" tabindex="23">
				&nbsp;&nbsp;&nbsp;&nbsp;
               	<CFSELECT name="FISCALYEARID8" id="FISCALYEARID8" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="#LookupCurrentFiscalYear.FISCALYEARID#" tabindex="24"></CFSELECT><BR />
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
			<TD align="CENTER" valign="TOP" colspan="3"><COM>SELECT ONE OF THE EIGHT (8) REPORTS ABOVE</COM></TD>
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
* The following code is the Hardware Assignments Report Generation Process. *
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
		
		<CFSET REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;Confirm Complete Hardware Assignment SRs - #FORM.CONFIRMFLAG# for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="ListSRHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SRID, CONFIRMFLAG
			FROM		SRHARDWASSIGNS
			WHERE	SRHARDWASSIGNID > 0 AND
					CONFIRMFLAG = <CFQUERYPARAM value="#FORM.CONFIRMFLAG#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	SRID
		</CFQUERY>

		<CFIF ListSRHardwareAssignments.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("There are NO Confirm Complete SRs for Hardware Assignments");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID IN (#ValueList(ListSRHardwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID1#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER DESC <!---	#REPORTORDER# --->
		</CFQUERY>

	</CFIF>
     
     <CFIF #FORM.REPORTCHOICE# EQ 2>
     
          <CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID2#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>     

		<CFSET REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;Salvaged Hardware Assignment SRs - #FORM.SALVAGEFLAG# for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="ListHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SRID, SALVAGEFLAG
			FROM		SRHARDWASSIGNS
			WHERE	SRHARDWASSIGNID > 0 AND
					SALVAGEFLAG = '#FORM.SALVAGEFLAG#'
			ORDER BY	SRID
		</CFQUERY>

		<CFIF ListHardwareAssignments.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("There are NO Salvaged Hardware Assignment SRs for Hardware Assignments");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID IN (#ValueList(ListHardwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID2#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER DESC <!---	#REPORTORDER# --->
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>
     
     	<CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID3#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 3:&nbsp;&nbsp;&nbsp;&nbsp;All Hardware Assignment SRs for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="ListHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SRID
			FROM		SRHARDWASSIGNS
			WHERE	SRHARDWASSIGNID > 0
			ORDER BY	SRID
		</CFQUERY>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID IN (#ValueList(ListHardwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID3#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER DESC <!---	#REPORTORDER# --->
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>
     
     	<CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	(CURRENTFISCALYEAR = 'YES')
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 4:&nbsp;&nbsp;&nbsp;&nbsp;Specific Hardware Assignment SR for the Current Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID = <CFQUERYPARAM value="#FORM.SRID4#" cfsqltype="CF_SQL_NUMERIC">AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#LookupCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER DESC <!--- #REPORTORDER# --->
		</CFQUERY>
	</CFIF>
     
     <CFIF #FORM.REPORTCHOICE# EQ 5>

		<CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID5#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 5:&nbsp;&nbsp;&nbsp;&nbsp;Specific Hardware Assignment SR for Previous Fiscal Years: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID = <CFQUERYPARAM value="#FORM.SRID5#" cfsqltype="CF_SQL_NUMERIC">AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID5#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER <!--- #REPORTORDER# --->
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 6>

		<CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID6#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 6: &nbsp;&nbsp;Range of Hardware Assignment SRs for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
          <CFSET FORM.SRRANGE = #REPLACE(FORM.SRRANGE, ";", ",")#>
		<CFSET BEGINSRRANGE = LISTGETAT(FORM.SRRANGE,1)>
		<CFSET ENDSRRANGE = LISTGETAT(FORM.SRRANGE,2)>
		SR RANGE FIELDS = BEGIN SR RANGE: #BEGINSRRANGE# AND END SR RANGE: #ENDSRRANGE#<BR /><BR />

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SR.SRID, SRHA.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR, SRHARDWASSIGNS SRHA
			WHERE	(SR.SERVICEREQUESTNUMBER >= '#BEGINSRRANGE#' AND 
               		SR.SERVICEREQUESTNUMBER <= '#ENDSRRANGE#') AND
               		(SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID6#" cfsqltype="CF_SQL_NUMERIC"> AND
					SR.SRID = SRHA.SRID)
			ORDER BY	SR.SERVICEREQUESTNUMBER DESC <!--- #REPORTORDER# --->
		</CFQUERY>
		<CFIF LookupServiceRequests.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The entered SRs are NOT Associated with a Installed/Returned Item.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 7>

		<CFQUERY name="LookupHWSW" datasource="#application.type#SERVICEREQUESTS">
			SELECT	HWSW_ID, HWSW_NAME
			FROM		HWSW
			WHERE	HWSW_ID = <CFQUERYPARAM value="#FORM.HWSWID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	HWSW_NAME
		</CFQUERY>
          
          <CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID7#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>
		
		<CFSET REPORTTITLE = 'REPORT 7: &nbsp;&nbsp;Specific HW Type - #LookupHWSW.HWSW_NAME# for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#' >

		<CFQUERY name="LookupHardwareAssignments" datasource="#application.type#SERVICEREQUESTS">
			SELECT	UNIQUE SRID, HWSWID
			FROM		SRHARDWASSIGNS
			WHERE	HWSWID = <CFQUERYPARAM value="#FORM.HWSWID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SRID
		</CFQUERY>
          
          <CFIF LookupHardwareAssignments.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("There are NO SRs for Hardware Action:  #LookupHWSW.HWSW_NAME#");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME
			FROM		SERVICEREQUESTS SR
			WHERE	SR.SRID IN (#ValueList(LookupHardwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID7#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER DESC <!--- #REPORTORDER# --->
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 8>

          <CFQUERY name="LookupFiscalYear4Digit" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID8#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	FISCALYEARID DESC
          </CFQUERY>
		
		<CFSET REPORTTITLE = 'REPORT 8: &nbsp;&nbsp;Series Of HW Types for a Specific Fiscal Year: &nbsp;&nbsp;#LookupFiscalYear4Digit.FISCALYEAR_4DIGIT#'>
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
					alert ("The entered HWSW Type was not HW ADD, HW DEL, HW AND IMAGE, HW MOVE, HW REPAIR, HW SWAP or HW UPGRADED. Spaces must be included between the words.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsdbreport.cfm" />
			<CFEXIT>
		</CFIF>

		<CFQUERY name="LookupHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	UNIQUE SRID, HWSWID
			FROM		SRHARDWASSIGNS
			WHERE	HWSWID IN (#ValueList(LookupHWSW.HWSW_ID)#) 
			ORDER BY	SRID
		</CFQUERY>
          
          <CFIF LookupHardwareAssignments.RecordCount EQ 0>
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
			WHERE	SR.SRID IN (#ValueList(LookupHardwareAssignments.SRID)#) AND
               		SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID8#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SR.SERVICEREQUESTNUMBER DESC <!--- #REPORTORDER# --->
		</CFQUERY>

	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>SR - Hardware Assignments Report</H1>
				<H2>#REPORTTITLE#</H2>
			</TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm" method="POST">
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
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm" />
          <CFEXIT>
     </CFIF>
     
     <CFQUERY name="LookupHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SR.SERVICEREQUESTNUMBER, SRHA.SRID, SRHA.HWSWID, HWSW.HWSW_NAME, SRHA.MODIFIEDBYID, MODBYCUST.FULLNAME AS MODBYNAME,  
          		TO_CHAR(SRHA.HWSWDATE, 'MM/DD/YYYY') AS HWSWDATE, TO_CHAR(SRHA.HWSWTIME, 'HH:MI:SS AM') AS HWSWTIME, SRHA.IMAGEID, 
                    SWI.IMAGENAME, SRHA.INSTALLINVENTID, INSTALLHI.BARCODENUMBER AS INSTALLBARCODE, INSTALLHIET.EQUIPMENTTYPE AS INSTALLEQUIPTYPE, 
                    SRHA.INSTALLLOCID, INSTALLLOC.ROOMNUMBER AS INSTALLROOM, SRHA.INSTALLCUSTID, INSTALLCUST.FULLNAME AS INSTALLNAME, SRHA.RETURNINVENTID,
                    RETURNHI.BARCODENUMBER AS RETURNBARCODE, RETURNHIET.EQUIPMENTTYPE AS RETURNEQUIPTYPE, SRHA.RETURNLOCID, RETURNLOC.ROOMNUMBER AS RETURNROOM,
                    SRHA.RETURNCUSTID, RETURNCUST.FULLNAME AS RETURNNAME, SRHA.SALVAGEFLAG, SRHA.MACHINENAME, SRHA.MACADDRESS, SRHA.IPADDRESS, SRHA.TECHCOMMENTS,
                    SRHA.MODIFIEDDATE, SRHA.CONFIRMFLAG, SRHA.CONFIRMCOMMENTS, SRHA.COMFIRMEDBYID, CONFIRMCUST.FULLNAME AS CONFIRMNAME, 
                    TO_CHAR(SRHA.CONFIRMEDDATE, 'MM/DD/YYYY') AS CONFIRMDATE
          FROM		SRHARDWASSIGNS SRHA, SERVICEREQUESTS SR, HWSW, SOFTWMGR.IMAGES SWI, LIBSHAREDDATAMGR.CUSTOMERS MODBYCUST, HARDWMGR.HARDWAREINVENTORY INSTALLHI, 
          		HARDWMGR.EQUIPMENTTYPE INSTALLHIET, FACILITIESMGR.LOCATIONS INSTALLLOC, LIBSHAREDDATAMGR.CUSTOMERS INSTALLCUST, HARDWMGR.HARDWAREINVENTORY RETURNHI, 
                    HARDWMGR.EQUIPMENTTYPE RETURNHIET, FACILITIESMGR.LOCATIONS RETURNLOC, 
                    LIBSHAREDDATAMGR.CUSTOMERS RETURNCUST, LIBSHAREDDATAMGR.CUSTOMERS CONFIRMCUST					
          WHERE	SRHA.SRHARDWASSIGNID > 0 AND
          		SRHA.SRID IN  (#ValueList(LookupServiceRequests.SRID)#) AND
                    SRHA.SRID = SR.SRID AND
                    SRHA.HWSWID = HWSW.HWSW_ID AND
               <CFIF #FORM.REPORTCHOICE# EQ 7>
                    SRHA.HWSWID = #val(FORM.HWSWID)# AND
               </CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 8>
                    SRHA.HWSWID IN (#ValueList(LookupHWSW.HWSW_ID)#) AND
               </CFIF>
                    SRHA.IMAGEID = SWI.IMAGEID  AND
                    SRHA.MODIFIEDBYID = MODBYCUST.CUSTOMERID AND
                    SRHA.INSTALLINVENTID = INSTALLHI.HARDWAREID AND
                    INSTALLHI.EQUIPMENTTYPEID = INSTALLHIET.EQUIPTYPEID AND
                    SRHA.INSTALLLOCID = INSTALLLOC.LOCATIONID AND
                    SRHA.INSTALLCUSTID = INSTALLCUST.CUSTOMERID AND
                    SRHA.RETURNINVENTID = RETURNHI.HARDWAREID AND
                    RETURNHI.EQUIPMENTTYPEID = RETURNHIET.EQUIPTYPEID AND
                    SRHA.RETURNLOCID = RETURNLOC.LOCATIONID AND
                    SRHA.RETURNCUSTID = RETURNCUST.CUSTOMERID AND
               <CFIF #FORM.REPORTCHOICE# EQ 2>
                    SRHA.SALVAGEFLAG = '#FORM.SALVAGEFLAG#' AND
               </CFIF>
               <CFIF #FORM.REPORTCHOICE# EQ 1>
                    SRHA.CONFIRMFLAG = '#FORM.CONFIRMFLAG#' AND
               </CFIF>
               	SRHA.COMFIRMEDBYID = CONFIRMCUST.CUSTOMERID
          ORDER BY	SR.SERVICEREQUESTNUMBER DESC, INSTALLBARCODE
     </CFQUERY>
     <CFSET SRCHANGE = "">
     
     	<TR>
			<TH align="CENTER" colspan="5">
				<H2>
                    	#LookupHardwareAssignments.RecordCount# Hardware Assignment records were selected.
				</H2>
               </TH>
		</TR>
          <TR>
			<TD align="CENTER" colspan="5"><HR width="100%" size="5" noshade /></TD>
		</TR>
                
<CFLOOP query="LookupHardwareAssignments">
		<CFIF SRCHANGE NEQ #LookupHardwareAssignments.SERVICEREQUESTNUMBER#>
          	<CFSET SRCHANGE = "#LookupHardwareAssignments.SERVICEREQUESTNUMBER#">
          <TR>
               <TD align="left" colspan="5"><HR /></TD>
          </TR>
          </CFIF>
     	<TR>
			<TH align="left">SR Number</TH>
			<TH align="left" valign="BOTTOM">HWSW</TH>
               <TH align="left">Modified By</TH>
               <TH align="left">HWSW Date</TH>
               <TH align="left">HWSW Time</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">#LookupHardwareAssignments.SERVICEREQUESTNUMBER#</TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardwareAssignments.HWSW_NAME#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardwareAssignments.MODBYNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.HWSWDATE#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.HWSWTIME#</DIV></TD>
		</TR>
          <TR>
          	<TH align="left" colspan="2">Barcode Number for SR</TH>
               <TH align="left">Staff Assigned</TH>
               <TH align="left">Image</TH>
               <TH align="left">&nbsp;&nbsp;</TH>

          </TR>
          <TR>
          
          <CFQUERY name="LookupSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
               SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
               FROM		SREQUIPLOOKUP
               WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#LookupHardwareAssignments.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
          </CFQUERY>
          
          <CFIF LookupSREquipLookup.RecordCount GT 0>
         
               <CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE">
                    SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
                              HI.OWNINGORGID, HI.CLUSTERNAME, HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, 
                              HI.MACADDRESS, HI.EQUIPMENTTYPEID, ET.EQUIPTYPEID, ET.EQUIPMENTTYPE, HI.DESCRIPTIONID, HI.MODELNAMEID,
                              HI.MODELNUMBERID, HI.SPEEDNAMEID, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, HI.REQUISITIONNUMBER,
                              HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME,
                              HI.COMMENTS, HI.MODIFIEDBYID, HI.DATECHECKED, ET.EQUIPMENTTYPE ||' - ' || HI.BARCODENUMBER AS DISPLAYKEY
                    FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET 
                    WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#LookupSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
                              HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
                              HI.CUSTOMERID = CUST.CUSTOMERID AND
                              HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID
                    ORDER BY	BARCODENUMBER
               </CFQUERY>
               
			<TD align="left" colspan="2">
               	<DIV>
                    	#LookupHardware.BARCODENUMBER#, #LookupHardware.EQUIPMENTTYPE#, #LookupHardware.DIVISIONNUMBER#,
                    	#LookupHardware.ROOMNUMBER#,  #LookupHardware.FULLNAME#
                    </DIV>
               </TD>
          <CFELSE>
               <TD align="left" colspan="2">
               	<STRONG>No Equipment was selected for this SR.</STRONG>
               </TD>
          </CFIF>
          
          	<TD align="left">
          
          <CFQUERY name="LookupStaff" datasource="#application.type#SERVICEREQUESTS">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, CUST.FULLNAME, SRSA.NEXT_ASSIGNMENT, 
                         SRSA.NEXT_ASSIGNMENT_GROUPID
               FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	SRSA.SRID = <CFQUERYPARAM value="#LookupHardwareAssignments.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
               ORDER BY	CUST.FULLNAME
          </CFQUERY>
            	
          <CFLOOP query="LookupStaff">
               	#LookupStaff.FULLNAME#<BR>
          </CFLOOP>
               </TD>
 			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardwareAssignments.IMAGENAME#</DIV></TD>              
               <TD align="left">&nbsp;&nbsp;</TD>
           
          </TR>
          <TR>
          	<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>
          <TR>

			<TH align="left">Installed Inventory</TH>
			<TH align="left">Installed Location</TH>
			<TH align="left">Installed Customer</TH>
               <TH align="left">Jack</TH>
			<TH align="left">Confirm</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardwareAssignments.INSTALLBARCODE# - #LookupHardwareAssignments.INSTALLEQUIPTYPE#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.INSTALLROOM#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.INSTALLNAME#</DIV></TD>
               <TD align="left" valign="TOP">
			<CFIF #LookupHardwareAssignments.RETURNINVENTID# GT 0>

                    <CFQUERY name="LookupJackNumbers" datasource="#application.type#FACILITIES">
                         SELECT	WJ.WALLJACKID, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.HARDWAREID
                         FROM		WALLJACKS WJ
                         WHERE	WJ.HARDWAREID = <CFQUERYPARAM value="#LookupHardwareAssignments.RETURNINVENTID#" cfsqltype="CF_SQL_NUMERIC">
                         ORDER BY	WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER
                    </CFQUERY>
               
               	<DIV>#LookupJackNumbers.CLOSET#-#LookupJackNumbers.JACKNUMBER#-#LookupJackNumbers.PORTLETTER#</DIV>
               <CFELSE>
               	&nbsp;&nbsp;
               </CFIF>
               </TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.CONFIRMFLAG#</DIV></TD>
		</TR>
          <TR>
			<TH align="left">Machine Name</TH>
			<TH align="left" valign="BOTTOM">MAC Address</TH>
               <TH align="left">IP Address</TH>
               <TH align="left">&nbsp;&nbsp;</TH>
               <TH align="left">Confirmed By</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.MACHINENAME#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardwareAssignments.MACADDRESS#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardwareAssignments.IPADDRESS#</DIV></TD>
          	<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.CONFIRMNAME#</DIV></TD>
		</TR>
          <TR>
          	<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
			<TH align="left">Returning Inventory</TH>
			<TH align="left">Returning Location</TH>
			<TH align="left">Returning Customer</TH>
               <TH align="left">&nbsp;&nbsp;</TH>
          	<TH align="left" valign="BOTTOM">Confirmed Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardwareAssignments.RETURNBARCODE# - #LookupHardwareAssignments.RETURNEQUIPTYPE#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.RETURNROOM#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.RETURNNAME#</DIV></TD>
			<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.CONFIRMDATE#</DIV></TD>
		</TR>
          <TR>
			<TH align="left" valign="BOTTOM" colspan="2">Additional Comments</TH>
			<TH align="left" valign="BOTTOM"><FONT COLOR="RED">Salvage</FONT></TH>
          	<TH align="left" valign="BOTTOM" colspan="2">Confirm Commments</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2"><DIV>#LookupHardwareAssignments.TECHCOMMENTS#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardwareAssignments.SALVAGEFLAG#</DIV></TD>
			<TD align="left" valign="TOP" colspan="2"><DIV>#LookupHardwareAssignments.CONFIRMCOMMENTS#</DIV></TD>
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
                    	#LookupHardwareAssignments.RecordCount# Hardware Assignment records were selected.
				</H2>
               </TH>
		</TR>
          <TR>
          	<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm" method="POST">
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