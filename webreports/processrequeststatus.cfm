<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processrequeststatus.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Request Status --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Request Status</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSREQUESTSTATUS EQ "ADD" OR FORM.PROCESSREQUESTSTATUS EQ "MODIFY">
	<CFQUERY name="ModifyRequestStatus" datasource="#application.type#WEBREPORTS">
		UPDATE	REQUESTSTATUS
		SET		REQUESTSTATUSNAME = UPPER('#FORM.REQUESTSTATUSNAME#')
		WHERE	(REQUESTSTATUSID = #val(Cookie.REQUESTSTATUSID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSREQUESTSTATUS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/requeststatus.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/requeststatus.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSREQUESTSTATUS EQ "DELETE" OR FORM.PROCESSREQUESTSTATUS EQ "CANCELADD">
	<CFQUERY name="DeleteRequestStatus" datasource="#application.type#WEBREPORTS">
		DELETE FROM	REQUESTSTATUS 
		WHERE 		REQUESTSTATUSID = #val(Cookie.REQUESTSTATUSID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSREQUESTSTATUS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/requeststatus.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>