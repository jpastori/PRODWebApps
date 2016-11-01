<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lookupcontactsprobleminfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Look up Contact/Category/Hardware for the IDT Service Requests --->
<!-- Last modified by John R. Pastori on 06/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm">
<cfset CONTENT_UPDATED = "June 30, 2016">
<cfinclude template = "../programsecuritycheck.cfm">

<cfif (FIND('joel', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "JOEL")>
	<cfset SESSION.ORIGINSERVER = "JOEL">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
<cfelse>
	<cfset SESSION.ORIGINSERVER = "">
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html>
<head>
	<title>Look up Contact/Category/Hardware for the IDT Service Requests</title>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Service Requests";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateLookupFields() {
		if (document.LOOKUP.REQUESTERID.selectedIndex == "0") {
			alertuser (document.LOOKUP.REQUESTERID.name +  ",  You must select a Requestor Name.");
			document.LOOKUP.REQUESTERID.focus();
			return false;
		}

		if (document.LOOKUP.PROBLEM_CATEGORYID.selectedIndex == "0") {
			alertuser (document.LOOKUP.PROBLEM_CATEGORYID.name +  ",  You must select a Problem Category.");
			document.LOOKUP.PROBLEM_CATEGORYID.focus();
			return false;
		}
		if (document.LOOKUP.BARCODENUMBER1.selectedIndex != "0" && document.LOOKUP.BARCODENUMBER2.value != "3065000") {
			alertuser ("You must select either hardware by Customer or by BarCode.  You can't choose both!");
			document.LOOKUP.BARCODENUMBER1.focus();
			return false;
		}
		
		if (document.LOOKUP.BARCODENUMBER2.value.length == 14) {
			var barcode = document.LOOKUP.BARCODENUMBER2.value;
			document.LOOKUP.BARCODENUMBER2.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

	}
//
</script>
<!--Script ends here -->

</head>

<body onLoad="document.LOOKUP.REQUESTERID.focus()">

<cfoutput>

<cfinclude template="/include/coldfusion/formheader.cfm">

<cfif NOT IsDefined('URL.PROCESS')>
	<cfset URL.PROCESS = "ADD">
</cfif>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<cfquery name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID,CUST.EMAIL, CUST.FAX, CUST.FULLNAME, CUST.UNITID, U.GROUPID, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.UNITID = U.UNITID) AND
     		(CUST.CUSTOMERID = 0 OR	
			CUST.ACTIVE = 'YES')	
	ORDER BY	CUST.FULLNAME
</cfquery>

<cfquery name="ListAltContacts" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID,CUST.EMAIL, CUST.FAX, CUST.FULLNAME, CUST.UNITID, U.GROUPID, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.UNITID = U.UNITID) AND
     		(CUST.CUSTOMERID = 0 OR	
			CUST.ACTIVE = 'YES')	
	ORDER BY	CUST.FULLNAME
</cfquery>

<cfquery name="ListProblemCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
	SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME, CATEGORYLETTER || ' ' || CATEGORYNAME AS CATEGORY
	FROM		PROBLEMCATEGORIES
	ORDER BY	CATEGORYID
</cfquery>

<cfquery name="ListCustomerHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE,
			HI.MODELNAMEID, MNAMEL.MODELNAME, HI.MODELNUMBERID, MNUMBERL.MODELNUMBER, HI.CUSTOMERID, CUST.FULLNAME, LOC.LOCATIONNAME,
			CUST.FULLNAME || '-' || HI.DIVISIONNUMBER || '-' || HI.BARCODENUMBER || '-' || EQT.EQUIPMENTTYPE || '-' || MNAMEL.MODELNAME AS LOOKUPBARCODE
	FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUMBERL, LIBSHAREDDATAMGR.CUSTOMERS CUST,
			FACILITIESMGR.LOCATIONS LOC
	WHERE	HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
			HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
			HI.MODELNUMBERID = MNUMBERL.MODELNUMBERID AND
			HI.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.LOCATIONID = LOC.LOCATIONID
	ORDER BY	LOOKUPBARCODE
</cfquery>


<!--- 
**************************************************************************
* The following code is the Look Up Modify Process for Service Requests. *
**************************************************************************
 --->

<cfif IsDefined('URL.CONTACTSPROBLEMCHANGED')>
	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Modify Existing SRs</h1></td>
		</tr>
	</table>
	<table width="100%" align="center" border="0">
		<tr>
			<th align="center"><h4>*Red fields marked with asterisks are required!&nbsp;&nbsp;&nbsp;&nbsp; </h4></th>
		</tr>
	</table>
	<br clear="left" />
	<table width="100%" align="center">

