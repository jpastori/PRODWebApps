<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: category.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/28/2009 --->
<!--- Date in Production: 01/28/2009 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Category --->
<!-- Last modified by John R. Pastori on 01/28/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/category.cfm">
<CFSET CONTENT_UPDATED = "January 28, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Category</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Category</TITLE>
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
		if (document.CATEGORY.CATEGORYNAME.value == "" || document.CATEGORY.CATEGORYNAME.value == " ") {
			alertuser (document.CATEGORY.CATEGORYNAME.name +  ",  A Category Name MUST be entered!");
			document.CATEGORY.CATEGORYNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.CATEGORYID.selectedIndex == "0") {
			alertuser ("A Category Name MUST be selected!");
			document.LOOKUP.CATEGORYID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCATEGORYS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CATEGORYID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CATEGORY.CATEGORYNAME.focus()">
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

<CFQUERY name="ListCategory" datasource="#application.type#INSTRUCTION" blockfactor="9">
	SELECT	CATEGORYID, CATEGORYNAME
	FROM		CATEGORY
	ORDER BY	CATEGORYNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*******************************************************
* The following code is the ADD Process for Category. *
*******************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Category</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
			SELECT	MAX(CATEGORYID) AS MAX_ID
			FROM		CATEGORY
		</CFQUERY>
		<CFSET FORM.CATEGORYID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="CATEGORYID" secure="NO" value="#FORM.CATEGORYID#">
		<CFQUERY name="AddCategoryID" datasource="#application.type#INSTRUCTION">
			INSERT INTO	CATEGORY (CATEGORYID)
			VALUES		(#val(Cookie.CATEGORYID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Category Key &nbsp; = &nbsp; #FORM.CATEGORYID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processcategory.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCategories" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processcategory.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="CATEGORYNAME">*Category Name:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="CATEGORYNAME" id="CATEGORYNAME" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessCategories" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processcategory.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCategories" value="CANCELADD" tabindex="3" /><BR />
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
**********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Category. *
**********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Instruction - Category </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPCATEGORYS')>
		<TR>
			<TH align="center">Category Key &nbsp; = &nbsp; #FORM.CATEGORYID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCATEGORYS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/category.cfm?PROCESS=#URL.PROCESS#&LOOKUPCATEGORYS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="CATEGORYID">*Category Name:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListCategory" value="CATEGORYID" display="CATEGORYNAME" required="No" tabindex="2"></CFSELECT>
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
**********************************************************************
* The following code is the Modify and Delete Processes for Category.*
**********************************************************************
 --->

		<CFQUERY name="GetCategory" datasource="#application.type#INSTRUCTION">
			SELECT	CATEGORYID, CATEGORYNAME
			FROM		CATEGORY
			WHERE	CATEGORYID = <CFQUERYPARAM value="#FORM.CATEGORYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CATEGORYNAME
		</CFQUERY>

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/category.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCategories" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processcategory.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<CFCOOKIE name="CATEGORYID" secure="NO" value="#FORM.CATEGORYID#">
			<TH align="left"><H4><LABEL for="CATEGORYNAME">*Category Name:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="CATEGORYNAME" id="CATEGORYNAME" value="#GetCategory.CATEGORYNAME#" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessCategories" value="MODIFY" tabindex="3" /></TD>
		</TR>
	<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessCategories" value="DELETE" tabindex="4" /></TD>
		</TR>
	</CFIF>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/instruction/category.cfm?PROCESS=#URL.PROCESS#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessCategories" value="Cancel" tabindex="5" /><BR />
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