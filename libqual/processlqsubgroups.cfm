<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processlqsubgroups.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to LibQual - LibQual SubGroups --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library LibQual - LibQual SubGroups</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSLQSUBGROUPS EQ "ADD" OR FORM.PROCESSLQSUBGROUPS EQ "MODIFY">
	<CFQUERY name="ModifyLQSubGroups" datasource="#application.type#LIBQUAL">
		UPDATE	LQSUBGROUPS
		SET		LQGROUPNAMEID = #val(FORM.LQGROUPNAMEID)#,
				SUBGROUPFIELDNAME = UPPER('#FORM.SUBGROUPFIELDNAME#'),
				SUBGROUPNAME = UPPER('#FORM.SUBGROUPNAME#')
		WHERE	(LQSUBGROUPID = #val(Cookie.LQSUBGROUPID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSLQSUBGROUPS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/lqsubgroups.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/lqsubgroups.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSLQSUBGROUPS EQ "DELETE" OR FORM.PROCESSLQSUBGROUPS EQ "CANCELADD">
	<CFQUERY name="DeleteLQSubGroups" datasource="#application.type#LIBQUAL">
		DELETE FROM	LQSUBGROUPS
		WHERE		LQSUBGROUPID = #val(Cookie.LQSUBGROUPID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSLQSUBGROUPS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/lqsubgroups.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>