<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: customerappaccess.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/11/2008 --->
<!--- Date in Production: 12/11/2008 --->
<!--- Module: Add/Modify/Delete Information to Library Security - Customer Application Access --->
<!-- Last modified by John R. Pastori on 12/11/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/customerappaccess.cfm">
<CFSET CONTENT_UPDATED = "December 11 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Library Security - Customer Application Access</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Library Security - Customer Application Access</TITLE>
	</CFIF>
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
		if (document.CUSTOMERAPPACCESS.CUSTOMERID != null && document.CUSTOMERAPPACCESS.CUSTOMERID.selectedIndex == "0") {
			alertuser (document.CUSTOMERAPPACCESS.CUSTOMERID.name +  ",  A Customer MUST be selected!");
			document.CUSTOMERAPPACCESS.CUSTOMERID.focus();
			return false;
		}

		if (document.CUSTOMERAPPACCESS.DBSYSTEMID != null && document.CUSTOMERAPPACCESS.DBSYSTEMID.selectedIndex == "0") {
			alertuser (document.CUSTOMERAPPACCESS.DBSYSTEMID.name +  ",  A DB System Name MUST be selected!");
			document.CUSTOMERAPPACCESS.DBSYSTEMID.focus();
			return false;
		}

		if (document.CUSTOMERAPPACCESS.SECURITYLEVELID.selectedIndex == "0") {
			alertuser (document.CUSTOMERAPPACCESS.SECURITYLEVELID.name +  ",  A Security Level MUST be selected!");
			document.CUSTOMERAPPACCESS.SECURITYLEVELID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.CUSTAPPACCESSID.selectedIndex == "0") {
			alertuser ("A Customer/DB System MUST be selected!");
			document.LOOKUP.CUSTAPPACCESSID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CUSTAPPACCESSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CUSTOMERAPPACCESS.CUSTOMERID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListCustomerAppAccess" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNAME,
			CAA.MODIFIEDBYID, CAA.MODIFIEDDATE, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
		<CFIF URL.PROCESS EQ 'ADD'>
			CUST.ACTIVE = 'YES' AND
		</CFIF>
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID
	ORDER BY	LOOKUPKEY
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
			SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 600 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 40
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*************************************************************************
* The following code is the ADD Process for Customer Application Access *
*************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Library Security - Customer Application Access</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUSTOMERID, FULLNAME, INITIALS, SECURITYLEVELID, PASSWORD, ACTIVE
			FROM		CUSTOMERS
			WHERE	ACTIVE = 'YES'
			ORDER BY	FULLNAME
		</CFQUERY>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSECURITY">
			SELECT	MAX(CUSTAPPACCESSID) AS MAX_ID
			FROM		CUSTOMERAPPACCESS
		</CFQUERY>
		<CFSET FORM.CUSTAPPACCESSID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="CUSTAPPACCESSID" secure="NO" value="#FORM.CUSTAPPACCESSID#">
		<CFQUERY name="AddCustomerAppAccessID" datasource="#application.type#LIBSECURITY">
			INSERT INTO	CUSTOMERAPPACCESS (CUSTAPPACCESSID)
			VALUES		(#val(Cookie.CUSTAPPACCESSID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Customer Application Access Key &nbsp; = &nbsp; #FORM.CUSTAPPACCESSID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/processcustomerappaccess.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCustAppAccess" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CUSTOMERAPPACCESS" onsubmit="return validateReqFields();" action="/#application.type#apps/libsecurity/processcustomerappaccess.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="CUSTOMERID">*Customer</LABEL></H4></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="2"></CFSELECT><BR />
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="DBSYSTEMID">*Database System (Optional Multiple Selections Allowed)</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="SECURITYLEVELID">*Security Access Level</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="DBSYSTEMID" id="DBSYSTEMID" size="10" query="ListDBSystems" value="DBSYSTEMID" display="DBSYSTEMNAME" selected="0" required="No" tabindex="3" multiple></CFSELECT><BR />
				<COM>(Hold down the shift key when <BR>
				clicking for a range of app systems to be chosen. <BR>
				Use control key and left mouse click (PC) or <BR>
				command key when clicking (Mac) on specific <BR>
				app systems to be chosen.)
				</COM>
			</TD>
			<TD align="left" valign="TOP" nowrap>
				<CFSELECT name="SECURITYLEVELID" id="SECURITYLEVELID" size="1" query="ListSecurityLevels" value="SECURITYLEVELID" display="SECURITYLEVELNAME" selected="#ListCustomers.SECURITYLEVELID#" required="No" tabindex="4"></CFSELECT><BR />
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
			<TH align="left">Date Modified</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="5"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessCustAppAccess" value="ADD" tabindex="6" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/processcustomerappaccess.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCustAppAccess" value="CANCELADD" tabindex="7" /><BR />
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

<!--- 
****************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Customer Application Access *
****************************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER')>
			<TH align="center"><H1>Lookup for Modify/Delete Information to Library Security - Customer Application Access</H1></TH>
		<CFELSE>
			<TH align="center"><H1>Modify/Delete Information to Library Security - Customer Application Access</H1></TH>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined("URL.LOOKUPCUSTOMER")>
		<TR>
			<TH align="center">CUSTOMERAPPACCESS Key &nbsp; = &nbsp; #FORM.CUSTAPPACCESSID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libsecurity/customerappaccess.cfm?PROCESS=#URL.PROCESS#&LOOKUPCUSTOMER=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%" nowrap><H4><LABEL for="CUSTAPPACCESSID">*Customer - DB System:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="CUSTAPPACCESSID" id="CUSTAPPACCESSID" size="1" query="ListCustomerAppAccess" value="CUSTAPPACCESSID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
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
****************************************************************************************
* The following code is the Modify and Delete Processes for Customer Application Access*
****************************************************************************************
 --->

		<CFQUERY name="GetCustomerAppAccess" datasource="#application.type#LIBSECURITY">
			SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CAA.PASSWORD, CAA.DBSYSTEMID,
					DBS.DBSYSTEMID, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, CAA.MODIFIEDBYID, CAA.MODIFIEDDATE
			FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS
			WHERE	CAA.CUSTAPPACCESSID = <CFQUERYPARAM value="#FORM.CUSTAPPACCESSID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CAA.CUSTOMERID = CUST.CUSTOMERID AND
					CAA.DBSYSTEMID = DBS.DBSYSTEMID
			ORDER BY	CAA.CUSTOMERID
		</CFQUERY>
	
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/customerappaccess.cfm?PROCESS=#URL.PROCESS#" method="POST">
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
				<CFCOOKIE name="CUSTAPPACCESSID" secure="NO" value="#FORM.CUSTAPPACCESSID#">
				<TD align="left" nowrap>
					#GetCustomerAppAccess.FULLNAME#<BR />
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
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#GetCustomerAppAccess.MODIFIEDBYID#" tabindex="3"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessCustAppAccess" value="MODIFY" tabindex="4" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessCustAppAccess" value="DELETE" tabindex="5" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/customerappaccess.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessCustAppAccess" value="Cancel" tabindex="6" /><BR />
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
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>