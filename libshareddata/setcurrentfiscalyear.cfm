<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: setcurrentfiscalyear.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Set Current Fiscal Year --->
<!--- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. --->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Set Current Fiscal Year</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.YEARTYPE')>
	<CFSET URL.YEARTYPE = 'FISCAL'>
</CFIF>

<CFIF URL.YEARTYPE EQ "FISCAL">
	<CFSET BEGINYEARMONTH = "7">
	<CFSET ENDYEARMONTH = "6">
	<CFSET UPDATEFIELDNAME = "CURRENTFISCALYEAR">
<CFELSE>
	<CFSET BEGINYEARMONTH = "6">
	<CFSET ENDYEARMONTH = "5">
	<CFSET UPDATEFIELDNAME = "CURRENTACADEMICYEAR">
</CFIF>

<CFSET CURRENTYEAR = YEAR(NOW())>
<H1>CURRENT YEAR = #CURRENTYEAR#</H1><BR />
<CFSET CURRENTMONTH = MONTH(NOW())>
<H1>CURRENT MONTH = #CURRENTMONTH#</H1><BR /><BR />

<CFIF CURRENTMONTH GTE "#BEGINYEARMONTH#" AND CURRENTMONTH LTE "12">
	<CFSET BEGINFISCALYEAR = #CURRENTYEAR#>
	<CFSET SELECTEDFISCALYEAR = #BEGINFISCALYEAR# & '-' & YEAR(DateAdd('yyyy', 1, NOW()))>
	<H1>BEGINYEAR = #SELECTEDFISCALYEAR#</H1><BR />
<CFELSEIF CURRENTMONTH GTE "1" AND CURRENTMONTH LTE "#ENDYEARMONTH#">
	<CFSET ENDFISCALYEAR = #CURRENTYEAR#>
	<CFSET SELECTEDFISCALYEAR = YEAR(DateAdd('yyyy', -1, NOW())) & '-' & #ENDFISCALYEAR#>
	<H1>ENDYEAR = #SELECTEDFISCALYEAR#</H1><BR />
</CFIF>

<CFTRANSACTION action="begin">
<CFQUERY name="UpdateCurrentFiscalYearFlag" datasource="#application.type#LIBSHAREDDATA">
	UPDATE	FISCALYEARS
	SET		#UPDATEFIELDNAME# = 'YES'
	WHERE	(FISCALYEAR_4DIGIT = '#SELECTEDFISCALYEAR#')
</CFQUERY>
<CFTRANSACTION action = "commit"/>
</CFTRANSACTION>

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
	FROM		FISCALYEARS
	WHERE	FISCALYEAR_4DIGIT = <CFQUERYPARAM value="#SELECTEDFISCALYEAR#" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="ListPreviousFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR, CURRENTACADEMICYEAR
	FROM		FISCALYEARS
	WHERE	(FISCALYEARID = #ListCurrentFiscalYear.FISCALYEARID# - 1)
	ORDER BY	FISCALYEARID
</CFQUERY>
<CFSET DISPLAYFIELDNAME = "ListPreviousFiscalYear.#UPDATEFIELDNAME#">

<CFIF #EVALUATE(DISPLAYFIELDNAME)# EQ 'YES'>
	<BR /><H1>Previous #URL.YEARTYPE# Year's Current #URL.YEARTYPE# Year Flag Field = #EVALUATE(DISPLAYFIELDNAME)#</H1>
	<CFTRANSACTION action="begin">
	<CFQUERY name="UpdateCurrentFiscalYearFlag" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	FISCALYEARS
		SET		#UPDATEFIELDNAME# = 'NO'
		WHERE	(FISCALYEARID = '#ListPreviousFiscalYear.FISCALYEARID#')
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>
<BR /><BR /><H1>The Current #URL.YEARTYPE# Year has been SET to YES and <BR />the Previous #URL.YEARTYPE# Year has been set to NO!</H1>
<META http-equiv="Refresh" content="5; URL=/#application.type#apps/libshareddata/index.cfm?logout=No" />
</CFOUTPUT>

</BODY>
</HTML>