<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: regaccept.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/28/2009 --->
<!--- Date in Production: 01/28/2009 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Registration Acceptance Type --->
<!-- Last modified by John R. Pastori on 01/28/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/regaccept.cfm">
<CFSET CONTENT_UPDATED = "January 28, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>

	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Registration Acceptance Type</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Registration Acceptance Type</TITLE>
	</CFIF>

	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->

<SCRIPT language="JavaScript">

	window.defaultStatus = "Welcome to Instruction - Orientation Statistics";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.REGACCEPT.REGACCEPTTYPE.value == "" || document.REGACCEPT.REGACCEPTTYPE.value == " ") {
			alertuser (document.REGACCEPT.REGACCEPTTYPE.name +  ",  A Registration Acceptance Type MUST be entered!");
			document.REGACCEPT.REGACCEPTTYPE.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.REGACCEPTID.selectedIndex == "0") {
			alertuser ("A Registration Acceptance Type MUST be selected!");
			document.LOOKUP.REGACCEPTID.focus();
			return false;
		}
	}


//

</SCRIPT>

<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPREGACCEPTS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.REGACCEPTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.REGACCEPT.REGACCEPTTYPE.focus()">
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

<CFQUERY name="ListRegAcceptType" datasource="#application.type#INSTRUCTION" blockfactor="5">
	SELECT	REGACCEPTID, REGACCEPTTYPE
	FROM		REGACCEPT
	ORDER BY	REGACCEPTTYPE
</CFQUERY>

<BR clear="left" />

<!--- 
***************************************************************************
* The following code is the ADD Process for Registration Acceptance Type. *
***************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Registration Acceptance Type</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
		SELECT	MAX(REGACCEPTID) AS MAX_ID
		FROM		REGACCEPT
	</CFQUERY>

	<CFSET FORM.REGACCEPTID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="REGACCEPTID" secure="NO" value="#FORM.REGACCEPTID#">
	<CFQUERY name="AddRegAcceptTypeID" datasource="#application.type#INSTRUCTION">
		INSERT INTO	REGACCEPT (REGACCEPTID)
		VALUES		(#val(Cookie.REGACCEPTID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Registration Acceptance Type Key &nbsp; = &nbsp; #FORM.REGACCEPTID#
			</TH>
		</TR>
	</TABLE>

	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processregaccept.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessRegAcceptType" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="REGACCEPT" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processregaccept.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="REGACCEPTTYPE">*Registration Acceptance Type:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="REGACCEPTTYPE" id="REGACCEPTTYPE" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessRegAcceptType" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processregaccept.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessRegAcceptType" value="CANCELADD" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
******************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Registration Acceptance Type. *
******************************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Instruction - Registration Acceptance Type </H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPREGACCEPTS')>
		<TR>
			<TH align="center">Registration Acceptance Type Key &nbsp; = &nbsp; #FORM.REGACCEPTID#</TH>
		</TR>
	</CFIF>
	</TABLE>

	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPREGACCEPTS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/regaccept.cfm?PROCESS=#URL.PROCESS#&LOOKUPREGACCEPTS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="REGACCEPTID">*Registration Acceptance Type:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="REGACCEPTID" id="REGACCEPTID" size="1" query="ListRegAcceptType" value="REGACCEPTID" display="REGACCEPTTYPE" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
******************************************************************************************
* The following code is the Modify and Delete Processes for Registration Acceptance Type.*
******************************************************************************************
 --->

		<CFQUERY name="GetRegAcceptType" datasource="#application.type#INSTRUCTION">
			SELECT	REGACCEPTID, REGACCEPTTYPE
			FROM		REGACCEPT
			WHERE	REGACCEPTID = <CFQUERYPARAM value="#FORM.REGACCEPTID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	REGACCEPTTYPE
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/instruction/regaccept.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessRegAcceptType" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="REGACCEPT" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processregaccept.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="REGACCEPTID" secure="NO" value="#FORM.REGACCEPTID#">
				<TH align="left"><H4><LABEL for="REGACCEPTTYPE">*Registration Acceptance Type:</label></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="REGACCEPTTYPE" id="REGACCEPTTYPE" value="#GetRegAcceptType.REGACCEPTTYPE#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessRegAcceptType" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessRegAcceptType" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/regaccept.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessRegAcceptType" value="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>