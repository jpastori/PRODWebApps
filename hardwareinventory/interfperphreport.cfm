<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: interfperphreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Process Information to IDT Hardware Inventory Interfaces/Peripherals Report --->
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
			<th align="center"><h1>IDT Hardware Inventory Interfaces/Peripherals Report</h1></th>
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
		<tr>
			<th align="CENTER" colspan="11"><h2>#LookupHardware.RecordCount# hardware records were selected.</h2></th>
		</tr>
		<tr>
			<th align="CENTER" valign="BOTTOM">Bar Code Number</th>
			<th align="CENTER" valign="BOTTOM">State Found Number</th>
			<th align="CENTER" valign="BOTTOM">Serial Number</th>
			<th align="CENTER" valign="BOTTOM">Installed Interfaces</th>
			<th align="CENTER" valign="BOTTOM">Installed Peripherals</th>
			<th align="CENTER" valign="BOTTOM">Type</th>
			<th align="CENTER" valign="BOTTOM">Description</th>
			<th align="CENTER" valign="BOTTOM">Model Name</th>
			<th align="CENTER" valign="BOTTOM">Model Number</th>
			<th align="CENTER" valign="BOTTOMP">Current Assign</th>
			<th align="CENTER" valign="BOTTOM">Current Location</th>
		</tr>
	<CFLOOP query="LookupHardware">

		<CFQUERY name="ListPCInstalledInterfaces" datasource="#application.type#HARDWARE">
			SELECT	PCII.INTERFACEID, PCII.BARCODENUMBER, PCII.INTERFACENAMEID, INL.INTERFACENAMEID, INL.INTERFACENAME
			FROM		PCINSTALLEDINTERFACES PCII, INTERFACENAMELIST INL
			WHERE	PCII.BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND 
					PCII.INTERFACENAMEID = INL.INTERFACENAMEID
			ORDER BY	PCII.BARCODENUMBER
		</CFQUERY>

		<CFQUERY name="ListPCInstalledPeripherals" datasource="#application.type#HARDWARE">
			SELECT	PCIP.PERIPHERALID, PCIP.BARCODENUMBER, PCIP.PERIPHERALNAMEID, PNL.PERIPHERALNAMEID, PNL.PERIPHERALNAME
			FROM		PCINSTALLEDPERIPHERALS PCIP, PERIPHERALNAMELIST PNL
			WHERE	PCIP.BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND 
					PCIP.PERIPHERALNAMEID = PNL.PERIPHERALNAMEID
			ORDER BY	PCIP.BARCODENUMBER
		</CFQUERY>

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<tr>
			<td align="left" valign="TOP" nowrap><div>#LookupHardware.BARCODENUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.STATEFOUNDNUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.SERIALNUMBER#</div></td>
			<td valign="TOP" nowrap>
				<CFLOOP query="ListPCInstalledInterfaces">
					<div>#INTERFACENAME#<br /></div>
				</CFLOOP>
			</td>
			<td valign="TOP" nowrap>
				<CFLOOP query="ListPCInstalledPeripherals">
					<div>#PERIPHERALNAME#<br /></div>
				</CFLOOP>
			</td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.EQUIPMENTTYPE#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.EQUIPMENTDESCRIPTION#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.MODELNAME#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.MODELNUMBER#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.FULLNAME#</div></td>
			<td align="CENTER" valign="TOP"><div>#LookupHardware.ROOMNUMBER#</div></td>
		</tr>
		<tr>
			<th align="left" valign="TOP">Modified By Name:</th>
			<td align="left" valign="MIDDLE"><div>#LookupRecordModifier.FULLNAME#</div></td>
			<th align="left" valign="TOP">Date Checked:</th>
			<td align="left" valign="MIDDLE"><div>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</div></td>
		</tr>
		<tr>
			<td colspan="11"><hr width="100%" size="5" noshade /></td>
		</tr>
	</CFLOOP>
	<br />
		<tr>
			<th align="CENTER" colspan="11"><h2>#LookupHardware.RecordCount# hardware records were selected.</h2></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td align="left" colspan="11"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>