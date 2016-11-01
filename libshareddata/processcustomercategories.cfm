<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcustomercategories.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->->
<!--- Module: Process Information to Library Shared Data Customer Category Database--->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Library Shared Data Customer Category Database</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCUSTOMERCATEGORY EQ "ADD" OR FORM.PROCESSCUSTOMERCATEGORY EQ "MODIFY">
	<CFQUERY name="ModifyCustomerCategory" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	CATEGORIES
		SET		CATEGORYNAME = UPPER('#FORM.CATEGORYNAME#')
		WHERE	(CATEGORYID = #val(Cookie.CATID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCUSTOMERCATEGORY EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/customercategories.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/customercategories.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCUSTOMERCATEGORY EQ "DELETE" OR FORM.PROCESSCUSTOMERCATEGORY EQ "CANCELADD">
	<CFQUERY name="DeleteCustomerCategory" datasource="#application.type#LIBSHAREDDATA">
		DELETE FROM	CATEGORIES 
		WHERE		CATEGORYID = #val(Cookie.CATID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSCUSTOMERCATEGORY EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/customercategories.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>