<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processrooms.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/27/2008 --->
<!--- Date in Production: 02/27/2008 --->
<!--- Module: Process Information to Instruction - Rooms --->
<!-- Last modified by John R. Pastori on 02/27/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - Rooms</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSROOMS EQ "ADD" OR FORM.PROCESSROOMS EQ "MODIFY">
	<CFQUERY name="ModifyRooms" datasource="#application.type#INSTRUCTION">
		UPDATE	ROOMS
		SET		ROOMNAME = '#FORM.ROOMNAME#'
		WHERE	(ROOMID = #val(Cookie.ROOMID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSROOMS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/rooms.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/rooms.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSROOMS EQ "DELETE" OR FORM.PROCESSROOMS EQ "CANCELADD">
	<CFQUERY name="DeleteRooms" datasource="#application.type#INSTRUCTION">
		DELETE FROM	ROOMS 
		WHERE 		ROOMID = #val(Cookie.ROOMID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSROOMS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/rooms.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>