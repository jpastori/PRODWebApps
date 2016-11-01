<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: affiliationdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/08/2007 --->
<!--- Date in Production: 10/08/2007 --->
<!--- Module: Instruction - Affiliation Report --->
<!-- Last modified by John R. Pastori on 10/08/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/affiliationdbreport.cfm">
<CFSET CONTENT_UPDATED = "October 08, 2007">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Affiliation Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<BODY>

<CFQUERY name="ListAffiliation" datasource="#application.type#INSTRUCTION" blockfactor="3">
	SELECT	AFFILIATIONID, AFFILIATIONNAME
	FROM		AFFILIATION
	WHERE	AFFILIATIONID > 0
	ORDER BY	AFFILIATIONNAME
</CFQUERY>

<CFOUTPUT>
<TABLE width="100%" border="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Affiliation Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER"><H2>#ListAffiliation.RecordCount# Affiliation records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Affiliation Name</TH>
	</TR>

<CFLOOP query="ListAffiliation">
	<TR>
		<TD align="left">#ListAffiliation.AFFILIATIONNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER"><H2>#ListAffiliation.RecordCount# Affiliation records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>

</CFOUTPUT>
</BODY>
</HTML>