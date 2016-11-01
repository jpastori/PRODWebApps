<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: monthsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Shared Data - Months Report --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/monthsdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Shared Data - Months Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListMonths" DATASOURCE="#application.type#LIBSHAREDDATA" BLOCKFACTOR="12">
	SELECT	MONTHID, MONTHNAME, MONTHNUMBERASCHAR
	FROM		MONTHS
	WHERE	MONTHID > 0
	ORDER BY	MONTHID
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Shared Data - Months Report</H1></TD>
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
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListMonths.RecordCount# Month records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="center">Month Number</TH>
		<TH ALIGN="left">Month Name</TH>
	</TR>

<CFLOOP QUERY="ListMonths">
	<TR>
		<TD ALIGN="center">#ListMonths.MONTHNUMBERASCHAR#</TD>
		<TD ALIGN="left">#ListMonths.MONTHNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListMonths.RecordCount# Month records were selected.</H2></TH>
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
		<TD COLSPAN="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>