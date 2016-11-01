<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: interfacenamesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory - Interface Names Report --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/interfacenamesdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory - Interface Names Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFQUERY name="ListInterfaces" datasource="#application.type#HARDWARE" blockfactor="92">
	SELECT	INTERFACENAMEID, INTERFACENAME, MODIFIEDBYID, MODIFIEDDATE
	FROM		INTERFACENAMELIST
	WHERE	INTERFACENAMEID > 0
	ORDER BY	INTERFACENAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Hardware Inventory - Interface Names Report</H1></TD>
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
		<TH align="CENTER" colspan="4"><H2>#ListInterfaces.RecordCount# Interface records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Interface Name</TH>
		<TH align="left">Interface Key Number</TH>
          <TH align="left" valign="TOP">Modified-By</TH>        
          <TH align="left" valign="TOP">Date Modified</TH>
	</TR>

<CFLOOP query="ListInterfaces">
	
     <CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
          SELECT	CUSTOMERID, LASTNAME, FULLNAME
          FROM		CUSTOMERS
          WHERE	CUSTOMERID = <CFQUERYPARAM VALUE="#ListInterfaces.MODIFIEDBYID#" CFSQLTYPE="CF_SQL_NUMERIC">
          ORDER BY	FULLNAME
     </CFQUERY>

	<TR>
		<TD align="left">#ListInterfaces.INTERFACENAME#</TD>
		<TD align="left">#ListInterfaces.INTERFACENAMEID#</TD>
          <TD align="left" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
          <TD align="left" valign="TOP"><DIV>#DateFormat(ListInterfaces.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>
	<TR>
		<TH align="CENTER" colspan="4">&nbsp;&nbsp;</TH>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="4"><H2>#ListInterfaces.RecordCount# Interface records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>