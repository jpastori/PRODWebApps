<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: sdsucoursesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/04/2007 --->
<!--- Date in Production: 01/04/20076 --->
<!--- Module: Instruction - SDSU Courses Report --->
<!-- Last modified by John R. Pastori on 01/04/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/sdsucoursesdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 04, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - SDSU Courses Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfquery name="ListSDSUCourses" DATASOURCE="#application.type#INSTRUCTION" BLOCKFACTOR="100">
	SELECT	SC.COURSEID, SC.COURSENUMBER, SC.COURSENAME, SC.PROFESSORID, P.PROFESSORNAME
	FROM		SDSUCOURSES SC, PROFESSORS P
	WHERE	COURSEID > 0 AND
			SC.PROFESSORID = P.PROFESSORID
	ORDER BY	COURSEID
</cfquery>

<cfoutput>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - SDSU Courses Report</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="4"><H2>#ListSDSUCourses.RecordCount# SDSU Course records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="center">Course Number</TH>
		<TH ALIGN="center">Course Name</TH>
		<TH ALIGN="center">Professor Name</TH>
	</TR>

<CFLOOP QUERY="ListSDSUCourses">
	<TR>
		<TD ALIGN="center">#ListSDSUCourses.COURSENUMBER#</TD>
		<TD ALIGN="center">#ListSDSUCourses.COURSENAME#</TD>
		<TD ALIGN="center">#ListSDSUCourses.PROFESSORNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="3"><H2>#ListSDSUCourses.RecordCount# SDSU Course records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD COLSPAN="3">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>