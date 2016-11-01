<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: presentlength.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/28/2009 --->
<!--- Date in Production: 01/28/2009 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Presentation Length --->
<!-- Last modified by John R. Pastori on 01/28/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/presentlength.cfm">
<CFSET CONTENT_UPDATED = "January 28, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Presentation Length</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Presentation Length</TITLE>
	</CFIF>
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
		if (document.PRESENTLENGTHS.PRESENTLENGTHTEXT.value == "" || document.PRESENTLENGTHS.PRESENTLENGTHTEXT.value == " ") {
			alertuser (document.PRESENTLENGTHS.PRESENTLENGTHTEXT.name +  ",  A Presentation Length MUST be entered!");
			document.PRESENTLENGTHS.PRESENTLENGTHTEXT.focus();
			return false;
		}
	
		if (document.PRESENTLENGTHS.PRESENTLENGTH.value == "" || document.PRESENTLENGTHS.PRESENTLENGTH.value == " ") {
			alertuser (document.PRESENTLENGTHS.PRESENTLENGTH.name +  ",  A Presentation Length number MUST be entered!");
			document.PRESENTLENGTHS.PRESENTLENGTH.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.PRESENTLENGTHID.selectedIndex == "0") {
			alertuser ("A Presentation Length MUST be selected!");
			document.LOOKUP.PRESENTLENGTHID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPRESENTLENGTHS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PRESENTLENGTHID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PRESENTLENGTHS.PRESENTLENGTHTEXT.focus()">
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

<CFQUERY name="ListPresentLengths" datasource="#application.type#INSTRUCTION" blockfactor="37">
	SELECT	PRESENTLENGTHID, PRESENTLENGTHTEXT, PRESENTLENGTH
	FROM		PRESENTLENGTHS
	ORDER BY	PRESENTLENGTH
</CFQUERY>

<BR clear="left" />

<!--- 
******************************************************************
* The following code is the ADD Process for Presentation Length. *
******************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Presentation Length</H1></TD>
		</TR>
	</TABLE>
	
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
		SELECT	MAX(PRESENTLENGTHID) AS MAX_ID
		FROM		PRESENTLENGTHS
	</CFQUERY>
	<CFSET FORM.PRESENTLENGTHID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="PRESENTLENGTHID" secure="NO" value="#FORM.PRESENTLENGTHID#">
	<CFQUERY name="AddPresentLengthsID" datasource="#application.type#INSTRUCTION">
		INSERT INTO	PRESENTLENGTHS (PRESENTLENGTHID)
		VALUES		(#val(Cookie.PRESENTLENGTHID)#)
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Presentation Length Key &nbsp; = &nbsp; #FORM.PRESENTLENGTHID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processpresentlength.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessPresentLength" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="PRESENTLENGTHS" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processpresentlength.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="PRESENTLENGTHTEXT">*Presentation Length Text</label></H4></TH>
			<TH align="left"><H4><LABEL for="PRESENTLENGTH">*Presentation Length</label></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="PRESENTLENGTHTEXT" id="PRESENTLENGTHTEXT" value="" align="LEFT" required="No" size="7" tabindex="2"></TD>
			<TD align="left">
				<CFINPUT type="Text" name="PRESENTLENGTH" id="PRESENTLENGTH" value="" align="LEFT" required="No" size="6" tabindex="3"><BR />
				<COM>FORMAT: &nbsp;&nbsp;9999.99</COM>
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessPresentLength" value="ADD" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processpresentlength.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessPresentLength" value="CANCELADD" tabindex="5" /><BR />
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
*********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Presentation Length. *
*********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Instruction - Presentation Length </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined("URL.LOOKUPPRESENTLENGTHS")>
		<TR>
			<TH align="center">PresentLength Key &nbsp; = &nbsp; #FORM.PRESENTLENGTHID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

		<CFIF NOT IsDefined("URL.LOOKUPPRESENTLENGTHS")>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/presentlength.cfm?PROCESS=#URL.PROCESS#&LOOKUPPRESENTLENGTHS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="PRESENTLENGTHID">*Presentation Length Text:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="PRESENTLENGTHID" id="PRESENTLENGTHID" size="1" query="ListPresentLengths" value="PRESENTLENGTHID" display="PRESENTLENGTHTEXT" required="No" tabindex="2"></CFSELECT>
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
*********************************************************************************
* The following code is the Modify and Delete Processes for Presentation Length.*
*********************************************************************************
 --->

		<CFQUERY name="GetPresentLengths" datasource="#application.type#INSTRUCTION">
			SELECT	PRESENTLENGTHID, PRESENTLENGTHTEXT, PRESENTLENGTH
			FROM		PRESENTLENGTHS
			WHERE	PRESENTLENGTHID = <CFQUERYPARAM value="#FORM.PRESENTLENGTHID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PRESENTLENGTHTEXT
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/instruction/presentlength.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessPresentLength" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="PRESENTLENGTHS" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processpresentlength.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="PRESENTLENGTHID" secure="NO" value="#FORM.PRESENTLENGTHID#">
				<TH align="left"><H4><LABEL for="PRESENTLENGTHTEXT">*Presentation Length Text</label></H4></TH>
				<TH align="left"><H4><LABEL for="PRESENTLENGTH">*Presentation Length</label></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="PRESENTLENGTHTEXT" id="PRESENTLENGTHTEXT" value="#GetPresentLengths.PRESENTLENGTHTEXT#" align="LEFT" required="No" size="7" tabindex="2"></TD>
				<TD align="left">
					<CFINPUT type="Text" name="PRESENTLENGTH" id="PRESENTLENGTH" value="#GetPresentLengths.PRESENTLENGTH#" align="LEFT" required="No" size="6" tabindex="3"><BR />
					<COM>FORMAT: &nbsp;&nbsp;9999.99</COM>
				</TD>
			</TR>
			
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessPresentLength" value="MODIFY" tabindex="4" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessPresentLength" value="DELETE" tabindex="5" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
	<CFFORM action="/#application.type#apps/instruction/presentlength.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessPresentLength" value="Cancel" tabindex="6" /><BR />
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