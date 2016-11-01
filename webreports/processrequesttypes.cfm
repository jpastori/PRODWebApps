<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processrequesttypes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Request Types --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Request Types</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSREQUESTTYPES EQ "ADD" OR FORM.PROCESSREQUESTTYPES EQ "MODIFY">
	<CFQUERY name="ModifyRequestTypes" datasource="#application.type#WEBREPORTS">
		UPDATE	REQUESTTYPES
		SET		REQUESTTYPENAME = UPPER('#FORM.REQUESTTYPENAME#'),
				REQUESTTYPEFIELDNAME = UPPER('#FORM.REQUESTTYPEFIELDNAME#')
		WHERE	(REQUESTTYPEID = #val(Cookie.REQUESTTYPEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSREQUESTTYPES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/requesttypes.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/requesttypes.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSREQUESTTYPES EQ "DELETE" OR FORM.PROCESSREQUESTTYPES EQ "CANCELADD">
	<CFQUERY name="DeleteRequestTypes" datasource="#application.type#WEBREPORTS">
		DELETE FROM	REQUESTTYPES 
		WHERE 		REQUESTTYPEID = #val(Cookie.REQUESTTYPEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSREQUESTTYPES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/requesttypes.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>