<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: joelssrindex.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/14/2016 --->
<!--- Date in Production: 07/14/2016 --->
<!--- Module: Joel's Service Request Home Page--->
<!-- Last modified by John R. Pastori on 07/14/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/joelssrindex.cfm">
<cfset CONTENT_UPDATED = "July 14, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<title>IDT Service Request Application</title>
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
<cfcookie name="INDEXDIR" secure="NO" value="/#application.type#apps/servicerequests">

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
<cfset Client.ACCESSINGLIBSTATS = "NO">
<cfset Client.ACCESSINGPURCHASING = "NO">
<cfset Client.ACCESSINGSERVICEREQUESTS = "NO">
<cfset Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<cfset Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<cfset Client.ACCESSINGWEBREPORTS = "NO">

<cfset SESSION.ORIGINSERVER = "Joel">
<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfset CLIENT.PGMRETURN = "returnindex.cfm">

<!--- SET COOKIE VARIABLES --->
<cfcookie name="ACTIONID" secure="NO" expires="NOW">
<cfcookie name="CATEGORYID" secure="NO" expires="NOW">
<cfcookie name="CUSTSRADDID" secure="NO" expires="NOW">
<cfcookie name="DISPLAYTYPE" secure="NO" expires="NOW">
<cfcookie name="HWSW_ID" secure="NO" expires="NOW">
<cfcookie name="IDTGROUPID" secure="NO" expires="NOW">
<cfcookie name="IDTSRID" secure="NO" expires="NOW">
<cfcookie name="OPSYSID" secure="NO" expires="NOW">
<cfcookie name="OPTIONID" secure="NO" expires="NOW">
<cfcookie name="PKUPRETURNID" secure="NO" expires="NOW">
<cfcookie name="PRIORITYID" secure="NO" expires="NOW">
<cfcookie name="SERVERID" secure="NO" expires="NOW">
<cfcookie name="SERVICETYPEID" secure="NO" expires="NOW">
<cfcookie name="SRHARDWASSIGNID" secure="NO" expires="NOW">
<cfcookie name="SRSOFTWASSIGNID" secure="NO" expires="NOW">
<cfcookie name="STAFFLOOKUPID" secure="NO" expires="NOW">
<cfcookie name="SRSTAFF_ASSIGNID" secure="NO" expires="NOW">
<cfcookie name="SUBCATEGORYID" secure="NO" expires="NOW">
<cfcookie name="TNSWO_ID" secure="NO" expires="NOW">
<cfcookie name="WORKGROUPASSIGNSID" secure="NO" expires="NOW">

<table width="100%" cellspacing="0" cellpadding="0" border="0">
	<tr align="LEFT">
		<td align="Left" >
			<cfinclude template="/include/coldfusion/header.cfm">
		</td>
	</tr>
</table>

<table width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" valign="TOP"><h1>Joel's Service Request Application</h1></td>
	</tr>
