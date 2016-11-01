<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: services.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/23/2008 --->
<!--- Date in Production: 07/23/2008 --->
<!--- Module: Add/Modify/Delete Information to Special Collections - Services --->
<!-- Last modified by John R. Pastori on 07/23/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/services.cfm">
<CFSET CONTENT_UPDATED = "July 23, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Special Collections - Services</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Special Collections - Services</TITLE>
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
		if (document.SERVICES.SERVICENAME.value == "" || document.SERVICES.SERVICENAME.value == " ") {
			alertuser (document.SERVICES.SERVICENAME.name +  ",  A Service Name MUST be entered!");
			document.SERVICES.SERVICENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.SERVICEID.selectedIndex == "0") {
			alertuser ("A Service Name MUST be selected!");
			document.LOOKUP.SERVICEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSERVICES') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SERVICES.SERVICENAME.focus()">
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

<CFQUERY name="ListServices" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
	SELECT	SERVICEID, SERVICENAME
	FROM		SERVICES
	ORDER BY	SERVICENAME
</CFQUERY>

<BR clear="left" />

<!--- 
*******************************************************
* The following code is the ADD Process for Services. *
*******************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Special Collections - Services</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	MAX(SERVICEID) AS MAX_ID
			FROM		SERVICES
		</CFQUERY>
		<CFSET FORM.SERVICEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="SERVICEID" secure="NO" value="#FORM.SERVICEID#">
		<CFQUERY name="AddServiceID" datasource="#application.type#SPECIALCOLLECTIONS">
			INSERT INTO	SERVICES (SERVICEID)
			VALUES		(#val(Cookie.SERVICEID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Service Key &nbsp; = &nbsp; #FORM.SERVICEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processservices.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessServices" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SERVICES" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processservices.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="SERVICENAME">*Service Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="SERVICENAME" id="SERVICENAME" value="" align="LEFT" required="No" size="30" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessServices" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processservices.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessServices" value="CANCELADD" tabindex="4" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Services. *
**********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Special Collections - Services </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPSERVICES')>
		<TR>
			<TH align="center">Service Key &nbsp; = &nbsp; #FORM.SERVICEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPServices')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/specialcollections/services.cfm?PROCESS=#URL.PROCESS#&LOOKUPSERVICES=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="SERVICEID">*Service Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="SERVICEID" id="SERVICEID" size="1" query="ListServices" value="SERVICEID" display="SERVICENAME" required="No" tabindex="2"></CFSELECT>
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
* The following code is the Modify and Delete Processes for Services.*
**********************************************************************
 --->

		<CFQUERY name="GetServices" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	SERVICEID, SERVICENAME
			FROM		SERVICES
			WHERE	SERVICEID = <CFQUERYPARAM value="#FORM.SERVICEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SERVICENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/services.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessServices" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="SERVICES" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processservices.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="SERVICEID" secure="NO" value="#FORM.SERVICEID#">
				<TH align="left"><H4><LABEL for="SERVICENAME">*Service Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="SERVICENAME" id="SERVICENAME" value="#GetServices.SERVICENAME#" align="LEFT" required="No" size="30" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessServices" value="MODIFY" tabindex="3" /></TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessServices" value="DELETE" tabindex="4" /></TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/services.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessServices" value="Cancel" tabindex="5" /><BR />
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