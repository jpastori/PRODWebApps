<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: unassignedbygrouplookup.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2016 --->
<!--- Date in Production: 06/30/2016 --->
<!--- Module: Unassigned SR List By Group Report --->
<!-- Last modified by John R. Pastori on 07/20/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm">
<cfset CONTENT_UPDATED = "July 20, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<cfif (FIND('joel', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
	<cfif (IsDefined('URL.GROUPID')) >
     	<cfset FORM.GROUPID = #URL.GROUPID#>
     </cfif>
	<cfset SESSION.ORIGINSERVER = "JOEL">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html>
<head>
	<title> Unassigned SR List By Group Report</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Service Requests Application!";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


	function validateGROUPReqFields() {
		if (document.LOOKUP.GROUPID.selectedIndex == "0") {
			alertuser ("You must select a Group Name.");
			document.LOOKUP.GROUPID.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTSORTORDER.selectedIndex == "0") {
			alertuser ("You must select a Sort Order.");
			document.LOOKUP.REPORTSORTORDER.focus();
			return false;
		}
	}

//
</script>
<!--Script ends here -->

</head>

<cfoutput>

<cfif NOT IsDefined('URL.LOOKUPGROUPID')>
	<cfset CURSORFIELD = "document.LOOKUP.GROUPID.focus()">
<cfelse>
	<cfset CURSORFIELD = "">
</cfif>

<body onLoad="#CURSORFIELD#">

<!--- 
**********************************************************************************************************
* The following code is the Group Assigned Lookup Process for SRDisplay List Unassigned By Group Lookup. *
**********************************************************************************************************
 --->
 

<cfif NOT IsDefined('URL.LOOKUPGROUPID')>

	<cfquery name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
     <CFIF Client.CUSTOMERID EQ 501 or Client.CUSTOMERID EQ 162>
          WHERE   	GROUPID IN (0,4,5,7,9,11,19)
     </CFIF>
		ORDER BY	GROUPNAME
	</cfquery>
	
	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Unassigned SR List By Group Lookup</h1></td>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<td align="center"><h4>A Group MUST be chosen!</h4></td>
		</tr>
	</table>
	<br />
	<table width="100%" align="LEFT" border="0">
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>
		</tr>
          <tr>
			<th align="left" width="50%"><h4><label for="GROUPID">*Group</label></h4></th>
               <th align="left" width="50%"><label for="REPORTSORTORDER">Group Report Sort Order</label></th>
		</tr>
<cfform name="LOOKUP" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm?LOOKUPGROUPID=FOUND" method="POST">
		<tr>
			<td align="left" width="50%">
				<cfselect name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" selected ="0" display="GROUPNAME" required="No" tabindex="2"></cfselect>
               </td>
               <td align="left" width="50%">
                   	<cfselect name="REPORTSORTORDER" id="REPORTSORTORDER" size="1" required="No" tabindex="3">
                         <option value="0">Select a Sort Order</option>
                    	<option value="1">SR Number</option>
                          <option selected value="2">Priority/SR Number</option>
                         <option value="3">Requester/SR Number</option>
                        <option value="4">Creation Date/SR Number</option>
                    </cfselect>
               </td>
          </tr>
          <tr>
               <td align="left" colspan="2">
				<input type="image" src="/images/buttonSelectGroup.jpg" value="Select Group" alt="Select Group" tabindex="4" />
			</td>
		</tr>
</cfform>
          <tr>
			<td align="left" colspan="2">&nbsp;&nbsp;</td>
		</tr>
          <tr>
			<td align="left" colspan="2">&nbsp;&nbsp;</td>
		</tr>
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>
		</tr>
		<tr>
			<td align="left" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

	<cfexit>
     
<cfelse>

