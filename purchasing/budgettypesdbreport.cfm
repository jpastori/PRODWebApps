<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: budgettypesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: IDT Purchasing - Budget Types Report --->
<!-- Last modified by John R. Pastori on 07/09/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/budgettypesdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 09, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchasing - Budget Types Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListBudgetTypes" datasource="#application.type#PURCHASING" blockfactor="14">
	SELECT	BUDGETTYPEID, BUDGETTYPENAME
	FROM		BUDGETTYPES
	WHERE	BUDGETTYPEID > 0
	ORDER BY	BUDGETTYPENAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Purchasing - Budget Types Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE border="0" align="center">
	<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListBudgetTypes.RecordCount# Budget Types records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Budget Type Name</TH>
	</TR>

<CFLOOP query="ListBudgetTypes">
	<TR>
		<TD align="left">#ListBudgetTypes.BUDGETTYPENAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListBudgetTypes.RecordCount# Budget Types records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><br>
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