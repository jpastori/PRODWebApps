<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmovetypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/31/2008 --->
<!--- Date in Production: 01/31/2008 --->
<!--- Module: Process Information to Facilities - Move Types --->
<!-- Last modified by John R. Pastori on 01/31/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Move Types</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSMOVETYPES EQ "ADD" OR FORM.PROCESSMOVETYPES EQ "MODIFY">
	<CFQUERY name="ModifyMoveTypes" datasource="#application.type#FACILITIES">
		UPDATE	MOVETYPES
		SET		MOVETYPENAME = UPPER('#FORM.MOVETYPENAME#')
		WHERE	(MOVETYPEID = #val(Cookie.MOVETYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSMOVETYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/movetypes.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/movetypes.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSMOVETYPES EQ "DELETE" OR FORM.PROCESSMOVETYPES EQ "CANCELADD">
	<CFQUERY name="DeleteMoveTypes" datasource="#application.type#FACILITIES">
		DELETE FROM	MOVETYPES 
		WHERE 		MOVETYPEID = #val(Cookie.MOVETYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSMOVETYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/movetypes.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>