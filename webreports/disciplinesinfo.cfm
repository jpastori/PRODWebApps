<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: disciplinesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Disciplines --->
<!-- Last modified by John R. Pastori on 07/30/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/bibliodisciplinesinfo.cfm">
<CFSET CONTENT_UPDATED = "July 30, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Disciplines</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Disciplines</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Library Shared Data Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.DISCIPLINES.DISCIPLINENAME.value == "" || document.DISCIPLINES.DISCIPLINENAME.value == " ") {
			alertuser (document.DISCIPLINES.DISCIPLINENAME.name +  ",  An Discipline Name MUST be entered!");
			document.DISCIPLINES.DISCIPLINENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.DISCIPLINEID.selectedIndex == "0") {
			alertuser ("An Discipline Name MUST be selected!");
			document.LOOKUP.DISCIPLINEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPDISCIPLINE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.DISCIPLINEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.DISCIPLINES.DISCIPLINENAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<IMG src="/images/bigheader.jpg" width="279" height="63" alt="LFOLKS Intranet Web Site" align="left" VALIGN="top" border="0" /><BR><BR><BR><BR>

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListDisciplines" datasource="#application.type#WEBREPORTS" blockfactor="92">
	SELECT	DISCIPLINEID, DISCIPLINENAME
	FROM		DISCIPLINES
	ORDER BY	DISCIPLINENAME
</CFQUERY>

<!--- 
***************************************************************
* The following code is the ADD Process for Disciplines Info. *
***************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Disciplines Info</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
		SELECT	MAX(DISCIPLINEID) AS MAX_ID
		FROM		DISCIPLINES
	</CFQUERY>
	<CFSET FORM.DISCIPLINEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="DISCIPLINEID" secure="NO" value="#FORM.DISCIPLINEID#">
	<CFQUERY name="AddDisciplinesID" datasource="#application.type#WEBREPORTS">
		INSERT INTO	DISCIPLINES (DISCIPLINEID)
		VALUES		(#val(Cookie.DISCIPLINEID)#)
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Disciplines Key &nbsp; = &nbsp; #FORM.DISCIPLINEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processdisciplinesinfo.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessDisciplines" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="DISCIPLINES" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processdisciplinesinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<CFCOOKIE name="DISCIPLINEID" secure="NO" value="#FORM.DISCIPLINEID#">
			<TH align="left"><H4><LABEL for="DISCIPLINENAME">*Discipline Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="DISCIPLINENAME" id="DISCIPLINENAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="LEFT"><INPUT type="submit" name="ProcessDisciplines" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processdisciplinesinfo.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessDisciplines" value="CANCELADD" tabindex="4" /><BR />
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
******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Disciplines Info. *
******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Web Reports - Disciplines Info</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPDISCIPLINE')>
		<TR>
			<TH align="center">Disciplines Key &nbsp; = &nbsp; #FORM.DISCIPLINEID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPDISCIPLINE')>
		<TABLE width="100%" align="LEFT">
			<TR>
	<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
	</CFFORM>
			</TR>
	<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/disciplinesinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPDISCIPLINE=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="DISCIPLINEID">*Discipline Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="DISCIPLINEID" id="DISCIPLINEID" size="1" query="ListDisciplines" value="DISCIPLINEID" display="DISCIPLINENAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" value="GO" tabindex="3" /></TD>
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
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
*******************************************************************************
* The following code is the Modify and Delete Processes for Disciplines Info. *
*******************************************************************************
 --->

		<CFQUERY name="GetDisciplines" datasource="#application.type#WEBREPORTS">
			SELECT	DISCIPLINEID, DISCIPLINENAME
			FROM		DISCIPLINES
			WHERE	DISCIPLINEID = <CFQUERYPARAM value="#FORM.DISCIPLINEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DISCIPLINENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/disciplinesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessDisciplines" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="DISCIPLINES" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processdisciplinesinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="DISCIPLINEID" secure="NO" value="#FORM.DISCIPLINEID#">
				<TH align="left"><H4><LABEL for="DISCIPLINENAME">*Discipline Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="DISCIPLINENAME" id="DISCIPLINENAME" value="#GetDisciplines.DISCIPLINENAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" name="ProcessDisciplines" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" name="ProcessDisciplines" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/disciplinesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessDisciplines" value="Cancel" tabindex="5" /><BR />
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