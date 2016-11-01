<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcheckedinitials.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to LibQual Checked Initials --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to LibQual Checked Initials</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCheckedInitials EQ "ADD" OR FORM.PROCESSCheckedInitials EQ "MODIFY">
	<CFQUERY name="ModifyCheckedInitials" datasource="#application.type#LIBQUAL">
		UPDATE	LQCHECKEDINITIALS
		SET		INITIALS = '#FORM.INITIALS#'
		WHERE	(CHECKEDINITID = #val(Cookie.CHECKEDINITID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCheckedInitials EQ "ADD">
		<H1>Data ADDED! </H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/checkedinitials.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED! </H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/checkedinitials.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCheckedInitials EQ "DELETE" OR FORM.PROCESSCheckedInitials EQ "CANCELADD">
	<CFQUERY name="DeleteCheckedInitials" datasource="#application.type#LIBQUAL">
		DELETE FROM	LQCHECKEDINITIALS 
		WHERE		CHECKEDINITID = #val(Cookie.CHECKEDINITID)#
	</CFQUERY>
	<H1>Data DELETED! </H1>
	<CFIF FORM.PROCESSCheckedInitials EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/checkedinitials.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>