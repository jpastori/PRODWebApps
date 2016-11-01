<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: pdsubtopicdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Web Reports - Public Desk SubTopics Report --->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/pdsubtopicdbreport.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Public Desk SubTopics Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListPDSubTopic" datasource="#application.type#WEBREPORTS" blockfactor="30">
	SELECT	SUBTOPICID, SUBTOPIC
	FROM		PDSUBTOPIC
	WHERE	SUBTOPICID > 0
	ORDER BY	SUBTOPIC
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Web Reports - Public Desk SubTopics Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE border="0" align="center">
	<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER"><H2>#ListPDSubTopic.RecordCount# Public Desk SubTopic records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="LEFT">Public Desk SubTopics</TH>
	</TR>

<CFLOOP query="ListPDSubTopic">
	<TR>
		<TD align="LEFT">#ListPDSubTopic.SUBTOPIC#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER"><H2>#ListPDSubTopic.RecordCount# Public Desk SubTopic records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
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