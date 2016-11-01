 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: sdsucourses.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/28/2009 --->
<!--- Date in Production: 01/28/2009 --->
<!--- Module: Add/Modify/Delete Information to Instruction - SDSU Courses --->
<!-- Last modified by John R. Pastori on 01/28/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/sdsucourses.cfm">
<CFSET CONTENT_UPDATED = "January 28, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - SDSU Courses</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - SDSU Courses</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Instruction Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.COURSES.COURSENUMBER.value == "" || document.COURSES.COURSENUMBER.value == " ") {
			alertuser (document.COURSES.COURSENUMBER.name +  ",  A Course Number MUST be entered!");
			document.COURSES.COURSENUMBER.focus();
			return false;
		}

		if (document.COURSES.COURSENAME.value == "" || document.COURSES.COURSENAME.value == " ") {
			alertuser (document.COURSES.COURSENAME.name +  ",  A Course Name MUST be entered!");
			document.COURSES.COURSENAME.focus();
			return false;
		}

		if (document.COURSES.PROFESSORID.selectedIndex == "0") {
			alertuser ("A Professor Name MUST be selected!");
			document.COURSES.PROFESSORID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.COURSEID.selectedIndex == "0") {
			alertuser ("A Course MUST be selected!");
			document.LOOKUP.COURSEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCOURSE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.COURSEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.COURSES.COURSENUMBER.focus()">
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

<CFQUERY name="ListSDSUCourses" datasource="#application.type#INSTRUCTION" blockfactor="100">
	SELECT	COURSEID, COURSENUMBER, COURSENAME, PROFESSORID
	FROM		SDSUCOURSES
	ORDER BY	COURSEID
</CFQUERY>

<BR clear="left" />

<!--- 
**********************************************************
* The following code is the ADD Process for SDSU Courses.*
**********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - SDSU Courses</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION" dbtype="ORACLE80">
		SELECT	MAX(COURSEID) AS MAX_ID
		FROM		SDSUCOURSES
	</CFQUERY>
	<CFSET FORM.COURSEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="COURSEID" secure="NO" value="#FORM.COURSEID#">
	<CFQUERY name="AddSDSUCoursesID" datasource="#application.type#INSTRUCTION" dbtype="ORACLE80">
		INSERT INTO	SDSUCOURSES (COURSEID)
		VALUES		(#val(Cookie.COURSEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				SDSU Courses Key &nbsp; = &nbsp; #FORM.COURSEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
	<CFFORM action="/#application.type#apps/instruction/processsdsucourses.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessSDSUCourses" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
	</CFFORM>
		</TR>
	<CFFORM name="COURSES" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processsdsucourses.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="COURSENUMBER">*Course Number</label></H4></TH>
			<TH align="left"><H4><LABEL for="COURSENAME">*Course Name</label></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="COURSENUMBER" id="COURSENUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="COURSENAME" id="COURSENAME" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PROFESSORID">*Professor Name</label></H4></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" width="70%">
					<CFSELECT name="PROFESSORID" id="PROFESSORID" size="1" query="ListProfessor" value="PROFESSORID" display="PROFESSORNAME" required="No" tabindex="4"></CFSELECT>
				</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessSDSUCourses" value="ADD" tabindex="5" /></TD>
		</TR>
	</CFFORM>
		<TR>
	<CFFORM action="/#application.type#apps/instruction/processsdsucourses.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessSDSUCourses" value="CANCELADD" tabindex="6" /><BR />
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
*************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting SDSU Courses.*
*************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPCOURSE')>
			<TD align="center"><H1>Lookup for Modify/Delete Information to Instruction - SDSU Courses</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to Instruction - SDSU Courses</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPCOURSE')>
		<TR>
			<TH align="center">SDSU Courses Key &nbsp; = &nbsp; #FORM.COURSEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCOURSE')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/sdsucourses.cfm?PROCESS=#URL.PROCESS#&LOOKUPCOURSE=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="COURSEID">*Course Name:</label></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="COURSEID" id="COURSEID" size="1" query="ListSDSUCourses" value="COURSEID" display="COURSENAME" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
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
**************************************************************************
* The following code is the Modify and Delete Processes for SDSU Courses.*
**************************************************************************
 --->

		<CFQUERY name="GetSDSUCourses" datasource="#application.type#INSTRUCTION">
			SELECT	COURSEID, COURSENUMBER, COURSENAME, PROFESSORID
			FROM		SDSUCOURSES
			WHERE	COURSEID = <CFQUERYPARAM value="#FORM.COURSEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	COURSEID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/instruction/sdsucourses.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessSDSUCourses" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="COURSES" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processsdsucourses.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="COURSEID" secure="NO" value="#FORM.COURSEID#">
				<TH align="left"><H4><LABEL for="COURSENUMBER">*Course Number</label></H4></TH>
				<TH align="left"><H4><LABEL for="COURSENAME">*Course Name</label></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="COURSENUMBER" id="COURSENUMBER" value="#GetSDSUCourses.COURSENUMBER#" align="LEFT" required="No" size="25" maxlength="50" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="COURSENAME" id="COURSENAME" value="#GetSDSUCourses.COURSENAME#" align="LEFT" required="No" size="25" maxlength="50" tabindex="3"></TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="PROFESSORID">*Professor Name</label></H4></TH>
				<TH align="left">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left" width="70%">
					<CFSELECT name="PROFESSORID" id="PROFESSORID" size="1" query="ListProfessor" value="PROFESSORID" display="PROFESSORNAME" selected="#GetSDSUCourses.PROFESSORID#" required="No" tabindex="4"></CFSELECT>
				</TD>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessSDSUCourses" value="MODIFY" tabindex="5" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessSDSUCourses" value="DELETE" tabindex="6" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/sdsucourses.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessSDSUCourses" value="Cancel" tabindex="7" /><BR />
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