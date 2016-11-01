<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: locationdescription.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/08/2009 --->
<!--- Date in Production: 01/08/2009 --->
<!--- Module: Add/Modify/Delete Information to Facilities - Location Description --->
<!-- Last modified by John R. Pastori on 01/08/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/locationdescription.cfm">
<CFSET CONTENT_UPDATED = "January 08, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - Location Description</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - Location Description</TITLE>
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
		if (document.LOCATIONDESCRIPTIONS.LOCATIONDESCRIPTION.value == "" || document.LOCATIONDESCRIPTIONS.LOCATIONDESCRIPTION.value == " ") {
			alertuser (document.LOCATIONDESCRIPTIONS.LOCATIONDESCRIPTION.name +  ",  A Location Description MUST be entered!");
			document.LOCATIONDESCRIPTIONS.LOCATIONDESCRIPTION.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.LOCATIONDESCRIPTIONID.selectedIndex == "0") {
			alertuser ("A Location Description MUST be selected!");
			document.LOOKUP.LOCATIONDESCRIPTIONID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPLOCATIONDESCRIPTION') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.LOCATIONDESCRIPTIONID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.LOCATIONDESCRIPTIONS.LOCATIONDESCRIPTION.focus()">
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

<CFQUERY name="ListLocationDescription" datasource="#application.type#FACILITIES" blockfactor="56">
	SELECT	LOCATIONDESCRIPTIONID, LOCATIONDESCRIPTION
	FROM		LOCATIONDESCRIPTION
	ORDER BY	LOCATIONDESCRIPTION
</CFQUERY>

<BR clear="left" />

<!--- 
*******************************************************************
* The following code is the ADD Process for Location Description. *
*******************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Add Information to Facilities - Location Description</H1></TD>
	</TR>
</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(LOCATIONDESCRIPTIONID) AS MAX_ID
		FROM		LOCATIONDESCRIPTION
	</CFQUERY>
	<CFSET FORM.LOCATIONDESCRIPTIONID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="LOCATIONDESCRIPTIONID" secure="NO" value="#FORM.LOCATIONDESCRIPTIONID#">
	<CFQUERY name="AddLocationDescriptionID" datasource="#application.type#FACILITIES">
		INSERT INTO	LOCATIONDESCRIPTION (LOCATIONDESCRIPTIONID)
		VALUES		(#val(Cookie.LOCATIONDESCRIPTIONID)#)
	</CFQUERY>

<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center">
			<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
			Location Description Key &nbsp; = &nbsp; #FORM.LOCATIONDESCRIPTIONID#
		</TH>
	</TR>
</TABLE>
<BR clear = "left" />
	
<TABLE align="left" width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/facilities/processlocationdescription.cfm" method="POST">
		<TD align="left" colspan="2">
			<INPUT type="submit" name="ProcessLocationDescription" value="CANCELADD" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
<CFFORM name="LOCATIONDESCRIPTIONS" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processlocationdescription.cfm" method="POST" ENABLECAB="Yes">
	<TR>
		<TH align="left"><H4><LABEL for="LOCATIONDESCRIPTION">*Location Description:</label></H4></TH>
		<TD align="left"><CFINPUT type="Text" name="LOCATIONDESCRIPTION" id="LOCATIONDESCRIPTION" value="" align="LEFT" required="No" size="100" maxlength="200" tabindex="2"></TD>
	</TR>
	<TR>
		<TD align="left"><INPUT type="submit" name="ProcessLocationDescription" value="ADD" tabindex="3" /></TD>
	</TR>
</CFFORM>
	<TR>
<CFFORM action="/#application.type#apps/facilities/processlocationdescription.cfm" method="POST">
		<TD align="left" colspan="2">
			<INPUT type="submit" name="ProcessLocationDescription" value="CANCELADD" tabindex="4" /><BR />
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
**********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Location Description. *
**********************************************************************************************
 --->

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Modify/Delete Information to Facilities - Location Description</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
	</TR>
	<CFIF IsDefined("URL.LOOKUPLOCATIONDESCRIPTION")>
	<TR>
		<TH align="center">Location Description Key &nbsp; = &nbsp; #FORM.LOCATIONDESCRIPTIONID#</TH>
	</TR>
	</CFIF>
</TABLE>
<BR clear = "left" />

	<CFIF NOT IsDefined("URL.LOOKUPLOCATIONDESCRIPTION")>
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/locationdescription.cfm?PROCESS=#URL.PROCESS#&LOOKUPLOCATIONDESCRIPTION=FOUND" method="POST">
		<TR>
			<TH align="left" width="30%"><H4><LABEL for="LOCATIONDESCRIPTIONID">*Location Description:</label></H4></TH>
			<TD align="left" width="70%">
				<CFSELECT name="LOCATIONDESCRIPTIONID" id="LOCATIONDESCRIPTIONID" size="1" query="ListLocationDescription" value="LOCATIONDESCRIPTIONID" display="LOCATIONDESCRIPTION" required="No" tabindex="2"></CFSELECT>
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
**********************************************************************************
* The following code is the Modify and Delete Processes for Location Description.*
**********************************************************************************
 --->

		<CFQUERY name="GetLocationDescription" datasource="#application.type#FACILITIES">
			SELECT	LOCATIONDESCRIPTIONID, LOCATIONDESCRIPTION
			FROM		LOCATIONDESCRIPTION
			WHERE	LOCATIONDESCRIPTIONID = <CFQUERYPARAM value="#FORM.LOCATIONDESCRIPTIONID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	LOCATIONDESCRIPTIONID
		</CFQUERY>

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/locationdescription.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessLocationDescription" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOCATIONDESCRIPTIONS" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processlocationdescription.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<CFCOOKIE name="LOCATIONDESCRIPTIONID" secure="NO" value="#FORM.LOCATIONDESCRIPTIONID#">
			<TH align="left"><H4><LABEL for="LOCATIONDESCRIPTION">*Location Description:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="LOCATIONDESCRIPTION" id="LOCATIONDESCRIPTION" value="#GetLocationDescription.LOCATIONDESCRIPTION#" required="No" size="100" maxlength="200" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessLocationDescription" value="MODIFY" tabindex="3" /></TD>
		</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessLocationDescription" value="DELETE" tabindex="4" /></TD>
		</TR>
		</CFIF>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/locationdescription.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessLocationDescription" value="Cancel" tabindex="5" /><BR />
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