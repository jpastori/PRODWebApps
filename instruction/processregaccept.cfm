<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processregaccept.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/27/2008 --->
<!--- Date in Production: 02/27/2008 --->
<!--- Module: Process Information to Instruction - Registration Acceptance Type --->
<!-- Last modified by John R. Pastori on 02/27/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - Registration Acceptance Type</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSREGACCEPTTYPE EQ "ADD" OR FORM.PROCESSREGACCEPTTYPE EQ "MODIFY">
	<CFQUERY name="ModifyRegAcceptType" datasource="#application.type#INSTRUCTION">
		UPDATE	REGACCEPT
		SET		REGACCEPTTYPE = '#FORM.REGACCEPTTYPE#'
		WHERE	(REGACCEPTID = #val(Cookie.REGACCEPTID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSREGACCEPTTYPE EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/regaccept.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/regaccept.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSREGACCEPTTYPE EQ "DELETE" OR FORM.PROCESSREGACCEPTTYPE EQ "CANCELADD">
	<CFQUERY name="DeleteRegAcceptType" datasource="#application.type#INSTRUCTION">
		DELETE FROM	REGACCEPT 
		WHERE 		REGACCEPTID = #val(Cookie.REGACCEPTID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSREGACCEPTTYPE EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/regaccept.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>