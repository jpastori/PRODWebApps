<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: iassetcomparereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/20/2016 --->
<!--- Date in Production: 10/20/2016 --->
<!--- Module: IDT Hardware Inventory - Compare iAsset Records Report --->
<!-- Last modified by John R. Pastori on 10/20/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/hardwareinventory/iassetcomparereport.cfm">
<cfset CONTENT_UPDATED = "October 20, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<title>IDT Hardware Inventory - Compare iAsset Records Report</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />
</head>

<body>

<cfoutput>

<cfquery name="ListiAssetRecords" datasource="ORACLEIASSETS" blockfactor="100">
	SELECT	TAG_NUMBER, ASSET_DESCRIPTION
	FROM		IDT_COMPAREASSETS
	ORDER BY	TAG_NUMBER
</cfquery>

<CFSET HIRECORDS = 0>

<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center"><h1>IDT Hardware Inventory - Compare iAsset Records Report</h1></td>
	</tr>
</table>
<br />
<table width="100%" border="0" align="left" valign="top" cellpadding="0" cellspacing="0">
	<tr>
<cfform action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<td align="LEFT" colspan="3">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</td>
</cfform>
	</tr>
	<tr>
		<th align="left">State Tag</th>
          <th align="left">Asset Description</th>
          <th align="left" valign="TOP">Comment</th>
	</tr>

<cfloop query="ListiAssetRecords">
	
     <cfquery name="LookupHardware" datasource="#application.type#HARDWARE">
          SELECT	STATEFOUNDNUMBER
          FROM		HARDWAREINVENTORY
          WHERE	STATEFOUNDNUMBER = <CFQUERYPARAM value="#ListiAssetRecords.TAG_NUMBER#" cfsqltype="CF_SQL_VARCHAR">
          ORDER BY	STATEFOUNDNUMBER
     </cfquery>


	<tr>
		<td align="left">#ListiAssetRecords.TAG_NUMBER#</td>
		<td align="left">#ListiAssetRecords.ASSET_DESCRIPTION#</td>
     <CFIF #LookupHardware.RecordCount# GT 0>
          <CFSET HIRECORDS = HIRECORDS + 1>
          <td align="left" valign="TOP"><div><strong>Item exists in Both</strong></div></td>
     <CFELSE>
     	<td align="left" valign="TOP"><div><strong>Item exists only in iAssets</strong></div></td>
     </CFIF>
	</tr>
</cfloop>
	<cfquery name="CountHardwareRecords" datasource="#application.type#HARDWARE">
          SELECT	HARDWAREID, STATEFOUNDNUMBER
          FROM		HARDWAREINVENTORY
          WHERE	HARDWAREID > 0
          ORDER BY	STATEFOUNDNUMBER
     </cfquery>
     
     <tr>
		<th align="CENTER" colspan="3"><BR><BR><h2>The iAsset Table contains #ListiAssetRecords.RecordCount# records.</h2></th>
	</tr>
	<tr>
		<th align="CENTER" colspan="3"><h2>#HIRECORDS# Library DB records MATCHED the iAsset records.</h2></th>
	</tr>
     <tr>
		<th align="CENTER" colspan="3"><h2> There are #CountHardwareRecords.RecordCount# records in the Library DB.</h2></th>
	</tr>
	<tr>
<cfform action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<td align="LEFT" colspan="3">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><br />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</td>
</cfform>
	</tr>
	<tr>
		<td align="left" colspan="4">
			<cfinclude template="/include/coldfusion/footer.cfm">
		</td>
	</tr>
</table>
</cfoutput>

</body>
</html>