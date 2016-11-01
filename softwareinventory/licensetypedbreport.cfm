<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: licensetypedbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: IDT Software Inventory - License Type Report --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/licensetypedbreport.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - License Type Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFQUERY name="ListLicenseType" datasource="#application.type#SOFTWARE" blockfactor="10">
	SELECT	LICENSETYPEID, LICENSETYPENAME
	FROM		LICENSETYPES
	WHERE	LICENSETYPEID > 0
	ORDER BY	LICENSETYPENAME
</CFQUERY>

<TABLE width="100%" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Software Inventory - License Type Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER"><H2>#ListLicenseType.RecordCount# License Type records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">License Type Name</TH>
	</TR>

<CFLOOP query="ListLicenseType">
	<TR>
		<TD align="left">#ListLicenseType.LICENSETYPENAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER"><H2>#ListLicenseType.RecordCount# License Type records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left"
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>