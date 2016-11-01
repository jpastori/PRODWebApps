<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: marketingdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/13/2006 --->
<!--- Date in Production: 12/13/2006 --->
<!--- Module: Instruction - Marketing Report --->
<!-- Last modified by John R. Pastori on 12/13/2006 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/marketingdbreport.cfm">
<CFSET CONTENT_UPDATED = "December 13, 2006">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Marketing Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<BODY>

<cfquery name="ListMarketing" DATASOURCE="#application.type#INSTRUCTION" BLOCKFACTOR="4">
	SELECT	MARKETINGID, MARKETINGTYPE
	FROM		MARKETING
	WHERE	MARKETINGID > 0
	ORDER BY	MARKETINGTYPE
</cfquery>

<cfoutput>
<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Marketing Report</H1></TD>
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
		<TH ALIGN="CENTER"><H2>#ListMarketing.RecordCount# Marketing records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Marketing Type</TH>
	</TR>

<CFLOOP QUERY="ListMarketing">
	<TR>
		<TD ALIGN="left">#ListMarketing.MARKETINGTYPE#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListMarketing.RecordCount# Marketing records were selected.</H2></TH>
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
		<TD ALIGN="left">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>

</cfoutput>
</BODY>
</HTML>