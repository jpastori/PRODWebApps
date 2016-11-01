<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: claimednotcomplkuplist.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/12/2012 --->
<!--- Date in Production: 10/12/2012 --->
<!--- Module: SR Comments via List/Lookup and SR Claimed/Not Completed Report --->
<!-- Last modified by John R. Pastori on 06/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm">
<cfset CONTENT_UPDATED = "June 30, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<cfif (FIND('joel', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
	<cfset SESSION.ORIGINSERVER = "JOEL">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html>
<head>
	<title>SR Comments via List/Lookup and SR Claimed/Not Completed Report</title>
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
		if (document.LOOKUP1.GROUPID.selectedIndex == "0") {
			alertuser ("You must select a Group Name.");
			document.LOOKUP1.GROUPID.focus();
			return false;
		}
	}


	function validateSTAFFIDReqFields() {
		if (document.LOOKUP2.CUSTOMERID.selectedIndex == "0") {
			alertuser ("You must select a Staff ID.");
			document.LOOKUP2.CUSTOMERID.focus();
			return false;
		}
	}
	
	
	function validateRadioButtonChecked() {
		checked=false;
		if (document.SELECTSR.SRID.length > 1) { 
			for(i=0; i<document.SELECTSR.SRID.length; i++){
			    if (document.SELECTSR.SRID[i].checked)
				   checked=true;
			}
			if (!checked) {
				alertuser ("You must select a Service Request.");
				document.SELECTSR.SRID[1].focus();
				return false;
			}
		}else{
			if (document.SELECTSR.SRID.checked) {
				   checked=true;
			}
			if (!checked) {
				alertuser ("You must select a Service Request.");
				document.SELECTSR.SRID.focus();
				return false;
			}
		}
	}

//
</script>
<!--Script ends here -->

</head>

<cfoutput>

<cfif IsDefined('URL.LIST_LOOKUP')>
	<cfset CLIENT.LIST_LOOKUP = "#URL.LIST_LOOKUP#">
</cfif>

<cfif CLIENT.LIST_LOOKUP EQ "LIST">
	<cfif NOT IsDefined('URL.LOOKUPGROUPID') AND NOT IsDefined('URL.LOOKUPSTAFFID')>
          <cfset CURSORFIELD = "document.LOOKUP1.GROUPID.focus()">
     <cfelse>
          <cfset CURSORFIELD = "">
     </cfif>
     <cfset SESSION.CUSTOMERFLAG = "NO">
     <cfset SESSION.GROUPFLAG = "NO">
</cfif>

<cfif CLIENT.LIST_LOOKUP EQ "LOOKUP">
	<cfif NOT IsDefined('URL.LOOKUPSTAFFID')>
          <cfset CURSORFIELD = "document.LOOKUP2.CUSTOMERID.focus()">
     <cfelse>
          <cfset CURSORFIELD = "document.SELECTSR.SRID[1].focus()">
     </cfif>
</cfif>

<body onLoad="#CURSORFIELD#">

<!--- 
*************************************************************************************************************************
* The following code is the Group Assigned and Staff Assigned Records Lookup Process for SR Claimed/Not Completed List. *
*************************************************************************************************************************
 --->
 

