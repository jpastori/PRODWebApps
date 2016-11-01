<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: professor.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/28/2009 --->
<!--- Date in Production: 01/28/2009 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Professor --->
<!-- Last modified by John R. Pastori on 01/28/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/professor.cfm">
<CFSET CONTENT_UPDATED = "January 28, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Professor</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Professor</TITLE>
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
		if (document.PROFESSOR.PROFESSORNAME.value == "" || document.PROFESSOR.PROFESSORNAME.value == " ") {
			alertuser (document.PROFESSOR.PROFESSORNAME.name +  ",  A Professor Name MUST be entered!");
			document.PROFESSOR.PROFESSORNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.PROFESSORID.selectedIndex == "0") {
			alertuser ("A Professor Name MUST be selected!");
			document.LOOKUP.PROFESSORID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPROFESSORS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PROFESSORID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PROFESSOR.PROFESSORNAME.focus()">
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

<CFQUERY name="ListProfessor" datasource="#application.type#INSTRUCTION" blockfactor="100">
	SELECT	PROFESSORID, PROFESSORNAME
	FROM		PROFESSORS
	ORDER BY	PROFESSORNAME
</CFQUERY>

<BR clear="left" />

<!--- 
********************************************************
* The following code is the ADD Process for Professor. *
********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Professor</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
			SELECT	MAX(PROFESSORID) AS MAX_ID
			FROM		PROFESSORS
		</CFQUERY>
		<CFSET FORM.PROFESSORID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="PROFESSORID" secure="NO" value="#FORM.PROFESSORID#">
		<CFQUERY name="AddProfessorID" datasource="#application.type#INSTRUCTION">
			INSERT INTO	PROFESSORS (PROFESSORID)
			VALUES		(#val(Cookie.PROFESSORID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Professor Key &nbsp; = &nbsp; #FORM.PROFESSORID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processprofessor.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessProfessors" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="PROFESSOR" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processprofessor.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="PROFESSORNAME">*Professor Name:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="PROFESSORNAME" id="PROFESSORNAME" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessProfessors" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processprofessor.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessProfessors" value="CANCELADD" tabindex="4" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Professor. *
***********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Instruction - Professor </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPPROFESSORS')>
		<TR>
			<TH align="center">Professor Key &nbsp; = &nbsp; #FORM.PROFESSORID#</TH>
		</TR>
	</CFIF>
	</TABLE>
<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPROFESSORS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/professor.cfm?PROCESS=#URL.PROCESS#&LOOKUPPROFESSORS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="PROFESSORID">*Professor Name:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="PROFESSORID" id="PROFESSORID" size="1" query="ListProfessor" value="PROFESSORID" display="PROFESSORNAME" required="No" tabindex="2"></CFSELECT>
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
* The following code is the Modify and Delete Processes for Professor.*
***********************************************************************
 --->

		<CFQUERY name="GetProfessor" datasource="#application.type#INSTRUCTION">
			SELECT	PROFESSORID, PROFESSORNAME
			FROM		PROFESSORS
			WHERE	PROFESSORID = <CFQUERYPARAM value="#FORM.PROFESSORID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	PROFESSORNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/instruction/professor.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessProfessors" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="PROFESSOR" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processprofessor.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="PROFESSORID" secure="NO" value="#FORM.PROFESSORID#">
				<TH align="left"><H4><LABEL for="PROFESSORNAME">*Professor Name:</label></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="PROFESSORNAME" id="PROFESSORNAME" value="#GetProfessor.PROFESSORNAME#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessProfessors" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessProfessors" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/professor.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessProfessors" value="Cancel" tabindex="5" /><BR />
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