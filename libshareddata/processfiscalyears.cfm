<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processfiscalyears.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data - Fiscal/Academic Years --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Fiscal Years Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSFISCALYEARS EQ "ADD" OR FORM.PROCESSFISCALYEARS EQ "MODIFY">
	<CFQUERY name="ModifyFiscalYears" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	FISCALYEARS
		SET		FISCALYEAR_2DIGIT = '#FORM.FISCALYEAR_2DIGIT#',
				FISCALYEAR_4DIGIT = '#FORM.FISCALYEAR_4DIGIT#',
				CURRENTFISCALYEAR = UPPER('#FORM.CURRENTFISCALYEAR#'),
				CURRENTACADEMICYEAR = UPPER('#FORM.CURRENTACADEMICYEAR#')
		WHERE	(FISCALYEARID = #val(Cookie.FISCALYEARID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSFISCALYEARS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/fiscalyears.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/fiscalyears.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSFISCALYEARS EQ "DELETE" OR FORM.PROCESSFISCALYEARS EQ "CANCELADD">
	<CFQUERY name="DeleteFiscalYears" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	FISCALYEARS 
		WHERE		FISCALYEARID = #val(Cookie.FISCALYEARID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSFISCALYEARS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/fiscalyears.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>