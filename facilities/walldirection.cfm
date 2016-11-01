<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: walldirection.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/19/2010 --->
<!--- Date in Production: 01/19/2010 --->
<!--- Module: Add/Modify/Delete Information to Facilities Wall Direction --->
<!-- Last modified by John R. Pastori on 01/19/2010 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/walldirection.cfm">
<CFSET CONTENT_UPDATED = "January 19, 2010">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - Wall Direction</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - Wall Direction</TITLE>
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
		if (document.WALLDIRECTION.WALLDIRNAME.value == "" || document.WALLDIRECTION.WALLDIRNAME.value == " ") {
			alertuser (document.WALLDIRECTION.WALLDIRNAME.name +  ",  A Wall Direction Name MUST be entered!");
			document.WALLDIRECTION.WALLDIRNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.WALLDIRID.selectedIndex == "0") {
			alertuser ("A Wall Direction Name MUST be selected!");
			document.LOOKUP.WALLDIRID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPWALLDIR') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.WALLDIRID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.WALLDIRECTION.WALLDIRNAME.focus()">
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

<CFQUERY name="ListWallDirection" datasource="#application.type#FACILITIES" blockfactor="6">
	SELECT	WALLDIRID, WALLDIRNAME
	FROM		WALLDIRECTION
	ORDER BY	WALLDIRNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*************************************************************
* The following code is the ADD Process for Wall Direction. *
*************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Facilities - Wall Direction</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(WALLDIRID) AS MAX_ID
		FROM		WALLDIRECTION
	</CFQUERY>
	<CFSET FORM.WALLDIRID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="WALLDIRID" secure="NO" value="#FORM.WALLDIRID#">
	<CFQUERY name="AddWallDirectionID" datasource="#application.type#FACILITIES">
		INSERT INTO	WALLDIRECTION (WALLDIRID)
		VALUES		(#val(Cookie.WALLDIRID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Wall Direction Key &nbsp; = &nbsp; #FORM.WALLDIRID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/processwalldirection.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessWallDirection" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="WALLDIRECTION" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processwalldirection.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="WALLDIRNAME">*Wall Direction Name:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="WALLDIRNAME" id="WALLDIRNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessWallDirection" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processwalldirection.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessWallDirection" value="CANCELADD" tabindex="4" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Wall Direction. *
****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Facilities - Wall Direction</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPWALLDIR')>
		<TR>
			<TH align="center">Wall Direction Key &nbsp; = &nbsp; #FORM.WALLDIRID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPWALLDIR')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/walldirection.cfm?PROCESS=#URL.PROCESS#&LOOKUPWALLDIR=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="WALLDIRID">*Wall Direction:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="WALLDIRID" id="WALLDIRID" size="1" query="ListWallDirection" value="WALLDIRID" display="WALLDIRNAME" required="No" tabindex="2"></CFSELECT>
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
* The following code is the Modify and Delete Processes for Wall Direction.*
****************************************************************************
 --->

		<CFQUERY name="GetWallDirection" datasource="#application.type#FACILITIES">
			SELECT	WALLDIRID, WALLDIRNAME
			FROM		WALLDIRECTION
			WHERE	WALLDIRID = <CFQUERYPARAM value="#FORM.WALLDIRID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	WALLDIRID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/facilities/walldirection.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessWallDirection" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="WALLDIRECTION" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processwalldirection.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="WALLDIRID" secure="NO" value="#FORM.WALLDIRID#">
				<TH align="left"><H4><LABEL for="WALLDIRNAME">*Wall Direction Name:</H4></TH>
				<TD align="left"><CFINPUT type="Text" name="WALLDIRNAME" id="WALLDIRNAME" align="LEFT" value="#GetWallDirection.WALLDIRNAME#" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessWallDirection" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessWallDirection" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/walldirection.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessWallDirection" value="Cancel" tabindex="5" /><BR />
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