<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processhardwareassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/28/2013 --->
<!--- Date in Production: 02/28/2013 --->
<!--- Module: Process Information to Service Requests - Hardware Assignments --->
<!-- Last modified by John R. Pastori on 02/08/2016 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Service Requests - Hardware Assignments</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0 OR FIND('MOD', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0 OR FIND('CONFIRM', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSHARDWAREASSIGN#, 1) EQ 0)>

	<CFIF IsDefined('FORM.INSTALLEDBARCODE') AND #FORM.INSTALLEDBARCODE#  NEQ "3065000">

          <CFQUERY name="LookupInstalledHardware" datasource="#application.type#HARDWARE">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID
               FROM		HARDWAREINVENTORY HI
               WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.INSTALLEDBARCODE#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	BARCODENUMBER
          </CFQUERY>
     
     	<CFIF LookupInstalledHardware.Recordcount EQ 0>
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert("Installed Barcode NOT found In Hardware Inventory Table!");
                    -->
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYLOOP&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRHARDWASSIGNID=#Cookie.SRHARDWASSIGNID#" />
               <CFEXIT>
          </CFIF>
     </CFIF>	
     
     <CFIF IsDefined('FORM.RETURNEDBARCODE') AND #FORM.RETURNEDBARCODE#  NEQ "3065000">
     
          <CFQUERY name="LookupReturnedHardware" datasource="#application.type#HARDWARE">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER
               FROM		HARDWAREINVENTORY HI
               WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.RETURNEDBARCODE#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	BARCODENUMBER
          </CFQUERY>
     
     	<CFIF LookupReturnedHardware.Recordcount EQ 0>
			<SCRIPT language="JavaScript">
                    <!-- 
                         alert("Returned Barcode NOT found In Hardware Inventory Table!");
                    -->
               </SCRIPT>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYLOOP&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRHARDWASSIGNID=#Cookie.SRHARDWASSIGNID#" />
               <CFEXIT>
          </CFIF>	
     </CFIF>

     <CFIF (FIND('CONFIRM', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0)>
          <CFIF IsDefined('FORM.CONFIRMEDDATE')>
               <CFSET FORM.CONFIRMEDDATE = #DateFormat(FORM.CONFIRMEDDATE, 'dd-mmm-yyyy')#>
          </CFIF>
     </CFIF>

	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyHardwareAssignments" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	SRHARDWASSIGNS
		SET		
          	<CFIF IsDefined('FORM.HWSWID')>
          		HWSWID = #val(FORM.HWSWID)#,
               </CFIF>
               <CFIF IsDefined('FORM.IMAGEID')>
               	IMAGEID = #val(FORM.IMAGEID)#,
               </CFIF>
			<CFIF IsDefined('FORM.INSTALLEDBARCODE') AND #FORM.INSTALLEDBARCODE#  NEQ "3065000">
				INSTALLINVENTID = #LookupInstalledHardware.HARDWAREID#,
				INSTALLLOCID = #val(FORM.INSTALLLOCID)#,
				INSTALLCUSTID = #val(FORM.INSTALLCUSTID)#,
			</CFIF>
               <CFIF IsDefined('FORM.RETURNEDBARCODE') AND #FORM.RETURNEDBARCODE#  NEQ "3065000">
				RETURNINVENTID = #LookupReturnedHardware.HARDWAREID#,            
				RETURNLOCID = #val(FORM.RETURNLOCID)#,
				RETURNCUSTID = #val(FORM.RETURNCUSTID)#,
               </CFIF>			
               <CFIF FIND('CONFIRM', #FORM.PROCESSHARDWAREASSIGN#, 1) EQ 0>
               	SALVAGEFLAG = UPPER('#FORM.SALVAGEFLAG#'),
               </CFIF>
			<CFIF IsDefined('FORM.MACHINENAME') AND #FORM.MACHINENAME#  NEQ "">
				MACHINENAME = UPPER('#FORM.MACHINENAME#'),
			</CFIF>
               <CFIF IsDefined('FORM.MACADDRESS') AND #FORM.MACADDRESS#  NEQ "">
				MACADDRESS = UPPER('#FORM.MACADDRESS#'),
			</CFIF>
               <CFIF IsDefined('FORM.IPADDRESS') AND #FORM.IPADDRESS#  NEQ "">
				IPADDRESS = '#FORM.IPADDRESS#',
               </CFIF>
               <CFIF IsDefined('FORM.MODIFIEDBYID')>
               	MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
               </CFIF>
               <CFIF IsDefined('FORM.MODIFIEDDATE')>
               	MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY'),
               </CFIF>
			<CFIF FIND('CONFIRM', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0 AND IsDefined('FORM.CONFIRMFLAG')>
               	CONFIRMFLAG = UPPER('#FORM.CONFIRMFLAG#'),
				CONFIRMCOMMENTS = UPPER('#FORM.CONFIRMCOMMENTS#'),
                    COMFIRMEDBYID = #val(FORM.COMFIRMEDBYID)#,
				CONFIRMEDDATE = TO_DATE('#FORM.CONFIRMEDDATE#', 'DD-MON-YYYY')
               <CFELSEIF IsDefined('FORM.TECHCOMMENTS')>
               	TECHCOMMENTS = UPPER('#FORM.TECHCOMMENTS#')
               <CFELSE>
               	SRHARDWASSIGNID = #val(Cookie.SRHARDWASSIGNID)#
			</CFIF>          	
		WHERE	SRHARDWASSIGNID = #val(Cookie.SRHARDWASSIGNID)#
	</CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
     
</CFIF>

<CFIF FIND('ADD', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0 AND (FIND('CANCEL', #FORM.PROCESSHARDWAREASSIGN#, 1) EQ 0)>
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
          <CFSET FORM.NEXT_ASSIGNMENT_REASON = 'HARDWARE ASSIGNMENT CHANGED'>
          <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
     
		<CFTRANSACTION action="begin">
     	<CFQUERY name="AddSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
               INSERT INTO	SRSTAFFASSIGNMENTS (SRSTAFF_ASSIGNID, SRID, NEXT_ASSIGNMENT, NEXT_ASSIGNMENT_GROUPID, STAFF_ASSIGNEDID, STAFF_DATEASSIGNED, NEXT_ASSIGNMENT_REASON, MODIFIEDDATE, STAFF_COMPLETEDSR)
               VALUES		(#val(Cookie.SRSTAFF_ASSIGNID)#, #val(Cookie.SRID)#, 'YES', 5, #GetInventoryCoordinatorID.WORKGROUPASSIGNSID#, TO_DATE('#FORM.STAFF_DATEASSIGNED#', 'DD-MON-YYYY'), '#FORM.NEXT_ASSIGNMENT_REASON#', TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY'), 'NO')
          </CFQUERY>
		<CFTRANSACTION action = "commit"/>
		</CFTRANSACTION>
     
     </CFIF>
     
	<CFIF IsDefined('URL.STAFFLOOP') AND #FORM.PROCESSHARDWAREASSIGN# EQ "ADD">
     	<CFIF ((IsDefined('LookupInstalledHardware.EQUIPMENTTYPEID')) AND (#LookupInstalledHardware.EQUIPMENTTYPEID# EQ 1 OR #LookupInstalledHardware.EQUIPMENTTYPEID# EQ 15))>
          	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYDELETE&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRID=#Cookie.SRID#" />
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
	<CFIF FORM.PROCESSHARDWAREASSIGN EQ "ADDLOOP">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=ADDLOOP&SRID=#Cookie.SRID#" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FIND('MODIFY', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0>
	<H1>Data MODIFIED!</H1>
	<CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") AND (#FORM.PROCESSHARDWAREASSIGN# EQ "MODIFY"))>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data MODIFIED!");
				window.close();
			-->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
	<CFIF FORM.PROCESSHARDWAREASSIGN EQ "MODIFY">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYDELETE&STAFFLOOP=#URL.STAFFLOOP#" />
		<CFEXIT>
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYLOOP&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRID=#Cookie.SRID#" />
		<CFEXIT>
	</CFIF>
</CFIF> 
    
<CFIF FIND('CONFIRM', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0>
     <H1>Data CONFIRMED!</H1>
     <CFIF FORM.PROCESSHARDWAREASSIGN EQ "CONFIRM">
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm?PROCESS=CONFIRM" />
          <CFEXIT>
     <CFELSE>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassignsconfirm.cfm?PROCESS=CONFIRM&LOOKUPITEM=FOUND&LOOP=YES&SRID=#Cookie.SRID#" />
          <CFEXIT>
     </CFIF>
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0 OR FORM.PROCESSHARDWAREASSIGN EQ "CANCELADD">
	<CFIF FORM.PROCESSHARDWAREASSIGN EQ "DELETEALL">
     
          <CFQUERY name="DeleteHardwareAssignments" datasource="#application.type#SERVICEREQUESTS">
               DELETE FROM	SRHARDWASSIGNS
               WHERE		SRID = #val(Cookie.SRID)#
          </CFQUERY>
          
	<CFELSE>     
     
          <CFQUERY name="DeleteHardwareAssignments" datasource="#application.type#SERVICEREQUESTS">
               DELETE FROM	SRHARDWASSIGNS
               WHERE		SRHARDWASSIGNID = #val(Cookie.SRHARDWASSIGNID)#
          </CFQUERY>
     
	</CFIF>

	<H1>Data DELETED!</H1>
	<CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") AND (FORM.PROCESSHARDWAREASSIGN EQ "DELETE" OR FORM.PROCESSHARDWAREASSIGN EQ "DELETEALL"))>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data Deleted!");
				window.close();
			 -->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
	<CFIF FIND('DELETE', #FORM.PROCESSHARDWAREASSIGN#, 1) NEQ 0>
		<CFIF FORM.PROCESSHARDWAREASSIGN EQ "DELETE">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYDELETE" />
               <CFEXIT>
		<CFELSE>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/hardwareassigns.cfm?PROCESS=MODIFYLOOP&LOOKUPITEM=FOUND&STAFFLOOP=#URL.STAFFLOOP#&SRID=#Cookie.SRID#" />
               <CFEXIT>
		</CFIF>
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>