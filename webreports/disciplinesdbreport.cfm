<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: disciplinesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/19/2007 --->
<!--- Date in Production: 01/19/2007 --->
<!--- Module: Web Reports - Disciplines Report--->
<!-- Last modified by John R. Pastori on 01/19/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/disciplinesdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 19, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Web Reports - Disciplines Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<!--- 
*************************************************************************************************
* The following code is the Report Generation Process for the Web Reports - Disciplines Report. *
*************************************************************************************************
 --->

<cfquery name="ListDisciplines" DATASOURCE="#application.type#WEBREPORTS" BLOCKFACTOR="91">
	SELECT	DISCIPLINEID, DISCIPLINENAME
	FROM		DISCIPLINES
	WHERE	DISCIPLINEID > 0
	ORDER BY	DISCIPLINENAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR>
		<TD align="center"><H1>Web Reports - Disciplines Report</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="LEFT">
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListDisciplines.RecordCount# Discipline records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Discipline Name</TH>
	</TR>

<CFLOOP QUERY="ListDisciplines">
	<TR>
		<TD ALIGN="left">#ListDisciplines.DISCIPLINENAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListDisciplines.RecordCount# Discipline records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
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