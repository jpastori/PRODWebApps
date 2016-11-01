<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processimagesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 04/20/2011 --->
<!--- Date in Production: 04/20/2011 --->
<!--- Module: Process Information to IDT Software Inventory Images --->
<!-- Last modified by John R. Pastori on 04/20/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Images</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSIMAGES EQ "ADD" OR FORM.PROCESSIMAGES EQ "MODIFY">
	<CFQUERY name="ModifyImages" datasource="#application.type#SOFTWARE">
		UPDATE	IMAGES
		SET		IMAGENAME = UPPER('#FORM.IMAGENAME#'),
          		IMAGEDESCRIPTION = UPPER('#FORM.IMAGEDESCRIPTION#'),
                    IMAGENOTES = UPPER('#FORM.IMAGENOTES#')
		WHERE	(IMAGEID = #val(Cookie.IMAGEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSIMAGES EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/imagesinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/imagesinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSIMAGES EQ "DELETE" OR FORM.PROCESSIMAGES EQ "CANCELADD">
	<CFQUERY name="DeleteImages" datasource="#application.type#SOFTWARE">
		DELETE FROM	IMAGES 
		WHERE		IMAGEID = #val(Cookie.IMAGEID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSIMAGES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/imagesinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>