<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: departmentsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Shared Data - Departments Report --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/departmentsdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Shared Data - Departments Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListDepartments" DATASOURCE="#application.type#LIBSHAREDDATA" BLOCKFACTOR="11">
	SELECT	DEPARTMENTID, DEPARTMENTNAME
	FROM		DEPARTMENTS
	WHERE	DEPARTMENTID > 0
	ORDER BY	DEPARTMENTNAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Shared Data - Departments Report</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/libshareddata/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<BR /><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListDepartments.RecordCount# Department records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Department Name</TH>
	</TR>

<CFLOOP QUERY="ListDepartments">
	<TR>
		<TD ALIGN="left">#ListDepartments.DEPARTMENTNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListDepartments.RecordCount# Department records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/libshareddata/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<BR /><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
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