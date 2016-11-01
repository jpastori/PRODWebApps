<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: modelnamesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Library IDT Hardware Inventory - Model Names Report--->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/modelnamesdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory - Model Names Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListModelNames" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	MODELNAMEID, MODELNAME, MODIFIEDBYID, MODIFIEDDATE
	FROM		MODELNAMELIST
	WHERE	MODELNAMEID > 0
	ORDER BY	MODELNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
			<TD align="center"><H1>IDT Hardware Inventory - Model Names Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" align="left" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="4"><H2>#ListModelNames.RecordCount# Model Name records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Model Name</TH>
		<TH align="left">Model Name Key Number</TH>
          <TH align="left" valign="TOP">Modified-By</TH>        
          <TH align="left" valign="TOP">Date Modified</TH>
	</TR>

<CFLOOP query="ListModelNames">
	
     <CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
          SELECT	CUSTOMERID, LASTNAME, FULLNAME
          FROM		CUSTOMERS
          WHERE	CUSTOMERID = <CFQUERYPARAM VALUE="#ListModelNames.MODIFIEDBYID#" CFSQLTYPE="CF_SQL_NUMERIC">
          ORDER BY	FULLNAME
     </CFQUERY>

	<TR>
		<TD align="left">#ListModelNames.MODELNAME#</TD>
		<TD align="left">#ListModelNames.MODELNAMEID#</TD>
          <TD align="left" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
          <TD align="left" valign="TOP"><DIV>#DateFormat(ListModelNames.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="4"><H2>#ListModelNames.RecordCount# Model Name records were selected.</H2></TH>
	</TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	
	<TR>
		<TD align="left" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>