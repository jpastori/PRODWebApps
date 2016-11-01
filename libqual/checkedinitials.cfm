<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: checkedinitials.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Add/Modify/Delete Information to LibQual Checked Initials Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/checkedinitials.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to LibQual - Checked Initials</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to LibQual - Checked Initials</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the LibQual Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.CHECKEDINITIALS.INITIALS.value == "" || document.CHECKEDINITIALS.INITIALS.value == " ") {
			alertuser (document.CHECKEDINITIALS.INITIALS.name +  ",  A person's Initials MUST be entered!");
			document.CHECKEDINITIALS.INITIALS.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.CHECKEDINITID.selectedIndex == "0") {
			alertuser ("A person's Initials MUST be selected!");
			document.LOOKUP.CHECKEDINITID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPINITIALS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CHECKEDINITID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CHECKEDINITIALS.INITIALS.focus()">
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

<CFQUERY name="ListCheckedInitials" datasource="#application.type#LIBQUAL" blockfactor="12">
	SELECT	CHECKEDINITID, INITIALS
	FROM		LQCHECKEDINITIALS
	ORDER BY	INITIALS
</CFQUERY>

<BR clear="left" />

<!--- 
***************************************************************
* The following code is the ADD Process for Checked Initials. *
***************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to LibQual - Checked Initials</H1></TD>
		</TR>
	</TABLE>
	
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBQUAL">
		SELECT	MAX(CHECKEDINITID) AS MAX_ID
		FROM		LQCHECKEDINITIALS
	</CFQUERY>
	<CFSET FORM.CHECKEDINITID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="CHECKEDINITID" secure="NO" value="#FORM.CHECKEDINITID#">
	<CFQUERY name="AddCheckedInitialsID" datasource="#application.type#LIBQUAL">
		INSERT INTO	LQCHECKEDINITIALS (CHECKEDINITID)
		VALUES		(#val(Cookie.CHECKEDINITID)#)
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Checked Initials Key &nbsp; = &nbsp; #FORM.CHECKEDINITID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libqual/processcheckedinitials.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCheckedInitials" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CHECKEDINITIALS" onsubmit="return validateReqFields();" action="/#application.type#apps/libqual/processcheckedinitials.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4>*Initials:</H4></TH>
			<TD align="left"><CFINPUT type="Text" name="INITIALS" value="" align="LEFT" required="No" size="4" maxlength="10" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessCheckedInitials" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libqual/processcheckedinitials.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCheckedInitials" value="CANCELADD" tabindex="4" /><BR />
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
******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Checked Initials. *
******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to LibQual - Checked Initials</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPINITIALS')>
		<TR>
			<TH align="center">Checked Initials Key &nbsp; = &nbsp; #FORM.CHECKEDINITID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPINITIALS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libqual/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libqual/checkedinitials.cfm?PROCESS=#URL.PROCESS#&LOOKUPINITIALS=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4>*Initials:</H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="CHECKEDINITID" size="1" query="ListCheckedInitials" value="CHECKEDINITID" display="INITIALS" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/libqual/index.cfm?logout=No" method="POST">
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

<!--- 
*******************************************************************************
* The following code is the Modify and Delete Processes for Checked Initials. *
*******************************************************************************
 --->

		<CFQUERY name="GetCheckedInitials" datasource="#application.type#LIBQUAL">
			SELECT	CHECKEDINITID, INITIALS
			FROM		LQCHECKEDINITIALS
			WHERE	CHECKEDINITID = <CFQUERYPARAM value="#FORM.CHECKEDINITID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	INITIALS
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libqual/checkedinitials.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessCheckedInitials" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CHECKEDINITIALS" onsubmit="return validateReqFields();" action="/#application.type#apps/libqual/processcheckedinitials.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="CHECKEDINITID" secure="NO" value="#FORM.CHECKEDINITID#">
				<TH align="left"><H4>*Initials:</H4></TH>
				<TD align="left"><CFINPUT type="Text" name="INITIALS" value="#GetCheckedInitials.INITIALS#" align="LEFT" required="No" size="4" maxlength="10" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessCheckedInitials" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessCheckedInitials" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libqual/checkedinitials.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessCheckedInitials" value="Cancel" tabindex="5" /><BR />
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