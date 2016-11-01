<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: imagesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: IDT Software Inventory - Images Report --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/imagesdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - Images Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFQUERY name="ListImages" datasource="#application.type#SOFTWARE" blockfactor="12" >
	SELECT	IMAGEID, IMAGENAME, IMAGEDESCRIPTION, IMAGENOTES
	FROM		IMAGES
	WHERE	IMAGEID > 0
	ORDER BY	IMAGENAME
</CFQUERY>

<TABLE width="100%" align="CENTER" border="3">
	<TR>
		<TD align="center"><H1>IDT Software Inventory - Images Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="3">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="Center" colspan="3"><H2>#ListImages.RecordCount# Image records were selected.</H2></TH>
	</TR>
     <TR>
		<TH align="left" colspan="3">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		<TH align="left">Images</TH>
          <TH align="left">Description</TH>
          <TH align="left">Notes</TH>
	</TR>

<CFLOOP query="ListImages">
	<TR>
		<TD align="left" valign="TOP">#ListImages.IMAGENAME#</TD>
          <TD align="left">#ListImages.IMAGEDESCRIPTION#</TD>
          <TD align="left">#ListImages.IMAGENOTES#</TD>
	</TR>
     <TR>
		<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
	</TR>
     
</CFLOOP>
	<TR>
		<TH align="Center" colspan="3"><H2>#ListImages.RecordCount# Image records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="3">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="LEFT" colspan="3">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>