<cfform name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=#URL.PROCESS#&CONTACTSPROBLEMCHANGED=YES&LOOKUPSR=FOUND" method="POST">
		<tr>
			<th align="left" nowrap><h4><label for="REQUESTERID">*Requestor:</label></h4></th>
			<td>
				<cfselect name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="#URL.REQUESTER#" required="No" tabindex="2"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left"><label for="ALTERNATE_CONTACTID">Alternate Contact:</label></th>
			<td>
				<cfselect name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListAltContacts" value="CUSTOMERID" display="FULLNAME" selected="#URL.ALTCONTACT#" required="No" tabindex="3"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left" nowrap><h4><label for="PROBLEM_CATEGORYID">*Problem Category:</label></h4></th>
			<td>
				<cfselect name="PROBLEM_CATEGORYID" id="PROBLEM_CATEGORYID" size="1" query="ListProblemCategories" value="CATEGORYID" display="CATEGORY" selected="#URL.PROBCAT#" required="No" tabindex="4"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left"><label for="BARCODENUMBER1">Customer Hardware:</label></th>
			<td>
				<cfselect name="BARCODENUMBER1" id="BARCODENUMBER1" size="1" query="ListCustomerHardware" value="BARCODENUMBER" display="LOOKUPBARCODE" selected="#URL.BARCODE#" required="No"  tabindex="5"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left"><label for="BARCODENUMBER2">or Barcode:</label></th>
			<td>
				<cfinput type="text" name="BARCODENUMBER2" id="BARCODENUMBER2" value="3065000" size="18" maxlength="17" tabindex="6">
			</td>
		</tr>
          <tr>
               <td align="left">&nbsp;&nbsp;</td>
          </tr>
		<tr>
			<td align="LEFT" colspan="2"><input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="7" />
		</td></tr>
</cfform>

		<tr>
			<td align="left" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

<cfelse>

<!--- 
***********************************************************************
* The following code is the Look Up Add Process for Service Requests. *
***********************************************************************
 --->

     <cfquery name="GetMaxSRUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(SRID) AS MAX_ID
		FROM		SERVICEREQUESTS
	</cfquery>

     <cfquery name="LookupLastSRCreated" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRID, SERVICEREQUESTNUMBER, CREATIONDATE
		FROM		SERVICEREQUESTS
          WHERE	SRID = #GetMaxSRUniqueID.MAX_ID#
	</cfquery>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td  align="center"><h1>Add New SRs</h1></td>
		</tr>
	</table>
     
	<table width="100%" align="center" border="0">
		<tr>
			<th align="center"><h4>*Red fields marked with asterisks are required!&nbsp;&nbsp;&nbsp;&nbsp; </h4></th>
		</tr>
          <tr>
          	<td align="center"> 
               	<strong>Last SR Created = #LookupLastSRCreated.SERVICEREQUESTNUMBER#(#GetMaxSRUniqueID.MAX_ID#) &nbsp;&nbsp;  
                    #DateFormat(LookupLastSRCreated.CREATIONDATE, "mm/dd/yyyy")#</strong>
               </td>
          </tr>
	</table>
     
	<br clear="left" />
	<table width="100%" align="center">
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>

		</tr>
          <tr>
               <td align="left">&nbsp;&nbsp;</td>
          </tr>
<cfform name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
		<tr>
			<th align="left" nowrap><h4><label for="REQUESTERID">*Requestor:</label></h4></th>
			<td>
				<cfselect name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="2"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left"><label for="ALTERNATE_CONTACTID">Alternate Contact:</label></th>
			<td>
				<cfselect name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListAltContacts" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="3"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left"><h4><label for="PROBLEM_CATEGORYID">*Problem Category:</label></h4></th>
			<td>
				<cfselect name="PROBLEM_CATEGORYID" id="PROBLEM_CATEGORYID" size="1" query="ListProblemCategories" value="CATEGORYID" display="CATEGORY" selected="0" required="No" tabindex="4"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left"><label for="BARCODENUMBER1">Customer Hardware:</label></th>
			<td>
				<cfselect name="BARCODENUMBER1" id="BARCODENUMBER1" size="1" query="ListCustomerHardware" value="BARCODENUMBER" display="LOOKUPBARCODE" selected="0" required="No"  tabindex="5"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left"><label for="BARCODENUMBER2">or Barcode:</label></th>
			<td>
				<cfinput type="text" name="BARCODENUMBER2" id="BARCODENUMBER2" value="3065000" size="18" maxlength="17" tabindex="6">
			</td>
		</tr>
          <tr>
               <td align="left">&nbsp;&nbsp;</td>
          </tr>
		<tr>
			<td align="LEFT" colspan="2"><input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="7" /></td>
		</tr>
</cfform>
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="8" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>

		</tr>
		<tr>
			<td align="left" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</cfif>
</cfoutput>

</body>
</html>