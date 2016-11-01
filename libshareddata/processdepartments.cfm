<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processdepartments.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data Departments Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Departments Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSDEPARTMENTS EQ "ADD" OR FORM.PROCESSDEPARTMENTS EQ "MODIFY">
	<CFQUERY name="ModifyDepartments" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	DEPARTMENTS
		SET		DEPARTMENTNAME = UPPER('#FORM.DEPARTMENTNAME#')
		WHERE	(DEPARTMENTID = #val(Cookie.DEPARTMENTID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSDEPARTMENTS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/departments.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/departments.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSDEPARTMENTS EQ "DELETE" OR FORM.PROCESSDEPARTMENTS EQ "CANCELADD">
	<CFQUERY name="DeleteDepartments" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	DEPARTMENTS 
		WHERE		DEPARTMENTID = #val(Cookie.DEPARTMENTID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSDEPARTMENTS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/departments.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>