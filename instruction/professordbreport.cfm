<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: professordbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/04/2007 --->
<!--- Date in Production: 01/04/2007 --->
<!--- Module: Instruction - Professor Report --->
<!-- Last modified by John R. Pastori on 01/04/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/professordbreport.cfm">
<CFSET CONTENT_UPDATED = "January 04, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Professor Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfquery name="ListProfessor" DATASOURCE="#application.type#INSTRUCTION" BLOCKFACTOR="100">
	SELECT	PROFESSORID, PROFESSORNAME
	FROM		PROFESSORS
	WHERE	PROFESSORID > 0
	ORDER BY	PROFESSORNAME
</cfquery>

<cfoutput>
<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Professor Report</H1></TD>
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
		<TH ALIGN="CENTER"><H2>#ListProfessor.RecordCount# Professor records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Professor Name</TH>
	</TR>

<CFLOOP QUERY="ListProfessor">
	<TR>
		<TD ALIGN="left">#ListProfessor.PROFESSORNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListProfessor.RecordCount# Professor records were selected.</H2></TH>
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
		<TD ALIGN="left"
<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		></TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>