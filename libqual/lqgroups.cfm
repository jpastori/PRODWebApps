<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqgroups.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Add/Modify/Delete Information to LibQual - LibQual Groups --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqgroups.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to LibQual - LibQual Groups</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to LibQual - LibQual Groups</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Library LibQual Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {

		if (document.LIBQUALGROUPS.GROUPFIELDNAME.value == "" || document.LIBQUALGROUPS.GROUPFIELDNAME.value == " ") {
			alertuser (document.LIBQUALGROUPS.GROUPFIELDNAME.name +  ",  A Group Field Name MUST be entered!");
			document.LIBQUALGROUPS.GROUPFIELDNAME.focus();
			return false;
		}

		if (document.LIBQUALGROUPS.GROUPNAME.value == "" || document.LIBQUALGROUPS.GROUPNAME.value == " ") {
			alertuser (document.LIBQUALGROUPS.GROUPNAME.name +  ",  A Group Name MUST be entered!");
			document.LIBQUALGROUPS.GROUPNAME.focus();
			return false;
		}

	}

	function validateLookupField() {
		if (document.LOOKUP.LQGROUPID.selectedIndex == 0) {
			alertuser ("A Group Name MUST be selected!");
			document.LOOKUP.LQGROUPID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPLQGROUPID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.LQGROUPID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.LIBQUALGROUPS.GROUPFIELDNAME.focus()">
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

<CFQUERY name="ListLQGroups" datasource="#application.type#LIBQUAL" blockfactor="7">
	SELECT	LQGROUPID, GROUPFIELDNAME, GROUPNAME
	FROM		LQGROUPS
	ORDER BY	GROUPNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*************************************************************
* The following code is the ADD Process for LibQual Groups. *
*************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to LibQual - LibQual Groups</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBQUAL">
		SELECT	MAX(LQGROUPID) AS MAX_ID
		FROM		LQGROUPS
	</CFQUERY>
	<CFSET FORM.LQGROUPID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="LQGROUPID" secure="NO" value="#FORM.LQGROUPID#">
	<CFQUERY name="AddLQGroupID" datasource="#application.type#LIBQUAL">
		INSERT INTO	LQGROUPS (LQGROUPID)
		VALUES		(#val(Cookie.LQGROUPID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				LQGroups Key &nbsp; = &nbsp; #FORM.LQGROUPID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libqual/processlqgroups.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessLQGroups" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LIBQUALGROUPS" onsubmit="return validateReqFields();" action="/#application.type#apps/libqual/processlqgroups.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4>*Group Field Name</H4></TH>
			<TH align="left" valign ="bottom"><H4>*Group Name</H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="GROUPFIELDNAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="GROUPNAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessLQGroups" value="ADD" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libqual/processlqgroups.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessLQGroups" value="CANCELADD" tabindex="5" /><BR />
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
****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting LibQual Groups. *
****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to LibQual - LQGroups</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined("URL.LOOKUPLQGROUPID")>
		<TR>
			<TH align="center">LQGroups Key &nbsp; = &nbsp; #FORM.LQGROUPID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPLQGROUPID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libqual/lqgroups.cfm?PROCESS=#URL.PROCESS#&LOOKUPLQGROUPID=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4>*Group Name:</H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="LQGROUPID" size="1" query="ListLQGroups" value="LQGROUPID" display="GROUPNAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
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
*****************************************************************************
* The following code is the Modify and Delete Processes for LibQual Groups. *
*****************************************************************************
 --->

		<CFQUERY name="GetLQGroups" datasource="#application.type#LIBQUAL">
			SELECT	LQGROUPID, GROUPFIELDNAME, GROUPNAME
			FROM		LQGROUPS
			WHERE	LQGROUPID = <CFQUERYPARAM value="#FORM.LQGROUPID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	GROUPNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libqual/lqgroups.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessLQGroups" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LIBQUALGROUPS" onsubmit="return validateReqFields();" action="/#application.type#apps/libqual/processlqgroups.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="LQGROUPID" secure="NO" value="#FORM.LQGROUPID#">
				<TH align="left"><H4>*Group Field Name</H4></TH>
				<TH align="left" valign ="bottom"><H4>*Group Name</H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="GROUPFIELDNAME" value="#GetLQGroups.GROUPFIELDNAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="GROUPNAME" value="#GetLQGroups.GROUPNAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessLQGroups" value="MODIFY" tabindex="4" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessLQGroups" value="DELETE" tabindex="5" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libqual/lqgroups.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessLQGroups" value="Cancel" tabindex="6" /><BR />
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