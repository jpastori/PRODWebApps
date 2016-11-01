<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: yearmonthdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/19/2007 --->
<!--- Date in Production: 01/19/2007 --->
<!--- Module: Web Reports - Article DB Year-Month Report --->
<!-- Last modified by John R. Pastori on 01/19/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME="John R. Pastori">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/webreports/yearmonthdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 19, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Article DB Year-Month Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListYearMonth" DATASOURCE="#application.type#WEBREPORTS" BLOCKFACTOR="41">
	SELECT	YEARMONTHID, YEARMONTHNAME
	FROM		YEARMONTH
	WHERE	YEARMONTHID > 0
	ORDER BY	YEARMONTHNAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Web Reports - Article DB Year-Month Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/webreports/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListYearMonth.RecordCount# Year-Month records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="CENTER">Year-Month Name</TH>
	</TR>

<CFLOOP QUERY="ListYearMonth">
	<TR>
		<TD ALIGN="CENTER">#ListYearMonth.YEARMONTHNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListYearMonth.RecordCount# Year-Month records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/webreports/index.cfm?logout=No" METHOD="POST">
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