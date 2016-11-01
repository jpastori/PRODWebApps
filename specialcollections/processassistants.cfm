<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processassistants.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/10/2008 --->
<!--- Date in Production: 07/10/2008 --->
<!--- Module: Process Information to Special Collections - Assistants --->
<!-- Last modified by John R. Pastori on 07/10/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Special Collections - Assistants</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSASSISTANTS EQ "ADD" OR FORM.PROCESSASSISTANTS EQ "MODIFY">
	<CFQUERY name="ModifyAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
		UPDATE	ASSISTANTS
		SET		ASSISTANTNAME = '#FORM.ASSISTANTNAME#',
				ACTIVE = '#FORM.ACTIVE#',
				APPROVAL = '#FORM.APPROVAL#'
		WHERE	(ASSISTANTID = #val(Cookie.ASSISTANTID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSASSISTANTS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/assistants.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/assistants.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSASSISTANTS EQ "DELETE" OR FORM.PROCESSASSISTANTS EQ "CANCELADD">
	<CFQUERY name="DeleteAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
		DELETE FROM	ASSISTANTS 
		WHERE 		ASSISTANTID = #val(Cookie.ASSISTANTID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSASSISTANTS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/assistants.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>