<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: bibliodisciplinesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Bibliography/Disciplines --->
<!-- Last modified by John R. Pastori on 07/30/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/bibliodisciplinesinfo.cfm">
<CFSET CONTENT_UPDATED = "July 30, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Bibliography/Disciplines</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Bibliography/Disciplines</TITLE>
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
		if (document.BIBLIODISCIPLINES.DISCIPLINEID.selectedIndex == "0") {
			alertuser (document.BIBLIODISCIPLINES.DISCIPLINEID.name +  ",  A DISCIPLINE Name MUST be selected!");
			document.BIBLIODISCIPLINES.DISCIPLINEID.focus();
			return false;
		}

		if (document.BIBLIODISCIPLINES.BIBLIOGRAPHERID.selectedIndex == "0") {
			alertuser (document.BIBLIODISCIPLINES.BIBLIOGRAPHERID.name +  ",  A Bibliographer Name MUST be selected!");
			document.BIBLIODISCIPLINES.BIBLIOGRAPHERID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.BIBLIODISCIPLINEID.selectedIndex == "0") {
			alertuser ("A DISCIPLINE Name MUST be selected!");
			document.LOOKUP.BIBLIODISCIPLINEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPBIBLIODISCIPLINE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.BIBLIODISCIPLINEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.BIBLIODISCIPLINES.DISCIPLINEID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<IMG src="/images/bigheader.jpg" width="279" height="63" alt="LFOLKS Intranet Web Site" align="left" VALIGN="top" border="0" />

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>
<BR><BR><BR><BR><BR>
<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListBiblioDisciplines" datasource="#application.type#WEBREPORTS" blockfactor="94">
	SELECT	BD.BIBLIODISCIPLINEID, BD.DISCIPLINEID, BD.SUBDISCIPLINE, BD.BIBLIOGRAPHERID, BD.ALTERNATEBIBLIOGRAPHERID, BD.BIBLIOACADEMICYEARID,
			D.DISCIPLINENAME || '-' || BD.SUBDISCIPLINE AS KEYFINDER
	FROM		BIBLIODISCIPLINES BD, DISCIPLINES D
	WHERE	BD.DISCIPLINEID = D.DISCIPLINEID
	ORDER BY	D.DISCIPLINENAME
</CFQUERY>

<CFQUERY name="ListBibliographers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, FULLNAME, LASTNAME, BIBLIOGRAPHER, ACTIVE
	FROM		CUSTOMERS
	WHERE	BIBLIOGRAPHER = 'YES' AND
			ACTIVE = 'YES'
	ORDER BY	FULLNAME
</CFQUERY>

<CFQUERY name="ListDisciplines" datasource="#application.type#WEBREPORTS" blockfactor="92">
	SELECT	DISCIPLINEID, DISCIPLINENAME
	FROM		DISCIPLINES
	ORDER BY	DISCIPLINENAME
</CFQUERY>

<CFQUERY name="LookupCurrentAcademicYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_4DIGIT AS FISCALYEAR
	FROM		FISCALYEARS
	WHERE	CURRENTFISCALYEAR = 'YES'
	ORDER BY	FISCALYEAR
</CFQUERY>

<!--- 
****************************************************************
* The following code is the ADD Process for Bibliography Info. *
****************************************************************
 --->
 
<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Bibliography Info</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
		SELECT	MAX(BIBLIODISCIPLINEID) AS MAX_ID
		FROM		BIBLIODISCIPLINES
	</CFQUERY>
	<CFSET FORM.BIBLIODISCIPLINEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="BIBLIODISCIPLINEID" secure="NO" value="#FORM.BIBLIODISCIPLINEID#">
	<CFQUERY name="AddBiblioDisciplinesID" datasource="#application.type#WEBREPORTS">
		INSERT INTO	BIBLIODISCIPLINES (BIBLIODISCIPLINEID, BIBLIOACADEMICYEARID)
		VALUES		(#val(Cookie.BIBLIODISCIPLINEID)#, #val(LookupCurrentAcademicYear.FISCALYEARID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Bibliography/Disciplines Key &nbsp; = &nbsp; #FORM.BIBLIODISCIPLINEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%"  border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processbibliodisciplinesinfo.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessBiblioDisciplines" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="BIBLIODISCIPLINES" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processbibliodisciplinesinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Academic Year</TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				#LookupCurrentAcademicYear.FISCALYEAR#
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="DISCIPLINEID">*Discipline Name</LABEL></H4></TH>
			<TH align="left"><LABEL for="SUBDISCIPLINE">Sub-Discipline</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="DISCIPLINEID" id="DISCIPLINEID" size="1" query="ListDisciplines" value="DISCIPLINEID" display="DISCIPLINENAME" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left"><CFINPUT type="Text" name="SUBDISCIPLINE" id="SUBDISCIPLINE" value="" align="LEFT" required="No" size="16" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="BIBLIOGRAPHERID">*Bibliographer Name</LABEL></H4></TH>
			<TH align="left"><LABEL for="ALTERNATEBIBLIOGRAPHERID">Alternate Bibliographer Name</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="BIBLIOGRAPHERID" id="BIBLIOGRAPHERID" size="1" query="ListBibliographers" value="CUSTOMERID" display="FULLNAME" required="No" tabindex="4"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="ALTERNATEBIBLIOGRAPHERID" id="ALTERNATEBIBLIOGRAPHERID" size="1" query="ListBibliographers" value="CUSTOMERID" display="FULLNAME" required="no" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT"><INPUT type="submit" name="ProcessBiblioDisciplines" value="ADD" tabindex="6" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processbibliodisciplinesinfo.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessBiblioDisciplines" value="CANCELADD" tabindex="7" /><BR />
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
*******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Bibliography Info. *
*******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
               <CFIF NOT IsDefined('URL.LOOKUPBIBLIODISCIPLINE')>
               	<H1>Modify/Delete Lookup Information for Web Reports - Bibliography Info</H1>
               <CFELSE>
               	<H1>Modify/Delete Lookup Information for Web Reports - Bibliography Info</H1>
               </CFIF>
               </TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPBIBLIODISCIPLINE')>
		<TR>
			<TH align="center">Bibliography/Disciplines Key &nbsp; = &nbsp; #FORM.BIBLIODISCIPLINEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPBIBLIODISCIPLINE')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/bibliodisciplinesinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPBIBLIODISCIPLINE=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="BIBLIODISCIPLINEID">*Discipline Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="BIBLIODISCIPLINEID" id="BIBLIODISCIPLINEID" size="1" query="ListBiblioDisciplines" value="BIBLIODISCIPLINEID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
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
********************************************************************************
* The following code is the Modify and Delete Processes for Bibliography Info. *
********************************************************************************
 --->

		<CFQUERY name="GetBiblioDisciplines" datasource="#application.type#WEBREPORTS">
			SELECT	BIBLIODISCIPLINEID, DISCIPLINEID, SUBDISCIPLINE, BIBLIOGRAPHERID, ALTERNATEBIBLIOGRAPHERID, BIBLIOACADEMICYEARID
			FROM		BIBLIODISCIPLINES
			WHERE	BIBLIODISCIPLINEID = <CFQUERYPARAM value="#FORM.BIBLIODISCIPLINEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DISCIPLINEID
		</CFQUERY>
		
		<CFQUERY name="GetAcademicYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
			SELECT	FISCALYEARID, FISCALYEAR_4DIGIT AS FISCALYEAR
			FROM		FISCALYEARS
			ORDER BY	FISCALYEAR
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/bibliodisciplinesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessBiblioDisciplines" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="BIBLIODISCIPLINES" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processbibliodisciplinesinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="BIBLIODISCIPLINEID" secure="NO" value="#FORM.BIBLIODISCIPLINEID#">
				<TH align="left"><LABEL for="BIBLIOACADEMICYEARID">Academic Year</LABEL></TH>
				<TH align="left">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="BIBLIOACADEMICYEARID" id="BIBLIOACADEMICYEARID" size="1" query="GetAcademicYears" value="FISCALYEARID" display="FISCALYEAR" selected="#GetBiblioDisciplines.BIBLIOACADEMICYEARID#" required="No" tabindex="2"></CFSELECT>
				</TD>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="DISCIPLINEID">*Discipline Name</LABEL></H4></TH>
				<TH align="left"><LABEL for="SUBDISCIPLINE">Sub-Discipline</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="DISCIPLINEID" id="DISCIPLINEID" size="1" query="ListDisciplines" value="DISCIPLINEID" display="DISCIPLINENAME" selected="#GetBiblioDisciplines.DISCIPLINEID#" required="No" tabindex="3"></CFSELECT>
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="SUBDISCIPLINE" id="SUBDISCIPLINE" value="#GetBiblioDisciplines.SUBDISCIPLINE#" align="LEFT" required="No" size="16" tabindex="4">
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="BIBLIOGRAPHERID">*Bibliographer Name</LABEL></H4></TH>
				<TH align="left"><LABEL for="ALTERNATEBIBLIOGRAPHERID">Alternate Bibliographer Name</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="BIBLIOGRAPHERID" id="BIBLIOGRAPHERID" size="1" query="ListBibliographers" value="CUSTOMERID" display="FULLNAME" selected="#GetBiblioDisciplines.BIBLIOGRAPHERID#" required="No" tabindex="5"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="ALTERNATEBIBLIOGRAPHERID" id="ALTERNATEBIBLIOGRAPHERID" size="1" query="ListBibliographers" value="CUSTOMERID" display="FULLNAME" selected="#GetBiblioDisciplines.ALTERNATEBIBLIOGRAPHERID#" required="no" tabindex="6"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" name="ProcessBiblioDisciplines" value="MODIFY" tabindex="7" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" name="ProcessBiblioDisciplines" value="DELETE" tabindex="8" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/bibliodisciplinesinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessBiblioDisciplines" value="Cancel" tabindex="9" /><BR />
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