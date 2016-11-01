<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processaddinventorydetail.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2008 --->
<!--- Date in Production: 06/23/2008 --->
<!--- Module: Process Information to IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 06/23/2008 using ColdFusion Studio. -->

	<CFINCLUDE template = "../programsecuritycheck.cfm">

	<CFLOOP index="Counter" from=1 to=6>
		<CFIF DataSizeNameArray[Counter] GT 0>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
				SELECT	MAX(HARDWARESIZESID) AS MAX_ID
				FROM		HARDWARESIZES
			</CFQUERY>
			<CFSET FORM.HARDWARESIZESID =  #val(GetMaxUniqueID.MAX_ID+1)#>
			<CFQUERY name="AddHardWareSizes" datasource="#application.type#HARDWARE">
				INSERT INTO	HARDWARESIZES (HARDWARESIZESID, BARCODENUMBER, HARDWARESIZENAMEID)
				VALUES		(#val(FORM.HARDWARESIZESID)#, '#FORM.BARCODENUMBER#', #val(DataSizeNameArray[Counter])#)
			</CFQUERY>
		</CFIF>
	</CFLOOP>

	<CFLOOP index="Counter" from=1 to=6>
		<CFIF DataInstalledInterfacesArray[Counter] GT 0>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
				SELECT	MAX(INTERFACEID) AS MAX_ID
				FROM		PCINSTALLEDINTERFACES
			</CFQUERY>
			<CFSET FORM.INTERFACEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
			<CFQUERY name="AddInstalledInterfaces" datasource="#application.type#HARDWARE">
				INSERT INTO	PCINSTALLEDINTERFACES (INTERFACEID, BARCODENUMBER, INTERFACENAMEID)
				VALUES		(#val(FORM.INTERFACEID)#, '#FORM.BARCODENUMBER#', #val(DataInstalledInterfacesArray[Counter])#)
			</CFQUERY>
		</CFIF>
	</CFLOOP>

	<CFLOOP index="Counter" from=1 to=6>
		<CFIF DataInstalledPeripheralsArray[Counter] GT 0>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
				SELECT	MAX(PERIPHERALID) AS MAX_ID
				FROM		PCINSTALLEDPERIPHERALS
			</CFQUERY>
			<CFSET FORM.PERIPHERALID =  #val(GetMaxUniqueID.MAX_ID+1)#>
			<CFQUERY name="AddInstalledPeripherals" datasource="#application.type#HARDWARE">
				INSERT INTO	PCINSTALLEDPERIPHERALS (PERIPHERALID, BARCODENUMBER, PERIPHERALNAMEID)
				VALUES		(#val(FORM.PERIPHERALID)#, '#FORM.BARCODENUMBER#', #val(DataInstalledPeripheralsArray[Counter])#)
			</CFQUERY>
		</CFIF>
	</CFLOOP>

	<CFIF IsDefined('FORM.WARRANTYRESTRICTIONS') OR IsDefined('FORM.WARRANTYEXPIRATIONDATE') OR IsDefined('FORM.WARRANTYCOMMENTS')>
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
			SELECT	MAX(HARDWAREWARRANTYID) AS MAX_ID
			FROM		HARDWAREWARRANTY
		</CFQUERY>
		<CFSET FORM.HARDWAREWARRANTYID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFQUERY name="AddHardWareWarranty" datasource="#application.type#HARDWARE">
			INSERT INTO	HARDWAREWARRANTY (HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, 
					<CFIF FORM.WARRANTYEXPIRATIONDATE IS NOT "">
						WARRANTYEXPIRATIONDATE,
					</CFIF>
						WARRANTYCOMMENTS)
			VALUES		(#val(FORM.HARDWAREWARRANTYID)#, '#FORM.BARCODENUMBER#', UPPER('#FORM.WARRANTYRESTRICTIONS#'),
					<CFIF FORM.WARRANTYEXPIRATIONDATE IS NOT "">
						TO_DATE('#FORM.WARRANTYEXPIRATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
					</CFIF>
						UPPER('#FORM.WARRANTYCOMMENTS#'))
		</CFQUERY>
	</CFIF>
	
	<CFIF #PROCESSHARDWAREINVENTORY# EQ "ADDMULTIPLE">
		<CFLOOP index="Counter" from=1 to=2>
			<CFIF DataHardwareAttachedToArray[Counter] GT 0>
				<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
					SELECT	MAX(ATTACHEDTOID) AS MAX_ID
					FROM		HARDWAREATTACHEDTO
				</CFQUERY>
				<CFSET FORM.ATTACHEDTOID =  #val(GetMaxUniqueID.MAX_ID+1)#>
				<CFQUERY name="AddHardwareAttachedTo" datasource="#application.type#HARDWARE">
					INSERT INTO	HARDWAREATTACHEDTO (ATTACHEDTOID, BARCODENUMBER, ATTACHEDTO)
					VALUES		(#val(FORM.ATTACHEDTOID)#, '#FORM.BARCODENUMBER#', #val(DataHardwareAttachedToArray[Counter])#)
				</CFQUERY>
			</CFIF>
		</CFLOOP>
	</CFIF>