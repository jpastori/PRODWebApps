<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcomputertypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/31/2008 --->
<!--- Date in Production: 01/31/2008 --->
<!--- Module: Process Information to Facilities - Computer Types --->
<!-- Last modified by John R. Pastori on 01/31/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Computer Types</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSCOMPUTERTYPES EQ "ADD" OR FORM.PROCESSCOMPUTERTYPES EQ "MODIFY">
	<CFQUERY name="ModifyComputerTypes" datasource="#application.type#FACILITIES">
		UPDATE	COMPUTERTYPES
		SET		COMPUTERTYPENAME = UPPER('#FORM.COMPUTERTYPENAME#')
		WHERE	(COMPUTERTYPEID = #val(Cookie.COMPUTERTYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCOMPUTERTYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/computertypes.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/computertypes.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCOMPUTERTYPES EQ "DELETE" OR FORM.PROCESSCOMPUTERTYPES EQ "CANCELADD">
	<CFQUERY name="DeleteComputerTypes" datasource="#application.type#FACILITIES">
		DELETE FROM	COMPUTERTYPES 
		WHERE 		COMPUTERTYPEID = #val(Cookie.COMPUTERTYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSCOMPUTERTYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/computertypes.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>