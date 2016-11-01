<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddmodelname.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFQUERY name="GetModelNames" datasource="#application.type#HARDWARE">
	SELECT	MODELNAMEID, MODELNAME, MODIFIEDBYID, MODIFIEDDATE
	FROM		MODELNAMELIST
	WHERE	MODELNAME = <CFQUERYPARAM value="UPPER(#FORM.MODELNAME#)" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	MODELNAME
</CFQUERY>

<CFIF #GetModelNames.RecordCount# EQ 0>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(MODELNAMEID) AS MAX_ID
		FROM		MODELNAMELIST
	</CFQUERY>
	<CFSET FORM.MODELNAMEID = #val(GetMaxUniqueID.MAX_ID+1)#>
     <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
	<CFQUERY name="AddModelNames" datasource="#application.type#HARDWARE">
		INSERT INTO	MODELNAMELIST (MODELNAMEID, MODELNAME, MODIFIEDBYID, MODIFIEDDATE)
		VALUES		(#val(FORM.MODELNAMEID)#, UPPER('#FORM.MODELNAME#'), #val(FORM.MODIFIEDBYID)#, TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
<CFELSE>
	<CFSET FORM.MODELNAMEID = #GetModelNames.MODELNAMEID#>
</CFIF>