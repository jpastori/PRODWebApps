<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/05/2012 --->
<!--- Date in Production: 07/05/2012 --->
<!--- Module: IDT Hardware Inventory Home Page --->
<!-- Last modified by John R. Pastori on 04/06/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/hardwareinventory/index.cfm">
<cfset CONTENT_UPDATED = "April 06 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<title>IDT Hardware Inventory Application</title>
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
<cfcookie name="INDEXDIR" secure="NO" value="/#application.type#apps/hardwareinventory">

<!--- APPLICATION ACCESS VARIABLES --->
<cfset URL.ACCESSINGAPPFIRSTTIME = "NO">
<cfset Client.ACCESSINGCONFIGMGMT = "NO">
<cfset Client.ACCESSINGFACILITIES = "NO">
<cfset Client.ACCESSINGHARDWAREINVENTORY = "YES">
<cfset Client.ACCESSINGIDTCHATTER = "NO">
<cfset Client.ACCESSINGINSTRUCTION = "NO">
<cfset Client.ACCESSINGLIBQUAL = "NO">
<cfset Client.ACCESSINGLIBSECURITY = "NO">
<cfset Client.ACCESSINGLIBSHAREDDATA = "NO">
<cfset Client.ACCESSINGLIBSTATS = "NO">
<cfset Client.ACCESSINGPURCHASING = "NO">
<cfset Client.ACCESSINGSERVICEREQUESTS = "NO">
<cfset Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<cfset Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<cfset Client.ACCESSINGWEBREPORTS = "NO">

<cfset SESSION.ORIGINSERVER = "">
<cfset SESSION.RETURNPGM = "">

<cfinclude template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<cfcookie name="EQUIPDESCRID" secure="NO" expires="NOW">
<cfcookie name="EQUIPTYPEID" secure="NO" expires="NOW">
<cfcookie name="HARDWAREID" secure="NO" expires="NOW">
<cfcookie name="INTERFACENAMEID" secure="NO" expires="NOW">
<cfcookie name="MODELNAMEID" secure="NO" expires="NOW">
<cfcookie name="MODELNUMBERID" secure="NO" expires="NOW">
<cfcookie name="PERIPHERALNAMEID" secure="NO" expires="NOW">
<cfcookie name="SIZENAMEID" secure="NO" expires="NOW">
<cfcookie name="SPEEDNAMEID" secure="NO" expires="NOW">
<cfcookie name="VENDORID" secure="NO" expires="NOW">

<table width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" valign="middle"><h1>IDT Hardware Inventory Application</h1></td>
	</tr>
