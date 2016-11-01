<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: dbsystemsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2011 --->
<!--- Date in Production: 06/23/2011 --->
<!--- Module:  Library Security - Database Systems Report --->
<!-- Last modified by John R. Pastori on 06/23/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/dbsystemsdbreport.cfm">
<CFSET CONTENT_UPDATED = "June 23, 2011">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Library Security - Database Systems Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>
<cfquery name="ListDatabaseSystems" DATASOURCE="#application.type#LIBSECURITY" BLOCKFACTOR="12">
	SELECT	DBSYSTEMID, DBSYSTEMNUMBER, DBSYSTEMNAME, DBSYSTEMDIRECTORY, DBSYSTEMGROUP
	FROM		DBSYSTEMS
	WHERE	DBSYSTEMID > 0
	ORDER BY	DBSYSTEMNAME
</cfquery>

<TABLE width="100%" align="left" BORDER="3">
	<TR>
		<TD align="center"><H1>Library Security - Database Systems Report</H1></TD>
	</TR>
</TABLE>
<BR /><BR /><BR /><BR />
<TABLE width="100%" border="0" align="left" VALIGN="top" CELLPADDING="0" CELLSPACING="0">
	<TR>
<cfform action="/#application.type#apps/libsecurity/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" VALIGN="TOP" COLSPAN="4">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="left" COLSPAN="4"><H2>#ListDatabaseSystems.RecordCount# Database System records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="center">Database System Number</TH>
		<TH ALIGN="left">Database System</TH>
          <TH ALIGN="left">Database System Directory</TH>
		<TH ALIGN="center">Database System Group</TH>
	</TR>

<CFLOOP QUERY="ListDatabaseSystems">
	<TR>
		<TD ALIGN="center">#ListDatabaseSystems.DBSYSTEMNUMBER#</TD>
		<TD ALIGN="left">#ListDatabaseSystems.DBSYSTEMNAME#</TD>
          <TD ALIGN="left">#ListDatabaseSystems.DBSYSTEMDIRECTORY#</TD>
		<TD ALIGN="center">#ListDatabaseSystems.DBSYSTEMGROUP#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="left" COLSPAN="4"><H2>#ListDatabaseSystems.RecordCount# Database System records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/libsecurity/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" VALIGN="TOP" COLSPAN="4">
			<INPUT type="SUBMIT" value="Cancel" tabindex="2" />&nbsp;&nbsp;
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