<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: fiscalyearsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Shared Data - Fiscal/Academic Years Report --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/fiscalyearsdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Shared Data - Fiscal/Academic Years Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListFiscalYears" DATASOURCE="#application.type#LIBSHAREDDATA" BLOCKFACTOR="75">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
	FROM		FISCALYEARS
	WHERE	FISCALYEARID > 0
	ORDER BY	FISCALYEARID
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Shared Data - Fiscal/Academic Years Report</H1></TD>
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
		<TH ALIGN="CENTER" COLSPAN="4"><H2>#ListFiscalYears.RecordCount# Fiscal/Academic Year records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="center">Fiscal Year - 2 Digits</TH>
		<TH ALIGN="center">Fiscal Year - 4 Digits</TH>
		<TH ALIGN="center">Current Fiscal Year Flag</TH>
		<TH ALIGN="left">Current Academic Year Flag</TH>
	</TR>

<CFLOOP QUERY="ListFiscalYears">
	<TR>
		<TD ALIGN="center">#ListFiscalYears.FISCALYEAR_2DIGIT#</TD>
		<TD ALIGN="center">#ListFiscalYears.FISCALYEAR_4DIGIT#</TD>
		<TD ALIGN="center">#ListFiscalYears.CURRENTFISCALYEAR#</TD>
		<TD ALIGN="center">#ListFiscalYears.CURRENTACADEMICYEAR#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="4"><H2>#ListFiscalYears.RecordCount# Fiscal/Academic Year records were selected.</H2></TH>
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
		<TD COLSPAN="4">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>