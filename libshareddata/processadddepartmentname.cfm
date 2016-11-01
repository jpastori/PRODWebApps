<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processadddepartmentname.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/14/2007 --->
<!--- Date in Production: 01/14/2007 --->
<!--- Module: Process Information to Library Shared Data - Units Info - Campus Mail Codes--->
<!-- Last modified by John R. Pastori on 01/14/2007 using ColdFusion Studio. -->

<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<cfquery name="GetDepartmentName" DATASOURCE="#application.type#LIBSHAREDDATA">
	SELECT	DEPARTMENTID, DEPARTMENTNAME
	FROM		DEPARTMENTS
	WHERE	DEPARTMENTNAME = <CFQUERYPARAM VALUE="#FORM.DEPARTMENTNAME#" CFSQLTYPE="CF_SQL_VARCHAR">
	ORDER BY	DEPARTMENTNAME
</cfquery>

<CFIF #GetDepartmentName.RecordCount# EQ 0>
	<cfquery name="GetMaxUniqueID" DATASOURCE="#application.type#LIBSHAREDDATA">
		SELECT	MAX(DEPARTMENTID) AS MAX_ID
		FROM		DEPARTMENTS
	</cfquery>
	<cfset FORM.DEPARTMENTID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFQUERY name="AddDepartmentName" DATASOURCE="#application.type#LIBSHAREDDATA">
		INSERT INTO	DEPARTMENTS (DEPARTMENTID, DEPARTMENTNAME)
		VALUES		(#val(FORM.DEPARTMENTID)#, UPPER('#FORM.DEPARTMENTNAME#'))
	</CFQUERY>
<CFELSE>
	<cfset FORM.DEPARTMENTID = #GetDepartmentName.DEPARTMENTID#>
</CFIF>