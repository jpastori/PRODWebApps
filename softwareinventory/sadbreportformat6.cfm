<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: sadbreportformat6.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: IDT Software Inventory - Assignments Report --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
	<tr>
		<th align="center" valign="BOTTOM"><u>Title</u></th>
		<th align="center" valign="BOTTOM"><u>Version</u></th>
		<th align="center" valign="BOTTOM"><u>SW Key</u></th>
		<th align="center" valign="BOTTOM"><u>Serial Number</u></th>
	</tr>

<CFLOOP query="LookupSoftWAssignSerNums">

	<CFQUERY name="LookupSoftwareNameKey" datasource="#application.type#SOFTWARE">
		SELECT	SI.SOFTWINVENTID, SI.TITLE, SI.VERSION
		FROM		SOFTWAREINVENTORY SI
		WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftWAssignSerNums.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	SI.TITLE
	</CFQUERY>

	<tr>
		<td align="center" valign="TOP" nowrap><div><COM>#LookupSoftwareNameKey.TITLE#</COM></div></td>
		<td align="center" valign="TOP" nowrap><div><COM>#LookupSoftwareNameKey.VERSION#</COM></div></td>
		<td align="center" valign="TOP"><div><COM>#LookupSoftwareNameKey.SOFTWINVENTID#</COM></div></td>
		<td align="center" valign="TOP"><div><COM>#LookupSoftWAssignSerNums.SERIALNUMBER#</COM></div></td>
	</tr>
</CFLOOP>
<CFSET SARECORDCOUNT = #LookupSoftWAssignSerNums.RecordCount#>
</CFOUTPUT>