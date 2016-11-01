<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: buildingnames.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/12/2012 --->
<!--- Date in Production: 01/12/2012 --->
<!--- Module: Add/Modify/Delete Information to Facilities - Building Names --->
<!-- Last modified by John R. Pastori on 01/12/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/buildingnames.cfm">
<CFSET CONTENT_UPDATED = "January 12, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - Building Names</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - Building Names</TITLE>
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
		if (document.BUILDINGNAMES.BUILDINGNAME.value == "" || document.BUILDINGNAMES.BUILDINGNAME.value == " ") {
			alertuser (document.BUILDINGNAMES.BUILDINGNAME.name +  ",  A Building Name MUST be entered!");
			document.BUILDINGNAMES.BUILDINGNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.BUILDINGNAMEID.selectedIndex == "0") {
			alertuser ("A Building Name MUST be selected!");
			document.LOOKUP.BUILDINGNAMEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPBUILDINGNAME') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.BUILDINGNAMEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.BUILDINGNAMES.BUILDINGNAME.focus()">
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

<CFQUERY name="ListBuildingNames" datasource="#application.type#FACILITIES" blockfactor="15">
	SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGABBREV, BUILDINGCODE || ' -- ' || BUILDINGNAME AS BUIDINGCODENAME
	FROM		BUILDINGNAMES
	ORDER BY	BUILDINGNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*************************************************************
* The following code is the ADD Process for Building Names. *
*************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Facilities - Building Names</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
			SELECT	MAX(BUILDINGNAMEID) AS MAX_ID
			FROM		BUILDINGNAMES
		</CFQUERY>
		<CFSET FORM.BUILDINGNAMEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="BUILDINGNAMEID" secure="NO" value="#FORM.BUILDINGNAMEID#">
		<CFQUERY name="AddBuildingNamesID" datasource="#application.type#FACILITIES">
			INSERT INTO	BUILDINGNAMES (BUILDINGNAMEID)
			VALUES		(#val(Cookie.BUILDINGNAMEID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Building Name Key &nbsp; = &nbsp; #FORM.BUILDINGNAMEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/processbuildingnames.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessBuildingNames" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="BUILDINGNAMES" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processbuildingnames.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="BUILDINGNAME">*Building Name</LABEL></H4></TH>
			<TH align="left"><LABEL for="BUILDINGCODE">Building Code</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="BUILDINGNAME" id="BUILDINGNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="BUILDINGCODE" id="BUILDINGCODE" value="" align="LEFT" required="No" size="7" maxlength="7" tabindex="3"></TD>
		</TR>
          <TR>
			<TH align="left"><LABEL for="BUILDINGABBREV">Building Abbreviation</LABEL></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
          <TR>
			<TD align="left"><CFINPUT type="Text" name="BUILDINGABBREV" id="BUILDINGABBREV" value="" align="LEFT" required="No" size="5" maxlength="4" tabindex="4"></TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessBuildingNames" value="ADD" tabindex="5" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processbuildingnames.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessBuildingNames" value="CANCELADD" tabindex="6" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Building Names. *
****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Facilities - Building Names</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPBUILDINGNAME')>
		<TR>
			<TH align="center">Building Name Key &nbsp; = &nbsp; #FORM.BUILDINGNAMEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />
	
	<CFIF NOT IsDefined('URL.LOOKUPBUILDINGNAME')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/buildingnames.cfm?PROCESS=#URL.PROCESS#&LOOKUPBUILDINGNAME=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="BUILDINGNAMEID">*Building Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="ListBuildingNames" value="BUILDINGNAMEID" display="BUIDINGCODENAME" required="No" tabindex="2"></CFSELECT>
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
****************************************************************************
* The following code is the Modify and Delete Processes for Building Names.*
****************************************************************************
 --->

		<CFQUERY name="GetBuildingNames" datasource="#application.type#FACILITIES">
			SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGABBREV 
			FROM		BUILDINGNAMES
			WHERE	BUILDINGNAMEID = <CFQUERYPARAM value="#FORM.BUILDINGNAMEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	BUILDINGNAMEID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/facilities/buildingnames.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessBuildingNames" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="BUILDINGNAMES" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processbuildingnames.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="BUILDINGNAMEID" secure="NO" value="#FORM.BUILDINGNAMEID#">
				<TH align="left"><H4><LABEL for="BUILDINGNAME">*Building Name</LABEL></H4></TH>
				<TH align="left"><LABEL for="BUILDINGCODE">Building Code</LABEL></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="BUILDINGNAME" id="BUILDINGNAME" value="#GetBuildingNames.BUILDINGNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="BUILDINGCODE" id="BUILDINGCODE" value="#GetBuildingNames.BUILDINGCODE#" align="LEFT" required="No" size="7" maxlength="7" tabindex="3"></TD>
			</TR>
               <TR>
                    <TH align="left"><LABEL for="BUILDINGABBREV">Building Abbreviation</LABEL></TH>
                    <TH align="left">&nbsp;&nbsp;</TH>
               </TR>
               <TR>
                    <TD align="left"><CFINPUT type="Text" name="BUILDINGABBREV" id="BUILDINGABBREV" value="#GetBuildingNames.BUILDINGABBREV#" align="LEFT" required="No" size="5" maxlength="4" tabindex="4"></TD>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessBuildingNames" value="MODIFY" tabindex="5" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessBuildingNames" value="DELETE" tabindex="6" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/buildingnames.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessBuildingNames" value="Cancel" tabindex="7" /><BR />
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