<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqsubgroupsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/13/2007 --->
<!--- Date in Production: 01/13/2007 --->
<!--- Module: LibQual - LibQual SubGroups Report --->
<!-- Last modified by John R. Pastori on 01/13/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqsubgroupsdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 13, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>LibQual - LibQual SubGroups Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListLQSubGroups" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="57">
	SELECT	LQSG.LQSUBGROUPID, LQSG.LQGROUPNAMEID, LQG.GROUPNAME, LQSG.SUBGROUPFIELDNAME, LQSG.SUBGROUPNAME
	FROM		LQSUBGROUPS LQSG, LQGROUPS LQG
	WHERE	LQSUBGROUPID > 0 AND
			LQSG.LQGROUPNAMEID = LQG.LQGROUPID
	ORDER BY	LQG.GROUPNAME, LQSG.SUBGROUPNAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>LibQual - LibQual SubGroups Report</H1></TD>
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
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListLQSubGroups.RecordCount# LibQual SubGroup records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="LEFT">LibQual SubGroup Field Name</TH>
		<TH ALIGN="LEFT">LibQual SubGroup Name</TH>
	</TR>
<CFSET FIELDNAME = 'ListLQSubGroups.GROUPNAME'>
<CFSET COMPAREHEADER =  "">
<CFSET REPORTHEADER = "">
<CFLOOP QUERY="ListLQSubGroups">
	<CFSET COMPAREHEADER = #Evaluate("#FIELDNAME#")#>
	<CFIF REPORTHEADER NEQ #COMPAREHEADER#>
		<CFSET REPORTHEADER = #COMPAREHEADER#>
	<TR>
		<TD ALIGN="CENTER" COLSPAN="2"><HR SIZE="5" NOSHADE /></TD>
	</TR>
	<TR>
		<TH align="left"><H2>#REPORTHEADER#</H2></TH>
	</TR>
	</CFIF>
	<TR>
		<TD ALIGN="LEFT">#ListLQSubGroups.SUBGROUPFIELDNAME#</TD>
		<TD ALIGN="LEFT">#ListLQSubGroups.SUBGROUPNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TD ALIGN="CENTER" COLSPAN="2"><HR SIZE="5" NOSHADE /></TD>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListLQSubGroups.RecordCount# LibQual SubGroup records were selected.</H2></TH>
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
		<TD COLSPAN="3">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>