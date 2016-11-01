<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: statefoundidsurveyreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Hardware Inventory State Found ID Survey By Bar Code Report --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

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

	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center"><h1>IDT Hardware Inventory State Found ID Survey By Bar Code Report</h1></th>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<th align="CENTER" colspan="8">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
			<th align="CENTER">Bar Code Number</th>
			<th align="CENTER">State Found Number</th>
			<th align="CENTER">Serial Number</th>
			<th align="CENTER">Equipment Type</th>
			<th align="CENTER">Current Assignment</th>
			<th align="CENTER">Date Received</th>
			<th align="CENTER">Modified-By Name</th>
			<th align="CENTER">Date Checked</th>
		</tr>
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
		<tr>
			<th align="left" nowrap><h2>#LookupHardware.ROOMNUMBER#</h2></th>
		</tr>
		</CFIF>
		<tr>
			<td align="left" nowrap><div>#LookupHardware.BARCODENUMBER#</div></td>
			<td align="left"><div>#LookupHardware.STATEFOUNDNUMBER#</div></td>
			<td align="left"><div>#LookupHardware.SERIALNUMBER#</div></td>
			<td align="left"><div>#LookupHardware.EQUIPMENTTYPE#</div></td>
			<td align="left"><div>#LookupHardware.FULLNAME#</div></td>
			<td align="left"><div>#DateFormat(LookupHardware.DATERECEIVED, "MM/DD/YYYY")#</div></td>
			<td align="left" nowrap><div>#LookupRecordModifier.FULLNAME#</div></td>
			<td align="left"><div>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</div></td>
		</tr>
	</CFLOOP>
		<tr>
			<th align="CENTER" colspan="8">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td align="left" colspan="8"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>