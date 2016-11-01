<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custsrapproval.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/16/2012 --->
<!--- Date in Production: 08/16/2012 --->
<!--- Module: Customer Service Request Approval --->
<!-- Last modified by John R. Pastori on 06/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/custsrapproval.cfm">
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
	<title>Customer Service Request Approval</title>

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
	
	function validateLookupField() {
		if (document.LOOKUP.CUSTADDREQUEST.selectedIndex == "0") {
			alertuser ("A Customer Name and Request Number MUST be selected!");
			document.LOOKUP.CUSTADDREQUEST.focus();
			return false;
		}
	}

	function validateReqFields() {
		if (document.CUSTSRADDAPPROVAL.REQUESTERID.selectedIndex == "0") {
			alertuser (document.CUSTSRADDAPPROVAL.REQUESTERID.name +  ",  You must select a Requestor Name.");
			document.CUSTSRADDAPPROVAL.REQUESTERID.focus();
			return false;
		}
		
		if (document.CUSTSRADDAPPROVAL.PROBLEM_DESCRIPTION.value == "" || document.CUSTSRADDAPPROVAL.PROBLEM_DESCRIPTION.value == " ") {
			alertuser (document.CUSTSRADDAPPROVAL.PROBLEM_DESCRIPTION.name +  ",  You must enter a Problem Description.");
			document.CUSTSRADDAPPROVAL.PROBLEM_DESCRIPTION.focus();
			return false;
		}
		
		if (document.CUSTSRADDAPPROVAL.PROBLEM_CATEGORYID.selectedIndex == "0") {
			alertuser (document.CUSTSRADDAPPROVAL.PROBLEM_CATEGORYID.name +  ",  You must select a Problem Category.");
			document.CUSTSRADDAPPROVAL.PROBLEM_CATEGORYID.focus();
			return false;
		}
		
		if ((document.CUSTSRADDAPPROVAL.EQUIPMENTBARCODE.value.length > 7) && (document.CUSTSRADDAPPROVAL.EQUIPMENTBARCODE.value.length != 14 
		  && document.CUSTSRADDAPPROVAL.EQUIPMENTBARCODE.value.length != 17)) {
			alertuser (document.CUSTSRADDAPPROVAL.EQUIPMENTBARCODE.name +  ",  If you include an Equipment Barcode, it MUST be 14 OR 17 characters.");
			document.CUSTSRADDAPPROVAL.EQUIPMENTBARCODE.focus();
			return false;
		}
		
		if (document.CUSTSRADDAPPROVAL.EQUIPMENTBARCODE.value.length == 14) {
			var barcode = document.CUSTSRADDAPPROVAL.EQUIPMENTBARCODE.value;
			document.CUSTSRADDAPPROVAL.EQUIPMENTBARCODE.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
			return true;
		}

	}
	
	
	function setNotApproved() {
		document.CUSTSRADDAPPROVAL.PROCESSCUSTSRADD.value = "NOT APPROVED";
		return true;
	}


//
</script>
<!--Script ends here -->

</head>

<cfoutput>

<cfset CURSORFIELD = "document.CUSTADD.REQUESTERID.focus()">
<body onLoad="#CURSORFIELD#">

<cfif IsDefined('URL.CUSTADDREQUEST')>
	<cfset FORM.CUSTADDREQUEST = #URL.CUSTADDREQUEST#>
</cfif>

<cfinclude template="/include/coldfusion/formheader.cfm">

<!--- 
**************************************************************************************
* The following code is the Look Up Process for Approving Customer Service Requests. *
**************************************************************************************
 --->

