<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processageranges.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/14/2005 --->
<!--- Date in Production: 12/14/2005 --->
<!--- Module: Process Information to Web Reports - Age Ranges --->
<!-- Last modified by John R. Pastori on 12/14/2005 using ColdFusion Studio. -->

<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<html>
<head>
	<title>Process Information to Library Web Reports - Age Ranges</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css">
</head>
<body>
<cfoutput>
<img src="/images/bigheader.jpg" width="279" height="63" alt="LFOLKS Intranet Web Site" align="left" valign="top" BORDER="0">
<br><br><br><br><br>

<CFIF FORM.PROCESSAGERANGES EQ "ADD" OR FORM.PROCESSAGERANGES EQ "MODIFY">
	<cfquery name="ModifyAgeRanges" DATASOURCE="#application.type#WEBREPORTS" dbtype="ORACLE80">
		UPDATE	AGERANGES
		SET		LIBQUALAGEID = #val(FORM.LIBQUALAGEID)#,
				AGERANGENAME = '#FORM.AGERANGENAME#'
		WHERE	(AGERANGEID = #val(Cookie.AGERANGEID)#)
	</cfquery>
	<CFIF FORM.PROCESSAGERANGES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META HTTP-EQUIV="Refresh" CONTENT="1; URL=/#application.type#apps/webreports/ageranges.cfm?PROCESS=ADD">
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META HTTP-EQUIV="Refresh" CONTENT="1; URL=/#application.type#apps/webreports/ageranges.cfm?PROCESS=MODIFYDELETE">
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSAGERANGES EQ "DELETE" OR FORM.PROCESSAGERANGES EQ "CANCELADD">
	<CFQUERY name="DeleteAgeRanges" DATASOURCE="#application.type#WEBREPORTS" dbtype="ORACLE80">
		DELETE FROM	AGERANGES
		WHERE		AGERANGEID = #val(Cookie.AGERANGEID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSAGERANGES EQ "DELETE">
		<META HTTP-EQUIV="Refresh" CONTENT="1; URL=/#application.type#apps/webreports/ageranges.cfm?PROCESS=MODIFYDELETE">
	<CFELSE>
		<META HTTP-EQUIV="Refresh" CONTENT="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No">
	</CFIF>
</CFIF>
</cfoutput>
</body>
</html>
