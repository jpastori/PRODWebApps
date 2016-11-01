<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: equiptypedbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: IDT Hardware Inventory - Equipment Type Report --->
<!-- Last modified by John R. Pastori on 07/12/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/equiptypedbreport.cfm">
<CFSET CONTENT_UPDATED = "July 12, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory - Equipment Type Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFQUERY name="ListEquipmentTypes" datasource="#application.type#HARDWARE" blockfactor="13">
	SELECT	EQUIPTYPEID, EQUIPMENTTYPE, MODIFIEDBYID, MODIFIEDDATE
	FROM		EQUIPMENTTYPE
	WHERE	EQUIPTYPEID > 0
	ORDER BY	EQUIPMENTTYPE
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Hardware Inventory - Equipment Type Report</H1></TD>
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
		<TH align="CENTER" colspan="4"><H2>#ListEquipmentTypes.RecordCount# Equipment Type records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Equipment Type</TH>
          <TH align="left">Equipment Type Key Number</TH>
          <TH align="left" valign="TOP">Modified-By</TH>        
          <TH align="left" valign="TOP">Date Modified</TH>
	</TR>

<CFLOOP query="ListEquipmentTypes">
	
     <CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
          SELECT	CUSTOMERID, LASTNAME, FULLNAME
          FROM		CUSTOMERS
          WHERE	CUSTOMERID = <CFQUERYPARAM VALUE="#ListEquipmentTypes.MODIFIEDBYID#" CFSQLTYPE="CF_SQL_NUMERIC">
          ORDER BY	FULLNAME
     </CFQUERY>

	<TR>
		<TD align="left">#ListEquipmentTypes.EQUIPMENTTYPE#</TD>
          <TD align="left">#ListEquipmentTypes.EQUIPTYPEID#</TD>
          <TD align="left" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
          <TD align="left" valign="TOP"><DIV>#DateFormat(ListEquipmentTypes.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
	</TR>
</CFLOOP>
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