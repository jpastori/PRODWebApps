<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsoftwareassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/28/2013 --->
<!--- Date in Production: 02/28/2013 --->
<!--- Module: Process Information to Service Requests - Software Assignments --->
<!-- Last modified by John R. Pastori on 02/08/2016 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Service Requests - Software Assignments</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0 OR FIND('MOD', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0 OR FIND('CONFIRM', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSSOFTWAREASSIGN#, 1) EQ 0)>

	<CFIF IsDefined('FORM.ASSIGN_BARCODE') AND #FORM.ASSIGN_BARCODE#  NEQ "3065000">

          <CFQUERY name="LookupAssignedHardware" datasource="#application.type#HARDWARE">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID
               FROM		HARDWAREINVENTORY HI
               WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.ASSIGN_BARCODE#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	BARCODENUMBER
          </CFQUERY>
     
     	<CFIF LookupAssignedHardware.Recordcount EQ 0>
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert("Assigned Barcode NOT found In Software Inventory Table!");
                    -->
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYLOOP&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRSOFTWASSIGNID=#Cookie.SRSOFTWASSIGNID#" />
               <CFEXIT>
          </CFIF>
     </CFIF>	
     
     <CFIF IsDefined('FORM.UNASSIGN_BARCODE') AND #FORM.UNASSIGN_BARCODE#  NEQ "3065000">
     
          <CFQUERY name="LookupUnAssignedHardware" datasource="#application.type#HARDWARE">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER
               FROM		HARDWAREINVENTORY HI
               WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.UNASSIGN_BARCODE#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	BARCODENUMBER
          </CFQUERY>
     
     	<CFIF LookupUnAssignedHardware.Recordcount EQ 0>
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert("UnAssigned Barcode NOT found In Software Inventory Table!");
                    -->
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYLOOP&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRSOFTWASSIGNID=#Cookie.SRSOFTWASSIGNID#" />
               <CFEXIT>
          </CFIF>	
     </CFIF>

     <CFIF (FIND('CONFIRM', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0)>
          <CFIF IsDefined('FORM.CONFIRMEDDATE')>
               <CFSET FORM.CONFIRMEDDATE = #DateFormat(FORM.CONFIRMEDDATE, 'dd-mmm-yyyy')#>
          </CFIF>
     </CFIF>

	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifySoftwareAssignments" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	SRSOFTWASSIGNS
		SET		
          	<CFIF IsDefined('FORM.HWSWID')>
          		HWSWID = #val(FORM.HWSWID)#,
               </CFIF>
               
               <CFIF IsDefined('FORM.IMAGEID')>
               	IMAGEID = #val(FORM.IMAGEID)#,
               </CFIF>
               
               <CFIF IsDefined('FORM.ASSIGN_SWID')>
               	ASSIGN_SWID = #val(FORM.ASSIGN_SWID)#,
                    ASSIGN_OTHERPKGTITLE = UPPER('#FORM.ASSIGN_OTHERPKGTITLE#'),
				ASSIGN_VERSION = #val(FORM.ASSIGN_VERSION)#,
               </CFIF>
                    
			<CFIF IsDefined('FORM.ASSIGN_BARCODE') AND #FORM.ASSIGN_BARCODE#  NEQ "3065000">
				ASSIGN_INVENTID = #LookupAssignedHardware.HARDWAREID#,
				ASSIGN_CUSTID = #val(FORM.ASSIGN_CUSTID)#,
			</CFIF>
               
               <CFIF IsDefined('FORM.UNASSIGN_SWID')>
               	UNASSIGN_SWID = #val(FORM.UNASSIGN_SWID)#,
                    UNASSIGN_OTHERPKGTITLE = UPPER('#FORM.UNASSIGN_OTHERPKGTITLE#'),
 				UNASSIGN_VERSION = #val(FORM.UNASSIGN_VERSION)#,
               </CFIF>
                  
               <CFIF IsDefined('FORM.UNASSIGN_BARCODE') AND #FORM.UNASSIGN_BARCODE#  NEQ "3065000">
				UNASSIGN_INVENTID = #LookupUnAssignedHardware.HARDWAREID#,            
				UNASSIGN_CUSTID = #val(FORM.UNASSIGN_CUSTID)#,
               </CFIF>
               			
               <CFIF IsDefined('FORM.MODIFIEDBYID')>
               	MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
               </CFIF>
               
               <CFIF IsDefined('FORM.MODIFIEDDATE')>
               	MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY'),
               </CFIF>
               
			<CFIF FIND('CONFIRM', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0 AND IsDefined('FORM.CONFIRMFLAG')>
               	CONFIRMFLAG = UPPER('#FORM.CONFIRMFLAG#'),
				CONFIRMCOMMENTS = UPPER('#FORM.CONFIRMCOMMENTS#'),
                    COMFIRMEDBYID = #val(FORM.COMFIRMEDBYID)#,
				CONFIRMEDDATE = TO_DATE('#FORM.CONFIRMEDDATE#', 'DD-MON-YYYY')
               <CFELSEIF IsDefined('FORM.TECHCOMMENTS')>
               	TECHCOMMENTS = UPPER('#FORM.TECHCOMMENTS#')
               <CFELSE>
               	SRSOFTWASSIGNID = #val(Cookie.SRSOFTWASSIGNID)#
			</CFIF>
                         	
		WHERE	SRSOFTWASSIGNID = #val(Cookie.SRSOFTWASSIGNID)#
	</CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
     
</CFIF>

<CFIF FIND('ADD', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0 AND (FIND('CANCEL', #FORM.PROCESSSOFTWAREASSIGN#, 1) EQ 0)>
	<H1>Data ADDED!</H1>
     
     <CFQUERY name="LookupSRAssignedStaff" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
			SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID
			FROM		SRSTAFFASSIGNMENTS SRSA
               WHERE     SRSA.SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
               		SRSA.NEXT_ASSIGNMENT = 'YES' AND
                         SRSA.NEXT_ASSIGNMENT_GROUPID = 5 AND
                         SRSA.SRSTAFF_ASSIGNID > 0
               ORDER BY	SRSA.STAFF_ASSIGNEDID          
     </CFQUERY>
     
     <CFIF LookupSRAssignedStaff.RecordCount EQ 0>
     
     	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
               SELECT	MAX(SRSTAFF_ASSIGNID) AS MAX_ID
               FROM		SRSTAFFASSIGNMENTS
          </CFQUERY>
          
          <CFQUERY name="GetInventoryCoordinatorID" datasource="#application.type#SERVICEREQUESTS">
               SELECT	WORKGROUPASSIGNSID, GROUPID, ACTIVE
               FROM		WORKGROUPASSIGNS
               WHERE	GROUPID = 5 AND
               		ACTIVE ='YES'
          </CFQUERY>
          
          <CFSET FORM.SRSTAFF_ASSIGNID = #val(GetMaxUniqueID.MAX_ID+1)#>
          <CFCOOKIE name="SRSTAFF_ASSIGNID" secure="NO" value="#FORM.SRSTAFF_ASSIGNID#">
          <CFSET FORM.STAFF_DATEASSIGNED = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
          <CFSET FORM.NEXT_ASSIGNMENT_REASON = 'SOFTWARE ASSIGNMENT CHANGED'>
          <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
     
     	<CFQUERY name="AddSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
               INSERT INTO	SRSTAFFASSIGNMENTS (SRSTAFF_ASSIGNID, SRID, NEXT_ASSIGNMENT, NEXT_ASSIGNMENT_GROUPID, STAFF_ASSIGNEDID, STAFF_DATEASSIGNED, NEXT_ASSIGNMENT_REASON, MODIFIEDDATE, STAFF_COMPLETEDSR)
               VALUES		(#val(Cookie.SRSTAFF_ASSIGNID)#, #val(Cookie.SRID)#, 'YES', 5, #GetInventoryCoordinatorID.WORKGROUPASSIGNSID#, TO_DATE('#FORM.STAFF_DATEASSIGNED#', 'DD-MON-YYYY'), '#FORM.NEXT_ASSIGNMENT_REASON#', TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY'), 'NO')
          </CFQUERY>
     
     </CFIF>
     
	<CFIF IsDefined('URL.STAFFLOOP') AND #FORM.PROCESSSOFTWAREASSIGN# EQ "ADD">
     	<CFIF (IsDefined('LookupAssignedHardware.EQUIPMENTTYPEID')) AND (#LookupAssignedHardware.EQUIPMENTTYPEID# EQ 1 OR #LookupAssignedHardware.EQUIPMENTTYPEID# EQ 15)>
          	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYDELETE&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRID=#Cookie.SRID#" />
          <CFELSE>
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert("Data Added!");
                         window.close();
                    -->
               </SCRIPT> 
          </CFIF>
		<CFEXIT>
	</CFIF>
	<CFIF FORM.PROCESSSOFTWAREASSIGN EQ "ADDLOOP">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=ADDLOOP&SRID=#Cookie.SRID#" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FIND('MODIFY', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0>
	<H1>Data MODIFIED!</H1>
	<CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") AND (#FORM.PROCESSSOFTWAREASSIGN# EQ "MODIFY"))>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data MODIFIED!");
				window.close();
			-->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
	<CFIF FORM.PROCESSSOFTWAREASSIGN EQ "MODIFY">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYDELETE&STAFFLOOP=#URL.STAFFLOOP#" />
		<CFEXIT>
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYLOOP&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRID=#Cookie.SRID#" />
		<CFEXIT>
	</CFIF>
</CFIF> 
    
<CFIF FIND('CONFIRM', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0>
     <H1>Data CONFIRMED!</H1>
     <CFIF FORM.PROCESSSOFTWAREASSIGN EQ "CONFIRM">
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsconfirm.cfm?PROCESS=CONFIRM" />
          <CFEXIT>
     <CFELSE>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassignsconfirm.cfm?PROCESS=CONFIRM&LOOKUPITEM=FOUND&LOOP=YES&SRID=#Cookie.SRID#" />
          <CFEXIT>
     </CFIF>
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0 OR FORM.PROCESSSOFTWAREASSIGN EQ "CANCELADD">
	<CFIF FORM.PROCESSSOFTWAREASSIGN EQ "DELETEALL">
     
          <CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS">
               DELETE FROM	SRSOFTWASSIGNS
               WHERE		SRID = #val(Cookie.SRID)#
          </CFQUERY>
     
	<CFELSE>     
     
          <CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS">
               DELETE FROM	SRSOFTWASSIGNS
               WHERE		SRSOFTWASSIGNID = #val(Cookie.SRSOFTWASSIGNID)#
          </CFQUERY>
     
	</CFIF>

	<H1>Data DELETED!</H1>
	<CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") AND (FORM.PROCESSSOFTWAREASSIGN EQ "DELETE" OR FORM.PROCESSSOFTWAREASSIGN EQ "DELETEALL"))>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data Deleted!");
				window.close();
			 -->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
	<CFIF FIND('DELETE', #FORM.PROCESSSOFTWAREASSIGN#, 1) NEQ 0>
		<CFIF FORM.PROCESSSOFTWAREASSIGN EQ "DELETE">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYDELETE&STAFFLOOP=NO" />
               <CFEXIT>
		<CFELSE>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/softwareassigns.cfm?PROCESS=MODIFYDELETE&LOOKUPITEM=FOUND&STAFFLOOP=NO&SRID=#Cookie.SRID#" />
               <CFEXIT>
		</CFIF>
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>