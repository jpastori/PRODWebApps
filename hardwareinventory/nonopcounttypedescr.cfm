<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: nonopcounttypedescr.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Process Information to IDT Hardware Inventory Non-Operational Count By Type/Description Report --->
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
	<CFSET INITIALHEADING = "YES">
	<CFSET EQUIPTYPE = "">
	<CFSET EQUIPDESCR = "">
	<CFSET EQUIPDESCRCOUNT = 1>
	<CFSET EQUIPDESCRCOUNTBYTYPE = 0>
	<CFSET TOTALEQUIPDESCRCOUNT = 0>
	<CFSET EQUIPTYPECOUNT = 0>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center"><h1>IDT Hardware Inventory Non-Operational Count By Type/Description Report</h1></th>
		</tr>
	</table>
	<table align="left" border="0">
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </td>
</CFFORM>
		</tr>
	<CFLOOP query="LookupHardware">
		<CFIF #EQUIPTYPE# EQ #LookupHardware.EQUIPMENTTYPE#>
			<CFIF #EQUIPDESCR# EQ #LookupHardware.EQUIPMENTDESCRIPTION#>
				<CFSET EQUIPDESCRCOUNT = EQUIPDESCRCOUNT + 1>
			<CFELSE>
				<CFSET EQUIPDESCRCOUNTBYTYPE = EQUIPDESCRCOUNTBYTYPE + EQUIPDESCRCOUNT>
				<CFSET TOTALEQUIPDESCRCOUNT  = TOTALEQUIPDESCRCOUNT  + EQUIPDESCRCOUNT>
		<tr>
			<td align="LEFT" valign="TOP">#EQUIPDESCR#</td>
			<td align="LEFT" valign="TOP">#EQUIPDESCRCOUNT#</td>
		</tr>
				<CFSET EQUIPDESCRCOUNT = 1>
				<CFSET EQUIPDESCR = #LookupHardware.EQUIPMENTDESCRIPTION#>
			</CFIF>
		<CFELSE>
			<CFIF #INITIALHEADING# EQ "NO">
				<CFSET EQUIPDESCRCOUNTBYTYPE = EQUIPDESCRCOUNTBYTYPE + EQUIPDESCRCOUNT>
				<CFSET TOTALEQUIPDESCRCOUNT  = TOTALEQUIPDESCRCOUNT  + EQUIPDESCRCOUNT>
		<tr>
			<td align="LEFT" valign="TOP">#EQUIPDESCR#</td>
			<td align="LEFT" valign="TOP">#EQUIPDESCRCOUNT#</td>
		</tr>
		<tr>
			<th align="LEFT" valign="TOP"><h2>#EQUIPTYPE# Equipment Description Total = #EQUIPDESCRCOUNTBYTYPE#</h2></th>
			<th align="LEFT" valign="TOP">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="CENTER" colspan="2"><hr /></td>
		</tr>
		<tr>
			<td align="CENTER" colspan="2">&nbsp;&nbsp;</td>
		</tr>
			<CFELSE>
				<CFSET INITIALHEADING = "NO">
			</CFIF>
		<tr>
			<th align="LEFT" valign="TOP"><h2>Equipment Type:  &nbsp;&nbsp;#LookupHardware.EQUIPMENTTYPE#</h2></th>
			<th align="LEFT" valign="TOP">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			
			<th align="LEFT" valign="TOP">Equipment Description</th>
			<th align="LEFT" valign="TOP">Description Count</th>
		</tr>
			<CFSET EQUIPDESCRCOUNT = 1>
			<CFSET EQUIPDESCRCOUNTBYTYPE = 0>
			<CFSET EQUIPDESCR = #LookupHardware.EQUIPMENTDESCRIPTION#>
			<CFSET EQUIPTYPECOUNT = EQUIPTYPECOUNT + 1>
			<CFSET EQUIPTYPE = #LookupHardware.EQUIPMENTTYPE#>
		</CFIF>
	</CFLOOP>
		<tr>
			<td align="LEFT" valign="TOP">#EQUIPDESCR#</td>
			<td align="LEFT" valign="TOP">#EQUIPDESCRCOUNT#</td>
			<CFSET EQUIPDESCRCOUNTBYTYPE = EQUIPDESCRCOUNTBYTYPE + EQUIPDESCRCOUNT>
			<CFSET TOTALEQUIPDESCRCOUNT  = TOTALEQUIPDESCRCOUNT  + EQUIPDESCRCOUNT>
		</tr>
		<tr>
			<th align="LEFT" valign="TOP"><h2>#EQUIPTYPE# Equipment Description Total = #EQUIPDESCRCOUNTBYTYPE#</h2></th>
			<th align="LEFT" valign="TOP">&nbsp;&nbsp;</th>
		</tr>
		<tr>
			<td align="CENTER" colspan="2"><hr size="5" noshade /></td>
		</tr>
		<tr>
			<td align="CENTER" colspan="2">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<th align="LEFT" valign="TOP"><h2>Total Equipment Type Count = #EQUIPTYPECOUNT#</h2></th>
			<th align="LEFT" valign="TOP"><h2>Total Equipment Description Count = #TOTALEQUIPDESCRCOUNT#</h2></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>