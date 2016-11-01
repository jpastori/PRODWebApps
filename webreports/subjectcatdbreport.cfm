<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: subjectcatdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/19/2007 --->
<!--- Date in Production: 01/19/2007 --->
<!--- Module: Web Reports - Article DB Site Subject Categories Report --->
<!-- Last modified by John R. Pastori on 01/19/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/subjectcatdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 19, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Article DB Site Subject Categories Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListSubjectCategories" DATASOURCE="#application.type#WEBREPORTS" BLOCKFACTOR="50">
	SELECT	SUBJECTCATID, SUBJECTCATNAME, SUBJECTCATURL, SUBJECTCATCOMMENTS
	FROM		SUBJECTCATEGORIES
	WHERE	SUBJECTCATID > 0
	ORDER BY	SUBJECTCATNAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Web Reports - Article DB Site Subject Categories Report</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="LEFT">
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="3">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="3"><H2>#ListSubjectCategories.RecordCount# Article DB Site Subject Category records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="LEFT">Subject Category Name</TH>
		<TH ALIGN="LEFT">Subject Categories URL</TH>
		<TH ALIGN="LEFT">Subject Categories Comment</TH>
	</TR>

<CFLOOP QUERY="ListSubjectCategories">
	<TR>
		<TD ALIGN="LEFT" NOWRAP><DIV>#ListSubjectCategories.SUBJECTCATNAME#</DIV></TD>
		<TD ALIGN="LEFT" NOWRAP><DIV>#ListSubjectCategories.SUBJECTCATURL#</DIV></TD>
		<TD ALIGN="LEFT" NOWRAP><DIV>#ListSubjectCategories.SUBJECTCATCOMMENTS#</DIV></TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="3"><H2>#ListSubjectCategories.RecordCount# Article DB Site Subject Category records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="3">
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