<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: movetypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/31/2008 --->
<!--- Date in Production: 01/31/2008 --->
<!--- Module: Add/Modify/Delete Information to Facilities - Move Types --->
<!-- Last modified by John R. Pastori on 01/31/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/movetypes.cfm">
<CFSET CONTENT_UPDATED = "January 31, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - Move Types</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - Move Types</TITLE>
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
		if (document.MOVETYPES.MOVETYPENAME.value == "" || document.MOVETYPES.MOVETYPENAME.value == " ") {
			alertuser (document.MOVETYPES.MOVETYPENAME.name +  ",  A Move Type Name MUST be entered!");
			document.MOVETYPES.MOVETYPENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.MOVETYPEID.selectedIndex == "0") {
			alertuser ("A Move Type Name MUST be selected!");
			document.LOOKUP.MOVETYPEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPMOVETYPE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.MOVETYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.MOVETYPES.MOVETYPENAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined("URL.PROCESS")>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListMoveTypes" datasource="#application.type#FACILITIES" blockfactor="8">
	SELECT	MOVETYPEID, MOVETYPENAME
	FROM		MOVETYPES
	ORDER BY	MOVETYPENAME
</CFQUERY>

<BR clear="left" />

<!--- 
*********************************************************
* The following code is the ADD Process for Move Types. *
*********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Facilities - Move Types</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(MOVETYPEID) AS MAX_ID
		FROM		MOVETYPES
	</CFQUERY>
	<CFSET FORM.MOVETYPEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="MOVETYPEID" secure="NO" value="#FORM.MOVETYPEID#">
	<CFQUERY name="AddMoveTypesID" datasource="#application.type#FACILITIES">
		INSERT INTO	MOVETYPES (MOVETYPEID)
		VALUES		(#val(Cookie.MOVETYPEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Move Type Key &nbsp; = &nbsp; #FORM.MOVETYPEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/processmovetypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMoveTypes" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MOVETYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processmovetypes.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4>*Move Type Name:</H4></TH>
			<TD align="left"><CFINPUT type="Text" name="MOVETYPENAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessMoveTypes" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processmovetypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMoveTypes" value="CANCELADD" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
	<CFEXIT>

<CFELSE>

<!--- 
*************************************************************************************
* The following code is the Look Up Process for  Modifying and Deleting Move Types. *
*************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Facilities - Move Types</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined("URL.LOOKUPMOVETYPE")>
		<TR>
			<TH align="center">Move Type Key &nbsp; = &nbsp; #FORM.MOVETYPEID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined("URL.LOOKUPMOVETYPE")>
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/movetypes.cfm?PROCESS=#URL.PROCESS#&LOOKUPMOVETYPE=FOUND" method="POST">
		<TR>
			<TH align="left"><H4>*Move Type Name:</H4></TH>
			<TD align="left">
				<CFSELECT name="MOVETYPEID" size="1" query="ListMoveTypes" value="MOVETYPEID" display="MOVETYPENAME" required="No" tabindex="2"></CFSELECT>
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
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	<CFELSE>

<!--- 
************************************************************************
* The following code is the Modify and Delete Processes for Move Types.*
************************************************************************
 --->

		<CFQUERY name="GetMoveTypes" datasource="#application.type#FACILITIES">
			SELECT	MOVETYPEID, MOVETYPENAME
			FROM		MOVETYPES
			WHERE	MOVETYPEID = <CFQUERYPARAM value="#FORM.MOVETYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	MOVETYPEID
		</CFQUERY>

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/movetypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMoveTypes" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MOVETYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processmovetypes.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<CFCOOKIE name="MOVETYPEID" secure="NO" value="#FORM.MOVETYPEID#">
			<TH align="left" width="30%"><H4>*Move Type Name:</H4></TH>
			<TD align="left" width="70%"><CFINPUT type="Text" name="MOVETYPENAME" value="#GetMoveTypes.MOVETYPENAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessMoveTypes" value="MODIFY" tabindex="3" /></TD>
		</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessMoveTypes" value="DELETE" tabindex="4" /></TD>
		</TR>
		</CFIF>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/movetypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMoveTypes" value="Cancel" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>