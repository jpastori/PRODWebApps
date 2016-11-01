<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmodmultwarrantyinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2008 --->
<!--- Date in Production: 06/23/2008 --->
<!--- Module: Process Information to IDT Hardware Inventory --->
<!-- Last modified by John R. Pastori on 06/23/2008 using ColdFusion Studio. -->

	<CFINCLUDE template = "../programsecuritycheck.cfm">

	<CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE">
		SELECT	HARDWAREID, BARCODENUMBER
		FROM		HARDWAREINVENTORY
		WHERE	HARDWAREINVENTORY.HARDWAREID IN (#URL.HARDWAREIDS#)
		ORDER BY	HARDWAREID
	</CFQUERY>

	<CFLOOP query = LookupHardware>
		<CFIF IsDefined('FORM.WARRANTYRESTRICTIONSCHANGED')>
			<CFQUERY name="ModifyHardwareWarranty" datasource="#application.type#HARDWARE">
				UPDATE	HARDWAREWARRANTY
				SET		HARDWAREWARRANTY.WARRANTYRESTRICTIONS = UPPER('#FORM.WARRANTYRESTRICTIONS#')
				WHERE	(HARDWAREWARRANTY.BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">)
			</CFQUERY>
		</CFIF>

		<CFIF IsDefined('FORM.WARRANTYEXPIRATIONDATECHANGED')>
			<CFQUERY name="ModifyHardwareWarranty" datasource="#application.type#HARDWARE">
				UPDATE	HARDWAREWARRANTY
				SET		HARDWAREWARRANTY.WARRANTYEXPIRATIONDATE = TO_DATE('#FORM.WARRANTYEXPIRATIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
				WHERE	(HARDWAREWARRANTY.BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">)
			</CFQUERY>
		</CFIF>

		<CFIF IsDefined('FORM.WARRANTYCOMMENTSCHANGED')>
			<CFQUERY name="ModifyHardwareWarranty" datasource="#application.type#HARDWARE">
				UPDATE	HARDWAREWARRANTY
				SET		HARDWAREWARRANTY.WARRANTYCOMMENTS = UPPER('#FORM.WARRANTYCOMMENTS#')
				WHERE	(HARDWAREWARRANTY.BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">)
			</CFQUERY>
		</CFIF>
	</CFLOOP>