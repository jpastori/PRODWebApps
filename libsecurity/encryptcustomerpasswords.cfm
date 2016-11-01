<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: encryptcustomerpasswords.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/20/2009 --->
<!--- Date in Production: 05/20/2009 --->
<!--- Module: Process Information to Library Security - Encrypt Customer Passwords --->
<!-- Last modified by John R. Pastori on 07/24/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/encryptcustomerpasswords.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Security - Encrypt Customer Passwords</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Library Security  - Encrypt Customer Passwords";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateLookupField() {
		if (document.LOOKUP.CUSTID.selectedIndex == "0") {
			alertuser ("A Customer Name MUST be selected!");
			document.LOOKUP.CUSTID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCUST')>
	<CFSET CURSORFIELD = "document.LOOKUP.CUSTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.LOOKUPCUST') AND #URL.CHANGE# EQ 'SINGLE'>

	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.UNITID, U.UNITID, CUST.PASSWORD, CUST.ACTIVE, CUST.SEEDKEY
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.UNITID = U.UNITID) AND
				(CUST.CUSTOMERID = 0 OR
				U.DEPARTMENTID = 8)
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Look up Customer For Password Change</H1></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!&nbsp;&nbsp;&nbsp;&nbsp; </H4></TH>
		</TR>
	</TABLE>
<BR clear="left" />

	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libsecurity/encryptcustomerpasswords.cfm?LOOKUPCUST=FOUND&CHANGE=SINGLE" method="POST">
		<TR>
			<TH align="LEFT" width="30%"><H4><LABEL for="CUSTID">*Customer Name:</LABEL></H4></TH>
			<TD align="LEFT" width="70%"><CFSELECT name="CUSTID" id="CUSTID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
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
			<TD align="left" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

	<CFIF #URL.CHANGE# EQ 'SINGLE'>

		<CFQUERY name="LookupCustomer" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.UNITID, U.UNITID, CUST.PASSWORD, CUST.ACTIVE, CUST.SEEDKEY
			FROM		CUSTOMERS CUST, UNITS U
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CUST.UNITID = U.UNITID AND
					U.DEPARTMENTID = 8
			ORDER BY	CUST.FULLNAME
		</CFQUERY>

	<CFELSE>

		<CFQUERY name="LookupCustomer" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.UNITID, U.UNITID, CUST.PASSWORD, CUST.ACTIVE, CUST.SEEDKEY
			FROM		CUSTOMERS CUST, UNITS U
			WHERE	CUST.CUSTOMERID > 0 AND
					CUST.UNITID = U.UNITID AND
					NOT U.GROUPID = 4 AND
					U.DEPARTMENTID = 8
			ORDER BY	CUST.FULLNAME
		</CFQUERY>

	</CFIF>

	<CFSET FORM.PASSWORD = '##LIBrarY123$'>
	<CFSET FORM.SEEDKEY = NOW()>
	<CFSET FORM.SEEDKEY = ListChangeDelims(FORM.SEEDKEY, "@", "'")>
	<CFSET FORM.NEWPASSWORD = ENCRYPT(#FORM.PASSWORD#, #FORM.SEEDKEY#)>

	<CFLOOP query="LookupCustomer">

		<CFQUERY name="ModifyCustomer" datasource="#application.type#LIBSHAREDDATA">
			UPDATE	CUSTOMERS
			SET		PASSWORD = '#FORM.NEWPASSWORD#',
					SEEDKEY = '#FORM.SEEDKEY#'
			WHERE	(CUSTOMERID = #val(LookupCustomer.CUSTOMERID)#)
		</CFQUERY>

		<CFQUERY name="LookupAccessSecurityRecords" datasource="#application.type#LIBSECURITY">
			SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID, DBS.DBSYSTEMID,
					DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID,
					SL.SECURITYLEVELNUMBER, SL.SECURITYLEVELNAME, CAA.MODIFIEDBYID, CAA.MODIFIEDDATE
			FROM		CUSTOMERAPPACCESS CAA, DBSYSTEMS DBS, SECURITYLEVELS SL, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	CAA.CUSTOMERID = <CFQUERYPARAM value="#LookupCustomer.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CAA.CUSTOMERID = CUST.CUSTOMERID AND
					CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
					CAA.SECURITYLEVELID = SL.SECURITYLEVELID
			ORDER BY	CAA.CUSTOMERID, DBS.DBSYSTEMNUMBER
		</CFQUERY>

	NAME IS #LookupCustomer.FULLNAME# &nbsp;&nbsp;&nbsp;&nbsp;FORM SEED KEY IS #FORM.SEEDKEY# &nbsp;&nbsp;&nbsp;&nbsp;FORM NEW PASSWORD ID #FORM.NEWPASSWORD#<BR /><BR />

		<CFLOOP query="LookupAccessSecurityRecords">
			<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>

			<CFQUERY name="ModifyAddedCustomerAppAccess" datasource="#application.type#LIBSECURITY">
				UPDATE	CUSTOMERAPPACCESS
				SET		PASSWORD = '#FORM.NEWPASSWORD#',
						MODIFIEDBYID = #val(Client.CUSTOMERID)#,
						MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
				WHERE	(CUSTAPPACCESSID = #val(LookupAccessSecurityRecords.CUSTAPPACCESSID)#)
			</CFQUERY>

		</CFLOOP>

	</CFLOOP>

	<H1>PASSWORDS SUCCESSFULLY UPDATED!</H1>
	<META http-equiv="Refresh" content="10; URL=/#application.type#apps/libsecurity/index.cfm?logout=Yes" />
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>