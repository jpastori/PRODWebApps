<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddsizename.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<CFSET COUNTER1 = 1>
<CFLOOP condition="COUNTER1 LESS THAN OR EQUAL TO 3">
	<CFSET session.SELECTFIELD = "FORM.SIZENAME#COUNTER1#">
	<CFSET SIZENAMEVALUE = "#evaluate(session.SELECTFIELD)#">
	<CFIF #SIZENAMEVALUE# NEQ "">
		<br /><br />SELECTFIELD = #SIZENAMEVALUE#<br /><br />
		<CFQUERY name="GetSizeNames" datasource="#application.type#HARDWARE">
			SELECT	SIZENAMEID, SIZENAME, MODIFIEDBYID, MODIFIEDDATE
			FROM		SIZENAMELIST
			WHERE	SIZENAME = <CFQUERYPARAM value="UPPER(#SIZENAMEVALUE#)" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	SIZENAME
		</CFQUERY>

		<CFIF #GetSizeNames.RecordCount# EQ 0>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
				SELECT	MAX(SIZENAMEID) AS MAX_ID
				FROM		SIZENAMELIST
			</CFQUERY>
			<CFSET FORM.SIZENAMEID = #val(GetMaxUniqueID.MAX_ID+1)#>
     		<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
			<CFQUERY name="AddSizeNames" datasource="#application.type#HARDWARE">
				INSERT INTO	SIZENAMELIST (SIZENAMEID, SIZENAME, MODIFIEDBYID, MODIFIEDDATE)
				VALUES		(#val(FORM.SIZENAMEID)#, UPPER('#SIZENAMEVALUE#'), #val(FORM.MODIFIEDBYID)#, TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
			</CFQUERY>
		<CFELSE>
			<CFSET FORM.SIZENAMEID = #GetSizeNames.SIZENAMEID#>
		</CFIF>

		<CFSET COUNTER2 = 1>
		<CFLOOP condition="COUNTER2 LESS THAN OR EQUAL TO 4">
			<br /><br />1st DataSizeNameArray[#COUNTER2#] = #DataSizeNameArray[COUNTER2]#<br /><br />
			<CFIF #DataSizeNameArray[COUNTER2]# EQ 0>
				<CFSET DataSizeNameArray[#COUNTER2#] = #FORM.SIZENAMEID#>
				<br /><br />2nd DataSizeNameArray[#COUNTER2#] = #DataSizeNameArray[COUNTER2]#<br /><br />
				<CFSET COUNTER2 = 6>
			</CFIF>
			<CFSET COUNTER2 = COUNTER2 + 1>
		</CFLOOP>
	<CFELSE>
		<CFSET COUNTER1 = 5>
	</CFIF>
	<CFSET COUNTER1 = COUNTER1 + 1>
</CFLOOP>
</CFOUTPUT>