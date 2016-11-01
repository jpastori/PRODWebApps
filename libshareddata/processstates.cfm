<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processstates.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data States Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data States Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSTATES EQ "ADD" OR FORM.PROCESSSTATES EQ "MODIFY">
	<CFQUERY name="ModifyStates" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	STATES
		SET		STATECODE = '#FORM.STATECODE#',
				STATENAME = '#FORM.STATENAME#'
		WHERE	(STATEID = #val(Cookie.STATEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSTATES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/states.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/states.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSTATES EQ "DELETE" OR FORM.PROCESSSTATES EQ "CANCELADD">
	<CFQUERY name="DeleteStates" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	STATES
		WHERE		STATEID = #val(Cookie.STATEID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSTATES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/states.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>