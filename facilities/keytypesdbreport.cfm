<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: keytypesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/25/2012 --->
<!--- Date in Production: 01/25/2012 --->
<!--- Module: Facilities - Key Types Report --->
<!-- Last modified by John R. Pastori on 01/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/keytypesdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 25, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Key Types Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<cfquery name="ListKeyTypes" DATASOURCE="#application.type#FACILITIES" BLOCKFACTOR="6">
	SELECT	KEYTYPEID, KEYTYPENAME
	FROM		KEYTYPES
	WHERE	KEYTYPEID > 0
	ORDER BY	KEYTYPENAME
</cfquery>
<cfoutput>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Key Types Report</H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="left" colspan="2"><INPUT type="submit" value="Cancel" tabindex="1"></TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" colspan="2"><H2>#ListKeyTypes.RecordCount# Key Type records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Key Type Name</TH>
          <TH ALIGN="left">Key Type Record Keys</TH>
	</TR>

<CFLOOP QUERY="ListKeyTypes">
	<TR>
		<TD ALIGN="left">#ListKeyTypes.KEYTYPENAME#</TD>
          <TD ALIGN="left">#ListKeyTypes.KEYTYPEID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" colspan="2"><H2>#ListKeyTypes.RecordCount# Key Type records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="left" colspan="2"><INPUT type="submit" value="Cancel" tabindex="2"></TD>
</cfform>
	</TR>
	<TR>
		<TD align="left" colspan="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR><BR>
</cfoutput>
</BODY>
</HTML>