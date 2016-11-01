<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srstaffassignloop.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/13/2012 --->
<!--- Date in Production: 09/13/2012 --->
<!--- Module: SR - Unassigned SRs By Group Loop --->
<!-- Last modified by John R. Pastori on 07/20/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/srstaffassignloop.cfm">
<cfset CONTENT_UPDATED = "July 20, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<cfif (FIND('joel', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
	<cfset SESSION.ORIGINSERVER = "JOEL">
     <cfif (FIND('unassignedbygrouplookup.cfm', #CGI.HTTP_REFERER#, 1) NEQ 0)>
     	<cfset session.SRIDArray = ArrayNew(1)>
		<cfset temp = ArraySet(session.SRIDArray, 1, 1, 0)>
		<cfset session.ArrayCounter = 0>
     </cfif>
     <cfif (IsDefined('FORM.GROUPID'))>
     	<cfset session.LOOKUPGROUP = #FORM.GROUPID#>
     </cfif>
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html>
<head>
	<title>SR - UnAssigned SRs By Group Loop</title>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Service Requests Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


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
	}

	function validateReqFields() {
		var STAFF_ASSIGNEDID_checkboxError = 0;
		if (document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.length > 1) {
			for (i = 0; i < document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.length; i++) {
				if(document.SRSTAFFASSIGN.STAFF_ASSIGNEDID[i].checked) {
					STAFF_ASSIGNEDID_checkboxError = 1;
					break;			
				}else{
					STAFF_ASSIGNEDID_checkboxError = 0;		
				}
			}
		}else{
			if(document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.checked) {
				STAFF_ASSIGNEDID_checkboxError = 1;			
			}else{
				STAFF_ASSIGNEDID_checkboxError = 0;		
			}
		} 

		if (STAFF_ASSIGNEDID_checkboxError == 0) { 
			alertuser ("At Least One Staff Member must be assigned.");
			if (document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.length > 1) {
				document.SRSTAFFASSIGN.STAFF_ASSIGNEDID[0].focus();
			}else{
				document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.focus();		
			}
			return false;
		}

		if (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED != null && (document.STAFFSRASSIGN.STAFF_DATEASSIGNED.value == ""
		 || document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.value == " ")) {
			alertuser (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.name +  ",  You must enter a Staff Assigned Date.");
			document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.focus();
			return false;
		}

		if (document.SRSTAFFASSIGN.NEXT_ASSIGNMENT_REASON != null && (document.SRSTAFFASSIGN.NEXT_ASSIGNMENT_REASON.value == ""
		 || document.SRSTAFFASSIGN.NEXT_ASSIGNMENT_REASON.value == " ")) {
			alertuser ("You must enter a Next Assignment Reason.");
			document.SRSTAFFASSIGN.NEXT_ASSIGNMENT_REASON.focus();
			return false;
		}

		
	}

//
</script>
<script language="JavaScript" src="../calendar_us.js"></script>
<!--Script ends here -->

</head>

<cfoutput>
<cfif NOT IsDefined("URL.LOOKUPGROUPID")>
	<cfset CURSORFIELD = "document.LOOKUP.GROUPID.focus()">
<cfelse>
	<cfset CURSORFIELD = "document.SRSTAFFASSIGN.PROBLEM_DESCRIPTION.focus()">
</cfif>
<body onLoad="#CURSORFIELD#">

<!--- 
********************************************************************************************
* The following code is the Group Records Lookup Process for SR - Unassigned SRs By Group. *
********************************************************************************************
 --->

<cfif NOT IsDefined("URL.LOOKUPGROUPID")>
	<cfset session.SRIDArray = ArrayNew(1)>
	<cfset temp = ArraySet(session.SRIDArray, 1, 1, 0)>
	<cfset session.ArrayCounter = 0>
     <cfset session.LOOKUPGROUP = 0>

	<cfquery name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPNAME
	</cfquery>

	<cfinclude template="/include/coldfusion/formheader.cfm">

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>SR - Unassigned SRs By Group Loop Lookup</h1></td>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<td align="center"><h4>A Group Name MUST be chosen!</h4></td>
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
<cfform name="LOOKUP" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/srstaffassignloop.cfm?LOOKUPGROUPID=FOUND" method="POST">
		<tr>
			<th align="left"><h4><label for="GROUPID">*Group</label></h4></th>
		</tr>
		<tr>
			<td align="left">
				<cfselect name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" selected ="0" display="GROUPNAME" required="No" tabindex="2"></cfselect>
			</td>
		</tr>
		<tr>
			<td align="left">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="left">
               	<input type="image" src="/images/buttonSelectGroup.jpg" value="Select Group" alt="Select Group" tabindex="3" />
               </td>
		</tr>
</cfform>
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>

		</tr>
		<tr>
			<td align="left" width="33%"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
	<cfexit>

<cfelseif session.SRIDArray[1] EQ 0>

<!--- 
*******************************************************************************************************************************
* The following code is the Initial Loop Requested Multiple Group Records Selection Process for SR - Unassigned SRs By Group. *
*******************************************************************************************************************************
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
     	WHERE	SR.GROUPASSIGNEDID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_VARCHAR"> AND
     </CFIF>
				SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.PRIORITYID = PRIORITY.PRIORITYID AND
                    SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
                    SR.PG_STAFFASSIGNEDCOUNT = 0 AND
               	SR.SRCOMPLETED = 'NO'
		ORDER BY	SR.SERVICEREQUESTNUMBER
	</cfquery>
     
	<cfquery name="ListSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
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
               	(SRSA.STAFF_ASSIGNEDID = 0 AND 
          	<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                    SRSA.NEXT_ASSIGNMENT_GROUPID IN (7,19))) AND
               <CFELSE>
                    SRSA.NEXT_ASSIGNMENT_GROUPID = #val(FORM.GROUPID)#)) AND
                </CFIF>
          <CFELSE>
          		(SRSA.STAFF_ASSIGNEDID = 0 AND 
          	<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                    SRSA.NEXT_ASSIGNMENT_GROUPID IN (7,19)) AND
               <CFELSE>
                    SRSA.NEXT_ASSIGNMENT_GROUPID = #val(FORM.GROUPID)#) AND
                </CFIF>            
          </CFIF>
                    (SRSA.STAFF_COMPLETEDSR = 'NO'))
          ORDER BY	SR.SERVICEREQUESTNUMBER
 	</cfquery>

	<cfif #LookupServiceRequests.RecordCount# EQ 0 AND #ListSRStaffAssignments.RecordCount# EQ 0>
		<script language="JavaScript">
				<!-- 
					alert("This group has NO unassigned Service Requests!");
				--> 
		</script>
		<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassignloop.cfm" />
		<cfexit>
     <cfelse>
     	<cfset COUNTER = 0>
     	<cfset SRIDS = #ValueList(LookupServiceRequests.SRID)#>
          <cfset SRSA_SRIDS = #ValueList(ListSRStaffAssignments.SRID)#>
          <cfloop from = "1" to = "#ListLen(SRSA_SRIDS)#" index = "COUNTER">
          	<cfif LISTFIND(SRIDS, #ListGetAt(SRSA_SRIDS, COUNTER)#) EQ 0> 
          		<cfset SRIDS = ListAppend(SRIDS, #ListGetAt(SRSA_SRIDS, COUNTER)#)>
               </cfif>
          </cfloop>
          <cfset SRIDS = ListSort(SRIDS, "Numeric")>
	</cfif>

	<cfset temp = ArraySet(session.SRIDArray, 1, LISTLEN(SRIDS), 0)>
     <cfset session.SRIDArray = ListToArray(SRIDS)>
     <br /><br />SRIDS = #SRIDS#<br /><br />
	<cfset session.LOOKUPGROUP = #FORM.GROUPID#>   

</cfif>

<!--- 
*********************************************************************************************************
* The following code is the Display form for Group Records Add Process to SR - Unassigned SRs By Group. *
*********************************************************************************************************
 --->

<cfset session.ArrayCounter = #session.ArrayCounter# + 1>

<cfif session.ArrayCounter GT ARRAYLEN(session.SRIDArray)>
	<h1>All Selected Records Processed!</h1>
     <cfif (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
     	<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm" />
     <cfelse>
		<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/srstaffassignloop.cfm" />
     </cfif>
	<cfexit>
</cfif>

<cfset FORM.SRID = #session.SRIDArray[session.ArrayCounter]#>

<cfquery name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
	SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
			TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SR.REQUESTERID, SR.ALTERNATE_CONTACTID,
			PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY, PROBSUBCAT.SUBCATEGORYNAME,
			SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.ASSIGN_PRIORITY, SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME,
			SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETED
	FROM		SERVICEREQUESTS SR, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
			GROUPASSIGNED IDTGROUP
	WHERE	SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
			SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
			SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
			SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
			SR.PRIORITYID = PRIORITY.PRIORITYID AND
			SR.SRCOMPLETED = 'NO'
	ORDER BY	SR.SERVICEREQUESTNUMBER
</cfquery>

<cfcookie name="SRID" secure="NO" value="#GetServiceRequests.SRID#">

<cfquery name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA">
	SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE
	FROM		CUSTOMERS CUST
	WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.REQUESTERID#" cfsqltype="CF_SQL_VARCHAR"> AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</cfquery>

<cfquery name="LookupPriority" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
	SELECT	PRIORITYID, PRIORITYNAME
	FROM		PRIORITY
	ORDER BY	PRIORITYNAME
</cfquery>

<cfquery name="GetSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
	SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SR.SRID, SR.SERVICEREQUESTNUMBER, SRSA.STAFF_ASSIGNEDID, SRSA.STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED,
			SRSA.STAFF_COMMENTS, SRSA.NEXT_ASSIGNMENT, SR.GROUPASSIGNEDID, SRSA.NEXT_ASSIGNMENT_GROUPID, IDTGROUP.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON,
			SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID
	FROM		SRSTAFFASSIGNMENTS SRSA, GROUPASSIGNED IDTGROUP,  SERVICEREQUESTS SR
	WHERE	((SRSA.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC">) AND
     	<CFIF #session.LOOKUPGROUP# EQ 7 OR #session.LOOKUPGROUP# EQ 19>
               ((SR.GROUPASSIGNEDID IN (7,19) AND
               SRSA.NEXT_ASSIGNMENT_GROUPID = 0) OR
          <CFELSE>
               ((SR.GROUPASSIGNEDID = #session.LOOKUPGROUP#  AND
               SRSA.NEXT_ASSIGNMENT_GROUPID = 0) OR
          </CFIF>
          <CFIF #session.LOOKUPGROUP# EQ 7 OR #session.LOOKUPGROUP# EQ 19>
               (SRSA.NEXT_ASSIGNMENT_GROUPID IN (7,19))) AND
          <CFELSE>
               (SRSA.NEXT_ASSIGNMENT_GROUPID = #session.LOOKUPGROUP#)) AND
          </CFIF>
			(SRSA.STAFF_ASSIGNEDID = 0 AND
			SRSA.NEXT_ASSIGNMENT_GROUPID = IDTGROUP.GROUPID AND
               SRSA.SRID = SR.SRID AND
			SRSA.STAFF_COMPLETEDSR = 'NO'))
	ORDER BY	SR.SERVICEREQUESTNUMBER, IDTGROUP.GROUPNAME
</cfquery>

<cfquery name="LookupOtherStaff" datasource="#application.type#SERVICEREQUESTS">
     SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, GA.GROUPID, GA.GROUPNAME AS WORKGROUPNAME,
               CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS, SRSA.NEXT_ASSIGNMENT, WGA.ACTIVE,
               SRSA.NEXT_ASSIGNMENT_GROUPID, NGA.GROUPID, NGA.GROUPNAME AS NEXTGROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR,
               SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID
     FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, GROUPASSIGNED NGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
     WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
               SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
               SRSA.STAFF_ASSIGNEDID > 0 AND
               WGA.GROUPID = GA.GROUPID AND
               WGA.ACTIVE = 'YES' AND
               SRSA.NEXT_ASSIGNMENT_GROUPID = NGA.GROUPID AND
               WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
     ORDER BY	CUST.FULLNAME
</cfquery>


<cfquery name="LookupStaffUnAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
	SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER, WGA.ACTIVE,
			CUST.FULLNAME || ' - ' || WGA.GROUPORDER  || ' - ' ||  GA.GROUPNAME AS CUSTOMERGROUP
	FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
<CFIF #GetSRStaffAssignments.RecordCount# GT 0 AND #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'YES'>
	WHERE	WGA.GROUPID = <CFQUERYPARAM value="#GetSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
<CFELSE>
	WHERE	WGA.GROUPID = <CFQUERYPARAM value="#GetServiceRequests.GROUPASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR"> AND
</CFIF>
			WGA.GROUPID = GA.GROUPID AND
			WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
		<CFIF LookupOtherStaff.RecordCount GT 0>
               NOT WGA.WORKGROUPASSIGNSID IN (#ValueList(LookupOtherStaff.STAFF_ASSIGNEDID)#) AND
          </CFIF>
          	WGA.ACTIVE = 'YES'
	ORDER BY	GA.GROUPNAME, CUST.FULLNAME
</cfquery>

<cfquery name="ListServDeskInitials" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, ACTIVE
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = #Client.CUSTOMERID# AND
			INITIALS IS NOT NULL AND
			ACTIVE = 'YES'
	ORDER BY	FULLNAME
</cfquery>

<table width="100%" align="center" border="3">
     <tr align="center">
          <td align="center"><h1>SR - Unassigned SRs By Group Loop</h1></td>
     </tr>
</table>
<table width="100%" align="center" border="0">
     <tr>
          <th align="center">
               <h4>*Red fields marked with asterisks are required!</h4><br>
               Service Request Key &nbsp; = &nbsp; #FORM.SRID#<br>
          <cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ "YES">
               <br><h2> This assignment is a Next Referral </h2><br>
          </cfif>
          </th>
     </tr>
</table>
<br clear="left" />

<table align="left" width="100%" border="0">
	<tr>
<cfform action="/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm" method="POST">
		<td align="left">
			<input type="image" src="/images/buttonCancelAssignLp.jpg" value="CANCEL ASSIGN LOOP" alt="Cancel Assign Loop" tabindex="1" /><br />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</td>
</cfform>
	</tr>
	<tr>
          <td align="left">&nbsp;&nbsp;</td>
	</tr>
     <tr>
<cfform action="/#application.type#apps/servicerequests/srstaffassignloop.cfm?LOOKUPGROUPID=FOUND" method="POST">
		<td align="left">
          	<cfif (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
          		<cfset session.LOOKUPGROUP = #FORM.GROUPID#>
          		<input type="hidden" name="GROUPID" value="#FORM.GROUPID#" />
               </cfif>
          	<input type="image" src="/images/buttonNextRec.jpg" value="NEXT RECORD" alt="Next Record" tabindex="2" />
          </td>
</cfform>
	</tr>
     <tr>
          <td align="left">&nbsp;&nbsp;</td>
	</tr>
</table>

<fieldset>
<legend>Service Request</legend>
<cfform name="SRSTAFFASSIGN" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processsrstaffassigninfo.cfm" method="POST" enablecab="Yes">
<table width="100%" align="LEFT">
	<tr>
		<th align="left" width="33%">SR</th>
		<th align="left" width="33%">Creation Date</th>
		<th align="left" width="33%">Creation Time</th>
	</tr>
	<tr>
		<td align="left" width="33%">
			#GetServiceRequests.SERVICEREQUESTNUMBER#
			<input type="hidden" name="SERVICEREQUESTNUMBER" value="#GetServiceRequests.SERVICEREQUESTNUMBER#" />
               <input type="hidden" name="SRID" value="#GetServiceRequests.SRID#" />
		</td>
		<td align="left" width="33%">#DateFormat(GetServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</td>
		<td align="left" width="33%">#TimeFormat(GetServiceRequests.CREATIONTIME, "hh:mm:ss tt")#</td>
	</tr>
	<tr>
		<th align="left" width="33%">Requester</th>
		<th align="left" width="33%">Problem Category</th>
		<th align="left" width="33%">Sub-Category</th>
	</tr>
	<tr>
		<td align="left" width="33%">
			#LookupRequesters.FULLNAME#
			<input type="hidden" name="REQUESTER" value="#LookupRequesters.FULLNAME#" />
		</td>
		<td align="left" width="33%">
			#GetServiceRequests.PROBCATEGORY#
			<input type="hidden" name="PROBCATEGORY" value="#GetServiceRequests.PROBCATEGORY#" />
		</td>
		<td align="left" width="33%">
          	#GetServiceRequests.SUBCATEGORYNAME#
               <input type="hidden" name="SUBCATEGORY" value="#GetServiceRequests.SUBCATEGORYNAME#" />
          </td>
	</tr>
	<tr>
		<th align="left" width="33%">Service Desk Initials</th>
		<th align="left" width="33%"><label for="PRIORITYID">Priority</label></th>
          <th align="left" width="33%"><label for="ASSIGN_PRIORITY">ASSIGN-P</label></th>
	</tr>
     <tr>
          <input type="hidden" name="SERVICEDESKINITIALSID" value="#ListServDeskInitials.CUSTOMERID#" />
          <td align="left" width="33%">#ListServDeskInitials.INITIALS#</td>
		<td align="left" width="33%" valign="TOP">
			<cfselect name="PRIORITYID" id="PRIORITYID" size="1" query="LookupPriority" value="PRIORITYID" display="PRIORITYNAME" selected="#GetServiceRequests.PRIORITYID#" required="No" tabindex="3"></cfselect>
		</td>
          <td align="left" width="33%">
			<cfselect name="ASSIGN_PRIORITY" id="ASSIGN_PRIORITY" size="1" selected="#GetServiceRequests.ASSIGN_PRIORITY#" required="No" tabindex="4">
				<option selected value="#GetServiceRequests.ASSIGN_PRIORITY#">#GetServiceRequests.ASSIGN_PRIORITY#</option>
				<cfloop index="Counter" from=1 to=20>
					<option value=#Counter#>#Counter#</option>
				</cfloop>
         		</cfselect>
          </td>
	</tr>
     <tr>
		<th align="left" colspan="3"><label for="PROBLEM_DESCRIPTION">Problem Description</label></th>
	</tr>
     <tr>
		<td align="left" colspan="3">
			<textarea name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="6" cols="100" wrap="VIRTUAL" tabindex="5">#GetServiceRequests.PROBLEM_DESCRIPTION#</textarea>
		</td>
	</tr>
</table>
</FIELDSET>
<br />
<fieldset>
<legend>Group/Staff Assignments</legend>
<table width="100%" border="0">
     <tr>
		<th align="left" width="25%">Group Assigned</th>
          <th align="left" width="25%"><h4><label for="STAFF_ASSIGNEDID">*Staff Assigned</label></h4></th>
		<th align="left" width="25%"><h4><label for="STAFF_DATEASSIGNED">*Date Staff Assigned</label></h4></th>
     <cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ "YES">
     	<th align="left" width="25%"><h4><label for="NEXT_ASSIGNMENT_REASON">*Reason for Next Assignment</label></h4></th>
     <cfelse>
     	<th align="left" width="25%">&nbsp;&nbsp;</th>
     </cfif>
	</tr>
	<tr>
	<cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ "YES">
		<td align="left" valign="TOP" width="25%">
          	#GetSRStaffAssignments.GROUPNAME#
          	<input type="hidden" name="NEXT_ASSIGNMENT" value="#GetSRStaffAssignments.NEXT_ASSIGNMENT#" />
          	<input type="hidden" name="GROUPID" value="#GetSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID#" />
          </td>
	<cfelse>
		<td align="left" valign="TOP" width="25%">
          	#GetServiceRequests.GROUPNAME#
          	<input type="hidden" name="NEXT_ASSIGNMENT" value="#GetSRStaffAssignments.NEXT_ASSIGNMENT#" />
           	<input type="hidden" name="GROUPID" value="#GetServiceRequests.GROUPASSIGNEDID#" />
          </td>
	</cfif>
     <cfif LookupStaffUnAssigned.RecordCount EQ 0>
          <td align="left" valign="top" width="25%">
               <input type="hidden" name="WORKGROUPASSIGNSID" value="0" />
               <strong>All The Staff From This Group Have Been Assigned!</strong>
          <td align="left" width="33%">&nbsp;&nbsp;</td>
          <cfelse>
     	<td align="left" valign="TOP" width="25%">
			 <cfloop query = "LookupStaffUnAssigned">
                    <cfinput type="Checkbox" name="STAFF_ASSIGNEDID" id="STAFF_ASSIGNEDID" value="#WORKGROUPASSIGNSID#" tabindex="6">#FULLNAME#<br>
               </cfloop>
		</td>
		<td align="left" valign="TOP" width="25%">
			<cfset FORM.STAFF_DATEASSIGNED = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
			<cfinput type="Text" name="STAFF_DATEASSIGNED" id="STAFF_DATEASSIGNED" value="#DateFormat(FORM.STAFF_DATEASSIGNED, "mm/dd/yyyy")#" align="LEFT" required="No" size="15" tabindex="7"> 
			<script language="JavaScript">
				new tcal ({'formname': 'STAFFSRASSIGN','controlname': 'STAFF_DATEASSIGNED'});

			</script>
		</td>
     </cfif>
     <cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ "YES">
     	<td align="left" valign="TOP" width="25%">
               <cftextarea name="NEXT_ASSIGNMENT_REASON" id="NEXT_ASSIGNMENT_REASON" wrap="VIRTUAL" rows="4" cols="25" tabindex="8"></cftextarea>
          </td>
     <cfelse>
     	<td align="left" width="25%">&nbsp;&nbsp;</td>
     </cfif>
	</tr>
	</table>
     <table width="100%" border="0">
          <tr>
               <th align="left" width="25%">Other Staff</th>
               <th align="left" width="25%">Other Staff Group</th>
               <th align="left" width="25%">Other Staff Comments</th>
               <th align="left" width="25%">Other Staff Completed SR?</th>
          </tr>

     <cfif LookupOtherStaff.RecordCount EQ 0>
          <tr>
               <td align="left" valign="top" width="25%">
                    <strong>No Other Staff Have Been Assigned!</strong>
               </td>
               <td align="left" valign="top" width="25%">&nbsp;&nbsp;</td>
               <td align="left" valign="top" width="25%">&nbsp;&nbsp;</td>
               <td align="left" valign="top" width="25%">&nbsp;&nbsp;</td>
          </tr>
     <cfelse>
          <cfloop query="LookupOtherStaff">
          
           <tr>
               <td align="left" valign="top" width="25%">
                    #LookupOtherStaff.FULLNAME#
<!--- 
               <CFIF #LookupOtherStaff.NEXT_ASSIGNMENT# EQ 'NO'>
                    - Primary
               <CFELSE>
                    - Next
               </CFIF>
--->
               </td>

               <td align="left" valign="top" width="25%">
               <cfif #LookupOtherStaff.STAFF_ASSIGNEDID# GT 0>
                    #LookupOtherStaff.WORKGROUPNAME#
               <cfelse>
                    #LookupOtherStaff.NEXTGROUPNAME#
               </cfif>
               </td>
          
               <cfquery name="LookupCompletedComments" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	COMPLETED_COMMENTSID, COMPLETED_COMMENTS
                    FROM		COMPLETEDCOMMENTS
                    WHERE	COMPLETED_COMMENTSID = <CFQUERYPARAM value="#LookupOtherStaff.STAFF_COMPLETEDCOMMENTSID#" cfsqltype="CF_SQL_NUMERIC">
                    ORDER BY	COMPLETED_COMMENTS
               </cfquery>
          
               <td align="left" valign="top" width="25%">
               <cfif #LookupOtherStaff.STAFF_COMMENTS# EQ "" AND #LookupOtherStaff.STAFF_COMPLETEDCOMMENTSID# GT 0>
                    #LookupCompletedComments.COMPLETED_COMMENTS#
               <cfelse>
                    #LookupOtherStaff.STAFF_COMMENTS#
               </cfif>
               </td>
               <td align="left" valign="top" width="25%">
                    #LookupOtherStaff.STAFF_COMPLETEDSR#
               </td>
          </tr>

          </cfloop>
     </cfif>
     </table>
</fieldset>
<br />
<fieldset>
<legend>Record Processing</legend>
<table width="100%" border="0">
	<tr>
     <cfif LookupStaffUnAssigned.RecordCount GT 0>
 		<td align="left" width="33%">
          	<input type="hidden" name="PROCESSSRSTAFFASSIGNS" value="ASSIGN LOOP" />
               <input type="image" src="/images/buttonAssignLoop.jpg" value="ASSIGN LOOP" alt="Assign Loop" tabindex="9" />
          </td>
     <cfelse>
          <td align="left" width="33%">&nbsp;&nbsp;</td>
     </cfif>
          <td align="left" valign="top" width="33%">
              <input type="image" src="/images/buttonAddNextGrp.jpg" value="Add Next Group" alt="Add Next Group" onClick="window.open('/#application.type#apps/servicerequests/srnextrefergroupchoice.cfm?SRID=#Cookie.SRID#&PROCESS=ADD&STAFFLOOP=YES',
                                          'Add Next Group','alwaysRaised=yes,dependent=no,width=800,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                          tabindex="10" />
          </td>
          <td align="left" valign="top" width="33%">&nbsp;&nbsp;</td>
     </tr>
     
</cfform>

     <tr>
<cfform action="/#application.type#apps/servicerequests/srstaffassignloop.cfm?LOOKUPGROUPID=FOUND" method="POST">
		
		<td align="left" width="33%">
          	<cfif (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
          		<cfset session.LOOKUPGROUP = #FORM.GROUPID#>
          		<input type="hidden" name="GROUPID" value="#FORM.GROUPID#" />
               </cfif>
               <input type="image" src="/images/buttonNextRec.jpg" value="NEXT RECORD" alt="Next Record" tabindex="11" />
          </td>
     	<td align="left" width="33%">&nbsp;&nbsp;</td>
          <td align="left" width="33%">&nbsp;&nbsp;</td>
</cfform>
	</tr>
</TABLE>
</FIELDSET>
<br />
<table width="100%" align="LEFT">
	<tr>
<cfform action="/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm" method="POST">
		<td align="left" colspan="3">
			<input type="image" src="/images/buttonCancelAssignLp.jpg" value="CANCEL ASSIGN LOOP" alt="Cancel Assign Loop" tabindex="12" /><br />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</td>
</cfform>
	</tr>
	<tr>
		<td align="left" colspan="3"><cfinclude template="/include/coldfusion/footer.cfm"></td>
	</tr>
</table>

</body>
</cfoutput>
</html>