<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: statefoundnumcurrassignrpt.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/26/2015 --->
<!--- Date in Production: 03/26/2015 --->
<!--- Module: IDT Hardware Inventory - State Found ## Current Assignment Report --->
<!-- Last modified by John R. Pastori on 03/26/2015 using ColdFusion Studio. -->

<CFIF (FIND('wiki', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "WIKI")>
	<CFSET SESSION.ORIGINSERVER = "WIKI">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSEIF (FIND('#application.type#apps/forms', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "FORMS")>
	<CFSET SESSION.ORIGINSERVER = "FORMS">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSE>
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET SESSION.ORIGINSERVER = "">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
</CFIF>

<CFOUTPUT>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>IDT Hardware Inventory - State Found ## Current Assignment Report</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="8">#LookupHardware.RecordCount# hardware records were selected.<BR /><BR /></TH>
		</TR>
		<TR>
			<TH align="CENTER">State Found Number</TH>
			<TH align="CENTER">Bar Code Number</TH>
			<TH align="CENTER">Serial Number</TH>
			<TH align="CENTER">Equipment Type</TH>
			<TH align="CENTER">Current Assignment</TH>
			<TH align="CENTER">Date Received</TH>
			<TH align="CENTER">Modified-By Name</TH>
			<TH align="CENTER">Date Checked</TH>
		</TR>
	<CFSET ROOMNUMBERHEADER = "">
	<CFLOOP query="LookupHardware">

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFIF ROOMNUMBERHEADER NEQ #LookupHardware.ROOMNUMBER#>
			<CFSET ROOMNUMBERHEADER = #LookupHardware.ROOMNUMBER#>
		<TR>
			<TH align="left" nowrap><H2>#LookupHardware.ROOMNUMBER#</H2></TH>
		</TR>
		</CFIF>

		<TR>
			<TD align="left"><DIV>#LookupHardware.STATEFOUNDNUMBER#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupHardware.BARCODENUMBER#</DIV></TD>
			<TD align="left"><DIV>#LookupHardware.SERIALNUMBER#</DIV></TD>
			<TD align="CENTER"><DIV>#LookupHardware.EQUIPMENTTYPE#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupHardware.FULLNAME#</DIV></TD>
			<TD align="left"><DIV>#DateFormat(LookupHardware.DATERECEIVED, "MM/DD/YYYY")#</DIV></TD>
			<TD align="left" nowrap><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
			<TD align="left"><DIV>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="8">#LookupHardware.RecordCount# hardware records were selected.<BR /><BR /></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="8"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFOUTPUT>