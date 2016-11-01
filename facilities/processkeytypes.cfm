<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processkeytypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/31/2008 --->
<!--- Date in Production: 01/31/2008 --->
<!--- Module: Process Information to Facilities - Key Types --->
<!-- Last modified by John R. Pastori on 01/31/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Key Types</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSKEYTYPES EQ "ADD" OR FORM.PROCESSKEYTYPES EQ "MODIFY">
	<CFQUERY name="ModifyKeyTypes" datasource="#application.type#FACILITIES">
		UPDATE	KEYTYPES
		SET		KEYTYPENAME = UPPER('#FORM.KEYTYPENAME#')
		WHERE	(KEYTYPEID = #val(Cookie.KEYTYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSKEYTYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/keytypes.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/keytypes.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSKEYTYPES EQ "DELETE" OR FORM.PROCESSKEYTYPES EQ "CANCELADD">
	<CFQUERY name="DeleteKeyTypes" datasource="#application.type#FACILITIES">
		DELETE FROM	KEYTYPES 
		WHERE 		KEYTYPEID = #val(Cookie.KEYTYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSKEYTYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/keytypes.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>