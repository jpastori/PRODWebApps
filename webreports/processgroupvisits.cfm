<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processgroupvisits.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Non-Affiliated Group Visits --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Web Reports - Non-Affiliated Group Visits</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSGROUPVISITS EQ "ADD" OR FORM.PROCESSGROUPVISITS EQ "MODIFY">
	<CFOUTPUT>
		<CFSET FORM.DATECHOICE1 = #DateFormat(FORM.DATECHOICE1, 'dd-mmm-yyyy')#>
		<CFIF IsDefined('FORM.DATECHOICE2')>
			<CFSET FORM.DATECHOICE2 = #DateFormat(FORM.DATECHOICE2, 'dd-mmm-yyyy')#>
		</CFIF>
		<CFIF IsDefined('FORM.DATECHOICE3')>
			<CFSET FORM.DATECHOICE3 = #DateFormat(FORM.DATECHOICE3, 'dd-mmm-yyyy')#>
		</CFIF>
		<CFQUERY name="ModifyGroupVisits" datasource="#application.type#WEBREPORTS">
			UPDATE	GROUPVISITS
			SET		REQUESTERNAME = '#FORM.REQUESTERNAME#',
					SCHOOLORGNAME = '#FORM.SCHOOLORGNAME#',
					ADDRESS = '#FORM.ADDRESS#',
					CITY = '#FORM.CITY#',
					STATEID = #val(FORM.STATEID)#,
					ZIPCODE = '#FORM.ZIPCODE#',
					WORKPHONE = '#FORM.WORKPHONE#',
					HOMEPHONE = '#FORM.HOMEPHONE#',
					CELLPHONE = '#FORM.CELLPHONE#',
					EMAIL = LOWER('#FORM.EMAIL#'),
					GRADECOURSE = '#FORM.GRADECOURSE#',
					STUDENTCOUNT = #val(FORM.STUDENTCOUNT)#,
					CHAPERONECOUNT = #val(FORM.CHAPERONECOUNT)#,
					DATECHOICE1 = TO_DATE('#FORM.DATECHOICE1# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				<CFIF NOT #FORM.DATECHOICE2# EQ ''>
					DATECHOICE2 = TO_DATE('#FORM.DATECHOICE2# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
				<CFIF NOT #FORM.DATECHOICE3# EQ ''>
					DATECHOICE3 = TO_DATE('#FORM.DATECHOICE3# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
					ARRIVALTIMEID = #val(FORM.ARRIVALTIMEID)#,
					DEPARTURETIMEID = #val(FORM.DEPARTURETIMEID)#,
					LEARNDESCR = '#FORM.LEARNDESCR#',
					REQUIREMENTDESCR = '#FORM.REQUIREMENTDESCR#'
			WHERE	(GROUPVISITID = #val(Cookie.GROUPVISITID)#)
		</CFQUERY>
	</CFOUTPUT>
	<CFIF FORM.PROCESSGROUPVISITS EQ "ADD">
		<CFMAIL
			to="phillips@rohan.sdsu.edu"
			from="infodomeweb@library.sdsu.edu"
			subject="#FORM.REQUESTERNAME# from #FORM.SCHOOLORGNAME# submitted a request to visit our Library."
		>

On #DateFormat(NOW(), 'mm/dd/yyyy')# #FORM.REQUESTERNAME#, from #FORM.SCHOOLORGNAME#, submitted a request to visit our Library.
The details can be viewed at https://lfolks.sdsu.edu/#application.type#apps/webreports/groupvisitsdbreport.cfm?GROUPVISITID=#Cookie.GROUPVISITID# .
		</CFMAIL>
		<CFOUTPUT>
			<H1>Data ADDED!</H1>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/groupvisits.cfm?PROCESS=ADD" />
		</CFOUTPUT>
	<CFELSE>
		<CFOUTPUT>
			<H1>Data MODIFIED!</H1>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/groupvisits.cfm?PROCESS=MODIFYDELETE" />
		</CFOUTPUT>
	</CFIF>
</CFIF>

<CFOUTPUT>
	<CFIF FORM.PROCESSGROUPVISITS EQ "DELETE" OR FORM.PROCESSGROUPVISITS EQ "CANCELADD">
		<CFQUERY name="DeleteGroupVisits" datasource="#application.type#WEBREPORTS">
			DELETE FROM	GROUPVISITS 
			WHERE 		GROUPVISITID = #val(Cookie.GROUPVISITID)#
		</CFQUERY> 
		<H1>Data DELETED!</H1>
		<CFIF FORM.PROCESSGROUPVISITS EQ "DELETE">
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/groupvisits.cfm?PROCESS=MODIFYDELETE" />
		<CFELSE>
			<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
		</CFIF>
	</CFIF>
</CFOUTPUT>

</BODY>
</HTML>