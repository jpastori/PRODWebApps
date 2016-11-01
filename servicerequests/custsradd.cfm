<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custsradd.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add Customer Service Requests--->
<!-- Last modified by John R. Pastori on 06/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/custsradd.cfm">
<cfset CONTENT_UPDATED = "June 30, 2016">

<cfif (FIND('wiki', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "WIKI")>
	<cfset SESSION.ORIGINSERVER = "WIKI">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelseif (FIND('#application.type#apps/forms', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "FORMS")>
	<cfset SESSION.ORIGINSERVER = "FORMS">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfinclude template = "../programsecuritycheck.cfm">
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html>
<head>
	<title>Add Customer Service Requests</title>

	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Service Requests";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.CUSTSRADD.REQUESTERID.selectedIndex == "0") {
			alertuser (document.CUSTSRADD.REQUESTERID.name +  ",  You must select a Requestor Name.");
			document.CUSTSRADD.REQUESTERID.focus();
			return false;
		}
		
		if (document.CUSTSRADD.PROBLEM_DESCRIPTION.value == "" || document.CUSTSRADD.PROBLEM_DESCRIPTION.value == " ") {
			alertuser (document.CUSTSRADD.PROBLEM_DESCRIPTION.name +  ",  You must enter a Problem Description.");
			document.CUSTSRADD.PROBLEM_DESCRIPTION.focus();
			return false;
		}
		
		if (document.CUSTSRADD.BARCODENUMBER2.value.length == 14) {
			var barcode = document.CUSTSRADD.BARCODENUMBER2.value;
			document.CUSTSRADD.BARCODENUMBER2.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

	}

//
</script>
<!--Script ends here -->

</head>

<cfoutput>

<cfset CURSORFIELD = "document.CUSTSRADD.REQUESTERID.focus()">
<body onLoad="#CURSORFIELD#">

<cfinclude template="/include/coldfusion/formheader.cfm">


<!--- 
************************************************************
* The following code is for all Customer Add SR Processes. *
************************************************************
 --->

<cfquery name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID,CUST.EMAIL, CUST.FAX, CUST.FULLNAME, CUST.UNITID, U.GROUPID, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.UNITID = U.UNITID) AND
     		(CUST.CUSTOMERID = 0 OR	
			CUST.ACTIVE = 'YES')	
	ORDER BY	CUST.FULLNAME
</cfquery>

<cfquery name="ListUnitLiaisons" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	UL.UNITID, UL.ALTERNATE_CONTACTID, U.UNITID, U.UNITNAME, CUST.CUSTOMERID, CUST.FULLNAME, CUST.UNITID, CUST.ACTIVE,
     		U.UNITNAME || ' - ' || CUST.FULLNAME AS DISPLAYNAME
	FROM		UNITLIAISON UL, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	UL.UNITID = U.UNITID AND
     		UL.ALTERNATE_CONTACTID =  CUST.CUSTOMERID AND
     		CUST.ACTIVE = 'YES'
	ORDER BY	U.UNITNAME, CUST.FULLNAME
</cfquery>

<cfquery name="ListCustomerHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE, HI.MODELNAMEID, MNAMEL.MODELNAME,
			HI.MODELNUMBERID, MNUMBERL.MODELNUMBER, HI.CUSTOMERID, CUST.FULLNAME, CUST.CATEGORYID, LOC.LOCATIONNAME, CUST.ACTIVE,
			CUST.FULLNAME || '-' || HI.BARCODENUMBER || '-' || EQT.EQUIPMENTTYPE || '-' || MNAMEL.MODELNAME AS LOOKUPBARCODE
	FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUMBERL, LIBSHAREDDATAMGR.CUSTOMERS CUST,
			FACILITIESMGR.LOCATIONS LOC
	WHERE	(HI.HARDWAREID = 0 OR
     		CUST.ACTIVE = 'YES') AND
     		(HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
			HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
			HI.MODELNUMBERID = MNUMBERL.MODELNUMBERID AND
			HI.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.LOCATIONID = LOC.LOCATIONID)
	ORDER BY	LOOKUPBARCODE
</cfquery>

<!--- 
***********************************************************
* The following code is the Customer Add Request Process. *
***********************************************************
 --->


<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center"><h1>Add Customer Service Requests</h1></td>
	</tr>
</table>

<table width="100%" align="center" border="0">
	<tr>
		<th align="center">
			<h4>
               	*Red fields marked with asterisks are required! <br>
                    Enter only one (1) problem per Service Request.
               </h4>
		</th>
	</tr>
