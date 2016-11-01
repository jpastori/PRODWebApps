<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsorientstats.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/29/2012 --->
<!--- Date in Production: 06/29/2012 --->
<!--- Module: Process Information to Instruction - Orientation Statistics --->
<!-- Last modified by John R. Pastori on 06/29/2012 using ColdFusion Studio. -->

<CFIF SESSION.ORIGINSERVER EQ "">
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET SESSION.RETURNPGM = "/#application.type#apps/instruction/index.cfm?logout=No">
<CFELSE>
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
</CFIF>

<HTML>
<HEAD>
	<TITLE>Process Information to Instruction - Orientation Statistics</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSORIENTSTATS#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSORIENTSTATS#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSORIENTSTATS#, 1) EQ 0)>
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifySoftwareInventory" datasource="#application.type#INSTRUCTION">
		UPDATE	ORIENTSTATS
		SET		INSTRUCTOR1ID = #val(FORM.INSTRUCTOR1ID)#,
				INSTRUCTOR2ID = #val(FORM.INSTRUCTOR2ID)#,
				INSTRUCTOR3ID = #val(FORM.INSTRUCTOR3ID)#,
				FACULTYCONTACT = UPPER('#FORM.FACULTYCONTACT#'),
				COURSENUMBER = UPPER('#FORM.COURSENUMBER#'),
				CATEGORYID = #val(FORM.CATEGORYID)#,
				DEPARTMENTID = #val(FORM.DEPARTMENTID)#,
				SDSURELATED = UPPER('#FORM.SDSURELATED#'),
				PARTICIPANTQTY = #val(FORM.PARTICIPANTQTY)#,
				STATUSID = #val(FORM.STATUSID)#,
				ROOMID = #val(FORM.ROOMID)#,
				MONTHID = #val(FORM.MONTHID)#,
				DAYID = #val(FORM.DAYID)#,
				ACADEMICYEARID = #val(FORM.ACADEMICYEARID)#,
				STARTTIMEID = #val(FORM.STARTTIMEID)#,
				PRESENTLENGTHID = #val(FORM.PRESENTLENGTHID)#,
				INSTRUCTORNAME = UPPER('#FORM.INSTRUCTORNAME#'),
				SEMESTERID = #val(FORM.SEMESTERID)#,
				USEDCLICKERS = UPPER('#FORM.USEDCLICKERS#'),
				USEDTABLETPCS = UPPER('#FORM.USEDTABLETPCS#')
		WHERE	ORIENTSTATSID = #val(Cookie.ORIENTSTATSID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>

<CFIF FORM.PROCESSORIENTSTATS EQ "ADD">
	<H1>Data ADDED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/orientstats.cfm?PROCESS=ADD" />
</CFIF>

<CFIF FORM.PROCESSORIENTSTATS EQ "MODIFY">
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/orientstats.cfm?PROCESS=MODIFYDELETE" />
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSORIENTSTATS#, 1) NEQ 0 OR FORM.PROCESSORIENTSTATS EQ "CANCELADD">

	<CFQUERY name="DeleteSoftwareInventory" datasource="#application.type#INSTRUCTION">
		DELETE FROM	ORIENTSTATS
		WHERE 		ORIENTSTATSID = #val(Cookie.ORIENTSTATSID)#
	</CFQUERY>

	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSORIENTSTATS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/instruction/orientstats.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#SESSION.RETURNPGM#" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>