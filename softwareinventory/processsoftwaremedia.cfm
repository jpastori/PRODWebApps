<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processssoftwaremedia.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Software Inventory - Media --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Media</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSSOFTWAREMEDIA#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSSOFTWAREMEDIA#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSSOFTWAREMEDIA#, 1) EQ 0)>
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifySoftwareMedia" datasource="#application.type#SOFTWARE">
		UPDATE	MEDIA
		SET		MEDIA.MEDIATYPEID = #val(FORM.MEDIATYPEID)#,		
				MEDIA.MEDIAQTY = #val(MEDIAQTY)#,
				MEDIA.LOCATIONID = #val(FORM.LOCATIONID)#,
				MEDIA.PARTNUMBER = UPPER('#FORM.PARTNUMBER#'),
				MEDIA.TITLE = UPPER('#FORM.TITLE#'),
				MEDIA.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MEDIA.MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	MEDIA.MEDIAID = #val(Cookie.MEDIAID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMEDIA EQ "ADD">
	<H1>Data ADDED!</H1>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("Data ADDED!");
			window.close();
		 -->
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMEDIA EQ "ADDLOOP">
	<H1>Data ADDED!</H1>					
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=ADD&SOFTWINVENTID=#val(Cookie.SOFTWINVENTID)#" />
</CFIF>


<CFIF FORM.PROCESSSOFTWAREMEDIA EQ "MODIFY">
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYDELETE" />
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMEDIA EQ "MODIFYLOOP">
	<H1>Data MODIFIED!</H1><BR />
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMEDIA EQ "NEXTRECORD">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREMEDIA EQ "DELETELOOP">
	<CFQUERY name="DeleteSoftwareMedia" datasource="#application.type#SOFTWARE">
		DELETE FROM	MEDIA
		WHERE 		MEDIA.MEDIAID = #val(Cookie.MEDIAID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYLOOP" />
		<CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSSOFTWAREMEDIA#, 1) NEQ 0 OR FORM.PROCESSSOFTWAREMEDIA EQ "CANCELADD">
	<CFIF FORM.PROCESSSOFTWAREMEDIA EQ "DELETE" OR FORM.PROCESSSOFTWAREMEDIA EQ "CANCELADD">
		<CFQUERY name="DeleteSoftwareMedia" datasource="#application.type#SOFTWARE">
			DELETE FROM	MEDIA
			WHERE 		MEDIA.MEDIAID = #val(Cookie.MEDIAID)#
		</CFQUERY>
	</CFIF>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSOFTWAREMEDIA EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwaremedia.cfm?PROCESS=MODIFYDELETE" />
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