</table>
<table border="0" width="100%" cellspacing="0" cellpadding="4">
	<cfinclude template="../IDTApplicationLinks.cfm">

	<tr>
	<cfif #Client.ProcessFlag# EQ "Yes">
		<th align="LEFT" valign="top">
			HARDWARE INVENTORY PROCESSING
		</th>
	</cfif>
		<th align="LEFT" valign="top">
			HARDWARE INVENTORY REPORTS
		</th>
	</tr>

	<tr>
	<cfif #Client.ProcessFlag# EQ "Yes">
		<td align="LEFT" valign="top">
			Single Record - <a href="/#application.type#apps/hardwareinventory/lookuproommanufcustinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Multiple Record - <a href="/#application.type#apps/hardwareinventory/inventorymultipleadd.cfm?PROCESS=NEWADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/inventorylkupmultipleadd.cfm?PROCESS=NEWADD">Lookup Add</a> or
			<a href="/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm">Modify/Delete</a> or
			<a href="/#application.type#apps/hardwareinventory/inventorymultiplemodloop.cfm?PROCESS=MODLOOP">Modify Loop</a><br /><br /><br />
               <a href="/#application.type#apps/hardwareinventory/inventoryassignverif.cfm">Assignment Verification</a>
		</td>
	</cfif>
		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/hardwareinventory/hardwareinventorystatus.cfm">Inventory</a> or
			<a href="/#application.type#apps/hardwareinventory/hardwareinventorystatus.cfm?PROCESS=ARCHIVEINVENTORY">Archive</a> Status<br />
			<a href="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT">Departmental & Unit/Customer</a> Reports<br />
               <a href="/#application.type#apps/hardwareinventory/masterinventorybycustrpt.cfm">Master Inventory by Customer</a> Report
		</td>
	</tr>

	<cfif #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
	<tr>
		<th align="LEFT" valign="top">
			SURPLUS PROCESSING
		</th>
		<th align="LEFT" valign="top">
			SURPLUS REPORTS
		</th>
	</tr>

	<tr>
		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/hardwareinventory/archiveinventoryinfo.cfm">Simple</a> Archive or
			Selected Archive <a href="/#application.type#apps/hardwareinventory/inventoryarchivelookup.cfm?ARCHIVE=FORWARD"> Lookup</a><br />
			Selected <a href="/#application.type#apps/hardwareinventory/inventoryarchivelookup.cfm?ARCHIVE=REVERSE">Reverse Archive </a> Lookup<br /><br /><br />
               Import <a href="/#application.type#apps/hardwareinventory/csv_importmmohardwarerecs.cfm">MMO Hardware </a>CSV Records<br />
               Compare <a href="/#application.type#apps/hardwareinventory/mmohardwarereccompare.cfm">MMO & Hardware Inventory</a> Records
		</td>
		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/hardwareinventory/archivecommentsreport.cfm">Archive Comments</a> Report<br />
			<a href="/#application.type#apps/hardwareinventory/inventoryarchivedbreports.cfm?PROCESS=ARCHIVE">Archive </a> Reports<br />
			<a href="/#application.type#apps/hardwareinventory/duplarchiveinventoryreport.cfm">Duplicate Archive/Inventory Records</a> Report<br />
			<a href="/#application.type#apps/hardwareinventory/duplinventoryarchivereport.cfm">Duplicate Inventory/Archive Records</a> Report<br />
			<a href="/#application.type#apps/hardwareinventory/hardwareinventorymmoreport.cfm">MMO</a> Reports<br />
		</td>
	</tr>
	</cfif>

	<cfif #Client.SecurityFlag# EQ "Yes">
     <tr>
		<th align="LEFT" valign="top">
			<h3>SHARED DATA PROCESSING</h3>
		</th>
		<th align="LEFT" valign="top">
			<h3>SHARED DATA REPORTS</h3>
		</th>
	</tr>

	<tr>
		<td align="LEFT" valign="top">
			Location - <a href="/#application.type#apps/facilities/locationinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/facilities/locationinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			WallJack Single Record - <a href="/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			WallJack Multiple Record - <a href="/#application.type#apps/facilities/walljacksmultiplemoddel.cfm?PROCESS=MULTMODDEL">Modify/Delete</a> or 
               <a href="/#application.type#apps/facilities/walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP">Modify/Delete Loop</a><br />
		</td>

		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/facilities/locationdbreport.cfm">Location</a><br />
			<a href="/#application.type#apps/facilities/walljacksdbreport.cfm?PROCESS=REPORT">Wall Jack</a><br />
		</td>
	</tr>
     </cfif>

	<tr>
     	<cfif #Client.ProcessFlag# EQ "Yes">
		<th align="LEFT" valign="top">
			SUPPORT FILE PROCESSING
		</th>
          </cfif>
		<th align="LEFT" valign="top">
			SUPPORT FILE REPORTS
		</th>
	</tr>

	<tr>
     	<cfif #Client.ProcessFlag# EQ "Yes">
		<td align="LEFT" valign="top">
			Archive Location  <a href="/#application.type#apps/hardwareinventory/archivelocation.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/archivelocation.cfm?PROCESS=MODIFY"> Modify</a><br />
			Equipment Description  <a href="/#application.type#apps/hardwareinventory/equipdescrinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/equipdescrinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Equipment Type  <a href="/#application.type#apps/hardwareinventory/equiptypeinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/equiptypeinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Interface Names<a href="/#application.type#apps/hardwareinventory/interfacenamesinfo.cfm?PROCESS=ADD">  Add</a> or
			<a href="/#application.type#apps/hardwareinventory/interfacenamesinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Model Names  <a href="/#application.type#apps/hardwareinventory/modelnamesinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/modelnamesinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Model Numbers  <a href="/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/modelnumbersinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Owning Org Codes - <a href="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Peripheral Names  <a href="/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/peripheralnamesinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Size Names  <a href="/#application.type#apps/hardwareinventory/sizenamesinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/sizenamesinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a><br />
			Speed Names  <a href="/#application.type#apps/hardwareinventory/speednamesinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/hardwareinventory/speednamesinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a> <br /><br />
			Vendors <a href="/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Vendor Contacts <a href="/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=ADD">Add</a> or
			<a href="/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a>
		</td>
          </cfif>
		<td align="LEFT" valign="top">
			<a href="/#application.type#apps/hardwareinventory/archivelocationreport.cfm">Archive Location </a><br />
			<a href="/#application.type#apps/hardwareinventory/equipdescrdbreport.cfm">Equipment Description </a><br />
			<a href="/#application.type#apps/hardwareinventory/equiptypedbreport.cfm">Equipment Type </a><br />
			<a href="/#application.type#apps/hardwareinventory/interfacenamesdbreport.cfm">Interface Names</a><br />
			<a href="/#application.type#apps/hardwareinventory/modelnamesdbreport.cfm">Model Names </a><br />
			<a href="/#application.type#apps/hardwareinventory/modelnumbersdbreport.cfm">Model Numbers </a><br />
			<a href="/#application.type#apps/libshareddata/orgcodesdbreport.cfm">Owning Org Codes</a><br />
			<a href="/#application.type#apps/hardwareinventory/peripheralnamesdbreport.cfm">Peripheral Names </a><br />
			<a href="/#application.type#apps/hardwareinventory/sizenamesdbreport.cfm">Size Names </a><br />
			<a href="/#application.type#apps/hardwareinventory/speednamesdbreport.cfm">Speed Names </a><br /><br />
			<a href="/#application.type#apps/purchasing/vendordbreport.cfm">Vendors</a><br />
			<a href="/#application.type#apps/purchasing/vendorcontactsdbreport.cfm">Vendor Contacts</a>
		</td>
	</tr>
	

	<cfinclude template="../LibraryApplicationLinks.cfm">

</table>

<cfinclude template="/include/coldfusion/footer.cfm">
</cfoutput>

</body>
</html>