</table>
<br>
<table border="0" width="100%" cellspacing="0" cellpadding="4">
	<cfinclude template="../IDTApplicationLinks.cfm">
	<tr>
		<th align="LEFT" valign="top">SERVICE REQUEST PROCESSING</th>
          <th align="LEFT" valign="top">SERVICE REQUEST REPORTS</th>
	</tr>
     <tr>
		<td align="LEFT" valign="top">
               <a href="/#application.type#apps/servicerequests/custsrapproval.cfm">Approve </a> Customer Service Requests<br>
               <a href="/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=ADD">Add</a> New SR <br>
			<a href="/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm">Add Assignments </a> to New SRs<br /><br />
          
			<a href="/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=MODIFY">Modify</a> an Existing SR<br />
               <a href="/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LIST_LOOKUP=LOOKUP"> Lookup/Modify SR Assignment Queues by Tech<br />
          </td>
	
		<td align="LEFT" valign="top">
          	SR <a href="/#application.type#apps/servicerequests/srreviewreport.cfm">Review Report</a><br />
               List <a href="/#application.type#apps/servicerequests/unassignedbygrouplist.cfm">Unassigned SRs By Group</a><br /><br />
		</td>
	</tr>
     
     
 <!---     Commented out and save for future use. JRP - 06/23/2016.
     <tr>
     	<td align="LEFT" valign="top">
          	Display List <a href="/#application.type#apps/servicerequests/unassignedbygrouplist.cfm">Unassigned By Group</a><br /><br /><br />
               Group Meeting List <a href="/#application.type#apps/servicerequests/grouplistclaimednotcompl.cfm">Claimed/Not Complete</a><br />
               Group List <a href="/#application.type#apps/servicerequests/grouplistsrcompleted.cfm">Service Request Completed</a><br />
               Display List <a href="/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LIST_LOOKUP=LIST">Claimed/Not Complete</a><br />
			Display Loop <a href="/#application.type#apps/servicerequests/claimednotcomploop.cfm">Claimed/Not Complete</a><br /><br />
               Display Single <a href="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm?DISPLAYTYPE=SINGLE BASIC "> SR Comments </a><br />
			Display Single <a href="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm?DISPLAYTYPE=SINGLE EXTRA "> SR Comments </a>with Extra Info<br /><br />
               Display Loop <a href="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm?DISPLAYTYPE=LOOP BASIC "> for SR Comments </a> <br />
			Display Loop <a href="/#application.type#apps/servicerequests/srstaffassigndisplay.cfm?DISPLAYTYPE=EXTRA LOOP"> for SR Comments </a>with Extra Info<br /><br>	
               
			<a href="/#application.type#apps/servicerequests/servicerequestdbreport.cfm">SR Number Lists</a><br />
			<a href="/#application.type#apps/servicerequests/srcounts.cfm">SR Statistic</a> Counts<br />
               <a href="/#application.type#apps/servicerequests/srassignedstaffcounts.cfm">Assigned Staff Statistic</a> Counts<br /><br>	
		</td>
	</tr>

	
	<tr>
	
		<th align="LEFT" valign="top">OTHER MODULE PROCESSING</th>
		<th align="LEFT" valign="top">OTHER MODULE REPORTS</th>
	</tr>

	<tr>
     <cfif #Client.SecurityFlag# EQ "Yes">
		<td align="LEFT" valign="top">
          	<br />
			 <a href="/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYDELETE&STAFFLOOP=NO"> Modify/Delete </a>
			 or  <a href="/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm?PROCESS=CONFIRM"> Confirm</a>
			Hardware Assignments<br /><br />
               <a href="/#application.type#apps/servicerequests/deleteconfirmedhwassigns.cfm"> Delete </a>Hardware Assignments

               <br /><br /><br />
			<a href="/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYDELETE&STAFFLOOP=NO"> Modify/Delete </a> 
			or  <a href="/#application.type#apps/servicerequests/softwareassignsconfirm.cfm?PROCESS=CONFIRM"> Confirm </a>
			Software Assignments<br /><br />
               <a href="/#application.type#apps/servicerequests/deleteconfirmedswassigns.cfm"> Delete </a>Software Assignments

               <br /><br /><br />
			<a href="/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a>
			or <a href="/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=SUBMIT"> Submit</a>
			TNS Work Orders<br />
               <br />
               <a href="/#application.type#apps/servicerequests/deletecompletedtnswo.cfm"> Delete </a>TNS Work Orders<br />

               <br />
               <a href="/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</a>
			or <a href="/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=SUBMIT"> Submit</a>
			Telephone Work Orders<br />
		</td>
	<cfelse>
          <td align="LEFT" valign="top">&nbsp;&nbsp;</td>	
     </cfif>
     <cfif #Client.ProcessFlag# EQ "Yes">
		<td align="LEFT" valign="top">
          	<br />
			<a href="/#application.type#apps/servicerequests/hardwareassignsdbreport.cfm"> Hardware Assignments </a> <br />
               <a href="/#application.type#apps/servicerequests/srnonpublichwreport.cfm">Non-Public Hardware / SR Report</a><br />
               <a href="/#application.type#apps/servicerequests/srpublichwreport.cfm">Public Hardware / SR Report</a><br /><br /><br />
			<a href="/#application.type#apps/servicerequests/softwareassignsdbreport.cfm"> Software Assignments </a> <br /><br /><br /><br /><br />
			<a href="/#application.type#apps/servicerequests/tnsworkordersdbreport.cfm"> TNS Work Orders</a><br /><br />
               <a href="/#application.type#apps/servicerequests/telephonewosdbreport.cfm"> Telephone Work Orders</a><br />
               <br />
		</td>
     </cfif>
	</tr>
	
