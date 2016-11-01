<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processprofessor.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/27/2008 --->
<!--- Date in Production: 02/27/2008 --->
<!--- Module: Process Information to Instruction - Professor --->
<!-- Last modified by John R. Pastori on 02/27/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - Professor</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPROFESSORS EQ "ADD" OR FORM.PROCESSPROFESSORS EQ "MODIFY">
	<CFQUERY name="ModifyProfessor" datasource="#application.type#INSTRUCTION">
		UPDATE	PROFESSORS
		SET		PROFESSORNAME = '#FORM.PROFESSORNAME#'
		WHERE	(PROFESSORID = #val(Cookie.PROFESSORID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPROFESSORS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/professor.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/professor.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPROFESSORS EQ "DELETE" OR FORM.PROCESSPROFESSORS EQ "CANCELADD">
	<CFQUERY name="DeleteProfessor" datasource="#application.type#INSTRUCTION">
		DELETE FROM	PROFESSORS
		WHERE 		PROFESSORID = #val(Cookie.PROFESSORID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPROFESSORS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/professor.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>