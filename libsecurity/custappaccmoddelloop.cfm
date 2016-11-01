<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custappaccmoddelloop.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/05/2009 --->
<!--- Date in Production: 08/05/2009 --->
<!--- Module: Modify/Delete Loop Information Update to Library Security - Customer Application Access --->
<!-- Last modified by John R. Pastori on 08/05/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/custappaccmoddelloop.cfm">
<CFSET CONTENT_UPDATED = "August 05, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Modify/Delete Loop Information Update to Library Security - Customer Application Access</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Library Security - Customer Application Access";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
		if (document.CUSTOMERAPPACCESS.SECURITYLEVELID.selectedIndex == "0") {
			alertuser (document.CUSTOMERAPPACCESS.SECURITYLEVELID.name +  ",  A Security Level MUST be selected!");
			document.CUSTOMERAPPACCESS.SECURITYLEVELID.focus();
			return false;
		}
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
	<CFSET CURSORFIELD = "document.CUSTOMERAPPACCESS.PASSWORD.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, FULLNAME, INITIALS, SECURITYLEVELID, PASSWORD, ACTIVE
	FROM		CUSTOMERS
	WHERE	ACTIVE = 'YES'
	ORDER BY	FULLNAME
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
	SELECT	DISTINCT CAA.MODIFIEDBYID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	CAA.MODIFIEDBYID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<BR clear="left" />

<!--- 
****************************************************************************************************************************
* The following code is the Look Up Process for Modify/Delete Loop Information Update to Customer Application Access Info. *
****************************************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER')>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Lookup for Modify/Delete Loop Information Update to Library Security - Customer Application Access</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required! </H4></TH>
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=#URL.PROCESS#&LOOKUPCUSTOMER=FOUND" method="POST">
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
********************************************************************************************************
* The following code is the Modify/Delete Loop Information Update to Customer Application Access Info. *
********************************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOP')>
		<CFSET temp = ArraySet(session.CustomerAccessIDArray, 1, 1, 0)>
		<CFSET session.ArrayCounter = 1>

		<CFQUERY name="LookupCustomerAppAccess" datasource="#application.type#LIBSECURITY">
			SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CAA.DBSYSTEMID, CAA.SECURITYLEVELID,
					CAA.MODIFIEDBYID, CAA.MODIFIEDDATE, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
			FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS, SECURITYLEVELS SL
			WHERE	CAA.CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CAA.CUSTOMERID = CUST.CUSTOMERID AND
					CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
					CAA.SECURITYLEVELID = SL.SECURITYLEVELID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFIF #LookupCustomerAppAccess.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("The Selected Customer was Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=MODIFYLOOP" />
			<CFEXIT>
		</CFIF>

		<CFSET CUSTAPPACCESSIDS = ValueList(LookupCustomerAppAccess.CUSTAPPACCESSID)>
		<CFSET temp = ArraySet(session.CustomerAccessIDArray, 1, LISTLEN(CUSTAPPACCESSIDS), 0)> 
		<CFSET session.CustomerAccessIDArray = ListToArray(CUSTAPPACCESSIDS)>
		<CFSET FORM.CUSTAPPACCESSID = session.CustomerAccessIDArray[session.ArrayCounter]>
		<!--- CUSTOMER ACCESS IDs = #CUSTAPPACCESSIDS# --->
	<CFELSE>
		<CFSET session.ArrayCounter = session.ArrayCounter + 1>
		<CFSET FORM.CUSTAPPACCESSID = session.CustomerAccessIDArray[session.ArrayCounter]>
	</CFIF>

	<CFQUERY name="GetCustomerAppAccess" datasource="#application.type#LIBSECURITY">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.FULLNAME, CAA.DBSYSTEMID, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID,
				CAA.MODIFIEDBYID, CAA.MODIFIEDDATE, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS, SECURITYLEVELS SL
		WHERE	CAA.CUSTAPPACCESSID = <CFQUERYPARAM value="#FORM.CUSTAPPACCESSID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Loop Information Update to Library Security - Customer Application Access</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<TR>
			<TH align="center">
				CUSTOMERAPPACCESS Key &nbsp; = &nbsp; #FORM.CUSTAPPACCESSID#
				<CFCOOKIE name="CUSTAPPACCESSID" secure="NO" value="#FORM.CUSTAPPACCESSID#">
			</TH>
		</TR>
	</TABLE>
	<TABLE align="left" width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=#URL.PROCESS#" method="POST">
		<TD align="LEFT" colspan="2">
			<INPUT type="submit" name="ProcessCustAppAccess" value="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
<CFFORM name="CUSTOMERAPPACCESS" onsubmit="return validateReqFields();" action="/#application.type#apps/libsecurity/processcustomerappaccess.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Customer</TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				#GetCustomerAppAccess.FULLNAME#
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left">Database System</TH>
			<TH align="left"><H4><LABEL for="SECURITYLEVELID">*Security Access Level</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				#GetCustomerAppAccess.DBSYSTEMNAME#<BR />
			</TD>
			<TD align="left" valign="TOP" nowrap>
				<CFSELECT name="SECURITYLEVELID" id="SECURITYLEVELID" size="1" query="ListSecurityLevels" value="SECURITYLEVELID" display="SECURITYLEVELNAME" selected="#GetCustomerAppAccess.SECURITYLEVELID#" required="No" tabindex="2"></CFSELECT><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
			<TH align="left">Date Modified</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" size="1" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#GetCustomerAppAccess.MODIFIEDBYID#" required="No" tabindex="3"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessCustAppAccess" value="MODIFYLOOP" tabindex="4" /></TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCustAppAccess" value="NEXTRECORD" tabindex="5" />
				&nbsp;&nbsp;(No change including Modified Date field.)
			</TD>
		</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessCustAppAccess" value="DELETELOOP" tabindex="6" /></TD>
		</TR>
		</CFIF>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/custappaccmoddelloop.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessCustAppAccess" value="Cancel" tabindex="7" /><BR />
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
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>