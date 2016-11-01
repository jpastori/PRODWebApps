<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processtnsrequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Process Information to Facilities - TNS Requests --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - TNS Requests</TITLE>
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSTNSREQUEST EQ "ADD" OR FORM.PROCESSTNSREQUEST EQ "MODIFY">
	<CFQUERY name="UpdateTNSRequestInfo" datasource="#application.type#FACILITIES">
		UPDATE	TNSREQUESTS
		SET		TNSREQUESTS.ROOMID = #val(FORM.ROOMID)#,
				TNSREQUESTS.JACKNUMBERID=#val(FORM.JACKNUMBERID)#,
				TNSREQUESTS.CAMPUSPHONE = '#FORM.CAMPUSPHONE#',
			<CFIF IsDefined('FORM.DIALINGCAPABILITY')>	
				TNSREQUESTS.DIALINGCAPABILITY = '#FORM.DIALINGCAPABILITY#', 
				TNSREQUESTS.LONGDISTAUTHCODE = '#FORM.LONGDISTAUTHCODE#', 
				TNSREQUESTS.NUMBERLISTED = '#FORM.NUMBERLISTED#',
			</CFIF>
				TNSREQUESTS.ESTIMATEONLY = '#FORM.ESTIMATEONLY#'
		WHERE	TNSREQUESTID = #val(Cookie.TNSREQUESTID)#
	</CFQUERY>
	
	<CFIF FORM.PROCESSTNSREQUEST EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/workrequest.cfm?PROCESS=ADD" />
		<CFEXIT>
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFYDELETE" />
		<CFEXIT>
	</CFIF>
</CFIF>
<CFIF FORM.PROCESSTNSREQUEST EQ "DELETE" OR FORM.PROCESSTNSREQUEST EQ "CANCELADD">
	<CFQUERY name="DeleteTNSRequestInfo" datasource="#application.type#FACILITIES">
		DELETE FROM 	TNSREQUESTS
		WHERE 		TNSREQUESTID = #val(Cookie.TNSREQUESTID)#
	</CFQUERY> 
	<CFIF FORM.PROCESSTNSREQUEST EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/tnsrequestinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>