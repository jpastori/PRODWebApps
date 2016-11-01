<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processalphatitles.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Shared Data - Alpha Titles --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Shared Data - Alpha Titles</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSALPHATITLES EQ "ADD" OR FORM.PROCESSALPHATITLES EQ "MODIFY">
	<CFQUERY name="ModifyAlphaTitles" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	ALPHATITLES
		SET		ALPHATITLE = '#FORM.ALPHATITLE#'
		WHERE	(ALPHATITLEID = #val(Cookie.ALPHATITLEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSALPHATITLES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/alphatitles.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/alphatitles.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSALPHATITLES EQ "DELETE" OR FORM.PROCESSALPHATITLES EQ "CANCELADD">
	<CFQUERY name="DeleteAlphaTitles" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	ALPHATITLES 
		WHERE 		ALPHATITLEID = #val(Cookie.ALPHATITLEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSALPHATITLES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/alphatitles.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>