<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processdbsystemsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2011 --->
<!--- Date in Production: 06/23/2011 --->
<!--- Module: Process Information to Library Security - Database Systems --->
<!-- Last modified by John R. Pastori on 06/23/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Security - Database Systems</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSDBSYSTEMS EQ "ADD" OR FORM.PROCESSDBSYSTEMS EQ "MODIFY">
	<CFQUERY name="ModifyDBSystems" datasource="#application.type#LIBSECURITY">
		UPDATE	DBSYSTEMS
		SET		DBSYSTEMNUMBER = #val(FORM.DBSYSTEMNUMBER)#,
				DBSYSTEMNAME = '#FORM.DBSYSTEMNAME#',
                    DBSYSTEMDIRECTORY = LOWER('#FORM.DBSYSTEMDIRECTORY#'),
				DBSYSTEMGROUP = '#FORM.DBSYSTEMGROUP#'
		WHERE	(DBSYSTEMID = #val(Cookie.DBSYSTEMID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSDBSYSTEMS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/dbsystemsinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/dbsystemsinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSDBSYSTEMS EQ "DELETE" OR FORM.PROCESSDBSYSTEMS EQ "CANCELADD">
	<CFQUERY name="DeleteDBSystems" datasource="#application.type#LIBSECURITY">
		DELETE FROM	DBSYSTEMS
		WHERE		DBSYSTEMID = #val(Cookie.DBSYSTEMID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSDBSYSTEMS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/dbsystemsinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libsecurity/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>