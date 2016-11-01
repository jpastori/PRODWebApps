<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddsizename.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<CFSET COUNTER1 = 0>
<CFLOOP condition="COUNTER1 LESS THAN OR EQUAL TO 3">
	<CFSET COUNTER1 = COUNTER1 + 1>
	<CFSET session.SELECTFIELD = "FORM.PERIPHERALNAME#COUNTER1#">
	<CFSET PERIPHERALNAMEVALUE = "#evaluate(session.SELECTFIELD)#">
	<CFIF #PERIPHERALNAMEVALUE# NEQ "">
		<br /><br />SELECTFIELD = #PERIPHERALNAMEVALUE#<br /><br />
		<CFQUERY name="GetPeripheralNames" datasource="#application.type#HARDWARE">
			SELECT	PERIPHERALNAMEID, PERIPHERALNAME, MODIFIEDBYID, MODIFIEDDATE
			FROM		PERIPHERALNAMELIST
			WHERE	PERIPHERALNAME = <CFQUERYPARAM value="UPPER(#PERIPHERALNAMEVALUE#)" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	PERIPHERALNAME
		</CFQUERY>
	
		<CFIF #GetPeripheralNames.RecordCount# EQ 0>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
				SELECT	MAX(PERIPHERALNAMEID) AS MAX_ID
				FROM		PERIPHERALNAMELIST
			</CFQUERY>
			<CFSET FORM.PERIPHERALNAMEID = #val(GetMaxUniqueID.MAX_ID+1)#>
     		<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
			<CFQUERY name="AddPeripheralNames" datasource="#application.type#HARDWARE">
				INSERT INTO	PERIPHERALNAMELIST (PERIPHERALNAMEID, PERIPHERALNAME, MODIFIEDBYID, MODIFIEDDATE)
				VALUES		(#val(FORM.PERIPHERALNAMEID)#, '#PERIPHERALNAMEVALUE#', #val(FORM.MODIFIEDBYID)#, TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
			</CFQUERY>
		<CFELSE>
			<CFSET FORM.PERIPHERALNAMEID = #GetPeripheralNames.PERIPHERALNAMEID#>
		</CFIF>
		<CFSET COUNTER2 = 0>
		<CFLOOP condition="COUNTER2 LESS THAN OR EQUAL TO 6">
			<CFSET COUNTER2 = COUNTER2 + 1>
			<br /><br />1st DataInstalledPeripheralsArray[#COUNTER2#] = #DataInstalledPeripheralsArray[COUNTER2]#<br /><br />
			<CFIF #DataInstalledPeripheralsArray[#COUNTER2#]# EQ 0>
				<CFSET DataInstalledPeripheralsArray[#COUNTER2#] = #FORM.PERIPHERALNAMEID#>
				<br /><br />2nd DataInstalledPeripheralsArray[#COUNTER2#] = #DataInstalledPeripheralsArray[COUNTER2]#<br /><br />
				<CFSET COUNTER2 = 7>
			</CFIF>
		</CFLOOP>
	<CFELSE>
		<CFSET COUNTER1 = 4>
	</CFIF>
</CFLOOP>
</CFOUTPUT>