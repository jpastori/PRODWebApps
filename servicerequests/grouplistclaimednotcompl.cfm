<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: grouplistclaimednotcompl.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/06/2012 --->
<!--- Date in Production: 11/06/2012 --->
<!--- Module: Group List Claimed/Not Complete --->
<!-- Last modified by John R. Pastori on 10/01/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/grouplistclaimednotcompl.cfm">
<CFSET CONTENT_UPDATED = "October 01, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Group List Claimed/Not Complete</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
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
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFIF NOT IsDefined('URL.LOOKUPGROUPID')>
	<CFSET CURSORFIELD = "document.LOOKUP.GROUPID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>

<BODY onLoad="#CURSORFIELD#">

<!--- 
********************************************************************************************************
* The following code is the Group Assigned Records Lookup Process for Group List Claimed/Not Complete. *
********************************************************************************************************
 --->
 

<CFIF NOT IsDefined('URL.LOOKUPGROUPID')>

	<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPNAME
	</CFQUERY>
	
     <CFQUERY name="ListStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	DISTINCT WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
          		CUST.ACTIVE = 'YES' 
		ORDER BY	CUST.FULLNAME
	</CFQUERY>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Group Meeting List Claimed/Not Complete Lookup</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TD align="center"><H4>A Group and Sort Order MUST be chosen!</H4></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
			<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left" width="50%"><LABEL for="GROUPID">Group</LABEL></TH>
               <TH align="left" width="50%"><LABEL for="REPORTSORTORDER"> Sort Order</LABEL></TH>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/grouplistclaimednotcompl.cfm?LOOKUPGROUPID=FOUND" method="POST">
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" selected ="0" display="GROUPNAME" required="No" tabindex="2"></CFSELECT>
               </TD>
               <TD align="left" width="50%">
                   	<CFSELECT name="REPORTSORTORDER" id="REPORTSORTORDER" size="1" required="No" tabindex="3">
                         <OPTION value="0">Select a Sort Order</OPTION>
                    	<OPTION SELECTED value="1">Staff Assigned/SR Number</OPTION>
                         <OPTION value="2">Staff Assigned/Priority/SR Number</OPTION>
                         <OPTION value="3">Staff Assigned/Requester/SR Number</OPTION>
                         <OPTION value="4">Staff Assigned/Creation Date/SR Number</OPTION>
                    </CFSELECT>
               </TD>
          </TR>
          <TR>
               <TD align="left" COLSPAN="2">
				<INPUT type="image" src="/images/buttonSelectGroup.jpg" value="Select Group" alt="Select Group" tabindex="4" />
			</TD>
		</TR>
</CFFORM>
          <TR>
			<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	<CFEXIT>
     
<CFELSE>

<!--- 
***************************************************************************************************
* The following code is the Group Assigned Selection Process for Group List Claimed/Not Complete. *
***************************************************************************************************
 --->

           
     
     <CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
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
     </CFQUERY>
               
	<CFIF #LookupServiceRequests.RecordCount# EQ 0>
          <SCRIPT language="JavaScript">
               <!-- 
                    alert("SR Records for your selected Group were Not Found");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/grouplistclaimednotcompl.cfm" />
          <CFEXIT>
     </CFIF>
     
     <CFSET SRIDS = #ValueList(LookupServiceRequests.SRID)#>
     <!--- <BR>SR IDS = #SRIDS# <BR> --->
     
     <CFQUERY name="LookupGroupStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
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
     </CFQUERY>
               
	<CFIF #LookupGroupStaffAssignments.RecordCount# GT 0>
          <CFSET SESSION.GROUPSRS = #ValueList(LookupGroupStaffAssignments.SRID)#>
     <CFELSE>
     	<CFSET SESSION.GROUPSRS = #ValueList(LookupServiceRequests.SRID)#>
     </CFIF>

     
     <!--- <BR>GROUP SRS = #SESSION.GROUPSRS# <BR> --->
     <CFSET SESSION.LKUPGROUPID = #FORM.GROUPID#>
     

