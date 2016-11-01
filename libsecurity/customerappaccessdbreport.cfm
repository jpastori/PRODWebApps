<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: customerappaccessdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/03/2008 --->
<!--- Date in Production: 12/03/2008 --->
<!--- Module: Library Security - Customer Application Access Report --->
<!-- Last modified by John R. Pastori on 12/03/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/customerappaccessdbreport.cfm">
<CFSET CONTENT_UPDATED = "December 03, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Library Security - Customer Application Access Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Library Security - Customer Application Access Report";


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
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined("URL.PROCESS")>
	<CFSET CURSORFIELD = "document.LOOKUP..REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
********************************************************************************************************
* The following code is the Look Up Process for Library Security - Customer Application Access Report. *
********************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.INITIALS, CUST.SECURITYLEVELID, CUST.PASSWORD,
				CUST.ACTIVE, CUST.UNITID, U.DEPARTMENTID
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	CUST.UNITID = U.UNITID
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListDBSystems" datasource="#application.type#LIBSECURITY" blockfactor="13">
		SELECT	DBSYSTEMID, DBSYSTEMNUMBER, DBSYSTEMNAME
		FROM		DBSYSTEMS
		ORDER BY	DBSYSTEMNAME
	</CFQUERY>

	<CFQUERY name="ListSecurityLevels" datasource="#application.type#LIBSECURITY" blockfactor="8">
		SELECT	SECURITYLEVELID, SECURITYLEVELNUMBER, SECURITYLEVELNAME
		FROM		SECURITYLEVELS
		ORDER BY	SECURITYLEVELNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Select Data for Library Security - Customer Application Access Report</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/libsecurity/customerappaccessdbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>SELECT ONE OF THE FOUR (4) REPORTS BELOW</COM></TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP"><INPUT type="SUBMIT" value="Select Options" tabindex="2" /></TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1: </LABEL>&nbsp;&nbsp;<LABEL for="ACTIVE1">Select All, Active or Inactive Customer Application Access Records</LABEL></TH>
			<TD align="left" nowrap>
				<CFSELECT name="ACTIVE1" id="ACTIVE1" size="1" tabindex="4">
					<OPTION value="-1">Select Active-YES or Inactive-NO</OPTION>
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE2">REPORT 2: </LABEL>&nbsp;&nbsp;<LABEL for="CUSTOMERID">Specific Customer Access Assignments</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="7">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE3">REPORT 3: </LABEL>&nbsp;&nbsp;<LABEL for="DBSYSTEMID">Specific Application Database System</LABEL> and <LABEL for="ACTIVE3">Active:YES/NO</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="DBSYSTEMID" id="DBSYSTEMID" size="1" query="ListDBSystems" value="DBSYSTEMID" display="DBSYSTEMNAME" required="No" tabindex="8"></CFSELECT>&nbsp;&nbsp;&nbsp;&nbsp;
				<CFSELECT name="ACTIVE3" id="ACTIVE3" size="1" tabindex="9">
					<OPTION value="-1">Select Active-YES or Inactive-NO</OPTION>
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="10">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE4">REPORT 4: </LABEL>&nbsp;&nbsp;<LABEL for="SECURITYLEVELID">Specific Security Level</LABEL> and <LABEL for="ACTIVE4">Active:YES/NO</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SECURITYLEVELID" id="SECURITYLEVELID" size="1" query="ListSecurityLevels" value="SECURITYLEVELID" display="SECURITYLEVELNAME" required="No" tabindex="11"></CFSELECT>&nbsp;&nbsp;&nbsp;&nbsp;
				<CFSELECT name="ACTIVE4" id="ACTIVE4" size="1" tabindex="12">
					<OPTION value="-1">Select Active-YES or Inactive-NO</OPTION>
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP"><INPUT type="SUBMIT" value="Select Options" tabindex="13" /></TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="14" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
		<TD align="left" valign="TOP" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
	<CFEXIT>

