<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: probsubcatsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/24/2012 --->
<!--- Date in Production: 05/24/2012 --->
<!--- Module: IDT Service Requests - Problem Sub-Categories Report --->
<!-- Last modified by John R. Pastori on 05/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/probsubcatsdbreport.cfm">
<CFSET CONTENT_UPDATED = "May 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Problem Sub-Categories Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListProblemSubCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	PROBLEMSUBCATEGORIES.SUBCATEGORYID, PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID, PROBLEMSUBCATEGORIES.SUBCATEGORYNAME,
			PROBLEMCATEGORIES.CATEGORYLETTER || ' ' || PROBLEMCATEGORIES.CATEGORYNAME AS SUBCATEGORYLETTER
	FROM		PROBLEMSUBCATEGORIES, PROBLEMCATEGORIES
	WHERE	PROBLEMSUBCATEGORIES.SUBCATEGORYID > 0 AND
			PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID = PROBLEMCATEGORIES.CATEGORYID
	ORDER BY	SUBCATEGORYLETTER, PROBLEMSUBCATEGORIES.SUBCATEGORYNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TD align="center"><H1>IDT Service Requests - Problem Sub-Categories Report</H1></TD>
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
		<TH align="center" colspan="2"><H2>#ListProblemSubCategories.RecordCount# Problem Sub-Category records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="center">Sub-Category Letter</TH>
		<TH align="left">Sub-Category</TH>
	</TR>

<CFLOOP query="ListProblemSubCategories">
	<TR>
		<TD align="center">#ListProblemSubCategories.SUBCATEGORYLETTER#</TD>
		<TD align="left">#ListProblemSubCategories.SUBCATEGORYNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="center" colspan="2"><H2>#ListProblemSubCategories.RecordCount# Problem Sub-Category records were selected.</H2></TH>
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