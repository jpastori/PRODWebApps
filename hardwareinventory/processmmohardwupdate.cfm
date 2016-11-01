<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmmohardwupdate.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/13/2012 --->
<!--- Date in Production: 01/13/2012 --->
<!--- Module: Update Hardware Inventory Record Fields with MMO Hardware Data --->
<!-- Last modified by John R. Pastori on 09/25/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/processmmohardwupdate.cfm">
<CFSET CONTENT_UPDATED = "September 25, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HEAD>
	<META http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<TITLE>Update Hardware Inventory Record Fields with MMO Hardware Data</TITLE>
     <LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFSET COUNTER = 0>
<CFSET SESSION.NAMEPOSITION = 1>
<CFSET SESSION.MatchCount = #ListLen(FORM.FIELDNAMES)# - 1>

<CFLOOP index="COUNTER" from=1 to=#SESSION.MatchCount#> 
	
     <CFSET SESSION.NAMEPOSITION = SESSION.NAMEPOSITION + 1>
     <CFSET SESSION.FORMFIELD = listGetAt(FORM.FIELDNAMES, #SESSION.NAMEPOSITION#)>
	<CFSET SESSION.STATEFOUNDNUMBER = #trim(listGetAt(EVALUATE(SESSION.FORMFIELD), 1))#>
     <CFSET SESSION.FIELDUPDATECOUNT = #ListLen(EVALUATE(SESSION.FORMFIELD))#>
	<CFLOOP index="FIELDCOUNTER" from=2 to=#SESSION.FIELDUPDATECOUNT#> 
     	<CFSET SESSION.FIELDNUMBER = trim(listGetAt(EVALUATE(SESSION.FORMFIELD), #FIELDCOUNTER#))>

<!--- Read Oracle MMO Hardware Table. --->

          <CFQUERY name="ReadMMOHardwareRecsTable" datasource="#application.type#HARDWARE" blockfactor="100">
               SELECT	MMOHW_ID, STATEFOUNDNUMBER, SERIALNUMBER, BUILDINGCODE, ROOMNUMBER, SPACE, PURCHASEORDERNUMBER, ORGCODE,
                         ROOMNUMBER || SPACE AS ROOMSPACE
               FROM 	MMOHARDWARE
               WHERE	STATEFOUNDNUMBER = <CFQUERYPARAM value="#SESSION.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	STATEFOUNDNUMBER 
          </CFQUERY>
          
          <CFIF SESSION.FIELDNUMBER EQ 1>
          
               <CFQUERY name="ModifyHardwareSN" datasource="#application.type#HARDWARE">
                    UPDATE	HARDWAREINVENTORY
                    SET		SERIALNUMBER = '#ReadMMOHardwareRecsTable.SERIALNUMBER#'
                    WHERE	STATEFOUNDNUMBER = <CFQUERYPARAM value="#SESSION.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR">
               </CFQUERY>
               
          </CFIF>
          
          <CFIF SESSION.FIELDNUMBER EQ 2>
          
               <CFQUERY name="ModifyHardwarePO" datasource="#application.type#HARDWARE">
                    UPDATE	HARDWAREINVENTORY
                    SET		PURCHASEORDERNUMBER = '#ReadMMOHardwareRecsTable.PURCHASEORDERNUMBER#'
                    WHERE	STATEFOUNDNUMBER = <CFQUERYPARAM value="#SESSION.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR">
               </CFQUERY>
               
          </CFIF>
          
          <CFIF SESSION.FIELDNUMBER EQ 3>
               
               <CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
                    SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGABBREV
                    FROM		BUILDINGNAMES
                    WHERE	BUILDINGCODE = <CFQUERYPARAM value="#ReadMMOHardwareRecsTable.BUILDINGCODE#" cfsqltype="CF_SQL_VARCHAR">
                    ORDER BY	BUILDINGNAME
               </CFQUERY>

			<CFIF LEFT(#ReadMMOHardwareRecsTable.ROOMSPACE#,1) EQ 0>
				<CFSET BuildRoomNumber = MID(#ReadMMOHardwareRecsTable.ROOMSPACE#, 2, LEN(#ReadMMOHardwareRecsTable.ROOMSPACE#))>
			<CFELSE>
				<CFSET BuildRoomNumber = #ReadMMOHardwareRecsTable.ROOMSPACE#>
			</CFIF>
			<CFSET BldgAbbrevRoomNum = #LookupBuildings.BUILDINGABBREV# & #BUILDROOMNUMBER#>

              <CFQUERY name="LookupRoomNumber" datasource="#application.type#FACILITIES" blockfactor="100">
                    SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, LOC.BUILDINGNAMEID, BN.BUILDINGCODE, BN.BUILDINGNAME    
                    FROM		LOCATIONS LOC, BUILDINGNAMES BN
                    WHERE	LOC.LOCATIONID > 0 AND
                              LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
                              BN.BUILDINGCODE = <CFQUERYPARAM value="#ReadMMOHardwareRecsTable.BUILDINGCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
                              LOC.ROOMNUMBER = <CFQUERYPARAM value="#BldgAbbrevRoomNum#" cfsqltype="CF_SQL_VARCHAR">
              </CFQUERY>
              
              <CFQUERY name="ModifyEquipLocID" datasource="#application.type#HARDWARE">
                    UPDATE	HARDWAREINVENTORY
                    SET		EQUIPMENTLOCATIONID = '#LookupRoomNumber.LOCATIONID#'
                    WHERE	STATEFOUNDNUMBER = <CFQUERYPARAM value="#SESSION.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR">
               </CFQUERY>
               
          </CFIF>
          
          <CFIF SESSION.FIELDNUMBER EQ 4>
          
                <CFQUERY name="LookupOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
                    SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION
                    FROM		ORGCODES
                    WHERE	ORGCODE = <CFQUERYPARAM value="#ReadMMOHardwareRecsTable.ORGCODE#" cfsqltype="CF_SQL_VARCHAR">
                    ORDER BY	ORGCODE
               </CFQUERY>
          
              <CFQUERY name="ModifyHardwareOC" datasource="#application.type#HARDWARE">
                    UPDATE	HARDWAREINVENTORY
                    SET		OWNINGORGID = '#LookupOrgCodes.ORGCODEID#'
                    WHERE	STATEFOUNDNUMBER = <CFQUERYPARAM value="#SESSION.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR">
               </CFQUERY>
               
          </CFIF>
	</CFLOOP>
     
</CFLOOP>


<H1>Data UPDATED!</H1>
<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/mmohardwarereccompare.cfm" /> 

</CFOUTPUT>
    
</BODY>
</HTML>