<cfif NOT IsDefined('URL.LOOKUPGROUPID') AND NOT IsDefined('URL.LOOKUPSTAFFID')>

     <cfset CLIENT.REPORTTITLE = ''>

	<cfquery name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPNAME
	</cfquery>
	
     <cfquery name="ListStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	UNIQUE WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(WGA.STAFFCUSTOMERID = CUST.CUSTOMERID) AND
          		(WORKGROUPASSIGNSID = 0 OR
          	<CFIF Client.CUSTOMERID EQ 501 or Client.CUSTOMERID EQ 162>
               	WGA.GROUPID IN (4,5,7,9,11,19) AND
               </CFIF>
          		WGA.ACTIVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</cfquery>
	<table width="100%" align="center" border="3">
		<tr align="center">
          <cfif CLIENT.LIST_LOOKUP EQ "LIST">
			<td align="center"><h1>SR Claimed/Not Completed List Lookup</h1></td>
          <cfelse>
          	<td align="center"><h1>Modify SR Comments via List Lookup</h1></td>
          </cfif>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<td align="center"><h4>One of the Lookup Fields MUST be chosen!</h4></td>
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

	<cfif CLIENT.LIST_LOOKUP EQ "LIST">

          <tr>
			<th align="left" width="50%"><label for="GROUPID">Group</label></th>
               <th align="left" width="50%"><label for="REPORTSORTORDER1">Group Report Sort Order</label></th>
		</tr>
<cfform name="LOOKUP1" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LOOKUPGROUPID=FOUND&LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">
		<tr>
			<td align="left" width="50%">
				<cfselect name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" selected ="0" display="GROUPNAME" required="No" tabindex="2"></cfselect>
               </td>
               <td align="left" width="50%">
                   	<cfselect name="REPORTSORTORDER1" id="REPORTSORTORDERD1" size="1" required="No" tabindex="3">
                         <option value="0">Select a Sort Order</option>
                    	<option value="1">SR Number</option>
                         <option value="2">Priority/SR Number</option>
                         <option value="3">Requester/SR Number</option>
                         <option value="5">Creation Date/SR Number</option>
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

	</cfif>

          <tr>
			<th align="left" width="50%"><label for="CUSTOMERID">Staff Assigned</label></th>
               <th align="left" width="50%"><label for="REPORTSORTORDER2">Staff Assigned Report Sort Order</label></th>
		</tr>
<cfform name="LOOKUP2" onsubmit="return validateSTAFFIDReqFields();" action="/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LOOKUPSTAFFID=FOUND&LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">
		<tr>
			<td align="left" width="50%">
				<cfselect name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListStaffAssigned" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" required="No" tabindex="5"></cfselect>
               </td>
               <td align="left" width="50%">
                   	<cfselect name="REPORTSORTORDER2" id="REPORTSORTORDER2" size="1" required="No" tabindex="6">
                         <option value="0">Select a Sort Order</option>
                    	<option value="1">SR Number</option>
                         <option value="2">Priority/SR Number</option>
                         <option value="3">Requester/SR Number</option>
                         <option value="4">Priority/Code/SR Number</option>
                         <option value="5">Creation Date/SR Number</option>
                    </cfselect>
			</td>
          </tr>
          <tr>
               <td align="left" colspan="2">
				<input type="image" src="/images/buttonSelectStaff.jpg" value="Select Staff" alt="Select Staff" tabindex="7" />
			</td>
		</tr>
</cfform>
		
          <tr>
			<td align="left" colspan="3">&nbsp;&nbsp;</td>
		</tr>
          <tr>
			<td align="left" colspan="3">&nbsp;&nbsp;</td>
		</tr>
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>
		</tr>
		<tr>
			<td align="left" colspan="3"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

	<cfexit>
     
<cfelse>

<!--- 
***************************************************************************************************************************
* The following code is the Group Assigned or Staff Assigned Records Selection Process for SR Claimed/Not Completed List. *
***************************************************************************************************************************
 --->

     <cfset SESSION.LKUPSTAFFCUSTOMERID = "">

     <cfif IsDefined('URL.LKUPSTAFFCUSTOMERID')>
          <cfset FORM.CUSTOMERID = "#URL.LKUPSTAFFCUSTOMERID#">
     </cfif>

 	<cfif CLIENT.LIST_LOOKUP EQ "LIST">
           
          <cfif IsDefined ('FORM.GROUPID')>
     
               <cfquery name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                    SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.GROUPASSIGNEDID, GA.GROUPID, GA.GROUPNAME, SR.SRCOMPLETED
                    FROM		SERVICEREQUESTS SR, GROUPASSIGNED GA 
                    WHERE	SR.GROUPASSIGNEDID = GA.GROUPID AND
					<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                              SR.GROUPASSIGNEDID IN (7,19) AND
                         <CFELSE> 
                              SR.GROUPASSIGNEDID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         </CFIF>
                              SR.SRCOMPLETED = 'NO'
                    ORDER BY	SR.SERVICEREQUESTNUMBER
               </cfquery>
               
               <cfif #LookupServiceRequests.RecordCount# EQ 0>
                    <script language="JavaScript">
                         <!-- 
                              alert("Records for your selected Group were Not Found");
                         --> 
                    </script>
                    <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" />
                    <cfexit>
               </cfif>
               
               <cfset SRIDS = #ValueList(LookupServiceRequests.SRID)#>
               <!--- <BR>SR IDS = #SRIDS# <BR> --->
     
               <cfquery name="LookupGroupStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                    SELECT	DISTINCT SRSA.SRID, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, SRSA.STAFF_COMPLETEDSR
                    FROM		SRSTAFFASSIGNMENTS SRSA
                    WHERE	(SRSA.STAFF_COMPLETEDSR = 'NO') AND
                              ((SRSA.SRID IN (#ValueList(LookupServiceRequests.SRID)#) AND
                              SRSA.NEXT_ASSIGNMENT = 'NO') OR
					<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                              (SRSA.NEXT_ASSIGNMENT_GROUPID IN (7,19) AND
                         <CFELSE> 
                              (SRSA.NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         </CFIF>
                              SRSA.NEXT_ASSIGNMENT = 'YES' AND
                              NOT (SRSA.SRID IN (#ValueList(LookupServiceRequests.SRID)#))))
                    ORDER BY	SRSA.SRID
               </cfquery>
               
               <cfif #LookupGroupStaffAssignments.RecordCount# EQ 0>
                    <script language="JavaScript">
                         <!-- 
                              alert(" Staff Assignment Records for your selected Group were Not Found");
                         --> 
                    </script>
                    <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" />
                    <cfexit>
               </cfif>
     
               <cfset SESSION.GROUPSRS = #ValueList(LookupGroupStaffAssignments.SRID)#>
               <!--- <BR>GROUP SRS = #SESSION.GROUPSRS# <BR> --->
               <cfset SESSION.LKUPGROUPID = #FORM.GROUPID#>
               <cfset SESSION.GROUPFLAG = "YES">
               <cfset SESSION.CUSTOMERFLAG = "NO">
                    
          <cfelseif IsDefined ('FORM.CUSTOMERID')> 
        
               <cfset SESSION.LKUPSTAFFCUSTOMERID = #FORM.CUSTOMERID#>
               <cfset SESSION.GROUPFLAG = "NO">
               <cfset SESSION.CUSTOMERFLAG = "YES">
               
          </cfif>
     
     </cfif>
     
     <cfif CLIENT.LIST_LOOKUP EQ "LOOKUP" OR SESSION.CUSTOMERFLAG EQ "YES">
 
          <cfquery name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
               SELECT	DISTINCT WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE
               FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                         CUST.ACTIVE = 'YES' AND
                         WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	CUST.FULLNAME
          </cfquery>
          
		<cfset FORM.CUSTOMERID = "#LookupStaffAssigned.STAFFCUSTOMERID#">
          <cfset SESSION.LKUPSTAFFCUSTOMERID = #LookupStaffAssigned.STAFFCUSTOMERID#>
       
	</cfif>
          
</cfif>

<!--- 
**********************************************************************************************************
* The following code is the Display form Staff Assigned Records for IDT SR Claimed/Not Completed Report. *
**********************************************************************************************************
 --->
 
<cfset CLIENT.REPORTCHOICE = 0>
<cfset CLIENT.REPORTORDER = 0>
<cfset CLIENT.REPORTTILE1 = "">
<cfset CLIENT.REPORTTILE2 = "">
<cfset CLIENT.REPORTTILE3 = "">

<cfif IsDefined('FORM.REPORTSORTORDER1') AND #FORM.REPORTSORTORDER1# GT 0>
	<cfset CLIENT.REPORTCHOICE = #FORM.REPORTSORTORDER1#>
<cfelseif IsDefined('FORM.REPORTSORTORDER2') AND #FORM.REPORTSORTORDER2# GT 0>
	<cfset CLIENT.REPORTCHOICE = #FORM.REPORTSORTORDER2#>
<cfelse>
	<cfset CLIENT.REPORTCHOICE = 2>
</cfif>
 
<cfset SORTORDER = ARRAYNEW(1)>
<cfset SORTORDER[1]  = 'SR.SERVICEREQUESTNUMBER'>
<cfset SORTORDER[2]  = 'P.PRIORITYNAME~ SR.SERVICEREQUESTNUMBER'>
<cfset SORTORDER[3]  = 'REQCUST.FULLNAME~ SR.SERVICEREQUESTNUMBER'>
<cfset SORTORDER[4]  = 'P.PRIORITYNAME~ SRSA.STAFF_ASSIGNMENT_ORDER~ SR.SERVICEREQUESTNUMBER'>
<cfset SORTORDER[5]  = 'SR.CREATIONDATE~ SR.SERVICEREQUESTNUMBER'>

<cfset CLIENT.REPORTORDER = EVALUATE("SORTORDER[#CLIENT.REPORTCHOICE#]")>

<cfif FIND('~', #CLIENT.REPORTORDER#, 1) NEQ 0>
	<cfset CLIENT.REPORTORDER = ListChangeDelims(CLIENT.REPORTORDER, ",", "~")>
</cfif>	

<cfif CLIENT.LIST_LOOKUP EQ "LIST">
	<cfset CLIENT.REPORTTITLE1 = "SR Claimed/Not Completed List">
<cfelse>
	<cfset CLIENT.REPORTTITLE1 = "Modify SR Comments via List">
</cfif>

<cfif IsDefined('SESSION.GROUPFLAG') AND SESSION.GROUPFLAG EQ "YES">
     
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
                    SR.PG_STAFFASSIGNEDCOUNT > 0 AND
                    SR.SRID IN (#SESSION.GROUPSRS#)
		ORDER BY	#CLIENT.REPORTORDER# DESC
	</cfquery>
     
     <cfquery name="LookupGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
          SELECT	GROUPID, GROUPNAME
          FROM		GROUPASSIGNED
          WHERE	GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	GROUPNAME
     </cfquery>
     
     <cfif #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
     	<cfset CLIENT.REPORTTITLE2 = "For Groups: &nbsp;&nbsp;ES/AA and ES/LIB">
     <cfelse>
     	<cfset CLIENT.REPORTTITLE2 = "For Group: &nbsp;&nbsp;#LookupGroupAssigned.GROUPNAME#">
     </cfif>
     
<cfelse>

     <cfquery name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SRSA.SRID, SRSA.NEXT_ASSIGNMENT, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, CUST.CUSTOMERID, CUST.FULLNAME AS STAFF, SR.SRID, 
                    SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATEDATE, SR.REQUESTERID, REQCUST.CUSTOMERID, 
                    REQCUST.FULLNAME AS REQUESTER, CUST.ACTIVE, SR.PRIORITYID, P.PRIORITYNAME, SR.PROBLEM_DESCRIPTION, SRSA.STAFF_ASSIGNMENT_ORDER
          FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PRIORITY P
          WHERE	(SRSA.SRID = SR.SRID AND
                    SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                    WGA.STAFFCUSTOMERID = CUST.CUSTOMERID  AND
                    SRSA.STAFF_COMPLETEDSR = 'NO') AND
                    (WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR">) AND
                    (SR.REQUESTERID = REQCUST.CUSTOMERID AND
                    SR.PRIORITYID = P.PRIORITYID)
          ORDER BY	#CLIENT.REPORTORDER# DESC
     </cfquery>
     
     <cfset CLIENT.REPORTTITLE2 = "For Staff Assigned: &nbsp;&nbsp;#GetServiceRequests.STAFF#">
     
</cfif>

<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center">
			<h1>#CLIENT.REPORTTITLE1#</h1>
			<h2>#CLIENT.REPORTTITLE2#</h2>
		</td>       
	</tr>
</table>
<br clear="left" />

<table width="100%" border="0">
	<tr>
<cfform action="/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">
		<td align="left">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
		</td>
</cfform>
	</tr>
	<tr>
		<th align="CENTER"><h2>#GetServiceRequests.RecordCount# Service Request records were selected.</h2></th>
	</tr>
</table>
<cfif CLIENT.LIST_LOOKUP EQ "LOOKUP"> 
<cfform name="SELECTSR" onsubmit="return validateRadioButtonChecked();" action="/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=MODIFYDELETE&LOOKUPSRSTAFFASSIGN=FOUND&LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">

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
		<th align="center">Priority</th>
		<th align="center">Requester</th>
		<th align="center">Problem Description</th>
		<th align="center">Creation Date</th>
          <th align="center">C</th>
	</tr>

<cfloop query="GetServiceRequests">

	<tr>
		<td align="center" valign="TOP">
			<cfinput type="radio" name="SRID" value="#GetServiceRequests.SRID#">
		</td>
		<td align="center" valign="TOP"><div>#GetServiceRequests.SERVICEREQUESTNUMBER#</div></td>
		<td align="left" valign="TOP">
          	<cfif #GetServiceRequests.PRIORITYID# EQ 1>
                    <div><strong><font color="RED">#GetServiceRequests.PRIORITYNAME#</font></strong></div>
               <cfelseif #GetServiceRequests.PRIORITYID# EQ 2>
                    <div><strong><font color="BLUE">#GetServiceRequests.PRIORITYNAME#</font></strong></div>
			<cfelseif #GetServiceRequests.PRIORITYID# EQ 4>
                    <div><strong><font color="GREEN">#GetServiceRequests.PRIORITYNAME#</font></strong></div>
               <cfelse>
                    <div><font color="BLACK">#GetServiceRequests.PRIORITYNAME#</font></div>
               </cfif>	
          </td>
		<td align="left" valign="TOP"><div>#GetServiceRequests.REQUESTER#</div></td>
		<td align="left" valign="TOP"><div>#LEFT(GetServiceRequests.PROBLEM_DESCRIPTION, 100)#</div></td>
		<td align="center" valign="TOP"><div>#GetServiceRequests.CREATEDATE#</div></td>
          <td align="center" valign="TOP"><div>#GetServiceRequests.STAFF_ASSIGNMENT_ORDER#</div></td>
	</tr>

</cfloop>
	<tr>
		<td align="left" colspan="7" valign="TOP">
			<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
		</td>
	</tr>
</table>
</cfform>

<cfelse>
<table width="100%" border="1">
	<tr> 
		<th align="center">SR</th>
		<th align="center">Priority</th>
		<th align="center">Requester</th>
		<th align="center">Problem Description</th>
		<th align="center">Creation Date</th>
     <cfif IsDefined('SESSION.GROUPFLAG') AND #SESSION.GROUPFLAG# EQ "YES">
     	<th align="center">Staff Assigned</th>
     </cfif>
	</tr>

<cfloop query="GetServiceRequests">

	<tr>
		<td align="center" valign="TOP"><div>#GetServiceRequests.SERVICEREQUESTNUMBER#</div></td>
		<td align="left" valign="TOP"><div>#GetServiceRequests.PRIORITYNAME#</div></td>
		<td align="left" valign="TOP"><div>#GetServiceRequests.REQUESTER#</div></td>
		<td align="left" valign="TOP"><div>#LEFT(GetServiceRequests.PROBLEM_DESCRIPTION, 100)#</div></td>
		<td align="center" valign="TOP"><div>#GetServiceRequests.CREATEDATE#</div></td>
	
	<cfif IsDefined('SESSION.GROUPFLAG') AND #SESSION.GROUPFLAG# EQ "YES">

          <cfquery name="LookupStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.NEXT_ASSIGNMENT, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, 
                         SR.SERVICEREQUESTNUMBER, WGA.STAFFCUSTOMERID, CUST.FULLNAME AS STAFF, CUST.FULLNAME || '-' || SR.SERVICEREQUESTNUMBER AS LOOKUPSTAFF,
                         TO_CHAR(STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED
               FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
               		SRSA.SRID = SR.SRID AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         SRSA.STAFF_ASSIGNEDID > 0 AND
                         SRSA.STAFF_COMPLETEDSR = 'NO' AND
                         SRSA.NEXT_ASSIGNMENT_GROUPID = GA.GROUPID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                         SRSA.STAFF_COMPLETEDSR = 'NO'
               ORDER BY	STAFF
          </cfquery>
		
          <td align="left" valign="top">
               <cfloop query="LookupStaffAssignments">
                    <div>#LookupStaffAssignments.STAFF#</div><br />
               </cfloop>
		</td>

     </cfif>

	</tr>
</cfloop>

</TABLE>
			
</cfif>

<table width="100%" border="0">
	<tr>
		<th align="CENTER" colspan="6"><h2>#GetServiceRequests.RecordCount# Service Request records were selected.</h2></th>
	</tr>

	<tr>
<cfform action="/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">
		<td align="left" colspan="6">
          	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" />
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