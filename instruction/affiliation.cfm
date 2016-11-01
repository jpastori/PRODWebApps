<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: affiliation.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written:  07/30/2012 --->
<!--- Date in Production:  07/30/2012 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Affiliation --->
<!-- Last modified by John R. Pastori on  07/30/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/affiliation.cfm">
<CFSET CONTENT_UPDATED = "July 30 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Affiliation</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Affiliation</TITLE>
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
		if (document.AFFILIATION.AFFILIATIONNAME.value == "" || document.AFFILIATION.AFFILIATIONNAME.value == " ") {
			alertuser (document.AFFILIATION.AFFILIATIONNAME.name +  ",  A Affiliation Name MUST be entered!");
			document.AFFILIATION.AFFILIATIONNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.AFFILIATIONID.selectedIndex == "0") {
			alertuser ("A Affiliation Name MUST be selected!");
			document.LOOKUP.AFFILIATIONID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPAFFILIATIONS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.AFFILIATIONID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.AFFILIATION.AFFILIATIONNAME.focus()">
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

<CFQUERY name="ListAffiliation" datasource="#application.type#INSTRUCTION" blockfactor="4">
	SELECT	AFFILIATIONID, AFFILIATIONNAME
	FROM		AFFILIATION
	ORDER BY	AFFILIATIONNAME
</CFQUERY>

<BR clear="left" />

<!--- 
**********************************************************
* The following code is the ADD Process for Affiliation. *
**********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Affiliation</H1></TD>
		</TR>
	</TABLE>
	
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
		SELECT	MAX(AFFILIATIONID) AS MAX_ID
		FROM		AFFILIATION
	</CFQUERY>
	<CFSET FORM.AFFILIATIONID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="AFFILIATIONID" secure="NO" value="#FORM.AFFILIATIONID#">
	<CFQUERY name="AddAffiliationID" datasource="#application.type#INSTRUCTION">
		INSERT INTO	AFFILIATION (AFFILIATIONID)
		VALUES		(#val(Cookie.AFFILIATIONID)#)
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Affiliation Key &nbsp; = &nbsp; #FORM.AFFILIATIONID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processaffiliation.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="SUBMIT" name="ProcessAffiliation" src="/images/closewindowbutton.jpg" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="AFFILIATION" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processaffiliation.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="AFFILIATIONNAME">*Affiliation Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="AFFILIATIONNAME" id="AFFILIATIONNAME" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="SUBMIT" name="ProcessAffiliation" src="/images/addbutton.jpg" value="ADD" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processaffiliation.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="SUBMIT" name="ProcessAffiliation" src="/images/closewindowbutton.jpg" value="CANCELADD" tabindex="4" /><BR />
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
*************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Affiliation. *
*************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Instruction - Affiliation </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPAFFILIATIONS')>
		<TR>
			<TH align="center">Affiliation Key &nbsp; = &nbsp; #FORM.AFFILIATIONID#</TH>
		</TR>
	</CFIF>
	</TABLE>
<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPAFFILIATIONS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="SUBMIT" src="/images/closewindowbutton.jpg" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/affiliation.cfm?PROCESS=#URL.PROCESS#&LOOKUPAFFILIATIONS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="AFFILIATIONID">*Affiliation Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="AFFILIATIONID" id="AFFILIATIONID" size="1" query="ListAffiliation" value="AFFILIATIONID" display="AFFILIATIONNAME" selected="0" required="No" tabindex="2"></CFSELECT>
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
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="SUBMIT" src="/images/closewindowbutton.jpg" value="Cancel" tabindex="4" /><BR />
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
*************************************************************************
* The following code is the Modify and Delete Processes for Affiliation.*
*************************************************************************
 --->

		<CFQUERY name="GetAffiliation" datasource="#application.type#INSTRUCTION">
			SELECT	AFFILIATIONID, AFFILIATIONNAME
			FROM		AFFILIATION
			WHERE	AFFILIATIONID = <CFQUERYPARAM value="#FORM.AFFILIATIONID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	AFFILIATIONNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/instruction/affiliation.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" name="ProcessAffiliation" src="/images/cancelbutton.jpg" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR><TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="AFFILIATION" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processaffiliation.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="AFFILIATIONID" secure="NO" value="#FORM.AFFILIATIONID#">
				<TH align="left"><H4><LABEL for="AFFILIATIONNAME">*Affiliation Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="AFFILIATIONNAME" id="AFFILIATIONNAME" value="#GetAffiliation.AFFILIATIONNAME#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="SUBMIT" name="ProcessAffiliation" src="/images/newmodifybutton.gif" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="SUBMIT" name="ProcessAffiliation" src="/images/deletebutton.jpg" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/affiliation.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="SUBMIT" name="ProcessAffiliation" src="/images/cancelbutton.jpg" value="Cancel" tabindex="5" /><BR />
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