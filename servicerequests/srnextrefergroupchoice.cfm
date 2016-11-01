 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srnextrefergroupchoice.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/24/2012 --->
<!--- Date in Production: 05/24/2012 --->
<!--- Module: SR - Choose Next Referral Group --->
<!-- Last modified by John R. Pastori on 10/02/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/srnextrefergroupchoice.cfm">
<CFSET CONTENT_UPDATED = "October 02, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">


<HTML>
<HEAD>
	<TITLE>SR - Choose Next Referral Group</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
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
	
	
	function setAddGroupStaff() {
		document.LOOKUP.ADDNEXTGROUP.value = "Add Group & Add Staff";
		return true;
	}

	
	function validateNextStaffReqFields() {
	
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
				document.SRSTAFFASSIGN.STAFF_ASSIGNEDID[1].focus();
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
	
		if (document.SRSTAFFASSIGN.NEXT_ASSIGNMENT_REASON != null && (document.SRSTAFFASSIGN.NEXT_ASSIGNMENT_REASON.value == ""
		 || document.SRSTAFFASSIGN.NEXT_ASSIGNMENT_REASON.value == " ")) {
			alertuser ("You must enter a Next Assignment Reason.");
			document.SRSTAFFASSIGN.NEXT_ASSIGNMENT_REASON.focus();
			return false;
		}
	}
	
	
//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFIF NOT IsDefined("URL.LOOKUPGROUPID")>
	<CFSET CURSORFIELD = "document.LOOKUP.GROUPID.focus()">
	<CFSET SESSION.SRID = "#URL.SRID#">
<CFELSE>
	<CFSET CURSORFIELD = "document.SRSTAFFASSIGN.STAFF_ASSIGNEDID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFIF NOT (IsDefined('URL.PROCESS'))>
	<CFSET URL.PROCESS = 'ADD'>
</CFIF>

<CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ 'YES') OR (IsDefined('client.STAFFLOOP') AND #client.STAFFLOOP# EQ 'YES'))>
	<CFSET PROGRAMNAME = 'processsrstaffassigninfo.cfm?NEXTGROUPADD=YES&PROCESS=#URL.PROCESS#&STAFFLOOP=YES'>
	<CFSET CLIENT.STAFFLOOP = 'YES'>
<CFELSE>
	<CFSET PROGRAMNAME = 'processsrstaffassigninfo.cfm?NEXTGROUPADD=YES&PROCESS=#URL.PROCESS#'>
	<CFSET CLIENT.STAFFLOOP = 'NO'>
</CFIF>



<!--- 
***********************************************************************************************
* The following code is the Group Records Lookup Process for SR - Choose Next Referral Group. *
***********************************************************************************************
 --->
 
<CFIF NOT IsDefined("URL.LOOKUPGROUPID")>

     <CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
          SELECT	GROUPID, GROUPNAME
          FROM		GROUPASSIGNED
          ORDER BY	GROUPNAME
     </CFQUERY>
     
     <CFINCLUDE template="/include/coldfusion/formheader.cfm">
     
     <TABLE width="100%" align="center" border="3">
          <TR align="center">
               <TD align="center"><H1>SR - Choose Next Referral Group</H1></TD>
          </TR>
     </TABLE>
     <TABLE width="100%" align="center" border="0">
          <TR>
               <TD align="center"><H4>A Group Name MUST be chosen!</H4></TD>
          </TR>
     </TABLE>
     <BR />
     <TABLE width="100%" align="LEFT" border="0">
          <TR>
          <CFIF IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES">
          	<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
          <CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</CFIF>
          </TR>
<CFFORM name="LOOKUP" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/srnextrefergroupchoice.cfm?LOOKUPGROUPID=FOUND&PROCESS=#URL.PROCESS#" method="POST">
          <TR>
               <TH align="left"><H4><LABEL for="GROUPID">*Group</LABEL></H4></TH>
               <TH align="left">&nbsp;&nbsp;</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">
                    <CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" selected ="0" display="GROUPNAME" required="No" tabindex="2"></CFSELECT>
               </TD>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TD align="left">
               	<INPUT type="hidden" name="ADDNEXTGROUP" value="ADD GROUP" />
               	<INPUT type="image" src="/images/buttonAddGroup.jpg" value="ADD GROUP" alt="Add Group" tabindex="3" />
              </TD>
          <CFIF Client.MaintLessFlag EQ "No">
               <TD align="left"><INPUT type="image" src="/images/buttonAddGroupStaff.jpg" value="Add Group & Add Staff" alt="Add Group & Add Staff" onClick="return setAddGroupStaff();" tabindex="4" /></TD>
          <CFELSE>
          	<TD align="left">&nbsp;&nbsp;</TD>
          </CFIF>
          </TR>
</CFFORM>
          <TR>
          <CFIF IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES">
          	<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
          <CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</CFIF>
          </TR>
          <TR>
               <TD align="left" width="33%" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
          </TR>
     </TABLE>
     
     <CFEXIT>
<CFELSE>

<!--- 
************************************************************************************
* The following code assigns the Group member from the chosen Next Referral Group. *
************************************************************************************
 --->
 
 	<CFQUERY name="LookupSRRequester" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME
          FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	SR.SRID = <CFQUERYPARAM value="#SESSION.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    SR.REQUESTERID = CUST.CUSTOMERID
          ORDER BY	CUST.FULLNAME
     </CFQUERY>
     
     <CFCOOKIE name="SRID" secure="NO" value="#LookupSRRequester.SRID#">
     
     <CFQUERY name="ListOtherStaff" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, GA.GROUPID, GA.GROUPNAME,
          		CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS, SRSA.NEXT_ASSIGNMENT,
                    SRSA.NEXT_ASSIGNMENT_GROUPID, SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE,
				WGA.ACTIVE, SRSA.STAFF_COMPLETEDCOMMENTSID
		FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	SRSA.SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                    WGA.GROUPID = GA.GROUPID AND
				WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                    WGA.ACTIVE = 'YES' AND
                    SRSA.STAFF_ASSIGNEDID > 0
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListStaffAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER,
				WGA.ACTIVE, CUST.FULLNAME || ' - ' || WGA.GROUPORDER  || ' - ' ||  GA.GROUPNAME AS STAFFGROUP
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
          WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
				WGA.GROUPID = GA.GROUPID
				AND WGA.GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND 
			<CFIF ListOtherStaff.RecordCount GT 0>
               	NOT WGA.WORKGROUPASSIGNSID IN (#ValueList(ListOtherStaff.STAFF_ASSIGNEDID)#) AND
               </CFIF>
               	WGA.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
	</CFQUERY>
     
     <CFIF ListStaffAssigned.RecordCount EQ 0>
     	<SCRIPT language="JavaScript">
			<!-- 
				alert("All The Staff From This Group Have Been Assigned!  Choose another group.");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srnextrefergroupchoice.cfm?SRID=#Cookie.SRID#" />
		<CFEXIT>
	</CFIF>
				
  
 	<CFQUERY name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, SRSA.STAFF_DATEASSIGNED, SRSA.STAFF_TIME_WORKED, SRSA.STAFF_COMMENTS,
                    SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, IDTGROUP.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, SRSA.STAFF_COMPLETEDSR,
                    SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMPLETEDCOMMENTSID
          FROM		SRSTAFFASSIGNMENTS SRSA, GROUPASSIGNED IDTGROUP
          WHERE	(SRSA.SRID = <CFQUERYPARAM value="#SESSION.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
                    SRSA.NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_VARCHAR">) AND
                    (SRSA.STAFF_ASSIGNEDID = 0 AND
                    SRSA.NEXT_ASSIGNMENT_GROUPID = IDTGROUP.GROUPID AND
                    SRSA.STAFF_COMPLETEDSR = 'NO')
          ORDER BY	SRSA.STAFF_ASSIGNEDID
     </CFQUERY>
     
     <CFIF #LookupSRStaffAssignments.RecordCount# EQ 0>
     
          <CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
               SELECT	MAX(SRSTAFF_ASSIGNID) AS MAX_ID
               FROM		SRSTAFFASSIGNMENTS
          </CFQUERY>
          <CFSET FORM.NEXT_SRSTAFF_ASSIGNID = #val(GetMaxUniqueID.MAX_ID+1)#>
          <CFCOOKIE name="NEXT_SRSTAFF_ASSIGNID" secure="NO" value="#FORM.NEXT_SRSTAFF_ASSIGNID#">
          <CFQUERY name="AddSRStaffAssignmentsID" datasource="#application.type#SERVICEREQUESTS">
               INSERT INTO	SRSTAFFASSIGNMENTS (SRSTAFF_ASSIGNID, SRID, NEXT_ASSIGNMENT, NEXT_ASSIGNMENT_GROUPID)
               VALUES		(#val(Cookie.NEXT_SRSTAFF_ASSIGNID)#, #val(SESSION.SRID)#, 'YES', #val(FORM.GROUPID)#)
          </CFQUERY>
          
     <CFELSE>
     
          <CFSET FORM.NEXT_SRSTAFF_ASSIGNID = #LookupSRStaffAssignments.SRSTAFF_ASSIGNID#>
          <CFCOOKIE name="NEXT_SRSTAFF_ASSIGNID" secure="NO" value="#FORM.NEXT_SRSTAFF_ASSIGNID#">
     
     </CFIF>
     
     <CFIF IsDefined('FORM.ADDNEXTGROUP') AND #FORM.ADDNEXTGROUP# EQ "ADD GROUP">
     	<CFIF IsDefined('CLIENT.STAFFLOOP') AND #CLIENT.STAFFLOOP# EQ "YES">
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert("Group Added!");
                         window.close();
                     -->
               </SCRIPT>
               <CFEXIT>
          </CFIF>
     	<CFIF IsDefined ('CLIENT.PGMRETURN') AND FIND('servicerequestinfo.cfm', #CLIENT.PGMRETURN#, 1) NEQ 0>
               <META http-equiv="Refresh" content="0; URL=#CLIENT.PGMRETURN#" />
               <CFSET CLIENT.PGMRETURN = "">
              <CFEXIT>
          <CFELSE>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
               <CFEXIT>
          </CFIF>
     </CFIF>

 
 	<CFQUERY name="LookupWorkGroupMembers" datasource="#application.type#SERVICEREQUESTS" blockfactor="46">
          SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, WGA.GROUPID, GA.GROUPNAME, CUST.CUSTOMERID, CUST.FULLNAME, WGA.ACTIVE
          FROM		WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	WGA.GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    WGA.GROUPID = GA.GROUPID AND
                    WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
               <CFIF ListOtherStaff.RecordCount GT 0>
               	NOT WGA.WORKGROUPASSIGNSID IN (#ValueList(ListOtherStaff.STAFF_ASSIGNEDID)#) AND
               </CFIF>
                    WGA.ACTIVE = 'YES'
          ORDER BY	CUST.FULLNAME
     </CFQUERY>
     
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add SR Next Referral Staff Assignment</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
     <TR>
          <TH align="center">
               <H4>*Red fields marked with asterisks are required!</H4><BR>
               SR Staff Assignment Key &nbsp; = &nbsp; #Cookie.NEXT_SRSTAFF_ASSIGNID#<BR>
               For Service Request Number: #LookupSRRequester.SERVICEREQUESTNUMBER#
          </TH>
     </TR>
</TABLE>
	<BR clear="left" />

	<TABLE align="left" width="100%" border="0">
		<TR>

<CFFORM action="/#application.type#apps/servicerequests/processsrstaffassigninfo.cfm?POPUP=CLOSE" method="POST">
			<TD align="left" width="33%">
               	<INPUT type="hidden" name="PROCESSSRSTAFFASSIGNS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR><BR>
               </TD>
</CFFORM>
		</TR>
     </TABLE>
     
	<BR />
     <FIELDSET>
     <LEGEND>Referral Group/Staff Assignment</LEGEND>
<CFFORM name="SRSTAFFASSIGN" onsubmit="return validateNextStaffReqFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
     <TABLE width="100%" border="0">
		<TR>
			<TH align="left" width="33%">Referral Group Assigned</TH>
			<TH align="left" width="33%"><LABEL for="STAFF_ASSIGNEDID">Staff Assigned</LABEL></TH>
			<TH align="left" width="33%"><LABEL for="STAFF_DATEASSIGNED">Date Staff Assigned</LABEL></TH>
          </TR>
		<TR>
			<TD align="left" width="33%" valign="TOP">
                	#LookupWorkGroupMembers.GROUPNAME#
               </TD>
               
			<TD align="left" width="33%" valign="TOP">
               	<INPUT type="hidden" name="SRID" value="#SESSION.SRID#" />
                    <INPUT type="hidden" name="REQUESTER" value="#LookupSRRequester.FULLNAME#" />
                    <INPUT type="hidden" name="NEXT_SRSTAFF_ASSIGNID" value="#Cookie.NEXT_SRSTAFF_ASSIGNID#" />
                     <CFLOOP query = "LookupWorkGroupMembers">
                         <CFINPUT type="Checkbox" name="STAFF_ASSIGNEDID" id="STAFF_ASSIGNEDID" value="#WORKGROUPASSIGNSID#" tabindex="2">#FULLNAME#<BR>
                    </CFLOOP>
			</TD>
			<TD align="left" width="33%" valign="TOP">
				<CFSET FORM.STAFF_DATEASSIGNED = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
				<CFINPUT type="Text" name="STAFF_DATEASSIGNED" id="STAFF_DATEASSIGNED" value="#DateFormat(FORM.STAFF_DATEASSIGNED, "mm/dd/yyyy")#" align="LEFT" required="No" size="15" tabindex="3">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'STAFFSRASSIGN','controlname': 'STAFF_DATEASSIGNED'});

				</SCRIPT>
			</TD>
		</TR>
          <TR>
			<TH align="left" colspan="3"><H4><LABEL for="NEXT_ASSIGNMENT_REASON">*Reason for Next Assignment</LABEL></H4></TH>
			
		</TR>
		<TR>
			<TD align="left" colspan="3">
               	<INPUT type="hidden" name="NEXT_ASSIGNMENT" value="YES" />
                    <INPUT type="hidden" name="NEXT_ASSIGNMENT_GROUPID" value="#FORM.GROUPID#" />
				<TEXTAREA name="NEXT_ASSIGNMENT_REASON" id="NEXT_ASSIGNMENT_REASON" wrap="VIRTUAL" rows="4" cols="25" tabindex="4"></TEXTAREA>
			</TD>
		</TR>
     </TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Record Processing</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSSRSTAFFASSIGNS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="5" />
               </TD>
		</TR>
     </TABLE>
     </FIELDSET>
	<BR clear="left" />
     
</CFFORM>

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processsrstaffassigninfo.cfm?POPUP=CLOSE" method="POST">
			<TD align="left" width="33%">
               	<INPUT type="hidden" name="PROCESSSRSTAFFASSIGNS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="6" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR><BR>
               </TD>
</CFFORM>
		</TR>
          <TR>
               <TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
          </TR>
     </TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>