<cfif NOT IsDefined('FORM.CUSTADDREQUEST')>

	<cfquery name="LookupCustomerSRAdds" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	CSRA.CUSTSRADDID, CSRA.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, CSRA.ALTERNATE_CONTACTID, CSRA.PROBLEM_DESCRIPTION, 
				CSRA.EQUIPMENTBARCODE, CSRA.DIVISIONNUMBER, CSRA.EQUIPMENTLOCATION, CSRA.APPROVALFLAG, CSRA.DATEENTERED,  
                    CUST.FULLNAME || ' - ' ||  CSRA.CUSTSRADDID  || ' - ' || TO_CHAR(CSRA.DATEENTERED, 'MM/DD/YYYY') AS LOOKUPKEY
		FROM		CUSTSRADD CSRA, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	CSRA.REQUESTERID =  CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CSRA.APPROVALFLAG = 'NO'
		ORDER BY  CUST.FULLNAME
	</cfquery>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Customer Service Request Lookup For Approval</h1></td>
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
<cfform name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/custsrapproval.cfm" method="POST">
		<tr>
			<th align="left" width="30%"><h4><label for="CUSTADDREQUEST">Customer Name, Request Number and Date Entered:</label></h4></th>
			<td align="left" width="70%">
				<cfselect name="CUSTADDREQUEST" id="CUSTADDREQUEST" size="1" query="LookupCustomerSRAdds" value="CUSTSRADDID" display="LOOKUPKEY" required="No" tabindex="2"></cfselect>
			</td>
		</tr>
		<tr>
			<td align="left" width="33%">&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td align="left" width="33%">
				<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
			</td>
		</tr>
</cfform>
		<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>

		</tr>
		<tr>
			<td align="CENTER" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

<cfelse>

<!--- 
*****************************************************************
* The following code is for all Customer SR Approval Processes. *
*****************************************************************
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

<cfquery name="ListProblemCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
	SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME, CATEGORYLETTER || ' ' || CATEGORYNAME AS CATEGORY
	FROM		PROBLEMCATEGORIES
	ORDER BY	CATEGORYID
</cfquery>

<cfquery name="ListPriority" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
	SELECT	PRIORITYID, PRIORITYNAME
	FROM		PRIORITY
	ORDER BY	PRIORITYNAME
</cfquery>

<cfquery name="SelectCustomerSRAdds" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	CSRA.CUSTSRADDID, CSRA.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, CSRA.ALTERNATE_CONTACTID, CSRA.PROBLEM_DESCRIPTION, 
     		CSRA.EQUIPMENTBARCODE, CSRA.DIVISIONNUMBER, CSRA.EQUIPMENTLOCATION, CSRA.APPROVALFLAG, TO_CHAR(CSRA.DATEENTERED, 'MM/DD/YYYY') AS DATEENTERED
	FROM		CUSTSRADD CSRA, LIBSHAREDDATAMGR.CUSTOMERS CUST
     WHERE	CSRA.CUSTSRADDID = <CFQUERYPARAM value="#FORM.CUSTADDREQUEST#" cfsqltype="CF_SQL_NUMERIC"> AND
     		CSRA.REQUESTERID =  CUST.CUSTOMERID AND
     		CUST.ACTIVE = 'YES' AND
               CSRA.APPROVALFLAG = 'NO'
     ORDER BY  CUST.FULLNAME
</cfquery>

<cfif #SelectCustomerSRAdds.RecordCount# EQ 0>
	<script language="JavaScript">
          <!-- 
               alert("Customer SR Request has already been approved or denied.");
          --> 
     </script>
     <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
     <cfexit>
</cfif>

<cfquery name="ListCustomerHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE, HI.MODELNAMEID, MNAMEL.MODELNAME,
			HI.MODELNUMBERID, MNUMBERL.MODELNUMBER, HI.CUSTOMERID, CUST.FULLNAME, LOC.LOCATIONNAME,
			CUST.FULLNAME || '-' || HI.BARCODENUMBER || '-' || EQT.EQUIPMENTTYPE || '-' || MNAMEL.MODELNAME AS LOOKUPBARCODE
	FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUMBERL, LIBSHAREDDATAMGR.CUSTOMERS CUST,
			FACILITIESMGR.LOCATIONS LOC
	WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#SelectCustomerSRAdds.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
     		HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
			HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
			HI.MODELNUMBERID = MNUMBERL.MODELNUMBERID AND
			HI.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.LOCATIONID = LOC.LOCATIONID
	ORDER BY	LOOKUPBARCODE
</cfquery>


<!--- 
***********************************************************
* The following code is the Customer SR Approval Process. *
***********************************************************
 --->


<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center"><h1>Customer SR Approval</h1></td>
	</tr>
</table>