</cfif>
	<tr>
     	<cfif #Client.SecurityFlag# EQ "Yes">
		<th align="LEFT" valign="top">SUPPORT FILE PROCESSING</th>
          <cfelse>
          <th align="LEFT" valign="top">&nbsp;&nbsp;</th>
          </cfif>
		<th align="LEFT" valign="top">SUPPORT FILE REPORTS</th>
	</tr>

	<tr>
     	<cfif #Client.SecurityFlag# EQ "Yes">

		<td align="LEFT" valign="top">
          	<br />
			Actions - <a href="/#application.type#apps/servicerequests/actionsinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/actionsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Completed Comments - <a href="/#application.type#apps/servicerequests/completedcommentsinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/completedcommentsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Group Assigned - <a href="/#application.type#apps/servicerequests/groupassignedinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/groupassignedinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			HWSW - <a href="/#application.type#apps/servicerequests/hwswinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/hwswinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Operating Systems - <a href="/#application.type#apps/servicerequests/opsysinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/opsysinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br /> 		
			Options - <a href="/#application.type#apps/servicerequests/optionsinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/optionsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Priority - <a href="/#application.type#apps/servicerequests/priorityinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/priorityinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Problem Categories - <a href="/#application.type#apps/servicerequests/probcatsinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/probcatsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Problem Sub-Categories - <a href="/#application.type#apps/servicerequests/probsubcatsinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/probsubcatsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Service Types - <a href="/#application.type#apps/servicerequests/servicetypesinfo.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/servicetypesinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
               Unit Liaisons - <a href="/#application.type#apps/servicerequests/unitliaisons.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/unitliaisons.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
			Workgroup Assignments - <a href="/#application.type#apps/servicerequests/workgroupassigns.cfm?PROCESS=Add">Add</a> or
			<a href="/#application.type#apps/servicerequests/workgroupassigns.cfm?PROCESS=MODIFYDELETE">Modify/Delete</a><br />
               <br />
		</td>

           <cfelse>

          <td align="LEFT" valign="top">&nbsp;&nbsp;</td>

          </cfif>

		<td align="LEFT" valign="top">
          	<br />
			<a href="/#application.type#apps/servicerequests/actionsdbreport.cfm">Actions</a><br />
			<a href="/#application.type#apps/servicerequests/completedcommentsdbreport.cfm">Completed Comments</a><br />
			<a href="/#application.type#apps/servicerequests/groupassigneddbreport.cfm">Group Assigned</a><br />
			<a href="/#application.type#apps/servicerequests/hwswdbreport.cfm">HWSW</a><br />
			<a href="/#application.type#apps/servicerequests/opsysdbreport.cfm"> Operating Systems</a><br />		
			<a href="/#application.type#apps/servicerequests/optionsdbreport.cfm">Options</a><br />
			<a href="/#application.type#apps/servicerequests/prioritydbreport.cfm">Priority</a><br />
			<a href="/#application.type#apps/servicerequests/probcatsdbreport.cfm">Problem Categories</a><br />
			<a href="/#application.type#apps/servicerequests/probsubcatsdbreport.cfm">Problem Sub-Categories</a><br />
			<a href="/#application.type#apps/servicerequests/servicetypesdbreport.cfm">Service Types</a><br />
               <a href="/#application.type#apps/servicerequests/unitliaisonsdbreport.cfm">Unit Liaisons</a><br />
			<a href="/#application.type#apps/servicerequests/workgroupassignsdbreport.cfm">Workgroup Assignments</a><br />
               <br />
		</td>
	</tr>
 --->
	<cfinclude template="../LibraryApplicationLinks.cfm">
</table>

<cfinclude template="/include/coldfusion/footer.cfm">
</cfoutput>

</body>
</html>