<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqgroupsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/13/2007 --->
<!--- Date in Production: 01/13/2007 --->
<!--- Module: LibQual - LibQual Groups Report --->
<!-- Last modified by John R. Pastori on 01/13/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqgroupsdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 13, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>LibQual - LibQual Groups Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListLQGroups" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="6">
	SELECT	LQGROUPID, GROUPFIELDNAME, GROUPNAME
	FROM		LQGROUPS
	WHERE	LQGROUPID > 0
	ORDER BY	GROUPNAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>LibQual - LibQual Groups Report</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="LEFT">
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListLQGroups.RecordCount# LibQual Group records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="LEFT">LibQual Group Field Name</TH>
		<TH ALIGN="LEFT">LibQual Group Name</TH>
	</TR>

<CFLOOP QUERY="ListLQGroups">
	<TR>
		<TD ALIGN="LEFT">#ListLQGroups.GROUPFIELDNAME#</TD>
		<TD ALIGN="LEFT">#ListLQGroups.GROUPNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListLQGroups.RecordCount# LibQual Group records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
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