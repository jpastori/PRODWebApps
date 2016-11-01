<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: yearmonth.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/02/2009 --->
<!--- Date in Production: 02/02/2009 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Article DB Year-Month --->
<!-- Last modified by John R. Pastori on 02/02/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/yearmonth.cfm">
<CFSET CONTENT_UPDATED = "February 02, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Article DB Year-Month</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Article DB Year-Month</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Web Reports";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.YEARMONTH.YEARMONTHNAME.value == "") {
			alertuser (document.YEARMONTH.YEARMONTHNAME.name +  ",  A Article DB Year-Month Name MUST be entered!");
			document.YEARMONTH.YEARMONTHNAME.focus();
			return false;
		}

		if (!document.YEARMONTH.YEARMONTHNAME.value.match(/^\d{4}-\d{2}/)) {
			alertuser (document.YEARMONTH.YEARMONTHNAME.name +  ",  A Year-Month in the format YYYY-MM MUST be entered!");
			document.YEARMONTH.YEARMONTHNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.YEARMONTHID.selectedIndex == "0") {
			alertuser ("A Article DB Year-Month Name MUST be selected!");
			document.LOOKUP.YEARMONTHID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPYEARMONTH') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.YEARMONTHID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.YEARMONTH.YEARMONTHNAME.focus()">
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

<CFQUERY name="ListYearMonth" datasource="#application.type#WEBREPORTS" blockfactor="42">
	SELECT	YEARMONTHID, YEARMONTHNAME
	FROM		YEARMONTH
	ORDER BY	YEARMONTHNAME
</CFQUERY>

<BR clear="left" />

<!--- 
********************************************************************
* The following code is the ADD Process for Article DB Year-Month. *
********************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Article DB Year-Month</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
		SELECT	MAX(YEARMONTHID) AS MAX_ID
		FROM		YEARMONTH
	</CFQUERY>
	<CFSET FORM.YEARMONTHID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="YEARMONTHID" secure="NO" value="#FORM.YEARMONTHID#">
	<CFQUERY name="AddYearMonthID" datasource="#application.type#WEBREPORTS">
		INSERT INTO	YEARMONTH (YEARMONTHID)
		VALUES		(#val(Cookie.YEARMONTHID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Article DB Year-Month Key &nbsp; = &nbsp; #FORM.YEARMONTHID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processyearmonth.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessYearMonth" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="YEARMONTH" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processyearmonth.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="YEARMONTHNAME">*Article DB Year-Month Name:</LABEL></H4></TH>
			<TD align="left">
				<CFINPUT type="Text" name="YEARMONTHNAME" id="YEARMONTHNAME" value="" align="LEFT" required="No" size="7" maxlength="7" tabindex="2"><BR />
				(Year-Month Name format is YYYY-MM.)
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessYearMonth" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processyearmonth.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessYearMonth" value="CANCELADD" tabindex="4" /><BR />
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
***********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Article DB Year-Month. *
***********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Web Reports - Article DB Year-Month</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPYEARMONTH')>
		<TR>
			<TH align="center">Article DB Year-Month Key &nbsp; = &nbsp; #FORM.YEARMONTHID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPYEARMONTH')>
		<TABLE width="100%" align="LEFT">
			<TR>
	<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
	</CFFORM>
			</TR>
	<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/yearmonth.cfm?PROCESS=#URL.PROCESS#&LOOKUPYEARMONTH=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="YEARMONTHID">*Article DB Year-Month Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="YEARMONTHID" id="YEARMONTHID" size="1" query="ListYearMonth" value="YEARMONTHID" display="YEARMONTHNAME" required="No" tabindex="2"></CFSELECT>
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
	<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
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
***********************************************************************************
* The following code is the Modify and Delete Processes for Article DB Year-Month.*
***********************************************************************************
 --->

		<CFQUERY name="GetYearMonth" datasource="#application.type#WEBREPORTS">
			SELECT	YEARMONTHID, YEARMONTHNAME
			FROM		YEARMONTH
			WHERE	YEARMONTHID = <CFQUERYPARAM value="#FORM.YEARMONTHID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	YEARMONTHNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/yearmonth.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessYearMonth" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="YEARMONTH" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processyearmonth.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="YEARMONTHID" secure="NO" value="#FORM.YEARMONTHID#">
				<TH align="left"><H4><LABEL for="YEARMONTHNAME">*Article DB Year-Month Name:</LABEL></H4></TH>
				<TD align="left">
					<CFINPUT type="Text" name="YEARMONTHNAME" id="YEARMONTHNAME" value="#GetYearMonth.YEARMONTHNAME#" align="LEFT" required="No" size="7" maxlength="7" tabindex="2"><BR />
					(Year-Month Name format is YYYY-MM.)
				</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessYearMonth" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessYearMonth" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/yearmonth.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessYearMonth" value="Cancel" tabindex="5" /><BR />
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