<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: checkedinitialsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/13/2007 --->
<!--- Date in Production: 01/13/2007 --->
<!--- Module: LibQual - Checked Initials Report --->
<!-- Last modified by John R. Pastori on 01/13/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/checkedinitialsdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 13, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>LibQual - Checked Initials Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>
<cfquery name="ListCheckedInitials" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="11">
	SELECT	CHECKEDINITID, INITIALS
	FROM		LQCHECKEDINITIALS
	WHERE	CHECKEDINITID > 0
	ORDER BY	INITIALS
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>LibQual - Checked Initials Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/libqual/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListCheckedInitials.RecordCount# Checked Initials records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="center">Initials</TH>
	</TR>

<CFLOOP QUERY="ListCheckedInitials">
	<TR>
		<TD ALIGN="center">#ListCheckedInitials.INITIALS#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListCheckedInitials.RecordCount# Checked Initials records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/libqual/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD align="left">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>