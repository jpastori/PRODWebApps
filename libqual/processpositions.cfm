<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpositions.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to LibQual - Positions --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library LibQual - Positions</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPOSITIONS EQ "ADD" OR FORM.PROCESSPOSITIONS EQ "MODIFY">
	<CFQUERY name="ModifyPositions" datasource="#application.type#LIBQUAL">
		UPDATE	LQPOSITIONS
		SET		LIBQUALPOSITIONID = #val(FORM.LIBQUALPOSITIONID)#,
				POSITIONNAME = '#FORM.POSITIONNAME#'
		WHERE	(POSITIONID = #val(Cookie.POSITIONID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPOSITIONS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/positions.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/positions.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPOSITIONS EQ "DELETE" OR FORM.PROCESSPOSITIONS EQ "CANCELADD">
	<CFQUERY name="DeletePositions" datasource="#application.type#LIBQUAL">
		DELETE FROM	LQPOSITIONS
		WHERE		POSITIONID = #val(Cookie.POSITIONID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPOSITIONS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/positions.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>