<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddinterfacename.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/30/2011 --->
<!--- Date in Production: 06/30/2011 --->
<!--- Module: Process Information to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 06/30/2011 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<CFSET COUNTER1 = 1>
<CFLOOP condition="COUNTER1 LESS THAN OR EQUAL TO 3">
	<CFSET session.SELECTFIELD = "FORM.INTERFACENAME#COUNTER1#">
	<CFSET INTERFACENAMEVALUE = "#evaluate(session.SELECTFIELD)#">
	<CFIF #INTERFACENAMEVALUE# NEQ "">
		<br /><br />SELECTFIELD = #INTERFACENAMEVALUE#<br /><br />
		<CFQUERY name="GetInterfaces" datasource="#application.type#HARDWARE">
			SELECT	INTERFACENAMEID, INTERFACENAME, MODIFIEDBYID, MODIFIEDDATE
			FROM		INTERFACENAMELIST
			WHERE	INTERFACENAME = <CFQUERYPARAM value="UPPER(#INTERFACENAMEVALUE#)" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY	INTERFACENAME
		</CFQUERY>

		<CFIF #GetInterfaces.RecordCount# EQ 0>
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
			SELECT	MAX(INTERFACENAMEID) AS MAX_ID
			FROM		INTERFACENAMELIST
		</CFQUERY>
		<CFSET FORM.INTERFACENAMEID = #val(GetMaxUniqueID.MAX_ID+1)#>
    		<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
		<CFQUERY name="AddInterfacenames" datasource="#application.type#HARDWARE">
			INSERT INTO	INTERFACENAMELIST (INTERFACENAMEID, INTERFACENAME, MODIFIEDBYID, MODIFIEDDATE)
			VALUES		(#val(FORM.INTERFACENAMEID)#, UPPER('#INTERFACENAMEVALUE#'), #val(FORM.MODIFIEDBYID)#, TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
		</CFQUERY>
		<CFELSE>
			<CFSET FORM.INTERFACENAMEID = #GetInterfaces.INTERFACENAMEID#>
		</CFIF>

		<CFSET COUNTER2 = 1>
		<CFLOOP condition="COUNTER2 LESS THAN OR EQUAL TO 6">
			<br /><br />1st DataInstalledInterfacesArray[#COUNTER2#] = #DataInstalledInterfacesArray[COUNTER2]#<br /><br />
			<CFIF #DataInstalledInterfacesArray[#COUNTER2#]# EQ 0>
				<CFSET DataInstalledInterfacesArray[#COUNTER2#] = #FORM.INTERFACENAMEID#>
				<br /><br />2nd DataInstalledInterfacesArray[#COUNTER2#] = #DataInstalledInterfacesArray[COUNTER2]#<br /><br />
				<CFSET COUNTER2 = 8>
			</CFIF>
			<CFSET COUNTER2 = COUNTER2 + 1>
		</CFLOOP>
	<CFELSE>
		<CFSET COUNTER1 = 5>
	</CFIF>
	<CFSET COUNTER1 = COUNTER1 + 1>
</CFLOOP>
</CFOUTPUT>