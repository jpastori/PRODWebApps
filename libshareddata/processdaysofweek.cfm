<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processdaysofweek.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data - Days Of The Week --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data - Days Of The Week</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSDAYSOFWEEK EQ "ADD" OR FORM.PROCESSDAYSOFWEEK EQ "MODIFY">
	<CFQUERY name="ModifyDaysOfWeek" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	DAYSOFWEEK
		SET		DAYSOFWEEKNAME = UPPER('#FORM.DAYSOFWEEKNAME#')
		WHERE	(DAYSOFWEEKID = #val(Cookie.DAYSOFWEEKID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSDAYSOFWEEK EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/daysofweek.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/daysofweek.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSDAYSOFWEEK EQ "DELETE" OR FORM.PROCESSDAYSOFWEEK EQ "CANCELADD">
	<CFQUERY name="DeleteDaysOfWeek" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	DAYSOFWEEK
		WHERE 		DAYSOFWEEKID = #val(Cookie.DAYSOFWEEKID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSDAYSOFWEEK EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/daysofweek.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>