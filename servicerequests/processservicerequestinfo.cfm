<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processservicerequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/10/2012 --->
<!--- Date in Production: 08/10/2012 --->
<!--- Module: Process Information to Service Requests--->
<!-- Last modified by John R. Pastori on 11/18/2015 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Service Requests</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">


<CFIF (FIND('MODIFY', #FORM.PROCESSSERVICEREQUEST#, 1) NEQ 0)>

	<CFQUERY name="LookupServiceRequest" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.GROUPASSIGNEDID
          FROM		SERVICEREQUESTS SR
          WHERE	SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_VARCHAR"> 
          ORDER BY	SR.SRID
     </CFQUERY>
 
 	<CFIF #LookupServiceRequest.GROUPASSIGNEDID# NEQ #FORM.GROUPASSIGNEDID# AND #LookupServiceRequest.GROUPASSIGNEDID# GT 0>
	    
          <CFQUERY name="LookupPrevStaffAssigned" datasource="#application.type#SERVICEREQUESTS">
               SELECT	WGA.WORKGROUPASSIGNSID, WGA.GROUPID, WGA.GROUPORDER
               FROM		WORKGROUPASSIGNS WGA
               WHERE	WGA.GROUPID = <CFQUERYPARAM value="#LookupServiceRequest.GROUPASSIGNEDID#" cfsqltype="CF_SQL_VARCHAR"> 
               ORDER BY	WGA.GROUPORDER
          </CFQUERY>
          
          <CFQUERY name="LookupStaffAssignsPrimary" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, SRSA.NEXT_ASSIGNMENT
               FROM		SRSTAFFASSIGNMENTS SRSA
               WHERE	SRSA.SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
               		SRSA.NEXT_ASSIGNMENT = 'NO' AND
                         SRSA.STAFF_ASSIGNEDID IN (#ValueList(LookupPrevStaffAssigned.WORKGROUPASSIGNSID)#)
               ORDER BY	SRSA.SRID
          </CFQUERY>

          <CFQUERY name="UpdateSRStaffAssignedCount" datasource="#application.type#SERVICEREQUESTS">
               UPDATE	SERVICEREQUESTS 
               SET		PG_STAFFASSIGNEDCOUNT = PG_STAFFASSIGNEDCOUNT - #LookupStaffAssignsPrimary.RecordCount#
               WHERE	(SRID = #val(Cookie.SRID)#)
          </CFQUERY>
               
          <CFQUERY name="LookupStaffAssignsNext" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, SRSA.NEXT_ASSIGNMENT
               FROM		SRSTAFFASSIGNMENTS SRSA
               WHERE	SRSA.SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
               		SRSA.NEXT_ASSIGNMENT = 'YES' AND
                         SRSA.STAFF_ASSIGNEDID IN (#ValueList(LookupPrevStaffAssigned.WORKGROUPASSIGNSID)#)
               ORDER BY	SRSA.SRID
          </CFQUERY>
     
          <CFQUERY name="UpdateSRStaffAssignedCount" datasource="#application.type#SERVICEREQUESTS">
               UPDATE	SERVICEREQUESTS 
               SET		NG_STAFFASSIGNEDCOUNT = NG_STAFFASSIGNEDCOUNT - #LookupStaffAssignsNext.RecordCount#
               WHERE	(SRID = #val(Cookie.SRID)#)
          </CFQUERY>
          
          <CFTRANSACTION action="begin">
          <CFQUERY name="DeleteSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
               DELETE FROM	SRSTAFFASSIGNMENTS 
               WHERE		SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
                              STAFF_ASSIGNEDID IN (#ValueList(LookupPrevStaffAssigned.WORKGROUPASSIGNSID)#)
          </CFQUERY>
          <CFTRANSACTION action = "commit"/>
		</CFTRANSACTION>

	</CFIF>

</CFIF>

</CFOUTPUT>


<CFIF (FIND('ADD', #FORM.PROCESSSERVICEREQUEST#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSSERVICEREQUEST#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSSERVICEREQUEST#, 1) EQ 0)>
	<CFOUTPUT>
     
     <CFTRANSACTION action="begin"> 
	<CFQUERY name="ModifyServiceRequests" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	SERVICEREQUESTS
		SET		SERVICEDESKINITIALSID = #val(FORM.SERVICEDESKINITIALSID)#,
				PROBLEM_SUBCATEGORYID = #val(FORM.PROBLEM_SUBCATEGORYID)#,
				PRIORITYID = #val(FORM.PRIORITYID)#,
			<CFIF IsDefined ('FORM.ASSIGN_PRIORITY')>
				ASSIGN_PRIORITY = #val(FORM.ASSIGN_PRIORITY)#,
			</CFIF>
				GROUPASSIGNEDID = #val(FORM.GROUPASSIGNEDID)#,
				SERVICETYPEID = #val(FORM.SERVICETYPEID)#,
				ACTIONID = #val(FORM.ACTIONID)#,
				OPERATINGSYSTEMID = #val(FORM.OPERATINGSYSTEMID)#,
			<CFIF IsDefined ('FORM.OPTIONID')>
				OPTIONID = #val(FORM.OPTIONID)#,
			<CFELSE>
				OPTIONID = 0,
			</CFIF>
               <CFIF IsDefined ('FORM.SRCOMPLETED')>
               	SRCOMPLETED = '#FORM.SRCOMPLETED#',
               </CFIF>
				PROBLEM_DESCRIPTION = UPPER('#FORM.PROBLEM_DESCRIPTION#')
		WHERE	(SRID = #val(Cookie.SRID)#)
	</CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
     
     </CFOUTPUT>
	<CFIF FIND('ADD', FORM.PROCESSSERVICEREQUEST, 1) NEQ 0>
     	<CFOUTPUT>

   		<CFIF IsDefined('FORM.BARCODENUMBER')>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
				SELECT	MAX(SREQUIPID) AS MAX_ID
				FROM		SREQUIPLOOKUP
			</CFQUERY>
			<CFSET FORM.SREQUIPID =  #val(GetMaxUniqueID.MAX_ID+1)#>
			<CFQUERY name="AddSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
				INSERT INTO	SREQUIPLOOKUP (SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE)
				VALUES		(#val(FORM.SREQUIPID)#, '#FORM.SERVICEREQUESTNUMBER#', '#FORM.BARCODENUMBER#')
			</CFQUERY>
		</CFIF>
          
		<H1>Data ADDED!</H1>
          
          <CFQUERY name="LookupServiceRequest" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, REQCUST.FULLNAME AS REQNAME, REQCUST.EMAIL AS RCEMAIL, 
               		SR.ALTERNATE_CONTACTID, ALTCUST.FULLNAME AS ALTNAME, ALTCUST.EMAIL AS ACEMAIL, P.PRIORITYNAME, SR.PROBLEM_DESCRIPTION
			FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, LIBSHAREDDATAMGR.CUSTOMERS ALTCUST, PRIORITY P
			WHERE	SRID = #val(Cookie.SRID)# AND
					SR.REQUESTERID = REQCUST.CUSTOMERID AND
                         SR.ALTERNATE_CONTACTID = ALTCUST.CUSTOMERID AND
					SR.PRIORITYID = P.PRIORITYID
			ORDER BY	SR.SRID
		</CFQUERY>
          
          <CFQUERY name="LookupAssigner" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, EMAIL
			FROM		CUSTOMERS CUST
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
					CUST.ACTIVE = 'YES'
			ORDER BY	CUST.FULLNAME
		</CFQUERY>
          
          <CFIF #LookupServiceRequest.ALTERNATE_CONTACTID# GT 0>
			<CFSET CCEMAIL = #LookupServiceRequest.ACEMAIL#>
               <CFSET ALTCONTACT = #LookupServiceRequest.ALTNAME#>
          <CFELSE>
               <CFSET CCEMAIL = "">
               <CFSET ALTCONTACT = "">
          </CFIF>
          
          </CFOUTPUT>
      
     
          <CFMAIL query = "LookupServiceRequest" 
                    to="#LookupServiceRequest.RCEMAIL#, libinfosys@mail.sdsu.edu"
                    from="#LookupAssigner.EMAIL#"
                    subject="New SR Number Assigned"
                    cc="#CCEMAIL#"		
          >

On #DateFormat(NOW(), 'mm/dd/yyyy')# your SR has been entered in the queue as:

     Requester               - #LookupServiceRequest.REQNAME#
     SR Number             - #LookupServiceRequest.SERVICEREQUESTNUMBER#  
     Priority                   - #LookupServiceRequest.PRIORITYNAME#
     Problem Description - #LEFT(LookupServiceRequest.PROBLEM_DESCRIPTION, 120)#

          </CFMAIL>    

		<CFOUTPUT> 


		<CFIF FORM.PROCESSSERVICEREQUEST EQ "ADD STAFF">
          	<CFSET CLIENT.PGMRETURN = "/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=ADD">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=ADD&SRID=#val(Cookie.SRID)#" />
               <CFEXIT>
		<CFELSE>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=ADD" />
               <CFEXIT>
		</CFIF>
 
          </CFOUTPUT>

	</CFIF>
	<CFOUTPUT>
	<CFIF FIND('MODIFY', #FORM.PROCESSSERVICEREQUEST#, 1) NEQ 0>
		<H1>Data MODIFIED!</H1>
		<CFIF NOT IsDefined('FORM.BARCODENUMBER')>
			<CFQUERY name="LookupSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
				SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
				FROM		SREQUIPLOOKUP
				WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#FORM.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
			</CFQUERY>
			<CFIF LookupSREquipLookup.RecordCount GT 0>
				<CFQUERY name="DeleteSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
					DELETE FROM	SREQUIPLOOKUP 
					WHERE		SERVICEREQUESTNUMBER = '#LookupSREquipLookup.SERVICEREQUESTNUMBER#'
				</CFQUERY>
			</CFIF>
		</CFIF>

          <CFIF ((IsDefined('FORM.SRCOMPLETERESET')) AND ((#FORM.SRCOMPLETERESET# EQ "YES" OR #FORM.SRCOMPLETERESET# EQ "VOIDED") AND (#FORM.SRCOMPLETED# EQ "NO")))>
          	<CFINCLUDE template = "processsrcompleted.cfm">
          </CFIF>

		<CFIF FORM.PROCESSSERVICEREQUEST EQ "MODIFY SR & Assign Staff">
          	<CFSET CLIENT.PGMRETURN = "/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=MODIFYDELETE">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=ADD&SRID=#val(Cookie.SRID)#&GROUPID=#FORM.GROUPASSIGNEDID#" />
               <CFEXIT>
		<CFELSE>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
               <CFEXIT>
		</CFIF>
	</CFIF>
     </CFOUTPUT>
</CFIF>

<CFOUTPUT>

<CFIF FORM.PROCESSSERVICEREQUEST EQ "VOID SR">
	<H1>SR Voided!</H1>
	<CFQUERY name="DeleteSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	SRSTAFFASSIGNMENTS 
		WHERE		SRID = #val(Cookie.SRID)#
	</CFQUERY>
     
     <CFQUERY name="VoidSR" datasource="#application.type#SERVICEREQUESTS">
          UPDATE	SERVICEREQUESTS
          SET		SERVICEREQUESTS.SRCOMPLETEDDATE = TO_DATE(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'),
                    SERVICEREQUESTS.SRCOMPLETED = 'VOIDED'
          WHERE	(SERVICEREQUESTS.SRID = #val(Cookie.SRID)#)
     </CFQUERY>
     <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
     <CFEXIT>
</CFIF>

<CFIF FORM.PROCESSSERVICEREQUEST EQ "CANCELADD">
	<H1>Data DELETED!</H1>
	<CFQUERY name="DeleteServiceRequests" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	SERVICEREQUESTS 
		WHERE		SRID = #val(Cookie.SRID)#
	</CFQUERY>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=ADD" />
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>