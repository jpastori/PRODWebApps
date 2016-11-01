<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsrcompleted.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/14/2012 --->
<!--- Date in Production: 12/14/2012 --->
<!--- Module: Process Service Request Completed Information --->
<!-- Last modified by John R. Pastori on 11/08/2013 using ColdFusion Studio. -->

			<CFOUTPUT>
			<CFIF (IsDefined('FORM.STAFF_COMPLETEDSR')) AND (#FORM.STAFF_COMPLETEDSR# EQ "YES" OR #FORM.STAFF_COMPLETEDSR# EQ "VOIDED")>
               	   
				<CFSET FORM.STAFF_COMPLETEDDATE = #DateFormat(NOW(), 'mm/dd/yyyy')#>

				<CFQUERY name="UpdateCompletedAssignment" datasource="#application.type#SERVICEREQUESTS">
					UPDATE	SRSTAFFASSIGNMENTS
					SET		STAFF_COMPLETEDSR = UPPER('#FORM.STAFF_COMPLETEDSR#'),
							STAFF_COMPLETEDDATE = TO_DATE('#FORM.STAFF_COMPLETEDDATE#', 'MM/DD/YYYY'),
							STAFF_COMPLETEDCOMMENTSID = #val(FORM.STAFF_COMPLETEDCOMMENTSID)#
					WHERE	(SRSTAFF_ASSIGNID = #val(Cookie.SRSTAFF_ASSIGNID)#)
				</CFQUERY>

				<CFQUERY name="ListSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
					SELECT	SRSTAFF_ASSIGNID, SRID, STAFF_ASSIGNEDID, STAFF_DATEASSIGNED, STAFF_TIME_WORKED, STAFF_COMMENTS, 
							NEXT_ASSIGNMENT, NEXT_ASSIGNMENT_GROUPID, NEXT_ASSIGNMENT_REASON, STAFF_COMPLETEDSR, STAFF_COMPLETEDDATE,
							STAFF_COMPLETEDCOMMENTSID
					FROM		SRSTAFFASSIGNMENTS
					WHERE	SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_NUMERIC">
					ORDER BY	SRSTAFF_ASSIGNID
				</CFQUERY>

				<CFSET SESSION.TOTAL_STAFFTIME_WORKED = 0>
                    <CFSET SESSION.TOTAL_REFSTAFFTIME_WORKED = 0>
                    
				<CFIF #ListSRStaffAssignments.RecordCount# GT 0>
					<CFSET SRCOMPLETED = "YES">
					<CFLOOP query = "ListSRStaffAssignments"> 
						<CFIF #ListSRStaffAssignments.STAFF_COMPLETEDSR# EQ "NO">
							<CFSET SRCOMPLETED = "NO">
                              <CFELSE>
                              	<CFSET SESSION.TOTAL_STAFFTIME_WORKED = (SESSION.TOTAL_STAFFTIME_WORKED + #ListSRStaffAssignments.STAFF_TIME_WORKED#)>
						</CFIF>
                              <CFIF SRCOMPLETED EQ "YES" AND #ListSRStaffAssignments.NEXT_ASSIGNMENT# EQ "YES">
                              	<CFSET SESSION.TOTAL_REFSTAFFTIME_WORKED = (SESSION.TOTAL_REFSTAFFTIME_WORKED + #ListSRStaffAssignments.STAFF_TIME_WORKED#)>
                              </CFIF>	
					</CFLOOP>
				<CFELSE>
					<CFSET SRCOMPLETED = "NO">
				</CFIF>

				<CFIF SRCOMPLETED EQ "YES">
                    
                    	<CFSET FORM.SR_COMPLETEDDATE = #DateFormat(NOW(), 'mm/dd/yyyy')#>
                         
					<CFQUERY name="UpdateSRTotTimeWorked" datasource="#application.type#SERVICEREQUESTS">
						UPDATE	SERVICEREQUESTS
						SET		TOTAL_STAFFTIME = #val(SESSION.TOTAL_STAFFTIME_WORKED)#,
								SRCOMPLETEDDATE = TO_DATE('#FORM.SR_COMPLETEDDATE#', 'MM/DD/YYYY'),
								SRCOMPLETED = UPPER('#FORM.STAFF_COMPLETEDSR#')
						WHERE	(SRID = #val(Cookie.SRID)#)
					</CFQUERY>

                         <CFQUERY name="UpdateSRRefTimeWorked" datasource="#application.type#SERVICEREQUESTS">
                              UPDATE	SERVICEREQUESTS
                              SET		TOTAL_REFERRALTIME = #val(SESSION.TOTAL_REFSTAFFTIME_WORKED)#
                              WHERE	(SRID = #val(Cookie.SRID)#)
                         </CFQUERY>

                    </CFIF>
                    
				<CFIF SRCOMPLETED EQ "VOIDED">
                    
                    	<CFSET FORM.SR_VOIDEDDATE = #DateFormat(NOW(), 'mm/dd/yyyy')#>
 
					<CFQUERY name="UpdateVoidedSR" datasource="#application.type#SERVICEREQUESTS">
						UPDATE	SERVICEREQUESTS
						SET		SRCOMPLETEDDATE = TO_DATE('#FORM.SR_VOIDEDDATE#', 'MM/DD/YYYY'),
								SRCOMPLETED = UPPER('#FORM.STAFF_COMPLETEDSR#')
						WHERE	(SRID = #val(Cookie.SRID)#)
					</CFQUERY>
				</CFIF>
                    
			<CFELSEIF IsDefined('FORM.SRCOMPLETERESET')>
<!--- CODE FOR PROCESS TO RE-OPEN CLOSED OR VOIDED SRs.  05/16/2012 - JRP ---> 

				<CFQUERY name="UpdateSRCompleteReset" datasource="#application.type#SERVICEREQUESTS">
					UPDATE	SRSTAFFASSIGNMENTS
					SET		STAFF_COMPLETEDSR = UPPER('#FORM.SRCOMPLETED#'),
							STAFF_COMPLETEDDATE = NULL,
							STAFF_COMPLETEDCOMMENTSID = 0
					WHERE	(SRID = #val(Cookie.SRID)#)
				</CFQUERY>
                    
				<CFIF #FORM.SRCOMPLETERESET# EQ "YES">

					<CFQUERY name="OpenClosedSR" datasource="#application.type#SERVICEREQUESTS">
                              UPDATE	SERVICEREQUESTS
                              SET		TOTAL_STAFFTIME = 0.00,
                                        TOTAL_REFERRALTIME = 0.00, 
                                        SRCOMPLETEDDATE = NULL,
                                        SRCOMPLETED = UPPER('#FORM.SRCOMPLETED#')
                              WHERE	(SRID = #val(Cookie.SRID)#)
                         </CFQUERY>
                         
				<CFELSEIF #FORM.SRCOMPLETERESET# EQ "VOIDED">
					<CFQUERY name="OpenVoidedSR" datasource="#application.type#SERVICEREQUESTS">
						UPDATE	SERVICEREQUESTS
						SET		PG_STAFFASSIGNEDCOUNT = 0,
                         			NG_STAFFASSIGNEDCOUNT = 0,
                                        TOTAL_STAFFTIME = 0.00,
                                        TOTAL_REFERRALTIME = 0.00, 
                                        SRCOMPLETEDDATE = NULL,
								SRCOMPLETED = UPPER('#FORM.SRCOMPLETED#')
						WHERE	(SRID = #val(Cookie.SRID)#)
					</CFQUERY>
				</CFIF>

			<CFELSE>

				<script language="JavaScript">
					<!-- 
						alert("You must Select YES for the Completed SR field before clicking the Staff Completed Button.");
					-->
				</script>
				<CFIF FIND('LOOP', #FORM.PROCESSSTAFFREFERRAL#, 7) EQ 0>
					<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=MODIFYDELETE&LOOKUPSTAFFREFERRAL=FOUND&SRSTAFFASSIGNID=#Cookie.SRSTAFF_ASSIGNID#" />
				<CFELSE>
					<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/staffassignsmodloop.cfm?LOOKUPSTAFFID=FOUND&SRSTAFFASSIGNID=#Cookie.SRSTAFF_ASSIGNID#" />
				</CFIF>

				<CFEXIT>

			</CFIF>
			</CFOUTPUT>