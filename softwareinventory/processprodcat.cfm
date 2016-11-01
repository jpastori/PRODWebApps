<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processprodcat.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Software Inventory - Product Categories --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Product Categories</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSPRODCATS EQ "ADD" OR FORM.PROCESSPRODCATS EQ "MODIFY">
	<CFQUERY name="ModifyProdCat" datasource="#application.type#SOFTWARE">
		UPDATE	PRODUCTCATEGORIES
		SET		PRODCATNAME = UPPER('#FORM.PRODCATNAME#')
		WHERE	(PRODCATID = #val(Cookie.PRODCATID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPRODCATS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/prodcat.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/prodcat.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPRODCATS EQ "DELETE" OR FORM.PROCESSPRODCATS EQ "CANCELADD">
	<CFQUERY name="DeleteProdCat" datasource="#application.type#SOFTWARE">
		DELETE FROM	PRODUCTCATEGORIES
		WHERE 		PRODCATID = #val(Cookie.PRODCATID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPRODCATS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/prodcat.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>