<!--- 
*********************************************************************************
* The following code is the Report Display for Group List Claimed/Not Complete. *
*********************************************************************************
 --->
 
	<CFSET CLIENT.REPORTCHOICE = 0>
     <CFSET CLIENT.REPORTORDER = 0>
     <CFSET CLIENT.REPORTTILE1 = "">
     <CFSET CLIENT.REPORTTILE2 = "">
     <CFSET SESSION.STAFFNAME = "">
     <CFSET SESSION.FIRSTRECORD = "YES">
     
     <CFSET CLIENT.REPORTCHOICE = #FORM.REPORTSORTORDER#>
      
     <CFSET SORTORDER = ARRAYNEW(1)>
     <CFSET SORTORDER[1]  = 'STAFF~ SR.SERVICEREQUESTNUMBER'>
     <CFSET SORTORDER[2]  = 'STAFF~ P.PRIORITYNAME~ SR.SERVICEREQUESTNUMBER'>
     <CFSET SORTORDER[3]  = 'STAFF~ REQCUST.FULLNAME~ SR.SERVICEREQUESTNUMBER'>
     <CFSET SORTORDER[4]  = 'STAFF~ SR.CREATIONDATE~ SR.SERVICEREQUESTNUMBER'>
     
     <CFSET CLIENT.REPORTORDER = EVALUATE("SORTORDER[#CLIENT.REPORTCHOICE#]")>
     
     <CFIF FIND('~', #CLIENT.REPORTORDER#, 1) NEQ 0>
          <CFSET CLIENT.REPORTORDER = ListChangeDelims(CLIENT.REPORTORDER, ",", "~")>
     </CFIF>	
     
     <CFSET CLIENT.REPORTTITLE1 = "Group Meeting List Claimed/Not Complete Report">
     
          
     <CFQUERY name="LookupGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
          SELECT	GROUPID, GROUPNAME
          FROM		GROUPASSIGNED
          WHERE	GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	GROUPNAME
     </CFQUERY>
     
     <CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
     	<CFSET CLIENT.REPORTTITLE2 = "For Group: &nbsp;&nbsp;ES/LIB - ES/AA">
     <CFELSE>
     	<CFSET CLIENT.REPORTTITLE2 = "For Group: &nbsp;&nbsp;#LookupGroupAssigned.GROUPNAME#">
     </CFIF>
     
     <CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SRSA.SRID, SRSA.NEXT_ASSIGNMENT, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.GROUPID, STAFFCUST.CUSTOMERID, STAFFCUST.FULLNAME AS STAFF, 
                    SR.SRID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATEDATE, SR.REQUESTERID, REQCUST.CUSTOMERID, 
                    REQCUST.FULLNAME AS REQUESTER, SR.PRIORITYID, P.PRIORITYNAME, SR.PROBLEM_DESCRIPTION
          FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS STAFFCUST, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PRIORITY P
          WHERE	SRSA.SRID IN (#SESSION.GROUPSRS#) AND
                    SRSA.SRID = SR.SRID AND
                    SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                    SRSA.STAFF_ASSIGNEDID > 0 AND
                    WGA.STAFFCUSTOMERID = STAFFCUST.CUSTOMERID  AND
			<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                    WGA.GROUPID IN (7,19) AND
               <CFELSE> 
                    WGA.GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
               </CFIF>
                    SRSA.STAFF_COMPLETEDSR = 'NO' AND
                    SR.REQUESTERID = REQCUST.CUSTOMERID AND
                    SR.PRIORITYID = P.PRIORITYID
          ORDER BY	#CLIENT.REPORTORDER# DESC
     </CFQUERY>

</CFIF>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center">
			<H1>#CLIENT.REPORTTITLE1#</H1>
			<H2>#CLIENT.REPORTTITLE2#</H2>
		</TD>       
	</TR>
</TABLE>
<BR clear="left" />

<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/grouplistclaimednotcompl.cfm" method="POST">
		<TD align="left">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER"><H2>#GetServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
	</TR>
</TABLE>


<TABLE width="100%" border="1">
	<TR>   
     	<TH align="center">Staff Assigned</TH>
		<TH align="center">SR</TH>
		<TH align="center">Creation Date</TH>
		<TH align="center">Priority</TH>
		<TH align="center">Problem Description</TH>
		<TH align="center">Requester</TH>
	</TR>

<CFLOOP query="GetServiceRequests">

<CFIF SESSION.STAFFNAME NEQ #GetServiceRequests.STAFF# AND SESSION.FIRSTRECORD EQ "NO">
	<TR>
     	<TD align="left" COLSPAN="6">&nbsp;&nbsp;</TD>
	</TR>
</CFIF>
<CFIF SESSION.FIRSTRECORD EQ "YES">
	<CFSET SESSION.FIRSTRECORD = "NO">
</CFIF>
	<TR>
     <CFIF SESSION.STAFFNAME NEQ #GetServiceRequests.STAFF#>
     	<TD align="left" valign="top">
          	<H3>#GetServiceRequests.STAFF#</H3>
               <CFSET SESSION.STAFFNAME = "#GetServiceRequests.STAFF#">
          </TD>
     <CFELSE>
     	<TD align="left">&nbsp;&nbsp;</TD>
     </CFIF>
		<TD align="center" valign="TOP"><DIV>#GetServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
		<TD align="center" valign="TOP"><DIV>#GetServiceRequests.CREATEDATE#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#GetServiceRequests.PRIORITYNAME#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#LEFT(GetServiceRequests.PROBLEM_DESCRIPTION, 100)#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#GetServiceRequests.REQUESTER#</DIV></TD>
	</TR>
</CFLOOP>
			
</TABLE>
<TABLE width="100%" border="0">
	<TR>
		<TH align="CENTER" colspan="6"><H2>#GetServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
	</TR>

	<TR>
<CFFORM action="/#application.type#apps/servicerequests/grouplistclaimednotcompl.cfm" method="POST">
		<TD align="left" colspan="6">
          	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
          </TD>
</CFFORM>
</TR>
	<TR>
		<TD colspan="6">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>


</BODY>
</CFOUTPUT>
</HTML>