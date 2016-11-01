<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsdsucourses.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/27/2008 --->
<!--- Date in Production: 02/27/2008 --->
<!--- Module: Process Information to Instruction - SDSU Courses --->
<!-- Last modified by John R. Pastori on 02/27/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - SDSU Courses</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSSDSUCOURSES EQ "ADD" OR FORM.PROCESSSDSUCOURSES EQ "MODIFY">
	<CFQUERY name="ModifySDSUCourses" datasource="#application.type#INSTRUCTION" dbtype="ORACLE80">
		UPDATE	SDSUCOURSES
		SET		COURSENUMBER = '#FORM.COURSENUMBER#',
				COURSENAME = '#FORM.COURSENAME#',
				PROFESSORID = #val(FORM.PROFESSORID)#
		WHERE	(COURSEID = #val(Cookie.COURSEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSSDSUCOURSES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/sdsucourses.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/sdsucourses.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSDSUCOURSES EQ "DELETE" OR FORM.PROCESSSDSUCOURSES EQ "CANCELADD">
	<CFQUERY name="DeleteSDSUCourses" datasource="#application.type#INSTRUCTION" dbtype="ORACLE80">
		DELETE FROM	SDSUCOURSES 
		WHERE		COURSEID = #val(Cookie.COURSEID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSDSUCOURSES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/sdsucourses.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>