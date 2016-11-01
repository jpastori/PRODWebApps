<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processshardwareinventoryinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Process Information to IDT Hardware Inventory --->
<!-- Last modified by John R. Pastori on 07/08/2015 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Hardware Inventory</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF IsDefined('FORM.PROCESSHARDWAREINVENTORYVERIFY')> 
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyHardwareInventory" datasource="#application.type#HARDWARE">
		UPDATE	HARDWAREINVENTORY
		SET		STATEFOUNDNUMBER = UPPER('#FORM.STATEFOUNDNUMBER#'),
				SERIALNUMBER = UPPER('#FORM.SERIALNUMBER#'),
				DIVISIONNUMBER = UPPER('#FORM.DIVISIONNUMBER#'),
				CLUSTERNAME = UPPER('#FORM.CLUSTERNAME#'),
				EQUIPMENTLOCATIONID = #val(FORM.EQUIPMENTLOCATIONID)#,
				CUSTOMERID = #val(FORM.CUSTOMERID)#,
				COMMENTS = UPPER('#FORM.COMMENTS#'),
				DATECHECKED = TO_DATE('#FORM.DATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#
		WHERE	(HARDWAREID = #val(Cookie.HARDWAREID)#)
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
     
     <CFSET DataHardwareAttachedToArray=ArrayNew(1)>
	<CFSET DataHardwareAttachedToArray[1]=FORM.ATTACHEDTO1>
     <CFSET DataHardwareAttachedToArray[2]=FORM.ATTACHEDTO2>
     <CFSET DataHardwareAttachedToArray[3]=FORM.ATTACHEDTO3>
     <CFSET DataHardwareAttachedToArray[4]=FORM.ATTACHEDTO4>
     
     <CFSET KeyHardwareAttachedToArray=ArrayNew(1)>
	<CFSET KeyHardwareAttachedToArray[1] = FORM.StoreHardwareAttachedToKey1>
	<CFSET KeyHardwareAttachedToArray[2] = FORM.StoreHardwareAttachedToKey2>
	<CFSET KeyHardwareAttachedToArray[3] = FORM.StoreHardwareAttachedToKey3>
	<CFSET KeyHardwareAttachedToArray[4] = FORM.StoreHardwareAttachedToKey4>
	
	<CFLOOP index="Counter" from=1 to=4>
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
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventoryassignverif.cfm?PROCESS=MODIFYDELETE" />
     <CFEXIT>
</CFIF>
	

<CFIF FORM.PROCESSHARDWAREINVENTORY NEQ "CANCELADD" AND FORM.PROCESSHARDWAREINVENTORY NEQ "DELETEMULTIPLE">
	<CFIF IsDefined('FORM.WARRANTYEXPIRATIONDATE') AND FORM.WARRANTYEXPIRATIONDATE IS NOT "">
		<CFSET FORM.WARRANTYEXPIRATIONDATE = DateFormat(FORM.WARRANTYEXPIRATIONDATE, 'DD-MMM-YYYY')>
	</CFIF>
	<CFIF IsDefined('FORM.DATERECEIVED') AND FORM.DATERECEIVED IS NOT "">
		<CFSET FORM.DATERECEIVED = DateFormat(FORM.DATERECEIVED, 'DD-MMM-YYYY')>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY NEQ "CANCELADD" AND FORM.PROCESSHARDWAREINVENTORY NEQ "MODIFYMULTIPLE" AND FORM.PROCESSHARDWAREINVENTORY NEQ "DELETEMULTIPLE">
	<CFSET DataSizeNameArray=ArrayNew(1)> 
	<CFSET DataSizeNameArray[1] = FORM.SIZENAMEID1>
	<CFSET DataSizeNameArray[2] = FORM.SIZENAMEID2>
	<CFSET DataSizeNameArray[3] = FORM.SIZENAMEID3>
	<CFSET DataSizeNameArray[4] = FORM.SIZENAMEID4>
	<CFSET DataSizeNameArray[5] = FORM.SIZENAMEID5>
	<CFSET DataSizeNameArray[6] = FORM.SIZENAMEID6>

	<CFSET DataInstalledInterfacesArray=ArrayNew(1)>
	<CFSET DataInstalledInterfacesArray[1]=FORM.INTERFACENAMEID1>
	<CFSET DataInstalledInterfacesArray[2]=FORM.INTERFACENAMEID2>
	<CFSET DataInstalledInterfacesArray[3]=FORM.INTERFACENAMEID3>
	<CFSET DataInstalledInterfacesArray[4]=FORM.INTERFACENAMEID4>
	<CFSET DataInstalledInterfacesArray[5]=FORM.INTERFACENAMEID5>
	<CFSET DataInstalledInterfacesArray[6]=FORM.INTERFACENAMEID6>

	<CFSET DataInstalledPeripheralsArray=ArrayNew(1)>
	<CFSET DataInstalledPeripheralsArray[1]=FORM.PERIPHERALNAMEID1>
	<CFSET DataInstalledPeripheralsArray[2]=FORM.PERIPHERALNAMEID2>
	<CFSET DataInstalledPeripheralsArray[3]=FORM.PERIPHERALNAMEID3>
	<CFSET DataInstalledPeripheralsArray[4]=FORM.PERIPHERALNAMEID4>
	<CFSET DataInstalledPeripheralsArray[5]=FORM.PERIPHERALNAMEID5>
	<CFSET DataInstalledPeripheralsArray[6]=FORM.PERIPHERALNAMEID6>

	<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "ADDMULTIPLE">
		<CFSET DataHardwareAttachedToArray=ArrayNew(1)>
		<CFSET DataHardwareAttachedToArray[1]=FORM.ATTACHEDTO1>
		<CFSET DataHardwareAttachedToArray[2]=FORM.ATTACHEDTO2>
	</CFIF>

	<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "MODIFY" OR FORM.PROCESSHARDWAREINVENTORY EQ "MODIFYLOOP">
		<CFSET DataHardwareAttachedToArray=ArrayNew(1)>
		<CFSET DataHardwareAttachedToArray[1]=FORM.ATTACHEDTO1>
		<CFSET DataHardwareAttachedToArray[2]=FORM.ATTACHEDTO2>
		<CFSET DataHardwareAttachedToArray[3]=FORM.ATTACHEDTO3>
		<CFSET DataHardwareAttachedToArray[4]=FORM.ATTACHEDTO4>
		<CFSET DataHardwareAttachedToArray[5]=FORM.ATTACHEDTO5>
		<CFSET DataHardwareAttachedToArray[6]=FORM.ATTACHEDTO6>
	</CFIF>

</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "ADD" OR FORM.PROCESSHARDWAREINVENTORY EQ "ADDMULTIPLE">
	<CFIF #FORM.TYPENAME# NEQ "">
		<CFINCLUDE template="processaddtypename.cfm">
	</CFIF>

	<CFIF #FORM.DESCRIPTIONNAME# NEQ "">
		<CFINCLUDE template="processadddescription.cfm">
	</CFIF>

	<CFIF #FORM.MODELNAME# NEQ "">
		<CFINCLUDE template="processaddmodelname.cfm">
	</CFIF>

	<CFIF #FORM.MODELNUMBER# NEQ "">
		<CFINCLUDE template="processaddmodelnumber.cfm">
	</CFIF>

	<CFIF #FORM.SPEEDNAME# NEQ "">
		<CFINCLUDE template="processaddspeedname.cfm">
	</CFIF>

	<CFIF #FORM.SIZENAME1# NEQ "">
		<CFINCLUDE template="processaddsizename.cfm">
	</CFIF>

	<CFIF #FORM.INTERFACENAME1# NEQ "">
		<CFINCLUDE template="processaddinterfacename.cfm">
	</CFIF>

	<CFIF #FORM.PERIPHERALNAME1# NEQ "">
		<CFINCLUDE template="processaddperipheralname.cfm">
	</CFIF>

</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "ADD" OR FORM.PROCESSHARDWAREINVENTORY EQ "ADDMULTIPLE" OR FORM.PROCESSHARDWAREINVENTORY EQ "MODIFY" OR FORM.PROCESSHARDWAREINVENTORY EQ "MODIFYLOOP">
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyHardwareInventory" datasource="#application.type#HARDWARE">
		UPDATE	HARDWAREINVENTORY
		SET		BARCODENUMBER = '#FORM.BARCODENUMBER#',
				STATEFOUNDNUMBER = UPPER('#FORM.STATEFOUNDNUMBER#'),
				SERIALNUMBER = UPPER('#FORM.SERIALNUMBER#'),
				DIVISIONNUMBER = UPPER('#FORM.DIVISIONNUMBER#'),

			<CFIF IsDefined('FORM.CLUSTERNAME') AND #FORM.CLUSTERNAME# NEQ "">
				CLUSTERNAME = UPPER('#FORM.CLUSTERNAME#'),
			</CFIF>
			<CFIF IsDefined('FORM.MACHINENAME') AND #FORM.MACHINENAME# NEQ "">
				MACHINENAME = UPPER('#FORM.MACHINENAME#'),
			</CFIF>

				EQUIPMENTLOCATIONID = #val(FORM.EQUIPMENTLOCATIONID)#,
				MACADDRESS = LOWER('#FORM.MACADDRESS#'),
                    AIRPORTID = UPPER('#FORM.AIRPORTID#'),
				IPADDRESS = UPPER('#FORM.IPADDRESS#'),
                    BLUETOOTHID = UPPER('#FORM.BLUETOOTHID#'),
				EQUIPMENTTYPEID = #val(FORM.EQUIPMENTTYPEID)#,
				DESCRIPTIONID = #val(FORM.DESCRIPTIONID)#,
				MODELNAMEID = #val(FORM.MODELNAMEID)#,
				MODELNUMBERID = #val(FORM.MODELNUMBERID)#,
				SPEEDNAMEID = #val(FORM.SPEEDNAMEID)#,
				MANUFACTURERID = #val(FORM.MANUFACTURERID)#,
				DELLEXPRESSSERVICE = UPPER('#FORM.DELLEXPRESSSERVICE#'),
				WARRANTYVENDORID = #val(FORM.WARRANTYVENDORID)#,
				REQUISITIONNUMBER = UPPER('#FORM.REQUISITIONNUMBER#'),
				PURCHASEORDERNUMBER = UPPER('#FORM.PURCHASEORDERNUMBER#'),
			<CFIF IsDefined('FORM.DATERECEIVED') AND #FORM.DATERECEIVED# NEQ "">
				DATERECEIVED = TO_DATE('#FORM.DATERECEIVED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
				FISCALYEARID = #val(FORM.FISCALYEARID)#,
				CUSTOMERID = #val(FORM.CUSTOMERID)#,
				COMMENTS = UPPER('#FORM.COMMENTS#'),
				OWNINGORGID = #val(FORM.OWNINGORGID)#,			
			<CFIF IsDefined('FORM.DATECHECKED') AND #FORM.DATECHECKED# NEQ "">
				DATECHECKED = TO_DATE('#FORM.DATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#
		WHERE	(HARDWAREID = #val(Cookie.HARDWAREID)#)
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "MODIFYMULTIPLE">
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyHardwareInventory" datasource="#application.type#HARDWARE">
		UPDATE	HARDWAREINVENTORY
		SET		
			<CFIF IsDefined("FORM.DIVISIONNUMBERCHANGED")>
				DIVISIONNUMBER = UPPER('#FORM.DIVISIONNUMBER#'),
			</CFIF>
			<CFIF IsDefined("FORM.CLUSTERNAMECHANGED")>
				CLUSTERNAME = UPPER('#FORM.CLUSTERNAME#'),
			</CFIF>
			<CFIF IsDefined("FORM.ROOMNUMBERCHANGED")>
				EQUIPMENTLOCATIONID = #val(FORM.EQUIPMENTLOCATIONID)#,
			</CFIF>
			<CFIF IsDefined("FORM.IPADDRESSCHANGED")>
				IPADDRESS = UPPER('#FORM.IPADDRESS#'),
			</CFIF>
			<CFIF IsDefined("FORM.EQUIPMENTTYPECHANGED")>
				EQUIPMENTTYPEID = #val(FORM.EQUIPMENTTYPEID)#,
			</CFIF>
			<CFIF IsDefined("FORM.EQUIPMENTDESCRIPTIONCHANGED")>
				DESCRIPTIONID = #val(FORM.DESCRIPTIONID)#,
			</CFIF>
			<CFIF IsDefined("FORM.MODELNAMECHANGED")>
				MODELNAMEID = #val(FORM.MODELNAMEID)#,
			</CFIF>
			<CFIF IsDefined("FORM.MODELNUMBERCHANGED")>
				MODELNUMBERID = #val(FORM.MODELNUMBERID)#,
			</CFIF>
			<CFIF IsDefined("FORM.SPEEDNAMECHANGED")>
				SPEEDNAMEID = #val(FORM.SPEEDNAMEID)#,
			</CFIF>
			<CFIF IsDefined("FORM.MANUFACTURERCHANGED")>
				MANUFACTURERID = #val(FORM.MANUFACTURERID)#,
			</CFIF>
			<CFIF IsDefined("FORM.WARRANTYVENDORCHANGED")>
				WARRANTYVENDORID = #val(FORM.WARRANTYVENDORID)#,
			</CFIF>
			<CFIF IsDefined("FORM.REQUISITIONNUMBERCHANGED")>
				REQUISITIONNUMBER = UPPER('#FORM.REQUISITIONNUMBER#'),
			</CFIF>
			<CFIF IsDefined("FORM.PURCHASEORDERNUMBERCHANGED")>
				PURCHASEORDERNUMBER = UPPER('#FORM.PURCHASEORDERNUMBER#'),
			</CFIF>
			<CFIF IsDefined("FORM.CUSTOMERCHANGED")>
				CUSTOMERID = #val(FORM.CUSTOMERID)#,
			</CFIF>
			<CFIF IsDefined("FORM.COMMENTSCHANGED")>
				COMMENTS = UPPER('#FORM.COMMENTS#'),
			</CFIF>
               <CFIF IsDefined("FORM.FISCALYEARIDCHANGED")>
				FISCALYEARID = #val(FORM.FISCALYEARID)#,
			</CFIF>
			<CFIF IsDefined("FORM.OWNINGORGIDCHANGED")>
				OWNINGORGID = #val(FORM.OWNINGORGID)#,
			</CFIF>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				DATECHECKED = TO_DATE('#FORM.DATECHECKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	HARDWAREID IN (#URL.HARDWAREIDS#)
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>


<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "ADD">
	<CFINCLUDE template="processaddinventorydetail.cfm">
	<H1>Data ADDED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/lookuproommanufcustinfo.cfm?PROCESS=ADD" />
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "ADDMULTIPLE">
	<CFINCLUDE template="processaddinventorydetail.cfm">
	<H1>Data ADDED!</H1>
	<CFINCLUDE template="updatestructuredata.cfm">
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultipleadd.cfm?PROCESS=REQUESTBARCODE" />
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "MODIFY">
	<CFINCLUDE template="processmodinventorydetail.cfm">
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm?PROCESS=MODIFYDELETE" />
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "MODIFYLOOP">
	<CFINCLUDE template="processmodinventorydetail.cfm">
	<H1>Data MODIFIED!</H1><BR />
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.HardwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultiplemodloop.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultiplemodloop.cfm?PROCESS=MODIFYLOOP&LOOKUPBARCODE=FOUND" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "NEXTRECORD">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.HardwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultiplemodloop.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultiplemodloop.cfm?PROCESS=MODIFYLOOP&LOOKUPBARCODE=FOUND" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "MODIFYMULTIPLE">
	<CFIF IsDefined('FORM.WARRANTYRESTRICTIONSCHANGED') OR IsDefined('FORM.WARRANTYEXPIRATIONDATECHANGED') OR IsDefined('FORM.WARRANTYCOMMENTSCHANGED')>
		<CFINCLUDE template="processmodmultwarrantyinfo.cfm">
	</CFIF>
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" />
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "DELETE">
	<CFQUERY name="DeleteHardWareSizes" datasource="#application.type#HARDWARE">
		DELETE FROM	HARDWARESIZES 
		WHERE 		BARCODENUMBER = '#FORM.BARCODENUMBER#'
	</CFQUERY>
	
	<CFQUERY name="DeleteInstalledInterfaces" datasource="#application.type#HARDWARE">
		DELETE FROM	PCINSTALLEDINTERFACES
		WHERE 		BARCODENUMBER = '#FORM.BARCODENUMBER#'
	</CFQUERY>

	<CFQUERY name="DeleteInstalledPeripherals" datasource="#application.type#HARDWARE">
		DELETE FROM	PCINSTALLEDPERIPHERALS
		WHERE 		BARCODENUMBER = '#FORM.BARCODENUMBER#'
	</CFQUERY>
	
	<CFQUERY name="DeleteHardwareAttachedTo" datasource="#application.type#HARDWARE">
		DELETE FROM	HARDWAREATTACHEDTO
		WHERE 		BARCODENUMBER = '#FORM.BARCODENUMBER#'
	</CFQUERY>

	<CFQUERY name="DeleteHardwareWarranty" datasource="#application.type#HARDWARE">
		DELETE FROM	HARDWAREWARRANTY
		WHERE 		BARCODENUMBER = '#FORM.BARCODENUMBER#'
	</CFQUERY> 
</CFIF>

<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "DELETEMULTIPLE">
	<CFQUERY name="LookupHardwareBarCode" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREID, BARCODENUMBER
		FROM		HARDWAREINVENTORY
		WHERE	HARDWAREID IN (#URL.HARDWAREIDS#)
		ORDER BY	BARCODENUMBER
	</CFQUERY>
	<CFLOOP query="LookupHardwareBarCode">
		<CFQUERY name="DeleteHardWareSizes" datasource="#application.type#HARDWARE">
			DELETE FROM	HARDWARESIZES 
			WHERE 		BARCODENUMBER = '#LookupHardwareBarCode.BARCODENUMBER#'
		</CFQUERY>

		<CFQUERY name="DeleteInstalledInterfaces" datasource="#application.type#HARDWARE">
			DELETE FROM	PCINSTALLEDINTERFACES
			WHERE 		BARCODENUMBER = '#LookupHardwareBarCode.BARCODENUMBER#'
		</CFQUERY>

		<CFQUERY name="DeleteInstalledPeripherals" datasource="#application.type#HARDWARE">
			DELETE FROM	PCINSTALLEDPERIPHERALS
			WHERE 		BARCODENUMBER = '#LookupHardwareBarCode.BARCODENUMBER#'
		</CFQUERY>

		<CFQUERY name="DeleteHardwareAttachedTo" datasource="#application.type#HARDWARE">
			DELETE FROM	HARDWAREATTACHEDTO
			WHERE 		BARCODENUMBER = '#LookupHardwareBarCode.BARCODENUMBER#'
		</CFQUERY>

		<CFQUERY name="DeleteHardwareWarranty" datasource="#application.type#HARDWARE">
			DELETE FROM	HARDWAREWARRANTY
			WHERE 		BARCODENUMBER = '#LookupHardwareBarCode.BARCODENUMBER#'
		</CFQUERY>
	</CFLOOP>
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSHARDWAREINVENTORY#, 1) NEQ 0 OR FORM.PROCESSHARDWAREINVENTORY EQ "CANCELADD">
	<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "DELETE" OR FORM.PROCESSHARDWAREINVENTORY EQ "CANCELADD">
		<CFQUERY name="DeleteHardwareInventory" datasource="#application.type#HARDWARE">
			DELETE FROM	HARDWAREINVENTORY
			WHERE 		HARDWAREID = #val(Cookie.HARDWAREID)#
		</CFQUERY>
	</CFIF>
	<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "DELETEMULTIPLE">
		<CFQUERY name="DeleteHardwareInventory" datasource="#application.type#HARDWARE">
			DELETE FROM	HARDWAREINVENTORY
			WHERE 		HARDWAREID IN (#URL.HARDWAREIDS#)
		</CFQUERY>
	</CFIF>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSHARDWAREINVENTORY EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/hardwareinventoryinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSEIF FORM.PROCESSHARDWAREINVENTORY EQ "DELETEMULTIPLE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/inventorymultiplemoddel.cfm" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>