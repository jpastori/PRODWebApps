<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processbibliodisciplinesinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Bibliography/Disciplines --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Bibliography/Disciplines </TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSBIBLIODISCIPLINES EQ "ADD" OR FORM.PROCESSBIBLIODISCIPLINES EQ "MODIFY">
	<CFQUERY name="ModifyBiblioDisciplines" datasource="#application.type#WEBREPORTS">
		UPDATE	BIBLIODISCIPLINES
		SET		BIBLIODISCIPLINES.DISCIPLINEID = #val(FORM.DISCIPLINEID)#,
				BIBLIODISCIPLINES.SUBDISCIPLINE = '#FORM.SUBDISCIPLINE#',
				BIBLIODISCIPLINES.BIBLIOGRAPHERID = #val(FORM.BIBLIOGRAPHERID)#,
				BIBLIODISCIPLINES.ALTERNATEBIBLIOGRAPHERID =  #val(FORM.ALTERNATEBIBLIOGRAPHERID)#
			<CFIF FORM.PROCESSBIBLIODISCIPLINES EQ "MODIFY">
				, BIBLIODISCIPLINES.BIBLIOACADEMICYEARID = #val(FORM.BIBLIOACADEMICYEARID)#
			</CFIF>
		WHERE	(BIBLIODISCIPLINES.BIBLIODISCIPLINEID = #val(Cookie.BIBLIODISCIPLINEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSBIBLIODISCIPLINES EQ "ADD">
		<H1>Data ADDED!	</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/bibliodisciplinesinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/bibliodisciplinesinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSBIBLIODISCIPLINES EQ "DELETE" OR FORM.PROCESSBIBLIODISCIPLINES EQ "CANCELADD">
	<CFQUERY name="DeleteBiblioDisciplines" datasource="#application.type#WEBREPORTS">
		DELETE FROM	BIBLIODISCIPLINES
		WHERE 		BIBLIODISCIPLINEID = #val(Cookie.BIBLIODISCIPLINEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSBIBLIODISCIPLINES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/bibliodisciplinesinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>