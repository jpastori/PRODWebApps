<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddcampusmailcode.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/14/2007 --->
<!--- Date in Production: 01/14/2007 --->
<!--- Module: Process Information to Library Shared Data - Units Info - Campus Mail Codes--->
<!-- Last modified by John R. Pastori on 01/14/2007 using ColdFusion Studio. -->

<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<cfquery name="GetCampusMailCode" DATASOURCE="#application.type#LIBSHAREDDATA">
	SELECT	CAMPUSMAILCODEID, CAMPUSMAILCODE
	FROM		CAMPUSMAILCODES
	WHERE	CAMPUSMAILCODE = <CFQUERYPARAM VALUE="#FORM.CAMPUSMAILCODE#" CFSQLTYPE="CF_SQL_VARCHAR">
	ORDER BY	CAMPUSMAILCODE
</cfquery>

<CFIF #GetCampusMailCode.RecordCount# EQ 0>
	<cfquery name="GetMaxUniqueID" DATASOURCE="#application.type#LIBSHAREDDATA">
		SELECT	MAX(CAMPUSMAILCODEID) AS MAX_ID
		FROM		CAMPUSMAILCODES
	</cfquery>
	<cfset FORM.CAMPUSMAILCODEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFQUERY name="AddCampusMailCode" DATASOURCE="#application.type#LIBSHAREDDATA">
		INSERT INTO	CAMPUSMAILCODES (CAMPUSMAILCODEID, CAMPUSMAILCODE)
		VALUES		(#val(FORM.CAMPUSMAILCODEID)#, '#FORM.CAMPUSMAILCODE#')
	</CFQUERY>
<CFELSE>
	<cfset FORM.CAMPUSMAILCODEID = #GetCampusMailCode.CAMPUSMAILCODEID#>
</CFIF>