<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: securitylevelsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/03/2008 --->
<!--- Date in Production: 12/03/2008 --->
<!--- Module: Add/Modify/Delete Information to Library Security - Security Levels --->
<!-- Last modified by John R. Pastori on 12/03/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/securitylevelsinfo.cfm">
<CFSET CONTENT_UPDATED = "December 03, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Library Security - Security Levels</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Library Security - Security Levels</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Library Security  - Security Levels";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.SECURITYLEVELS.SECURITYLEVELNUMBER.value == "" || document.SECURITYLEVELS.SECURITYLEVELNUMBER.value == " ") {
			alertuser (document.SECURITYLEVELS.SECURITYLEVELNUMBER.name +  ",  A Security Level Number MUST be entered!");
			document.SECURITYLEVELS.SECURITYLEVELNUMBER.focus();
			return false;
		}

		if (document.SECURITYLEVELS.SECURITYLEVELNAME.value == "" || document.SECURITYLEVELS.SECURITYLEVELNAME.value == " ") {
			alertuser (document.SECURITYLEVELS.SECURITYLEVELNAME.name +  ",  A Security Level Name MUST be entered!");
			document.SECURITYLEVELS.SECURITYLEVELNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.SECURITYLEVELID.selectedIndex == "0") {
			alertuser ("A Security Level Name MUST be selected!");
			document.LOOKUP.SECURITYLEVELID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSECLEVEL') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SECURITYLEVELID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SECURITYLEVELS.SECURITYLEVELNUMBER.focus()">
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

<CFQUERY name="ListSecurityLevels" datasource="#application.type#LIBSECURITY" blockfactor="8">
	SELECT	SECURITYLEVELID, SECURITYLEVELNUMBER, SECURITYLEVELNAME
	FROM		SECURITYLEVELS
	ORDER BY	SECURITYLEVELNAME
</CFQUERY>

<!--- 
*************************************************************
* The following code is the ADD Process for Security Levels *
*************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Library Security - Security Levels</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSECURITY">
		SELECT	MAX(SECURITYLEVELID) AS MAX_ID
		FROM		SECURITYLEVELS
	</CFQUERY>
	<CFSET FORM.SECURITYLEVELID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="SECURITYLEVELID" secure="NO" value="#FORM.SECURITYLEVELID#">
	<CFQUERY name="AddSecurityLevelID" datasource="#application.type#LIBSECURITY">
		INSERT INTO	SECURITYLEVELS (SECURITYLEVELID)
		VALUES		(#val(Cookie.SECURITYLEVELID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Security Levels Key &nbsp; = &nbsp; #FORM.SECURITYLEVELID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="LEFT" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/processsecuritylevelsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessSecurityLevels" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SECURITYLEVELS" onsubmit="return validateReqFields();" action="/#application.type#apps/libsecurity/processsecuritylevelsinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="SECURITYLEVELNUMBER">*Security Level Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="SECURITYLEVELNAME">*Security Level</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="SECURITYLEVELNUMBER" id="SECURITYLEVELNUMBER" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="SECURITYLEVELNAME" id="SECURITYLEVELNAME" value="" align="LEFT" required="No" size="50" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessSecurityLevels" value="ADD" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/processsecuritylevelsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessSecurityLevels" value="CANCELADD" tabindex="5" /><BR />
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
****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Security Levels *
****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Library Security - Security Levels</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPSECLEVEL')>
		<TR>
			<TH align="center">Security Level Key &nbsp; = &nbsp; #FORM.SECURITYLEVELID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPSECLEVEL')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libsecurity/securitylevelsinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPSECLEVEL=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="SECURITYLEVELID">*Security Level:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="SECURITYLEVELID" id="SECURITYLEVELID" size="1" query="ListSecurityLevels" value="SECURITYLEVELID" display="SECURITYLEVELNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD  align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
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
*****************************************************************************
* The following code is the Modify and Delete Processes for Security Levels *
*****************************************************************************
 --->

		<CFQUERY name="GetSecurityLevels" datasource="#application.type#LIBSECURITY">
			SELECT	SECURITYLEVELID, SECURITYLEVELNUMBER, SECURITYLEVELNAME
			FROM		SECURITYLEVELS
			WHERE	SECURITYLEVELID = <CFQUERYPARAM value="#FORM.SECURITYLEVELID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SECURITYLEVELNAME
		</CFQUERY>

		<TABLE align="LEFT" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/securitylevelsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessSecurityLevels" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="SECURITYLEVELS" onsubmit="return validateReqFields();" action="/#application.type#apps/libsecurity/processsecuritylevelsinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left"><H4><LABEL for="SECURITYLEVELNUMBER">*Security Level Number</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="SECURITYLEVELNAME">*Security Level</LABEL></H4></TH>
			</TR>
			<TR>
				<CFCOOKIE name="SECURITYLEVELID" secure="NO" value="#FORM.SECURITYLEVELID#">
				<TD align="left"><CFINPUT type="Text" name="SECURITYLEVELNUMBER" id="SECURITYLEVELNUMBER" value="#GetSecurityLevels.SECURITYLEVELNUMBER#" align="LEFT" required="No" size="50" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="SECURITYLEVELNAME" id="SECURITYLEVELNAME" value="#GetSecurityLevels.SECURITYLEVELNAME#" align="LEFT" required="No" size="50" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessSecurityLevels" value="MODIFY" tabindex="4" /></TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessSecurityLevels" value="DELETE" tabindex="5" /></TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/securitylevelsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessSecurityLevels" value="Cancel" tabindex="6" /><BR />
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
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>