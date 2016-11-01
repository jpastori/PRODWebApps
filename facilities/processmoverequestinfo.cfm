<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmoverequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Process Information to Facilities - Move Requests --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Move Requests</TITLE>
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSMOVEREQUEST EQ "ADD" OR FORM.PROCESSMOVEREQUEST EQ "MODIFY">
	
	<CFIF NOT IsDefined('session.MOVEREQUESTCOUNTER')OR session.MOVEREQUESTCOUNTER EQ 0>
		<CFSET session.MOVEREQUESTCOUNTER = 1>
		<CFSET session.NUMMOVESNEEDED = #FORM.NUMMOVESNEEDED#>
	</CFIF>
	MOVE REQUEST COUNTER = #session.MOVEREQUESTCOUNTER#
	<CFIF FIND('TNS', #FORM.REQUESTTYPENAME#, 1) EQ 0>
		<CFSET FORMATDELIVERYDATE = DateFormat(#FORM.DELIVERYDATE#, "dd-mmm-yyyy")>
		<CFSET FORMATPICKUPDATE = DateFormat(#FORM.PICKUPDATE#, "dd-mmm-yyyy")>
		<CFSET FORMATCURRENTTIME = TimeFormat(#NOW()#, "HH:mm:ss")>
	</CFIF>

	<CFQUERY name="UpdateMoveRequest" datasource="#application.type#FACILITIES">
		UPDATE	MOVEREQUESTS 
		SET		MOVETYPEID = #val(FORM.MOVETYPEID)#,
				ITEMDESCRIPTION = '#FORM.ITEMDESCRIPTION#',
			<CFIF FIND('TNS', #FORM.REQUESTTYPENAME#, 1) EQ 0>
				STATENUMBER = '#FORM.STATENUMBER#',
				PICKUPDATE = TO_DATE('#FORMATPICKUPDATE# #FORMATCURRENTTIME#', 'DD-MON-YY HH24:MI:SS'),
				DELIVERYDATE = TO_DATE('#FORMATDELIVERYDATE# #FORMATCURRENTTIME#', 'DD-MON-YY HH24:MI:SS'),
				NUMBEROFBOXES = #val(FORM.NUMBEROFBOXES)#,
				NUMBEROFCHAIRS = #val(FORM.NUMBEROFCHAIRS)#,
				NUMBEROFTABLES = #val(FORM.NUMBEROFTABLES)#,
			</CFIF>
				ESTIMATEONLY = '#FORM.ESTIMATEONLY#',
				FROMROOMID = #val(FORM.FROMROOMID)#,
			<CFIF FIND('TNS', #FORM.REQUESTTYPENAME#, 1) NEQ 0>
				CAMPUSPHONE = '#FORM.CAMPUSPHONE#',
				FROMJACKNUMBERID = #val(FORM.FROMJACKNUMBERID)#,
			</CFIF>
				TOROOMID = #val(FORM.TOROOMID)#
			<CFIF FIND('TNS', #FORM.REQUESTTYPENAME#, 1) NEQ 0 AND FIND('MOVE', #FORM.REQUESTTYPENAME#, 1) NEQ 0 AND #FORM.TOJACKNUMBERID# GT 0>
				, TOJACKNUMBERID = #val(FORM.TOJACKNUMBERID)#
			</CFIF>
		WHERE	(MOVEREQUESTID = #val(Cookie.MOVEREQUESTID)#)
	</CFQUERY>

	<A href="/"><IMG src="/images/bigheader.jpg" width="279" height="63" alt="LFOLKS Intranet Web Site" align="left" VALIGN="top" border="0" /></A>
		<BR /><BR /><BR /><BR /><BR />
	<CFIF FORM.PROCESSMOVEREQUEST EQ "ADD">
		<H1>Data ADDED!</H1>
	<CFELSE>
		<H1>Data MODIFIED!</H1>
	</CFIF>

	<CFIF session.MOVEREQUESTCOUNTER LT #session.NUMMOVESNEEDED#>
		<CFSET session.MOVEREQUESTCOUNTER = session.MOVEREQUESTCOUNTER + 1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/moverequestinfo.cfm?PROCESS=#FORM.PROCESSMOVEREQUEST#&MOVETYPEID=#FORM.MOVETYPEID#&PICKUPDATE=#FORM.PICKUPDATE#&DELIVERYDATE=#FORM.DELIVERYDATE#" />
	<CFELSE>
		<CFSET session.MOVEREQUESTCOUNTER = 0>
		<CFSET session.NUMMOVESNEEDED = 0>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/workrequest.cfm?PROCESS=#FORM.PROCESSMOVEREQUEST#" />
	</CFIF>

</CFIF>

<CFIF FORM.PROCESSMOVEREQUEST EQ "DELETE" OR FORM.PROCESSMOVEREQUEST EQ "CANCELADD">
	<CFQUERY name="DeleteMoveRequestInfo" datasource="#application.type#FACILITIES">
		DELETE FROM 	MOVEREQUESTS
		WHERE 		MOVEREQUESTID = #val(Cookie.MOVEREQUESTID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSMOVEREQUEST EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/moverequestinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>