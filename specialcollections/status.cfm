<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: status.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/23/2008 --->
<!--- Date in Production: 07/23/2008 --->
<!--- Module: Add/Modify/Delete Information to Special Collections - Status --->
<!-- Last modified by John R. Pastori on 07/23/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/status.cfm">
<CFSET CONTENT_UPDATED = "July 23, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Special Collections - Status</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Special Collections - Status</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Library Shared Data Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.STATUS.STATUSNAME.value == "" || document.STATUS.STATUSNAME.value == " ") {
			alertuser (document.STATUS.STATUSNAME.name +  ",  A Status Name MUST be entered!");
			document.STATUS.STATUSNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.STATUSID.selectedIndex == "0") {
			alertuser ("A Status Name MUST be selected!");
			document.LOOKUP.STATUSID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSTATUS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.STATUSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.STATUS.STATUSNAME.focus()">
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

<CFQUERY name="ListStatus" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
	SELECT	STATUSID, STATUSNAME
	FROM		STATUS
	ORDER BY	STATUSNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*****************************************************
* The following code is the ADD Process for Status. *
*****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Special Collections - Status</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	MAX(STATUSID) AS MAX_ID
			FROM		STATUS
		</CFQUERY>
		<CFSET FORM.STATUSID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="STATUSID" secure="NO" value="#FORM.STATUSID#">
		<CFQUERY name="AddStatusID" datasource="#application.type#SPECIALCOLLECTIONS">
			INSERT INTO	STATUS (STATUSID)
			VALUES		(#val(Cookie.STATUSID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Status Key &nbsp; = &nbsp; #FORM.STATUSID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processstatus.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessStatus" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="STATUS" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processstatus.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="STATUSNAME">*Status Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="STATUSNAME" id="STATUSNAME" value="" align="LEFT" required="No" size="30" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessStatus" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processstatus.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessStatus" value="CANCELADD" tabindex="4" /><BR />
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
********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Status. *
********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Special Collections - Status </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPSTATUS')>
		<TR>
			<TH align="center">Status Key &nbsp; = &nbsp; #FORM.STATUSID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPSTATUS')>
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/specialcollections/status.cfm?PROCESS=#URL.PROCESS#&LOOKUPSTATus=FOUND" method="POST">
		<TR>
			<TH align="LEFT" width="30%"><H4><LABEL for="STATUSID">*Status Name:</LABEL></H4></TH>
			<TD align="LEFT" width="70%">
				<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatus" value="STATUSID" display="STATUSNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
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
********************************************************************
* The following code is the Modify and Delete Processes for Status.*
********************************************************************
 --->

		<CFQUERY name="GetStatus" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	STATUSID, STATUSNAME
			FROM		STATUS
			WHERE	STATUSID = <CFQUERYPARAM value="#FORM.STATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/status.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessStatus" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="STATUS" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processstatus.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="STATUSID" secure="NO" value="#FORM.STATUSID#">
				<TH align="left"><H4><LABEL for="STATUSNAME">*Status Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="STATUSNAME" id="STATUSNAME" value="#GetStatus.STATUSNAME#" align="LEFT" required="No" size="30" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessStatus" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessStatus" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/status.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessStatus" value="Cancel" tabindex="5" /><BR />
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