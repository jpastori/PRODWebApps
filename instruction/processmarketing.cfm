<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmarketing.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/27/2008 --->
<!--- Date in Production: 02/27/2008 --->
<!--- Module: Process Information to Instruction - Marketing --->
<!-- Last modified by John R. Pastori on 02/27/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - Marketing</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSMARKETING EQ "ADD" OR FORM.PROCESSMARKETING EQ "MODIFY">
	<CFQUERY name="ModifyMarketing" datasource="#application.type#INSTRUCTION">
		UPDATE	MARKETING
		SET		MARKETINGTYPE = '#FORM.MARKETINGTYPE#'
		WHERE	(MARKETINGID = #val(Cookie.MARKETINGID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSMARKETING EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/marketing.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/marketing.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSMARKETING EQ "DELETE" OR FORM.PROCESSMARKETING EQ "CANCELADD">
	<CFQUERY name="DeleteMarketing" datasource="#application.type#INSTRUCTION">
		DELETE FROM	MARKETING 
		WHERE 		MARKETINGID = #val(Cookie.MARKETINGID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSMARKETING EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/marketing.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>