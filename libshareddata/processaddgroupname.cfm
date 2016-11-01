<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddgroupname.cfm.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/14/2007 --->
<!--- Date in Production: 01/14/2007 --->
<!--- Module: Process Information to Library Shared Data - Units Info - Campus Mail Codes--->
<!-- Last modified by John R. Pastori on 01/14/2007 using ColdFusion Studio. -->

<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<cfquery name="GetGroupName" DATASOURCE="#application.type#LIBSHAREDDATA">
	SELECT	GROUPID, GROUPNAME
	FROM		GROUPS
	WHERE	GROUPNAME = <CFQUERYPARAM VALUE="#FORM.GROUPNAME#" CFSQLTYPE="CF_SQL_VARCHAR">
	ORDER BY	GROUPNAME
</cfquery>

<CFIF #GetGroupName.RecordCount# EQ 0>
	<cfquery name="GetMaxUniqueID" DATASOURCE="#application.type#LIBSHAREDDATA">
		SELECT	MAX(GROUPID) AS MAX_ID
		FROM		GROUPS
	</cfquery>
	<cfset FORM.GROUPID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFQUERY name="AddGroupName" DATASOURCE="#application.type#LIBSHAREDDATA">
		INSERT INTO	GROUPS (GROUPID, GROUPNAME)
		VALUES		(#val(FORM.GROUPID)#, UPPER('#FORM.GROUPNAME#'))
	</CFQUERY>
<CFELSE>
	<cfset FORM.GROUPID = #GetGroupName.GROUPID#>
</CFIF>