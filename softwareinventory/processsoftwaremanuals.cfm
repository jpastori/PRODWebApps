<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processssoftwaremanuals.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Software Inventory - Manuals --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Manuals</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSSOFTWAREMANUALS#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSSOFTWAREMANUALS#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSSOFTWAREMANUALS#, 1) EQ 0)>
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifySoftwareManuals" datasource="#application.type#SOFTWARE">
		UPDATE	MANUALS
		SET		MANUALS.MANUALSQTY = #val(MANUALSQTY)#,
				MANUALS.LOCATIONID = #val(FORM.LOCATIONID)#,
				MANUALS.PARTNUMBER = UPPER('#FORM.PARTNUMBER#'),
				MANUALS.TITLE = UPPER('#FORM.TITLE#'),
				MANUALS.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MANUALS.MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	MANUALS.MANUALSID = #val(Cookie.MANUALSID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMANUALS EQ "ADD">
	<H1>Data ADDED!</H1>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("Data ADDED!");
			window.close();
		 -->
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMANUALS EQ "ADDLOOP">
	<H1>Data ADDED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=ADD&SOFTWINVENTID=#val(Cookie.SOFTWINVENTID)#" />
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMANUALS EQ "MODIFY">
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYDELETE" />
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMANUALS EQ "MODIFYLOOP">
	<H1>Data MODIFIED!</H1><BR />
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMANUALS EQ "NEXTRECORD">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYLOOP" />
		<CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMANUALS EQ "DELETELOOP">
	<CFQUERY name="DeleteSoftwareManuals" datasource="#application.type#SOFTWARE">
		DELETE FROM	MANUALS
		WHERE 		MANUALS.MANUALSID = #val(Cookie.MANUALSID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYLOOP" />
		<CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSSOFTWAREMANUALS#, 1) NEQ 0 OR FORM.PROCESSSOFTWAREMANUALS EQ "CANCELADD">
	<CFIF FORM.PROCESSSOFTWAREMANUALS EQ "DELETE" OR FORM.PROCESSSOFTWAREMANUALS EQ "CANCELADD">
		<CFQUERY name="DeleteSoftwareManuals" datasource="#application.type#SOFTWARE">
			DELETE FROM	MANUALS
			WHERE 		MANUALS.MANUALSID = #val(Cookie.MANUALSID)#
		</CFQUERY>
	</CFIF>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSOFTWAREMANUALS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremanuals.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data DELETED!");
				window.close();
		 	-->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>