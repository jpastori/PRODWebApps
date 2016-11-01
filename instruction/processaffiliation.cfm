<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaffiliation.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/27/2008 --->
<!--- Date in Production: 02/27/2008 --->
<!--- Module: Process Information to Instruction - Affiliation --->
<!-- Last modified by John R. Pastori on 02/27/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - Affiliation</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSAFFILIATION EQ "ADD" OR FORM.PROCESSAFFILIATION EQ "MODIFY">
	<CFQUERY name="ModifyAffiliation" datasource="#application.type#INSTRUCTION">
		UPDATE	AFFILIATION
		SET		AFFILIATIONNAME = '#FORM.AFFILIATIONNAME#'
		WHERE	(AFFILIATIONID = #val(Cookie.AFFILIATIONID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSAFFILIATION EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/affiliation.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/affiliation.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSAFFILIATION EQ "DELETE" OR FORM.PROCESSAFFILIATION EQ "CANCELADD">
	<CFQUERY name="DeleteAffiliation" datasource="#application.type#INSTRUCTION">
		DELETE FROM	AFFILIATION 
		WHERE 		AFFILIATIONID = #val(Cookie.AFFILIATIONID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSAFFILIATION EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/affiliation.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>