<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processidtypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Special Collections - ID Types --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Special Collections - ID Types</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSIDTYPES EQ "ADD" OR FORM.PROCESSIDTYPES EQ "MODIFY">
	<CFQUERY name="ModifyIDTypes" datasource="#application.type#SPECIALCOLLECTIONS">
		UPDATE	IDTYPES
		SET		IDTYPENAME = '#FORM.IDTYPENAME#'
		WHERE	(IDTYPEID = #val(Cookie.IDTYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSIDTYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/idtypes.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/idtypes.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSIDTYPES EQ "DELETE" OR FORM.PROCESSIDTYPES EQ "CANCELADD">
	<CFQUERY name="DeleteIDTypes" datasource="#application.type#SPECIALCOLLECTIONS">
		DELETE FROM	IDTYPES 
		WHERE 		IDTYPEID = #val(Cookie.IDTYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSIDTYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/idtypes.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>