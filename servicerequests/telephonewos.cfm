<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: telephonewos.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/28/2013 --->
<!--- Date in Production: 02/28/2013 --->
<!--- Module: Add, Modify and Delete Telephone Work Orders--->
<!-- Last modified by John R. Pastori on 01/12/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">

<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/telephonewos.cfm">
<CFSET CONTENT_UPDATED = "January 12, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Telephone Work Orders</TITLE>
	<CFELSE>
		<TITLE>Modify Telephone Work Orders</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Service Requests";

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


	function validateReqFields() {

		if (document.TELEPHONEWO.WORK_DESCRIPTION.value == "" || document.TELEPHONEWO.WORK_DESCRIPTION.value == " ") {
			alertuser (document.TELEPHONEWO.WORK_DESCRIPTION.name +  ",  You must enter a Work Description.");
			document.TELEPHONEWO.WORK_DESCRIPTION.focus();
			return false;
		}

		if ((document.TELEPHONEWO.ACCOUNTNUMBER2 != null) && (document.TELEPHONEWO.ACCOUNTNUMBER2.value == "" || document.TELEPHONEWO.ACCOUNTNUMBER2.value == " ")) {
			alertuser (document.TELEPHONEWO.ACCOUNTNUMBER2.name +  ",  You must enter a 4 digit number.");
			document.TELEPHONEWO.ACCOUNTNUMBER2.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.SRID1.selectedIndex == "0" && document.LOOKUP.SRID2.selectedIndex == "0") {
			alertuser ("A selection must be made from one of the dropdowns.");
			document.LOOKUP.SRID1.focus();
			return false;
		}
		
		if (document.LOOKUP.SRID1.selectedIndex > "0" && document.LOOKUP.SRID2.selectedIndex > "0") {
			alertuser ("BOTH dropdown values can NOT be selected! Choose one or the other.");
			document.LOOKUP.SRID1.focus();
			return false;
		}
		
	}
	
		
	function setModReview() {
		document.TELEPHONEWO.PROCESSTELEPHONEWOS.value = "MODIFY AND REVIEW";
		return true;
	}
	

	function setDelete() {
		document.TELEPHONEWO.PROCESSTELEPHONEWOS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined("URL.LOOKUPWO") AND URL.PROCESS EQ "MODIFY">
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.TELEPHONEWO.WO_TYPE.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<CFIF IsDefined("URL.WO_TYPE")>
	<CFSET FORM.WOTYPE = "#URL.WO_TYPE#">
<CFELSE>
	<CFSET FORM.WOTYPE = "NEW">
</CFIF>

<!--- 
*****************************************************************
* The following code is for all Telephone Work Order Processes. *
*****************************************************************
 --->

<CFQUERY name="ListLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
			LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
			LOC.MODIFIEDBYID, LOC.MODIFIEDDATE
	FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
	WHERE	LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID AND
               BN.BUILDINGNAMEID IN (0,10,11)
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
</CFQUERY>


<!--- 
********************************************************************
* The following code is the ADD Process for Telephone Work Orders. *
********************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Telephone Work Orders</H1></TD>
          </TR>
     </TABLE>
     
     <CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
                    SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, CUST.LASTNAME, CUST.FIRSTNAME, CUST.CATEGORYID, CAT.CATEGORYNAME, 
                    CUST.UNITID, U.UNITID, U.DEPARTMENTID, DEPT.DEPARTMENTNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.DIALINGCAPABILITY,
                    CUST.VOICEMAIL, CUST.PHONEBOOKLISTING, CUST.CONTACTBY, LOC.ROOMNUMBER, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID, 
                    SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID, SR.GROUPASSIGNEDID, IDTGROUP.GROUPID, IDTGROUP.GROUPNAME, SR.SERVICETYPEID,
                    SR.ACTIONID, SR.OPERATINGSYSTEMID, SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, SR.TOTAL_REFERRALTIME,
                    SR.SRCOMPLETEDDATE, SR.SRCOMPLETED, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
          FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC, GROUPASSIGNED IDTGROUP, 
          		LIBSHAREDDATAMGR.CATEGORIES CAT, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.DEPARTMENTS DEPT
          WHERE	SR.SRID = <CFQUERYPARAM value="#URL.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    SR.REQUESTERID = CUST.CUSTOMERID AND
                    CUST.LOCATIONID = LOC.LOCATIONID AND
                    SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
                    CUST.CATEGORYID = CAT.CATEGORYID AND
                    CUST.UNITID = U.UNITID AND 
                    U.DEPARTMENTID = DEPT.DEPARTMENTID
          ORDER BY	LOOKUPKEY
     </CFQUERY>
     
     <CFQUERY name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.FULLNAME,
                    TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID
          FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	SRSA.SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    SRSA.STAFF_COMPLETEDSR = 'NO' AND
                    SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                    WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                    SRSA.NEXT_ASSIGNMENT = 'NO' AND
                    SRSA.NEXT_ASSIGNMENT_GROUPID = 0
          ORDER BY	SRSA.STAFF_ASSIGNEDID
     </CFQUERY>
     
     <CFQUERY name="LookupTelephoneWOs" datasource="#application.type#SERVICEREQUESTS">
          SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, CUST.FULLNAME, 
                    CUST.LOCATIONID, LOC.ROOMNUMBER, TNSWO.NEW_LOCATION, TNSWO.WORK_DESCRIPTION, TNSWO.WO_DUEDATE, 
                    TNSWO.WO_NUMBER, TNSWO.PHONE_CURRENT_JACKNUMBER, TNSWO.PHONE_NEW_JACKNUMBER
          FROM		TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CATEGORIES CAT, 
                    LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.DEPARTMENTS DEPT
          WHERE	TNSWO.SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    TNSWO.STAFFID = CUST.CUSTOMERID AND
                    CUST.LOCATIONID = LOC.LOCATIONID AND
                    CUST.CATEGORYID = CAT.CATEGORYID AND
                    CUST.UNITID = U.UNITID AND 
                    U.DEPARTMENTID = DEPT.DEPARTMENTID AND
                    TNSWO.WO_TYPE LIKE ('%PHONE%')
          ORDER BY	TNSWO.WO_TYPE
     </CFQUERY>

     <CFIF LookupTelephoneWOs.RecordCount EQ 0>

          <CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
               SELECT	MAX(TNSWO_ID) AS MAX_ID
               FROM		TNSWORKORDERS
          </CFQUERY>
          <CFSET FORM.TNSWO_ID = #val(GetMaxUniqueID.MAX_ID+1)#>
          <CFCOOKIE name="TNSWO_ID" secure="NO" value="#FORM.TNSWO_ID#">
          <CFQUERY name="AddTNSWOIDInfo" datasource="#application.type#SERVICEREQUESTS">
               INSERT INTO	TNSWORKORDERS (TNSWO_ID, SRID)
               VALUES		(#val(FORM.TNSWO_ID)#, #val(URL.SRID)#)
          </CFQUERY> 
          
     <CFELSE>
     
     	<SCRIPT language="JavaScript">
			<!-- 
				alert ("This SR already has a Telephone Work Order associated with it.");
			-->
		</SCRIPT>
		<CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('client.STAFFLOOP') AND #client.STAFFLOOP# EQ "YES"))>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#URL.SRID#" />
			<CFEXIT>
		<CFELSE>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE&LOOKUPWO=FOUND&SRID=#URL.SRID#" />
			<CFEXIT>
		</CFIF>

	</CFIF>

     <TABLE width="100%" align="center" border="0">
          <TR>
               <TH align="center">
                    <H4>*Red fields marked with asterisks are required!</H4>
               </TH>
          </TR>
          <TR>
               <TH align="center">
                    Telephone Work Order Key &nbsp; = &nbsp; #FORM.TNSWO_ID#<BR />
                    Telephone Contact Phone: &nbsp;&nbsp;&nbsp;&nbsp;4-3500
               </TH>
          </TR>
     </TABLE>
     <BR clear="left" />
     
     <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES")>
          <CFSET PROGRAMNAME = "processtelephonewos.cfm?STAFFLOOP=YES">
     <CFELSEIF (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
          <CFSET PROGRAMNAME = "processtelephonewos.cfm?SRCALL=YES">
     <CFELSE>
          <CFSET PROGRAMNAME = "processtelephonewos.cfm">
     </CFIF>
     
     <TABLE width="100%" align="LEFT" border="0">
          <TR>
<CFFORM action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST">
               <TD align="left">
                    <INPUT type="hidden" name="PROCESSTELEPHONEWOS" value="CANCELADD" />
                    <INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
</CFFORM>
          </TR>
<CFFORM name="TELEPHONEWO" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
          <TR>
               <TH align="left" valign="TOP">SR</TH>
               <TH align="left" valign="TOP">Requestor</TH>
               <TH align="left" valign="TOP">Group</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">
                    #LookupServiceRequests.SERVICEREQUESTNUMBER#
               </TD>
               <TD align="left" valign ="TOP">
                    #LookupServiceRequests.FULLNAME#
                    <INPUT type="hidden" name="REQUESTERID" value="#LookupServiceRequests.REQUESTERID#" />
               </TD>
               <TD align="left" valign="TOP">
                    #LookupServiceRequests.GROUPNAME#
               </TD>
          </TR>
           <TR>
               <TH align="left" valign="TOP">SR Creation Date</TH>
               <TH align="left" valign="TOP">Requestor Location</TH>
               <TH align="left" valign="TOP">Staff Assignment</TH>
          </TR>
          <TR>
               <TD align="left" valign ="TOP">
                    #DateFormat(LookupServiceRequests.CREATIONDATE, 'mm/dd/yyyy')#
               </TD>
               <TD align="left" valign ="TOP">
                    #LookupServiceRequests.ROOMNUMBER#
               </TD>
               <TD align="left" valign="TOP">
                    #LookupSRStaffAssignments.FULLNAME#
                    <INPUT type="hidden" name="STAFFID" value="#LookupSRStaffAssignments.STAFFCUSTOMERID#" />
               </TD>
          </TR>
          <TR>
               <TH align="left"><LABEL for="WO_DUEDATE">Telephone WO Due Date</LABEL></TH>
               <TH align="left"><LABEL for="WO_TYPE">Telephone WO Type</LABEL></TH>
               <TH align="left"><LABEL for="WO_STATUS">Telephone WO Status</LABEL></TH>
          </TR>
          <TR>
               <TD align="left" valign ="TOP">
                    <CFINPUT type="Text" name="WO_DUEDATE" id="WO_DUEDATE" value="" align="LEFT" required="No" size="15" tabindex="2">
                    <SCRIPT language="JavaScript">
                         new tcal ({'formname': 'TELEPHONEWO','controlname': 'WO_DUEDATE'});

                    </SCRIPT>
               </TD>
               <TD align="left" valign="TOP">
                    <CFSELECT name="WO_TYPE" id="WO_TYPE" size="1" tabindex="3">
                         <OPTION value="TELEPHONE TYPE">TELEPHONE TYPE</OPTION>
                         <OPTION selected value="NEW PHONE">NEW PHONE</OPTION>
                         <OPTION value="MOVE PHONE">MOVE PHONE</OPTION>
                         <OPTION value="REPORT PHONE">REPORT PHONE</OPTION>
                    </CFSELECT>
               </TD>
               <TD align="left" valign="TOP">
                    <CFSELECT name="WO_STATUS" id="WO_STATUS" size="1" tabindex="4">
                         <OPTION selected value="PENDING">PENDING</OPTION>
                         <OPTION value="COMPLETE">COMPLETE</OPTION>
                    </CFSELECT>
               </TD>
               <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TH align="left" valign="BOTTOM">User First Name</TH>
               <TH align="left" valign="BOTTOM">User Last Name</TH>
               <TH align="left" valign="BOTTOM">User Category</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">#LookupServiceRequests.FIRSTNAME#</TD>
               <TD align="left" valign="TOP">#LookupServiceRequests.LASTNAME#</TD>
               <TD align="left" valign="TOP">#LookupServiceRequests.CATEGORYNAME#</TD>
          </TR>
          <TR>
               <TH align="left" valign="BOTTOM" colspan="2">Department</TH>
               <TH align="left" valign="BOTTOM">User E-Mail</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP" colspan="2">#LookupServiceRequests.DEPARTMENTNAME#</TD>
               <TD align="left" valign="TOP">#LookupServiceRequests.EMAIL#</TD>
          </TR>
          <TR>
               <TH align="left">User Phone</TH>
               <TH align="left">Contact By?</TH>
               <TH align="left"><LABEL for="DIALINGCAPABILITY">Dialing Capability</LABEL></TH>	
          </TR>
          <TR>
               <TD align="left">#LookupServiceRequests.CAMPUSPHONE#</TD>
               <TD align="left">#LookupServiceRequests.CONTACTBY#</TD>
               <TD align="left">
				<CFSELECT name="DIALINGCAPABILITY" id="DIALINGCAPABILITY" size="1" tabindex="5">
                    	<OPTION selected value="#LookupServiceRequests.DIALINGCAPABILITY#">#LookupServiceRequests.DIALINGCAPABILITY#</OPTION>
					<OPTION value="3-CAMPUS, LOCAL AND SD COUNTY">3-CAMPUS, LOCAL AND SD COUNTY</OPTION>
					<OPTION value="2-CAMPUS AND LOCAL">2-CAMPUS AND LOCAL</OPTION>
					<OPTION value="1-CAMPUS">1-CAMPUS</OPTION>
				</CFSELECT>
               </TD>
          </TR>
          <TR>
               <TH align="left"><LABEL for="VOICEMAIL">Voice Mail</LABEL></TH>
               <TH align="left"><LABEL for="PHONEBOOKLISTING">Phonebook Listing</LABEL></TH>
               <TH align="left">&nbsp;&nbsp;</TH>	
          </TR>
          <TR>
               <TD align="left">
				<CFSELECT name="VOICEMAIL" id="VOICEMAIL" size="1" tabindex="6">
                    	<OPTION selected value="#LookupServiceRequests.VOICEMAIL#">#LookupServiceRequests.VOICEMAIL#</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
               <TD align="left">
				<CFSELECT name="PHONEBOOKLISTING" id="PHONEBOOKLISTING" size="1" tabindex="7">
                    	<OPTION selected value="#LookupServiceRequests.PHONEBOOKLISTING#">#LookupServiceRequests.PHONEBOOKLISTING#</OPTION>
					<OPTION value="UNLISTED">UNLISTED</OPTION>
					<OPTION value="LISTED">LISTED</OPTION>
				</CFSELECT>
			</TD>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
           <TR>
               <TH align="left" valign="TOP"><LABEL for="NEW_LOCATION">New Location</LABEL></TH>
               <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
               <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">
                    <CFSELECT name="NEW_LOCATION" id="NEW_LOCATION" size="1" query="ListLocations" value="LOCATIONID" display="ROOMNUMBER" required="No" tabindex="8"></CFSELECT>
               </TD>
               <TD align="left" valign="TOP">
                    <INPUT type="image" src="/images/buttonAddLoc.jpg" name="AddLocation" value="ADD" alt="Add Location Record" onClick="window.open('/#application.type#apps/facilities/locationinfo.cfm?PROCESS=ADD&SRCALL=YES', 'Add Location Record','alwaysRaised=yes,dependent=no,width=800,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="9" /><BR>
                    <COM>If you have to add a new LOCATION record, click the "CANCEL ADD" button on this screen and open a new Add Telephone Work Order Screen.</COM>
               </TD>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TH align="left" valign="TOP">Current Jack Number</TH>
               <TH align="left" valign="TOP">New Jack Number</TH>
               <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP"> NONE </TD>
               <TD align="left" valign="TOP"> NEW</TD>
               <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TH align="left" valign="TOP" colspan="3"><H4><LABEL for="WORK_DESCRIPTION">*Work Description</LABEL></H4></TH>
          </TR>
          <TR>
               
			<CFSET SESSION.WORK_DESCRIPTION = REFind("CURRENT JACK/PORT:", LookupServiceRequests.PROBLEM_DESCRIPTION, 1, "True")>
               <CFSET SESSION.TEXTLEN = #SESSION.WORK_DESCRIPTION.pos[1]# - 1>
<!---                
               WORK DESCR Position = #SESSION.WORK_DESCRIPTION.pos[1]# &nbsp;&nbsp;&nbsp;&nbsp;WORK DESCR Length = #SESSION.WORK_DESCRIPTION.len[1]#<BR>
               Text length = #SESSION.TEXTLEN#<BR>
 --->
               <TD align="left" valign="TOP" colspan="3">
               <CFIF SESSION.WORK_DESCRIPTION.len[1] GT 0>
                    <CFSET SESSION.WORK_DESCRTEXT = LEFT(LookupServiceRequests.PROBLEM_DESCRIPTION, SESSION.TEXTLEN)>
 				<CFTEXTAREA name="WORK_DESCRIPTION" id="WORK_DESCRIPTION" rows="6" cols="100" wrap="PHYSICAL" required tabindex="10">#SESSION.WORK_DESCRTEXT#</CFTEXTAREA>
			<CFELSE>
 				<CFTEXTAREA name="WORK_DESCRIPTION" id="WORK_DESCRIPTION" rows="6" cols="100" wrap="PHYSICAL" required tabindex="10">#LookupServiceRequests.PROBLEM_DESCRIPTION#</CFTEXTAREA>
               </CFIF>
			</TD>
          </TR>
         <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TD align="left" valign="TOP" colspan="3">
                    <INPUT type="hidden" name="PROCESSTELEPHONEWOS" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="11" />
               </TD>
          </TR>
</CFFORM>
          <TR>
<CFFORM action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST">
               <TD align="left" valign="TOP" colspan="3">
                    <INPUT type="hidden" name="PROCESSTELEPHONEWOS" value="CANCELADD" />
                    <INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="12" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
</CFFORM>
          </TR>
          <TR>
               <TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
          </TR>
     </TABLE>

<CFELSE>

<!--- 
*****************************************************************************************
* The following code is the Look Up Process for Modify/Delete of Telephone Work Orders. *
*****************************************************************************************
 --->
 
     <CFIF NOT IsDefined('URL.LOOKUPWO')>

          <CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
               SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
               FROM		FISCALYEARS
               WHERE	(CURRENTFISCALYEAR = 'YES')
               ORDER BY	FISCALYEARID
          </CFQUERY>
     
          <CFQUERY name="LookupTelephoneWOs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	TNSWO_ID, SRID, WO_TYPE, WO_STATUS, STAFFID, CURRENT_JACKNUMBER, NEW_JACKNUMBER, HW_INVENTORYID, 
                         ACCOUNTNUMBER1, ACCOUNTNUMBER2, ACCOUNTNUMBER3, WORK_DESCRIPTION, JUSTIFICATION_DESCRIPTION, 
                         OTHER_DESCRIPTION, WO_DUEDATE, WO_NUMBER
               FROM		TNSWORKORDERS
               WHERE	TNSWO_ID > 0 AND
                         WO_TYPE LIKE ('%PHONE%')
               ORDER BY	WO_TYPE
          </CFQUERY>
     
          <CFIF LookupTelephoneWOs.RecordCount EQ 0>
               <SCRIPT language="JavaScript">
                    <!-- 
                         alert ("There are NO Telephone Work Orders on file.");
                    -->
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
               <CFEXIT>
          </CFIF>
     
          <CFQUERY name="LookupServiceRequestsCurrFY" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
                         SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
                         SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID,
                         SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID,
                         SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
                         SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
                         SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED, TNSWO.WO_NUMBER, TNSWO.WO_STATUS,
                    <CFIF #Client.SecurityFlag# EQ "No">
                         CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
                    <CFELSE>
                         CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || SR.SRCOMPLETED || ' - ' || TNSWO.WO_NUMBER || ' - ' || TNSWO.WO_STATUS AS LOOKUPKEY
                    </CFIF>
               FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST, TNSWORKORDERS TNSWO
               WHERE	(SR.SRID = 0 OR 
                         SR.SRID IN (#ValueList(LookupTelephoneWOs.SRID)#)) AND
                         (SR.REQUESTERID = CUST.CUSTOMERID AND
                    <CFIF #Client.SecurityFlag# EQ "No">
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = ' Completed?') AND
                    </CFIF>
                    	SR.SRID = TNSWO.SRID AND
                         SR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) 
               ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
          </CFQUERY>
          
          <CFQUERY name="LookupServiceRequestsPrevFYs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
                         SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
                         SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID,
                         SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID,
                         SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
                         SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
                         SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED, TNSWO.WO_NUMBER, TNSWO.WO_STATUS,
                    <CFIF #Client.SecurityFlag# EQ "No">
                         CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
                    <CFELSE>
                         CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || SR.SRCOMPLETED || ' - ' || TNSWO.WO_NUMBER || ' - ' || TNSWO.WO_STATUS AS LOOKUPKEY
                    </CFIF>
               FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST, TNSWORKORDERS TNSWO
               WHERE	(SR.SRID = 0 OR 
                         SR.SRID IN (#ValueList(LookupTelephoneWOs.SRID)#)) AND
                         (SR.REQUESTERID = CUST.CUSTOMERID AND
                    <CFIF #Client.SecurityFlag# EQ "No">
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = ' Completed?') AND
                    </CFIF>
                    	SR.SRID = TNSWO.SRID AND
                    	SR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) 
               ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
          </CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TD align="center"><H1>Modify/Delete Telephone Work Orders Lookup</H1></TD>
			</TR>
		</TABLE>
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>
		<BR clear="left" />
	
		<TABLE width="100%" align="LEFT" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=#URL.PROCESS#&LOOKUPWO=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="SRID1">*Requester/SR For Current Fiscal Year & CFY+1:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SRID1" id="SRID1" size="1" required="No" tabindex="2">
						<CFIF #Client.SecurityFlag# EQ "No">
                                   <OPTION value="0">CUSTOMER - Select SR </OPTION>
                              <CFELSE>
                                   <OPTION value="0">CUSTOMER - Select SR - Completed? - Select WO - WO Status</OPTION>
                              </CFIF>
                              <CFLOOP query="LookupServiceRequestsCurrFY">
                              	<OPTION value="#SRID#">#LOOKUPKEY#</OPTION>
                              </CFLOOP>  
                         </CFSELECT>
				</TD>
			</TR>
               <TR>
				<TH align="left" width="30%"><H4><LABEL for="SRID2">*Or Requester/SR For Previous Fiscal Years:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SRID2" id="SRID2" size="1" query="LookupServiceRequestsPrevFYs" value="SRID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left" width="33%">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" width="33%">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
******************************************************************************
* The following code is the Modify/Delete Process for Telephone Work Orders. *
******************************************************************************
 --->

		<CFIF IsDefined('FORM.SRID1') AND IsDefined('FORM.SRID2')>
			<CFIF FORM.SRID1 GT 0>
                    <CFSET FORM.SRID = #FORM.SRID1#>
               <CFELSE>
                    <CFSET FORM.SRID = #FORM.SRID2#>
               </CFIF>
          </CFIF>

		<CFIF IsDefined('FORM.SRID')>
			<CFCOOKIE name="SRID" secure="NO" value="#FORM.SRID#">
		<CFELSEIF IsDefined("URL.SRID")>
			<CFSET FORM.SRID = #val(URL.SRID)#>
			<CFCOOKIE name="SRID" secure="NO" value="#FORM.SRID#">
		</CFIF>

		<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
                         SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, CUST.LASTNAME, CUST.FIRSTNAME, CUST.CATEGORYID, CAT.CATEGORYNAME,
                         CUST.UNITID, U.UNITID, U.DEPARTMENTID, DEPT.DEPARTMENTNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.CONTACTBY,
                         CUST.DIALINGCAPABILITY, CUST.VOICEMAIL, CUST.PHONEBOOKLISTING, LOC.ROOMNUMBER, SR.ALTERNATE_CONTACTID,
                         SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID, SR.GROUPASSIGNEDID, IDTGROUP.GROUPID, IDTGROUP.GROUPNAME,
                         SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID, SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
                         SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
               FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC, GROUPASSIGNED IDTGROUP, 
               		LIBSHAREDDATAMGR.CATEGORIES CAT, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.DEPARTMENTS DEPT
			WHERE	SR.SRID > 0 AND
					SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SR.REQUESTERID = CUST.CUSTOMERID AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
                    	SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
                         CUST.CATEGORYID = CAT.CATEGORYID AND
                         CUST.UNITID = U.UNITID AND 
                         U.DEPARTMENTID = DEPT.DEPARTMENTID
			ORDER BY	LOOKUPKEY
		</CFQUERY>
          
          <CFQUERY name="GetSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.FULLNAME,
               		CUST.LOCATIONID, LOC.ROOMNUMBER, TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED, 
                         SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID
               FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC
               WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                         CUST.LOCATIONID = LOC.LOCATIONID AND
                         SRSA.NEXT_ASSIGNMENT = 'NO' AND
                         SRSA.NEXT_ASSIGNMENT_GROUPID = 0
               ORDER BY	SRSA.STAFF_ASSIGNEDID
          </CFQUERY>
     
		<CFQUERY name="GetTelephoneWOs" datasource="#application.type#SERVICEREQUESTS">
			SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, CUST.FULLNAME, 
               		CUST.LOCATIONID, LOC.ROOMNUMBER, TNSWO.NEW_LOCATION, TNSWO.WORK_DESCRIPTION,
                         TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER, TNSWO.PHONE_CURRENT_JACKNUMBER, TNSWO.PHONE_NEW_JACKNUMBER
			FROM		TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC
			WHERE	TNSWO.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
               		TNSWO.STAFFID = CUST.CUSTOMERID AND
                         CUST.LOCATIONID = LOC.LOCATIONID AND
          			TNSWO.WO_TYPE LIKE ('%PHONE%')
			ORDER BY	TNSWO.WO_TYPE
		</CFQUERY>

		<CFIF GetTelephoneWOs.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("This SR is NOT Associated with a Telephone Work Order.");
				-->
			</SCRIPT>
               <CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ 'YES') OR (IsDefined('client.STAFFLOOP') AND #client.STAFFLOOP# EQ 'YES'))>
                    <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#" />
                    <CFEXIT>
               <CFELSE>
               	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=ADD&SRID=#FORM.SRID#" />
                    <CFEXIT>
               </CFIF>
		</CFIF>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TD  align="center"><H1>Modify/Delete Telephone Work Orders</H1></TD>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align="center">
					Telephone Work Order Key &nbsp; = &nbsp; #GetTelephoneWOs.TNSWO_ID#<BR />
					Telephone Contact Phone: &nbsp;&nbsp;&nbsp;&nbsp;4-3500
					<CFCOOKIE name="TNSWO_ID" secure="NO" value="#GetTelephoneWOs.TNSWO_ID#">
				</TH>
			</TR>
		</TABLE>
          
          <BR clear="left" />
          
          <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES")>
               <CFSET PROGRAMNAME = "processtelephonewos.cfm?STAFFLOOP=YES">
          <CFELSEIF (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
               <CFSET PROGRAMNAME = "processtelephonewos.cfm?SRCALL=YES">
          <CFELSE>
               <CFSET PROGRAMNAME = "processtelephonewos.cfm">
          </CFIF>

		<TABLE width="100%" align="left" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" valign="TOP">
                    <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" /><BR />
                    <CFELSE>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    </CFIF>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="TELEPHONEWO" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
			<TR>
                    <TH align="left" valign="TOP">SR</TH>
                    <TH align="left" valign="TOP">Requestor</TH>
                    <TH align="left" valign="TOP">Group</TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP">
                         #GetServiceRequests.SERVICEREQUESTNUMBER#
                    </TD>
                    <TD align="left" valign ="TOP">
                         #GetServiceRequests.FULLNAME#
                         <INPUT type="hidden" name="REQUESTERID" value="#GetServiceRequests.REQUESTERID#" />
                    </TD>
                    <TD align="left" valign="TOP">
                         #GetServiceRequests.GROUPNAME#
                    </TD>
               </TR>
                <TR>
                    <TH align="left" valign="TOP">SR Creation Date</TH>
                    <TH align="left" valign="TOP">Requestor Location</TH>
                    <TH align="left" valign="TOP">Staff Assignment</TH>
               </TR>
               <TR>
                    <TD align="left" valign ="TOP">
                         #DateFormat(GetServiceRequests.CREATIONDATE, 'mm/dd/yyyy')#
                    </TD>
                    <TD align="left" valign ="TOP">
                         #GetServiceRequests.ROOMNUMBER#
                    </TD>
                    <TD align="left" valign="TOP">
                    <CFIF #GetTelephoneWOs.STAFFID# GT 0>
                         #GetTelephoneWOs.FULLNAME#
                    <CFELSE>
                    	#GetSRStaffAssignments.FULLNAME#
                    	<INPUT type="hidden" name="STAFFID" value="#GetSRStaffAssignments.STAFFCUSTOMERID#" />
                    </CFIF>
                    </TD>
               </TR>
               <TR>
                    <TH align="left" valign="TOP"><LABEL for="WO_DUEDATE">Telephone WO Due Date</LABEL></TH>
                    <TH align="left" valign="TOP"><LABEL for="WO_TYPE">Telephone WO Type</LABEL></TH>
				<TH align="left" valign="TOP">Staff Location</TH>
               </TR>
               <TR>
                    <TD align="left" valign ="TOP">
                         <CFINPUT type="Text" name="WO_DUEDATE" id="WO_DUEDATE" value="#DateFormat(GetTelephoneWOs.WO_DUEDATE, 'mm/dd/yyyy')#" align="LEFT" required="No" size="15" tabindex="2">
                         <SCRIPT language="JavaScript">
                              new tcal ({'formname': 'TELEPHONEWO','controlname': 'WO_DUEDATE'});
     
                         </SCRIPT>
                    </TD>
                    <TD align="left" valign="TOP">
                         <CFSELECT name="WO_TYPE" id="WO_TYPE" size="1" tabindex="3">
                         <CFIF GetTelephoneWOs.WO_TYPE NEQ "Telephone">
                              <OPTION selected value="#GetTelephoneWOs.WO_TYPE#">#GetTelephoneWOs.WO_TYPE#</OPTION>
                         </CFIF>
                              <OPTION value="TELEPHONE TYPE">TELEPHONE TYPE</OPTION>
                              <OPTION value="NEW PHONE">NEW PHONE</OPTION>
                              <OPTION value="MOVE PHONE">MOVE PHONE</OPTION>
                              <OPTION value="REPORT PHONE">REPORT PHONE</OPTION>
                         </CFSELECT>
                    </TD>
                    <TD align="left" valign="TOP">
                    	<CFIF #GetTelephoneWOs.STAFFID# GT 0>
                         	#GetTelephoneWOs.ROOMNUMBER#
                         <CFELSE>
                         	#GetSRStaffAssignments.ROOMNUMBER#
                         </CFIF>
                    </TD>
               </TR>
			<TR>
				<TH align="left" valign="TOP"><LABEL for="WO_NUMBER">Telephone WO Number</LABEL></TH>
                   	<TH align="left" valign="TOP"><LABEL for="WO_STATUS">Telephone WO Status</LABEL></TH>
				<TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="WO_NUMBER" id="WO_NUMBER" value="#GetTelephoneWOs.WO_NUMBER#" align="LEFT" required="No" size="20" tabindex="4">
				</TD>
                    <TD align="left" valign="TOP">
                         <CFSELECT name="WO_STATUS" id="WO_STATUS" size="1" tabindex="5">
                         	<OPTION selected value="#GetTelephoneWOs.WO_STATUS#">#GetTelephoneWOs.WO_STATUS#</OPTION>
                              <OPTION value="PENDING">PENDING</OPTION>
                              <OPTION value="COMPLETE">COMPLETE</OPTION>
                         </CFSELECT>
                    </TD>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
               <TR>
                    <TH align="left" valign="BOTTOM">User First Name</TH>
                    <TH align="left" valign="BOTTOM">User Last Name</TH>
                    <TH align="left" valign="BOTTOM">User Category</TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP">#GetServiceRequests.FIRSTNAME#</TD>
                    <TD align="left" valign="TOP">#GetServiceRequests.LASTNAME#</TD>
                    <TD align="left" valign="TOP">#GetServiceRequests.CATEGORYNAME#</TD>
               </TR>
               <TR>
                    <TH align="left" valign="BOTTOM" colspan="2">Department</TH>
                    <TH align="left" valign="BOTTOM">User E-Mail</TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP" colspan="2">#GetServiceRequests.DEPARTMENTNAME#</TD>
                    <TD align="left" valign="TOP">#GetServiceRequests.EMAIL#</TD>
               </TR>
               <TR>
                    <TH align="left">User Phone</TH>
                    <TH align="left">Contact By?</TH>
                    <TH align="left"><LABEL for="DIALINGCAPABILITY">Dialing Capability</LABEL></TH>	
               </TR>
               <TR>
                    <TD align="left">#GetServiceRequests.CAMPUSPHONE#</TD>
                    <TD align="left">#GetServiceRequests.CONTACTBY#</TD>
                    <TD align="left">
                         <CFSELECT name="DIALINGCAPABILITY" id="DIALINGCAPABILITY" size="1" tabindex="6">
                         	<OPTION selected value="#GetServiceRequests.DIALINGCAPABILITY#">#GetServiceRequests.DIALINGCAPABILITY#</OPTION>
                              <OPTION value="1-CAMPUS">1-CAMPUS</OPTION>
                              <OPTION value="2-CAMPUS AND LOCAL">2-CAMPUS AND LOCAL</OPTION>
                              <OPTION value="3-CAMPUS, LOCAL AND SD COUNTY">3-CAMPUS, LOCAL AND SD COUNTY</OPTION>
                         </CFSELECT>
                    </TD>
               </TR>
               <TR>
                    <TH align="left"><LABEL for="VOICEMAIL">Voice Mail</LABEL></TH>
                    <TH align="left"><LABEL for="PHONEBOOKLISTING">Phonebook Listing</LABEL></TH>
                    <TH align="left">&nbsp;&nbsp;</TH>	
               </TR>
               <TR>
                    <TD align="left">
                         <CFSELECT name="VOICEMAIL" id="VOICEMAIL" size="1" tabindex="7">
                         	<OPTION selected value="#GetServiceRequests.VOICEMAIL#">#GetServiceRequests.VOICEMAIL#</OPTION>
                              <OPTION value="NO">NO</OPTION>
                              <OPTION value="YES">YES</OPTION>
                         </CFSELECT>
                    </TD>
                    <TD align="left">
                         <CFSELECT name="PHONEBOOKLISTING" id="PHONEBOOKLISTING" size="1" tabindex="8">
                         	<OPTION selected value="#GetServiceRequests.PHONEBOOKLISTING#">#GetServiceRequests.PHONEBOOKLISTING#</OPTION>
                              <OPTION value="UNLISTED">UNLISTED</OPTION>
                              <OPTION value="LISTED">LISTED</OPTION>
                         </CFSELECT>
                    </TD>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
                <TR>
                    <TH align="left" valign="TOP"><LABEL for="NEW_LOCATION">New Location</LABEL></TH>
                    <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
                    <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP">
                         <CFSELECT name="NEW_LOCATION" id="NEW_LOCATION" size="1" query="ListLocations" value="LOCATIONID" display="ROOMNUMBER" selected="#GetTelephoneWOs.NEW_LOCATION#" required="No" tabindex="9"></CFSELECT>
                    </TD>
                    <TD align="left">&nbsp;&nbsp;</TD>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
               <TR>
                    <TH align="left"><LABEL for="PHONE_CURRENT_JACKNUMBER">Current Jack Number</LABEL></TH>
                    <TH align="left"><LABEL for="PHONE_NEW_JACKNUMBER">New Jack Number</LABEL></TH>
                    <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
               </TR>
               <TR>
                    <TD align="left" nowrap>
                    	<CFINPUT type="Text" name="PHONE_CURRENT_JACKNUMBER" id="PHONE_CURRENT_JACKNUMBER" value="#GetTelephoneWOs.PHONE_CURRENT_JACKNUMBER#" align="LEFT" required="No" size="20" tabindex="10">
                    </TD>
                    <TD align="left" nowrap>
                    	<CFINPUT type="Text" name="PHONE_NEW_JACKNUMBER" id="PHONE_NEW_JACKNUMBER" value="#GetTelephoneWOs.PHONE_NEW_JACKNUMBER#" align="LEFT" required="No" size="20" tabindex="11">
                    </TD>
                    <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
               </TR>
			<TR>
                    <TH align="left" valign="TOP" colspan="3"><H4><LABEL for="WORK_DESCRIPTION">*Work Description</LABEL></H4></TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP" colspan="3">
                         <CFTEXTAREA name="WORK_DESCRIPTION" id="WORK_DESCRIPTION" rows="6" cols="100" wrap="VIRTUAL" required="No" tabindex="12">#GetTelephoneWOs.WORK_DESCRIPTION#</CFTEXTAREA>
                    </TD>
               </TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
			<TR>
				<TD align="left" valign="TOP">
                    	<INPUT type="hidden" name="PROCESSTELEPHONEWOS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="13" />
                    </TD>
				<TD align="left" valign="TOP">
                    	<INPUT type="image" src="/images/buttonMODReview.jpg" value="MODIFY AND REVIEW" alt="Modify & Review" onClick="return setModReview();" tabindex="14" />
                    </TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="15" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" valign="TOP" colspan="2">
                    <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="16" /><BR />
                    <CFELSE>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="16" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    </CFIF>
				</TD>
</CFFORM>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>