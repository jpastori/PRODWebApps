<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processorgcodes.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/29/2011 --->
<!--- Date in Production: 06/29/2011 --->
<!--- Module: Process Information to Shared Data - Org Codes --->
<!-- Last modified by John R. Pastori on 06/29/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data - Org Codes</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSORGCODES EQ "ADD" OR FORM.PROCESSORGCODES EQ "MODIFY">
	<CFQUERY name="ModifyOrgCodes" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	ORGCODES
		SET		ORGCODE = #FORM.ORGCODE#,
				ORGCODEDESCRIPTION = UPPER('#FORM.ORGCODEDESCRIPTION#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	ORGCODEID = #val(Cookie.ORGCODEID)#
	</CFQUERY>
	<CFIF FORM.PROCESSORGCODES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSORGCODES EQ "DELETE" OR FORM.PROCESSORGCODES EQ "CANCELADD">
	<CFQUERY name="DeleteOrgCodes" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	ORGCODES
		WHERE		ORGCODEID = #val(Cookie.ORGCODEID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSORGCODES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>