<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: nostatdeptsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/05/2007 --->
<!--- Date in Production: 01/05/2007 --->
<!--- Module: Instruction - Departments with No Orientation Statistics Report --->
<!-- Last modified by John R. Pastori on 01/05/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/nostatdeptsreport.cfm">
<CFSET CONTENT_UPDATED = "January 05, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Departments with No Orientation Statistics Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfquery name="LookupCurrentAcademicYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTACADEMICYEAR = 'YES')
	ORDER BY	FISCALYEARID
</cfquery>

<cfquery name="ListAcademicYears" datasource="#application.type#LIBSHAREDDATA" BLOCKFACTOR="59">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
	FROM		FISCALYEARS
	WHERE	FISCALYEARID > 17 AND
			FISCALYEARID <= #LookupCurrentAcademicYear.FISCALYEARID#
	ORDER BY	FISCALYEAR_4DIGIT
</cfquery>

<cfoutput>
<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Departments with No Orientation Statistics Report</H1></TD>
	</TR>
</TABLE>
<BR />

<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
<!--- </CFOUTPUT> --->
<CFLOOP QUERY="ListAcademicYears">
	<CFSET CLIENT.ACADEMICYEARKEY = #ListAcademicYears.FISCALYEARID#>
	<!--- CLIENT ACADEMIC YEAR KEY = #CLIENT.ACADEMICYEARKEY#<BR> --->
	<cfquery name="ListDepartments" DATASOURCE="#application.type#INSTRUCTION" BLOCKFACTOR="100">
		SELECT	DEPARTMENTID, DEPARTMENTNAME
		FROM		DEPARTMENTS
		WHERE	DEPARTMENTID > 0
		ORDER BY	DEPARTMENTNAME
	</cfquery>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>Academic Year: &nbsp;&nbsp;#ListAcademicYears.FISCALYEAR_4DIGIT#</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Department Name</TH>
		<TH ALIGN="left">Department Record Number</TH>
	</TR>

	<CFSET NOSTATDEPTRECCOUNT = 0>
	<CFLOOP QUERY="ListDepartments">
		<cfquery name="LookupOrientStats" datasource="#application.type#INSTRUCTION">
			SELECT	OS.ORIENTSTATSID, OS.DEPARTMENTID, OS.ACADEMICYEARID
			FROM		ORIENTSTATS OS
			WHERE	OS.ACADEMICYEARID = <CFQUERYPARAM VALUE="#CLIENT.ACADEMICYEARKEY#" CFSQLTYPE="CF_SQL_NUMERIC"> AND
					OS.DEPARTMENTID = <CFQUERYPARAM VALUE="#ListDepartments.DEPARTMENTID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	OS.ACADEMICYEARID
		</cfquery>

		<CFIF #LookupOrientStats.RecordCount# EQ 0>
			<CFSET NOSTATDEPTRECCOUNT = #NOSTATDEPTRECCOUNT# + 1>
	<TR>
		<TD ALIGN="left">#ListDepartments.DEPARTMENTNAME#</TD>
		<TD ALIGN="left">#NOSTATDEPTRECCOUNT#</TD>
	</TR>
		</CFIF>
	</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2">
			#NOSTATDEPTRECCOUNT# Departments had NO Statistics for Academic Year: #ListAcademicYears.FISCALYEAR_4DIGIT# 
		</TH>
	</TR>
	<TR>
		<TD ALIGN="left" COLSPAN="2">
			<HR align="left" width="100%" size="5" noshade />
		</TD>
	</TR>
</CFLOOP>
<!--- <CFOUTPUT> --->
	<TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD ALIGN="left" COLSPAN="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>