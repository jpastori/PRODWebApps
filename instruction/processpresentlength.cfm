<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpresentlength.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/27/2008 --->
<!--- Date in Production: 02/27/2008 --->
<!--- Module: Process Information to Instruction - Presentation Length --->
<!-- Last modified by John R. Pastori on 02/27/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - Presentation Length</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPRESENTLENGTH EQ "ADD" OR FORM.PROCESSPRESENTLENGTH EQ "MODIFY">
	<CFQUERY name="ModifyPresentLengths" datasource="#application.type#INSTRUCTION">
		UPDATE	PRESENTLENGTHS
		SET		PRESENTLENGTHTEXT = '#FORM.PRESENTLENGTHTEXT#',
				PRESENTLENGTH = #val(FORM.PRESENTLENGTH)#
		WHERE	(PRESENTLENGTHID = #val(Cookie.PRESENTLENGTHID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPRESENTLENGTH EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/presentlength.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/presentlength.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPRESENTLENGTH EQ "DELETE" OR FORM.PROCESSPRESENTLENGTH EQ "CANCELADD">
	<CFQUERY name="DeletePresentLengths" datasource="#application.type#INSTRUCTION">
		DELETE FROM	PRESENTLENGTHS
		WHERE 		PRESENTLENGTHID = #val(Cookie.PRESENTLENGTHID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPRESENTLENGTH EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/presentlength.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>