<table width="100%" align="center" border="0">
	<tr>
		<th align="center">
			<h4>*Red fields marked with asterisks are required!</h4><br>
               Date Request Was Entered:  #SelectCustomerSRAdds.DATEENTERED#
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
<cfform name="CUSTSRADDAPPROVAL" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processcustsradd.cfm" method="POST" enablecab="Yes">
	<tr>
		<th align="left" nowrap><h4><label for="REQUESTERID">*Requestor</label></h4></th>
		<th align="left"><label for="ALTERNATE_CONTACTID">Alternate Contact</label></th>
	</tr>
	<tr>
		<td>
          	<cfcookie name="CUSTADDREQUEST" secure="NO" value="#FORM.CUSTADDREQUEST#">
			<cfselect name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="#SelectCustomerSRAdds.REQUESTERID#" required="No" tabindex="2"></cfselect>
		</td>
		<td>
			<cfselect name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListUnitLiaisons" value="ALTERNATE_CONTACTID" display="DISPLAYNAME" selected="#SelectCustomerSRAdds.ALTERNATE_CONTACTID#" required="No" tabindex="3"></cfselect><br>
               <COM>(Make selection only if the request involves a public workstation or printer.)</COM>
		</td>
	</tr>
	<tr>
		<th align="left" valign="TOP" colspan="2"><h4><label for="PROBLEM_DESCRIPTION">*Problem Description</label></h4></th>
     </tr>
     <tr>
		<td align="left" valign="TOP" colspan="2">
			<textarea name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="10" cols="60" wrap="VIRTUAL" required tabindex="4">#SelectCustomerSRAdds.PROBLEM_DESCRIPTION#</textarea>
          </td>
	</tr>
	<tr>
          <th align="left" nowrap><h4><label for="PROBLEM_CATEGORYID">*Problem Category</label></h4></th>
          <th align="left"><h4><label for="PRIORITYID">*Priority</label></h4></th>
     </tr>
	<tr>
		<td align="left" valign="TOP">
			<cfselect name="PROBLEM_CATEGORYID" id="PROBLEM_CATEGORYID" size="1" query="ListProblemCategories" value="CATEGORYID" display="CATEGORY" selected="0" required="No" tabindex="5"></cfselect>
		</td>
          <td align="left" width="33%">
               <cfselect name="PRIORITYID" id="PRIORITYID" size="1" query="ListPriority" value="PRIORITYID" display="PRIORITYNAME" selected="3" required="No" tabindex="6"></cfselect>
          </td>
    </tr>
	<tr>
          <th align="left" valign="TOP"><label for="EQUIPMENTBARCODE">Customer Hardware</label></th>
          <th align="left">&nbsp;&nbsp;</th>
	</tr>
	<tr>
		<td align="left" valign="TOP">
               <cfinput type="text" name="EQUIPMENTBARCODE" id="EQUIPMENTBARCODE" value="#SelectCustomerSRAdds.EQUIPMENTBARCODE#" size="18" maxlength="17" tabindex="7"><br>
               <COM>(If problem is software or hardware related, you must provide a barcode.)</COM>
          <cfif #ListCustomerHardware.RecordCount# EQ 0>
          	<br><COM>(<h4>*NOTE:  THE CUSTOMER ENTERED BARCODE DOES NOT EXIST IN OUR HARDWARE INVENTORY TABLE.</h4>)</COM>
          </cfif>
		</td>
          <td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="left"><label for="DIVISIONNUMBER">Division Number</label></th>
		<th align="left"><label for="EQUIPMENTLOCATION">Room Number</label></th>
	</tr>
	<tr>
		<td align="left">
          	#SelectCustomerSRAdds.DIVISIONNUMBER#
          </td>
		<td align="left">
          	#SelectCustomerSRAdds.EQUIPMENTLOCATION#
          </td>
	</tr>
     <tr>
		<td align="LEFT">
          	<input type="hidden" name="PROCESSCUSTSRADD" value="APPROVE" />
          	<input type="image" src="/images/buttonApprove.jpg" value="APPROVE" alt="Approve" tabindex="8" />
          </td>
          <td align="LEFT">
          	<input type="image" src="/images/buttonNotApproved.jpg" value="NOT APPROVED" alt="Not Approved" onClick="return setNotApproved();" tabindex="9" />
          </td>
	</tr>
</cfform>
	<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="10" /><br />
			<COM>(Please DO NOT use the Browser's Back Button to exit this screen.)</COM>
		</td>
</cfform>

	</tr>
	<tr>
		<td align="CENTER" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
	</tr>
</table>

</cfif>

</body>
</cfoutput>
</html>