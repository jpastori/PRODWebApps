<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: departmentdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/05/2007 --->
<!--- Date in Production: 01/05/2007 --->
<!--- Module: Instruction - Departments Report --->
<!-- Last modified by John R. Pastori on 01/05/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/departmentdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 05, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Departments Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfquery name="ListDepartments" DATASOURCE="#application.type#INSTRUCTION" BLOCKFACTOR="100">
	SELECT	DEPARTMENTID, DEPARTMENTNAME, BROADAFFILIATION
	FROM		DEPARTMENTS
	WHERE	DEPARTMENTID > 0
	ORDER BY	DEPARTMENTNAME
</cfquery>

<cfoutput>
<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Departments Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListDepartments.RecordCount# Department records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Department Name</TH>
		<TH ALIGN="left">Broad Affiliation</TH>
	</TR>

<CFLOOP QUERY="ListDepartments">
	<TR>
		<TD ALIGN="left">#ListDepartments.DEPARTMENTNAME#</TD>
		<TD ALIGN="left">#ListDepartments.BROADAFFILIATION#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListDepartments.RecordCount# Department records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/instruction/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD ALIGN="left">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>