<CFELSE>

<!--- 
************************************************************************************
* The following code is the Customer Application Access Report Generation Process. *
************************************************************************************
 --->

	<CFSET REPORTTITLE = ''>
	<CFIF #FORM.REPORTCHOICE# EQ 1>

		<CFQUERY name="ListCustomerAppAccess" datasource="#application.type#LIBSECURITY" blockfactor="100">
			SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CUST.UNITID, U.UNITID, U.UNITNAME,
					CAA.PASSWORD, CAA.DBSYSTEMID, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELNAME,
					CAA.MODIFIEDBYID, MODBY.FULLNAME AS MODBYNAME, CAA.MODIFIEDDATE, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
			FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, DBSYSTEMS DBS, SECURITYLEVELS SL,
					LIBSHAREDDATAMGR.CUSTOMERS MODBY
			WHERE	CAA.CUSTAPPACCESSID > 0 AND
					CAA.CUSTOMERID = CUST.CUSTOMERID AND
				<CFIF #FORM.ACTIVE1# NEQ '-1'>
					CUST.ACTIVE = '#FORM.ACTIVE1#' AND
				</CFIF>
					CUST.UNITID = U.UNITID AND
					CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
					CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
					CAA.MODIFIEDBYID = MODBY.CUSTOMERID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;All Customer Application Access Records'>
		<CFIF #FORM.ACTIVE1# NEQ '-1'>
			<CFSET REPORTTITLE = #REPORTTITLE# & "<BR>Where ACTIVE FLAG is #FORM.ACTIVE1#">
		</CFIF>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>

		<CFQUERY name="LookupCustomer" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.FULLNAME
			FROM		CUSTOMERS CUST
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CUST.FULLNAME
		</CFQUERY>

		<CFQUERY name="ListCustomerAppAccess" datasource="#application.type#LIBSECURITY">
			SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CUST.UNITID, U.UNITID, U.UNITNAME,
					CAA.PASSWORD, CAA.DBSYSTEMID, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELNAME,
					CAA.MODIFIEDBYID, MODBY.FULLNAME AS MODBYNAME, CAA.MODIFIEDDATE, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
			FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, DBSYSTEMS DBS, SECURITYLEVELS SL,
					LIBSHAREDDATAMGR.CUSTOMERS MODBY
			WHERE	CAA.CUSTAPPACCESSID > 0 AND
					CAA.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CAA.CUSTOMERID = CUST.CUSTOMERID AND
					CUST.UNITID = U.UNITID AND
					CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
					CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
					CAA.MODIFIEDBYID = MODBY.CUSTOMERID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;Specific Customer Access Assignments - #LookupCustomer.FULLNAME#'>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>

		<CFQUERY name="ListCustomerAppAccess" datasource="#application.type#LIBSECURITY" blockfactor="100">
			SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CUST.UNITID, U.UNITID, U.UNITNAME,
					CAA.PASSWORD, CAA.DBSYSTEMID, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELNAME,
					CAA.MODIFIEDBYID, MODBY.FULLNAME AS MODBYNAME, CAA.MODIFIEDDATE, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
			FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, DBSYSTEMS DBS, SECURITYLEVELS SL,
					LIBSHAREDDATAMGR.CUSTOMERS MODBY
			WHERE	CAA.CUSTAPPACCESSID > 0 AND
					CAA.CUSTOMERID = CUST.CUSTOMERID AND
				<CFIF #FORM.ACTIVE3# NEQ '-1'>
					CUST.ACTIVE = '#FORM.ACTIVE3#' AND
				</CFIF>
					CUST.UNITID = U.UNITID AND
					CAA.DBSYSTEMID = #val(FORM.DBSYSTEMID)# AND
					CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
					CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
					CAA.MODIFIEDBYID = MODBY.CUSTOMERID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 3: &nbsp;&nbsp;Specific Application Database System - #ListCustomerAppAccess.DBSYSTEMNAME#'>
		<CFIF #FORM.ACTIVE3# NEQ '-1'>
			<CFSET REPORTTITLE = #REPORTTITLE# & "<BR>Where ACTIVE FLAG is #FORM.ACTIVE3#">
		</CFIF>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>

		<CFQUERY name="ListCustomerAppAccess" datasource="#application.type#LIBSECURITY" blockfactor="100">
			SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CUST.UNITID, U.UNITID, U.UNITNAME,
					CAA.PASSWORD, CAA.DBSYSTEMID, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELNAME,
					CAA.MODIFIEDBYID, MODBY.FULLNAME AS MODBYNAME, CAA.MODIFIEDDATE, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
			FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, DBSYSTEMS DBS, SECURITYLEVELS SL,
					LIBSHAREDDATAMGR.CUSTOMERS MODBY
			WHERE	CAA.CUSTAPPACCESSID > 0 AND
					CAA.CUSTOMERID = CUST.CUSTOMERID AND
				<CFIF #FORM.ACTIVE4# NEQ '-1'>
					CUST.ACTIVE = '#FORM.ACTIVE4#' AND
				</CFIF>
					CUST.UNITID = U.UNITID AND
					CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
					CAA.SECURITYLEVELID = #val(FORM.SECURITYLEVELID)# AND
					CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
					CAA.MODIFIEDBYID = MODBY.CUSTOMERID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 4: &nbsp;&nbsp;Specific Security Level - #ListCustomerAppAccess.SECURITYLEVELNAME#'>
		<CFIF #FORM.ACTIVE4# NEQ '-1'>
			<CFSET REPORTTITLE = #REPORTTITLE# & "<BR>Where ACTIVE FLAG is #FORM.ACTIVE4#">
		</CFIF>

	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Library Security - Customer Application Access Database Report
				<H2>#REPORTTITLE#
			</H2></H1></TD>
		</TR>
	</TABLE>
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/customerappaccessdbreport.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="7">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="left" colspan="7"><H2>#ListCustomerAppAccess.RecordCount# Customer Application Access records were selected.</H2></TH>
		</TR>
		<TR>
		<CFIF #FORM.REPORTCHOICE# NEQ 2>
			<TH align="left">Customer</TH>
		</CFIF>
			<TH align="left">Unit</TH>
			<TH align="left">Active Customer</TH>
		<CFIF #FORM.REPORTCHOICE# NEQ 3>
			<TH align="left">Database System</TH>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# NEQ 4>
			<TH align="left">Security Access Level</TH>
		</CFIF>
			<TH align="left">Modified By</TH>
			<TH align="left">Modified Date</TH>
		</TR>
	
	<CFLOOP query="ListCustomerAppAccess">
		<TR>
		<CFIF #FORM.REPORTCHOICE# NEQ 2>
			<TD align="left"><DIV>#ListCustomerAppAccess.FULLNAME#</DIV></TD>
		</CFIF>
			<TD align="left"><DIV>#ListCustomerAppAccess.UNITNAME#</DIV></TD>
			<TD align="left"><DIV>#ListCustomerAppAccess.ACTIVE#</DIV></TD>
		<CFIF #FORM.REPORTCHOICE# NEQ 3>
			<TD align="left"><DIV>#ListCustomerAppAccess.DBSYSTEMNAME#</DIV></TD>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# NEQ 4>
			<TD align="left"><DIV>#ListCustomerAppAccess.SECURITYLEVELNAME#</DIV></TD>
		</CFIF>
			<TD align="left"><DIV>#ListCustomerAppAccess.MODBYNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#DateFormat(ListCustomerAppAccess.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="left" colspan="7"><H2>#ListCustomerAppAccess.RecordCount# Customer Application Access records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/customerappaccessdbreport.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="7">
				<INPUT type="SUBMIT" value="Cancel" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="7">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>