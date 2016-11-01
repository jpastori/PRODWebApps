<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processproductplatforms.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2011 --->
<!--- Date in Production: 08/03/2011 --->
<!--- Module: Process Information to IDT Software Inventory - Product Platforms --->
<!-- Last modified by John R. Pastori on 08/03/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Product Platforms</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSPRODUCTPLATFORMS EQ "ADD" OR FORM.PROCESSPRODUCTPLATFORMS EQ "MODIFY">
	<CFQUERY name="ModifyProductPlatforms" datasource="#application.type#SOFTWARE">
		UPDATE	PRODUCTPLATFORMS
		SET		PRODUCTPLATFORMNAME = UPPER('#FORM.PRODUCTPLATFORMNAME#')
		WHERE	(PRODUCTPLATFORMID = #val(Cookie.PRODUCTPLATFORMID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSPRODUCTPLATFORMS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/productplatforms.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/productplatforms.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPRODUCTPLATFORMS EQ "DELETE" OR FORM.PROCESSPRODUCTPLATFORMS EQ "CANCELADD">
	<CFQUERY name="DeleteProductPlatforms" datasource="#application.type#SOFTWARE">
		DELETE FROM	PRODUCTPLATFORMS 
		WHERE 		PRODUCTPLATFORMID = #val(Cookie.PRODUCTPLATFORMID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPRODUCTPLATFORMS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/productplatforms.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>