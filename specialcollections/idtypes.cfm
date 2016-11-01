<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idtypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/23/2008 --->
<!--- Date in Production: 07/23/2008 --->
<!--- Module: Add/Modify/Delete Information to Special Collections - ID Types --->
<!-- Last modified by John R. Pastori on 07/23/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/idtypes.cfm">
<CFSET CONTENT_UPDATED = "July 23, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Special Collections - ID Types</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Special Collections - ID Types</TITLE>
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
		if (document.IDTYPES.IDTYPENAME.value == "" || document.IDTYPES.IDTYPENAME.value == " ") {
			alertuser (document.IDTYPES.IDTYPENAME.name +  ",  An ID Type Name MUST be entered!");
			document.IDTYPES.IDTYPENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.IDTYPEID.selectedIndex == "0") {
			alertuser ("An ID Type Name MUST be selected!");
			document.LOOKUP.IDTYPEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPIDTYPES') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.IDTYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.IDTYPES.IDTYPENAME.focus()">
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

<CFQUERY name="ListIDTypes" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="12">
	SELECT	IDTYPEID, IDTYPENAME
	FROM		IDTYPES
	ORDER BY	IDTYPENAME
</CFQUERY>

<BR clear="left" />

<!--- 
*******************************************************
* The following code is the ADD Process for ID Types. *
*******************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Special Collections - ID Types</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	MAX(IDTYPEID) AS MAX_ID
			FROM		IDTYPES
		</CFQUERY>
		<CFSET FORM.IDTYPEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="IDTYPEID" secure="NO" value="#FORM.IDTYPEID#">
		<CFQUERY name="AddIDTypeID" datasource="#application.type#SPECIALCOLLECTIONS">
			INSERT INTO	IDTYPES (IDTYPEID)
			VALUES		(#val(Cookie.IDTYPEID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				IDType Key &nbsp; = &nbsp; #FORM.IDTYPEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processidtypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessIDTypes" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="IDTYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processidtypes.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="IDTYPENAME">*ID Type Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="IDTYPENAME" id="IDTYPENAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessIDTypes" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processidtypes.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessIDTypes" value="CANCELADD" tabindex="4" /><BR />
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
**********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting ID Types. *
**********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Special Collections - ID Types </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPIDTYPES')>
		<TR>
			<TH align="center">IDType Key &nbsp; = &nbsp; #FORM.IDTYPEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPIDTypes')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/specialcollections/idtypes.cfm?PROCESS=#URL.PROCESS#&LOOKUPIDTYPES=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="IDTYPEID">*ID Type Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="IDTYPEID" id="IDTYPEID" size="1" query="ListIDTypes" value="IDTYPEID" display="IDTYPENAME" required="No" tabindex="2"></CFSELECT>
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
**********************************************************************
* The following code is the Modify and Delete Processes for ID Types.*
**********************************************************************
 --->

		<CFQUERY name="GetIDTypes" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	IDTYPEID, IDTYPENAME
			FROM		IDTYPES
			WHERE	IDTYPEID = <CFQUERYPARAM value="#FORM.IDTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	IDTYPENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/idtypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessIDTypes" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="IDTYPES" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processidtypes.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="IDTYPEID" secure="NO" value="#FORM.IDTYPEID#">
				<TH align="left"><H4><LABEL for="IDTYPENAME">*ID Type Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="IDTYPENAME" id="IDTYPENAME" value="#GetIDTypes.IDTYPENAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessIDTypes" value="MODIFY" tabindex="3" /></TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessIDTypes" value="DELETE" tabindex="4" /></TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/idtypes.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessIDTypes" value="Cancel" tabindex="5" /><BR />
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