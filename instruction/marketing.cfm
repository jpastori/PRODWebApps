<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: marketing.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/28/2009 --->
<!--- Date in Production: 01/28/2009 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Marketing --->
<!-- Last modified by John R. Pastori on 01/28/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/marketing.cfm">
<CFSET CONTENT_UPDATED = "January 28, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Marketing</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Marketing</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Instruction - Orientation Statistics";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.MARKETING.MARKETINGTYPE.value == "" || document.MARKETING.MARKETINGTYPE.value == " ") {
			alertuser (document.MARKETING.MARKETINGTYPE.name +  ",  A Marketing Type MUST be entered!");
			document.MARKETING.MARKETINGTYPE.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.MARKETINGID.selectedIndex == "0") {
			alertuser ("A Marketing Type MUST be selected!");
			document.LOOKUP.MARKETINGID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPMARKETINGS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.MARKETINGID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.MARKETING.MARKETINGTYPE.focus()">
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

<CFQUERY name="ListMarketing" datasource="#application.type#INSTRUCTION" blockfactor="5">
	SELECT	MARKETINGID, MARKETINGTYPE
	FROM		MARKETING
	ORDER BY	MARKETINGTYPE
</CFQUERY>

<BR clear="left" />

<!--- 
********************************************************
* The following code is the ADD Process for Marketing. *
********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Marketing</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
			SELECT	MAX(MARKETINGID) AS MAX_ID
			FROM		MARKETING
		</CFQUERY>
		<CFSET FORM.MARKETINGID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="MARKETINGID" secure="NO" value="#FORM.MARKETINGID#">
		<CFQUERY name="AddMarketingID" datasource="#application.type#INSTRUCTION">
			INSERT INTO	MARKETING (MARKETINGID)
			VALUES		(#val(Cookie.MARKETINGID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Marketing Key &nbsp; = &nbsp; #FORM.MARKETINGID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processmarketing.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMarketing" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MARKETING" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processmarketing.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="MARKETINGTYPE">*Marketing Type:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="MARKETINGTYPE" id="MARKETINGTYPE" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessMarketing" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processmarketing.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMarketing" value="CANCELADD" tabindex="4" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Marketing. *
***********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Instruction - Marketing </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPMARKETINGS')>
		<TR>
			<TH align="center">Marketing Key &nbsp; = &nbsp; #FORM.MARKETINGID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPMARKETINGS')>
		<TABLE width="100%" align="LEFT">
			<TR>
	<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
	</CFFORM>
			</TR>
	<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/marketing.cfm?PROCESS=#URL.PROCESS#&LOOKUPMARKETINGS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="MARKETINGID">*Marketing Type:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="MARKETINGID" id="MARKETINGID" size="1" query="ListMarketing" value="MARKETINGID" display="MARKETINGTYPE" required="No" tabindex="2"></CFSELECT>
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
	<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
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
* The following code is the Modify and Delete Processes for Marketing.*
***********************************************************************
 --->

		<CFQUERY name="GetMarketing" datasource="#application.type#INSTRUCTION">
			SELECT	MARKETINGID, MARKETINGTYPE
			FROM		MARKETING
			WHERE	MARKETINGID = <CFQUERYPARAM value="#FORM.MARKETINGID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	MARKETINGTYPE
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/instruction/marketing.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessMarketing" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="MARKETING" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processmarketing.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="MARKETINGID" secure="NO" value="#FORM.MARKETINGID#">
				<TH align="left"><H4><LABEL for="MARKETINGTYPE">*Marketing Type:</label></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="MARKETINGTYPE" id="MARKETINGTYPE" value="#GetMarketing.MARKETINGTYPE#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessMarketing" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessMarketing" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/marketing.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessMarketing" value="Cancel" tabindex="5" /><BR />
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