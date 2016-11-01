<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/05/2012 --->
<!--- Date in Production: 07/05/2012 --->
<!--- Module: IDT Software Inventory Application Home Page--->
<!-- Last modified by John R. Pastori on 09/22/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/softwareinventory/index.cfm">
<cfset CONTENT_UPDATED = "September 22, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<title>IDT Software Inventory Application</title>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

	<script language="JavaScript">
		<!--
			if (window.history.forward(1) != null) {
				window.history.forward(1); 
			}

		//-->
	</script>

</head>

<body>

<cfoutput>
<cfcookie name="INDEXDIR" secure="NO" value="/#application.type#apps/softwareinventory">

<!--- APPLICATION ACCESS VARIABLES --->
<cfset URL.ACCESSINGAPPFIRSTTIME = "NO">
<cfset Client.ACCESSINGCONFIGMGMT = "NO">
<cfset Client.ACCESSINGFACILITIES = "NO">
<cfset Client.ACCESSINGHARDWAREINVENTORY = "NO">
<cfset Client.ACCESSINGIDTCHATTER = "NO">
<cfset Client.ACCESSINGINSTRUCTION = "NO">
<cfset Client.ACCESSINGLIBQUAL = "NO">
<cfset Client.ACCESSINGLIBSECURITY = "NO">
<cfset Client.ACCESSINGLIBSHAREDDATA = "NO">
<cfset Client.ACCESSINGPCRESSTATS = "NO">
<cfset Client.ACCESSINGPURCHASING = "NO">
<cfset Client.ACCESSINGSERVICEREQUESTS = "NO">
<cfset Client.ACCESSINGSOFTWAREINVENTORY = "YES">
<cfset Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<cfset Client.ACCESSINGWEBREPORTS = "NO">

<cfset SESSION.ORIGINSERVER = "">
<cfset SESSION.RETURNPGM = "">

<cfinclude template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<cfcookie name="IMAGEID" secure="NO" expires="NOW">
<cfcookie name="LICENSETYPEID" secure="NO" expires="NOW">
<cfcookie name="MANUALSID" secure="NO" expires="NOW">
<cfcookie name="MEDIAID" secure="NO" expires="NOW">
<cfcookie name="MEDIATYPEID" secure="NO" expires="NOW">
<cfcookie name="OTHERITEMSID" secure="NO" expires="NOW">
<cfcookie name="PRODCATID" secure="NO" expires="NOW">
<cfcookie name="PRODUCTPLATFORMID" secure="NO" expires="NOW">
<cfcookie name="SERIALNUMBERID" secure="NO" expires="NOW">
<cfcookie name="SOFTWASSIGNID" secure="NO" expires="NOW">
<cfcookie name="SOFTWINVENTID" secure="NO" expires="NOW">
<cfcookie name="STATUSID" secure="NO" expires="NOW">
<cfcookie name="STOREDLOCID" secure="NO" expires="NOW">

<table width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" valign="middle"><h1>IDT Software Inventory Application</h1></td>
	</tr>
