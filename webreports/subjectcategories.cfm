<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: subjectcategories.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/02/2009 --->
<!--- Date in Production: 02/02/2009 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Article DB Site Subject Categories --->
<!-- Last modified by John R. Pastori on 02/02/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/subjectcategories.cfm">
<CFSET CONTENT_UPDATED = "February 02, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Article DB Site Subject Categories</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Article DB Site Subject Categories</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Library Web Reports Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {

		if (document.SUBJECTCATEGORIES.SUBJECTCATNAME.value == "" || document.SUBJECTCATEGORIES.SUBJECTCATNAME.value == " ") {
			alertuser (document.SUBJECTCATEGORIES.SUBJECTCATNAME.name +  ",  A SUBJECT CATEGORY Name MUST be entered!");
			document.SUBJECTCATEGORIES.SUBJECTCATNAME.focus();
			return false;
		}

		if (document.SUBJECTCATEGORIES.SUBJECTCATURL.value == "" || document.SUBJECTCATEGORIES.SUBJECTCATURL.value == " ") {
			alertuser (document.SUBJECTCATEGORIES.SUBJECTCATURL.name +  ",  A SUBJECT CATEGORY URL MUST be entered!");
			document.SUBJECTCATEGORIES.SUBJECTCATURL.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.SUBJECTCATID.selectedIndex == "0") {
			alertuser ("A SUBJECT CATEGORIES Name MUST be selected!");
			document.LOOKUP.SUBJECTCATID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSUBJECTCATID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SUBJECTCATID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SUBJECTCATEGORIES.SUBJECTCATNAME.focus()">
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

<CFQUERY name="ListSubjectCategories" datasource="#application.type#WEBREPORTS" blockfactor="51">
	SELECT	SUBJECTCATID, SUBJECTCATNAME, SUBJECTCATURL, SUBJECTCATCOMMENTS
	FROM		SUBJECTCATEGORIES
	ORDER BY	SUBJECTCATNAME
</CFQUERY>

<BR clear="left" />

<!--- 
***************************************************************
* The following code is the ADD Process for Article DB Sites. *
***************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Article DB Site Subject Categories</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
		SELECT	MAX(SUBJECTCATID) AS MAX_ID
		FROM		SUBJECTCATEGORIES
	</CFQUERY>
	<CFSET FORM.SUBJECTCATID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="SUBJECTCATID" secure="NO" value="#FORM.SUBJECTCATID#">
	<CFQUERY name="AddSubjectCategoriesID" datasource="#application.type#WEBREPORTS">
		INSERT INTO	SUBJECTCATEGORIES (SUBJECTCATID)
		VALUES		(#val(Cookie.SUBJECTCATID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Subject Categories Key &nbsp; = &nbsp; #FORM.SUBJECTCATID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processsubjectcategories.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessSubjectCategories" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SUBJECTCATEGORIES" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processsubjectcategories.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="SUBJECTCATNAME">*Subject Categories Name</LABEL></H4></TH>
			<TH align="left" valign ="bottom"><H4><LABEL for="SUBJECTCATURL">*Subject Categories URL</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="SUBJECTCATNAME" id="SUBJECTCATNAME" value="" align="LEFT" required="No" size="40" maxlength="50" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="SUBJECTCATURL" id="SUBJECTCATURL" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="left" colspan="2"><LABEL for="SUBJECTCATCOMMENTS">Subject Category Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<TEXTAREA name="SUBJECTCATCOMMENTS" id="SUBJECTCATCOMMENTS" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="60" tabindex="4"> </TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessSubjectCategories" value="ADD" tabindex="5" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processsubjectcategories.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessSubjectCategories" value="CANCELADD" tabindex="6" /><BR />
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
******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Article DB Sites. *
******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Modify/Delete Information to Web Reports - <BR />
				Article DB Site Subject Categories
			</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!&nbsp;&nbsp;&nbsp;&nbsp; </H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPSUBJECTCATID')>
		<TR>
			<TH align="center"> Subject Categories Key &nbsp; = &nbsp; #FORM.SUBJECTCATID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPSUBJECTCATID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/subjectcategories.cfm?PROCESS=#URL.PROCESS#&LOOKUPSUBJECTCATID=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="SUBJECTCATID">*Subject Categories Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="SUBJECTCATID" id="SUBJECTCATID" size="1" query="ListSubjectCategories" value="SUBJECTCATID" display="SUBJECTCATNAME" required="No" tabindex="2"></CFSELECT>
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
*******************************************************************************
* The following code is the Modify and Delete Processes for Article DB Sites. *
*******************************************************************************
 --->

		<CFQUERY name="GetSubjectCategories" datasource="#application.type#WEBREPORTS">
			SELECT	SUBJECTCATID, SUBJECTCATNAME, SUBJECTCATURL, SUBJECTCATCOMMENTS
			FROM		SUBJECTCATEGORIES
			WHERE	SUBJECTCATID = <CFQUERYPARAM value="#FORM.SUBJECTCATID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SUBJECTCATNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/subjectcategories.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessSubjectCategories" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="SUBJECTCATEGORIES" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processsubjectcategories.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="SUBJECTCATID" secure="NO" value="#FORM.SUBJECTCATID#">
				<TH align="left"><H4><LABEL for="SUBJECTCATNAME">*Subject Categories Name</LABEL></H4></TH>
				<TH align="left" valign ="bottom"><H4><LABEL for="SUBJECTCATURL">*Subject Categories URL</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="SUBJECTCATNAME" id="SUBJECTCATNAME" value="#GetSubjectCategories.SUBJECTCATNAME#" align="LEFT" required="No" size="40" maxlength="50" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="SUBJECTCATURL" id="SUBJECTCATURL" value="#GetSubjectCategories.SUBJECTCATURL#" align="LEFT" required="No" size="50" maxlength="100" tabindex="3"></TD>
			</TR>
			<TR>
				<TH align="left" colspan="2"><LABEL for="SUBJECTCATCOMMENTS">Subject Comments</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<TEXTAREA name="SUBJECTCATCOMMENTS" id="SUBJECTCATCOMMENTS" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="60" tabindex="4">#GetSubjectCategories.SUBJECTCATCOMMENTS#</TEXTAREA>
				</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessSubjectCategories" value="MODIFY" tabindex="5" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessSubjectCategories" value="DELETE" tabindex="6" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/subjectcategories.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessSubjectCategories" value="Cancel" tabindex="7" /><BR />
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