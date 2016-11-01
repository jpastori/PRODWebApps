<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processyearmonth.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Article DB Year-Month --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Article DB Year-Month</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSYEARMONTH EQ "ADD" OR FORM.PROCESSYEARMONTH EQ "MODIFY">
	<CFQUERY name="ModifyYearMonth" datasource="#application.type#WEBREPORTS">
		UPDATE	YEARMONTH
		SET		YEARMONTHNAME = '#FORM.YEARMONTHNAME#'
		WHERE	(YEARMONTHID = #val(Cookie.YEARMONTHID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSYEARMONTH EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/yearmonth.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/yearmonth.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSYEARMONTH EQ "DELETE" OR FORM.PROCESSYEARMONTH EQ "CANCELADD">
	<CFQUERY name="DeleteYearMonth" datasource="#application.type#WEBREPORTS">
		DELETE FROM	YEARMONTH 
		WHERE 		YEARMONTHID = #val(Cookie.YEARMONTHID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSYEARMONTH EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/yearmonth.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>