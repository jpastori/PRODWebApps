<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processhours.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data Hours Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Hours Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSHOURS EQ "ADD" OR FORM.PROCESSHOURS EQ "MODIFY">
	<CFQUERY name="ModifyHours" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	HOURS
		SET		HOURS.HOURSTEXT = UPPER('#FORM.HOURSTEXT#'),
				HOURS.HOURS = TO_DATE('30-Dec-1899 #FORM.HOURS#', 'DD-MON-YYYY HH:MI:SS AM')
		WHERE	(HOURSID = #val(Cookie.HOURSID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSHOURS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/hours.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/hours.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSHOURS EQ "DELETE" OR FORM.PROCESSHOURS EQ "CANCELADD">
	<CFQUERY name="DeleteHours" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	HOURS 
		WHERE		HOURSID = #val(Cookie.HOURSID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF #FORM.PROCESSHOURS# EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/hours.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>