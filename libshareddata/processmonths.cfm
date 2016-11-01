<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmonths.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data Months Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Months Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSMONTHS EQ "ADD" OR FORM.PROCESSMONTHS EQ "MODIFY">
	<CFQUERY name="ModifyMonths" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	MONTHS
		SET		MONTHNAME = UPPER('#FORM.MONTHNAME#'),
				MONTHNUMBERASCHAR = '#FORM.MONTHNUMBERASCHAR#'
		WHERE	(MONTHID = #val(Cookie.MONTHID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSMONTHS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/months.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/months.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSMONTHS EQ "DELETE" OR FORM.PROCESSMONTHS EQ "CANCELADD">
	<CFQUERY name="DeleteMonths" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	MONTHS 
		WHERE		MONTHID = #val(Cookie.MONTHID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSMONTHS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/months.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>