<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqsubgroups.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Add/Modify/Delete Information to LibQual - LibQual SubGroups --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqsubgroups.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to LibQual - LibQual SubGroups</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to LibQual - LibQual SubGroups</TITLE>
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

		if (document.LIBQUALSUBGROUPS.LQGROUPNAMEID.selectedIndex == 0 ) {
			alertuser (document.LIBQUALSUBGROUPS.LQGROUPNAMEID.name +  ",  A LibQual Group Name MUST be entered!");
			document.LIBQUALSUBGROUPS.LQGROUPNAMEID.focus();
			return false;
		}

		if (document.LIBQUALSUBGROUPS.SUBGROUPFIELDNAME.value == "" || document.LIBQUALSUBGROUPS.SUBGROUPFIELDNAME.value == " ") {
			alertuser (document.LIBQUALSUBGROUPS.SUBGROUPFIELDNAME.name +  ",  A SubGroup Field Name MUST be entered!");
			document.LIBQUALSUBGROUPS.SUBGROUPFIELDNAME.focus();
			return false;
		}

		if (document.LIBQUALSUBGROUPS.SUBGROUPNAME.value == "" || document.LIBQUALSUBGROUPS.SUBGROUPNAME.value == " ") {
			alertuser (document.LIBQUALSUBGROUPS.SUBGROUPNAME.name +  ",  A SubGroup Name MUST be entered!");
			document.LIBQUALSUBGROUPS.SUBGROUPNAME.focus();
			return false;
		}

	}

	function validateLookupField() {
		if (document.LOOKUP.LQSUBGROUPID.selectedIndex == 0) {
			alertuser ("A SubGroup Name MUST be selected!");
			document.LOOKUP.LQSUBGROUPID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPLQSUBGROUPID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.LQSUBGROUPID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.LIBQUALSUBGROUPS.SUBGROUPFIELDNAME.focus()">
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

<CFQUERY name="ListLQSubGroups" datasource="#application.type#LIBQUAL" blockfactor="58">
	SELECT	LQSG.LQSUBGROUPID, LQSG.LQGROUPNAMEID, LQG.GROUPNAME, LQSG.SUBGROUPFIELDNAME, LQSG.SUBGROUPNAME,
			LQG.GROUPNAME || ' - ' || LQSG.SUBGROUPNAME AS LOOKUPKEY
	FROM		LQSUBGROUPS LQSG, LQGROUPS LQG
	WHERE	LQSG.LQGROUPNAMEID = LQG.LQGROUPID
	ORDER BY	LOOKUPKEY
</CFQUERY>

<BR clear="left" />

<!--- 
****************************************************************
* The following code is the ADD Process for LibQual SubGroups. *
****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to LibQual - LibQual SubGroups</H1></TD>
		</TR>
	</TABLE>
	
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBQUAL">
		SELECT	MAX(LQSUBGROUPID) AS MAX_ID
		FROM		LQSUBGROUPS
	</CFQUERY>
	<CFSET FORM.LQSUBGROUPID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="LQSUBGROUPID" secure="NO" value="#FORM.LQSUBGROUPID#">
	<CFQUERY name="AddLQGroupID" datasource="#application.type#LIBQUAL">
		INSERT INTO	LQSUBGROUPS (LQSUBGROUPID)
		VALUES		(#val(Cookie.LQSUBGROUPID)#)
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				LQSubGroups Key &nbsp; = &nbsp; #FORM.LQSUBGROUPID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libqual/processlqsubgroups.cfm" method="POST">
			<TD align="left" colspan="3">
				<INPUT type="submit" name="ProcessLQSubGroups" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LIBQUALSUBGROUPS" onsubmit="return validateReqFields();" action="/#application.type#apps/libqual/processlqsubgroups.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4>*LibQual Group Name</H4></TH>
			<TH align="left"><H4>*SubGroup Field Name</H4></TH>
			<TH align="left" valign ="bottom"><H4>*SubGroup Name</H4></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="LQGROUPNAMEID" size="1" query="ListLQGroups" value="LQGROUPID" display="GROUPNAME" selected="0" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left"><CFINPUT type="Text" name="SUBGROUPFIELDNAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
			<TD align="left"><CFINPUT type="Text" name="SUBGROUPNAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="4"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessLQSubGroups" value="ADD" tabindex="5" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libqual/processlqsubgroups.cfm" method="POST">
			<TD align="left" colspan="3">
				<INPUT type="submit" name="ProcessLQSubGroups" value="CANCELADD" tabindex="6" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="3">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting LibQual SubGroups. *
*******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to LibQual - LibQual SubGroups</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPLQSUBGROUPID')>
		<TR>
			<TH align="center">LQSubGroups Key &nbsp; = &nbsp; #FORM.LQSUBGROUPID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPLQSUBGROUPID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libqual/lqsubgroups.cfm?PROCESS=#URL.PROCESS#&LOOKUPLQSUBGROUPID=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4>*Group Name - SubGroup Name:</H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="LQSUBGROUPID" size="1" query="ListLQSubGroups" value="LQSUBGROUPID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
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
********************************************************************************
* The following code is the Modify and Delete Processes for LibQual SubGroups. *
********************************************************************************
 --->

		<CFQUERY name="GetLQSubGroups" datasource="#application.type#LIBQUAL">
			SELECT	LQSUBGROUPID, LQGROUPNAMEID, SUBGROUPFIELDNAME, SUBGROUPNAME
			FROM		LQSUBGROUPS
			WHERE	LQSUBGROUPID = <CFQUERYPARAM value="#FORM.LQSUBGROUPID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SUBGROUPNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libqual/lqsubgroups.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="3">
					<INPUT type="submit" name="ProcessLQSubGroups" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LIBQUALSUBGROUPS" onsubmit="return validateReqFields();" action="/#application.type#apps/libqual/processlqsubgroups.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="LQSUBGROUPID" secure="NO" value="#FORM.LQSUBGROUPID#">
				<TH align="left"><H4>*LibQual Group Name</H4></TH>
				<TH align="left"><H4>*SubGroup Field Name</H4></TH>
				<TH align="left" valign ="bottom"><H4>*SubGroup Name</H4></TH>
			</TR>
			<TR>
				<TD align="LEFT">
					<CFSELECT name="LQGROUPNAMEID" size="1" query="ListLQGroups" value="LQGROUPID" display="GROUPNAME" selected="#GetLQSubGroups.LQGROUPNAMEID#" required="No" tabindex="2"></CFSELECT>
				</TD>
				<TD align="left"><CFINPUT type="Text" name="SUBGROUPFIELDNAME" value="#GetLQSubGroups.SUBGROUPFIELDNAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
				<TD align="left"><CFINPUT type="Text" name="SUBGROUPNAME" value="#GetLQSubGroups.SUBGROUPNAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="4"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessLQSubGroups" value="MODIFY" tabindex="5" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessLQSubGroups" value="DELETE" tabindex="6" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libqual/lqsubgroups.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="3">
					<INPUT type="submit" name="ProcessLQSubGroups" value="Cancel" tabindex="7" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="3">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>