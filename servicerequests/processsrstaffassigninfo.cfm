<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsrstaffassigninfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/13/2012 --->
<!--- Date in Production: 09/13/2012 --->
<!--- Module: Process Information to SR Staff Assignments --->
<!-- Last modified by John R. Pastori on 07/14/2016 using ColdFusion Studio. -->

<cfinclude template = "../programsecuritycheck.cfm">

<cfif (FIND('joel', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
	<cfset SESSION.ORIGINSERVER = "JOEL">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html>
<head>
	<title>Process Information to SR Staff Assignments</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />
</head>

<body>

<cfoutput>

<cfinclude template="/include/coldfusion/formheader.cfm">

<cfset FORM.UPDATEKEY = 0>

<cfif IsDefined('FORM.NEXT_SRSTAFF_ASSIGNID') AND #FORM.NEXT_SRSTAFF_ASSIGNID# GT 0>
	<cfset FORM.UPDATEKEY = #FORM.NEXT_SRSTAFF_ASSIGNID#>
</cfif>
<cfif IsDefined('FORM.SRSTAFF_ASSIGNID') AND #FORM.SRSTAFF_ASSIGNID# GT 0>
	<cfset FORM.UPDATEKEY = #FORM.SRSTAFF_ASSIGNID#>
</cfif>

<cfif IsDefined('FORM.PROCESSSRSTAFFASSIGNS') AND FIND('CANCEL', #FORM.PROCESSSRSTAFFASSIGNS#, 1) EQ 0>
	<cfset SESSION.ARRAYCOUNT = 0>
     <cfset SESSION.LOOPCOUNT = 0>
     <cfset SESSION.STAFF_ASSIGNEDID_ARRAY = ArrayNew(1)>
     <cfset temp = ArraySet(SESSION.STAFF_ASSIGNEDID_ARRAY, 1, #ListLen(FORM.STAFF_ASSIGNEDID)#, 0)>
	<cfif IsDefined('FORM.STAFF_DATEASSIGNED')>
		<cfset FORM.STAFF_DATEASSIGNED = #DateFormat(FORM.STAFF_DATEASSIGNED, 'dd-mmm-yyyy')#>
	</cfif>
</cfif>

<cfset SESSION.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>

</cfoutput>


<!--- 
********************************************************************
* The following code is the Add Processes for SR Staff Assignments *
********************************************************************
 --->
<cfif (FIND('ADD', #FORM.PROCESSSRSTAFFASSIGNS#, 1) NEQ 0 AND FIND('CANCEL', #FORM.PROCESSSRSTAFFASSIGNS#, 1) EQ 0)>
	<cfoutput>
     
     <cfset SESSION.STAFF_ASSIGNEDID_ARRAY = #ListToArray(FORM.STAFF_ASSIGNEDID)#>
     <cfset SESSION.ARRAYCOUNT = (ArrayLen(SESSION.STAFF_ASSIGNEDID_ARRAY))>

     <cfloop index = "SESSION.LOOPCOUNT" from="1" to="#SESSION.ARRAYCOUNT#">
     
     	<cfset FORM.STAFF_ASSIGNEDID = SESSION.STAFF_ASSIGNEDID_ARRAY[#SESSION.LOOPCOUNT#]>

		<cftransaction action="begin">
          <cfquery name="UpdateSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
               UPDATE	SRSTAFFASSIGNMENTS
               SET	
                    <CFIF IsDefined('FORM.STAFF_ASSIGNEDID')>
                         STAFF_ASSIGNEDID = #val(FORM.STAFF_ASSIGNEDID)#,
                    </CFIF>
                    <CFIF IsDefined('FORM.STAFF_DATEASSIGNED')>
                         STAFF_DATEASSIGNED = TO_DATE('#FORM.STAFF_DATEASSIGNED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
                    </CFIF>
                    <CFIF IsDefined('FORM.STAFF_TIME_WORKED')>
                         STAFF_TIME_WORKED = #val(FORM.STAFF_TIME_WORKED)#,
                    </CFIF>
                    <CFIF IsDefined('FORM.STAFF_COMMENTS')>
                         STAFF_COMMENTS = UPPER('#FORM.STAFF_COMMENTS#'),
                    </CFIF>
                    <CFIF IsDefined('FORM.NEXT_ASSIGNMENT')>
                         NEXT_ASSIGNMENT = UPPER('#FORM.NEXT_ASSIGNMENT#'),
                    </CFIF>
                    <CFIF IsDefined('FORM.NEXT_ASSIGNMENT_GROUPID')>
                         NEXT_ASSIGNMENT_GROUPID = #val(FORM.NEXT_ASSIGNMENT_GROUPID)#,
                    </CFIF>
                    <CFIF IsDefined('FORM.NEXT_ASSIGNMENT_REASON')>
                         NEXT_ASSIGNMENT_REASON = UPPER('#FORM.NEXT_ASSIGNMENT_REASON#'),
                    </CFIF>
                    <CFIF IsDefined('FORM.STAFF_COMPLETEDCOMMENTSID')>
                         STAFF_COMPLETEDCOMMENTSID = #val(FORM.STAFF_COMPLETEDCOMMENTSID)#,
                    </CFIF>
                    	MODIFIEDDATE = TO_DATE('#SESSION.MODIFIEDDATE#', 'DD-MON-YYYY')
               WHERE	(SRSTAFF_ASSIGNID = #val(FORM.UPDATEKEY)#)
          </cfquery>
          <cftransaction action = "commit"/>
		</cftransaction>
          
          <h1>Data ADDED!</h1>
          
          <cfif #FORM.NEXT_ASSIGNMENT# EQ "NO">
                
               <cfquery name="ModifyServiceRequests" datasource="#application.type#SERVICEREQUESTS">
                    UPDATE	SERVICEREQUESTS
                    SET		PG_STAFFASSIGNEDCOUNT = PG_STAFFASSIGNEDCOUNT + 1
                    WHERE	(SRID = #val(Cookie.SRID)#)
               </cfquery>

          <cfelse>
          
          	<cfquery name="ModifyServiceRequests" datasource="#application.type#SERVICEREQUESTS">
                    UPDATE	SERVICEREQUESTS
                    SET		NG_STAFFASSIGNEDCOUNT = NG_STAFFASSIGNEDCOUNT + 1
                    WHERE	(SRID = #val(Cookie.SRID)#)
               </cfquery>
          
          </cfif>
          	
		<h1>SR Data MODIFIED!</h1>
                    
          <cfif #SESSION.LOOPCOUNT# LT #SESSION.ARRAYCOUNT#>
               <cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	MAX(SRSTAFF_ASSIGNID) AS MAX_ID
                    FROM		SRSTAFFASSIGNMENTS
               </cfquery>
               <cfset FORM.UPDATEKEY = #val(GetMaxUniqueID.MAX_ID+1)#>
               <cfquery name="AddSRStaffAssignmentsID" datasource="#application.type#SERVICEREQUESTS">
                    INSERT INTO	SRSTAFFASSIGNMENTS (SRSTAFF_ASSIGNID, SRID)
                    VALUES		(#val(FORM.UPDATEKEY)#, #val(Cookie.SRID)#)
               </cfquery>
          </cfif>
     </cfloop>
	</cfoutput>
     
     <cfset SESSION.LOOPCOUNT = 0>

	<cfloop index = "SESSION.LOOPCOUNT" from="1" to="#SESSION.ARRAYCOUNT#">
     	<cfset FORM.STAFF_ASSIGNEDID = SESSION.STAFF_ASSIGNEDID_ARRAY[#SESSION.LOOPCOUNT#]>
		<cfif FORM.STAFF_ASSIGNEDID GT 0>
           	
			<cfoutput>
				<cfquery name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS">
					SELECT	WGA.WORKGROUPASSIGNSID, SRSA.SRID, WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT, CUST.CUSTOMERID, CUST.FULLNAME,
                         		WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER, CUST.EMAIL AS STAFF_EMAIL
					FROM		WORKGROUPASSIGNS WGA, SRSTAFFASSIGNMENTS SRSA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA, LIBSHAREDDATAMGR.UNITS U
					WHERE	WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#FORM.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         		WGA.WORKGROUPASSIGNSID = SRSA.STAFF_ASSIGNEDID AND
                                   SRSA.SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
							WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
							WGA.GROUPID = GA.GROUPID AND
							CUST.UNITID = U.UNITID
					ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
				</cfquery>
                    
                    <cfquery name="LookupAssigner" datasource="#application.type#LIBSHAREDDATA">
					SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, EMAIL
					FROM		CUSTOMERS CUST
					WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
							CUST.ACTIVE = 'YES'
					ORDER BY	CUST.FULLNAME
				</cfquery>
                    
                    <cfquery name="LookupSRInfo1" datasource="#application.type#SERVICEREQUESTS">
                         SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, REQ.CUSTOMERID, REQ.FULLNAME AS REQUESTER, REQ.EMAIL, REQ.CAMPUSPHONE,
                         		SR.PROBLEM_CATEGORYID, PROBCAT.CATEGORYLETTER || PROBCAT.CATEGORYNAME AS PROBCATEGORY, SR.PROBLEM_SUBCATEGORYID, 
                                   PROBSUBCAT.SUBCATEGORYNAME AS PROBSUBCATEGORY, SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, 
                                   SR.PROBLEM_DESCRIPTION, SR.PG_STAFFASSIGNEDCOUNT, SR.NG_STAFFASSIGNEDCOUNT
                         FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQ, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY
                         WHERE	SR.SRID = <CFQUERYPARAM value="#LookupStaffAssigned.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
                                   SR.REQUESTERID = REQ.CUSTOMERID AND
                                   SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
                                   SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
                                   SR.PRIORITYID = PRIORITY.PRIORITYID
                         ORDER BY	REQUESTER
                    </cfquery>
                    
                     <cfif #LookupStaffAssigned.NEXT_ASSIGNMENT# EQ "YES">
          			<cfset PRIMARYNEXTASSIGN = "NEXT ASSIGNED">
     			<cfelse>
     				<cfset PRIMARYNEXTASSIGN = "PRIMARY">
     			</cfif>

				<cfif #LookupSRInfo1.PG_STAFFASSIGNEDCOUNT# EQ 1 AND #LookupSRInfo1.NG_STAFFASSIGNEDCOUNT# EQ 0>
                    	<cfset CCEMAIL = #LookupSRInfo1.EMAIL#>
                    <cfelse>
                    	<cfset CCEMAIL = "">
     			</cfif>
                    
			</cfoutput>
       		<cfif NOT (LookupStaffAssigned.CUSTOMERID EQ Client.CUSTOMERID)>  	
                    <cfmail query = "LookupStaffAssigned" 
                         to="#LookupStaffAssigned.STAFF_EMAIL#"
                         from="#LookupAssigner.EMAIL#"
                         subject="New SR for #FORM.REQUESTER#"
                         cc="#CCEMAIL#"
                    >

On #DateFormat(NOW(), 'mm/dd/yyyy')# you (#LookupStaffAssigned.STAFF_EMAIL#) have been assigned as #PRIMARYNEXTASSIGN# for:

     Requester                 - #LookupSRInfo1.REQUESTER#
     Requester Phone     - #LookupSRInfo1.CAMPUSPHONE#
     SR Number               - #LookupSRInfo1.SERVICEREQUESTNUMBER#  
     Priority                        - #LookupSRInfo1.PRIORITYNAME#
     Problem Category     - #LookupSRInfo1.PROBCATEGORY#
     Sub-Category             - #LookupSRInfo1.PROBSUBCATEGORY#
     Problem Description - #LookupSRInfo1.PROBLEM_DESCRIPTION#
				</cfmail>
               </cfif>
		</cfif>
     </cfloop>
	<cfoutput>
     
     <cfif IsDefined ('URL.NEXTGROUPADD') AND #URL.NEXTGROUPADD# EQ "YES">
     	<cfif #URL.PROCESS# EQ "ADD">
          	<cfif IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES">
				<script language="JavaScript">
                         <!-- 
                              alert("Data Added!");
                              window.close();
                          -->
                    </script>
                    <cfexit>
               </cfif>
          	<cfif IsDefined ('CLIENT.PGMRETURN') AND FIND('.cfm', #CLIENT.PGMRETURN#, 1) NEQ 0>
                    <meta http-equiv="Refresh" content="0; URL=#CLIENT.PGMRETURN#" />
                    <cfset CLIENT.PGMRETURN = "">
                   <cfexit>
               <cfelse>
                    <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=ADD" />
                    <cfexit>
               </cfif>
          </cfif>
		<cfif URL.PROCESS EQ 'MODIFY'>
               <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
               <cfexit>
          </cfif>
     	<cfif URL.PROCESS EQ 'MODIFY LOOP'>
			<cfif session.ArrayCounter EQ ARRAYLEN(session.SRSTAFFASSIGNArray)>
                    <h1>All Selected Records Processed!</h1>
                    <meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm" />
                    <cfexit>
                <cfelse>
                    <h1>Process Next Record</h1>
                    <meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm?LOOKUPSTAFFID=FOUND" />
                    <cfexit>    
                </cfif>  
          </cfif>
          <cfif URL.PROCESS EQ 'ASSIGN LOOP'>
         		<cfif session.ArrayCounter EQ ARRAYLEN(session.SRIDArray)>
                    <h1>All Selected Records Processed!</h1>
                    <meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/srstaffassignloop.cfm" />
                    <cfexit>
               <cfelse>
                    <h1>Process Next Record</h1>
                    <meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/srstaffassignloop.cfm?LOOKUPGROUPID=FOUND" />
                    <cfexit>
               </cfif>
          </cfif>
     <cfelseif #FORM.PROCESSSRSTAFFASSIGNS# EQ "ADD" AND IsDefined ('CLIENT.PGMRETURN') AND FIND('.cfm', #CLIENT.PGMRETURN#, 1) NEQ 0>
     	<meta http-equiv="Refresh" content="0; URL=#CLIENT.PGMRETURN#" />
      	<cfset CLIENT.PGMRETURN = "">
         <cfexit>
     <cfelse>
          <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=ADD" />
          <cfexit>
     </cfif>
     </cfoutput>
     
     <cfexit>
     
</cfif>



<!--- 
*********************************************************************
* The following code is the Modify Process for SR Staff Assignments *
*********************************************************************
 --->

<cfif FIND('MODIFY', #FORM.PROCESSSRSTAFFASSIGNS#, 1) NEQ 0 >
<!--- Execute MODIFYLOOP Logic --->
<cfoutput>

	<cfquery name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID 
          FROM		SRSTAFFASSIGNMENTS SRSA
          WHERE	SRSA.SRSTAFF_ASSIGNID = #val(FORM.SRSTAFF_ASSIGNID)#
     </cfquery>
     
     <cfif LookupSRStaffAssignments.STAFF_ASSIGNEDID EQ 0>
     	<cfif #FORM.NEXT_ASSIGNMENT# EQ "NO">
               <cftransaction action="begin">
               <cfquery name="UpdateSRStaffAssignedCount" datasource="#application.type#SERVICEREQUESTS">
                    UPDATE	SERVICEREQUESTS 
                    SET		PG_STAFFASSIGNEDCOUNT = PG_STAFFASSIGNEDCOUNT + 1
                    WHERE	(SRID = #val(FORM.SRID)#)
               </cfquery>
               <cftransaction action = "commit"/>
               </cftransaction>
          <cfelse>
          	<cftransaction action="begin">
               <cfquery name="UpdateSRStaffAssignedCount" datasource="#application.type#SERVICEREQUESTS">
                    UPDATE	SERVICEREQUESTS 
                    SET		NG_STAFFASSIGNEDCOUNT = NG_STAFFASSIGNEDCOUNT + 1
                    WHERE	(SRID = #val(FORM.SRID)#)
               </cfquery>
               <cftransaction action = "commit"/>
               </cftransaction>
          </cfif>
     </cfif>

	<cftransaction action="begin">
	<cfquery name="UpdateSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	SRSTAFFASSIGNMENTS
		SET		
			<CFIF IsDefined('FORM.STAFF_ASSIGNEDID')>
				STAFF_ASSIGNEDID = #val(FORM.STAFF_ASSIGNEDID)#,
			</CFIF>
			<CFIF IsDefined('FORM.STAFF_DATEASSIGNED')>
				STAFF_DATEASSIGNED = TO_DATE('#FORM.STAFF_DATEASSIGNED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
			<CFIF IsDefined('FORM.STAFF_TIME_WORKED')>
				STAFF_TIME_WORKED = #val(FORM.STAFF_TIME_WORKED)#,
			</CFIF>
			<CFIF IsDefined('FORM.STAFF_COMMENTS')>
				STAFF_COMMENTS = UPPER('#FORM.STAFF_COMMENTS#'),
			</CFIF>
			<CFIF IsDefined('FORM.NEXT_ASSIGNMENT')>
				NEXT_ASSIGNMENT = UPPER('#FORM.NEXT_ASSIGNMENT#'),
			</CFIF>
			<CFIF IsDefined('FORM.NEXT_ASSIGNMENT_GROUPID')>
				NEXT_ASSIGNMENT_GROUPID = #val(FORM.NEXT_ASSIGNMENT_GROUPID)#,
			</CFIF>
			<CFIF IsDefined('FORM.NEXT_ASSIGNMENT_REASON')>
				NEXT_ASSIGNMENT_REASON = UPPER('#FORM.NEXT_ASSIGNMENT_REASON#'),
			</CFIF>
               <CFIF IsDefined('FORM.STAFF_COMPLETEDCOMMENTSID')>
               	STAFF_COMPLETEDCOMMENTSID = #val(FORM.STAFF_COMPLETEDCOMMENTSID)#,
			</CFIF>
			<CFIF IsDefined('FORM.STAFF_ASSIGNMENT_ORDER')>
               	STAFF_ASSIGNMENT_ORDER = #val(FORM.STAFF_ASSIGNMENT_ORDER)#,
			</CFIF>
               <CFIF IsDefined('FORM.STAFF_COMPLETEDSR') AND #FORM.STAFF_COMPLETEDSR# EQ 'NO'>
               	STAFF_COMPLETEDSR = UPPER('#FORM.STAFF_COMPLETEDSR#'),
			</CFIF>
               	MODIFIEDDATE = TO_DATE('#SESSION.MODIFIEDDATE#', 'DD-MON-YYYY')
		WHERE	SRSTAFF_ASSIGNID = #val(FORM.UPDATEKEY)#
	</cfquery>
     <cftransaction action = "commit"/>
	</cftransaction>

     <h1>Data MODIFIED!</h1>
</cfoutput>

     <cfif (#FORM.PROCESSSRSTAFFASSIGNS# EQ "MODIFY TO COMPLETION" OR #FORM.PROCESSSRSTAFFASSIGNS# EQ "MODIFY LOOP TO COMPLETION") OR ((IsDefined('FORM.SRCOMPLETERESET')) AND (#FORM.SRCOMPLETERESET# EQ "YES" OR #FORM.SRCOMPLETERESET# EQ "VOIDED"))>

          <cfinclude template = "processsrcompleted.cfm">
          
          <cfif (((IsDefined('SESSION.PRIMARYGROUP')) AND (#SESSION.PRIMARYGROUP# EQ "ES/LIB" OR #SESSION.PRIMARYGROUP# EQ "ES/AA")) OR ((IsDefined('SESSION.NEXTGROUP')) AND (#SESSION.NEXTGROUP# EQ "ES/LIB" OR #SESSION.NEXTGROUP# EQ "ES/AA")))>
          
          	<cfquery name="LookupStaffCustomer" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.FULLNAME, CUST.EMAIL, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER
                    FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
                    WHERE	WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#FORM.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
                              WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                              WGA.GROUPID = GA.GROUPID
                    ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
               </cfquery>
               
               <cfquery name="LookupSRInfo2" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, REQ.CUSTOMERID, REQ.FULLNAME AS REQUESTER, REQ.EMAIL, 
                              SR.PROBLEM_CATEGORYID, PROBCAT.CATEGORYLETTER || PROBCAT.CATEGORYNAME AS PROBCATEGORY, SR.PROBLEM_SUBCATEGORYID, 
                              PROBSUBCAT.SUBCATEGORYNAME AS PROBSUBCATEGORY, SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.GROUPASSIGNEDID, SR.PROBLEM_DESCRIPTION,
                              SR.PG_STAFFASSIGNEDCOUNT, SR.NG_STAFFASSIGNEDCOUNT
                    FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQ, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY
                    WHERE	SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
                              SR.REQUESTERID = REQ.CUSTOMERID AND
                              SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
                              SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
                              SR.PRIORITYID = PRIORITY.PRIORITYID
                    ORDER BY	REQUESTER
               </cfquery>
          
			<cfmail
                    to="libinfosys@mail.sdsu.edu"
				from="#LookupStaffCustomer.EMAIL#"
				subject="SR #LookupSRInfo2.SERVICEREQUESTNUMBER# Assignment for #LookupStaffCustomer.FULLNAME# is Complete. "
			>

On #DateFormat(NOW(), 'mm/dd/yyyy')# #LookupStaffCustomer.FULLNAME# Completed their assignment for SR #LookupSRInfo2.SERVICEREQUESTNUMBER#:

     Requester                 - #LookupSRInfo2.REQUESTER#
     SR Number               - #LookupSRInfo2.SERVICEREQUESTNUMBER#  
     Priority                     - #LookupSRInfo2.PRIORITYNAME#
     Problem Category     - #LookupSRInfo2.PROBCATEGORY#
     Sub-Category               - #LookupSRInfo2.PROBSUBCATEGORY#
     Problem Description - #LookupSRInfo2.PROBLEM_DESCRIPTION#
			</cfmail>
		</cfif>
     </cfif>

<cfoutput>	

     <cfif FIND('MODIFY LOOP', #FORM.PROCESSSRSTAFFASSIGNS#, 1) NEQ 0>
          <cfif session.ArrayCounter EQ ARRAYLEN(session.SRSTAFFASSIGNArray)>
               <h1>All Selected Records Processed!</h1>
               <meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm" />
               <cfexit>
          <cfelse>
               <h1>Process Next Record</h1>
               <meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm?LOOKUPSTAFFID=FOUND" />
               <cfexit>
          </cfif>

     <cfelseif IsDefined('URL.LIST_LOOKUP') AND #URL.LIST_LOOKUP# EQ "LOOKUP">
     
     	<cfquery name="LookupStaffCustomer" datasource="#application.type#SERVICEREQUESTS">
			SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER
			FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
			WHERE	WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#FORM.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
					WGA.GROUPID = GA.GROUPID
			ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
		</cfquery>
          
     	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LOOKUPSTAFFID=FOUND&LIST_LOOKUP=#URL.LIST_LOOKUP#&LKUPSTAFFCUSTOMERID=#LookupStaffCustomer.STAFFCUSTOMERID#" />
          <cfexit>
     <cfelse>	
          <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
          <cfexit>
     </cfif>
     
</cfoutput>

</cfif>

<cfoutput>
<!--- 
*********************************************************************
* The following code is the Loop Processes for SR Staff Assignments *
*********************************************************************
 --->
<cfif FORM.PROCESSSRSTAFFASSIGNS EQ "CANCEL ASSIGN LOOP">
     <meta http-equiv="Refresh" content="2; URL=/#application.type#apps/servicerequests/srstaffassignloop.cfm" />
	<cfexit>
</cfif>

</cfoutput>

<!--- Process ASSIGNLOOP DATA --->
<cfif FIND('ASSIGN LOOP', #FORM.PROCESSSRSTAFFASSIGNS#, 1) NEQ 0>
   <cfif FORM.PROCESSSRSTAFFASSIGNS EQ "ASSIGN LOOP" OR FORM.PROCESSSRSTAFFASSIGNS EQ "ASSIGN LOOP THEN NEXT GROUP">
   
     <cfset SESSION.STAFF_ASSIGNEDID_ARRAY = #ListToArray(FORM.STAFF_ASSIGNEDID)#>
     <cfset ARRAYCOUNT = (ArrayLen(SESSION.STAFF_ASSIGNEDID_ARRAY))>
       
     <cfloop index = "LOOPCOUNT" from="1" to="#ARRAYCOUNT#">
     	<cfoutput>
          
          <cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
               SELECT	MAX(SRSTAFF_ASSIGNID) AS MAX_ID
               FROM		SRSTAFFASSIGNMENTS
          </cfquery>
          <cfset FORM.ADDSRSAKEY = #val(GetMaxUniqueID.MAX_ID+1)#>
          <cfquery name="AddSRStaffAssignmentsID" datasource="#application.type#SERVICEREQUESTS">
               INSERT INTO	SRSTAFFASSIGNMENTS (SRSTAFF_ASSIGNID, SRID)
               VALUES		(#val(FORM.ADDSRSAKEY)#, #val(Cookie.SRID)#)
          </cfquery>

     	<cfset FORM.STAFF_ASSIGNEDID = SESSION.STAFF_ASSIGNEDID_ARRAY[#LOOPCOUNT#]>

		<cftransaction action="begin">
          <cfquery name="AssignSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
			UPDATE	SRSTAFFASSIGNMENTS
			SET		STAFF_ASSIGNEDID = #val(FORM.STAFF_ASSIGNEDID)#,
					STAFF_DATEASSIGNED = TO_DATE('#FORM.STAFF_DATEASSIGNED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
			WHERE	(SRSTAFF_ASSIGNID = #val(FORM.ADDSRSAKEY)#)
		</cfquery>
          <cftransaction action = "commit"/>
		</cftransaction>
		<h1>Staff Assigned!</h1>

		<cfquery name="LookupStaffAssigned" datasource="#application.type#SERVICEREQUESTS">
			SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SRSA.SRID, SRSA.NEXT_ASSIGNMENT, CUST.CUSTOMERID, CUST.FULLNAME,
               		WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER, CUST.EMAIL AS STAFF_EMAIL
			FROM		WORKGROUPASSIGNS WGA, SRSTAFFASSIGNMENTS SRSA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA, LIBSHAREDDATAMGR.UNITS U
			WHERE	WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#FORM.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
               		WGA.WORKGROUPASSIGNSID = SRSA.STAFF_ASSIGNEDID AND
                         SRSA.SRID = #FORM.SRID# AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
					WGA.GROUPID = GA.GROUPID AND
					CUST.UNITID = U.UNITID
			ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
		</cfquery>

          <cfquery name="LookupAssigner" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, EMAIL
			FROM		CUSTOMERS CUST
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
					CUST.ACTIVE = 'YES'
			ORDER BY	CUST.FULLNAME
		</cfquery>
          
           <cfquery name="LookupSRInfo3" datasource="#application.type#SERVICEREQUESTS">
               SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, REQ.CUSTOMERID, REQ.FULLNAME AS REQUESTER, REQ.EMAIL, REQ.CAMPUSPHONE, 
                         SR.PROBLEM_CATEGORYID, PROBCAT.CATEGORYLETTER || PROBCAT.CATEGORYNAME AS PROBCATEGORY, SR.PROBLEM_SUBCATEGORYID, 
                         PROBSUBCAT.SUBCATEGORYNAME AS PROBSUBCATEGORY, SR.PRIORITYID, PRIORITY.PRIORITYNAME, SR.ASSIGN_PRIORITY, SR.GROUPASSIGNEDID,
                         SR.PROBLEM_DESCRIPTION, SR.PG_STAFFASSIGNEDCOUNT, SR.NG_STAFFASSIGNEDCOUNT
               FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQ, PROBLEMCATEGORIES PROBCAT, PROBLEMSUBCATEGORIES PROBSUBCAT, PRIORITY
               WHERE	SR.SRID = <CFQUERYPARAM value="#LookupStaffAssigned.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
                         SR.REQUESTERID = REQ.CUSTOMERID AND
                         SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
                         SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
                         SR.PRIORITYID = PRIORITY.PRIORITYID
               ORDER BY	REQUESTER
          </cfquery>
          
          <cfif (#FORM.PRIORITYID# NEQ #LookupSRInfo3.PRIORITYID# OR #FORM.ASSIGN_PRIORITY# NEQ #LookupSRInfo3.ASSIGN_PRIORITY# OR #FORM.PROBLEM_DESCRIPTION# NEQ #LookupSRInfo3.PROBLEM_DESCRIPTION#)>
			<cftransaction action="begin">
			<cfquery name="UpdateSRStaffAssignedCount" datasource="#application.type#SERVICEREQUESTS">
				UPDATE	SERVICEREQUESTS 
				SET		PRIORITYID = #val(FORM.PRIORITYID)#,
						ASSIGN_PRIORITY = #val(FORM.ASSIGN_PRIORITY)#,
						PROBLEM_DESCRIPTION = '#PROBLEM_DESCRIPTION#'
				WHERE	(SRID = #val(Cookie.SRID)#)
			</cfquery>
			<cftransaction action = "commit"/>
			</cftransaction>

		</cfif>

         <cfif #LookupStaffAssigned.NEXT_ASSIGNMENT# EQ "YES">
          	<cfset PRIMARYNEXTASSIGN = "NEXT ASSIGNED">
     	<cfelse>
     		<cfset PRIMARYNEXTASSIGN = "PRIMARY">
     	</cfif>

          <cfif #LookupSRInfo3.PG_STAFFASSIGNEDCOUNT# EQ 1 AND #LookupSRInfo3.NG_STAFFASSIGNEDCOUNT# EQ 0> 
			<cfset CCEMAIL = #LookupSRInfo3.EMAIL#>
          <cfelse>
               <cfset CCEMAIL = "">
          </cfif>
                    			
		</cfoutput>
          
          
		<cfif NOT (LookupStaffAssigned.CUSTOMERID EQ Client.CUSTOMERID)>
			<cfmail query = "LookupStaffAssigned"
                    to="#LookupStaffAssigned.STAFF_EMAIL#"
				from="#LookupAssigner.EMAIL#"
				subject="New SR Number for #FORM.REQUESTER#"
				cc="#CCEMAIL#"
			>

On #DateFormat(NOW(), 'mm/dd/yyyy')# you (#LookupStaffAssigned.STAFF_EMAIL#) have been assigned as #PRIMARYNEXTASSIGN# for:

     Requester                  - #LookupSRInfo3.REQUESTER#
     Requester Phone      - #LookupSRInfo3.CAMPUSPHONE#
     SR Number                - #LookupSRInfo3.SERVICEREQUESTNUMBER#  
     Priority                        - #LookupSRInfo3.PRIORITYNAME#
     Problem Category     - #LookupSRInfo3.PROBCATEGORY#
     Sub-Category              - #LookupSRInfo3.PROBSUBCATEGORY#
     Problem Description - #LookupSRInfo3.PROBLEM_DESCRIPTION#
			</cfmail>
		</cfif>
          
          
		<cfoutput>
          

		 <cfif #LookupStaffAssigned.NEXT_ASSIGNMENT# EQ "NO">
                
               <cfquery name="ModifyServiceRequests" datasource="#application.type#SERVICEREQUESTS">
                    UPDATE	SERVICEREQUESTS
                    SET		PG_STAFFASSIGNEDCOUNT = PG_STAFFASSIGNEDCOUNT + 1
                    WHERE	(SRID = #val(Cookie.SRID)#)
               </cfquery>

          <cfelse>
          
          	<cfquery name="ModifyServiceRequests" datasource="#application.type#SERVICEREQUESTS">
                    UPDATE	SERVICEREQUESTS
                    SET		NG_STAFFASSIGNEDCOUNT = NG_STAFFASSIGNEDCOUNT + 1
                    WHERE	(SRID = #val(Cookie.SRID)#)
               </cfquery>
          
          </cfif>
 
		<h1>SR Data MODIFIED!</h1>
          
          <cfif #LOOPCOUNT# LT #ARRAYCOUNT#>

               <cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	MAX(SRSTAFF_ASSIGNID) AS MAX_ID
                    FROM		SRSTAFFASSIGNMENTS
               </cfquery>
               <cfset FORM.UPDATEKEY = #val(GetMaxUniqueID.MAX_ID+1)#>
               <cfquery name="AddSRStaffAssignmentsID" datasource="#application.type#SERVICEREQUESTS">
                    INSERT INTO	SRSTAFFASSIGNMENTS (SRSTAFF_ASSIGNID, SRID)
                    VALUES		(#val(FORM.UPDATEKEY)#, #val(Cookie.SRID)#)
               </cfquery>
               
          </cfif>
		</cfoutput>

	</cfloop>
   </cfif>

<!--- Execute NEXTASSIGNLOOP Logic --->
	<cfoutput>
     
     	<cfif #FORM.PROCESSSRSTAFFASSIGNS# EQ "ASSIGN LOOP THEN NEXT GROUP">
               <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srsecondrefergroupchoice.cfm?SRID=#Cookie.SRID#&PROCESS=ASSIGN LOOP" />
               <cfexit> 
          </cfif>       
		
		<cfif session.ArrayCounter EQ ARRAYLEN(session.SRIDArray)>
			<h1>All Selected Records Processed!</h1>
			<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/srstaffassignloop.cfm" />
			<cfexit>
          <cfelse>
			<h1>Process Next Record</h1>
			<meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/srstaffassignloop.cfm?LOOKUPGROUPID=FOUND" />
			<cfexit>
		</cfif>

	</cfoutput>

</cfif>
 
<!--- 
***********************************************************************
* The following code is the Delete Processes for SR Staff Assignments *
***********************************************************************
 --->

<cfoutput>
<cfif (FIND('DELETE', #FORM.PROCESSSRSTAFFASSIGNS#, 1) NEQ 0) OR (FIND('CANCEL', #FORM.PROCESSSRSTAFFASSIGNS#, 1) NEQ 0)> 

	<cfif FORM.UPDATEKEY GT 0>
          <cftransaction action="begin">
          <cfquery name="DeleteSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
               DELETE FROM	SRSTAFFASSIGNMENTS 
               WHERE		SRSTAFF_ASSIGNID = #val(FORM.UPDATEKEY)#
          </cfquery>
          <cftransaction action = "commit"/>
          </cftransaction>
          <h1>Data DELETED!</h1>
          
     </cfif>

     <cfif IsDefined('URL.POPUP') OR IsDefined('URL.STAFFLOOP')>
          <script language="JavaScript">
               <!-- 
                    alert("Data Deleted!");
                    window.close();
                -->
          </script>
          <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
          <cfexit>
     </cfif>

     <cfif FIND('DELETE', #FORM.PROCESSSRSTAFFASSIGNS#, 1) NEQ 0>
     
     	<cfif IsDefined('FORM.STAFF_ASSIGNEDID') AND #FORM.STAFF_ASSIGNEDID# GT 0>
			<cfif #FORM.NEXT_ASSIGNMENT# EQ "NO">
                    <cftransaction action="begin">
                    <cfquery name="UpdateSRStaffAssignedCount" datasource="#application.type#SERVICEREQUESTS">
                         UPDATE	SERVICEREQUESTS 
                         SET		PG_STAFFASSIGNEDCOUNT = PG_STAFFASSIGNEDCOUNT - 1
                         WHERE	(SRID = #val(Cookie.SRID)#)
                    </cfquery>
                    <cftransaction action = "commit"/>
                    </cftransaction>
               <cfelse>
                    <cftransaction action="begin">
                    <cfquery name="UpdateSRStaffAssignedCount" datasource="#application.type#SERVICEREQUESTS">
                         UPDATE	SERVICEREQUESTS 
                         SET		NG_STAFFASSIGNEDCOUNT = NG_STAFFASSIGNEDCOUNT - 1
                         WHERE	(SRID = #val(Cookie.SRID)#)
                    </cfquery>
                    <cftransaction action = "commit"/>
                    </cftransaction>
               </cfif>
		</cfif>
          
          <cfif #FORM.PROCESSSRSTAFFASSIGNS# EQ 'DELETE LOOP'>
               <cfif session.ArrayCounter EQ ARRAYLEN(session.SRSTAFFASSIGNArray)>
                    <h1>All Selected Records Processed!</h1>
                    <meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm" />
                    <cfexit>
               <cfelse>
                    <h1>Process Next Record</h1>
                    <meta http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm?LOOKUPSTAFFID=FOUND" />
                    <cfexit>
               </cfif>
         <cfelseif IsDefined('URL.LIST_LOOKUP') AND #URL.LIST_LOOKUP# EQ "LOOKUP">

               <cfquery name="LookupStaffCustomer" datasource="#application.type#SERVICEREQUESTS">
                    SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER
                    FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
                    WHERE	WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#FORM.STAFF_ASSIGNEDID#" cfsqltype="CF_SQL_NUMERIC"> AND
                              WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                              WGA.GROUPID = GA.GROUPID
                    ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
               </cfquery>
               
               <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/claimednotcomplkuplist.cfm?LOOKUPSTAFFID=FOUND&LIST_LOOKUP=#URL.LIST_LOOKUP#&LKUPSTAFFCUSTOMERID=#LookupStaffCustomer.STAFFCUSTOMERID#" />
               <cfexit>
               
          <cfelse>	
               <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupservicerequestinfo.cfm?PROCESS=MODIFYDELETE" />
               <cfexit>
          </cfif>
     <cfelse>
     	<CFIF (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
     		<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/unassignedbygrouplookup.cfm?LOOKUPGROUPID=FOUND&GROUPID=#FORM.GROUPID#" />
          <CFELSE>
          	<meta http-equiv="Refresh" content="0; URL=#SESSION.RETURNPGM#" />
          </CFIF>
          <cfexit>
     </cfif>
</cfif>
     
</cfoutput>

</body>
</html>