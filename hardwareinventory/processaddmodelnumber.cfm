<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddmodelnumber.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFQUERY name="GetModelNumbers" datasource="#application.type#HARDWARE">
	SELECT	MODELNUMBERID, MODELNUMBER, MODIFIEDBYID, MODIFIEDDATE
	FROM		MODELNUMBERLIST
	WHERE	MODELNUMBER = <CFQUERYPARAM value="UPPER(#FORM.MODELNUMBER#)" cfsqltype="CF_SQL_VARCHAR">
	ORDER BY	MODELNUMBER
</CFQUERY>

<CFIF #GetModelNumbers.RecordCount# EQ 0>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(MODELNUMBERID) AS MAX_ID
		FROM		MODELNUMBERLIST
	</CFQUERY>
	<CFSET FORM.MODELNUMBERID = #val(GetMaxUniqueID.MAX_ID+1)#>
     <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
	<CFQUERY name="AddModelNumbers" datasource="#application.type#HARDWARE">
		INSERT INTO	MODELNUMBERLIST (MODELNUMBERID, MODELNUMBER, MODIFIEDBYID, MODIFIEDDATE)
		VALUES		(#val(FORM.MODELNUMBERID)#, UPPER('#FORM.MODELNUMBER#'), #val(FORM.MODIFIEDBYID)#, TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
<CFELSE>
	<CFSET FORM.MODELNUMBERID = #GetModelNumbers.MODELNUMBERID#>
</CFIF>