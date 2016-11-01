<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmodinventorydetail.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2008 --->
<!--- Date in Production: 06/23/2008 --->
<!--- Module: Process Information to IDT Hardware Inventory --->
<!-- Last modified by John R. Pastori on 06/23/2008 using ColdFusion Studio. -->

	<CFINCLUDE template = "../programsecuritycheck.cfm">

	<CFSET KeySizeNameArray=ArrayNew(1)> 
	<CFSET KeySizeNameArray[1] = FORM.StoreSizeNameKey1>
	<CFSET KeySizeNameArray[2] = FORM.StoreSizeNameKey2>
	<CFSET KeySizeNameArray[3] = FORM.StoreSizeNameKey3>
	<CFSET KeySizeNameArray[4] = FORM.StoreSizeNameKey4>
	<CFSET KeySizeNameArray[5] = FORM.StoreSizeNameKey5>
	<CFSET KeySizeNameArray[6] = FORM.StoreSizeNameKey6>
	<CFLOOP index="Counter" from=1 to=6>
		<CFIF DataSizeNameArray[Counter] GT 0>
			<CFIF KeySizeNameArray[Counter] GT 0>
				<CFTRANSACTION action="begin">
				<CFQUERY name="ModifyHardWareSizes" datasource="#application.type#HARDWARE">
					UPDATE	HARDWARESIZES 
					SET		HARDWARESIZES.BARCODENUMBER = '#FORM.BARCODENUMBER#',
							HARDWARESIZES.HARDWARESIZENAMEID = #val(DataSizeNameArray[Counter])#
					WHERE	(HARDWARESIZES.HARDWARESIZESID = #val(KeySizeNameArray[Counter])#)
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>
			<CFELSE>
				<CFTRANSACTION action="begin">
				<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
					SELECT	MAX(HARDWARESIZESID) AS MAX_ID
					FROM		HARDWARESIZES
				</CFQUERY>
				<CFSET FORM.HARDWARESIZESID =  #val(GetMaxUniqueID.MAX_ID+1)#>
				
				<CFQUERY name="AddHardWareSizes" datasource="#application.type#HARDWARE">
					INSERT INTO	HARDWARESIZES (HARDWARESIZESID, BARCODENUMBER, HARDWARESIZENAMEID)
					VALUES		(#val(FORM.HARDWARESIZESID)#, '#FORM.BARCODENUMBER#', #val(DataSizeNameArray[Counter])#)
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>
			</CFIF>
		<CFELSEIF DataSizeNameArray[Counter] EQ 0 AND KeySizeNameArray[Counter] GT 0>
			<CFQUERY name="DeleteHardWareSizes" datasource="#application.type#HARDWARE">
				DELETE FROM	HARDWARESIZES
				WHERE 		(HARDWARESIZES.HARDWARESIZESID = #val(KeySizeNameArray[Counter])#)
			</CFQUERY>
		</CFIF>
	</CFLOOP>

	<CFSET KeyInstalledInterfacesArray=ArrayNew(1)>
	<CFSET KeyInstalledInterfacesArray[1] = FORM.StoreInstalledInterfacesKey1>
	<CFSET KeyInstalledInterfacesArray[2] = FORM.StoreInstalledInterfacesKey2>
	<CFSET KeyInstalledInterfacesArray[3] = FORM.StoreInstalledInterfacesKey3>
	<CFSET KeyInstalledInterfacesArray[4] = FORM.StoreInstalledInterfacesKey4>
	<CFSET KeyInstalledInterfacesArray[5] = FORM.StoreInstalledInterfacesKey5>
	<CFSET KeyInstalledInterfacesArray[6] = FORM.StoreInstalledInterfacesKey6>
	<CFLOOP index="Counter" from=1 to=6>
		<CFIF DataInstalledInterfacesArray[Counter] GT 0>
			<CFIF KeyInstalledInterfacesArray[Counter] GT 0>
				<CFTRANSACTION action="begin">
				<CFQUERY name="ModifyInstalledInterfaces" datasource="#application.type#HARDWARE">
					UPDATE	PCINSTALLEDINTERFACES
					SET		PCINSTALLEDINTERFACES.BARCODENUMBER = '#FORM.BARCODENUMBER#',
							PCINSTALLEDINTERFACES.INTERFACENAMEID = #val(DataInstalledInterfacesArray[Counter])#
					WHERE	(PCINSTALLEDINTERFACES.INTERFACEID = #val(KeyInstalledInterfacesArray[Counter])#)
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>
			<CFELSE>
				<CFTRANSACTION action="begin">
				<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
					SELECT	MAX(INTERFACEID) AS MAX_ID
					FROM		PCINSTALLEDINTERFACES
				</CFQUERY>
				<CFSET FORM.INTERFACEID =  #val(GetMaxUniqueID.MAX_ID+1)#>
				
				<CFQUERY name="AddInstalledInterfaces" datasource="#application.type#HARDWARE">
					INSERT INTO	PCINSTALLEDINTERFACES (INTERFACEID, BARCODENUMBER, INTERFACENAMEID)
					VALUES		(#val(FORM.INTERFACEID)#, '#FORM.BARCODENUMBER#', #val(DataInstalledInterfacesArray[Counter])#)
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>
			</CFIF>
		<CFELSEIF DataInstalledInterfacesArray[Counter] EQ 0 AND KeyInstalledInterfacesArray[Counter] GT 0>
			<CFQUERY name="DeleteInstalledInterfaces" datasource="#application.type#HARDWARE">
				DELETE FROM	PCINSTALLEDINTERFACES
				WHERE 		(PCINSTALLEDINTERFACES.INTERFACEID = #val(KeyInstalledInterfacesArray[Counter])#)
			</CFQUERY>
		</CFIF>
	</CFLOOP>

	<CFSET KeyInstalledPeripheralsArray=ArrayNew(1)>
	<CFSET KeyInstalledPeripheralsArray[1] = FORM.StoreInstalledPeripheralsKey1>
	<CFSET KeyInstalledPeripheralsArray[2] = FORM.StoreInstalledPeripheralsKey2>
	<CFSET KeyInstalledPeripheralsArray[3] = FORM.StoreInstalledPeripheralsKey3>
	<CFSET KeyInstalledPeripheralsArray[4] = FORM.StoreInstalledPeripheralsKey4>
	<CFSET KeyInstalledPeripheralsArray[5] = FORM.StoreInstalledPeripheralsKey5>
	<CFSET KeyInstalledPeripheralsArray[6] = FORM.StoreInstalledPeripheralsKey6>
	<CFLOOP index="Counter" from=1 to=6>
		<CFIF DataInstalledPeripheralsArray[Counter] GT 0>
			<CFIF KeyInstalledPeripheralsArray[Counter] GT 0>
				<CFTRANSACTION action="begin">
				<CFQUERY name="ModifyInstalledPeripherals" datasource="#application.type#HARDWARE">
					UPDATE	PCINSTALLEDPERIPHERALS
					SET		PCINSTALLEDPERIPHERALS.BARCODENUMBER = '#FORM.BARCODENUMBER#',
							PCINSTALLEDPERIPHERALS.PERIPHERALNAMEID = #val(DataInstalledPeripheralsArray[Counter])#
					WHERE	(PCINSTALLEDPERIPHERALS.PERIPHERALID = #val(KeyInstalledPeripheralsArray[Counter])#)
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>
			<CFELSE>
				<CFTRANSACTION action="begin">
				<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
					SELECT	MAX(PERIPHERALID) AS MAX_ID
					FROM		PCINSTALLEDPERIPHERALS
				</CFQUERY>
				<CFSET FORM.PERIPHERALID =  #val(GetMaxUniqueID.MAX_ID+1)#>
				
				<CFQUERY name="AddInstalledPeripherals" datasource="#application.type#HARDWARE">
					INSERT INTO	PCINSTALLEDPERIPHERALS (PERIPHERALID, BARCODENUMBER, PERIPHERALNAMEID)
					VALUES		(#val(FORM.PERIPHERALID)#, '#FORM.BARCODENUMBER#', #val(DataInstalledPeripheralsArray[Counter])#)
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>
			</CFIF>
		<CFELSEIF DataInstalledPeripheralsArray[Counter] EQ 0 AND KeyInstalledPeripheralsArray[Counter] GT 0>
			<CFQUERY name="DeleteInstalledPeripherals" datasource="#application.type#HARDWARE">
				DELETE FROM	PCINSTALLEDPERIPHERALS
				WHERE 		(PCINSTALLEDPERIPHERALS.PERIPHERALID = #val(KeyInstalledPeripheralsArray[Counter])#)
			</CFQUERY>
		</CFIF>
	</CFLOOP>

	<CFSET KeyHardwareAttachedToArray=ArrayNew(1)>
	<CFSET KeyHardwareAttachedToArray[1] = FORM.StoreHardwareAttachedToKey1>
	<CFSET KeyHardwareAttachedToArray[2] = FORM.StoreHardwareAttachedToKey2>
	<CFSET KeyHardwareAttachedToArray[3] = FORM.StoreHardwareAttachedToKey3>
	<CFSET KeyHardwareAttachedToArray[4] = FORM.StoreHardwareAttachedToKey4>
	<CFSET KeyHardwareAttachedToArray[5] = FORM.StoreHardwareAttachedToKey5>
	<CFSET KeyHardwareAttachedToArray[6] = FORM.StoreHardwareAttachedToKey6>
	<CFLOOP index="Counter" from=1 to=6>
		<CFIF DataHardwareAttachedToArray[Counter] GT 0>
			<CFIF KeyHardwareAttachedToArray[Counter] GT 0>
				<CFTRANSACTION action="begin">
				<CFQUERY name="ModifyHardwareAttachedTo" datasource="#application.type#HARDWARE">
					UPDATE	HARDWAREATTACHEDTO
					SET		HARDWAREATTACHEDTO.BARCODENUMBER = '#FORM.BARCODENUMBER#',
							HARDWAREATTACHEDTO.ATTACHEDTO = #val(DataHardwareAttachedToArray[Counter])#
					WHERE	(HARDWAREATTACHEDTO.ATTACHEDTOID = #val(KeyHardwareAttachedToArray[Counter])#)
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>
			<CFELSE>
				<CFTRANSACTION action="begin">
				<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
					SELECT	MAX(ATTACHEDTOID) AS MAX_ID
					FROM		HARDWAREATTACHEDTO
				</CFQUERY>
				<CFSET FORM.ATTACHEDTOID =  #val(GetMaxUniqueID.MAX_ID+1)#>
				
				<CFQUERY name="AddHardwareAttachedTo" datasource="#application.type#HARDWARE">
					INSERT INTO	HARDWAREATTACHEDTO (ATTACHEDTOID, BARCODENUMBER, ATTACHEDTO)
					VALUES		(#val(FORM.ATTACHEDTOID)#, '#FORM.BARCODENUMBER#', #val(DataHardwareAttachedToArray[Counter])#)
				</CFQUERY>
				<CFTRANSACTION action = "commit"/>
				</CFTRANSACTION>
			</CFIF>
		<CFELSEIF DataHardwareAttachedToArray[Counter] EQ 0 AND KeyHardwareAttachedToArray[Counter] GT 0>
			<CFQUERY name="DeleteHardwareAttachedTo" datasource="#application.type#HARDWARE">
				DELETE FROM	HARDWAREATTACHEDTO
				WHERE 		(HARDWAREATTACHEDTO.ATTACHEDTOID = #val(KeyHardwareAttachedToArray[Counter])#)
			</CFQUERY>
		</CFIF>
	</CFLOOP>

	<CFIF FORM.HARDWAREWARRANTYID GT 0>
		<CFTRANSACTION action="begin">
		<CFQUERY name="ModifyHardwareWarranty" datasource="#application.type#HARDWARE">
			UPDATE	HARDWAREWARRANTY
			SET		HARDWAREWARRANTY.BARCODENUMBER = '#FORM.BARCODENUMBER#',
					HARDWAREWARRANTY.WARRANTYRESTRICTIONS = UPPER('#FORM.WARRANTYRESTRICTIONS#'),
				<CFIF FORM.WARRANTYEXPIRATIONDATE IS NOT "">
					HARDWAREWARRANTY.WARRANTYEXPIRATIONDATE = TO_DATE('#FORM.WARRANTYEXPIRATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
					HARDWAREWARRANTY.WARRANTYCOMMENTS = UPPER('#FORM.WARRANTYCOMMENTS#')
			WHERE	(HARDWAREWARRANTY.HARDWAREWARRANTYID = #val(FORM.HARDWAREWARRANTYID)#)
		</CFQUERY>
		<CFTRANSACTION action = "commit"/>
		</CFTRANSACTION>
	<CFELSEIF IsDefined('FORM.WARRANTYRESTRICTIONS') OR IsDefined('FORM.WARRANTYEXPIRATIONDATE') OR IsDefined('FORM.WARRANTYCOMMENTS')>
		<CFTRANSACTION action="begin">
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
		<CFTRANSACTION action = "commit"/>
		</CFTRANSACTION>
	</CFIF>