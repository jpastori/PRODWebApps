<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processlqgroups.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to LibQual - LibQual Groups --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library LibQual - LibQual Groups</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSLQGROUPS EQ "ADD" OR FORM.PROCESSLQGROUPS EQ "MODIFY">
	<CFQUERY name="ModifyLQGroups" datasource="#application.type#LIBQUAL">
		UPDATE	LQGROUPS
		SET		GROUPFIELDNAME = UPPER('#FORM.GROUPFIELDNAME#'),
				GROUPNAME = UPPER('#FORM.GROUPNAME#')
		WHERE	(LQGROUPID = #val(Cookie.LQGROUPID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSLQGROUPS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/lqgroups.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/lqgroups.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSLQGROUPS EQ "DELETE" OR FORM.PROCESSLQGROUPS EQ "CANCELADD">
	<CFQUERY name="DeleteLQGroups" datasource="#application.type#LIBQUAL">
		DELETE FROM	LQGROUPS
		WHERE		LQGROUPID = #val(Cookie.LQGROUPID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSLQGROUPS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/lqgroups.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>