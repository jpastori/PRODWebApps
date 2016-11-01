<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: setacademicyear.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/19/2007 --->
<!--- Date in Production: 01/19/2007 --->
<!--- Module: Set Current Academic Year to Web Reports - Bibliography/Disciplines --->
<!-- Last modified by John R. Pastori on 01/19/2007 using ColdFusion Studio. -->

<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Set Current Academic Year to Web Reports - Bibliography/Disciplines</TITLE>
	<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="LookupCurrentAcademicYear" DATASOURCE="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_4DIGIT AS FISCALYEAR
	FROM		FISCALYEARS
	WHERE	CURRENTFISCALYEAR = 'YES'
	ORDER BY	FISCALYEAR
</cfquery>

<cfquery name="ModifyBiblioDisciplines" DATASOURCE="#application.type#WEBREPORTS">
	UPDATE	BIBLIODISCIPLINES
	SET		BIBLIODISCIPLINES.BIBLIOACADEMICYEARID = #val(LookupCurrentAcademicYear.FISCALYEARID)#
</cfquery>

<H1>Data MODIFIED!</H1>
<META HTTP-EQUIV="Refresh" CONTENT="1; URL=/#application.type#apps/webreports/index.cfm?logout=No" />
</cfoutput>

</BODY>
</HTML>