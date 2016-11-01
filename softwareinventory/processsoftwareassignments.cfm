<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsoftwareassignments.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 04/22/2011 --->
<!--- Date in Production: 04/22/2011 --->
<!--- Module: Process Information to IDT Software Inventory - Assignments --->
<!-- Last modified by John R. Pastori on 04/22/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Assignments</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSSOFTWAREASSIGNMENTS#, 1) NEQ 0 OR FORM.PROCESSSOFTWAREASSIGNMENTS EQ "MODIFY" OR FORM.PROCESSSOFTWAREASSIGNMENTS EQ "MODIFYLOOP") AND (FIND('CANCEL', #FORM.PROCESSSOFTWAREASSIGNMENTS#, 1) EQ 0)>
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifySoftwareAssignments" datasource="#application.type#SOFTWARE">
		UPDATE	SOFTWAREASSIGNMENTS
		SET		ASSIGNEDHARDWAREID = #val(FORM.ASSIGNEDHARDWAREID)#,
				SERIALNUMBER = '#FORM.SERIALNUMBER#',
				ASSIGNEDCUSTID = #val(FORM.ASSIGNEDCUSTID)#,
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	SOFTWASSIGNID = #val(Cookie.SOFTWASSIGNID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "ADD">
	<H1>Data ADDED!</H1>
	<CFIF IsDefined('URL.PGMCALL') AND (#URL.PGMCALL# EQ 'SI' OR #URL.PGMCALL# EQ 'SA')>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data ADDED!");
				window.close();
			 -->
		</SCRIPT>
	</CFIF>
     <CFIF IsDefined('URL.PGMCALL') AND (#URL.PGMCALL# EQ 'CUSTASSIGN')>
     	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/custsoftwassigns.cfm?PROCESS=REPORT&ASSIGNEDCUSTID=#FORM.ASSIGNEDCUSTID#&HARDWAREID=#FORM.ASSIGNEDHARDWAREID#" />
	<CFELSEIF IsDefined('URL.PGMCALL') AND (#URL.PGMCALL# EQ 'LOOKUPSA')>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/swassignslookupadd.cfm?PROCESS=ADD" />
     <CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=ADD" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "ADDLOOP">
	<H1>Data ADDED!</H1>
	<CFIF IsDefined('URL.PGMCALL') AND (#URL.PGMCALL# EQ 'LOOKUPSA')>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/swassignslookupadd.cfm?PROCESS=ADD&SOFTWASSIGNID=#val(Cookie.SOFTWASSIGNID)#" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=ADD&PGMCALL=SA&SOFTWINVENTID=#val(Cookie.SOFTWINVENTID)#" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "MODIFY">
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYDELETE" />
</CFIF>

<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "MODIFYMULTIPLE">
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifySoftwareAssignments" datasource="#application.type#SOFTWARE">
		UPDATE	SOFTWAREASSIGNMENTS
		SET
			<CFIF IsDefined("FORM.SERIALNUMBERCHANGED")>
				SERIALNUMBER = '#FORM.SERIALNUMBER#',
			</CFIF>
			<CFIF IsDefined("FORM.ASSIGNEDCUSTIDCHANGED")>
				ASSIGNEDCUSTID = #val(FORM.ASSIGNEDCUSTID)#,
			</CFIF>
			<CFIF IsDefined("FORM.ASSIGNEDHARDWAREIDCHANGED")>
				ASSIGNEDHARDWAREID = #val(FORM.ASSIGNEDHARDWAREID)#,
			</CFIF>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	SOFTWASSIGNID IN (#URL.SOFTWASSIGNIDS#) AND
          		SOFTWASSIGNID > 0
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
	<H1>Data MODIFIED!</H1><BR />
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/swassignsmultiplemoddel.cfm" />
</CFIF>

<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "MODIFYLOOP">
	<H1>Data MODIFIED!</H1><BR />
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "NEXTRECORD">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "DELETELOOP">
	<CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SOFTWARE">
		DELETE FROM	SOFTWAREASSIGNMENTS
		WHERE 		SOFTWASSIGNID = #val(Cookie.SOFTWASSIGNID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYLOOP" />
		<CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSSOFTWAREASSIGNMENTS#, 1) NEQ 0 OR FORM.PROCESSSOFTWAREASSIGNMENTS EQ "CANCELADD">
	<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "DELETE" OR FORM.PROCESSSOFTWAREASSIGNMENTS EQ "CANCELADD">

		<CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SOFTWARE">
			DELETE FROM	SOFTWAREASSIGNMENTS
			WHERE 		SOFTWASSIGNID = #val(Cookie.SOFTWASSIGNID)#
		</CFQUERY>

	</CFIF>

	<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "DELETEMULTIPLE">
		<CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SOFTWARE">
			DELETE FROM	SOFTWAREASSIGNMENTS
			WHERE 		SOFTWASSIGNID IN (#URL.SOFTWASSIGNIDS#)
		</CFQUERY>
	</CFIF>

	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareassignments.cfm?PROCESS=MODIFYDELETE" />
		<CFEXIT>
	<CFELSEIF FORM.PROCESSSOFTWAREASSIGNMENTS EQ "DELETEMULTIPLE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/swassignsmultiplemoddel.cfm" />
		<CFEXIT>
	</CFIF>
	<CFIF IsDefined('URL.PGMCALL') AND (#URL.PGMCALL# EQ 'SI' OR #URL.PGMCALL# EQ 'SA')>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data DELETED!");
				window.close();
			 -->
		</SCRIPT>
	</CFIF>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>