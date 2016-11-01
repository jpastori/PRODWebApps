<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: fundacctsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: IDT Purchasing - Fund Accounts Report --->
<!-- Last modified by John R. Pastori on 07/09/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/fundacctsdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 09, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchasing - Fund Accounts Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListFundAccts" datasource="#application.type#PURCHASING" blockfactor="14">
	SELECT	FUNDACCTID, FUNDACCTNAME
	FROM		FUNDACCTS
	WHERE	FUNDACCTID > 0
	ORDER BY	FUNDACCTNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Purchasing - Fund Accounts Report</H1></TD>
	</TR>
</TABLE>
<BR />
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
		<TH align="CENTER" colspan="2"><H2>#ListFundAccts.RecordCount# Fund Accounts records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">FundAccts Name</TH>
	</TR>

<CFLOOP query="ListFundAccts">
	<TR>
		<TD align="left">#ListFundAccts.FUNDACCTNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="2"><H2>#ListFundAccts.RecordCount# Fund Accounts records were selected.</H2></TH>
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