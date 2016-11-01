<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcategory.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/27/2008 --->
<!--- Date in Production: 02/27/2008 --->
<!--- Module: Process Information to Instruction - Category --->
<!-- Last modified by John R. Pastori on 02/27/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - Category</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCATEGORIES EQ "ADD" OR FORM.PROCESSCATEGORIES EQ "MODIFY">
	<CFQUERY name="ModifyCategory" datasource="#application.type#INSTRUCTION">
		UPDATE	CATEGORY
		SET		CATEGORYNAME = '#FORM.CATEGORYNAME#'
		WHERE	(CATEGORYID = #val(Cookie.CATEGORYID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCATEGORIES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/category.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/category.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCATEGORIES EQ "DELETE" OR FORM.PROCESSCATEGORIES EQ "CANCELADD">
	<CFQUERY name="DeleteCategory" datasource="#application.type#INSTRUCTION">
		DELETE FROM	CATEGORY 
		WHERE 		CATEGORYID = #val(Cookie.CATEGORYID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSCATEGORIES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/category.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>