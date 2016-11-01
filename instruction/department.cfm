<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: department.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/28/2009 --->
<!--- Date in Production: 01/28/2009 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Departments --->
<!-- Last modified by John R. Pastori on 01/28/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/department.cfm">
<CFSET CONTENT_UPDATED = "January 28, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Departments</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Departments</TITLE>
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
		if (document.DEPARTMENTS.DEPARTMENTNAME.value == "" || document.DEPARTMENTS.DEPARTMENTNAME.value == " ") {
			alertuser (document.DEPARTMENTS.DEPARTMENTNAME.name +  ",  A Department Name MUST be entered!");
			document.DEPARTMENTS.DEPARTMENTNAME.focus();
			return false;
		}

		if (document.DEPARTMENTS.BROADAFFILIATION.value == "" || document.DEPARTMENTS.BROADAFFILIATION.value == " ") {
			alertuser (document.DEPARTMENTS.BROADAFFILIATION.name +  ",  A Broad Affiliation MUST be entered!");
			document.DEPARTMENTS.BROADAFFILIATION.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.DEPARTMENTID.selectedIndex == "0") {
			alertuser ("A Department Name MUST be selected!");
			document.LOOKUP.DEPARTMENTID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPDEPARTMENTS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.DEPARTMENTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.DEPARTMENTS.DEPARTMENTNAME.focus()">
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

<CFQUERY name="ListDepartments" datasource="#application.type#INSTRUCTION" blockfactor="100">
	SELECT	DEPARTMENTID, DEPARTMENTNAME, BROADAFFILIATION
	FROM		DEPARTMENTS
	ORDER BY	DEPARTMENTNAME
</CFQUERY>

<BR clear="left" />

<!--- 
**********************************************************
* The following code is the ADD Process for Departments. *
**********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Departments</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
		SELECT	MAX(DEPARTMENTID) AS MAX_ID
		FROM		DEPARTMENTS
	</CFQUERY>
	<CFSET FORM.DEPARTMENTID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="DEPARTMENTID" secure="NO" value="#FORM.DEPARTMENTID#">
	<CFQUERY name="AddDepartmentsID" datasource="#application.type#INSTRUCTION">
		INSERT INTO	DEPARTMENTS (DEPARTMENTID)
		VALUES		(#val(Cookie.DEPARTMENTID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Department Key &nbsp; = &nbsp; #FORM.DEPARTMENTID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processdepartment.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessDepartments" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="DEPARTMENTS" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processdepartment.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="DEPARTMENTNAME">*Department Name</label></H4></TH>
			<TH align="left"><H4><LABEL for="BROADAFFILIATION">*Broad Affiliation</label></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="DEPARTMENTNAME" id="DEPARTMENTNAME" value="" align="LEFT" required="No" size="80" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="BROADAFFILIATION" id="BROADAFFILIATION" value="" align="LEFT" required="No" size="50" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessDepartments" value="ADD" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processdepartment.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessDepartments" value="CANCELADD" tabindex="5" /><BR />
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
* The following code is the Look Up Process for Modifying and Deleting Departments. *
*************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
			<CFIF NOT IsDefined('URL.LOOKUPDEPARTMENTS')>
				<H1>Lookup for Modify/Delete Information to Instruction - Departments </H1>
			<CFELSE>
				<H1>Modify/Delete Information to Instruction - Departments </H1>
			</CFIF>
			</TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPDEPARTMENTS')>
		<TR>
			<TH align="center">Departments Key &nbsp; = &nbsp; #FORM.DEPARTMENTID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPDEPARTMENTS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/department.cfm?PROCESS=#URL.PROCESS#&LOOKUPDEPARTMENTS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="DEPARTMENTID">*Department Name:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="DEPARTMENTID" id="DEPARTMENTID" size="1" query="ListDepartments" value="DEPARTMENTID" display="DEPARTMENTNAME" selected="0" required="No" tabindex="2"></CFSELECT>
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
*************************************************************************
* The following code is the Modify and Delete Processes for Departments.*
*************************************************************************
 --->

		<CFQUERY name="GetDepartments" datasource="#application.type#INSTRUCTION">
			SELECT	DEPARTMENTID, DEPARTMENTNAME, BROADAFFILIATION
			FROM		DEPARTMENTS
			WHERE	DEPARTMENTID = <CFQUERYPARAM value="#FORM.DEPARTMENTID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DEPARTMENTNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/instruction/department.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessDepartments" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="DEPARTMENTS" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processdepartment.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="DEPARTMENTID" secure="NO" value="#FORM.DEPARTMENTID#">
				<TH align="left"><H4><LABEL for="DEPARTMENTNAME">*Department Name</label></H4></TH>
				<TH align="left"><H4><LABEL for="BROADAFFILIATION">*Broad Affiliation</label></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="DEPARTMENTNAME" id="DEPARTMENTNAME" value="#GetDepartments.DEPARTMENTNAME#" align="LEFT" required="No" size="80" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="BROADAFFILIATION" id="BROADAFFILIATION" value="#GetDepartments.BROADAFFILIATION#" align="LEFT" required="No" size="50" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessDepartments" value="MODIFY" tabindex="4" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessDepartments" value="DELETE" tabindex="5" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/department.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessDepartments" value="Cancel" tabindex="6" /><BR />
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