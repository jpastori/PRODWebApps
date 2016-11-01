<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: staffassignsmodloop.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/25/2012 --->
<!--- Date in Production: 07/25/2012 --->
<!--- Module: Select SR Staff Assignments Modification Loop --->
<!-- Last modified by John R. Pastori on 09/30/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/staffassignsmodloop.cfm">
<CFSET CONTENT_UPDATED = "September 30, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<CFIF NOT IsDefined('Cookie.DISPLAYTYPE') AND IsDefined('URL.DISPLAYTYPE')>
	<CFCOOKIE name="DISPLAYTYPE" secure="NO" value="#URL.DISPLAYTYPE#">
</CFIF>
	
<HTML>
<HEAD>
	<TITLE>Modify Referral Loop to Completion - #Cookie.DISPLAYTYPE#</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Service Requests Lookup";

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


	function validateSTAFFIDReqFields() {
		if (document.LOOKUP.STAFFID.selectedIndex == "0") {
			alertuser ("You must select a Staff ID.");
			document.LOOKUP.STAFFID.focus();
			return false;
		}
	}

	function validateReqFields() {
		if (document.STAFFASSIGNMENT.STAFF_ASSIGNEDID.selectedIndex == "0") {
			alertuser (document.STAFFASSIGNMENT.STAFF_ASSIGNEDID.name +  ",  You must select a Staff Name.");
			document.STAFFASSIGNMENT.STAFF_ASSIGNEDID.focus();
			return false;
		}

		if (document.STAFFASSIGNMENT.STAFF_DATEASSIGNED.value == "" || document.STAFFASSIGNMENT.STAFF_DATEASSIGNED.value == " ") {
			alertuser (document.STAFFASSIGNMENT.STAFF_DATEASSIGNED.name +  ",  You must enter a Staff Assigned Date.");
			document.STAFFASSIGNMENT.STAFF_DATEASSIGNED.focus();
			return false;
		}
		
		if (document.STAFFASSIGNMENT.NEXT_ASSIGNMENT_REASON != null && (document.STAFFASSIGNMENT.NEXT_ASSIGNMENT_REASON.value == ""
		 || document.STAFFASSIGNMENT.NEXT_ASSIGNMENT_REASON.value == " ")) {
			alertuser ("You must enter a Next Assignment Reason.");
			document.STAFFASSIGNMENT.NEXT_ASSIGNMENT_REASON.focus();
			return false;
		}
		
		if ((document.STAFFASSIGNMENT.STAFF_COMMENTS != null || document.STAFFASSIGNMENT.STAFF_COMPLETEDCOMMENTSID.selectedIndex > "0")
		 && (document.STAFFASSIGNMENT.STAFF_TIME_WORKED.value != "00.0" && document.STAFFASSIGNMENT.STAFF_COMPLETEDSR.value == "YES" 
		 && document.STAFFASSIGNMENT.PROCESSSRSTAFFASSIGNS.value == "MODIFY LOOP")) {
			alertuser ("You must click the MODIFY TO COMPLETION Button to close this SR.");
			document.STAFFASSIGNMENT.STAFF_COMPLETEDSR.focus();
			return false;
		}
		
	}
	
	function validateModifyToCompletion() {
		if (document.STAFFASSIGNMENT.STAFF_ASSIGNEDID != null && document.STAFFASSIGNMENT.STAFF_ASSIGNEDID.selectedIndex == "0") {
			alertuser (document.STAFFASSIGNMENT.STAFF_ASSIGNEDID.name +  ",  You must select a Staff Name.");
			document.STAFFASSIGNMENT.STAFF_ASSIGNEDID.focus();
			return false;
		}
	
		if (document.STAFFASSIGNMENT.STAFF_DATEASSIGNED != null && (document.STAFFASSIGNMENT.STAFF_DATEASSIGNED.value == ""
		 || document.STAFFASSIGNMENT.STAFF_DATEASSIGNED.value == " ")) {
			alertuser (document.STAFFASSIGNMENT.STAFF_DATEASSIGNED.name +  ",  You must enter a Staff Assigned Date.");
			document.STAFFASSIGNMENT.STAFF_DATEASSIGNED.focus();
			return false;
		}
		
		if ((document.STAFFASSIGNMENT.STAFF_COMMENTS.value == "" && document.STAFFASSIGNMENT.STAFF_COMPLETEDCOMMENTSID.selectedIndex == "0")
		 && (document.STAFFASSIGNMENT.STAFF_TIME_WORKED.value == "00.0" && document.STAFFASSIGNMENT.STAFF_COMPLETEDSR.value == "NO")) {
			alertuser ("You must set the Completed SR? dropdown to YES or VOIDED when you click the MODIFY TO COMPLETION Button.");
			document.STAFFASSIGNMENT.STAFF_COMMENTS.focus();
			return false;
		}
		
		if ((document.STAFFASSIGNMENT.STAFF_COMMENTS.value == "" && document.STAFFASSIGNMENT.STAFF_COMPLETEDCOMMENTSID.selectedIndex == "0")
		 && (document.STAFFASSIGNMENT.STAFF_COMPLETEDSR.value == "YES" || document.STAFFASSIGNMENT.STAFF_COMPLETEDSR.value == "VOIDED")) {
			alertuser ("You must fill out one of the comment fields, fill out the Staff Time Worked field and set the Completed SR? dropdown to YES or VOIDED when you click the MODIFY TO COMPLETION Button.");
			document.STAFFASSIGNMENT.STAFF_COMMENTS.focus();
			return false;
		}
		
		if ((document.STAFFASSIGNMENT.STAFF_COMMENTS.value != null || document.STAFFASSIGNMENT.STAFF_COMPLETEDCOMMENTSID.selectedIndex > "0")
		 && (document.STAFFASSIGNMENT.STAFF_TIME_WORKED.value == "00.0" && document.STAFFASSIGNMENT.STAFF_COMPLETEDSR.value == "YES")) {
			alertuser ("You must enter a Staff Time Worked when Completed SR field is YES and you click the MODIFY TO COMPLETION Button.");
			document.STAFFASSIGNMENT.STAFF_TIME_WORKED.focus();
			return false;
		}
		
		if ((document.STAFFASSIGNMENT.STAFF_COMMENTS != null || document.STAFFASSIGNMENT.STAFF_COMPLETEDCOMMENTSID.selectedIndex > "0")
		 && (document.STAFFASSIGNMENT.STAFF_TIME_WORKED.value != "00.0" && document.STAFFASSIGNMENT.STAFF_COMPLETEDSR.value == "NO")) {
			alertuser ("You must set the Completed SR? dropdown to YES or VOIDED when you click the MODIFY TO COMPLETION Button.");
			document.STAFFASSIGNMENT.STAFF_COMPLETEDSR.focus();
			return false;
		}
						
		document.STAFFASSIGNMENT.PROCESSSRSTAFFASSIGNS.value = "MODIFY LOOP TO COMPLETION";
		return true;
		
	}

		
	function setDeleteLoop() {
		document.STAFFASSIGNMENT.PROCESSSRSTAFFASSIGNS.value = "DELETE LOOP";
		return true;
	}


	function setPrevRecord() {
		document.CHOOSEREC1.RETRIEVERECORD.value = "PREVIOUS RECORD";
		document.CHOOSEREC2.RETRIEVERECORD.value = "PREVIOUS RECORD";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFIF NOT IsDefined('URL.LOOKUPSTAFFID')>
	<CFSET CURSORFIELD = "document.LOOKUP.STAFFID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.STAFFASSIGNMENT.STAFF_COMMENTS.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
****************************************************************************************************
* The following code is the Staff Assigned Records Lookup Process for Multiple Modify Update Loop. *
****************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPSTAFFID')>

	<CFQUERY name="ListStaff" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, LASTNAME, FULLNAME AS STAFF, INITIALS, FULLNAME, ACTIVE
		FROM		CUSTOMERS
		WHERE	INITIALS IS NOT NULL AND
				ACTIVE = 'YES'
		ORDER BY	STAFF
	</CFQUERY>

	<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPNAME
	</CFQUERY>

	<CFSET session.SRSTAFFASSIGNArray=ArrayNew(1)>
	<CFSET temp = ArraySet(session.SRSTAFFASSIGNArray, 1, 1, 0)>
	<CFSET session.ArrayCounter = 0>

	<TABLE width="100%" align="center" border="3">
		<TR align="center"><BR />
          <CFIF (FIND('EXTRA', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
			<TD align="center"><H1>SR Comments via Loop Lookup - EXTRA </H1></TD>
          <CFELSE>
          	<TD align="center"><H1>SR Comments via Loop Lookup</H1></TD>
          </CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TD align="center"><H4>A Lookup Field Value MUST be chosen!</H4></TD>
		</TR>
	</TABLE>
	<BR />
	
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateSTAFFIDReqFields();" action="/#application.type#apps/servicerequests/staffassignsmodloop.cfm?LOOKUPSTAFFID=FOUND" method="POST">
		<TR>
			<TH align="left"><LABEL for="STAFFID">Staff Assigned</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="STAFFID" id="STAFFID" size="1" query="ListStaff" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="image" src="/images/buttonSelectStaff.jpg" value="Select Staff" alt="Select Staff" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
	<CFEXIT>
<CFELSEIF session.SRSTAFFASSIGNArray[1] EQ 0>

<!--- 
*******************************************************************************************************
* The following code is the Staff Assigned Records Selection Process for Multiple Modify Update Loop. *
*******************************************************************************************************
 --->
 
	<CFQUERY name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.NEXT_ASSIGNMENT, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, 
				SRSA.STAFF_COMPLETEDSR, CUST.FULLNAME || '-' || SR.SERVICEREQUESTNUMBER AS LOOKUPSTAFF
		FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.STAFFID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SRSA.STAFF_COMPLETEDSR = 'NO' AND
				SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
				SRSA.SRID = SR.SRID
		ORDER BY	LOOKUPSTAFF DESC
	</CFQUERY>

	<CFIF #LookupSRStaffAssignments.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting your selection criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm" />
		<CFEXIT>
	</CFIF>

	<CFSET SRSTAFFASSIGN = #ValueList(LookupSRStaffAssignments.SRSTAFF_ASSIGNID)#>
	<CFSET temp = ArraySet(session.SRSTAFFASSIGNArray, 1, LISTLEN(SRSTAFFASSIGN), 0)>
	<CFSET session.SRSTAFFASSIGNArray = ListToArray(SRSTAFFASSIGN)>
	<BR /><BR />SRSTAFFASSIGN = #SRSTAFFASSIGN#<BR /><BR />
	
</CFIF>

<!--- 
**************************************************************************************************
* The following code is the Display form for Staff Assigned Records Multiple Modify Update Loop. *
**************************************************************************************************
 --->
 
<CFIF IsDefined('FORM.RETRIEVERECORD') AND #FORM.RETRIEVERECORD# EQ "PREVIOUS RECORD">  	
	<CFSET session.ArrayCounter = #session.ArrayCounter# - 1>
<CFELSEIF NOT IsDefined('URL.SRSTAFF_ASSIGNID')>
     <CFSET session.ArrayCounter = #session.ArrayCounter# + 1>
</CFIF>

<CFIF session.ArrayCounter GT ARRAYLEN(session.SRSTAFFASSIGNArray)>
	<H1>All Selected Records Processed!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm" />
	<CFEXIT>
</CFIF>

<CFIF IsDefined('URL.SRSTAFF_ASSIGNID')>
	<CFSET FORM.SRSTAFF_ASSIGNID = #val(URL.SRSTAFF_ASSIGNID)#>
<CFELSE>
	<CFSET FORM.SRSTAFF_ASSIGNID = #session.SRSTAFFASSIGNArray[session.ArrayCounter]#>
</CFIF>

<CFQUERY name="GetSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
	SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.FULLNAME,
			TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS,
			SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, IDTGROUP.GROUPID, IDTGROUP.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON,
			SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID, SRSA.STAFF_ASSIGNMENT_ORDER
	FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED IDTGROUP
	WHERE	SRSA.SRSTAFF_ASSIGNID = <CFQUERYPARAM value="#FORM.SRSTAFF_ASSIGNID#" cfsqltype="CF_SQL_NUMERIC"> AND
			SRSA.STAFF_COMPLETEDSR = 'NO' AND
			SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
			WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
			SRSA.NEXT_ASSIGNMENT_GROUPID = IDTGROUP.GROUPID
	ORDER BY	SRSA.STAFF_ASSIGNEDID
</CFQUERY>

<CFCOOKIE name="SRSTAFF_ASSIGNID" secure="NO" value="#GetSRStaffAssignments.SRSTAFF_ASSIGNID#">

<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
	SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE, TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME,
			SDINIT.INITIALS, SR.REQUESTERID, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID, PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY,
               PROBSUBCAT.SUBCATEGORYNAME, SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, IDTGROUP.GROUPID, IDTGROUP.GROUPNAME, SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETED
	FROM		SERVICEREQUESTS SR, GROUPASSIGNED IDTGROUP, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY
	WHERE	SR.SRID = <CFQUERYPARAM value="#GetSRStaffAssignments.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
			SR.SRCOMPLETED = 'NO' AND
			SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
			SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
			SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
			SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
			SR.PRIORITYID = PRIORITY.PRIORITYID AND
               SR.SRCOMPLETED = 'NO'
	ORDER BY	SR.SRID
</CFQUERY>

<CFIF #GetServiceRequests.RecordCount# EQ 0>

	<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.SRCOMPLETED
		FROM		SERVICEREQUESTS SR
		WHERE	SR.SRID = <CFQUERYPARAM value="#GetSRStaffAssignments.SRID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	SR.SRID
	</CFQUERY>

	<SCRIPT language="JavaScript">
		<!-- 
			alert("The SR, #GetServiceRequests.SERVICEREQUESTNUMBER#, has been closed prematurely CLOSED (SR COMPLETED = #GetServiceRequests.SRCOMPLETED#). You still have an open referral!");
		--> 
	</SCRIPT>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm?LOOKUPSTAFFID=FOUND" />
	<CFEXIT>
</CFIF>

<CFCOOKIE name="SRID" secure="NO" value="#GetServiceRequests.SRID#">
<CFSET FORM.SRID = #cookie.SRID#>

<CFQUERY name="GetRequesters" datasource="#application.type#LIBSHAREDDATA">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC"> AND
			CUST.UNITID = UNITS.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="GetAltContacts" datasource="#application.type#LIBSHAREDDATA">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
			CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
	WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.ALTERNATE_CONTACTID#" cfsqltype="CF_SQL_NUMERIC"> AND
			CUST.UNITID = UNITS.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES'
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="GetSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
		FROM		SREQUIPLOOKUP
		WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#GetServiceRequests.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
</CFQUERY>

<CFIF #GetServiceRequests.PROBLEM_CATEGORYID# EQ 4 AND #GetSREquipLookup.RecordCount# GT 0>

	<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, 
				EQT.EQUIPMENTTYPE, HI.OWNINGORGID, HI.MODELNAMEID, MNAMEL.MODELNAME, HI.MODELNUMBERID, MNUML.MODELNUMBER,
				HI.CUSTOMERID, CUST.FULLNAME, LOC.LOCATIONNAME, HW.WARRANTYEXPIRATIONDATE AS WARDATE
		FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUML, LIBSHAREDDATAMGR.CUSTOMERS CUST,
				FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
		WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#GetSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
				HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
				HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
				HI.MODELNUMBERID = MNUML.MODELNUMBERID AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				HI.BARCODENUMBER = HW.BARCODENUMBER
		ORDER BY	BARCODENUMBER
	</CFQUERY>
     
                    
     <CFQUERY name="LookupHardwareAttachedTo" datasource="#application.type#HARDWARE">
          SELECT	ATTACHEDTOID, BARCODENUMBER, ATTACHEDTO
          FROM		HARDWAREATTACHEDTO
          WHERE	ATTACHEDTO = <CFQUERYPARAM value="#GetHardware.HARDWAREID#" cfsqltype="CF_SQL_VARCHAR">
     </CFQUERY>

</CFIF>

<CFQUERY name="LookupOtherStaff" datasource="#application.type#SERVICEREQUESTS">
     SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, GA.GROUPID, GA.GROUPNAME AS WORKGROUPNAME,
               CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS, SRSA.NEXT_ASSIGNMENT,
               SRSA.NEXT_ASSIGNMENT_GROUPID, NGA.GROUPID, NGA.GROUPNAME AS NEXTGROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR,
                SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID
     FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, GROUPASSIGNED NGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
     WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
               SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
               SRSA.STAFF_ASSIGNEDID > 0 AND
               WGA.GROUPID = GA.GROUPID AND
               SRSA.NEXT_ASSIGNMENT_GROUPID = NGA.GROUPID AND
               WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
               NOT WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#GetSRStaffAssignments.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR">
     ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="GetStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
	SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER,
			CUST.FULLNAME || ' - ' ||  GA.GROUPNAME AS CUSTOMERGROUP
	FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
	WHERE	WGA.GROUPID = GA.GROUPID AND
          <CFIF #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'YES'>
               (WGA.GROUPID = <CFQUERYPARAM value="#GetSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID#" cfsqltype="CF_SQL_VARCHAR">) AND
          <CFELSE>
                WGA.GROUPID = <CFQUERYPARAM value="#GetServiceRequests.GROUPASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR"> AND 
          </CFIF>
		<CFIF #Client.SecurityFlag# EQ "NO" AND #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ "NO">
			WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#GetSRStaffAssignments.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
		</CFIF>
     	<CFIF #LookupOtherStaff.RecordCount# GT 0>
               NOT WGA.WORKGROUPASSIGNSID = #LookupOtherStaff.STAFF_ASSIGNEDID# AND 
     	</CFIF>
			WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
	ORDER BY	GA.GROUPNAME, CUST.FULLNAME
</CFQUERY>

<CFQUERY name="LookupCompletedComments" datasource="#application.type#SERVICEREQUESTS" blockfactor="34">
	SELECT	COMPLETED_COMMENTSID, COMPLETED_COMMENTS
	FROM		COMPLETEDCOMMENTS
	ORDER BY	COMPLETED_COMMENTS
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		 <CFIF (FIND('EXTRA', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
			<TD align="center"><H1>Modify SR Comments via Loop - EXTRA </H1></TD>
          <CFELSE>
          	<TD align="center"><H1>Modify SR Comments via Loop</H1></TD>
          </CFIF>
	</TR>
</TABLE>
<TABLE width="100%">
	<TR>
		<TH align="center" colspan="3"><H4>Staff Assignments Key &nbsp; = &nbsp; #GetSRStaffAssignments.SRSTAFF_ASSIGNID#<BR />
		#GetSRStaffAssignments.FULLNAME# currently has #ArrayLen(session.SRSTAFFASSIGNArray)# Service Requests Assigned.</H4></TH>
	</TR>
</TABLE>
<TABLE align="left" width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/staffassignsmodloop.cfm?DISPLAYTYPE=#Cookie.DISPLAYTYPE#" method="POST">
		<TD align="left" width="33%">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
</CFFORM>
	</TR>
	<TR>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</TR>
     <TR>
<CFFORM name="CHOOSEREC1" action="/#application.type#apps/servicerequests/staffassignsmodloop.cfm?DISPLAYTYPE=#Cookie.DISPLAYTYPE#&LOOKUPSTAFFID=FOUND" method="POST">
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
     	<TD align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
</CFFORM>
	</TR>
     <TR>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</TR>
</TABLE>
   
<FIELDSET>
<LEGEND>Service Request</LEGEND>
<CFFORM name="STAFFASSIGNMENT" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processsrstaffassigninfo.cfm" method="POST" ENABLECAB="Yes">
<TABLE width="100%" align="LEFT">
	<TR>
		<TH align="left" width="33%">SR</TH>
		<TH align="left" width="33%">Creation Date</TH>
		<TH align="left" width="33%">Creation Time</TH>
	</TR>
	<TR>
		<INPUT type="hidden" name="SRID" value="#FORM.SRID#" />
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
		<TD align="left" width="33%">#GetRequesters.FULLNAME#</TD>
		<TD align="left" width="33%">#GetServiceRequests.PROBCATEGORY#</TD>
		<TD align="left" width="33%">#GetServiceRequests.SUBCATEGORYNAME#</TD>
	</TR>
	<TR>
		<TH align="left" width="33%">Service Desk Initials</TH>
		<TH align="left" width="33%">Priority</TH>
          <TH align="left" width="33%">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		
		<TD align="left" width="33%" valign="TOP">#GetServiceRequests.INITIALS#</TD>
		<TD align="left" width="33%" valign="TOP">#GetServiceRequests.PRIORITYNAME#</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</TR>
     <TR>
          <TH align="left" colspan="3">Problem Description</TH>
     </TR>
     <TR>
          <TD align="left" colspan="3">#GetServiceRequests.PROBLEM_DESCRIPTION#</TD>
     </TR>
</TABLE>
</FIELDSET>
<BR />
<CFIF IsDefined('GetHardware.RecordCount') AND #GetHardware.RecordCount# GT 0>
<FIELDSET>
<LEGEND>Associated Equipment</LEGEND>
<TABLE width="100%" align="LEFT">
	<TR>
		<TH align="left" width="33%">Bar Code Number</TH>
		<TH align="left" width="33%">State/Found Number</TH>
		<TH align="left" width="33%">Division Number</TH>
	</TR>
	<TR>
		<TD align="left" width="33%">#GetHardware.BARCODENUMBER#</TD>
		<TD align="left" width="33%">#GetHardware.STATEFOUNDNUMBER#</TD>
		<TD align="left" width="33%">#GetHardware.DIVISIONNUMBER#</TD>
	</TR>
	<TR>
		<TH align="left" width="33%">Warranty Expiration</TH>
		<TH align="left" width="33%">Equipment Attached</TH>
		<TH align="left" width="33%">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		<TD align="left" width="33%">#DateFormat(GetHardware.WARDATE, "mm/dd/yyyy")#</TD>
		<TD align="left" width="33%">
               <CFLOOP query="LookupHardwareAttachedTo">
                    #BARCODENUMBER#
               </CFLOOP>
          </TD>	
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</TR>
</TABLE>
</FIELDSET>
</CFIF>
<BR />
<FIELDSET>
<LEGEND>Group/Staff Assignments</LEGEND>
<TABLE width="100%" border="0">
	<TR>

	<CFIF #Client.SecurityFlag# EQ "YES">
		<CFIF #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'NO'>
               <TH align="left" width="33%">Primary Group Assigned</TH>
               <TH align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<H4><LABEL for="STAFF_ASSIGNEDID">*Primary Staff Assigned</LABEL></H4></TH>
               <TH align="left" width="33%"><H4><LABEL for="STAFF_DATEASSIGNED">*Date Primary Staff Assigned</LABEL></H4></TH>
          <CFELSE>
               <TH align="left" width="33%">Next Referral Group Assigned</TH>
               <TH align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<H4><LABEL for="STAFF_ASSIGNEDID">*Next Referral Staff Assigned</LABEL></H4></TH>
               <TH align="left" width="33%"><H4><LABEL for="STAFF_DATEASSIGNED">*Date Next Referral Staff Assigned</LABEL></H4></TH>
          </CFIF>
     <CFELSE>
          <CFIF #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'NO'>
               <TH align="left" width="33%">Primary Group Assigned</TH>
               <TH align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="STAFF_ASSIGNEDID">Primary Staff Assigned</LABEL></TH>
               <TH align="left" width="33%"><LABEL for="STAFF_DATEASSIGNED">Date Primary Staff Assigned</LABEL></TH>
          <CFELSE>
               <TH align="left" width="33%">Next Referral Group Assigned</TH>
               <TH align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="STAFF_ASSIGNEDID">Next Referral Staff Assigned</LABEL></TH>
               <TH align="left" width="33%"><LABEL for="STAFF_DATEASSIGNED">Date Next Referral Staff Assigned</LABEL></TH>
          </CFIF>
     </CFIF>
    	   	
     </TR>
	<TR>
	<CFIF #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ "YES">
		<TD align="left" width="33%">
          	#GetSRStaffAssignments.GROUPNAME#
               <CFSET SESSION.NEXTGROUP = "#GetSRStaffAssignments.GROUPNAME#">
          </TD>
	<CFELSE>
		<TD align="left" width="33%">
          	#GetServiceRequests.GROUPNAME#
               <CFSET SESSION.PRIMARYGROUP = "#GetServiceRequests.GROUPNAME#">
          </TD>
	</CFIF>
		<TD align="left" width="33%">
          <INPUT type="hidden" name="SRSTAFF_ASSIGNID" value="#Cookie.SRSTAFF_ASSIGNID#" />
		<CFIF #Client.SecurityFlag# EQ "YES">
          	&nbsp;&nbsp;&nbsp;&nbsp;
			<CFSELECT name="STAFF_ASSIGNEDID" id="STAFF_ASSIGNEDID" size="1" required="No" tabindex="4">
				<OPTION value="0">SELECT A STAFF NAME</OPTION>
				<OPTION selected value="#GetSRStaffAssignments.STAFF_ASSIGNEDID#">#GetSRStaffAssignments.FULLNAME#</OPTION>
				<CFLOOP query = "GetStaffAssigned">
					<OPTION value="#WORKGROUPASSIGNSID#">#FULLNAME#</OPTION>
				</CFLOOP>
			</CFSELECT>
		<CFELSE>
          	<INPUT type="hidden" name="STAFF_ASSIGNEDID" value="#GetSRStaffAssignments.STAFF_ASSIGNEDID#" />
			&nbsp;&nbsp;&nbsp;&nbsp;#GetSRStaffAssignments.FULLNAME#
		</CFIF>
		</TD>
          <TD align="left" width="33%">
		<CFIF #Client.SecurityFlag# EQ "Yes">
			<CFINPUT type="Text" name="STAFF_DATEASSIGNED" id="STAFF_DATEASSIGNED" value="#DateFormat(GetSRStaffAssignments.STAFF_DATEASSIGNED, "mm/dd/yyyy")#" align="LEFT" required="No" size="15" tabindex="5">
               <SCRIPT language="JavaScript">
				new tcal ({'formname': 'STAFFSRASSIGN','controlname': 'STAFF_DATEASSIGNED'});

			</SCRIPT>
		<CFELSE>
			#DateFormat(GetSRStaffAssignments.STAFF_DATEASSIGNED, "mm/dd/yyyy")#
		</CFIF>
		</TD>

	</TR>
     <TR>
          <TH align="left" colspan="3"><LABEL for="STAFF_COMMENTS">Comments</LABEL></TH>
     </TR>
     <TR>
          <TD align="left" colspan="3" valign="TOP">
               <CFTEXTAREA name="STAFF_COMMENTS" id="STAFF_COMMENTS" wrap="VIRTUAL" rows="6" cols="100" tabindex="6">#GetSRStaffAssignments.STAFF_COMMENTS#</CFTEXTAREA>
          </TD>
     </TR>
     <TR>
          <TH align="left" width="33%"><LABEL for="STAFF_COMPLETEDCOMMENTSID">Completion Comments</LABEL></TH>
          <TH align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;Assignments</TH>
	<CFIF #Client.SecurityFlag# EQ "YES">
          <TH align="left" width="33%"><LABEL for="STAFF_ASSIGNMENT_ORDER">Code</LABEL></TH>
	<CFELSE>
           <TH align="left" width="33%">&nbsp;&nbsp;</TH>
	</CFIF>
     </TR>
     <TR>
          <TD align="left" width="33%" valign="TOP">
               <CFSELECT name="STAFF_COMPLETEDCOMMENTSID" id="STAFF_COMPLETEDCOMMENTSID" size="1" query="LookupCompletedComments" value="COMPLETED_COMMENTSID" display="COMPLETED_COMMENTS" selected="#GetSRStaffAssignments.STAFF_COMPLETEDCOMMENTSID#" required="No" tabindex="7"></CFSELECT>
          </TD>
          <TD align="left" width="33%" valign="TOP">
     
               <CFQUERY name="LookupHardwareAssigns" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                    SELECT	SRHA.SRHARDWASSIGNID, SRHA.SRID, SRHA.HWSWID, HSA.HWSW_ID, HSA.HWSW_NAME
                    FROM		SRHARDWASSIGNS SRHA, HWSW HSA
                    WHERE	SRHA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                              SUBSTR(HSA.HWSW_NAME,1,2) = 'HW' AND
                              SRHA.HWSWID = HSA.HWSW_ID
                    ORDER BY	SRHA.HWSWID
               </CFQUERY>
               
               <TABLE width="33%" border="0">
                    <TR>
                         <TD align="left" width="16%" valign="TOP">&nbsp;&nbsp;&nbsp;&nbsp;HW:</TD>
                         <TD align="left" width="17%" valign="TOP">#LookupHardwareAssigns.Recordcount#</TD>
                    </TR>
          
               <CFQUERY name="LookupSoftwareAssigns" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                    SELECT	SRSA.SRSOFTWASSIGNID, SRSA.SRID, SRSA.HWSWID, HSA.HWSW_ID, HSA.HWSW_NAME
                    FROM		SRSOFTWASSIGNS SRSA, HWSW HSA
                    WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                              SUBSTR(HSA.HWSW_NAME,1,2) = 'SW' AND
                              SRSA.HWSWID = HSA.HWSW_ID 
                    ORDER BY	SRSA.HWSWID
               </CFQUERY>
               
               	<TR>
                         <TD align="left" width="16%" valign="TOP">&nbsp;&nbsp;&nbsp;&nbsp;SW:</TD>
                         <TD align="left" width="17%" valign="TOP">#LookupSoftwareAssigns.Recordcount#</TD>
                    </TR>

               <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	TNSWO_ID, SRID, WO_TYPE
                    FROM		TNSWORKORDERS
                    WHERE	SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                              NOT WO_TYPE LIKE ('%PHONE%')
                    ORDER BY	WO_TYPE
               </CFQUERY>
                               
               	<TR>
                         <TD align="left" width="16%" valign="TOP">&nbsp;&nbsp;&nbsp;&nbsp;TNS:</TD>
                         <TD align="left" width="17%" valign="TOP">#LookupTNSWorkOrders.Recordcount#</TD>
                    </TR>
               
               <CFQUERY name="LookupTelephoneWOs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                    SELECT	SRID
                    FROM		TNSWORKORDERS
                    WHERE	SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                              WO_TYPE LIKE ('%PHONE%')
                    ORDER BY	SRID
               </CFQUERY>
               
               	<TR>
                         <TD align="left" width="16%" valign="TOP">&nbsp;&nbsp;&nbsp;&nbsp;Tele:</TD>
                         <TD align="left" width="17%" valign="TOP">#LookupTelephoneWOs.Recordcount#</TD>
                    </TR>
               </TABLE>
 
          </TD>
	<CFIF #Client.SecurityFlag# EQ "YES">
          <TD align="left"valign="TOP" width="33%">
               <CFSELECT name="STAFF_ASSIGNMENT_ORDER" id="STAFF_ASSIGNMENT_ORDER" size="1" tabindex="26">
                    <OPTION selected value="#GetSRStaffAssignments.STAFF_ASSIGNMENT_ORDER#">#GetSRStaffAssignments.STAFF_ASSIGNMENT_ORDER#</OPTION>
                    <OPTION value="1">1</OPTION>
                    <OPTION value="2">2</OPTION>
                    <OPTION value="3">3</OPTION>
                    <OPTION value="4">4</OPTION>
                    <OPTION value="5">5</OPTION>
               </CFSELECT>
          </TD>
	<CFELSE>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
     </CFIF>
     </TR>
	<TR>
		<TH align="left" width="33%"><LABEL for="STAFF_TIME_WORKED">Staff Time Worked</LABEL></TH>
		<TH align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="STAFF_COMPLETEDSR">Completed SR?</LABEL></TH>
    <CFIF #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'YES'>
          <TH align="left" width="33%"><H4><LABEL for="NEXT_ASSIGNMENT_REASON">*Reason for Next Assignment</LABEL></H4></TH>
     <CFELSE>
          <TH align="left" width="33%">&nbsp;&nbsp</TH>
     </CFIF>
	</TR>
	<TR>
		<TD align="left" width="33%">
			<CFINPUT type="Text" name="STAFF_TIME_WORKED" id="STAFF_TIME_WORKED" value="#NumberFormat(GetSRStaffAssignments.STAFF_TIME_WORKED, '0_._')#" align="LEFT" required="No" size="25" tabindex="8"><BR>
               <INPUT type="image" src="/images/buttonTime.jpg" value="Time?"  alt="Time?" 
					onClick="window.open('/#application.type#apps/servicerequests/timefieldsreminder.cfm',
                         				 'Time Fields Reminder','alwaysRaised=yes,dependent=no,width=150,height=260,directories=no,toolbar=no,scrollbars=no,location=no,status=no,menubar=no,resizable=no,screenX=25,screenY=25'); return false;" 
									 tabindex="9" />
		</TD>
		<TD align="left" width="33%" valign="top">
          	&nbsp;&nbsp;&nbsp;&nbsp;
			<CFSELECT name="STAFF_COMPLETEDSR" id="STAFF_COMPLETEDSR" size="1" tabindex="10">
				<OPTION value="NO">NO</OPTION>
			<CFIF #GetSRStaffAssignments.STAFF_COMPLETEDSR# EQ "YES">
				<OPTION selected value="YES">YES</OPTION>
			<CFELSE>
				<OPTION value="YES">YES</OPTION>
			</CFIF>
			<CFIF #GetSRStaffAssignments.STAFF_COMPLETEDSR# EQ "VOIDED">
				<OPTION selected value="VOIDED">VOIDED</OPTION>
			<CFELSE>
				<OPTION value="VOIDED">VOIDED</OPTION>
			</CFIF>
			</CFSELECT>
		</TD>
	<CFIF #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'YES'>
          <TD align="left" width="33%" valign="top">
               <CFTEXTAREA name="NEXT_ASSIGNMENT_REASON" id="NEXT_ASSIGNMENT_REASON" wrap="VIRTUAL" rows="4" cols="25" tabindex="11">#GetSRStaffAssignments.NEXT_ASSIGNMENT_REASON#</CFTEXTAREA>
          </TD>
     <CFELSE>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
     </CFIF>
	</TR>
	</TABLE>
     <TABLE width="100%" border="0">
          <TR>
               <TH align="left" width="25%">Other Staff</TH>
               <TH align="left" width="25%">Other Staff Group</TH>
               <TH align="left" width="25%">Other Staff Comments</TH>
               <TH align="left" width="25%">Other Staff Completed SR?</TH>
          </TR>

     <CFIF LookupOtherStaff.RecordCount EQ 0>
          <TR>
               <TD align="left" valign="top" width="25%">
                    <STRONG>No Other Staff Have Been Assigned!</STRONG>
               </TD>
               <TD align="left" valign="top" width="25%">&nbsp;&nbsp;</TD>
               <TD align="left" valign="top" width="25%">&nbsp;&nbsp;</TD>
               <TD align="left" valign="top" width="25%">&nbsp;&nbsp;</TD>
          </TR>
     <CFELSE>
          <CFLOOP query="LookupOtherStaff">
          
           <TR>
               <TD align="left" valign="top" width="25%">
                    #LookupOtherStaff.FULLNAME#
               </TD>

               <TD align="left" valign="top" width="25%">
               <CFIF #LookupOtherStaff.STAFF_ASSIGNEDID# GT 0>
                    #LookupOtherStaff.WORKGROUPNAME#
               <CFELSE>
                    #LookupOtherStaff.NEXTGROUPNAME#
               </CFIF>
               </TD>
          
               <CFQUERY name="LookupCompletedComments" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	COMPLETED_COMMENTSID, COMPLETED_COMMENTS
                    FROM		COMPLETEDCOMMENTS
                    WHERE	COMPLETED_COMMENTSID = <CFQUERYPARAM value="#LookupOtherStaff.STAFF_COMPLETEDCOMMENTSID#" cfsqltype="CF_SQL_NUMERIC">
                    ORDER BY	COMPLETED_COMMENTS
               </CFQUERY>
          
               <TD align="left" valign="top" width="25%">
               <CFIF #LookupOtherStaff.STAFF_COMMENTS# EQ "" AND #LookupOtherStaff.STAFF_COMPLETEDCOMMENTSID# GT 0>
                    #LookupCompletedComments.COMPLETED_COMMENTS#
               <CFELSE>
                    #LookupOtherStaff.STAFF_COMMENTS#
               </CFIF>
               </TD>
               <TD align="left" valign="top" width="25%">
                    #LookupOtherStaff.STAFF_COMPLETEDSR#
               </TD>
          </TR>

          </CFLOOP>
     </CFIF>
     </TABLE>
</FIELDSET>
<BR />

<CFIF (FIND('EXTRA', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>

	<CFQUERY name="LookupPurchReqPO" datasource="#application.type#PURCHASING">
          SELECT	PURCHREQID, SERVICEREQUESTNUMBER, CREATIONDATE, PONUMBER, REQFILEDDATE, COMPLETIONDATE 
          FROM		PURCHREQS
          WHERE	SERVICEREQUESTNUMBER = '#GetServiceRequests.SERVICEREQUESTNUMBER#'
          ORDER BY	PONUMBER
     </CFQUERY>
     
     <CFIF LookupPurchReqPO.RecordCount GT 0>
     
          <CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
               SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PRL.LINEQTY, PRL.LINEDESCRIPTION
               FROM		PURCHREQLINES PRL
               WHERE	PRL.PURCHREQID = <CFQUERYPARAM value="#LookupPurchReqPO.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> 
               ORDER BY	PRL.LINENUMBER
          </CFQUERY>

     </CFIF>
     
     <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
          SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, TNSWO.CURRENT_JACKNUMBER, CURRWJ.JACKNUMBER AS CURRJACK,
                    TNSWO.NEW_JACKNUMBER, NEWWJ.JACKNUMBER AS NEWJACK, TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION, TNSWO.JUSTIFICATION_DESCRIPTION, 
                    TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER, TNSWO.EBA_111, TNSWO.NEW_LOCATION
          FROM		TNSWORKORDERS TNSWO, FACILITIESMGR.WALLJACKS CURRWJ, FACILITIESMGR.WALLJACKS NEWWJ
          WHERE	TNSWO.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    TNSWO.CURRENT_JACKNUMBER = CURRWJ.WALLJACKID AND
                    TNSWO.NEW_JACKNUMBER = NEWWJ.WALLJACKID
          ORDER BY	TNSWO.WO_TYPE
     </CFQUERY>	
          
<FIELDSET>
<LEGEND>Extra</LEGEND>
<TABLE width="100%" border="0">
	<TR>
		<TD colspan="3">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TH align="left" width="33%">Parts Quantity</TH>
		<TH align="left" width="33%">Parts Requested</TH>
		<TH align="left" width="33%">Purchase Order Number</TH>
	</TR>
	<TR>
      <CFIF LookupPurchReqPO.RecordCount GT 0>
     	<TD align="left" width="33%" valign="top">
          <CFLOOP query = "LookupPurchReqLines">
			#LookupPurchReqLines.LINEQTY#<BR><BR>
          </CFLOOP>
          </TD>       
		<TD align="left" width="33%" valign="top">
         	<CFLOOP query = "LookupPurchReqLines">
			#LEFT(LookupPurchReqLines.LINEDESCRIPTION, 40)#<BR><BR>
          </CFLOOP>
          </TD>
          <TD align="left" width="33%" valign="top">#LookupPurchReqPO.PONUMBER#</TD>
	<CFELSE>
     	<TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</CFIF>	
	</TR>
	<TR>
		<TH align="left" width="33%">PO Creation Date</TH>
		<TH align="left" width="33%">PO Filed Date</TH>
		<TH align="left" width="33%">PO Completion Date</TH>
	</TR>
	<TR>
     <CFIF LookupPurchReqPO.RecordCount GT 0>
		<TD align="left" width="33%">#DateFormat(LookupPurchReqPO.CREATIONDATE, "mm/dd/yyyy")#</TD>
		<TD align="left" width="33%">#DateFormat(LookupPurchReqPO.REQFILEDDATE, "mm/dd/yyyy")#</TD>
		<TD align="left" width="33%">#DateFormat(LookupPurchReqPO.COMPLETIONDATE, "mm/dd/yyyy")#</TD>
     <CFELSE>
     	<TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</CFIF>	
	</TR>
	<TR>
		<TH align="left" width="33%">TNS Work Order Number</TH>
		<TH align="left" width="33%">TNS Complete Date</TH>
		<TH align="left" width="33%">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		<TD align="left" width="33%">#LookupTNSWorkOrders.WO_NUMBER#</TD>
		<CFIF LookupTNSWorkOrders.WO_DUEDATE NEQ ''>
		<TD align="left" width="33%">#DateFormat(LookupTNSWorkOrders.WO_DUEDATE, "mm/dd/yyyy")#</TD>
		<CFELSE>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
		</CFIF>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</TR>
</TABLE>
</FIELDSET>
<BR />
</CFIF>

<FIELDSET>
<LEGEND>Assignment Record Processing</LEGEND>
<TABLE width="100%" border="0">
	<TR>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
		<TD align="left" width="33%">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD align="left" width="33%">
          	<INPUT type="hidden" name="PROCESSSRSTAFFASSIGNS" value="MODIFY LOOP" />
               <INPUT type="image" src="/images/buttonModifyLoop.jpg" value="MODIFY LOOP" alt="Modify Loop" tabindex="12" />
          </TD>
     <CFIF (FIND('ADMIN', #Cookie.DISPLAYTYPE#, 1) NEQ 0)>
     	<TD align="left" width="33%"><INPUT type="image" src="/images/buttonDEL-Loop.jpg" value="DELETE LOOP" alt="Delete Staff Assignment" onClick="return setDeleteLoop();" tabindex="13" /></TD>
     <CFELSE>
		<TD align="left" width="33%"><INPUT type="image" src="/images/buttonMODLoopCompletion.jpg" value="MODIFY LOOP TO COMPLETION" alt="Modify Loop To Completion" onClick="return validateModifyToCompletion();" tabindex="13" /></TD>
     </CFIF>
	<CFIF Client.MaintLessFlag EQ "No">
          <TD align="left" width="33%">
              <INPUT type="image" src="/images/buttonAddNextGrp.jpg" value="Add Next Group" alt="Add Next Group" onClick="window.open('/#application.type#apps/servicerequests/srnextrefergroupchoice.cfm?SRID=#Cookie.SRID#&PROCESS=ADD&STAFFLOOP=YES',
                                          'Add Next Group','alwaysRaised=yes,dependent=no,width=800,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                          tabindex="14" />
          </TD>
	</CFIF>
	</TR>

</CFFORM>
<CFFORM name="CHOOSEREC2" action="/#application.type#apps/servicerequests/staffassignsmodloop.cfm?DISPLAYTYPE=#Cookie.DISPLAYTYPE#&LOOKUPSTAFFID=FOUND" method="POST">
     <TR>
          <TD align="left" width="33%">
          	<INPUT type="hidden" name="RETRIEVERECORD" value="NEXT RECORD" />
          	<INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXT RECORD" alt="Next Record" tabindex="15" />
          </TD>
	 <CFIF #session.ArrayCounter# GT 1>
          <TD align="left" width="33%">
               <INPUT type="image" src="/images/buttonPreviousRec.jpg" value="PREVIOUS RECORD" alt="Previous Record" onClick="return setPrevRecord();" tabindex="16" />
          </TD>
     <CFELSE>
     	<TD align="left" width="33%">&nbsp;&nbsp;</TD>
     </CFIF>
          <TD align="left" width="33%">&nbsp;&nbsp;</TD>
     </TR>
</CFFORM>
</TABLE>
</FIELDSET>
<BR />

<CFIF (FIND('ADMIN', #Cookie.DISPLAYTYPE#, 1) EQ 0)>
<FIELDSET>
<LEGEND>Add Supplemental Records</LEGEND>
<TABLE width="100%" border="0">
			<TR>
                    <TD align="left" width="33%">
                         <INPUT type="image" src="/images/buttonAddChat.jpg" value="Add Chatter" alt="Add Chatter"  
                          onClick="window.open('/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=ADD&STAFFLOOP=YES',
                                               'Add Chatter','alwaysRaised=yes,dependent=no,width=950,height=1000,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="14" /> 
                    </TD>
                    <TD align="left" width="33%">                    
                         <INPUT type="image" src="/images/buttonAddHWAssigns.jpg" value="Add Hardware Assignments" alt="Add Hardware Assignments" 
                          onClick="window.open('/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#',
                                               'Add Hardware Assignments','alwaysRaised=yes,dependent=no,width=1200,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="15" />
                    </TD>
                    <TD align="left" width="33%">                    
                         <INPUT type="image" src="/images/buttonModDelHWAssigns.jpg" value="Modify/Delete Hardware Assignments" alt="Modify/Delete Hardware Assignments" 
                          onClick="window.open('/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYDELETE&LOOKUPITEM=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                                               'Modify/Delete Hardware Assignments','alwaysRaised=yes,dependent=no,width=1200,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="16" />
                    </TD>
                    
			</TR>
			<TR>
                    <TD align="left" width="33%">&nbsp;&nbsp;</TD>
                    <TD align="left" width="33%">
                         <INPUT type="image" src="/images/buttonAddSWAssigns.jpg" value="Add Software Assignments" alt="Add Software Assignments" 
                          onClick="window.open('/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#',
                                               'Add Software Assignments','alwaysRaised=yes,dependent=no,width=1200,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="17" />
                    </TD>
                    <TD align="left" width="33%">
                         <INPUT type="image" src="/images/buttonModDelSWAssigns.jpg" value="Modify/Delete Software Assignments" alt="Modify/Delete Software Assignments" 
                          onClick="window.open('/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYDELETE&STAFFLOOP=YES&SRID=#FORM.SRID#',
                                               'Add Software Assignments','alwaysRaised=yes,dependent=no,width=1200,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="18" />
                    </TD>
			</TR>
			<TR>
				<TD align="left" width="33%">&nbsp;&nbsp;</TD>
			<CFIF #GetServiceRequests.PROBLEM_CATEGORYID# EQ 9 OR #GetServiceRequests.PROBLEM_CATEGORYID# EQ 16>
              		<TD align="left" width="33%">
                    	<INPUT type="image" src="/images/buttonAddTNSRequest.jpg" value="Add TNS Requests" alt="Add TNS Requests" 
                          onClick="window.open('/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Add TNS Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="19" />
                   </TD>
                   <TD align="left" width="33%">
					<INPUT type="image" src="/images/buttonModifyTNSRequest.jpg" value="Modify TNS Requests" alt="Modify TNS Requests"  
					 onClick="window.open('/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Modify TNS Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					 				  tabindex="20" /> 
                    </TD>
			<CFELSE>	
                    <TD align="left" width="33%">&nbsp;&nbsp;</TD>
               </CFIF>     
			
			</TR>
		<CFIF #GetServiceRequests.PROBLEM_CATEGORYID# EQ 9 OR #GetServiceRequests.PROBLEM_CATEGORYID# EQ 16>
               <TR>
               	<TD align="left" width="33%">&nbsp;&nbsp;</TD>
			     <TD align="left" width="33%">
                    	<INPUT type="image" src="/images/buttonAddPhoneRequest.jpg" value="Add Telephone Requests" alt="Add Telephone Requests" 
                          onClick="window.open('/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Add Telephone Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="21" />
                   </TD>
			     <TD align="left" width="33%">
                    	<INPUT type="image" src="/images/buttonModPhoneRequest.jpg" value="Modify Telephone Requests" alt="Modify Telephone Requests" 
                          onClick="window.open('/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Modify Telephone Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="22" />
                    </TD>
			</TR>
               <TR>
               	<TD align="left" width="33%">&nbsp;&nbsp;</TD>
			     <TD align="left" width="33%">
					<INPUT type="image" src="/images/buttonSubmitTNSRequest.jpg" value="Submit TNS Requests" alt="Submit TNS Requests"  
					 onClick="window.open('/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=SUBMIT&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Submit TNS Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					 				  tabindex="23" /> 
                    </TD>
			     <TD align="left" width="33%">
                    	<INPUT type="image" src="/images/buttonSubmitPhoneRequest.jpg" value="Submit Telephone Requests" alt="Submit Telephone Requests" 
                          onClick="window.open('/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=SUBMIT&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Submit Telephone Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="24" />
                    </TD>
			</TR>
		</CFIF>
 		</TABLE>
</FIELDSET>
<BR />
</CFIF>

<TABLE width="100%" align="LEFT">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/staffassignsmodloop.cfm?DISPLAYTYPE=#Cookie.DISPLAYTYPE#" method="POST">
		<TD align="left" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="24" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>

</BODY>
</HTML>
</CFOUTPUT>