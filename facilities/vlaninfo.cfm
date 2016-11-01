<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: vlaninfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/07/2015 --->
<!--- Date in Production: 07/07/2015 --->
<!--- Module: Add/Modify/Delete Information to Facilities - VLan Info --->
<!-- Last modified by John R. Pastori on 07/07/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/vlaninfo.cfm">
<CFSET CONTENT_UPDATED = "July 07, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - VLan Info</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - VLan Info</TITLE>
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
		if (document.VLANINFO.VLAN_NUMBER.value == "" || document.VLANINFO.VLAN_NUMBER.value == " ") {
			alertuser (document.VLANINFO.VLAN_NUMBER.name +  ",  A VLan Number MUST be entered!");
			document.VLANINFO.VLAN_NUMBER.focus();
			return false;
		}
		if (document.VLANINFO.VLAN_NAME.value == "" || document.VLANINFO.VLAN_NAME.value == " ") {
			alertuser (document.VLANINFO.VLAN_NAME.name +  ",  A VLan Name MUST be entered!");
			document.VLANINFO.VLAN_NAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.VLANID.selectedIndex == "0") {
			alertuser ("A VLan Number MUST be selected!");
			document.LOOKUP.VLANID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPVLANINFO') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.VLANID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.VLANINFO.VLANNUMBER.focus()">
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

<CFQUERY name="ListVLanInfo" datasource="#application.type#FACILITIES" blockfactor="9">
	SELECT	VLANID, VLAN_NUMBER, VLAN_NAME, VLAN_NUMBER || ' - ' || VLAN_NAME AS VLANKEY
	FROM		VLANINFO
	ORDER BY	VLANID
</CFQUERY>

<BR clear="left" />

<!--- 
********************************************************
* The following code is the ADD Process for VLan Info. *
********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Facilities - VLan Info</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
			SELECT	MAX(VLANID) AS MAX_ID
			FROM		VLANINFO
		</CFQUERY>
		<CFSET FORM.VLANID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="VLANID" secure="NO" value="#FORM.VLANID#">
		<CFQUERY name="AddVLanInfoID" datasource="#application.type#FACILITIES">
			INSERT INTO	VLANINFO (VLANID)
			VALUES		(#val(Cookie.VLANID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				VLan Info Key &nbsp; = &nbsp; #FORM.VLANID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/processvlaninfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessVLanInfo" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="VLANINFO" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processvlaninfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="VLAN_NUMBER">*VLan Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="VLAN_NAME">*VLan Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="VLAN_NUMBER" id="VLAN_NUMBER" value="" align="LEFT" required="No" size="5" maxlength="10" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="VLAN_NAME" id="VLAN_NAME" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessVLanInfo" value="ADD" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processvlaninfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessVLanInfo" value="CANCELADD" tabindex="5" /><BR />
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
***********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting VLan Info. *
***********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Facilities - VLan Info</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPVLANINFO')>
		<TR>
			<TH align="center">VLan Info Key &nbsp; = &nbsp; #FORM.VLANID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />
	
	<CFIF NOT IsDefined('URL.LOOKUPVLANINFO')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/vlaninfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPVLANINFO=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="VLANID">*VLan Number:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="VLANID" id="VLANID" size="1" query="ListVLanInfo" value="VLANID" display="VLANKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" colspan="2"><INPUT type="submit" value="GO" tabindex="3" /></TD>
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
***********************************************************************
* The following code is the Modify and Delete Processes for VLan Info.*
***********************************************************************
 --->

		<CFQUERY name="GetVLanInfo" datasource="#application.type#FACILITIES">
			SELECT	VLANID, VLAN_NUMBER, VLAN_NAME
			FROM		VLANINFO
			WHERE	VLANID = <CFQUERYPARAM value="#FORM.VLANID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	VLANID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/facilities/vlaninfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessVLanInfo" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="VLANINFO" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processvlaninfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="VLANID" secure="NO" value="#FORM.VLANID#">
				<TH align="left"><H4><LABEL for="VLAN_NUMBER">*VLan Number</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="VLAN_NAME">*VLan Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="VLAN_NUMBER" id="VLAN_NUMBER" value="#GetVLanInfo.VLAN_NUMBER#" align="LEFT" required="No" size="5" maxlength="10" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="VLAN_NAME" id="VLAN_NAME" value="#GetVLanInfo.VLAN_NAME#" align="LEFT" required="No" size="50" maxlength="100" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessVLanInfo" value="MODIFY" tabindex="4" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessVLanInfo" value="DELETE" tabindex="5" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/vlaninfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessVLanInfo" value="Cancel" tabindex="6" /><BR />
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