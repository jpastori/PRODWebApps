<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custappaccmultipledel.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/06/2009 --->
<!--- Date in Production: 03/06/2009 --->
<!--- Module: Multiple Record Delete To Library Security - Customer Application Access. --->
<!-- Last modified by John R. Pastori on 03/06/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/custappaccmultipledel.cfm">
<CFSET CONTENT_UPDATED = "March 06, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Multiple Record Delete To Library Security - Customer Application Access</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Library Security - Customer Application Access";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateLookupField() {
		if (document.LOOKUP.CUSTOMERID.selectedIndex == "0") {
			alertuser ("A Customer MUST be selected!");
			document.LOOKUP.CUSTOMERID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER')>
	<CFSET CURSORFIELD = "document.LOOKUP.CUSTOMERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
*******************************************************************************************************
* The following code is the Look Up Process for Multiple Record Delete to Customer Application Access *
*******************************************************************************************************
 --->


<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.INITIALS, CUST.SECURITYLEVELID, CUST.PASSWORD, CUST.ACTIVE, CUST.UNITID, U.DEPARTMENTID
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	CUST.ACTIVE = 'YES' AND
			CUST.UNITID = U.UNITID
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

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			CAA.MODIFIEDBYID, CAA.MODIFIEDDATE, SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 700 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER')>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Lookup for Multiple Record Delete To Library Security - Customer Application Access</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libsecurity/custappaccmultipledel.cfm?LOOKUPCUSTOMER=FOUND" method="POST">
		<TR>
			<TH align="LEFT" width="30%" nowrap><H4><LABEL for="CUSTOMERID">*Customer:</LABEL></H4></TH>
			<TD align="LEFT" width="70%">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT"><INPUT type="submit" value="GO" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
************************************************************************************
* The following code is the Customer Application Access Report Generation Process. *
************************************************************************************
 --->

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
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, DBSYSTEMS DBS, SECURITYLEVELS SL, LIBSHAREDDATAMGR.CUSTOMERS MODBY
		WHERE	CAA.CUSTAPPACCESSID > 0 AND
				CAA.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.UNITID = U.UNITID AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				CAA.MODIFIEDBYID = MODBY.CUSTOMERID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFIF #ListCustomerAppAccess.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("The Selected Customer was Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libsecurity/custappaccmultipledel.cfm" />
			<CFEXIT>
		</CFIF>

	<CFSET REPORTTITLE = 'Delete Specific Customer Access Assignments - #LookupCustomer.FULLNAME#'>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Multiple Record Delete To Library Security - Customer Application Access
				<H2>#REPORTTITLE#
			</H2></H1></TD>
		</TR>
	</TABLE>
	<TABLE border="0">
		<TR>
	<CFFORM action="/#application.type#apps/libsecurity/custappaccmultipledel.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="7">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
	</CFFORM>
		</TR>
		<TR>
	<CFFORM action="/#application.type#apps/libsecurity/processcustomerappaccess.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="7">
				<INPUT type="HIDDEN" name="DELCUSTOMERID" value="#FORM.CUSTOMERID#" />
				<INPUT type="SUBMIT" name="ProcessCustAppAccess" value="CONFIRM DELETE" tabindex="2" />
			</TD>
	</CFFORM>
		</TR>
		<TR>
			<TH align="left" colspan="7"><H2>#ListCustomerAppAccess.RecordCount# Customer Application Access records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="left">Unit</TH>
			<TH align="left">Active Customer</TH>
			<TH align="left">Database System</TH>
			<TH align="left">Security Access Level</TH>
			<TH align="left">Modified By</TH>
			<TH align="left">Modified Date</TH>
		</TR>
	
	<CFLOOP query="ListCustomerAppAccess">
		<TR>
			<TD align="left"><DIV>#ListCustomerAppAccess.UNITNAME#</DIV></TD>
			<TD align="left"><DIV>#ListCustomerAppAccess.ACTIVE#</DIV></TD>
			<TD align="left"><DIV>#ListCustomerAppAccess.DBSYSTEMNAME#</DIV></TD>
			<TD align="left"><DIV>#ListCustomerAppAccess.SECURITYLEVELNAME#</DIV></TD>
			<TD align="left"><DIV>#ListCustomerAppAccess.MODBYNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#DateFormat(ListCustomerAppAccess.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="left" colspan="7"><H2>#ListCustomerAppAccess.RecordCount# Customer Application Access records were selected.</H2></TH>
		</TR>
		<TR>
	<CFFORM action="/#application.type#apps/libsecurity/processcustomerappaccess.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="7">
				<INPUT type="HIDDEN" name="DELCUSTOMERID" value="#FORM.CUSTOMERID#" />
				<INPUT type="SUBMIT" name="ProcessCustAppAccess" value="CONFIRM DELETE" tabindex="3" />
			</TD>
	</CFFORM>
		</TR>
		<TR>
	<CFFORM action="/#application.type#apps/libsecurity/custappaccmultipledel.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="7">
				<INPUT type="SUBMIT" value="Cancel" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
	</CFFORM>
		</TR>
		<TR>
			<TD colspan="5">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>