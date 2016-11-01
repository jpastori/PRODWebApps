<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: claimednotcomploop.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/04/2012 --->
<!--- Date in Production: 06/04/2012 --->
<!--- Module: SR Claimed/Not Completed Loop --->
<!-- Last modified by John R. Pastori on 09/29/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/claimednotcomploop.cfm">
<CFSET CONTENT_UPDATED = "September 29, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">


<HTML>
<HEAD>
	<TITLE>SR Claimed/Not Completed Loop</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Service Requests Application";


	if (window.history.forward(1) != null) {
		javascript:window.history.forward(1);
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
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
			alertuser ("You must select a Staff Name.");
			document.LOOKUP2.CUSTOMERID.focus();
			return false;
		}
	}
	
	
	function setPrevRecord() {
		document.STAFFSRASSIGNS.RETRIEVERECORD.value = "PREVIOUS RECORD";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPGROUPID') AND NOT IsDefined('URL.LOOKUPSTAFFID')>
	<CFSET CURSORFIELD = "document.LOOKUP1.GROUPID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.STAFFSRASSIGNS.SUBMIT_BUTTON.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*************************************************************************************************************************
* The following code is the Group Assigned and Staff Assigned Records Lookup Process for SR Claimed/Not Completed Loop. *
*************************************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPGROUPID') AND NOT IsDefined('URL.LOOKUPSTAFFID')>

	<CFSET session.STAFFASSIGNArray=ArrayNew(1)>
	<CFSET temp = ArraySet(session.STAFFASSIGNArray, 1, 1, 0)>
	<CFSET session.ArrayCounter = 0>
	<CFSET session.REPORTTITLE = ''>

	<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPNAME
	</CFQUERY>
	
     <CFQUERY name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	DISTINCT WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
          		CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</CFQUERY>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Claimed/Not Completed Loop Lookup</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TD align="center"><H4>One of the Lookup Fields MUST be chosen!</H4></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
			<TH align="left" width="33%"><LABEL for="GROUPID">Group</LABEL></TH>
               <TH align="left" width="33%"><LABEL for="STAFF_ASSIGNEDID">Staff Assigned</LABEL></TH>
		</TR>
		<TR>
<CFFORM name="LOOKUP1" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/claimednotcomploop.cfm?LOOKUPGROUPID=FOUND" method="POST">
			<TD align="left" width="33%">
				<CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" display="GROUPNAME" selected="0" required="No" tabindex="2"></CFSELECT><BR>
				<INPUT type="image" src="/images/buttonSelectGroup.jpg" value="Select Group" alt="Select Group" tabindex="3" />
			</TD>
</CFFORM>
<CFFORM name="LOOKUP2" onsubmit="return validateSTAFFIDReqFields();" action="/#application.type#apps/servicerequests/claimednotcomploop.cfm?LOOKUPSTAFFID=FOUND" method="POST">
			<TD align="left" width="33%">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="LookupStaffAssigned" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" required="No" tabindex="4"></CFSELECT><BR>
                    <INPUT type="image" src="/images/buttonSelectStaff.jpg" value="Select Staff" alt="Select Staff" tabindex="5" />
			</TD>
</CFFORM>
		</TR>
          <TR>
			<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFEXIT>
<CFELSEIF session.STAFFASSIGNArray[1] EQ 0>

<!--- 
***************************************************************************************************************************
* The following code is the Group Assigned or Staff Assigned Records Selection Process for SR Claimed/Not Completed Loop. *
***************************************************************************************************************************
 --->
 
 
 	<CFIF IsDefined ('FORM.GROUPID') AND #FORM.GROUPID# GT 0>

		<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.GROUPASSIGNEDID, SR.SRCOMPLETED, GA.GROUPID, GA.GROUPNAME
			FROM		SERVICEREQUESTS SR, GROUPASSIGNED GA 
			WHERE	SR.GROUPASSIGNEDID = GA.GROUPID AND
				<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                         SR.GROUPASSIGNEDID IN (7,19) AND
                    <CFELSE> 
                         SR.GROUPASSIGNEDID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    </CFIF>
                    	SR.SRID > 0 AND
                         SR.SRCOMPLETED = 'NO'
			ORDER BY	SR.SERVICEREQUESTNUMBER
		</CFQUERY>
          
          <CFIF #GetServiceRequests.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert("Records for your selected Group were Not Found");
                    --> 
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/claimednotcomploop.cfm" />
               <CFEXIT>
          </CFIF>
          
          <CFSET SRIDS = #ValueList(GetServiceRequests.SRID)#>
          <CFSET FORM.CUSTOMERID = 0>
          <!--- <BR>SRIDS = #SRIDS# <BR> --->

		<CFQUERY name="GetGroupStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SR.SERVICEREQUESTNUMBER, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, SRSA.STAFF_COMPLETEDSR
			FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR
			WHERE	((SRSA.SRID IN (#ValueList(GetServiceRequests.SRID)#) AND
               		SRSA.NEXT_ASSIGNMENT = 'NO') OR
               	<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                         (SRSA.NEXT_ASSIGNMENT_GROUPID IN (7,19) AND
                    <CFELSE> 
                         (SRSA.NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    </CFIF>
                   		SRSA.NEXT_ASSIGNMENT = 'YES')) AND
                         SRSA.STAFF_COMPLETEDSR = 'NO' AND
                         SRSA.SRID = SR.SRID
               ORDER BY	SR.SERVICEREQUESTNUMBER
		</CFQUERY>
          
          <CFIF #GetGroupStaffAssignments.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert(" Staff Assignment Records for your selected Group were Not Found");
                    --> 
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/claimednotcomploop.cfm" />
               <CFEXIT>
          </CFIF>
          
          <CFSET GetStaffAssignments_RecordCount = #GetGroupStaffAssignments.Recordcount#>
          <CFSET STAFFASSIGNIDS = #ValueList(GetGroupStaffAssignments.SRSTAFF_ASSIGNID)#>
     
     </CFIF>
 
 	<CFIF IsDefined ('FORM.CUSTOMERID') AND #FORM.CUSTOMERID# GT 0> 
   
     	<CFQUERY name="GetIndividualStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.NEXT_ASSIGNMENT, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, SRSA.NEXT_ASSIGNMENT_GROUPID,
					SR.SERVICEREQUESTNUMBER, WGA.STAFFCUSTOMERID, CUST.FULLNAME AS STAFF, CUST.FULLNAME || '-' || SRSA.SRID AS LOOKUPSTAFF,
					TO_CHAR(STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED
			FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	SRSA.SRID = SR.SRID AND
               		SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID  AND
                         SRSA.STAFF_COMPLETEDSR = 'NO'
			ORDER BY	SR.SERVICEREQUESTNUMBER
		</CFQUERY>
          
           <CFIF #GetIndividualStaffAssignments.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert(" Assignment Records for your selected Staff Person were Not Found");
                    --> 
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/claimednotcomploop.cfm" />
               <CFEXIT>
          </CFIF>

         <CFSET GetStaffAssignments_RecordCount = #GetIndividualStaffAssignments.Recordcount#>
          <CFSET STAFFASSIGNIDS = #ValueList(GetIndividualStaffAssignments.SRSTAFF_ASSIGNID)#>
          
	</CFIF>
     <!--- <BR>STAFFASSIGNIDS = #STAFFASSIGNIDS# <BR> --->
     

	<CFSET temp = ArraySet(session.STAFFASSIGNArray, 1, LISTLEN(STAFFASSIGNIDS), 0)>
	<CFSET session.STAFFASSIGNArray = ListToArray(STAFFASSIGNIDS)>
	<CFIF IsDefined('FORM.GROUPID') AND #FORM.GROUPID# GT 0>
		<CFSET session.REPORTTITLE1 = "Claimed/Not Completed Loop By Group">
          <CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
			<CFSET session.REPORTTITLE2 = "For Group: &nbsp;&nbsp;ES/LIB - ES/AA">
          <CFELSE>
               <CFSET session.REPORTTITLE2 = "For Group: &nbsp;&nbsp;#GetServiceRequests.GROUPNAME#">
          </CFIF>
 	<CFELSE>
		<CFSET session.REPORTTITLE1 = "Claimed/Not Completed Loop By Staff Assigned">
          <CFSET session.REPORTTITLE2 = "For Staff Assigned: &nbsp;&nbsp;#GetIndividualStaffAssignments.STAFF#">
	</CFIF>

</CFIF>

<!--- 
***********************************************************************************************************************
* The following code is the Display form for Group or Staff Assigned Records for IDT SR Claimed/Not Completed Report. *
***********************************************************************************************************************
 --->

	<CFIF IsDefined('FORM.RETRIEVERECORD') AND #FORM.RETRIEVERECORD# EQ "PREVIOUS RECORD">  	
         	<CFSET session.ArrayCounter = #session.ArrayCounter# - 1>
	<CFELSE>
		<CFSET session.ArrayCounter = #session.ArrayCounter# + 1>
     </CFIF>
	<CFIF session.ArrayCounter GT ARRAYLEN(session.STAFFASSIGNArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/claimednotcomploop.cfm" />
		<CFEXIT>
	</CFIF>
	
	<CFSET FORM.STAFFASSIGNID = #session.STAFFASSIGNArray[session.ArrayCounter]#>

	<CFQUERY name="GetStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.NEXT_ASSIGNMENT, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, 
				SR.SERVICEREQUESTNUMBER, WGA.STAFFCUSTOMERID, CUST.FULLNAME AS STAFF, CUST.FULLNAME || '-' || SR.SERVICEREQUESTNUMBER AS LOOKUPSTAFF,
				TO_CHAR(STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED
		FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SRSA.SRSTAFF_ASSIGNID = <CFQUERYPARAM value="#FORM.STAFFASSIGNID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
				SRSA.STAFF_COMPLETEDSR = 'NO' AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
				SRSA.SRID = SR.SRID  AND
                    SRSA.NEXT_ASSIGNMENT_GROUPID = GA.GROUPID AND
                    SRSA.STAFF_COMPLETEDSR = 'NO'
		ORDER BY	SR.SERVICEREQUESTNUMBER
	</CFQUERY>
     
	<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
				TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SR.REQUESTERID, SR.ALTERNATE_CONTACTID,
				PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY, PROBSUBCAT.SUBCATEGORYNAME,
				SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME, SR.PROBLEM_DESCRIPTION
		FROM		SERVICEREQUESTS SR, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
				GROUPASSIGNED IDTGROUP
		WHERE	SR.SRID = <CFQUERYPARAM value="#GetStaffAssignments.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
				SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.PRIORITYID = PRIORITY.PRIORITYID
		ORDER BY	SR.SERVICEREQUESTNUMBER
	</CFQUERY>
 	
	<CFQUERY name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE
		FROM		CUSTOMERS CUST
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.REQUESTERID#" cfsqltype="CF_SQL_VARCHAR"> AND
				CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</CFQUERY>
	
	<CFQUERY name="LookupPriority" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
		SELECT	PRIORITYID, PRIORITYNAME
		FROM		PRIORITY
		ORDER BY	PRIORITYNAME
	</CFQUERY>
     
     <CFQUERY name="LookupHardwareAssigns" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SRHA.SRHARDWASSIGNID, SRHA.SRID, SRHA.HWSWID, HSA.HWSW_ID, HSA.HWSW_NAME
          FROM		SRHARDWASSIGNS SRHA, HWSW HSA
          WHERE	SRHA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
          		SRHA.HWSWID > 0 AND 
                    SRHA.HWSWID = HSA.HWSW_ID AND
                    SUBSTR(HSA.HWSW_NAME,1,2) = 'HW'
          ORDER BY	SRHA.HWSWID
     </CFQUERY>
 
<!---      
      <CFQUERY name="LookupSoftwareAssigns" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SRSA.SRSOFTWASSIGNID, SRSA.SRID, SRSA.HWSWID, HSA.HWSW_ID, HSA.HWSW_NAME
          FROM		SRSOFTWASSIGNS SRSA, HWSW HSA
          WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                    SRSA.HWSWID = HSA.HWSW_ID AND
                    SUBSTR(HSA.HWSW_NAME,1,2) = 'SW'
          ORDER BY	SRSA.HWSWID
     </CFQUERY>
 --->
 		
	<CFQUERY name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER,
				CUST.FULLNAME || ' - ' || WGA.GROUPORDER  || ' - ' ||  GA.GROUPNAME AS CUSTOMERGROUP
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
		WHERE	WGA.GROUPID = <CFQUERYPARAM value="#GetServiceRequests.GROUPASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR"> AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
				WGA.GROUPID = GA.GROUPID
		ORDER BY	GA.GROUPNAME, CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupOtherStaff" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, CUST.FULLNAME, SRSA.NEXT_ASSIGNMENT, 
				SRSA.NEXT_ASSIGNMENT_GROUPID
		FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
				NOT SRSA.STAFF_ASSIGNEDID = <CFQUERYPARAM value="#GetStaffAssignments.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR"> AND
				SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
		ORDER BY	SRSA.STAFF_ASSIGNEDID
	</CFQUERY>
 
   	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
               	<H1>#session.REPORTTITLE1#</H1>
                    <H2>#session.REPORTTITLE2#</H2>
               </TD>       
		</TR>
	</TABLE>
	<BR clear="left" />
	
	<TABLE width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/claimednotcomploop.cfm" method="POST">
			<TD align="left" width="33%">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="3"><H2>#ARRAYLEN(session.STAFFASSIGNArray)# Staff Assignment records were selected.</H2></TH>
		</TR>
     </TABLE>

<CFFORM name="STAFFSRASSIGNS" action="/#application.type#apps/servicerequests/claimednotcomploop.cfm?LOOKUPGROUPID=FOUND" method="POST" ENABLECAB="Yes">
    <FIELDSET>
     <LEGEND>Record Selection</LEGEND>
     <TABLE width="100%" border="0">	
    		 <TR>
			<TD align="left" width="33%">
                    <INPUT type="hidden" name="RETRIEVERECORD" value="NEXT RECORD" />
                    <INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXT RECORD" alt="Next Record" tabindex="2" />
               </TD>
           <CFIF #session.ArrayCounter# GT 1>
               <TD align="left" width="33%">
                    <INPUT type="image" src="/images/buttonPreviousRec.jpg" value="PREVIOUS RECORD" alt="Previous Record" onClick="return setPrevRecord();" tabindex="3" />
               </TD>
          <CFELSE>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          </CFIF>
			<TD align="left" width="33%">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
     </FIELDSET>
          <BR />
	<FIELDSET>
	<LEGEND>Service Request</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TH align="left" width="33%">SR</TH>
			<TH align="left" width="33%">Creation Date</TH>
			<TH align="left" width="33%">Creation Time</TH>
		</TR>
		<TR>
			<TD align="left" width="33%">#GetServiceRequests.SERVICEREQUESTNUMBER#</TD>
			<TD align="left" width="33%">#DateFormat(GetServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</TD>
			<TD align="left" width="33%">#TimeFormat(GetServiceRequests.CREATIONTIME, "hh:mm:ss tt")#</TD>
		</TR>
		<TR>
			<TH align="left" width="33%">Requester</TH>
			<TH align="left" width="33%">Problem Category</TH>
			<TH align="left" width="33%">Sub-Category</TH>
		</TR>
		<TR>
			<TD align="left" width="33%">#LookupRequesters.FULLNAME#</TD>
			<TD align="left" width="33%">#GetServiceRequests.PROBCATEGORY#</TD>
			<TD align="left" width="33%">#GetServiceRequests.SUBCATEGORYNAME#</TD>
		</TR>
		<TR>
			<TH align="left" width="33%">Problem Description</TH>
			<TH align="left" width="33%">Priority</TH>
               <TH align="left" width="33%">HWSW</TH>	
		</TR>
		<TR>
			<TD align="left" width="33%">
				#GetServiceRequests.PROBLEM_DESCRIPTION#
			</TD>
			<TD align="left" width="33%" valign="TOP">
				#GetServiceRequests.PRIORITYNAME#
			</TD>
          	<TD align="left" width="33%">
               <CFIF LookupHardwareAssigns.RecordCount GT 0>
				#LookupHardwareAssigns.HWSW_NAME#<BR>
               </CFIF>
<!---                
               <CFIF LookupSoftwareAssigns.RecordCount GT 0>
				#LookupSoftwareAssigns.HWSW_NAME#
               </CFIF>
 --->               
			</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />

     <FIELDSET>
     <LEGEND>Group/Staff Assignments</LEGEND>
     <TABLE width="100%" border="0"> 
		<TR>
          	<TH align="left" width="33%">Group Assigned</TH>
			<TH align="left" width="33%">Staff Assigned</TH>
			<TH align="left" width="33%">Date Staff Assigned</TH>
          </TR>
		<TR>
          <CFIF #GetStaffAssignments.NEXT_ASSIGNMENT# EQ "YES">
			<TD align="left" valign="TOP"><STRONG>#GetStaffAssignments.GROUPNAME#</STRONG></TD>
		<CFELSE>
			<TD align="left" valign="TOP"><STRONG>#GetServiceRequests.GROUPNAME#</STRONG></TD>
		</CFIF>
			<TD valign="TOP">#GetStaffAssignments.STAFF#</TD>
			<TD align="left" valign="TOP">
               	#DateFormat(GetStaffAssignments.STAFF_DATEASSIGNED, "mm/dd/yyyy")#
			</TD>
		</TR>
 		<TR>
			<TH align="left" width="33%">Other Staff</TH>
               <TH align="left" width="33%">&nbsp;&nbsp;</TH>
               <TH align="left" width="33%">&nbsp;&nbsp;</TH>			
		</TR>
          <TR>
          	<TD align="left" valign="top">
			<CFIF LookupOtherStaff.RecordCount EQ 0>
				<STRONG>No Other Staff Have Been Assigned!</STRONG>
			<CFELSE>
				<CFLOOP query="LookupOtherStaff">
					#LookupOtherStaff.FULLNAME#<BR />
				</CFLOOP>
			</CFIF>
			</TD>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
     </FIELDSET>
</CFFORM>
     <BR />
     <TABLE width="100%" border="0">	
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/claimednotcomploop.cfm" method="POST">
			<TD align="left" width="33%">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

</BODY>
</CFOUTPUT>
</HTML>