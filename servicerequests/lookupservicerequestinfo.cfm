<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lookupservicerequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/25/2012 --->
<!--- Date in Production: 05/25/2012 --->
<!--- Module: Lookup Service Request Info --->
<!-- Last modified by John R. Pastori on 05/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm">
<CFSET CONTENT_UPDATED = "May 25, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Lookup Service Request Info </TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Service Requests Lookup";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateSRNumber() {
		if ((document.LOOKUP1.SERVICEREQUESTNUMBER.value.length == 5) 
		 || (document.LOOKUP1.SERVICEREQUESTNUMBER.value.length != 5 
		 && document.LOOKUP1.SERVICEREQUESTNUMBER.value.length != 9)) {
			alertuser ("You must enter a 9 character Service Request Number.");
			document.LOOKUP1.SERVICEREQUESTNUMBER.focus();
			return false;
		}
	}

	function validateGROUPReqFields() {
	
		var GROUPIDcheckboxError = 0;
		for (i = 0; i < document.LOOKUP2.GROUPID.length; i++){
			if(document.LOOKUP2.GROUPID[i].checked) {
				GROUPIDcheckboxError = 1;
				break;
			}else{
				GROUPIDcheckboxError = 0;
			}
 
		} 
		if(GROUPIDcheckboxError == 0){ 
			alertuser ("At Least One Group must be chosen!");
			document.LOOKUP2.GROUPID[1].focus();
			return false;
		}
	}

	function validateSRReqFields() {
		if (document.LOOKUP3.SRID.selectedIndex == "0") {
			alertuser ("You must select a Service Request.");
			document.LOOKUP3.SRID.focus();
			return false;
		}
	}

	function validateSTAFFIDReqFields() {
		if (document.LOOKUP4.STAFF_ASSIGNEDID.selectedIndex == "0") {
			alertuser ("You must select a Staff ID.");
			document.LOOKUP4.STAFF_ASSIGNEDID.focus();
			return false;
		}
	}
	
	function validateRequesterSRReqFields() {
		if (document.SECONDLOOKUP1.SRID.selectedIndex == "0") {
			alertuser ("You must select a Requester and SR.");
			document.SECONDLOOKUP1.SRID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<CFIF URL.PROCESS EQ "ADD" OR URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP1.SERVICEREQUESTNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SECONDLOOKUP1.SRID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">


<!--- 
*********************************************************************************************
* The following code is the Lookup for Add/Modify/Delete Processes of SR Staff Assignments. *
*********************************************************************************************
 --->

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEAR_4DIGIT
</CFQUERY>

<CFIF URL.PROCESS EQ "ADD">

	<CFCOOKIE name="SAVE_PROCESS" secure="NO" value="#URL.PROCESS#">
	<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, SR.GROUPASSIGNEDID, SR.SRCOMPLETED,
				IDTGROUP.GROUPNAME, CUST.FULLNAME, CUST.FULLNAME || '-' || SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, GROUPASSIGNED IDTGROUP, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SR.REQUESTERID = CUST.CUSTOMERID AND
				IDTGROUP.GROUPID = SR.GROUPASSIGNEDID AND
                    SR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    SR.SRID > 0 AND
               	SR.SRCOMPLETED = 'NO' 
          ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
	</CFQUERY>

<CFELSEIF URL.PROCESS EQ "MODIFYDELETE">

	<CFCOOKIE name="SAVE_PROCESS" secure="NO" value="#URL.PROCESS#">
     
     <CFIF Client.MaintLessFlag EQ "No">
       
          <CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	DISTINCT SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, SR.GROUPASSIGNEDID, SR.SRCOMPLETED,
                         IDTGROUP.GROUPID, CUST.FULLNAME, CUST.FULLNAME || '-' || SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
               FROM		SERVICEREQUESTS SR, GROUPASSIGNED IDTGROUP, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
                         SR.REQUESTERID = CUST.CUSTOMERID AND
                         SR.SRID > 0  AND
               		SR.SRCOMPLETED = 'NO'
               ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
          </CFQUERY>
          
	<CFELSE>

	    	<CFQUERY name="ListStaffAssignedSRs" datasource="#application.type#SERVICEREQUESTS">
               SELECT	DISTINCT SRSA.SRID AS ASSIGNSRID, SRSA.NEXT_ASSIGNMENT, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, CUST.CUSTOMERID, CUST.FULLNAME AS STAFF, SR.SRID, 
                         SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATEDATE, SR.REQUESTERID, REQCUST.CUSTOMERID, 
                         REQCUST.FULLNAME AS REQUESTER, CUST.ACTIVE, SR.PRIORITYID, P.PRIORITYNAME, SR.PROBLEM_DESCRIPTION, REQCUST.FULLNAME || ' - ' || SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
               FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PRIORITY P
               WHERE	(SRSA.SRID = SR.SRID AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID  AND
                         SRSA.STAFF_COMPLETEDSR = 'NO') AND
                         (WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR">) AND
                         (SR.REQUESTERID = REQCUST.CUSTOMERID AND
                         SR.PRIORITYID = P.PRIORITYID)
               ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
          </CFQUERY>
               	
     </CFIF>

	<CFQUERY name="ListStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	DISTINCT WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID 
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

<CFELSEIF URL.PROCESS EQ "LOOKUPGROUP">

	<CFSET ARRAYCOUNT = 0>
	<CFSET LOOPCOUNT = 0>
     <CFSET SESSION.GROUPIDARRAY = ArrayNew(1)>
     <CFSET temp = ArraySet(SESSION.GROUPIDARRAY, 1, 14, 0)>
     <CFSET SESSION.GROUPIDLIST = ''>

	<CFSET SESSION.GROUPIDARRAY = #ListToArray(FORM.GROUPID)#>
     <CFSET ARRAYCOUNT = (ArrayLen(SESSION.GROUPIDARRAY) - 1)>

     <CFLOOP index = "LOOPCOUNT" from="1" to="#ARRAYCOUNT#"> 
     	<CFSET SESSION.GROUPIDLIST = (SESSION.GROUPIDLIST & SESSION.GROUPIDARRAY[#LOOPCOUNT#] & ";")>
     </CFLOOP>

     <CFSET SESSION.GROUPIDLIST = (SESSION.GROUPIDLIST & SESSION.GROUPIDARRAY[#ArrayLen(SESSION.GROUPIDARRAY)#])>
     <CFSET SESSION.GROUPIDLIST = ListChangeDelims(SESSION.GROUPIDLIST, ",", ";")>

	<CFQUERY name="ListSRStaffAssigns" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSTAFF_ASSIGNID, SRID, STAFF_ASSIGNEDID, STAFF_DATEASSIGNED, STAFF_TIME_WORKED, STAFF_COMMENTS, 
				NEXT_ASSIGNMENT, NEXT_ASSIGNMENT_GROUPID, NEXT_ASSIGNMENT_REASON, STAFF_COMPLETEDSR, STAFF_COMPLETEDDATE, 
				STAFF_COMPLETEDCOMMENTSID
		FROM		SRSTAFFASSIGNMENTS
		WHERE	NEXT_ASSIGNMENT_GROUPID IN (#SESSION.GROUPIDLIST#) AND
				STAFF_COMPLETEDSR = 'NO'
		ORDER BY	STAFF_ASSIGNEDID
	</CFQUERY>

	<CFIF Cookie.SAVE_PROCESS EQ "ADD">
 
		<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, SR.GROUPASSIGNEDID,
					IDTGROUP.GROUPID, IDTGROUP.GROUPNAME, CUST.FULLNAME, CUST.FULLNAME || '-' || SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
			FROM		SERVICEREQUESTS SR, GROUPASSIGNED IDTGROUP, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.GROUPASSIGNEDID IN (#SESSION.GROUPIDLIST#)
				<CFIF ListSRStaffAssigns.RecordCount GT 0>
					OR SR.SRID IN (#ValueList(ListSRStaffAssigns.SRID)#)
				</CFIF>
					) AND 
					(SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
					SR.REQUESTERID = CUST.CUSTOMERID AND
               		SR.SRCOMPLETED = 'NO') AND
                    	(SR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) 
          	ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
		</CFQUERY>

	<CFELSEIF Cookie.SAVE_PROCESS EQ "MODIFYDELETE">
		<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	DISTINCT SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, SR.GROUPASSIGNEDID,
					IDTGROUP.GROUPID, IDTGROUP.GROUPNAME, CUST.FULLNAME, CUST.FULLNAME || '-' || SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
			FROM		SERVICEREQUESTS SR, SRSTAFFASSIGNMENTS SRSA, GROUPASSIGNED IDTGROUP, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SR.GROUPASSIGNEDID IN (#SESSION.GROUPIDLIST#)
				<CFIF ListSRStaffAssigns.RecordCount GT 0>
					OR SR.SRID IN (#ValueList(ListSRStaffAssigns.SRID)#)
				</CFIF>
					) AND 
					(SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
					SR.SRID = SRSA.SRID AND
					SR.REQUESTERID = CUST.CUSTOMERID AND
               		SR.SRCOMPLETED = 'NO')
			ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
		</CFQUERY>
	</CFIF>
</CFIF>

<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
	SELECT	GROUPID, GROUPNAME
	FROM		GROUPASSIGNED
     WHERE	GROUPID > 0
	ORDER BY	GROUPNAME
</CFQUERY>

<IMG src="/images/bigheader.jpg" width="279" height="63" alt="LFOLKS Intranet Web Site" align="left" VALIGN="top" border="0" />
<BR /><BR /><BR /><BR /><BR />

<TABLE width="100%" align="center" border="3">
     <TR align="center"><BR />
     <CFIF URL.PROCESS EQ "ADD">
          <TD align="center"><H1>Add Assignments via Single Lookup</H1></TD>
     <CFELSEIF URL.PROCESS EQ "MODIFYDELETE">
          <TD align="center"><H1>SR Comments via Single Lookup </H1></TD>
     <CFELSEIF URL.PROCESS EQ "LOOKUPGROUP">
          <TD align="center"><H1>Requester and SR Lookup </H1></TD>
     </CFIF>
     </TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
     <TR>
          <TD align="center"><H4>A Lookup Field MUST be chosen!</H4></TD>
     </TR>
</TABLE>
<BR /><BR />

<TABLE width="100%" align="LEFT" border="0">
<CFIF URL.PROCESS EQ "ADD" OR URL.PROCESS EQ "MODIFYDELETE">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="left">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>

	<TR>
	<CFIF Client.MaintLessFlag EQ "No">
		<TH align="LEFT"><LABEL for="SERVICEREQUESTNUMBER">SR</LABEL></TH>
		<TH align="left">Or <LABEL for="GROUPID">Group Assigned</LABEL></TH>
     <CFELSE>
     	<TH align="left"><LABEL for="SRID">Requester and SR</LABEL></TH>
     </CFIF>
	</TR>
	<TR>
	<CFIF Client.MaintLessFlag EQ "No">
<CFFORM name="LOOKUP1" onsubmit="return validateSRNumber();" action="/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=#URL.PROCESS#" method="POST">	
		<TD align="LEFT" VALIGN="TOP">
          	<INPUT type="hidden" name="SRID" value="0" />
          	<CFINPUT type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#" align="LEFT" required="NO" size="9" maxlength="9" tabindex="2"><BR>
			<INPUT type="image" src="/images/buttonSelectSR.jpg" value="Select SR" alt="Select SR" tabindex="3" /><BR />
			<COM>(Use to find 1st Group Staff Assignments Only.)</COM>
          </TD>
</CFFORM>

     
<CFFORM name="LOOKUP2" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=LOOKUPGROUP" method="POST">
		<TD align="LEFT" VALIGN="TOP">
          	 <CFLOOP query = "ListGroupAssigned">
                    <CFINPUT type="Checkbox" name="GROUPID" id="GROUPID" value="#GROUPID#" tabindex="4">#GROUPNAME#<BR>
               </CFLOOP>
               <INPUT type="image" src="/images/buttonSelectGroup.jpg" value="Select Group" alt="Select Group" tabindex="5" /><BR />
			<COM>(Use to find all Group Staff Assignments.)</COM><BR><BR>
		</TD>
</CFFORM>

	<CFELSE>
     	
<CFFORM name="LOOKUP3" onsubmit="return validateSRReqFields();" action="/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPSRSTAFFASSIGN=FOUND" method="POST">
		<TD align="LEFT" valign="TOP">

               <CFSELECT name="SRID" id="SRID" size="1" required="No" tabindex="2">
               	<OPTION value="0">Select a Requester and SR</OPTION>
                    <CFLOOP query="ListStaffAssignedSRs">
                         <OPTION value="#ASSIGNSRID#">#LOOKUPKEY#</OPTION>
                    </CFLOOP>  
               </CFSELECT>

               <INPUT type="hidden" name="STAFF_ASSIGNEDID" value="#ListStaffAssignedSRs.STAFF_ASSIGNEDID#" />
               <BR>
               <INPUT type="image" src="/images/buttonSelectReqtrSR.jpg" value="Select Requester/SR" alt="Select Requester/SR" tabindex="3" /><BR />
			<COM>(Use to find 1st Group Staff Assignments Only.)</COM>

          </TD>
</CFFORM>

	</CFIF>     

	</TR>

	<CFIF URL.PROCESS EQ "ADD">

     <TR>
		<TD align="left">&nbsp;&nbsp;</TD>
	</TR>
     <TR>
          <TH align="left">Or <LABEL for="SRID">Requester and SR</LABEL></TH>
     	<TH align="left">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
  
<CFFORM name="LOOKUP3" onsubmit="return validateSRReqFields();" action="/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
		<TD align="LEFT">
          	 <CFSELECT name="SRID" id="SRID" size="1" required="No" tabindex="6">
               	<OPTION value="0">Select a Requester and SR</OPTION>
                    <CFLOOP query="ListServiceRequests">
                         <OPTION value="#SRID#">#LOOKUPKEY#</OPTION>
                    </CFLOOP>  
               </CFSELECT>	
			<BR>
               <INPUT type="image" src="/images/buttonSelectReqtrSR.jpg" value="Select Requester/SR" alt="Select Requester/SR" tabindex="7" /><BR />
			<COM>(Use to find 1st Group Staff Assignments Only.)</COM>
		</TD>
</CFFORM>
	</TR>
     </CFIF>
     <TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
		<TD align="left">
          	<BR><BR>
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="8" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>

</CFIF>
	<TR>
		<TD align="LEFT">&nbsp;&nbsp;</TD>
	</TR>

<CFIF URL.PROCESS EQ "LOOKUPGROUP">

	<TR>
<CFFORM action="/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=#Cookie.SAVE_PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
	</TR>

	<CFIF ListServiceRequests.RecordCount GT 0>
<CFFORM name="SECONDLOOKUP1" onsubmit="return validateRequesterSRReqFields();" action="/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=#Cookie.SAVE_PROCESS#" method="POST">
	<TR>
		<TH align="left"><LABEL for="SRID">Requester and SR</LABEL></TH>
	</TR>
	<TR>
		<TD align="LEFT">
          	<INPUT type="hidden" name="GROUPID" value="#FORM.GROUPID#" />
			<CFSELECT name="SRID" id="SRID" size="1" required="No" tabindex="2">
                    <OPTION value="0">CUSTOMER - SR NUMBER</OPTION>
                    <CFLOOP query="ListServiceRequests">
                         <OPTION value="#SRID#">#LOOKUPKEY#</OPTION>
                    </CFLOOP>  
               </CFSELECT>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT"><INPUT type="image" src="/images/buttonSelectReqtrSR.jpg" value="Select Requester/SR" alt="Select Requester/SR" tabindex="3" /></TD>
	</TR>
</CFFORM>
	<CFELSE>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("There are NO SR's assigned to this Group!  Please select another Group.");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
		<CFEXIT>
	</CFIF>
     <TR>
		<TD align="left">&nbsp;&nbsp;</TD>
	</TR>
     <TR>
<CFFORM action="/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=#Cookie.SAVE_PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
	</TR>

</CFIF>

	<TR>
		<TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
<BR><BR>

</BODY>
</CFOUTPUT>
</HTML>