</table>
<br clear="left" />

<table width="100%" align="LEFT" border="0">
	<tr>
<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>
	</tr>
<cfform name="CUSTSRADD" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processcustsradd.cfm" method="POST" enablecab="Yes">
	<tr>
		<th align="left" nowrap><h4><label for="REQUESTERID">*Requestor</label></h4></th>
		<th align="left"><label for="ALTERNATE_CONTACTID">Alternate Contact</label></th>
	</tr>
	<tr>
		<td align="left" valign="TOP">
			<cfselect name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="2"></cfselect>
		</td>
		<td align="left" valign="TOP">
			<cfselect name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListUnitLiaisons" value="ALTERNATE_CONTACTID" display="DISPLAYNAME" selected="0" required="No" tabindex="3"></cfselect><br>
               <COM>
               	(Make selection only if the request involves a public workstation or printer. <br>
                     &nbsp;Select the unit where the public workstation or printer is located.)
              </COM>
		</td>
	</tr>
     <tr>
     	<td align="left" colspan="2">&nbsp;&nbsp;</td>
	</tr>       
	<tr>
		<th align="left" valign="TOP" colspan="2"><h4><label for="PROBLEM_DESCRIPTION">*Problem Description</label></h4></th>
	</tr>
	<tr>
		<td align="left" valign="TOP" colspan="2">
			<textarea name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="5" cols="85" wrap="VIRTUAL" required tabindex="4"> </textarea><br>
               <COM> (Please be as specific as possible.  Basically, tell us what steps we need to take to re-create the problem,<br>
                     what you expected to happen and what actually happened. Include what you are trying to do, what <br> 
                     appears on the screen or printer display, what noises are made, error message text, if any, etc.)
               </COM>
          </td>
     </tr>
     <tr>
     	<td align="left" colspan="2">&nbsp;&nbsp;</td>
	</tr>       
     <tr>
          <th align="left" valign="BOTTOM">
               <label for="BARCODENUMBER1">Customer Hardware</label>
          </th>
          <th align="left" valign="BOTTOM">
          	<label for="BARCODENUMBER2">or Barcode</label>
          </th>
          
     </tr>
     <tr>
          
          <td align="left" valign="TOP">
               <cfselect name="BARCODENUMBER1" id="BARCODENUMBER1" size="1" query="ListCustomerHardware" value="BARCODENUMBER" display="LOOKUPBARCODE" selected="0" required="No"  tabindex="5"></cfselect><br>
               <COM>(If problem is software or hardware related, you must provide a barcode.)</COM>    
          </td>
          <td align="left" valign="TOP">
               <cfinput type="text" name="BARCODENUMBER2" id="BARCODENUMBER2" value="3065000" size="17" maxlength="17" tabindex="6">
          </td>
     </tr>
     <tr>
     	<td align="left" colspan="2">&nbsp;&nbsp;</td>
	</tr>       
	<tr>
		<th align="left" valign="TOP"><label for="DIVISIONNUMBER">Division Number</label></th>
		<th align="left" valign="TOP"><label for="EQUIPMENTLOCATION">Room Number of Hardware</label></th>
	</tr>
	<tr>
		<td align="left" valign="TOP">
          	<cfinput type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="" align="LEFT" required="No" size="50" tabindex="7"><br>
               <COM>(Type the hardware's labeled name.)</COM>
          </td>
		<td align="left" valign="TOP">
          	<cfinput type="Text" name="EQUIPMENTLOCATION" id="EQUIPMENTLOCATION" value="" required="No" size="20" maxlength="50" tabindex="8"><br>
               <COM>(i.e. LL-229.)</COM>
          </td>
	</tr>
     <tr>
     	<td align="left" colspan="2">&nbsp;&nbsp;</td>
	</tr>       
	<tr>
		<td align="LEFT">
          	<input type="hidden" name="PROCESSCUSTSRADD" value="ADD" />
               <input type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="9" />
          </td>
		<td align="LEFT">
          	<input type="image" src="/images/buttonClearForm.jpg" value="CLEAR FORM" alt="Clear Form" onClick="CUSTSRADD.reset(); return false; " tabindex="10" />
          </td>
	</tr>
</cfform>
	<tr>
     	<td align="left" colspan="2">&nbsp;&nbsp;</td>
	</tr> 
	<tr>
<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="11" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>
	</tr>
	<tr>
		<td align="CENTER" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
	</tr>
</table>

</body>
</cfoutput>
</html>