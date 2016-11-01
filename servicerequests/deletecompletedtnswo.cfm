<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: deletecompletedtnswo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/25/2015 --->
<!--- Date in Production: 08/25/2015 --->
<!--- Module: Delete Completed TNS Work Orders By Date or Hardware Inventory Barcode --->
<!-- Last modified by John R. Pastori on 08/25/2015 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL =" pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/deletecompletedtnswo.cfm">
<cfset CONTENT_UPDATED = "August 25, 2015">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<title>Delete Completed TNS Work Orders By Date or Hardware Inventory Barcode</title>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Service Requests";
	
	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	
	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


//
</script>
<script language="JavaScript" src="../calendar_us.js"></script>
<!--Script ends here -->

</head>

<cfoutput>
<cfif NOT IsDefined('URL.LOOKUPSWASSIGN')>
	<cfset CURSORFIELD = "document.LOOKUP.DELETEDATE.focus()">
<CFELSE>
	<cfset CURSORFIELD = "">     
</cfif>
<body onLoad="#CURSORFIELD#">

<cfinclude template="/include/coldfusion/formheader.cfm">

<!--- 
*************************************************************************************
* The following code is the Look Up Process for Deleting Completed TNS Work Orders. *
*************************************************************************************
 --->

<cfif NOT IsDefined('URL.LOOKUPSWASSIGN')>

	<cfquery name="LookupHardwareInventBarcodes" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, SR.SERVICEREQUESTNUMBER, TNSWO.HW_INVENTORYID, HI.BARCODENUMBER, TNSWO.WO_STATUS,
          		HI.BARCODENUMBER || ' - ' || SR.SERVICEREQUESTNUMBER AS LOOKUPBARCODE
          FROM		TNSWORKORDERS TNSWO, SERVICEREQUESTS SR, HARDWMGR.HARDWAREINVENTORY HI					
          WHERE	TNSWO.TNSWO_ID > 0 AND
          		TNSWO.SRID = SR.SRID AND
                    TNSWO.HW_INVENTORYID = HI.HARDWAREID AND
                    NOT TNSWO.WO_DUEDATE IS NULL AND
                    TNSWO.WO_STATUS = 'COMPLETE'
          ORDER BY	HI.BARCODENUMBER, SR.SERVICEREQUESTNUMBER 
     </cfquery>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Delete Completed TNS Work Orders</h1></td>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<TH align="center"><h4>*Red fields marked with asterisks are required!</h4></TH>
		</tr>
	</table>
	<br clear="left" />

	<table width="100%" align="LEFT" border="0">
		<tr>
<cfform action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<td align="left" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
          <tr>
			<td align="left">&nbsp;&nbsp;</td>
		</tr>
<cfform name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/deletecompletedtnswo.cfm?LOOKUPSWASSIGN=FOUND" method="POST">
		<tr>
               <TH align="left" valign="BOTTOM"><h4><label for="DELETEDATE">*Delete by WO Due Date</label></h4></TH>
               <TH align="left" valign="BOTTOM"><h4><label for="HW_INVENTORYID">*Or Hardware Inventory BarCode</label></h4></TH>
          </tr>
          <tr>
               <td align="left">
                    <cfset FORM.DELETEDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
                    <cfinput type="Text" name="DELETEDATE" id="DELETEDATE" value="Delete Text and Select a Date" align="LEFT" required="No" size="26" maxlength="30" tabindex="2">
                    <script language="JavaScript">
                         new tcal ({'formname': 'LOOKUP','controlname': 'DELETEDATE'});
     
                    </script><br>
				<COM>(The Date Format is MM/DD/YYYY) </COM>
               </td>
               <td>
				<cfselect name="HW_INVENTORYID" id="HW_INVENTORYID" size="1" required="No"  tabindex="3">
                    	 <option value="*">Select an BarCode - SR</option>
                              <cfloop query="LookupHardwareInventBarcodes">
                                   <option value="#HW_INVENTORYID#">#LOOKUPBARCODE#</option>
                              </cfloop>  
                    </cfselect>
			</td>
		</tr>
		<tr>
			<td align="left">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="left" colspan="2">
				<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
			</td>
		</tr>
</cfform>
		<tr>
<cfform action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<td align="left" colspan="2">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
		<tr>
			<td align="CENTER" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
	<cfexit>

<CFELSE>

<!--- 
*****************************************************************************
* The following code is the Delete Process for TNS Work Orders Information. *
*****************************************************************************
 --->

	<cfif #FORM.DELETEDATE# NEQ "Delete Text and Select a Date">
		<cfset FORM.DELETEDATE = #DateFormat(FORM.DELETEDATE, 'dd-mmm-yyyy')#>
          
          <cfquery name="DeleteTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS" result="DeleteResult">
               DELETE FROM	TNSWORKORDERS
               WHERE		WO_STATUS = 'COMPLETE' AND
                              NOT WO_DUEDATE IS NULL AND
                              WO_DUEDATE < TO_DATE('#FORM.DELETEDATE#', 'DD-MON-YYYY')
          </cfquery>
          
     <CFELSEIF #FORM.HW_INVENTORYID# NEQ "*">
     
     	<cfquery name="DeleteTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS" result="DeleteResult">
               DELETE FROM	TNSWORKORDERS
               WHERE		WO_STATUS = 'COMPLETE' AND
                              NOT WO_DUEDATE IS NULL AND
                              HW_INVENTORYID = #FORM.HW_INVENTORYID#
          </cfquery>
     
     <CFELSE>
 
		<script language="JavaScript1.1">
			<!-- 
				alert("No information was entered in the Delete by WO Due Date Or Hardware Inventory BarCode fields. Please use one of the fields to select the appropriate records");
			//
			--> 
			
		</script>

          <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/deletecompletedtnswo.cfm" />
		<cfexit> 
     
     </cfif>
      
     <table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Delete Completed TNS Work Orders <br> By Date Or Hardware Inventory BarCode</h1></td>
		</tr>
	</table>
	<br clear="left" />

	<table width="100%" align="LEFT" border="0">
		<tr>
<cfform action="/#application.type#apps/servicerequests/deletecompletedtnswo.cfm" method="POST">
			<td align="left">
				<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
          <tr>
			<td align="left">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<TH align="CENTER">
				<h2>
                    	#DeleteResult.RecordCount# TNS Work Order records were Deleted.
				</h2>
               </TH>
		</tr>
          <tr>
          	<td align="left">&nbsp;&nbsp;</td>
          </tr>
		<tr>
<cfform action="/#application.type#apps/servicerequests/deletecompletedtnswo.cfm" method="POST">
			<td align="left">
               	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </td>
</cfform>
		</tr>
		<tr>
			<td align="left">
				<cfinclude template="/include/coldfusion/footer.cfm">
			</td>
		</tr>
	</table>
</cfif>

</body>
</cfoutput>
</html>