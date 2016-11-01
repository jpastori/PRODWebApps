<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: masterinventorybycustrpt.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: IDT Hardware Inventory - Master Inventory by Customer Report --->
<!-- Last modified by John R. Pastori on 04/06/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/hardwareinventory/masterinventorybycustrpt.cfm">
<cfset CONTENT_UPDATED = "April 06 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<title>IDT Hardware Inventory - Master Inventory by Customer Report</title>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language="JAVASCRIPT">
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

</script>
<!--Script ends here -->

</head>

<body>

<cfoutput>
<!--- 
*************************************************************************************************
* The following code displays the IDT Hardware Inventory - Master Inventory by Customer Report. *
*************************************************************************************************
 --->
<cfquery name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
     SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE, 
               HI.DESCRIPTIONID, ED.EQUIPMENTDESCRIPTION, HI.MODELNAMEID, MNL.MODELNAME, HI.MODELNUMBERID,  MUL.MODELNUMBER, HI.EQUIPMENTLOCATIONID,
               LOC.ROOMNUMBER, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME AS CUSTNAME, HI.MACHINENAME, HI.MACADDRESS, HI.MODIFIEDBYID, HI.DATECHECKED
     FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED, MODELNAMELIST MNL, MODELNUMBERLIST MUL, FACILITIESMGR.LOCATIONS LOC, 				
     		LIBSHAREDDATAMGR.CUSTOMERS CUST
     WHERE	(HI.HARDWAREID > 0 AND
               HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
               HI.EQUIPMENTTYPEID IN (1,8,15) AND
               HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
               HI.MODELNAMEID = MNL.MODELNAMEID AND
               HI.MODELNUMBERID = MUL.MODELNUMBERID AND
               HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
               HI.CUSTOMERID = CUST.CUSTOMERID)
     ORDER BY	CUST.FULLNAME, HI.BARCODENUMBER
</cfquery>


<table width="100%" align="center" border="3">
     <tr align="center">
          <th align="center"><h1>IDT Hardware Inventory <BR> Master Inventory by Customer Report</h1></th>
     </tr>
</table>
<table width="100%" align="center" border="0">
     <tr>
<cfform action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
          <td align="left">
               <input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
          </td>
</cfform>
     </tr>
     <tr>
          <th align="CENTER" colspan="16">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
     </tr>
     <tr>
          <th align="CENTER">Bar Code Number</th>
          <th align="CENTER">State Found Number</th>
          <th align="CENTER">Serial Number</th>
          <th align="CENTER">Division Number</th>
          <th align="CENTER">Equipment Type</th>
          <th align="CENTER">Equipment Description</th>
          <th align="CENTER">Model Name</th>
          <th align="CENTER">Model Number</th>
          <th align="CENTER">Warranty Expiration</th>
          <th align="CENTER">Equipment Location</th>
          <th align="CENTER">Wall Jack</th>
          <th align="CENTER">Current Assignment</th>
          <th align="CENTER">Machine Name</th>
          <th align="CENTER">MAC Address</th>
          <th align="CENTER">Modified-By Name</th>
          <th align="CENTER">Date Checked</th>
     </tr>

<cfloop query="LookupHardware">

     <cfquery name="LookupHardwareWarranty" datasource="#application.type#HARDWARE">
          SELECT	HARDWAREWARRANTYID, BARCODENUMBER, WARRANTYRESTRICTIONS, WARRANTYEXPIRATIONDATE, WARRANTYCOMMENTS
          FROM		HARDWAREWARRANTY
          WHERE	BARCODENUMBER = <CFQUERYPARAM value="#LookupHardware.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR">
          ORDER BY	BARCODENUMBER
     </cfquery>
     
     <cfquery name="LookupJackNumbers" datasource="#application.type#FACILITIES">
          SELECT	WJ.WALLJACKID, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.WALLDIRID, WD.WALLDIRNAME
          FROM		WALLJACKS WJ, WALLDIRECTION WD
          WHERE	WJ.HARDWAREID = <CFQUERYPARAM value="#LookupHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    WJ.WALLDIRID = WD.WALLDIRID
          ORDER BY	WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER
     </cfquery>

     <cfquery name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
          SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, FULLNAME || '-' || INITIALS AS SDINITIALS
          FROM		CUSTOMERS
          WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupHardware.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	FULLNAME
     </cfquery>

     <tr>
          <td align="left" valign="TOP" nowrap><div>#LookupHardware.BARCODENUMBER#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.STATEFOUNDNUMBER#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.SERIALNUMBER#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.DIVISIONNUMBER#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.EQUIPMENTTYPE#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.EQUIPMENTDESCRIPTION#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.MODELNAME#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.MODELNUMBER#</div></td>
          <td align="left" valign="TOP"><div>#DateFormat(LookupHardwareWarranty.WARRANTYEXPIRATIONDATE, "MM/DD/YYYY")#</div></td>
          <td align="left" valign="TOP" nowrap><div>#LookupHardware.ROOMNUMBER#</div></td>
          <td align="left" valign="TOP"><div>#LookupJackNumbers.CLOSET#-#LookupJackNumbers.JACKNUMBER#-#LookupJackNumbers.PORTLETTER#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.CUSTNAME#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.MACHINENAME#</div></td>
          <td align="left" valign="TOP"><div>#LookupHardware.MACADDRESS#</div></td>
          <td align="left" valign="TOP" nowrap><div>#LookupRecordModifier.FULLNAME#</div></td>
          <td align="left" valign="TOP"><div>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</div></td>
     </tr>
</cfloop>
     <tr>
          <th align="CENTER" colspan="16">#LookupHardware.RecordCount# hardware records were selected.<br /><br /></th>
     </tr>
     <tr>
<cfform action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
          <td align="left">
               <input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
          </td>
</cfform>
     </tr>
     <tr>
          <td align="left" colspan="16"><cfinclude template="/include/coldfusion/footer.cfm"></td>
     </tr>
</table>

</cfoutput>