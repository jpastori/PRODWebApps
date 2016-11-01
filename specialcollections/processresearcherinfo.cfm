<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processresearcherinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/16/2008 --->
<!--- Date in Production: 05/16/2008 --->
<!--- Module: Process Information to Special Collections - Researcher Information --->
<!-- Last modified by John R. Pastori on 05/16/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Special Collections - Researcher Information</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSRESEARCHERINFO EQ "ADD" OR FORM.PROCESSRESEARCHERINFO EQ "MODIFY">
	<CFQUERY name="ModifyResearcherInfo" datasource="#application.type#SPECIALCOLLECTIONS">
		UPDATE	RESEARCHERINFO
		SET		HONORIFIC = '#FORM.HONORIFIC#',
				FIRSTNAME = '#FORM.FIRSTNAME#',
				LASTNAME = '#FORM.LASTNAME#',
				FULLNAME = '#FORM.FIRSTNAME# #FORM.LASTNAME#',
				INSTITUTION = '#FORM.INSTITUTION#',
				DEPTMAJOR = '#FORM.DEPTMAJOR#',
				ADDRESS = '#FORM.ADDRESS#',
				CITY = '#FORM.CITY#',
				STATEID = #val(FORM.STATEID)#,
				ZIPCODE = '#FORM.ZIPCODE#',
				PHONE = '#FORM.PHONE#',
				FAX = '#FORM.FAX#',
				EMAIL = '#FORM.EMAIL#',
				IDTYPEID = #val(FORM.IDTYPEID)#,
				IDNUMBER = '#FORM.IDNUMBER#',
				STATUSID = #val(FORM.STATUSID)#,
				INITIALTOPIC = '#FORM.INITIALTOPIC#',
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	(RESEARCHERID = #val(Cookie.RESEARCHERID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSRESEARCHERINFO EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/researcherinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/researcherinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSRESEARCHERINFO EQ "DELETE" OR FORM.PROCESSRESEARCHERINFO EQ "CANCELADD">
	<CFQUERY name="DeleteResearcherInfo" datasource="#application.type#SPECIALCOLLECTIONS">
		DELETE FROM	RESEARCHERINFO 
		WHERE 		RESEARCHERID = #val(Cookie.RESEARCHERID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSRESEARCHERINFO EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/researcherinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>