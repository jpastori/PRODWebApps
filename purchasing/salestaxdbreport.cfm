<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: salestaxdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: IDT Purchasing - Sales Tax Report --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME="John R. Pastori">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/purchasing/salestaxdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchasing - Sales Tax Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFQUERY name="ListSalesTax" datasource="#application.type#PURCHASING">
	SELECT	SALESTAXID, SALESTAXTEXT, CURRENTSALESTAX, TO_CHAR(CURRENTSALESTAX , '9D9999') AS DISPLAYSALESTAX
	FROM		SALESTAX
	WHERE	SALESTAXID = 1
	ORDER BY	SALESTAXTEXT
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Purchasing - Sales Tax Report</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="center">
	<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListSalesTax.RecordCount# Sales Tax records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="center">Sales Tax Text</TH>
		<TH align="center">Sales Tax Number Format</TH>
	</TR>

<CFLOOP query="ListSalesTax">
	<TR>
		<TD align="center">#ListSalesTax.SALESTAXTEXT#</TD>
		<TD align="center">#ListSalesTax.DISPLAYSALESTAX#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListSalesTax.RecordCount# Sales Tax records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
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