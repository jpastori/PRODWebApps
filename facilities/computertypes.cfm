<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: computertypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/08/2009 --->
<!--- Date in Production: 01/08/2009 --->
<!--- Module: Add/Modify/Delete Information to Facilities Computer Types --->
<!-- Last modified by John R. Pastori on 01/08/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/computertypes.cfm">
<CFSET CONTENT_UPDATED = "January 08, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - Computer Types</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - Computer Types</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.COMPUTERTYPES.COMPUTERTYPENAME.value == "" || document.COMPUTERTYPES.COMPUTERTYPENAME.value == " ") {
			alertuser (document.COMPUTERTYPES.COMPUTERTYPENAME.name +  ",  A Computer Type Name MUST be entered!");
			document.COMPUTERTYPES.COMPUTERTYPENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.COMPUTERTYPEID.selectedIndex == "0") {
			alertuser ("A Computer Type Name MUST be selected!");
			document.LOOKUP.COMPUTERTYPEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCOMPUTERTYPE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.COMPUTERTYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.COMPUTERTYPES.COMPUTERTYPENAME.focus()">
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

<CFQUERY name="ListComputerTypes" datasource="#application.type#FACILITIES" blockfactor="6">
	SELECT	COMPUTERTYPEID, COMPUTERTYPENAME
	FROM		COMPUTERTYPES
	ORDER BY	COMPUTERTYPENAME
</CFQUERY>

<BR clear="left" />

<!--- 
*************************************************************
* The following code is the ADD Process for Computer Types. *
*************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Facilities - Computer Types</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(COMPUTERTYPEID) AS MAX_ID
		FROM		COMPUTERTYPES
	</CFQUERY>
	<CFSET FORM.COMPUTERTYPEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="COMPUTERTYPEID" secure="NO" value="#FORM.COMPUTERTYPEID#">
	<CFQUERY name="AddComputerTypesID" datasource="#application.type#FACILITIES">
		INSERT INTO	COMPUTERTYPES (COMPUTERTYPEID)
		VALUES		(#val(Cookie.COMPUTERTYPEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Computer Type Key &nbsp; = &nbsp; #FORM.COMPUTERTYPEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/processcomputertypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessComputerTypes" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="COMPUTERTYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processcomputertypes.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="COMPUTERTYPENAME">*Computer Type:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="COMPUTERTYPENAME" id="COMPUTERTYPENAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessComputerTypes" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processcomputertypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessComputerTypes" value="CANCELADD" tabindex="4" /><BR />
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
****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Computer Types. *
****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Facilities - Computer Types</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPCOMPUTERTYPE')>
		<TR>
			<TH align="center">Computer Type Key &nbsp; = &nbsp; #FORM.COMPUTERTYPEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCOMPUTERTYPE')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/computertypes.cfm?PROCESS=#URL.PROCESS#&LOOKUPCOMPUTERTYPE=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="COMPUTERTYPEID">*Computer Type:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="COMPUTERTYPEID" id="COMPUTERTYPEID" size="1" query="ListComputerTypes" value="COMPUTERTYPEID" display="COMPUTERTYPENAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
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
****************************************************************************
* The following code is the Modify and Delete Processes for Computer Types.*
****************************************************************************
 --->

		<CFQUERY name="GetComputerTypes" datasource="#application.type#FACILITIES">
			SELECT	COMPUTERTYPEID, COMPUTERTYPENAME
			FROM		COMPUTERTYPES
			WHERE	COMPUTERTYPEID = <CFQUERYPARAM value="#FORM.COMPUTERTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	COMPUTERTYPEID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/facilities/computertypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessComputerTypes" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="COMPUTERTYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processcomputertypes.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="COMPUTERTYPEID" secure="NO" value="#FORM.COMPUTERTYPEID#">
				<TH align="left"><H4><LABEL for="COMPUTERTYPENAME">*Computer Type Name:</H4></TH>
				<TD align="left"><CFINPUT type="Text" name="COMPUTERTYPENAME" id="COMPUTERTYPENAME" align="LEFT" value="#GetComputerTypes.COMPUTERTYPENAME#" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessComputerTypes" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessComputerTypes" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/computertypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessComputerTypes" value="Cancel" tabindex="5" /><BR />
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