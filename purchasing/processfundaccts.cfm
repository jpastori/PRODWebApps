<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processfundaccts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Purchasing - Fund Accounts --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchasing - Fund Accounts</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSFUNDACCTS EQ "ADD" OR FORM.PROCESSFUNDACCTS EQ "MODIFY">
	<CFQUERY name="ModifyFundAccts" datasource="#application.type#PURCHASING">
		UPDATE	FUNDACCTS
		SET		FUNDACCTNAME = UPPER('#FORM.FUNDACCTNAME#')
		WHERE	(FUNDACCTID = #val(Cookie.FUNDACCTID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSFUNDACCTS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/fundaccts.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/fundaccts.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSFUNDACCTS EQ "DELETE" OR FORM.PROCESSFUNDACCTS EQ "CANCELADD">
	<CFQUERY name="DeleteFundAccts" datasource="#application.type#PURCHASING">
		DELETE FROM	FUNDACCTS
		WHERE 		FUNDACCTID = #val(Cookie.FUNDACCTID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSFUNDACCTS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/fundaccts.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>