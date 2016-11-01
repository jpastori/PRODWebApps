<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processbudgettypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/27/2011 --->
<!--- Date in Production: 09/27/2011 --->
<!--- Module: Process Information to IDT Purchasing - Budget Types --->
<!-- Last modified by John R. Pastori on 09/27/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchasing - Budget Types</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSBUDGETTYPES EQ "ADD" OR FORM.PROCESSBUDGETTYPES EQ "MODIFY">
	<CFQUERY name="ModifyBudgetTypes" datasource="#application.type#PURCHASING">
		UPDATE	BUDGETTYPES
		SET		BUDGETTYPENAME = UPPER('#FORM.BUDGETTYPENAME#')
		WHERE	(BUDGETTYPEID = #val(Cookie.BUDGETTYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSBUDGETTYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/budgettypes.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/budgettypes.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSBUDGETTYPES EQ "DELETE" OR FORM.PROCESSBUDGETTYPES EQ "CANCELADD">
	<CFQUERY name="DeleteBudgetTypes" datasource="#application.type#PURCHASING">
		DELETE FROM	BUDGETTYPES
		WHERE 		BUDGETTYPEID = #val(Cookie.BUDGETTYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSBUDGETTYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/budgettypes.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>