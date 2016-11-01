<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: sadbreportformat5.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2011 --->
<!--- Date in Production: 08/03/2011 --->
<!--- Module: IDT Software Inventory - Assignments Report --->
<!-- Last modified by John R. Pastori on 08/03/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
	<tr>
		<th align="LEFT" valign="BOTTOM"><u>SW Key</u></th>
		<th align="LEFT" valign="BOTTOM"><u>Title</u></th>
		<th align="center" valign="BOTTOM"><u>Version</u></th>
		<th align="center" valign="BOTTOM"><u>Category</u></th>
		<th align="center" valign="BOTTOM"><u>Platform</u></th>
	</tr>

<CFLOOP query="LookupSoftwareInventory">

	<CFQUERY name="LookupSoftwareAssignmentDetail" datasource="#application.type#SOFTWARE">
		SELECT	SA.SOFTWINVENTID
		FROM		SOFTWAREASSIGNMENTS SA
		WHERE	SA.SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	SA.SOFTWINVENTID
	</CFQUERY>

	<CFIF (#FORM.CURRASSIGNEDFLAG# EQ 'YES' AND #LookupSoftwareAssignmentDetail.RecordCount# GT 0) OR 
		 (#FORM.CURRASSIGNEDFLAG# EQ 'NO' AND #LookupSoftwareAssignmentDetail.RecordCount# EQ 0)>
		<CFSET SARECORDCOUNT = #SARECORDCOUNT# + 1>
	<tr>
		<td align="center" valign="TOP"><div><COM>#LookupSoftwareInventory.SOFTWINVENTID#</COM></div></td>
		<td align="LEFT" valign="TOP" nowrap><div><COM>#LookupSoftwareInventory.TITLE#</COM></div></td>
		<td align="center" valign="TOP"><div><COM>#LookupSoftwareInventory.VERSION#</COM></div></td>
		<td align="center" valign="TOP"><div><COM>#LookupSoftwareInventory.PRODCATNAME#</COM></div></td>
		<td align="center" valign="TOP"><div><COM>#LookupSoftwareInventory.PRODUCTPLATFORMNAME#</COM></div></td>
	</tr>
	<tr>
		<td align="CENTER" colspan="5"><hr size="5" noshade /></td>
	</tr>
	</CFIF>
</CFLOOP>
</CFOUTPUT>