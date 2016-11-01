<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srstaffassigninfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/20/2012 --->
<!--- Date in Production: 09/20/2012 --->
<!--- Module: Add/Modify/Void/Delete SR Staff Assignments --->
<!-- Last modified by John R. Pastori onon 07/26/2016 using DreamWeaver. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/srstaffassigninfo.cfm">
<cfset CONTENT_UPDATED = "July 26, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<cfif URL.PROCESS EQ 'ADD'>
		<title>Add SR Staff Assignments</title>
	<cfelse>
		<title>Modify/Void/Delete Staff SR Assignments</title>
	</cfif>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to SR Staff Assignments";

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


	function validateAddReqFields() {
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
	
		if (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED != null && (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.value == ""
		 || document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.value == " ")) {
			alertuser (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.name +  ",  You must enter a Staff Assigned Date.");
			document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.focus();
			return false;
		}
	}
	
	
	function validateLookupReqFields() {
		if (document.LOOKUP.STAFF_ASSIGNEDID.selectedIndex == "0" && document.LOOKUP.GROUP_ASSIGNEDID.selectedIndex == "0") {
			alertuser ("You must select a Staff Member, Group and SR.");
			document.LOOKUP.STAFF_ASSIGNEDID.focus();STAFF_ASSIGNEDID
			return false;
		}
	}
	

	function validateModifyReqFields() {
		if (document.SRSTAFFASSIGN.STAFF_ASSIGNEDID != null && document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.selectedIndex == "0") {
			alertuser (document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.name +  ",  You must select a Staff Name.");
			document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.focus();
			return false;
		}
	
		if (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED != null && (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.value == ""
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
		
		if ((document.SRSTAFFASSIGN.STAFF_COMMENTS != null || document.SRSTAFFASSIGN.STAFF_COMPLETEDCOMMENTSID.selectedIndex > "0")
		 && (document.SRSTAFFASSIGN.STAFF_TIME_WORKED.value != "00.0" && document.SRSTAFFASSIGN.STAFF_COMPLETEDSR.value == "YES" 
		 && document.SRSTAFFASSIGN.PROCESSSRSTAFFASSIGNS.value == "MODIFY")) {
			alertuser ("You must click the MODIFY TO COMPLETION Button to close this SR.");
			document.SRSTAFFASSIGN.STAFF_COMPLETEDSR.focus();
			return false;
		}
		
	}

	
	function validateModifyToCompletion() {
		if (document.SRSTAFFASSIGN.STAFF_ASSIGNEDID != null && document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.selectedIndex == "0") {
			alertuser (document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.name +  ",  You must select a Staff Name.");
			document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.focus();
			return false;
		}
	
		if (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED != null && (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.value == ""
		 || document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.value == " ")) {
			alertuser (document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.name +  ",  You must enter a Staff Assigned Date.");
			document.SRSTAFFASSIGN.STAFF_DATEASSIGNED.focus();
			return false;
		}
		
		if ((document.SRSTAFFASSIGN.STAFF_COMMENTS.value == "" && document.SRSTAFFASSIGN.STAFF_COMPLETEDCOMMENTSID.selectedIndex == "0")
		 && (document.SRSTAFFASSIGN.STAFF_TIME_WORKED.value == "00.0" && document.SRSTAFFASSIGN.STAFF_COMPLETEDSR.value == "NO")) {
			alertuser ("You must fill out one of the comment fields, fill out the Staff Time Worked field and set the Completed SR? dropdown to YES or VOIDED when you click the MODIFY TO COMPLETION Button.");
			document.SRSTAFFASSIGN.STAFF_COMMENTS.focus();
			return false;
		}
		
		if ((document.SRSTAFFASSIGN.STAFF_COMMENTS.value == "" && document.SRSTAFFASSIGN.STAFF_COMPLETEDCOMMENTSID.selectedIndex == "0")
		 && (document.SRSTAFFASSIGN.STAFF_COMPLETEDSR.value == "YES" || document.SRSTAFFASSIGN.STAFF_COMPLETEDSR.value == "VOIDED")) {
			alertuser ("You must fill out one of the comment fields, fill out the Staff Time Worked field and set the Completed SR? dropdown to YES or VOIDED when you click the MODIFY TO COMPLETION Button.");
			document.SRSTAFFASSIGN.STAFF_COMMENTS.focus();
			return false;
		}
		
		if ((document.SRSTAFFASSIGN.STAFF_COMMENTS.value != null || document.SRSTAFFASSIGN.STAFF_COMPLETEDCOMMENTSID.selectedIndex > "0")
		 && (document.SRSTAFFASSIGN.STAFF_TIME_WORKED.value == "00.0" && document.SRSTAFFASSIGN.STAFF_COMPLETEDSR.value == "YES")) {
			alertuser ("You must enter a Staff Time Worked when Completed SR field is YES and you click the MODIFY TO COMPLETION Button.");
			document.SRSTAFFASSIGN.STAFF_TIME_WORKED.focus();
			return false;
		}
		
		if ((document.SRSTAFFASSIGN.STAFF_COMMENTS != null || document.SRSTAFFASSIGN.STAFF_COMPLETEDCOMMENTSID.selectedIndex > "0")
		 && (document.SRSTAFFASSIGN.STAFF_TIME_WORKED.value != "00.0" && document.SRSTAFFASSIGN.STAFF_COMPLETEDSR.value == "NO")) {
			alertuser ("You must set the Completed SR? dropdown to YES or VOIDED when you click the MODIFY TO COMPLETION Button.");
			document.SRSTAFFASSIGN.STAFF_COMPLETEDSR.focus();
			return false;
		}
		
		document.SRSTAFFASSIGN.PROCESSSRSTAFFASSIGNS.value = "MODIFY TO COMPLETION";
		return true;
		
	}

	
	function setDeleteStaff() {
		document.SRSTAFFASSIGN.PROCESSSRSTAFFASSIGNS.value = "DELETE STAFF";
		return true;
	}

//
</script>
<script language="JavaScript" src="../calendar_us.js"></script>
<!--Script ends here -->

</head>

<cfoutput>
<cfif NOT IsDefined("URL.LOOKUPSRSTAFFASSIGN") AND URL.PROCESS EQ "MODIFYDELETE">
	<cfset CURSORFIELD = "document.LOOKUP.SRSTAFF_ASSIGNID.focus()">
<cfelseif #Client.SecurityFlag# EQ "Yes">
	<cfset CURSORFIELD = "document.SRSTAFFASSIGN.STAFF_ASSIGNEDID[1].focus()">
<cfelseif IsDefined ('URL.NEXTGROUP')>
	<cfset CURSORFIELD = "document.SRSTAFFASSIGN.NEXT_ASSIGN_GROUPID.focus()">
<cfelse>
	<cfset CURSORFIELD = "document.SRSTAFFASSIGN.STAFF_COMMENTS.focus()">
</cfif>
<body onLoad="#CURSORFIELD#">.

<cfinclude template="/include/coldfusion/formheader.cfm">

<cfif NOT IsDefined('URL.PROCESS')>
	<cfset URL.PROCESS = "ADD">
</cfif>

<cfif IsDefined('URL.SRID')>
	<cfset FORM.SRID = #URL.SRID#>
	<cfcookie name="SRID" secure="NO" value="#FORM.SRID#">
</cfif>

<cfif IsDefined('URL.GROUPID')>
	<cfset FORM.GROUPID = #URL.GROUPID#>
</cfif>

<cfset NORECORDSFOUND = "NO">
<cfset FOUNDINSR = "NO">
<cfset FOUNDINASSIGN = "NO">

<!--- 
*************************************************************************
* The following code is used by all Processes for SR Staff Assignments. *
*************************************************************************
 --->

<cfquery name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</cfquery>

<cfquery name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
     SELECT	GROUPID, GROUPNAME
     FROM		GROUPASSIGNED
     ORDER BY	GROUPNAME
</cfquery>

<cfquery name="LookupServiceRequest" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
			TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SDINIT.INITIALS, SR.REQUESTERID, SR.ALTERNATE_CONTACTID,
			SR.PROBLEM_CATEGORYID, PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY, PROBSUBCAT.SUBCATEGORYNAME, 
			P.PRIORITYNAME, SR.GROUPASSIGNEDID, GA.GROUPNAME, SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETED
	FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY P,
			GROUPASSIGNED GA
	WHERE	SR.SRID > 0 AND
		<CFIF IsDefined ('FORM.SERVICEREQUESTNUMBER')>
			SR.SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#FORM.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
		<CFELSEIF IsDefined('FORM.GROUPID') AND #FORM.GROUPID# GT 0>
			SR.GROUPASSIGNEDID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
			SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
		<CFELSEIF IsDefined('FORM.SRID') AND #FORM.SRID# GT 0>
			SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
		</CFIF>
			SR.GROUPASSIGNEDID = GA.GROUPID AND
			SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
			SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
			SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
			SR.PRIORITYID = P.PRIORITYID AND
               SR.SRCOMPLETED = 'NO'
	ORDER BY	SR.SRID
</cfquery>

<cfif #LookupServiceRequest.RecordCount# EQ 0>
	<cfset NORECORDSFOUND = "YES">
<cfelse>
	<cfset FOUNDINSR = "YES">
     <cfif NOT (IsDefined('FORM.SRID'))>
     	<cfset FORM.SRID = #LookupServiceRequest.SRID#>
     </cfif>	
	<cfcookie name="SRID" secure="NO" value="#LookupServiceRequest.SRID#">
</cfif>

<cfif IsDefined('FORM.GROUPID') AND #FORM.GROUPID# GT 0>
 
     <cfquery name="LookupSRStaffGroupAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SRSTAFF_ASSIGNID, SRID, STAFF_ASSIGNEDID, STAFF_DATEASSIGNED, STAFF_TIME_WORKED, STAFF_COMMENTS, 
                    NEXT_ASSIGNMENT, NEXT_ASSIGNMENT_GROUPID, NEXT_ASSIGNMENT_REASON, STAFF_COMPLETEDSR, STAFF_COMPLETEDDATE, 
                    STAFF_COMPLETEDCOMMENTSID
          FROM		SRSTAFFASSIGNMENTS
          WHERE	SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
			 <CFIF URL.PROCESS EQ "ADD">
          		STAFF_ASSIGNEDID = 0 AND
                	NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC">
                <CFELSEIF URL.PROCESS EQ "MODIFYDELETE">
                	(STAFF_ASSIGNEDID > 0 AND
                    NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC">)
                </CFIF>             
          ORDER BY	STAFF_ASSIGNEDID
     </cfquery>
     
     <cfif #LookupServiceRequest.RecordCount# EQ 0 AND #LookupSRStaffGroupAssignments.RecordCount# EQ 0>
		<cfset NORECORDSFOUND = "YES">
     <cfelse>
     	<cfset NORECORDSFOUND = "NO">
     </cfif>
     
     <cfif #LookupSRStaffGroupAssignments.RecordCount# GT 0>
          <cfset FOUNDINASSIGN = "YES">
     </cfif>

</cfif>

<cfif NORECORDSFOUND EQ "YES">
	<script language="JavaScript">
		<!-- 
			alert("SR Record and Unassigned Staff Assignment Record Not Found");
		--> 
	</script>
	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=#URL.PROCESS#" />
	<cfexit>
</cfif>


<!--- 
*******************************************************************
* The following code is the ADD Process for SR Staff Assignments. *
*******************************************************************
 --->
 
<cfif (URL.PROCESS EQ 'ADD') AND (#Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes")>

	 <cfif #LookupServiceRequest.RecordCount# EQ 0>
      
      	<cfquery name="LookupServiceRequest" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
                         TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SDINIT.INITIALS, SR.REQUESTERID, SR.ALTERNATE_CONTACTID,
                         SR.PROBLEM_CATEGORYID, PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY, PROBSUBCAT.SUBCATEGORYNAME, 
                         P.PRIORITYNAME, SR.GROUPASSIGNEDID, GA.GROUPNAME, SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETED
               FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY P,
                         GROUPASSIGNED GA
               WHERE	SR.SRID > 0 AND
                         SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SR.GROUPASSIGNEDID = GA.GROUPID AND
                         SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
                         SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
                         SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
                         SR.PRIORITYID = P.PRIORITYID AND
                         SR.SRCOMPLETED = 'NO'
               ORDER BY	SR.SRID
          </cfquery>
      
     </cfif>

 	<cfquery name="ListRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER, 
				CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#LookupServiceRequest.REQUESTERID#" cfsqltype="CF_SQL_VARCHAR"> AND
				CUST.UNITID = UNITS.UNITID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</cfquery>

	<cfquery name="ListAltContacts" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
				CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#LookupServiceRequest.ALTERNATE_CONTACTID#" cfsqltype="CF_SQL_VARCHAR"> AND 
				CUST.UNITID = UNITS.UNITID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</cfquery>
     
	<cfquery name="LookupSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
		FROM		SREQUIPLOOKUP
		WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#LookupServiceRequest.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>

	<cfif LookupSREquipLookup.RecordCount GT 0>
		<cfquery name="LookupHardware" datasource="#application.type#HARDWARE">
			SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTTYPEID,
					EQT.EQUIPMENTTYPE, HI.OWNINGORGID, HI.MODELNAMEID, MNAMEL.MODELNAME, HI.MODELNUMBERID, MNUML.MODELNUMBER,
					HI.CUSTOMERID, CUST.FULLNAME, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER, HW.WARRANTYEXPIRATIONDATE AS WARDATE
			FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUML, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
			WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#LookupSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
					HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
					HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
					HI.MODELNUMBERID = MNUML.MODELNUMBERID AND
					HI.CUSTOMERID = CUST.CUSTOMERID AND
					HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
					HI.BARCODENUMBER = HW.BARCODENUMBER
			ORDER BY	BARCODENUMBER
		</cfquery>
          
           <cfquery name="LookupHardwareAttachedTo" datasource="#application.type#HARDWARE">
                    SELECT	ATTACHEDTOID, BARCODENUMBER, ATTACHEDTO
                    FROM		HARDWAREATTACHEDTO
                    WHERE	ATTACHEDTO = <CFQUERYPARAM value="#LookupHardware.HARDWAREID#" cfsqltype="CF_SQL_VARCHAR">
               </cfquery>

	</cfif>

	<cfquery name="ListOtherStaff" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, GA.GROUPID, GA.GROUPNAME AS WORKGROUPNAME,
                    CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS, SRSA.NEXT_ASSIGNMENT, WGA.ACTIVE,
                    SRSA.NEXT_ASSIGNMENT_GROUPID, NGA.GROUPID, NGA.GROUPNAME AS NEXTGROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR,
                    SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID
          FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, GROUPASSIGNED NGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	SRSA.SRID = <CFQUERYPARAM value="#LookupServiceRequest.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
                    SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                    SRSA.STAFF_ASSIGNEDID > 0 AND
                    WGA.GROUPID = GA.GROUPID AND
                    SRSA.NEXT_ASSIGNMENT_GROUPID = NGA.GROUPID AND
                    WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                    WGA.ACTIVE = 'YES'
          ORDER BY	CUST.FULLNAME
     </cfquery>
 
	<cfif IsDefined('FORM.GROUPID') AND #FOUNDINASSIGN# EQ "YES">
  
     	<cfquery name="LookupStaffUnAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
               SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER, WGA.ACTIVE,
                         CUST.FULLNAME || ' - ' || WGA.GROUPORDER  || ' - ' ||  GA.GROUPNAME AS STAFFGROUP
               FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
               WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                         WGA.GROUPID = GA.GROUPID AND
                         WGA.GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    <CFIF ListOtherStaff.RecordCount GT 0>
                         NOT WGA.WORKGROUPASSIGNSID IN (#ValueList(ListOtherStaff.STAFF_ASSIGNEDID)#) AND 
                    </CFIF>
                    	WGA.ACTIVE = 'YES'
               ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
          </cfquery>
   
	<cfelseif #FOUNDINSR# EQ "YES">

     	<cfquery name="LookupStaffUnAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
               SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER, WGA.ACTIVE,
                         CUST.FULLNAME || ' - ' || WGA.GROUPORDER  || ' - ' ||  GA.GROUPNAME AS STAFFGROUP
               FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
               WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                         WGA.GROUPID = GA.GROUPID AND
                         WGA.GROUPID = <CFQUERYPARAM value="#LookupServiceRequest.GROUPASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    <CFIF ListOtherStaff.RecordCount GT 0>
                         NOT WGA.WORKGROUPASSIGNSID IN (#ValueList(ListOtherStaff.STAFF_ASSIGNEDID)#) AND 
                    </CFIF>
                    	WGA.ACTIVE = 'YES'
               ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
          </cfquery>

     </cfif>
     
     <cfif LookupStaffUnAssigned.RecordCount GT 0>

          <cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
               SELECT	MAX(SRSTAFF_ASSIGNID) AS MAX_ID
               FROM		SRSTAFFASSIGNMENTS
          </cfquery>
          <cfset FORM.SRSTAFF_ASSIGNID = #val(GetMaxUniqueID.MAX_ID+1)#>
          <cfcookie name="SRSTAFF_ASSIGNID" secure="NO" value="#FORM.SRSTAFF_ASSIGNID#">
          <cfquery name="AddSRStaffAssignmentsID" datasource="#application.type#SERVICEREQUESTS">
               INSERT INTO	SRSTAFFASSIGNMENTS (SRSTAFF_ASSIGNID, SRID)
               VALUES		(#val(Cookie.SRSTAFF_ASSIGNID)#, #val(LookupServiceRequest.SRID)#)
          </cfquery>

      </cfif>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Add SR Staff Assignments</h1></td>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<th align="center">
				<h4>*Red fields marked with asterisks are required!</h4>
			</th>
		</tr>
		<tr>
		<cfif LookupStaffUnAssigned.RecordCount GT 0>
			<th align="center">
				SR Staff Assignment Key &nbsp; = &nbsp; #FORM.SRSTAFF_ASSIGNID#
			</th>
		<cfelse>
          	<th align="center">
				<h4><strong>All The Staff From This Group Have Been Assigned!</strong></h4>
			</th>       
          </cfif>
		</tr>
	</table>
	<br clear="left" />

	<table align="left" width="100%" border="0">
		<tr>
          <cfif LookupStaffUnAssigned.RecordCount GT 0>
<cfform action="/#application.type#apps/servicerequests/processsrstaffassigninfo.cfm" method="POST">
			<td align="left" colspan="2">
               	<input type="hidden" name="SRSTAFF_ASSIGNID" value="#Cookie.SRSTAFF_ASSIGNID#" />
                <cfif (IsDefined('session.lookupgroup'))>
                    <input type="hidden" name="GROUPID" value="#session.lookupgroup#" />
                </cfif>
                    <input type="hidden" name="PROCESSSRSTAFFASSIGNS" value="CANCELADD" />
				<input type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><br><br>
			</td>
</cfform>
		<cfelse>
<cfform action="/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=ADD" method="POST">
			<td align="left" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</cfif>        
		</tr>
     </table>

<cfform name="SRSTAFFASSIGN" onsubmit="return validateAddReqFields();" action="/#application.type#apps/servicerequests/processsrstaffassigninfo.cfm" method="POST" enablecab="Yes">
	<br><br><br><br><br>
     <fieldset>
     <legend>Service Request</legend>
	<table width="100%" align="LEFT">
		<tr>
			<th align="left" width="33%">SR</th>
			<th align="left" width="33%">Creation Date</th>
			<th align="left" width="33%">Creation Time</th>
		</tr>
		<tr>
			<td align="left" width="33%">
               	<input type="hidden" name="SERVICEREQUESTNUMBER" value="#LookupServiceRequest.SERVICEREQUESTNUMBER#" />
               	<input type="hidden" name="SRID" value="#Cookie.SRID#" />
				#LookupServiceRequest.SERVICEREQUESTNUMBER#
			</td>
			<td align="left" width="33%">#DateFormat(LookupServiceRequest.CREATIONDATE, "mm/dd/yyyy")#</td>
			<td align="left" width="33%">#TimeFormat(LookupServiceRequest.CREATIONTIME, "hh:mm:ss tt")#</td>
		</tr>
		<tr>
			<th align="left" width="33%">Requester</th>
			<th align="left" width="33%">R Unit</th>
			<th align="left" width="33%">R Phone</th>
		</tr>
		<tr>
			<td align="left" width="33%">
				<input type="hidden" name="REQUESTER" value="#ListRequesters.FULLNAME#" />
				#ListRequesters.FULLNAME#
			</td>
			<td align="left" width="33%">#ListRequesters.UNITNAME#</td>
			<td align="left" width="33%">#ListRequesters.CAMPUSPHONE#</td>
		</tr>
		<tr>
			<th align="left" width="33%">Service Desk Initials</th>
			<th align="left" width="33%">R Room</th>
			<th align="left" width="33%">R E-Mail</th>
		</tr>
		<tr>
			<td>#LookupServiceRequest.INITIALS#</td>
			<td align="left" width="33%">#ListRequesters.ROOMNUMBER#</td>
			<td align="left" width="33%"><a href="MAILTO:#ListRequesters.EMAIL#">#ListRequesters.EMAIL#</a></td>
		</tr>
	<cfif #LookupServiceRequest.ALTERNATE_CONTACTID# GT 0>
		<tr>
			<th align="left" width="33%">Alt Contact</th>
			<th align="left" width="33%">AC Unit</th>
			<th align="left" width="33%">AC Phone</th>
		</tr>
		<tr>
			<td align="left" width="33%">#ListAltContacts.FULLNAME#</td>
			<td align="left" width="33%">#ListAltContacts.UNITNAME#</td>
			<td align="left" width="33%">#ListAltContacts.CAMPUSPHONE#</td>
		</tr>
		<tr>
			<th align="left" width="33%">&nbsp;&nbsp;</th>
			<th align="left" width="33%">AC Room</th>
			<th align="left" width="33%">AC E-Mail</th>
		</tr>
		<tr>
			<td align="left" width="33%">&nbsp;&nbsp;</td>
			<td align="left" width="33%">#ListAltContacts.ROOMNUMBER#</td>
			<td align="left" width="33%"><a href="MAILTO:#ListAltContacts.EMAIL#">#ListAltContacts.EMAIL#</a></td>
		</tr>
	</cfif>
		<tr>
			<th align="left" width="33%">Problem Category</th>
			<th align="left" width="33%">Sub-Category</th>
			<th align="left" width="33%">Priority</th>
		</tr>
		<tr>
			<td align="left" width="33%" valign="TOP">
               	<input type="hidden" name="PROBCATEGORY" value="#LookupServiceRequest.PROBCATEGORY#" />
				#LookupServiceRequest.PROBCATEGORY#
			</td>
			<td align="left" width="33%" valign="TOP">
               	<input type="hidden" name="SUBCATEGORY" value="#LookupServiceRequest.SUBCATEGORYNAME#" />
               	#LookupServiceRequest.SUBCATEGORYNAME#
               </td>
               <td align="left" width="33%" valign="TOP">
               	<input type="hidden" name="PRIORITYNAME" value="#LookupServiceRequest.PRIORITYNAME#" />
               	#LookupServiceRequest.PRIORITYNAME#
               </td>
          </tr>
          <tr>
			<th align="left" colspan="3">Problem Description</th>
		</tr>
		<tr>
			<td align="left" colspan="3">#LookupServiceRequest.PROBLEM_DESCRIPTION#</td>
		</tr>
	</table>
	</fieldset>
	<br />
	<cfif IsDefined('LookupHardware.RecordCount') AND #LookupHardware.RecordCount# GT 0>
     <fieldset>
	<legend>Associated Equipment</legend>
	<table width="100%" align="LEFT">
		<tr>
			<th align="left" width="33%">Bar Code Number</th>
			<th align="left" width="33%">Equipment Type</th>
			<th align="left" width="33%">State/Found Number</th>
		</tr>
		<tr>
			<td align="left" width="33%">#LookupHardware.BARCODENUMBER#</td>
			<td align="left" width="33%">#LookupHardware.EQUIPMENTTYPE#</td>
			<td align="left" width="33%">#LookupHardware.STATEFOUNDNUMBER#</td>
		</tr>
		<tr>
			<th align="left" width="33%">Model</th>
			<th align="left" width="33%">Model Number</th>
			<th align="left" width="33%">Division Number</th>
		</tr>
		<tr>
			<td align="left" width="33%">#LookupHardware.MODELNAME#</td>
			<td align="left" width="33%">#LookupHardware.MODELNUMBER#</td>
			<td align="left" width="33%">#LookupHardware.DIVISIONNUMBER#</td>
		</tr>
 		<tr>
			<th align="left" width="33%">Currently Assigned</th>
			<th align="left" width="33%">Equipment Room Number</th>
			<th align="left" width="33%">Serial</th>
		</tr>
		<tr>
			<td align="left" width="33%">#LookupHardware.FULLNAME#</td>
			<td align="left" width="33%">#LookupHardware.ROOMNUMBER#</td>
			<td align="left" width="33%">#LookupHardware.SERIALNUMBER#</td>
		</tr>
         <tr>
			<th align="left" width="33%">Warranty Expiration Date</th>
               <th align="left" width="33%">Equipment Attached</th>
               <th align="left" width="33%">&nbsp;&nbsp;</th>
          </tr>     
		<tr>
			<td align="left" width="33%" valign="top">#DateFormat(LookupHardware.WARDATE, "mm/dd/yyyy")#</td>
               <td align="left" width="33%">
                    <cfloop query="LookupHardwareAttachedTo">
                         #BARCODENUMBER#<br>
                    </cfloop>
               </td>
               <td align="left" width="33%">&nbsp;&nbsp;</td>
          </tr>
     </table>
	</fieldset>
	<br />
	</cfif> 
     <br />
     <fieldset>
     <legend>Group/Staff Assignments</legend>
     <table width="100%" border="0">
		<tr>
          <cfif IsDefined('FORM.GROUPID') AND #FOUNDINASSIGN# EQ "YES">
			<th align="left" width="33%" valign="BOTTOM">Next Group Assigned</th>
          <cfelse>
          	<th align="left" width="33%" valign="BOTTOM">Primary Group Assigned</th>
          </cfif>
			<th align="left" width="33%" valign="BOTTOM"><h4><label for="STAFF_ASSIGNEDID">*Staff Assigned</label></h4></th>
			<th align="left" width="33%" valign="BOTTOM"><h4><label for="STAFF_DATEASSIGNED">*Date Staff Assigned</label></h4></th>			
		</tr>
		<tr>
			<td align="left" width="33%" valign="TOP">
               	<input type="hidden" name="NEXT_ASSIGNMENT" value="#FOUNDINASSIGN#" />
               	#LookupStaffUnAssigned.GROUPNAME#
               </td>
          <cfif LookupStaffUnAssigned.RecordCount EQ 0>
          	<td align="left" width="33%" valign="top">
               	<input type="hidden" name="WORKGROUPASSIGNSID" value="0" />
				<strong>All The Staff From This Group Have Been Assigned!</strong>
			<td align="left" width="33%">&nbsp;&nbsp;</td>
          <cfelse>
			<td align="left" width="33%" valign="TOP">
               	<input type="hidden" name="SRSTAFF_ASSIGNID" value="#Cookie.SRSTAFF_ASSIGNID#" />
                    <cfloop query = "LookupStaffUnAssigned">
                         <input type="Checkbox" name="STAFF_ASSIGNEDID" id="STAFF_ASSIGNEDID" value="#WORKGROUPASSIGNSID#" tabindex="2">#FULLNAME#<br>
                    </cfloop>
			</td>
			<td align="left" width="33%" valign="TOP">
				<cfset FORM.STAFF_DATEASSIGNED = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
				<cfinput type="Text" name="STAFF_DATEASSIGNED" id="STAFF_DATEASSIGNED" value="#DateFormat(FORM.STAFF_DATEASSIGNED, "mm/dd/yyyy")#" align="LEFT" required="No" size="15" tabindex="3">
                    <script language="JavaScript">
					new tcal ({'formname': 'SRSTAFFASSIGN','controlname': 'STAFF_DATEASSIGNED'});

				</script>
			</td>
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

     <cfif ListOtherStaff.RecordCount EQ 0>
          <tr>
               <td align="left" valign="top" width="25%">
                    <strong>No Other Staff Have Been Assigned!</strong>
               </td>
               <td align="left" valign="top" width="25%">&nbsp;&nbsp;</td>
               <td align="left" valign="top" width="25%">&nbsp;&nbsp;</td>
               <td align="left" valign="top" width="25%">&nbsp;&nbsp;</td>
          </tr>
     <cfelse>
          <cfloop query="ListOtherStaff">
          
           <tr>
               <td align="left" valign="top" width="25%">
                    #ListOtherStaff.FULLNAME#
               </td>

               <td align="left" valign="top" width="25%">
               <cfif #ListOtherStaff.STAFF_ASSIGNEDID# GT 0>
                    #ListOtherStaff.WORKGROUPNAME#
               <cfelse>
                    #ListOtherStaff.NEXTGROUPNAME#
               </cfif>
               </td>
          
               <cfquery name="LookupCompletedComments" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	COMPLETED_COMMENTSID, COMPLETED_COMMENTS
                    FROM		COMPLETEDCOMMENTS
                    WHERE	COMPLETED_COMMENTSID = <CFQUERYPARAM value="#ListOtherStaff.STAFF_COMPLETEDCOMMENTSID#" cfsqltype="CF_SQL_NUMERIC">
                    ORDER BY	COMPLETED_COMMENTS
               </cfquery>
          
               <td align="left" valign="top" width="25%">
               <cfif #ListOtherStaff.STAFF_COMMENTS# EQ "" AND #ListOtherStaff.STAFF_COMPLETEDCOMMENTSID# GT 0>
                    #LookupCompletedComments.COMPLETED_COMMENTS#
               <cfelse>
                    #ListOtherStaff.STAFF_COMMENTS#
               </cfif>
               </td>
               <td align="left" valign="top" width="25%">
                    #ListOtherStaff.STAFF_COMPLETEDSR#
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
               	<input type="hidden" name="PROCESSSRSTAFFASSIGNS" value="ADD" />
               	<input type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
          	</td>
          <cfelse>
          	<td align="left" width="33%">&nbsp;&nbsp;</td>
     	</cfif>
               <td align="left" width="33%">
                   <input type="image" src="/images/buttonAddNextGrp.jpg" value="Add Next Group" alt="Add Next Group" onClick="window.open('/#application.type#apps/servicerequests/srnextrefergroupchoice.cfm?SRID=#Cookie.SRID#&PROCESS=ADD&STAFFLOOP=YES',
                          				  'Add Next Group','alwaysRaised=yes,dependent=no,width=800,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="5" />
               </td>
               <td align="left" width="33%">&nbsp;&nbsp;</td>
		</tr>
     </table>
     </fieldset>

</cfform>	
	<br />
     <table width="100%" align="LEFT">
		<tr>
          <cfif LookupStaffUnAssigned.RecordCount GT 0>
<cfform action="/#application.type#apps/servicerequests/processsrstaffassigninfo.cfm" method="POST">
			<td align="left" colspan="2">
               	<input type="hidden" name="SRSTAFF_ASSIGNID" value="#Cookie.SRSTAFF_ASSIGNID#" />
               <cfif (IsDefined('session.lookupgroup'))>
                    <input type="hidden" name="GROUPID" value="#session.lookupgroup#" />
               </cfif>
                    <input type="hidden" name="PROCESSSRSTAFFASSIGNS" value="CANCELADD" />
				<input type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="6" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><br><br>
			</td>
</cfform>
		<cfelse>
<cfform action="/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=ADD" method="POST">
			<td align="left" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><br><br>
			</td>
</cfform>
		</cfif>
		</tr>
		<tr>
			<td align="left" colspan="5"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
     
     <cfexit>

<cfelse>

<!--- 
**********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting SR Staff Assignments. *
**********************************************************************************************
 --->

	<cfif NOT IsDefined('URL.LOOKUPSRSTAFFASSIGN')>
		<table width="100%" align="center" border="3">
			<tr align="center">
				<td align="center"><h1>SR Staff Assignments Lookup</h1></td>
			</tr>
		</table>

		<table width="100%" align="center" border="0">
			<tr>
				<th align="center"><h4>*Red fields marked with asterisks are required!</h4></th>
			</tr>
		</table>
		<br clear="left" />

		<cfquery name="LookupSRAssignedStaff" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, WGA.WORKGROUPASSIGNSID,
               		WGA.GROUPID, GA.GROUPID, GA.GROUPNAME, WGA.STAFFCUSTOMERID, SR.SRCOMPLETED, SRSA.SRID || ',' || SRSA.STAFF_ASSIGNEDID AS LOOKUPASSIGNKEYS1, 
                         CUST.FULLNAME || ' - ' || GA.GROUPNAME || ' - ' || SR.SERVICEREQUESTNUMBER AS LOOKUPSTAFF1
			FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE     (SRSA.SRID = SR.SRID AND
               		SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.GROUPID = GA.GROUPID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                         SRSA.STAFF_ASSIGNEDID > 0) AND (
               		
		<CFIF IsDefined('FORM.SERVICEREQUESTNUMBER')>
					SRSA.SRID = <CFQUERYPARAM value="#LookupServiceRequest.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
			<CFIF IsDefined ('FORM.NEXT_ASSIGNMENT') AND #FORM.NEXT_ASSIGNMENT# EQ 'YES'>
					SRSA.NEXT_ASSIGNMENT = 'YES' AND
			</CFIF>
          <CFELSEIF IsDefined('FORM.GROUPID')>
          			SRSA.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
			<CFIF IsDefined ('FORM.NEXT_ASSIGNMENT') AND #FORM.NEXT_ASSIGNMENT# EQ 'YES'>
					SRSA.NEXT_ASSIGNMENT = 'YES' AND
			</CFIF>                   
		<CFELSEIF IsDefined('FORM.STAFFCUSTOMERID')>
					WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.STAFFCUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
			<CFIF IsDefined('FORM.NEXT_ASSIGNMENT') AND #FORM.NEXT_ASSIGNMENT# EQ 'YES'>
					SRSA.NEXT_ASSIGNMENT = 'YES' AND
			</CFIF>
		</CFIF>
          			SR.SRCOMPLETED = 'NO')
			ORDER BY	LOOKUPSTAFF1
		</cfquery>
          
          <cfquery name="LookupSRUnAssignedStaff" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, NGA.GROUPID, NGA.GROUPNAME, 
               		WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SR.SRCOMPLETED, SRSA.SRID || ',' || SRSA.NEXT_ASSIGNMENT_GROUPID AS LOOKUPASSIGNKEYS2,
                         WGA.ACTIVE, CUST.FULLNAME || ' - ' || NGA.GROUPNAME || ' - ' || SR.SERVICEREQUESTNUMBER AS LOOKUPSTAFF2
			FROM		SRSTAFFASSIGNMENTS SRSA, GROUPASSIGNED NGA, SERVICEREQUESTS SR, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE     (SRSA.SRID = SR.SRID AND
               		SRSA.NEXT_ASSIGNMENT_GROUPID = NGA.GROUPID AND
               		SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                         (NOT WGA.ACTIVE = 'NO') AND
                         SRSA.STAFF_ASSIGNEDID = 0) AND (
               		
		<CFIF IsDefined('FORM.SERVICEREQUESTNUMBER')>
					SRSA.SRID = <CFQUERYPARAM value="#LookupServiceRequest.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
			<CFIF IsDefined ('FORM.NEXT_ASSIGNMENT') AND #FORM.NEXT_ASSIGNMENT# EQ 'YES'>
					SRSA.NEXT_ASSIGNMENT = 'YES' AND
			</CFIF>
          <CFELSEIF IsDefined('FORM.GROUPID')>
          			SRSA.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
			<CFIF IsDefined ('FORM.NEXT_ASSIGNMENT') AND #FORM.NEXT_ASSIGNMENT# EQ 'YES'>
					SRSA.NEXT_ASSIGNMENT = 'YES' AND
			</CFIF>                   
		<CFELSEIF IsDefined('FORM.STAFFCUSTOMERID')>
					WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.STAFFCUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
			<CFIF IsDefined('FORM.NEXT_ASSIGNMENT') AND #FORM.NEXT_ASSIGNMENT# EQ 'YES'>
					SRSA.NEXT_ASSIGNMENT = 'YES' AND
			</CFIF>
		</CFIF>
          			SR.SRCOMPLETED = 'NO')
			ORDER BY	LOOKUPSTAFF2
		</cfquery>

		<cfif #LookupSRAssignedStaff.RecordCount# EQ 0 AND #LookupSRUnAssignedStaff.RecordCount# EQ 0>
          
          	<cfif NOT IsDefined('FORM.SERVICEREQUESTNUMBER')>
               	<cfset FORM.SERVICEREQUESTNUMBER = #LookupServiceRequest.SERVICEREQUESTNUMBER#>
               </cfif>
          
          	<cfquery name="LookupSRInfo" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED
                    FROM		SERVICEREQUESTS SR
                    WHERE	SR.SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#FORM.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR"> 
                    ORDER BY	SR.SERVICEREQUESTNUMBER
               </cfquery>
               
               <cfif #LookupSRInfo.SRCOMPLETED# EQ "YES">
               	<script language="JavaScript">
					<!-- 
						alert('Service Request #LookupSRInfo.SERVICEREQUESTNUMBER# was completed on #DateFormat(LookupSRInfo.SRCOMPLETEDDATE, "mm/dd/yyyy")#.  No further processing is allowed.');
					--> 
				</script>
				<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
				<cfexit>
			</cfif>
          
			<cfif IsDefined('FORM.SRID') OR IsDefined('FORM.GROUPID')>
               	<cfif (#Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes")>
					<script language="JavaScript">
                              <!-- 
                                   alert("SR Staff Assignment Not Found! Transferring to the SR Staff Assignment Add Process.");
                              --> 
                         </script>
                       <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=ADD&SRID=#LookupSRInfo.SRID#" />
                    	<cfexit>
				<cfelse>
                    	<script language="JavaScript">
                              <!-- 
                                   alert("SR Staff Assignment Not Found! You do NOT have sufficient Security Access to go to the SR Staff Assignment Add Process.");
                              --> 
                         </script>
                         <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
                    	<cfexit> 
                    </cfif>                   
			<cfelse>
				<script language="JavaScript">
					<!-- 
						alert("Staff Member has no Assignments! Please select another Staff Member.");
					--> 
				</script>
				<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
				<cfexit>
			</cfif>
		</cfif>
          
          <cfif #LookupSRAssignedStaff.RecordCount# EQ 1 AND #LookupSRUnAssignedStaff.RecordCount# EQ 0>       
          	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=MODIFYDELETE&LOOKUPSRSTAFFASSIGN=FOUND&SRSTAFF_ASSIGNID=#LookupSRAssignedStaff.SRSTAFF_ASSIGNID#" />
          	<cfexit>
          </cfif>
          
          <cfif #LookupSRAssignedStaff.RecordCount# EQ 0 AND #LookupSRUnAssignedStaff.RecordCount# EQ 1>
          	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=MODIFYDELETE&LOOKUPSRSTAFFASSIGN=FOUND&SRSTAFF_ASSIGNID=#LookupSRUnAssignedStaff.SRSTAFF_ASSIGNID#" />
          	<cfexit>
          </cfif>
          
		<table align="left" width="100%" border="0">
			<tr>
<cfform action="/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" method="POST">
				<td align="left" colspan="2">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</td>
</cfform>
			</tr>
<cfform name="LOOKUP" onsubmit="return validateLookupReqFields();" action="/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPSRSTAFFASSIGN=FOUND" method="POST">
			<tr>
				<th align="left" nowrap>
                    	<h4><label for="STAFF_ASSIGNEDID">*SR Assigned Staff:</label></h4>
                    </th>
				<th align="left" nowrap>
                    	<h4><label for="GROUP_ASSIGNEDID">*SR UnAssigned Staff:</label></h4>
                    </th>
			</tr>
               <tr>
				<td align="left" width="70%">
                    	<input type="hidden" name="SRID" value="#LookupServiceRequest.SRID#" />
                    	<cfselect name="STAFF_ASSIGNEDID" id="STAFF_ASSIGNEDID" size="1" required="No" tabindex="2">
                              <option value="0">Select a Staff Member, Group and SR</option>
                              <cfloop query="LookupSRAssignedStaff">
                                   <option value="#LOOKUPASSIGNKEYS1#">#LOOKUPSTAFF1#</option>
                              </cfloop>  
                         </cfselect>
				</td>
				<td align="left" width="70%">
                    	<cfselect name="GROUP_ASSIGNEDID" id="GROUP_ASSIGNEDID" size="1" required="No" tabindex="3">
                              <option value="-1">Select a Staff Member, Group and SR</option>
                              <cfloop query="LookupSRUnAssignedStaff">
                                   <option value="#LOOKUPASSIGNKEYS2#">#LOOKUPSTAFF2#</option>
                              </cfloop>  
                         </cfselect>
				</td>
			</tr>
			<tr>
				<td align="left" colspan="2">&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td align="left" colspan="2">
                    	<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
                    </td>
			</tr>
</cfform>
			<tr>
<cfform action="/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" method="POST">
				<td align="left" colspan="2">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</td>
</cfform>
			</tr>
			<tr>
				<td align="left" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
			</tr>
		</table>
	
	<cfelse>

<!--- 
************************************************************************************
* The following code is the Modify/Void/Delete Processes for SR Staff Assignments. *
************************************************************************************
 --->
 
<!---  
	If this program was called from claimednotcomplkuplist.cfm program, then the LIST_LOOKUP parameter must be passed to the processsrstaffassigninfo.cfm
     so control will return to the claimednotcomplkuplist.cfm program.
 --->

 
		<cfif IsDefined('URL.LIST_LOOKUP')>
          	<cfif IsDefined('URL.LKUPSTAFFCUSTOMERID') >
                  <cfset FORM.LKUPSTAFFCUSTOMERID = #URL.LKUPSTAFFCUSTOMERID#>                    
               </cfif>     
               	
			<cfset CLIENT.LIST_LOOKUP = "#URL.LIST_LOOKUP#">
               <cfset PROCESSPROGRAMNAME = "processsrstaffassigninfo.cfm?LIST_LOOKUP=#CLIENT.LIST_LOOKUP#">
               <cfset REPORTTITLE = "Modify SR Comments - List Choice">
               <cfset RETURNPGM = "/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LOOKUPSTAFFID=FOUND&LIST_LOOKUP=#URL.LIST_LOOKUP#&LKUPSTAFFCUSTOMERID=#FORM.LKUPSTAFFCUSTOMERID#">
          <cfelse>
          	<cfset CLIENT.LIST_LOOKUP = "NO">
               <cfset PROCESSPROGRAMNAME = "processsrstaffassigninfo.cfm">
               <cfset REPORTTITLE = "Modify SR Comments - Single">
               <cfset RETURNPGM = "/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=#URL.PROCESS#">
          </cfif>

          <cfif IsDefined('FORM.STAFF_ASSIGNEDID') AND FIND(',', #FORM.STAFF_ASSIGNEDID#, 1) NEQ 0>
          	<cfset FORM.SRID = #LISTFIRST(FORM.STAFF_ASSIGNEDID)#>
          	<cfset FORM.STAFF_ASSIGNEDID = #LISTLAST(FORM.STAFF_ASSIGNEDID)#>
          <cfelseif IsDefined('FORM.GROUP_ASSIGNEDID') AND FIND(',', #FORM.GROUP_ASSIGNEDID#, 1) NEQ 0>
          	<cfset FORM.SRID = #LISTFIRST(FORM.GROUP_ASSIGNEDID)#>
          	<cfset FORM.GROUP_ASSIGNEDID = #LISTLAST(FORM.GROUP_ASSIGNEDID)#>
          </cfif>	

		<cfquery name="GetSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.GROUPID, WGA.STAFFCUSTOMERID, CUST.FULLNAME,
					TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS,
					SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR, 
					SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID, SRSA.STAFF_ASSIGNMENT_ORDER
			FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
               WHERE	SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
               		WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                         SRSA.NEXT_ASSIGNMENT_GROUPID = GA.GROUPID AND
               	<CFIF IsDefined('URL.SRSTAFF_ASSIGNID') AND #URL.SRSTAFF_ASSIGNID# GT 0>
					SRSA.SRSTAFF_ASSIGNID = #val(URL.SRSTAFF_ASSIGNID)# AND
                    </CFIF>
               <CFIF IsDefined('CLIENT.LIST_LOOKUP') AND #CLIENT.LIST_LOOKUP# EQ "LOOKUP">
               		SRSA.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                     <CFIF IsDefined('FORM.LKUPSTAFFCUSTOMERID') AND NOT FORM.LKUPSTAFFCUSTOMERID EQ "">
                         WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.LKUPSTAFFCUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
                     </CFIF>
               </CFIF>
          		<CFIF IsDefined('FORM.STAFF_ASSIGNEDID') AND #FORM.STAFF_ASSIGNEDID# GT 0>
					SRSA.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
          			SRSA.STAFF_ASSIGNEDID = <CFQUERYPARAM value="#FORM.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
          		</CFIF>
                    <CFIF IsDefined('FORM.GROUP_ASSIGNEDID') AND #FORM.GROUP_ASSIGNEDID# EQ 0>
					SRSA.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
          			SRSA.NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#FORM.GROUP_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
          		</CFIF>
                    <CFIF IsDefined('FORM.GROUP_ASSIGNEDID') AND #FORM.GROUP_ASSIGNEDID# GT 0>
					SRSA.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
          			SRSA.NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#FORM.GROUP_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
          		</CFIF>
				<CFIF IsDefined('FORM.STAFFCUSTOMERID') AND #FORM.STAFFCUSTOMERID# GT 0>
					WGA.STAFFCUSTOMERID = <CFQUERYPARAM value="#FORM.STAFFCUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				</CFIF>
					SRSA.SRSTAFF_ASSIGNID > 0
			ORDER BY	CUST.FULLNAME
		</cfquery>
          
          <cfif #GetSRStaffAssignments.RecordCount# EQ 0>
			<script language="JavaScript">
                    <!-- 
                         alert(" Staff Assignment Records for your selected Group were Not Found");
                    --> 
               </script>
               <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=ADD&SRID=#FORM.SRID#" />
               <cfexit>
          </cfif>
          
		<cfcookie name="SRSTAFF_ASSIGNID" secure="NO" value="#GetSRStaffAssignments.SRSTAFF_ASSIGNID#">

		<cfquery name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
					TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SDINIT.INITIALS, SR.REQUESTERID, SR.ALTERNATE_CONTACTID,
					SR.PROBLEM_CATEGORYID, PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY, PROBSUBCAT.SUBCATEGORYNAME, 
					PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, GA.GROUPNAME, SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETED
			FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS SDINIT, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY,
					GROUPASSIGNED GA
			WHERE	SR.SRID = <CFQUERYPARAM value="#GetSRStaffAssignments.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
					SR.GROUPASSIGNEDID = GA.GROUPID AND
					SR.SERVICEDESKINITIALSID = SDINIT.CUSTOMERID AND
					SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
					SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
					SR.PRIORITYID = PRIORITY.PRIORITYID AND
               		SR.SRCOMPLETED = 'NO'
			ORDER BY	SR.SRID
		</cfquery>

          <cfif NOT IsDefined('FORM.SRID') OR FORM.SRID NEQ #GetServiceRequests.SRID#>
          	<cfset FORM.SRID = #GetServiceRequests.SRID#>
          </cfif>
          	
		<cfcookie name="SRID" secure="NO" value="#val(GetServiceRequests.SRID)#">

		<cfquery name="GetRequesters" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
					CUST.EMAIL, CUST.ACTIVE
			FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.REQUESTERID#" cfsqltype="CF_SQL_VARCHAR"> AND
					CUST.UNITID = UNITS.UNITID AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
					CUST.ACTIVE = 'YES'
			ORDER BY	CUST.FULLNAME
		</cfquery>

		<cfquery name="GetAltContacts" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
					CUST.EMAIL, CUST.ACTIVE
			FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.ALTERNATE_CONTACTID#" cfsqltype="CF_SQL_VARCHAR"> AND 
					CUST.UNITID = UNITS.UNITID AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
					CUST.ACTIVE = 'YES'
			ORDER BY	CUST.FULLNAME
		</cfquery>
          
		<cfquery name="GetSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
			FROM		SREQUIPLOOKUP
			WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#GetServiceRequests.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>

		<cfif GetSREquipLookup.RecordCount GT 0>
			<cfquery name="GetHardware" datasource="#application.type#HARDWARE">
				SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTTYPEID,
						EQT.EQUIPMENTTYPE, HI.OWNINGORGID, HI.MODELNAMEID, MNAMEL.MODELNAME, HI.MODELNUMBERID, MNUML.MODELNUMBER,
						HI.CUSTOMERID, CUST.FULLNAME, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER, HW.WARRANTYEXPIRATIONDATE AS WARDATE
				FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUML, LIBSHAREDDATAMGR.CUSTOMERS CUST,
						FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
				WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#GetSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
						HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
						HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
						HI.MODELNUMBERID = MNUML.MODELNUMBERID AND
						HI.CUSTOMERID = CUST.CUSTOMERID AND
						HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
						HI.BARCODENUMBER = HW.BARCODENUMBER
				ORDER BY	BARCODENUMBER
			</cfquery>

			<cfquery name="LookupOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
				SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
				FROM		ORGCODES
				WHERE	ORGCODEID = <CFQUERYPARAM value="#GetHardware.OWNINGORGID#" cfsqltype="CF_SQL_VARCHAR">
				ORDER BY	ORGCODE
			</cfquery>
               
               <cfquery name="LookupHardwareAttachedTo" datasource="#application.type#HARDWARE">
                    SELECT	ATTACHEDTOID, BARCODENUMBER, ATTACHEDTO
                    FROM		HARDWAREATTACHEDTO
                    WHERE	ATTACHEDTO = <CFQUERYPARAM value="#GetHardware.HARDWAREID#" cfsqltype="CF_SQL_VARCHAR">
               </cfquery>

		</cfif>
          
          <cfquery name="GetNextGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="46">
			SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER,
					CUST.FULLNAME || ' - ' || WGA.GROUPORDER  || ' - ' ||  GA.GROUPNAME AS STAFFGROUP
			FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
               WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
               		WGA.GROUPID = GA.GROUPID AND
                         WGA.GROUPID = <CFQUERYPARAM value="#GetSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	GA.GROUPNAME, CUST.FULLNAME
		</cfquery>

		<cfquery name="LookupOtherStaff" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, GA.GROUPID, GA.GROUPNAME AS WORKGROUPNAME,
               		CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS, SRSA.NEXT_ASSIGNMENT, WGA.ACTIVE,
                         SRSA.NEXT_ASSIGNMENT_GROUPID, NGA.GROUPID, NGA.GROUPNAME AS NEXTGROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR,
                         SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID
			FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, GROUPASSIGNED NGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	(SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
					SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         SRSA.STAFF_ASSIGNEDID > 0 AND
                         WGA.GROUPID = GA.GROUPID AND
                         SRSA.NEXT_ASSIGNMENT_GROUPID = NGA.GROUPID AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID) AND
                         WGA.ACTIVE = 'YES' AND
					((NOT WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#GetSRStaffAssignments.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR">) OR
                         (SRSA.STAFF_ASSIGNEDID = 0 AND 
                         NOT SRSA.NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#GetSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID#" cfsqltype="CF_SQL_VARCHAR">))
			ORDER BY	CUST.FULLNAME, NGA.GROUPNAME
		</cfquery>

		<cfquery name="GetStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="46">
			SELECT	DISTINCT WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER,
					CUST.FULLNAME || ' - ' || WGA.GROUPORDER  || ' - ' ||  GA.GROUPNAME AS STAFFGROUP
			FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
               WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
               		WGA.GROUPID = GA.GROUPID
			<CFIF #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'YES'>
					AND(WGA.GROUPID = <CFQUERYPARAM value="#GetSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID#" cfsqltype="CF_SQL_VARCHAR">)
			<CFELSE>
					AND WGA.GROUPID = <CFQUERYPARAM value="#GetServiceRequests.GROUPASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR">
			</CFIF>
					
			<CFIF #Client.SecurityFlag# EQ "NO" AND #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ "NO">
					AND WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#GetSRStaffAssignments.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR">
			</CFIF>
               <CFIF LookupOtherStaff.RecordCount GT 0>
					AND NOT WGA.WORKGROUPASSIGNSID = #LookupOtherStaff.STAFF_ASSIGNEDID#
               </CFIF>
			ORDER BY	GA.GROUPNAME, CUST.FULLNAME

		</cfquery>

		<cfquery name="LookupCompletedComments" datasource="#application.type#SERVICEREQUESTS" blockfactor="34">
			SELECT	COMPLETED_COMMENTSID, COMPLETED_COMMENTS
			FROM		COMPLETEDCOMMENTS
			ORDER BY	COMPLETED_COMMENTS
		</cfquery>

		<table width="100%" align="center" border="3">
			<tr align="center">
				<td align="center"><h1>#REPORTTITLE#</h1></td>
			</tr>
		</table>
		<table width="100%" align="center" border="0">
			<tr>
				<th align="center"><h4>*Red fields marked with asterisks are required!</h4></th>
			</tr>
			<tr>
				<th align="center">SR Staff Assignment Key &nbsp; = &nbsp; #Cookie.SRSTAFF_ASSIGNID#</th>
			</tr>
		</table>
	
		<table align="left" width="100%" border="0">
			<tr>
<cfform action="#RETURNPGM#" method="POST">
				<td align="left" width="33%">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</td>
</cfform>
			</tr>
	     </table>
     
     <fieldset>
     <legend>Service Request</legend>
<cfform name="SRSTAFFASSIGN" onsubmit="return validateModifyReqFields();" action="/#application.type#apps/servicerequests/#PROCESSPROGRAMNAME#" method="POST" enablecab="Yes">
	<table width="100%" align="LEFT">
			<tr>
				<th align="left" width="33%">SR</th>
				<th align="left" width="33%">Creation Date</th>
				<th align="left" width="33%">Creation Time</th>
			</tr>
			<tr>
				<input type="hidden" name="SRID" value="#FORM.SRID#" />
				<td align="left" width="33%">#GetServiceRequests.SERVICEREQUESTNUMBER#</td>
				<td align="left" width="33%">#DateFormat(GetServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</td>
				<td align="left" width="33%">#TimeFormat(GetServiceRequests.CREATIONTIME, "hh:mm:ss tt")#</td>
			</tr>
			<tr>
				<th align="left" width="33%">Requester</th>
				<th align="left" width="33%">R Unit</th>
				<th align="left" width="33%">R Phone</th>
			</tr>
			<tr>
				<td align="left" width="33%">#GetRequesters.FULLNAME#</td>
				<td align="left" width="33%">#GetRequesters.UNITNAME#</td>
				<td align="left" width="33%">#GetRequesters.CAMPUSPHONE#</td>
			</tr>
			<tr>
                    <th align="left" width="33%">Service Desk Initials</th>
                    <th align="left" width="33%">R Room</th>
                    <th align="left" width="33%">R E-Mail</th>
               </tr>
               <tr>
                    <td>#GetServiceRequests.INITIALS#</td>
				<td align="left" width="33%">#GetRequesters.ROOMNUMBER#</td>
				<td align="left" width="33%"><a href="MAILTO:#GetRequesters.EMAIL#">#GetRequesters.EMAIL#</a></td>
			</tr>
		<cfif GetServiceRequests.ALTERNATE_CONTACTID GT 0>
			<tr>
				<th align="left" width="33%">Alt Contact</th>
				<th align="left" width="33%">AC Unit</th>
				<th align="left" width="33%">AC Phone</th>
			</tr>
			<tr>
				<td align="left" width="33%">#GetAltContacts.FULLNAME#</td>
				<td align="left" width="33%">#GetAltContacts.UNITNAME#</td>
				<td align="left" width="33%">#GetAltContacts.CAMPUSPHONE#</td>
			</tr>
			<tr>
				<th align="left" width="33%">&nbsp;&nbsp;</th>
				<th align="left" width="33%">AC Room</th>
				<th align="left" width="33%">AC E-Mail</th>
			</tr>
			<tr>
				<td align="left" width="33%">&nbsp;&nbsp;</td>
				<td align="left" width="33%">#GetAltContacts.ROOMNUMBER#</td>
				<td align="left" width="33%"><a href="MAILTO:#GetAltContacts.EMAIL#">#GetAltContacts.EMAIL#</a></td>
			</tr>
		</cfif>
			<tr>
			<th align="left" width="33%">Problem Category</th>
			<th align="left" width="33%">Sub-Category</th>
			<th align="left" width="33%">Priority</th>
		</tr>
		<tr>
			<td align="left" width="33%" valign="TOP">
				#GetServiceRequests.PROBCATEGORY#
			</td>
			<td align="left" width="33%" valign="TOP">
               	#GetServiceRequests.SUBCATEGORYNAME#
               </td>
               <td align="left" width="33%" valign="TOP">
               	#GetServiceRequests.PRIORITYNAME#
               </td>
          </tr>
          <tr>
			<th align="left" colspan="3">Problem Description</th>
		</tr>
		<tr>
			<td align="left" colspan="3">#GetServiceRequests.PROBLEM_DESCRIPTION#</td>
		</tr>
          </table>
          </FIELDSET>
          <br />
          <cfif IsDefined('GetHardware.RecordCount') AND #GetHardware.RecordCount# GT 0>
          <fieldset>
          <legend>Associated Equipment</legend>
          <table width="100%" align="LEFT">
			<tr>
				<th align="left" width="33%">Bar Code Number</th>
				<th align="left" width="33%">Equipment Type</th>
				<th align="left" width="33%">State/Found Number</th>
			</tr>
			<tr>
				<td align="left" width="33%">#GetHardware.BARCODENUMBER#</td>
				<td align="left" width="33%">#GetHardware.EQUIPMENTTYPE#</td>
				<td align="left" width="33%">#GetHardware.STATEFOUNDNUMBER#</td>
			</tr>
               <tr>
                    <th align="left" width="33%">Model</th>
                    <th align="left" width="33%">Model Number</th>
                    <th align="left" width="33%">Division Number</th>
               </tr>
               <tr>
                    <td align="left" width="33%">#GetHardware.MODELNAME#</td>
                    <td align="left" width="33%">#GetHardware.MODELNUMBER#</td>
                    <td align="left" width="33%">#GetHardware.DIVISIONNUMBER#</td>
               </tr>
               <tr>
                    <th align="left" width="33%">Currently Assigned</th>
                    <th align="left" width="33%">Equipment Room Number</th>
                    <th align="left" width="33%">Serial</th>
               </tr>
               <tr>
                    <td align="left" width="33%">#GetHardware.FULLNAME#</td>
                    <td align="left" width="33%">#GetHardware.ROOMNUMBER#</td>
                    <td align="left" width="33%">#GetHardware.SERIALNUMBER#</td>
               </tr>
              <tr>
                    <th align="left" width="33%">Warranty Expiration Date</th>
				<th align="left" width="33%">Equipment Attached</th>
                    <th align="left" width="33%">&nbsp;&nbsp;</th>
               </tr>     
               <tr>
                    <td align="left" width="33%" valign="top">#DateFormat(GetHardware.WARDATE, "mm/dd/yyyy")#</td>
				<td align="left" width="33%">
                    	<cfloop query="LookupHardwareAttachedTo">
						#BARCODENUMBER#<br>
					</cfloop>
                    </td>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
                </tr>
          </table>
          </fieldset>
		</cfif>
          <br />
          <fieldset>
          <legend>Group/Staff Assignments</legend>
          <table width="100%" border="0">
			<tr>
		<cfif #Client.SecurityFlag# EQ "YES">
               <cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'NO'>
                    <th align="left" width="33%">Primary Group Assigned</th>
                    <th align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<h4><label for="STAFF_ASSIGNEDID">*Primary Staff Assigned</label></h4></th>
                    <th align="left" width="33%"><h4><label for="STAFF_DATEASSIGNED">*Date Primary Staff Assigned</label></h4></th>
               <cfelse>
                    <th align="left" width="33%">Next Referral Group Assigned</th>
                    <th align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<h4><label for="STAFF_ASSIGNEDID">*Next Referral Staff Assigned</label></h4></th>
                    <th align="left" width="33%"><h4><label for="STAFF_DATEASSIGNED">*Date Next Referral Staff Assigned</label></h4></th>
               </cfif>
		<cfelse>
               <cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'NO'>
                    <th align="left" width="33%">Primary Group Assigned</th>
                    <th align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<label for="STAFF_ASSIGNEDID">Primary Staff Assigned</label></th>
                    <th align="left" width="33%"><label for="STAFF_DATEASSIGNED">Date Primary Staff Assigned</label></th>
               <cfelse>
                    <th align="left" width="33%">
                    	<cfif #Client.SecurityFlag# EQ "Yes">
                         	<label for="NEXT_ASSIGNMENT_GROUPID">Next Referral Group Assigned</label>
                         <cfelse>
                         	Next Referral Group Assigned
                         </cfif>
                    </th>
                    <th align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;<label for="STAFF_ASSIGNEDID">Next Referral Staff Assigned</label></th>
                    <th align="left" width="33%"><label for="STAFF_DATEASSIGNED">Date Next Referral Staff Assigned</label></th>
               </cfif>
          </cfif>     	
			</tr>
			<tr>
				<td align="left" width="33%">
				<cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'NO'>
					#GetServiceRequests.GROUPNAME#
                         <cfset SESSION.PRIMARYGROUP = "#GetServiceRequests.GROUPNAME#">
                         <input type="hidden" name="NEXT_ASSIGNMENT" value="#GetSRStaffAssignments.NEXT_ASSIGNMENT#" />
				<cfelse>
                    	<cfif #Client.SecurityFlag# EQ "Yes">
                    		<cfselect name="NEXT_ASSIGNMENT_GROUPID" id="NEXT_ASSIGNMENT_GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" selected ="#GetNextGroupAssigned.GROUPID#" display="GROUPNAME" required="No" tabindex="2"></cfselect>
                         <cfelse>
						#GetNextGroupAssigned.GROUPNAME#
                              <cfset SESSION.NEXTGROUP = "#GetNextGroupAssigned.GROUPNAME#">
                         </cfif>
                         <input type="hidden" name="NEXT_ASSIGNMENT" value="#GetSRStaffAssignments.NEXT_ASSIGNMENT#" />
				</cfif>
				</td>
				<td align="left" width="33%">
                    <input type="hidden" name="SRSTAFF_ASSIGNID" value="#Cookie.SRSTAFF_ASSIGNID#" />
 				<cfif #Client.SecurityFlag# EQ "YES">
                    	&nbsp;&nbsp;&nbsp;&nbsp;
					<cfselect name="STAFF_ASSIGNEDID" id="STAFF_ASSIGNEDID" size="1" required="No" tabindex="3">
                         	<option value="0">Select a Staff Member and SR</option>
						<option selected value="#GetSRStaffAssignments.STAFF_ASSIGNEDID#">#GetSRStaffAssignments.FULLNAME#</option>
						<cfloop query = "GetStaffAssigned">
							<option value="#WORKGROUPASSIGNSID#">#FULLNAME#</option>
						</cfloop>
					</cfselect>
				<cfelse>
                    	<input type="hidden" name="STAFF_ASSIGNEDID" value="#GetSRStaffAssignments.STAFF_ASSIGNEDID#" />
					&nbsp;&nbsp;&nbsp;&nbsp;#GetSRStaffAssignments.FULLNAME#
				</cfif>
				</td>
				<td align="left" width="33%">
				<cfif #Client.SecurityFlag# EQ "Yes">
					<cfif #GetSRStaffAssignments.STAFF_ASSIGNEDID# EQ 0>
						<cfset FORM.STAFF_DATEASSIGNED = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
						<cfinput type="Text" name="STAFF_DATEASSIGNED" id="STAFF_DATEASSIGNED" value="#DateFormat(FORM.STAFF_DATEASSIGNED, "mm/dd/yyyy")#" align="LEFT" required="No" size="15" tabindex="4">
                               <script language="JavaScript">
							new tcal ({'formname': 'SRSTAFFASSIGN','controlname': 'STAFF_DATEASSIGNED'});

						</script>
					<cfelse>
						<cfinput type="Text" name="STAFF_DATEASSIGNED" id="STAFF_DATEASSIGNED" value="#DateFormat(GetSRStaffAssignments.STAFF_DATEASSIGNED, "mm/dd/yyyy")#" align="LEFT" required="No" size="15" tabindex="4">
                               <script language="JavaScript">
							new tcal ({'formname': 'SRSTAFFASSIGN','controlname': 'STAFF_DATEASSIGNED'});

						</script>
					</cfif>
				<cfelse>
					#DateFormat(GetSRStaffAssignments.STAFF_DATEASSIGNED, "mm/dd/yyyy")#
				</cfif>
				</td>
			</tr>
			<tr>
				<th align="left" colspan="3"><label for="STAFF_COMMENTS">Comments</label></th>
			</tr>
			<tr>
				<td align="left" colspan="3" valign="TOP">
					<cftextarea name="STAFF_COMMENTS" id="STAFF_COMMENTS" wrap="PHYSICAL" rows="6" cols="100" tabindex="5">#GetSRStaffAssignments.STAFF_COMMENTS#</cftextarea>
				</td>
			</tr>
			<tr>
				<th align="left" width="33%"><label for="STAFF_COMPLETEDCOMMENTSID">Completion Comments</label></th>
                    <th align="left" width="33%">&nbsp;&nbsp;&nbsp;&nbsp;Assignments</th>
			<cfif #Client.SecurityFlag# EQ "YES">
                    <th align="left" width="33%"><label for="STAFF_ASSIGNMENT_ORDER">Code</label></th>
			<cfelse>
               	<th align="left" width="33%">&nbsp;&nbsp;</th>
			</cfif>
			</tr>
			<tr>
				<td align="left" width="33%" valign="TOP">
					<cfselect name="STAFF_COMPLETEDCOMMENTSID" id="STAFF_COMPLETEDCOMMENTSID" size="1" query="LookupCompletedComments" value="COMPLETED_COMMENTSID" display="COMPLETED_COMMENTS" selected="#GetSRStaffAssignments.STAFF_COMPLETEDCOMMENTSID#" required="No" tabindex="6"></cfselect>
				</td>
                    <td align="left" width="33%" valign="TOP">
     
                         <cfquery name="LookupHardwareAssigns" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                              SELECT	SRHA.SRHARDWASSIGNID, SRHA.SRID, SRHA.HWSWID, HSA.HWSW_ID, HSA.HWSW_NAME
                              FROM		SRHARDWASSIGNS SRHA, HWSW HSA
                              WHERE	SRHA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                                        SRHA.HWSWID = HSA.HWSW_ID
                              ORDER BY	SRHA.HWSWID
                         </cfquery>
                         
                         <table width="33%" border="0">
                         	<tr>
                         		<td align="left" width="16%" valign="TOP">&nbsp;&nbsp;&nbsp;&nbsp;HW:</td>
                                   <td align="left" width="17%" valign="TOP">#LookupHardwareAssigns.Recordcount#</td>
                    		</tr>
                              
                         <cfquery name="LookupSoftwareAssigns" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                              SELECT	SRSA.SRSOFTWASSIGNID, SRSA.SRID, SRSA.HWSWID, HSA.HWSW_ID, HSA.HWSW_NAME
                              FROM		SRSOFTWASSIGNS SRSA, HWSW HSA
                              WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                                        SRSA.HWSWID = HSA.HWSW_ID 
                              ORDER BY	SRSA.HWSWID
                         </cfquery>
                         
                         	<tr>
                         		<td align="left" width="16%" valign="TOP">&nbsp;&nbsp;&nbsp;&nbsp;SW:</td>
                                   <td align="left" width="17%" valign="TOP">#LookupSoftwareAssigns.Recordcount#</td>
                         	</tr>
                              
                         <cfquery name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
                              SELECT	TNSWO_ID, SRID, WO_TYPE
                              FROM		TNSWORKORDERS
                              WHERE	SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                                        NOT WO_TYPE LIKE ('%PHONE%')
                              ORDER BY	WO_TYPE
                         </cfquery>
                                         
                         	<tr>
                         		<td align="left" width="16%" valign="TOP">&nbsp;&nbsp;&nbsp;&nbsp;TNS:</td>
                                   <td align="left" width="17%" valign="TOP">#LookupTNSWorkOrders.Recordcount#</td>
                         	</tr>
                         
                         <cfquery name="LookupTelephoneWOs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
                              SELECT	SRID
                              FROM		TNSWORKORDERS
                              WHERE	SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMBER"> AND
                                        WO_TYPE LIKE ('%PHONE%')
                              ORDER BY	SRID
                         </cfquery>
                         
                         	<tr>
                         		<td align="left" width="16%" valign="TOP">&nbsp;&nbsp;&nbsp;&nbsp;Tele:</td>
                                   <td align="left" width="17%" valign="TOP">#LookupTelephoneWOs.Recordcount#</td>
                         	</tr>
           			</table>

                    </td>
			<cfif #Client.SecurityFlag# EQ "YES">
                    <td align="left" width="33%" valign="TOP">
                    	<cfselect name="STAFF_ASSIGNMENT_ORDER" id="STAFF_ASSIGNMENT_ORDER" size="1" tabindex="26">
                         	<option selected value="#GetSRStaffAssignments.STAFF_ASSIGNMENT_ORDER#">#GetSRStaffAssignments.STAFF_ASSIGNMENT_ORDER#</option>
                              <option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
                              <option value="5">5</option>
                    	</cfselect>
               	</td>
			<cfelse>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
			</cfif>
               </tr>
			<tr>
				<th align="left" width="33%" valign="BOTTOM"><label for="STAFF_TIME_WORKED">Staff Time Worked</label></th>
				<th align="left" width="33%" valign="BOTTOM">&nbsp;&nbsp;&nbsp;&nbsp;<label for="STAFF_COMPLETEDSR">Completed SR?</label></th>
              <cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'YES'>
				<th align="left" width="33%" valign="BOTTOM"><h4><label for="NEXT_ASSIGNMENT_REASON">*Reason for Next Assignment</label></h4></th>
			<cfelse>
				<th align="left" width="33%">&nbsp;&nbsp;</th>
			</cfif>
			</tr>
			<tr>
               	<td align="left" width="33%" valign="top">
                         <cfinput type="Text" name="STAFF_TIME_WORKED" id="STAFF_TIME_WORKED" value="#NumberFormat(GetSRStaffAssignments.STAFF_TIME_WORKED, '0_._')#" align="LEFT" required="No" size="25" tabindex="7"><br>
                         <input type="image" src="/images/buttonTime.jpg" value="Time?"  alt="Time?"
                         onClick="window.open('/#application.type#apps/servicerequests/timefieldsreminder.cfm',
                                              'Time Fields Reminder','alwaysRaised=yes,dependent=no,width=150,height=260,directories=no,toolbar=no,scrollbars=no,location=no,status=no,menubar=no,resizable=no,screenX=25,screenY=25'); return false;" 
                                              tabindex="8" />
                    </td>
				<td align="left" width="33%" valign="top">
                    	&nbsp;&nbsp;&nbsp;&nbsp;
					<cfselect name="STAFF_COMPLETEDSR" id="STAFF_COMPLETEDSR" size="1" tabindex="9">
						<option value="NO">NO</option>
					<cfif #GetSRStaffAssignments.STAFF_COMPLETEDSR# EQ "YES">
						<option selected value="YES">YES</option>
					<cfelse>
						<option value="YES">YES</option>
					</cfif>
					<cfif #GetSRStaffAssignments.STAFF_COMPLETEDSR# EQ "VOIDED">
						<option selected value="VOIDED">VOIDED</option>
					<cfelse>
						<option value="VOIDED">VOIDED</option>
					</cfif>
					</cfselect>
				</td>
 			<cfif #GetSRStaffAssignments.NEXT_ASSIGNMENT# EQ 'YES'>
				<td align="left" width="33%" valign="top">
					<cftextarea name="NEXT_ASSIGNMENT_REASON" id="NEXT_ASSIGNMENT_REASON" wrap="VIRTUAL" rows="4" cols="25" tabindex="10">#GetSRStaffAssignments.NEXT_ASSIGNMENT_REASON#</cftextarea>
				</td>
			<cfelse>
				<td align="left" width="33%">&nbsp;&nbsp;</td>
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
          <legend>Assignment Record Processing</legend>
          <table width="100%" border="0">	
			<tr>
				<td align="left" width="33%">
                    	<input type="hidden" name="PROCESSSRSTAFFASSIGNS" value="MODIFY" />
                         <input type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="11" />
                    </td>
				<td align="left" width="33%">
                    	<input type="image" src="/images/buttonMODCompletion.jpg" value="MODIFY TO COMPLETION" alt="Modify To Completion" onClick="return validateModifyToCompletion();" tabindex="12" />
                    </td>

<!---  Only Admin Level can delete a Staff Assignment Record --->
			<cfif #Client.SecurityFlag# EQ "Yes">
                    <td align="left" width="33%">
                         <input type="image" src="/images/buttonDELStaff.jpg" value="DELETE STAFF" alt="Delete Staff Assignment" onClick="return setDeleteStaff();" tabindex="13" />
                    </td>
               <cfelse>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
               </cfif>
                    
			</tr>

		<cfif (IsDefined("Client.MaintLessFlag") AND Client.MaintLessFlag EQ "No")>
			<tr>
                    <td align="left" width="33%">
                        <input type="image" src="/images/buttonAddNextGrp.jpg" value="Add Next Group" alt="Add Next Group" onClick="window.open('/#application.type#apps/servicerequests/srnextrefergroupchoice.cfm?SRID=#Cookie.SRID#&PROCESS=ADD&STAFFLOOP=YES',
                                                    'Add Next Group','alwaysRaised=yes,dependent=no,width=800,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                                    tabindex="14" />
                    </td>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
			</tr>
		</cfif>

               <tr>
				<td align="left" width="33%">&nbsp;&nbsp;</td>
			</tr>
      
</cfform>
		</TABLE>
          </FIELDSET>
          <br />
          <fieldset>
          <legend>Add Supplemental Records</legend>
          <table width="100%" border="0">
			<tr>
                    <td align="left" width="33%">
                         <input type="image" src="/images/buttonAddChat.jpg" value="Add Chatter" alt="Add Chatter"  
                          onClick="window.open('/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=ADD&STAFFLOOP=YES',
                                               'Add Chatter','alwaysRaised=yes,dependent=no,width=950,height=1000,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="15" /> 
                    </td>                   
                    <td align="left" width="33%">
                    
                         <input type="image" src="/images/buttonAddHWAssigns.jpg" value="Add Hardware Assignments" alt="Add Hardware Assignments" 
                          onClick="window.open('/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#',
                                               'Add Hardware Assignments','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="16" />
                    </td>
                    <td align="left" width="33%">
                    
                         <input type="image" src="/images/buttonModDelHWAssigns.jpg" value="Modify/Delete Hardware Assignments" alt="Modify/Delete Hardware Assignments" 
                          onClick="window.open('/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYDELETE&LOOKUPITEM=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                                               'Modify/Delete Hardware Assignments','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="17" />
                    </td>
			</tr>
			<tr>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
                    <td align="left" width="33%">
                         <input type="image" src="/images/buttonAddSWAssigns.jpg" value="Add Software Assignments" alt="Add Software Assignments" 
                          onClick="window.open('/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#',
                                               'Add Software Assignments','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="18" />
                    </td>
                    <td align="left" width="33%">
                         <input type="image" src="/images/buttonModDelSWAssigns.jpg" value="Modify/Delete Software Assignments" alt="Modify/Delete Software Assignments" 
                          onClick="window.open('/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYDELETE&LOOKUPITEM=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                                               'Add Software Assignments','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="19" />
                    </td>
			</tr>
               <tr>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
                    <cfif #GetServiceRequests.PROBLEM_CATEGORYID# EQ 2>
				<td align="left" width="33%">
					<input type="image" src="/images/buttonAddPurch.jpg" value="ADD PURCH" alt="Add Purchase Requisition" 
					onClick="window.open('/#application.type#apps/servicerequests/lookupsrpurchreqinfo.cfm?SRNUMBER=#GetServiceRequests.SERVICEREQUESTNUMBER#',
					 'Look Up Purchase Requisition','alwaysRaised=yes,dependent=no,width=1200,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					 tabindex="20" />
				</td>
				<cfelse>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
				</cfif>
                    <cfif #GetServiceRequests.PROBLEM_CATEGORYID# EQ 2>
				<td align="left" width="33%">
					<input type="image" src="/images/buttonModPurch.jpg" value="MODIFY PURCH" alt="Modify Purchase Requisition" 
					onClick="window.open('/#application.type#apps/servicerequests/lookupsrpurchreqinfo.cfm?SRNUMBER=#GetServiceRequests.SERVICEREQUESTNUMBER#',
					 'Look Up Purchase Requisition','alwaysRaised=yes,dependent=no,width=1200,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					 tabindex="21" />
				</td>
				<cfelse>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
				</cfif>
			</tr>
			<tr>
				<td align="left" width="33%">&nbsp;&nbsp;</td>
			<cfif #GetServiceRequests.PROBLEM_CATEGORYID# EQ 9 OR #GetServiceRequests.PROBLEM_CATEGORYID# EQ 16>
              		<td align="left" width="33%">
                    	<input type="image" src="/images/buttonAddTNSRequest.jpg" value="Add TNS Requests" alt="Add TNS Requests" 
                          onClick="window.open('/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Add TNS Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="22" />
                   </td>
                   <td align="left" width="33%">
					<input type="image" src="/images/buttonModifyTNSRequest.jpg" value="Modify TNS Requests" alt="Modify TNS Requests"  
					 onClick="window.open('/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Modify TNS Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					 				  tabindex="23" /> 
                    </td>
                   
			<cfelse>	
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
               </cfif>     
			
			</tr>
		<cfif #GetServiceRequests.PROBLEM_CATEGORYID# EQ 9 OR #GetServiceRequests.PROBLEM_CATEGORYID# EQ 16>
               <tr>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
			     <td align="left" width="33%">
                    	<input type="image" src="/images/buttonAddPhoneRequest.jpg" value="Add Telephone Requests" alt="Add Telephone Requests" 
                          onClick="window.open('/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Add Telephone Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="24" />
                   </td>
			     <td align="left" width="33%">
                    	<input type="image" src="/images/buttonModPhoneRequest.jpg" value="Modify Telephone Requests" alt="Modify Telephone Requests" 
                          onClick="window.open('/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Modify Telephone Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="25" />
                    </td>
			</tr>
               <tr>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
			     <td align="left" width="33%">
					<input type="image" src="/images/buttonSubmitTNSRequest.jpg" value="Submit TNS Requests" alt="Submit TNS Requests"  
					 onClick="window.open('/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=SUBMIT&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Submit TNS Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					 				  tabindex="26" /> 
                    </td>
			     <td align="left" width="33%">
                    	<input type="image" src="/images/buttonSubmitPhoneRequest.jpg" value="Submit Telephone Requests" alt="Submit Telephone Requests" 
                          onClick="window.open('/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=SUBMIT&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#FORM.SRID#',
                          				  'Submit Telephone Requests','alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="27" />
                    </td>
			</tr>
		</cfif>
 		</table>
          </fieldset>
          <br />
          <table width="100%" align="LEFT">
			<tr>
<cfform action="#RETURNPGM#" method="POST">
				<td align="left" colspan="2">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="28" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</td>
</cfform>
			</tr>
			<tr>
				<td align="left" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
			</tr>
		</table>
	</cfif>
</cfif>

</body>
</cfoutput>
</html>