</table>
<table border="0" width="100%" cellspacing="0" cellpadding="4">
	<cfinclude template="../IDTApplicationLinks.cfm">

	<tr>
	<cfif #Client.ProcessFlag# EQ "Yes">
		<th align="LEFT" valign="top">
			SOFTWARE INVENTORY PROCESSING
		</th>
	</cfif>
		<th align="LEFT" valign="top">
			SOFTWARE INVENTORY REPORTS
		</th>
	</tr>

	<tr>
	<cfif #Client.ProcessFlag# EQ "Yes">
		<td align="LEFT" valign="top">
			Inventory - <a href="/#application.type#apps/softwareinventory/softwareinventory.cfm?PROCESS=ADD"> Add</a> or
			<a href="/#application.type#apps/softwareinventory/softwareinventory.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br /><br />
			Assignments Single Record - <a href="/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=ADD"> Add</a> or
			<a href="/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Assignments Multiple Record - <a href="/#application.type#apps/softwareinventory/swassignslookupadd.cfm?PROCESS=ADD"> Lookup Add</a> or
			<a href="/#application.type#apps/softwareinventory/swassignsmultiplemoddel.cfm"> Modify/Delete</a> or
			<a href="/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYLOOP"> Modify/Delete Loop</a><br />
               Assignments - <a href="/#application.type#apps/softwareinventory/custsoftwassigns.cfm"> By Customer</a><br />
               Customer Assignments - <a href="/#application.type#apps/softwareinventory/custsoftwimageassigns.cfm"> By Image</a><br /><br />
			Manuals - <a href="/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a> or 
			<a href="/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYLOOP"> Modify/Delete Loop</a><br />
			Media - <a href="/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a> or 
			<a href="/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYLOOP"> Modify/Delete Loop</a><br />
			Other Items - <a href="/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a> or 
			<a href="/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYLOOP"> Modify/Delete Loop</a><br />
		</td>
	</cfif>
		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/softwareinventory/softwareinventorydbreport.cfm"> Inventory Reports</a> or
			<a href="/#application.type#apps/softwareinventory/silookupreport.cfm"> Lookup Report</a><br /><br />
			<a href="/#application.type#apps/softwareinventory/softwareassignmentsdbreport.cfm"> Assignments Report</a><br />
		<cfif #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
			<a href="/#application.type#apps/softwareinventory/unmatchedswassgnrecs.cfm"> UnMatched Software Assignment Records</a><br />
          <cfelse>
          	<br>
		</cfif>
          	<br /><br /><br />
			<a href="/#application.type#apps/softwareinventory/softwaremanualsdbreport.cfm">Manuals Report</a><br />
			<a href="/#application.type#apps/softwareinventory/softwaremediadbreport.cfm"> Media Report</a><br />
			<a href="/#application.type#apps/softwareinventory/softwareotheritemsdbreport.cfm"> Other Items Report</a><br />
		</td>
	</tr>


	<cfif #Client.SecurityFlag# EQ "Yes">
	<tr>
		<th align="LEFT" valign="top">
			ARCHIVE PROCESSING
		</th>
		<th align="LEFT" valign="top">
			ARCHIVE REPORTS
		</th>
	</tr>

	<tr>
		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/softwareinventory/swarchiveinventoryinfo.cfm?ARCHIVE=SIMPLE">Simple</a> Archive or
			Selected Archive <a href="/#application.type#apps/softwareinventory/swinventoryarchivelookup.cfm?ARCHIVE=FORWARD"> Lookup</a><br />
			Selected <a href="/#application.type#apps/softwareinventory/swinventoryarchivelookup.cfm?ARCHIVE=REVERSE">Reverse Archive </a> Lookup
		</td>
		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/softwareinventory/duplswarchiveinventoryreport.cfm">Duplicate Archive/Inventory Records</a> Report<br />
			<a href="/#application.type#apps/softwareinventory/duplswinventoryarchivereport.cfm">Duplicate Inventory/Archive Records</a> Report<br />
			<a href="/#application.type#apps/softwareinventory/softwareinventoryarchivereport.cfm?REPORT=ARCHIVE">Software Archived</a> Reports<br />
               <a href="/#application.type#apps/softwareinventory/softwarearchivedbreport.cfm"> Software Archive Detail</a> Reports<br />
			<a href="/#application.type#apps/softwareinventory/softwareinventoryarchivereport.cfm?REPORT=INVENTORY">Software Inventory To Archive</a> Reports<br />
		</td>
	</tr>
	</cfif>

	<tr>
     	<cfif #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
		<th align="LEFT" valign="top">
			SUPPORT FILES PROCESSING
		</th>
          </cfif>
		<th align="LEFT" valign="top">
			SUPPORT FILES REPORTS
		</th>
	</tr>

	<tr>
     	<cfif #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
		<td align="LEFT" valign="top">
			Images - <a href="/#application.type#apps/softwareinventory/imagesinfo.cfm?PROCESS=Add"> Add</a> or
			<a href="/#application.type#apps/softwareinventory/imagesinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			License Type - <a href="/#application.type#apps/softwareinventory/licensetype.cfm?PROCESS=Add"> Add</a> or
			<a href="/#application.type#apps/softwareinventory/licensetype.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Media Type - <a href="/#application.type#apps/softwareinventory/mediatype.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/softwareinventory/mediatype.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Product Categories - <a href="/#application.type#apps/softwareinventory/prodcat.cfm?PROCESS=Add"> Add</a> or
			<a href="/#application.type#apps/softwareinventory/prodcat.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
               Product Platforms - <a href="/#application.type#apps/softwareinventory/productplatforms.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/softwareinventory/productplatforms.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Statuses -  <a href="/#application.type#apps/softwareinventory/statuses.cfm?PROCESS=Add"> Add</a> or
			<a href="/#application.type#apps/softwareinventory/statuses.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Stored Locations - <a href="/#application.type#apps/softwareinventory/storedlocations.cfm?PROCESS=Add"> Add</a> or
			<a href="/#application.type#apps/softwareinventory/storedlocations.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
		</td>
		</cfif>
		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/softwareinventory/imagesdbreport.cfm"> Images</a><br />
			<a href="/#application.type#apps/softwareinventory/licensetypedbreport.cfm"> License Type</a><br />
			<a href="/#application.type#apps/softwareinventory/mediatypedbreport.cfm"> Media Type</a><br />
			<a href="/#application.type#apps/softwareinventory/prodcatdbreport.cfm"> Product Categories</a><br />
			<a href="/#application.type#apps/softwareinventory/productplatformsdbreport.cfm">Product Platforms</a><br />
			<a href="/#application.type#apps/softwareinventory/statusesdbreport.cfm"> Statuses</a><br />
			<a href="/#application.type#apps/softwareinventory/storedlocationsdbreport.cfm"> Stored Locations</a><br />
		</td>
	</tr>

	<cfinclude template="../LibraryApplicationLinks.cfm">

</table>

<cfinclude template="/include/coldfusion/footer.cfm">
</cfoutput>

</body>
</html>