<!--- 
**********************************************************************************************************************
* The following code is the Group Assigned Records Selection Process for SR Display List Unassigned By Group Lookup. *
**********************************************************************************************************************
 --->

      <cfquery name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
				TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SDINIT.FULLNAME AS INITNAME, SR.REQUESTERID, SR.ALTERNATE_CONTACTID,
				PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME || '--' || PROBSUBCAT.SUBCATEGORYNAME AS PROBCATEGORY,
				PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME, SR.PROBLEM_DESCRIPTION, SR.PG_STAFFASSIGNEDCOUNT
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY, GROUPASSIGNED IDTGROUP
         
     <CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
          WHERE	SR.GROUPASSIGNEDID IN (7,19) AND
     <CFELSE> 
     	WHERE	SR.GROUPASSIGNEDID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
     </CFIF>
				SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.PRIORITYID = PRIORITY.PRIORITYID AND
                    SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
                    SR.PG_STAFFASSIGNEDCOUNT < 1 AND
               	SR.SRCOMPLETED = 'NO'
		ORDER BY	SR.SERVICEREQUESTNUMBER
	</cfquery>
     
	<cfquery name="LookupGroupStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID AS SRSAIDENT, SR.SRID, SR.SERVICEREQUESTNUMBER, SRSA.STAFF_ASSIGNEDID, SRSA.STAFF_DATEASSIGNED, 
          		SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS, SRSA.NEXT_ASSIGNMENT, SR.GROUPASSIGNEDID, SRSA.NEXT_ASSIGNMENT_GROUPID,
                    SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID
		FROM		SRSTAFFASSIGNMENTS SRSA,  SERVICEREQUESTS SR
		WHERE	((SRSA.SRID = SR.SRID) AND
          <CFIF LookupServiceRequests.RecordCount GT 0>
          		((SRSA.SRID IN (#ValueList(LookupServiceRequests.SRID)#) AND
                    SRSA.STAFF_ASSIGNEDID = 0 AND           
          	<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
               	SR.GROUPASSIGNEDID IN (7,19) AND
                    SRSA.NEXT_ASSIGNMENT_GROUPID = 0) OR
               <CFELSE>
                    SR.GROUPASSIGNEDID = #val(FORM.GROUPID)#  AND
                    SRSA.NEXT_ASSIGNMENT_GROUPID = 0) OR
               </CFIF>
               	(SRSA.STAFF_ASSIGNEDID < 1 AND 
          	<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                    SRSA.NEXT_ASSIGNMENT_GROUPID IN (7,19))) AND
               <CFELSE>
                    SRSA.NEXT_ASSIGNMENT_GROUPID = #val(FORM.GROUPID)#)) AND
                </CFIF>
          <CFELSE>
          		(SRSA.STAFF_ASSIGNEDID < 1 AND 
          	<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                    SRSA.NEXT_ASSIGNMENT_GROUPID IN (7,19)) AND
               <CFELSE>
                    SRSA.NEXT_ASSIGNMENT_GROUPID = #val(FORM.GROUPID)#) AND
                </CFIF>            
          </CFIF>
                    (SRSA.STAFF_COMPLETEDSR = 'NO'))
          ORDER BY	SR.SERVICEREQUESTNUMBER
 	</cfquery>

	<cfif #LookupServiceRequests.RecordCount# EQ 0 AND #LookupGroupStaffAssignments.RecordCount# EQ 0>
		<script language="JavaScript">
				<!-- 
					alert("This group has NO unassigned Service Requests!");
				--> 
		</script>
		<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm" />
		<cfexit>
	<cfelse>
     	<cfset COUNTER = 0>
     	<cfset SRIDS = #ValueList(LookupServiceRequests.SRID)#>
          <cfset SRSA_SRIDS = #ValueList(LookupGroupStaffAssignments.SRID)#>
          <cfloop from = "1" to = "#ListLen(SRSA_SRIDS)#" index = "COUNTER">
          	<cfif LISTFIND(SRIDS, #ListGetAt(SRSA_SRIDS, COUNTER)#) EQ 0> 
          		<cfset SRIDS = ListAppend(SRIDS, #ListGetAt(SRSA_SRIDS, COUNTER)#)>
               </cfif>
          </cfloop>
          <cfset SRIDS = ListSort(SRIDS, "Numeric")>
     	<cfset SESSION.GROUPSRS = #SRIDS#>
	</cfif>
</cfif>

<!--- 
***************************************************************************************
* The following code displays the SR Display List Unassigned By Group Report Records. *
***************************************************************************************
 --->
 
<cfset CLIENT.REPORTORDER = 0>
 
<cfset SORTORDER = ARRAYNEW(1)>
<cfset SORTORDER[1]  = 'SR.SERVICEREQUESTNUMBER'>
<cfset SORTORDER[2]  = 'P.PRIORITYNAME~ SR.SERVICEREQUESTNUMBER'>
<cfset SORTORDER[3]  = 'REQCUST.FULLNAME~ SR.SERVICEREQUESTNUMBER'>
<cfset SORTORDER[4]  = 'SR.CREATIONDATE~ SR.SERVICEREQUESTNUMBER'>

<cfif (IsDefined('FORM.REPORTSORTORDER') AND #FORM.REPORTSORTORDER# GT 0)>
	<cfset CLIENT.REPORTORDER = #FORM.REPORTSORTORDER#>
<cfelse>
	<cfset CLIENT.REPORTORDER = 1>
</cfif>

<cfset CLIENT.REPORTSORTORDER = EVALUATE("SORTORDER[#CLIENT.REPORTORDER#]")>

<cfif FIND('~', #CLIENT.REPORTSORTORDER#, 1) NEQ 0>
	<cfset CLIENT.REPORTSORTORDER = ListChangeDelims(CLIENT.REPORTSORTORDER, ",", "~")>
</cfif>	

     
<cfquery name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
     SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATEDATE, SR.REQUESTERID, 		
               REQCUST.CUSTOMERID, REQCUST.FULLNAME AS REQUESTER, REQCUST.ACTIVE, SR.PROBLEM_DESCRIPTION, SR.PRIORITYID, P.PRIORITYNAME,
               SR.GROUPASSIGNEDID, GA.GROUPID, GA.GROUPNAME, SR.PG_STAFFASSIGNEDCOUNT
     FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PRIORITY P, GROUPASSIGNED GA 
     WHERE	SR.REQUESTERID = REQCUST.CUSTOMERID AND
               REQCUST.ACTIVE = 'YES' AND
               SR.PRIORITYID = P.PRIORITYID AND
               SR.GROUPASSIGNEDID = GA.GROUPID AND
               SR.SRCOMPLETED = 'NO' AND
               SR.PG_STAFFASSIGNEDCOUNT < 1 AND
               SR.SRID IN (#SESSION.GROUPSRS#)
     ORDER BY	#CLIENT.REPORTSORTORDER# DESC
</cfquery>
          
<cfquery name="LookupGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
     SELECT	GROUPID, GROUPNAME
     FROM		GROUPASSIGNED
     WHERE	GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC">
     ORDER BY	GROUPNAME
</cfquery>

<cfset session.lookupgroup = #FORM.GROUPID#>

<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center">
			<h1>Unassigned SR List By Group Report</h1>
		<cfif #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
          	<h2>For Group: &nbsp;&nbsp;ES/LIB - ES/AA</h2>
          <cfelse>
			<h2>For Group: &nbsp;&nbsp;#LookupGroupAssigned.GROUPNAME#</h2>
          </cfif>
		</td>       
	</tr>
</table>
<br clear="left" />

<table width="100%" border="0">
	<tr>
<cfform action="/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm" method="POST">
		<td align="left">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
		</td>
</cfform>
	</tr>
	<tr>
		<th align="CENTER"><h2>#GetServiceRequests.RecordCount# Service Request records were selected.</h2></th>
	</tr>
</table>

<cfform name="SELECTSR" onsubmit="return validateRadioButtonChecked();" action="/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=ADD" method="POST">

<table width="100%" border="1">
	<tr>
		<td align="left" colspan="7" valign="TOP">
			<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="2" />
		</td>
	</tr>
	<tr> 
		<th align="center">&nbsp;&nbsp;
		<cfif IsDefined('SESSION.LKUPSTAFFCUSTOMERID')>
               <cfinput type="hidden" name="LKUPSTAFFCUSTOMERID" value="#SESSION.LKUPSTAFFCUSTOMERID#" />
          </cfif>
		</th>
		<th align="center">SR</th>
		<th align="center">Creation Date</th>
		<th align="center">Priority</th>
		<th align="center">Problem Description</th>
		<th align="center">Requester</th>
	</tr>

<cfloop query="GetServiceRequests">

	<tr>
     	<td align="center" valign="TOP">
			<cfinput type="radio" name="SRID" value="#GetServiceRequests.SRID#">
		</td>
		<td align="center" valign="TOP"><div>#GetServiceRequests.SERVICEREQUESTNUMBER#</div></td>
		<td align="center" valign="TOP"><div>#GetServiceRequests.CREATEDATE#</div></td>
		<td align="left" valign="TOP"><div>#GetServiceRequests.PRIORITYNAME#</div></td>
		<td align="left" valign="TOP"><div>#LEFT(GetServiceRequests.PROBLEM_DESCRIPTION, 100)#</div></td>
		<td align="left" valign="TOP"><div>#GetServiceRequests.REQUESTER#</div></td>
	</tr>

</cfloop>
	<tr>
		<td align="left" colspan="7" valign="TOP">
			<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
		</td>
	</tr>
</table>
</cfform>
<table width="100%" border="0">
	<tr>
		<th align="CENTER" colspan="5"><h2>#GetServiceRequests.RecordCount# Service Request records were selected.</h2></th>
	</tr>
	
     <tr>
<cfform action="/#application.type#apps/servicerequests/srstaffassignloop.cfm?LOOKUPGROUPID=FOUND" method="POST">
		<td align="left" colspan="6">
          	<cfinput type="hidden" name="GROUPID" value="#FORM.GROUPID#" />
          	<input type="image" src="/images/buttonAssignLoop.jpg" value="ASSIGN LOOP" alt="Assign Loop" tabindex="4" />
          </td>
</cfform>
	</tr>
     
	<tr>
<cfform action="/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm" method="POST">
		<td align="left" colspan="5">
          	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" />
          </td>
</cfform>
	</tr>
     
	<tr>
		<td colspan="6">
			<cfinclude template="/include/coldfusion/footer.cfm">
		</td>
	</tr>
</table>


</body>
</cfoutput>
</html>