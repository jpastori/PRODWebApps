<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcollections.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Special Collections - Collections --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Special Collections - Collections</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSCOLLECTIONS EQ "ADD" OR FORM.PROCESSCOLLECTIONS EQ "MODIFY">
	<CFQUERY name="ModifyCollections" datasource="#application.type#SPECIALCOLLECTIONS">
		UPDATE	COLLECTIONS
		SET		COLLECTIONNAME = '#FORM.COLLECTIONNAME#'
		WHERE	(COLLECTIONID = #val(Cookie.COLLECTIONID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSCOLLECTIONS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/collections.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/collections.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSCOLLECTIONS EQ "DELETE" OR FORM.PROCESSCOLLECTIONS EQ "CANCELADD">
	<CFQUERY name="DeleteCollections" datasource="#application.type#SPECIALCOLLECTIONS">
		DELETE FROM	COLLECTIONS 
		WHERE 		COLLECTIONID = #val(Cookie.COLLECTIONID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSCOLLECTIONS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/collections.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>