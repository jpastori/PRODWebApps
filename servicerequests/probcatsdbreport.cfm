<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: probcatsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/24/2012 --->
<!--- Date in Production: 05/24/2012 --->
<!--- Module:  IDT Service Requests - Problem Categories Report --->
<!-- Last modified by John R. Pastori on 03/03/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/probcatsdbreport.cfm">
<CFSET CONTENT_UPDATED = "March 03, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Problem Categories Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListProblemCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="14">
	SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME
	FROM		PROBLEMCATEGORIES
	WHERE	CATEGORYID > 0
	ORDER BY	CATEGORYLETTER
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TD align="center"><H1>IDT Service Requests - Problem Categories Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="center" colspan="2"><H2>#ListProblemCategories.RecordCount# Problem Category records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="center">Category Letter</TH>
		<TH align="left">Category</TH>
	</TR>

<CFLOOP query="ListProblemCategories">
	<TR>
		<TD align="center">#ListProblemCategories.CATEGORYLETTER#</TD>
		<TD align="left">#ListProblemCategories.CATEGORYNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="center" colspan="2"><H2>#ListProblemCategories.RecordCount# Problem Category records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="2">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>