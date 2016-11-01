<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: productplatformsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: IDT Software Inventory - Product Platforms Database Report --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/productplatformsdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - Product Platforms Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<cfquery name="ListProductPlatforms" DATASOURCE="#application.type#SOFTWARE" BLOCKFACTOR="6">
	SELECT	PRODUCTPLATFORMID, PRODUCTPLATFORMNAME
	FROM		PRODUCTPLATFORMS
	WHERE	PRODUCTPLATFORMID > 0
	ORDER BY	PRODUCTPLATFORMNAME
</cfquery>

<cfoutput>

<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>IDT Software Inventory - Product Platforms Report</H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/softwareinventory/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1"><BR>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListProductPlatforms.RecordCount# Product Platform records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Product Platform Name</TH>
	</TR>

<CFLOOP QUERY="ListProductPlatforms">
	<TR>
		<TD ALIGN="left">#ListProductPlatforms.PRODUCTPLATFORMNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER"><H2>#ListProductPlatforms.RecordCount# Product Platform records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/softwareinventory/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2"><BR>
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD>
<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR><BR>
</cfoutput>
</BODY>
</HTML>