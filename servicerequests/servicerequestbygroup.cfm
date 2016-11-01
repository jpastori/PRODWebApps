<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: servicerequestbygroup.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/25/2012 --->
<!--- Date in Production: 05/25/2012 --->
<!--- Module: IDT Service Requests - Report by Group--->
<!-- Last modified by John R. Pastori on 05/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/servicerequestbygroup.cfm">
<CFSET CONTENT_UPDATED = "May 25, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Service Requests Report by Group</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Service Requests Lookup";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateGROUPReqFields() {
		if (document.LOOKUP.GROUPID.selectedIndex == "0") {
			alertuser ("You must select a Group Name.");
			document.LOOKUP.GROUPID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.GROUPID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
****************************************************************************************
* The following code is the Lookup Process for IDT Service Requests - Report by Group. *
****************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPID
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Look up Group Name for IDT Service Requests Report by Group</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/servicerequestbygroup.cfm?PROCESS=LOOKUPGROUP" method="POST">
		<TR>
			<TH align="left" nowrap><LABEL for="GROUPID">Look Up by Group Assigned:</LABEL></TH>
			<TD align="LEFT">
				<CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" selected ="0" display="GROUPNAME" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonSelectGroup.jpg" value="Select Group" alt="Select Group" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" />
               </TD>
</CFFORM>
		</TR>
		<TR>
		<TD align="left" colspan="5"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************
* The following code is the Report by Group Generation Process. *
*****************************************************************
 --->

	<CFQUERY name="ListServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE, 
				TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SDINIT.FULLNAME, REQ.FULLNAME AS RNAME,
				SR.ALTERNATE_CONTACTID, ALTCONTACT.FULLNAME AS ANAME, PROBCAT.CATEGORYLETTER || PROBCAT.CATEGORYNAME AS PROBCATEGORY,
				PROBSUBCAT.SUBCATEGORYNAME AS PROBSUBCATEGORY, PRIORITY.PRIORITYNAME, IDTGROUP.GROUPNAME, SERVICETYPES.SERVICETYPENAME,
				ACTIONS.ACTIONNAME, OPSYS.OPSYSNAME, OPTIONS.OPTIONNAME, SR.SRCOMPLETEDDATE
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, LIBSHAREDDATAMGR.CUSTOMERS REQ,
				LIBSHAREDDATAMGR.CUSTOMERS ALTCONTACT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
				GROUPASSIGNED IDTGROUP, SERVICETYPES, ACTIONS, OPSYS, OPTIONS
		WHERE	SR.GROUPASSIGNEDID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
				SR.REQUESTERID = REQ.CUSTOMERID AND
				SR.ALTERNATE_CONTACTID = ALTCONTACT.CUSTOMERID AND
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.PRIORITYID = PRIORITY.PRIORITYID AND
				SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
				SR.SERVICETYPEID = SERVICETYPES.SERVICETYPEID AND
				SR.ACTIONID = ACTIONS.ACTIONID AND
				SR.OPERATINGSYSTEMID = OPSYS.OPSYSID AND 
				SR.OPTIONID = OPTIONS.OPTIONID
		ORDER BY	SR.SRID
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>IDT Service Requests Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/servicerequestbygroup.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="15"><H2>#ListServiceRequests.RecordCount# hardware records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="center">Service Desk Initials</TH>
			<TH align="center">Service Request Number</TH>
			<TH align="center">Creation Date</TH>
			<TH align="center">Creation Time</TH>
			<TH align="center">Requester</TH>
			<TH align="center">Alternate Contact</TH>
			<TH align="center">Problem Category</TH>
			<TH align="center">Problem Sub-Category</TH>
			<TH align="center">Priority</TH>
			<TH align="center">Service Type</TH>
			<TH align="center">Action</TH>
			<TH align="center">Operating System</TH>
			<TH align="center">Option</TH>
			<TH align="center">Group Assigned</TH>
			<TH align="center">SR Completed Date</TH>
		</TR>
	<CFLOOP query="ListServiceRequests">
		<TR>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.FULLNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.CREATIONDATE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.CREATIONTIME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.RNAME#</DIV></TD>
		<CFIF #ListServiceRequests.ALTERNATE_CONTACTID# GT "0">
			<TD align="center" valign="TOP"><DIV>#ListServiceRequests.ANAME#</DIV></TD>
		<CFELSE>
			<TD align="left" valign="TOP">&nbsp;</TD>
		</CFIF>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.PROBCATEGORY#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.PROBSUBCATEGORY#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.PRIORITYNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.SERVICETYPENAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.ACTIONNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.OPSYSNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.OPTIONNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListServiceRequests.GROUPNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListServiceRequests.SRCOMPLETEDDATE, "mm/dd/yyyy")#</DIV></TD> 
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="15"><H2>#ListServiceRequests.RecordCount# hardware records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/servicerequestbygroup.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="15">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>