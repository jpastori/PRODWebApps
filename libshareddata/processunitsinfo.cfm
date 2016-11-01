<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processunitsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/25/2011 --->
<!--- Date in Production: 01/25/2011 --->
<!--- Module: Process Information to Library Shared Data Units/Groups Database--->
<!-- Last modified by John R. Pastori on 01/25/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Units/Groups Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSUNITS EQ "ADD">
	<CFIF #FORM.CAMPUSMAILCODE# NEQ "">
		<CFINCLUDE template="processaddcampusmailcode.cfm">
	</CFIF>

	<CFIF #FORM.GROUPNAME# NEQ "">
		<CFINCLUDE template="processaddgroupname.cfm">
	</CFIF>

	<CFIF #FORM.DEPARTMENTNAME# NEQ "">
		<CFINCLUDE template="processadddepartmentname.cfm">
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSUNITS EQ "ADD" OR FORM.PROCESSUNITS EQ "MODIFY">
	<CFQUERY name="ModifyUnits" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	UNITS
		SET		UNITNAME = UPPER('#FORM.UNITNAME#'),
				CAMPUSMAILCODEID = #val(FORM.CAMPUSMAILCODEID)#,
				GROUPID = #val(FORM.GROUPID)#,
				DEPARTMENTID = #val(FORM.DEPARTMENTID)#,
				SUPERVISORID = #val(FORM.SUPERVISORID)#,
				ACTIVEUNIT = '#FORM.ACTIVEUNIT#'
		WHERE	(UNITID = #val(Cookie.UNITID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSUNITS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/unitsinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/unitsinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSUNITS EQ "CANCELADD">
	<CFQUERY name="DeleteUnits" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	UNITS 
		WHERE		UNITS.UNITID = #val(Cookie.UNITID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>