<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hasstatdeptsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/05/2007 --->
<!--- Date in Production: 01/05/2007 --->
<!--- Module: Instruction - Departments with Orientation Statistics Report --->
<!-- Last modified by John R. Pastori on 01/05/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/hasstatdeptsreport.cfm">
<CFSET CONTENT_UPDATED = "January 05, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Departments with Orientation Statistics Report</TITLE>
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

<cfset DepartmentsQuery = QueryNew("ACADEMICYEAR, DEPARTMENTNAME, STATDEPTRECCOUNT")>
<CFLOOP QUERY="ListAcademicYears">

	<CFSET CLIENT.ACADEMICYEARKEY = #ListAcademicYears.FISCALYEARID#>
	<CFSET CLIENT.ACADEMICYEAR = #ListAcademicYears.FISCALYEAR_4DIGIT#>
	<!--- CLIENT ACADEMIC YEAR KEY = #CLIENT.ACADEMICYEARKEY# - CLIENT ACADEMIC YEAR = #CLIENT.ACADEMICYEAR#<BR> --->
	
	<cfquery name="ListDepartments" DATASOURCE="#application.type#INSTRUCTION" BLOCKFACTOR="100">
		SELECT	DEPARTMENTID, DEPARTMENTNAME
		FROM		DEPARTMENTS
		WHERE	DEPARTMENTID > 0
		ORDER BY	DEPARTMENTNAME
	</cfquery>

	<CFLOOP QUERY="ListDepartments">
		<cfquery name="LookupOrientStats" datasource="#application.type#INSTRUCTION">
			SELECT	OS.ORIENTSTATSID, OS.DEPARTMENTID, OS.ACADEMICYEARID
			FROM		ORIENTSTATS OS
			WHERE	OS.ACADEMICYEARID = <CFQUERYPARAM VALUE="#CLIENT.ACADEMICYEARKEY#" CFSQLTYPE="CF_SQL_NUMERIC"> AND
					OS.DEPARTMENTID = <CFQUERYPARAM VALUE="#ListDepartments.DEPARTMENTID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	OS.ACADEMICYEARID
		</cfquery>

		<CFIF LookupOrientStats.RecordCount GT 0>
			<cfset temp = QueryAddRow(DepartmentsQuery)>
			<cfset temp = QuerySetCell(DepartmentsQuery, "ACADEMICYEAR", #CLIENT.ACADEMICYEAR#)>
			<cfset temp = QuerySetCell(DepartmentsQuery, "DEPARTMENTNAME", #ListDepartments.DEPARTMENTNAME#)>
			<cfset temp = QuerySetCell(DepartmentsQuery, "STATDEPTRECCOUNT", #LookupOrientStats.RecordCount#)>
		</CFIF>
	</CFLOOP>
</CFLOOP>

<!--- <cfdump var=#DepartmentsQuery#> --->

<cfquery name="ListStatDepartments" DBTYPE="QUERY" BLOCKFACTOR="100">
	SELECT	ACADEMICYEAR, DEPARTMENTNAME, STATDEPTRECCOUNT
	FROM		DepartmentsQuery
	ORDER BY	ACADEMICYEAR, STATDEPTRECCOUNT DESC, DEPARTMENTNAME
</cfquery>

<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Departments with Orientation Statistics Report</H1></TD>
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
	<TR>
		<TH ALIGN="left">Department Name</TH>
		<TH ALIGN="left">Department Statistic Record Count</TH>
	</TR>

	<CFSET CLIENT.STATDEPTRECCOUNT = 0>
	<CFSET STATRECCOUNT = 0>
	<CFSET ACADYRTITLE = "">

<CFLOOP QUERY="ListStatDepartments">

	<CFIF ACADYRTITLE NEQ #ListStatDepartments.ACADEMICYEAR#>
		<CFIF STATRECCOUNT GT 0>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2">
			#STATRECCOUNT# Departments had Statistics for Academic Year: #ACADYRTITLE#.<BR />
			#CLIENT.STATDEPTRECCOUNT# Statistics Records were created.
		</TH>
			<CFSET CLIENT.STATDEPTRECCOUNT = 0>
			<CFSET STATRECCOUNT = 0>
	</TR>
		</CFIF>
		<CFSET ACADYRTITLE = #ListStatDepartments.ACADEMICYEAR#>
	<TR>
		<TD ALIGN="left" COLSPAN="2">
			<HR align="left" width="100%" size="5" noshade />
		</TD>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>Academic Year: &nbsp;&nbsp;#ListStatDepartments.ACADEMICYEAR#</H2></TH>
	</TR> 
	</CFIF>
	<TR>
		<TD ALIGN="left">#ListStatDepartments.DEPARTMENTNAME#</TD>
		<TD ALIGN="left">#ListStatDepartments.STATDEPTRECCOUNT#</TD>
	</TR>
		<CFSET CLIENT.STATDEPTRECCOUNT = #CLIENT.STATDEPTRECCOUNT# + #ListStatDepartments.STATDEPTRECCOUNT#>
		<CFSET STATRECCOUNT = #STATRECCOUNT# + 1>
	<tr>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2">
			#STATRECCOUNT# Departments had Statistics for Academic Year: #ACADYRTITLE#.<BR />
			#CLIENT.STATDEPTRECCOUNT# Statistics Records were created.
		</TH>
	</TR>
	<TR>
		<TD ALIGN="left" COLSPAN="2">
			<HR align="left" width="100%" size="5" noshade />
		</TD>
	</TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</tr>
	<TR>
		<TD ALIGN="left" COLSPAN="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>