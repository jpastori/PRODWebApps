<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: prodcatdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: IDT Software Inventory - Product Categories Report --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/prodcatdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - Product Categories Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFQUERY name="ListProdCat" datasource="#application.type#SOFTWARE" blockfactor="29">
	SELECT	PRODCATID, PRODCATNAME
	FROM		PRODUCTCATEGORIES
	WHERE	PRODCATID > 0
	ORDER BY	PRODCATNAME
</CFQUERY>

<TABLE width="100%" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Software Inventory - Product Categories Report</H1></TD>
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
		<TH align="CENTER"><H2>#ListProdCat.RecordCount# Product Categories records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Product Categories Name</TH>
	</TR>

<CFLOOP query="ListProdCat">
	<TR>
		<TD align="left">#ListProdCat.PRODCATNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER"><H2>#ListProdCat.RecordCount# Product Categories records were selected.</H2></TH>
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