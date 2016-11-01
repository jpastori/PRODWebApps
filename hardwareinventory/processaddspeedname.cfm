<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddspeedname.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFQUERY name="GetSpeedNames" datasource="#application.type#HARDWARE">
	SELECT	SPEEDNAMEID, SPEEDNAME, MODIFIEDBYID, MODIFIEDDATE
	FROM		SPEEDNAMELIST
	WHERE	SPEEDNAME = <CFQUERYPARAM value="UPPER(#FORM.SPEEDNAME#)" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	SPEEDNAME
</CFQUERY>

<CFIF #GetSpeedNames.RecordCount# EQ 0>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(SPEEDNAMEID) AS MAX_ID
		FROM		SPEEDNAMELIST
	</CFQUERY>
	<CFSET FORM.SPEEDNAMEID = #val(GetMaxUniqueID.MAX_ID+1)#>
     <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
	<CFQUERY name="AddSpeedNamesID" datasource="#application.type#HARDWARE">
		INSERT INTO	SPEEDNAMELIST (SPEEDNAMEID, SPEEDNAME, MODIFIEDBYID, MODIFIEDDATE)
		VALUES		(#val(FORM.SPEEDNAMEID)#, UPPER('#FORM.SPEEDNAME#'), #val(FORM.MODIFIEDBYID)#, TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
<CFELSE>
	<CFSET FORM.SPEEDNAMEID = #GetSpeedNames.SPEEDNAMEID#>
</CFIF>