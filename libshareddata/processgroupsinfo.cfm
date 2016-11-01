<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processgroupsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Library Shared Data Groups Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Groups Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSGROUPS EQ "ADD" OR FORM.PROCESSGROUPS EQ "MODIFY">
	<CFQUERY name="ModifyGroups" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	GROUPS
		SET		GROUPNAME = UPPER('#FORM.GROUPNAME#'),
				MANAGEMENTID = #val(FORM.MANAGEMENTID)#
		WHERE	(GROUPID = #val(Cookie.GROUPID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSGROUPS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/groups.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/groups.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSGROUPS EQ "DELETE" OR FORM.PROCESSGROUPS EQ "CANCELADD">
	<CFQUERY name="DeleteGroups" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	GROUPS 
		WHERE		GROUPID = #val(Cookie.GROUPID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSGROUPS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/groups.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>