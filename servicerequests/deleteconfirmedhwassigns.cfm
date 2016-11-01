<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: deleteconfirmedhwassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/03/2012 --->
<!--- Date in Production: 12/03/2012 --->
<!--- Module: Delete Confirmed Hardware Assignments By Date --->
<!-- Last modified by John R. Pastori on 10/10/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL =" pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/deleteconfirmedhwassigns.cfm">
<cfset CONTENT_UPDATED = "October 10, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<html>
<head>
	<title>Delete Confirmed Hardware Assignments By Date</title>
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
<cfif NOT IsDefined('URL.LOOKUPHWASSIGN')>
	<cfset CURSORFIELD = "document.LOOKUP.DELETEDATE.focus()">
<cfelse>
	<cfset CURSORFIELD = "">     
</cfif>
<body onLoad="#CURSORFIELD#">

<cfinclude template="/include/coldfusion/formheader.cfm">

<!--- 
******************************************************************************************
* The following code is the Look Up Process for Deleting Confirmed Hardware Assignments. *
******************************************************************************************
 --->

<cfif NOT IsDefined('URL.LOOKUPHWASSIGN')>

	<cfquery name="LookupReturnBarcodes" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SRHA.SRHARDWASSIGNID, SRHA.SRID, SR.SERVICEREQUESTNUMBER, SRHA.RETURNINVENTID, RETURNHI.BARCODENUMBER, 
          		SRHA.CONFIRMFLAG, SRHA.CONFIRMEDDATE, RETURNHI.BARCODENUMBER || ' - ' || SR.SERVICEREQUESTNUMBER AS LOOKUPBARCODE
          FROM		SRHARDWASSIGNS SRHA, SERVICEREQUESTS SR, HARDWMGR.HARDWAREINVENTORY RETURNHI					
          WHERE	SRHA.SRHARDWASSIGNID > 0 AND
          		SRHA.SRID = SR.SRID AND
                    SRHA.RETURNINVENTID = RETURNHI.HARDWAREID AND
                    SRHA.CONFIRMFLAG = 'YES' AND
                    NOT SRHA.CONFIRMEDDATE IS NULL
          ORDER BY	RETURNHI.BARCODENUMBER, SR.SERVICEREQUESTNUMBER
     </cfquery>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Delete Confirmed Hardware Assignments <br> By Date Lookup</h1></td>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<th align="center"><h4>*Red fields marked with asterisks are required!</h4></th>
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
<cfform name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/deleteconfirmedhwassigns.cfm?LOOKUPHWASSIGN=FOUND" method="POST">
		<tr>
               <th align="left" valign="BOTTOM"><h4><label for="DELETEDATE">*Delete by Confirmed Date</label></h4></th>
               <th align="left" valign="BOTTOM"><h4><label for="RETURNINVENTID">*Or Returning BarCode</label></h4></th>
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
				<cfselect name="RETURNINVENTID" id="RETURNINVENTID" size="1" required="No"  tabindex="3">
                    	 <option value="*">Select an BarCode - SR</option>
                              <cfloop query="LookupReturnBarcodes">
                                   <option value="#RETURNINVENTID#">#LOOKUPBARCODE#</option>
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

<cfelse>

<!--- 
*********************************************************************************
* The following code is the Delete Process for Hardware Assignment Information. *
*********************************************************************************
 --->

	<cfif #FORM.DELETEDATE# NEQ "Delete Text and Select a Date">
		<cfset FORM.DELETEDATE = #DateFormat(FORM.DELETEDATE, 'dd-mmm-yyyy')#>
     
          <cfquery name="DeleteHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" result="DeleteResult">
               DELETE FROM	SRHARDWASSIGNS
               WHERE		CONFIRMFLAG = 'YES' AND
                              NOT CONFIRMEDDATE IS NULL AND
                              CONFIRMEDDATE < TO_DATE('#FORM.DELETEDATE#', 'DD-MON-YYYY')
          </cfquery>
      
     <cfelseif #FORM.RETURNINVENTID# NEQ "*">
     
     	<cfquery name="DeleteHardwareAssignments" datasource="#application.type#SERVICEREQUESTS" result="DeleteResult">
               DELETE FROM	SRHARDWASSIGNS
               WHERE		CONFIRMFLAG = 'YES' AND
                              NOT CONFIRMEDDATE IS NULL AND
                              RETURNINVENTID = #FORM.RETURNINVENTID#
          </cfquery>
     
     <cfelse>
 
		<script language="JavaScript1.1">
			<!-- 
				alert("No information was entered in the Delete by Confirmed Date Or Returning BarCode fields. Please use one of the fields to select the appropriate records");
			//
			--> 
			
		</script>

          <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/deleteconfirmedhwassigns.cfm" />
		<cfexit> 
     
     </cfif>
      
     <table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Delete Confirmed Hardware Assignments</h1></td>
		</tr>
	</table>
	<br clear="left" />

	<table width="100%" align="LEFT" border="0">
		<tr>
<cfform action="/#application.type#apps/servicerequests/deleteconfirmedhwassigns.cfm" method="POST">
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
			<th align="CENTER">
				<h2>
                    	#DeleteResult.RecordCount# Hardware Assignment records were Deleted.
				</h2>
               </th>
		</tr>
          <tr>
          	<td align="left">&nbsp;&nbsp;</td>
          </tr>
		<tr>
<cfform action="/#application.type#apps/servicerequests/deleteconfirmedhwassigns.cfm" method="POST">
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