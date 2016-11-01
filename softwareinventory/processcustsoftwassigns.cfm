<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcustsoftwassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 04/22/2011 --->
<!--- Date in Production: 04/22/2011 --->
<!--- Module: Process Information to IDT Software Inventory - Assignments By Customer --->
<!-- Last modified by John R. Pastori on 04/22/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Assignments By Customer</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "ADD">

	<CFSET SoftwareIDArray = ArrayNew(1)>
     <CFSET Counter = 0>
	<CFSET temp = ArraySet(SoftwareIDArray, 1, LISTLEN(URL.SOFTWAREIDS), 0)> 
	<CFSET SoftwareIDArray = ListToArray(URL.SOFTWAREIDS)>
     <CFSET FORM.ASSIGNDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
     <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
     
	<CFLOOP index="Counter" from=1 to=#LISTLEN(URL.SOFTWAREIDS)#>
		<CFIF SoftwareIDArray[Counter] GT 0>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SOFTWARE">
				SELECT	MAX(SOFTWASSIGNID) AS MAX_ID
				FROM		SOFTWAREASSIGNMENTS
			</CFQUERY>
			<CFSET FORM.SOFTWASSIGNID =  #val(GetMaxUniqueID.MAX_ID+1)#>
			<CFQUERY name="AddSoftwareAssignments" datasource="#application.type#SOFTWARE">
				INSERT INTO	SOFTWAREASSIGNMENTS (SOFTWASSIGNID, SOFTWINVENTID, ASSIGNDATE, ASSIGNEDHARDWAREID, ASSIGNEDCUSTID, MODIFIEDBYID, MODIFIEDDATE)
				VALUES		(#val(FORM.SOFTWASSIGNID)#, 
                    			 #val(SoftwareIDArray[Counter])#, 
                                    TO_DATE('#FORM.ASSIGNDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'), 
                                    #URL.HARDWAREID#, 
                                    #URL.ASSIGNEDCUSTID#, 
                                    #Client.CUSTOMERID#, 
                                    TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
			</CFQUERY>
		</CFIF>
	</CFLOOP>

     <H1>Data ADDED!</H1> 
     <BR>&nbsp;&nbsp;&nbsp;&nbsp;Software IDs = #URL.SOFTWAREIDS#
     <BR>&nbsp;&nbsp;&nbsp;&nbsp;Assigned Date = #FORM.ASSIGNDATE#
     <BR>&nbsp;&nbsp;&nbsp;&nbsp;Assigned Hardware ID  = #URL.HARDWAREID#
     <BR>&nbsp;&nbsp;&nbsp;&nbsp;Assigned Customer ID = #URL.ASSIGNEDCUSTID#
     <BR>&nbsp;&nbsp;&nbsp;&nbsp;Modified By ID = #Client.CUSTOMERID#
     <BR>&nbsp;&nbsp;&nbsp;&nbsp;Modified Date = #FORM.MODIFIEDDATE#<BR><BR>
	<META http-equiv="Refresh" content="5; URL=/#application.type#apps/softwareinventory/custsoftwimageassigns.cfm">
	<CFEXIT>
</CFIF>

<CFTRANSACTION action="begin">
<CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SOFTWARE">
	DELETE FROM	SOFTWAREASSIGNMENTS
	WHERE 		SOFTWASSIGNID = #val(URL.SOFTWASSIGNID)#
</CFQUERY>
<CFTRANSACTION action = "commit"/>
</CFTRANSACTION>

<H1>Data DELETED!</H1>
<CFIF #FORM.PROCESSSOFTWAREASSIGNMENTS# EQ "DELETE/ADD">
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=ADD&PGMCALL=CUSTASSIGN&ASSIGNEDCUSTID=#URL.ASSIGNEDCUSTID#&HARDWAREID=#URL.HARDWAREID#">
	<CFEXIT>
</CFIF>

<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/custsoftwassigns.cfm?PROCESS=REPORT&ASSIGNEDCUSTID=#URL.ASSIGNEDCUSTID#&HARDWAREID=#URL.HARDWAREID#">

</CFOUTPUT>

</BODY>
</HTML>