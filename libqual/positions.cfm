<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: positions.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Add/Modify/Delete Information to LibQual - Positions --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/positions.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to LibQual - Positions</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to LibQual - Positions</TITLE>
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

		if (document.POSITION.POSITIONNAME.value == "" || document.POSITION.POSITIONNAME.value == " ") {
			alertuser (document.POSITION.POSITIONNAME.name +  ",  A Position Name MUST be entered!");
			document.POSITION.POSITIONNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.POSITIONID.selectedIndex == "0") {
			alertuser ("A Position Name MUST be selected!");
			document.LOOKUP.POSITIONID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPOSITIONID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.POSITIONID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.POSITION.LIBQUALPOSITIONID.focus()">
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


<CFQUERY name="ListPositions" datasource="#application.type#LIBQUAL" blockfactor="6">
	SELECT	POSITIONID, LIBQUALPOSITIONID, POSITIONNAME, LIBQUALPOSITIONID || ' - ' || POSITIONNAME AS POSITIONCODENAME
	FROM		LQPOSITIONS
	ORDER BY	LIBQUALPOSITIONID
</CFQUERY>

<BR clear="left" />

<!--- 
********************************************************
* The following code is the ADD Process for Positions. *
********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to LibQual - Positions</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBQUAL">
			SELECT	MAX(POSITIONID) AS MAX_ID
			FROM		LQPOSITIONS
		</CFQUERY>
		<CFSET FORM.POSITIONID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="POSITIONID" secure="NO" value="#FORM.POSITIONID#">
		<CFQUERY name="AddPositionsID" datasource="#application.type#LIBQUAL">
			INSERT INTO	LQPOSITIONS (POSITIONID)
			VALUES		(#val(Cookie.POSITIONID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Positions Key &nbsp; = &nbsp; #FORM.POSITIONID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libqual/processpositions.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessPositions" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="POSITION" onsubmit="return validateReqFields();" action="/#application.type#apps/libqual/processpositions.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">LIBQUALPositionsID</TH>
			<TH align="left" valign ="bottom"><H4>*Positions Name</H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="LIBQUALPOSITIONID" value="" align="LEFT" required="No" size="6" maxlength="6" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="POSITIONNAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessPositions" value="ADD" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libqual/processpositions.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessPositions" value="CANCELADD" tabindex="5" /><BR />
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
***********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Positions. *
***********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to LibQual - Positions</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPPOSITIONID')>
		<TR>
			<TH align="center">Positions Key &nbsp; = &nbsp; #FORM.POSITIONID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPOSITIONID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libqual/positions.cfm?PROCESS=#URL.PROCESS#&LOOKUPPOSITIONID=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4>*Positions Name:</H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="POSITIONID" size="1" query="ListPositions" value="POSITIONID" display="POSITIONNAME" required="No" tabindex="2"></CFSELECT>
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
<CFEXIT>

	<CFELSE>

<!--- 
************************************************************************
* The following code is the Modify and Delete Processes for Positions. *
************************************************************************
 --->

		<CFQUERY name="GetPositions" datasource="#application.type#LIBQUAL">
			SELECT	POSITIONID, LIBQUALPOSITIONID, POSITIONNAME
			FROM		LQPOSITIONS
			WHERE	POSITIONID = <CFQUERYPARAM value="#FORM.POSITIONID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	LIBQUALPOSITIONID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libqual/positions.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessPositions" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="POSITION" onsubmit="return validateReqFields();" action="/#application.type#apps/libqual/processpositions.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="POSITIONID" secure="NO" value="#FORM.POSITIONID#">
				<TH align="left">LIBQUALPositionsID</TH>
				<TH align="left" valign ="bottom"><H4>*Positions Name</H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="LIBQUALPOSITIONID" value="#GetPositions.LIBQUALPOSITIONID#" align="LEFT" required="No" size="2" maxlength="2" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="POSITIONNAME" value="#GetPositions.POSITIONNAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessPositions" value="MODIFY" tabindex="4" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessPositions" value="DELETE" tabindex="5" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libqual/positions.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessPositions" value="Cancel" tabindex="6" /><BR />
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