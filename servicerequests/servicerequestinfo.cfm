<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: servicerequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Add and Modify Service Requests--->
<!-- Last modified by John R. Pastori on 06/30/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/servicerequests/servicerequestinfo.cfm">
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
	<cfif URL.PROCESS EQ 'ADD'>
		<title>Add Service Requests</title>
	<cfelse>
		<title>Modify Service Requests</title>
	</cfif>
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
		if (document.SERVICEREQUEST.PROBLEM_SUBCATEGORYID.selectedIndex == "0") {
			alertuser (document.SERVICEREQUEST.PROBLEM_SUBCATEGORYID.name +  ",  You must select a Problem Sub-Category Name.");
			document.SERVICEREQUEST.PROBLEM_SUBCATEGORYID.focus();
			return false;
		}

		if (document.SERVICEREQUEST.SERVICETYPEID.selectedIndex == "0") {
			alertuser (document.SERVICEREQUEST.SERVICETYPEID.name +  ",  You must select a Service Type Name.");
			document.SERVICEREQUEST.SERVICETYPEID.focus();
			return false;
		}

		if (document.SERVICEREQUEST.ACTIONID.selectedIndex == "0") {
			alertuser (document.SERVICEREQUEST.ACTIONID.name +  ",  You must select a Action Name.");
			document.SERVICEREQUEST.ACTIONID.focus();
			return false;
		}

		if (document.SERVICEREQUEST.OPERATINGSYSTEMID.selectedIndex == "0") {
			alertuser (document.SERVICEREQUEST.OPERATINGSYSTEMID.name +  ",  You must select an Operating System Name.");
			document.SERVICEREQUEST.OPERATINGSYSTEMID.focus();
			return false;
		}

		if (document.SERVICEREQUEST.GROUPASSIGNEDID.selectedIndex == "0") {
			alertuser (document.SERVICEREQUEST.GROUPASSIGNEDID.name +  ",  You must Assign a Primary Group.");
			document.SERVICEREQUEST.GROUPASSIGNEDID.focus();
			return false;
		}
		
		if (document.SERVICEREQUEST.PRIORITYID.selectedIndex == "0") {
			alertuser (document.SERVICEREQUEST.PRIORITYID.name +  ",  You must Assign a Priority.");
			document.SERVICEREQUEST.PRIORITYID.focus();
			return false;
		}

		if (document.SERVICEREQUEST.PROBLEM_DESCRIPTION.value == "" || document.SERVICEREQUEST.PROBLEM_DESCRIPTION.value == " ") {
			alertuser (document.SERVICEREQUEST.PROBLEM_DESCRIPTION.name +  ",  You must enter a Problem Description.");
			document.SERVICEREQUEST.PROBLEM_DESCRIPTION.focus();
			return false;
		}


	}

	
	function setAddStaff() {
		document.SERVICEREQUEST.PROCESSSERVICEREQUEST.value = "ADD STAFF";
		return true;
	}


	function validateLookupField() {
		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length == 5 && document.LOOKUP.SRID1.selectedIndex == "0" && document.LOOKUP.SRID2.selectedIndex == "0") {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}

		if (document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 5 && document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 9) {
			alertuser (document.LOOKUP.SERVICEREQUESTNUMBER.name +  ",  A 9 character SR Number MUST be entered for this lookup!");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}

		if ((document.LOOKUP.SERVICEREQUESTNUMBER.value.length != 5) && (document.LOOKUP.SRID1.selectedIndex > "0" || document.LOOKUP.SRID2.selectedIndex > "0")) {
			alertuser ("BOTH a 9 character SR Number AND a dropdown value can NOT be entered! Choose one or the other.");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}
		
		if (document.LOOKUP.SRID1.selectedIndex > "0" && document.LOOKUP.SRID2.selectedIndex > "0") {
			alertuser ("BOTH dropdown values can NOT be selected! Choose one or the other.");
			document.LOOKUP.SERVICEREQUESTNUMBER.focus();
			return false;
		}
		
	}

	
	function setVoidSR() {
		document.SERVICEREQUEST.PROCESSSERVICEREQUEST.value = "Void SR";
		return true;
	}

	
	function setModSRStaff() {
		document.SERVICEREQUEST.PROCESSSERVICEREQUEST.value = "MODIFY SR & Assign Staff";
		return true;
	}
	
//
</script>
<!--Script ends here -->

</head>

<cfoutput>
<cfif NOT IsDefined('URL.LOOKUPSR') AND #URL.PROCESS# EQ "MODIFY">
	<cfset CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">
<cfelse>
	<cfset CURSORFIELD = "document.SERVICEREQUEST.PROBLEM_SUBCATEGORYID.focus()">
</cfif>
<body onLoad="#CURSORFIELD#">

<cfinclude template="/include/coldfusion/formheader.cfm">

<cfif NOT IsDefined('URL.PROCESS')>
	<cfset URL.PROCESS = "ADD">
</cfif>

<cfif IsDefined('URL.SRID')>
	<cfset FORM.SRID = #URL.SRID#>
</cfif>

<!--- 
************************************************************
* The following code is for all Service Request Processes. *
************************************************************
 --->

<cfquery name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</cfquery>

<cfquery name="ListServiceRequestsCurrFY" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
			SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
			SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID,
			SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID,
			SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
			SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
			SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,
		<CFIF #Client.SecurityFlag# EQ "No">
          	CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
          <CFELSE>
			CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || SR.SRCOMPLETED AS LOOKUPKEY
          </CFIF>
	FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	SR.REQUESTERID = CUST.CUSTOMERID AND
     	<CFIF #Client.SecurityFlag# EQ "No">
			(SR.SRCOMPLETED = 'NO' OR
                SR.SRCOMPLETED = ' Completed?') AND
		</CFIF>
     		SR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> 
	ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
</cfquery>

<cfquery name="ListServiceRequestsPrevFYs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
			SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
			SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID,
			SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID,
			SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
			SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
			SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,
          <CFIF #Client.SecurityFlag# EQ "No">
          	CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
          <CFELSE>
			CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || SR.SRCOMPLETED AS LOOKUPKEY
          </CFIF>
	FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	SR.REQUESTERID = CUST.CUSTOMERID AND
      	<CFIF #Client.SecurityFlag# EQ "No">
			(SR.SRCOMPLETED = 'NO' OR
                SR.SRCOMPLETED = ' Completed?') AND
		</CFIF>
    		SR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC"> 
	ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
</cfquery>

<cfquery name="ListServDeskInitials" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, ACTIVE
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = #Client.CUSTOMERID# AND
			INITIALS IS NOT NULL AND
			ACTIVE = 'YES'
	ORDER BY	FULLNAME
</cfquery>

<cfquery name="ListPriority" datasource="#application.type#SERVICEREQUESTS" blockfactor="4">
	SELECT	PRIORITYID, PRIORITYNAME
	FROM		PRIORITY
	ORDER BY	PRIORITYNAME
</cfquery>

<cfquery name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
	SELECT	GROUPID, GROUPNAME
	FROM		GROUPASSIGNED
	ORDER BY	GROUPNAME
</cfquery>

<cfquery name="ListServiceTypes" datasource="#application.type#SERVICEREQUESTS" blockfactor="9">
	SELECT	SERVICETYPEID, SERVICETYPENAME
	FROM		SERVICETYPES
	ORDER BY	SERVICETYPENAME
</cfquery>

<cfquery name="ListActions" datasource="#application.type#SERVICEREQUESTS" blockfactor="18">
	SELECT	ACTIONID, ACTIONNAME
	FROM		ACTIONS
	ORDER BY	ACTIONNAME
</cfquery>

<cfquery name="ListOperatingSystems" datasource="#application.type#SERVICEREQUESTS" blockfactor="13">
	SELECT	OPSYSID, OPSYSNAME
	FROM		OPSYS
	ORDER BY	OPSYSNAME
</cfquery>

<cfquery name="ListOptions" datasource="#application.type#SERVICEREQUESTS" blockfactor="3">
	SELECT	OPTIONID, OPTIONNAME
	FROM		OPTIONS
	ORDER BY	OPTIONNAME
</cfquery>

<!--- 
***************************************************************
* The following code is the ADD Process for Service Requests. *
***************************************************************
 --->

<cfif URL.PROCESS EQ 'ADD'>

	<cfset client.STAFFLOOP = 'NO'>
	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Add Service Requests</h1></td>
		</tr>
	</table>
	<cfquery name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
				CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#FORM.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.UNITID = UNITS.UNITID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</cfquery>

	<cfif NOT IsDefined ('FORM.ALTERNATE_CONTACTID')>
		<cfset FORM.ALTERNATE_CONTACTID = 0>
	</cfif>

	<cfquery name="LookupAltContacts" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
				CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#FORM.ALTERNATE_CONTACTID#" cfsqltype="CF_SQL_NUMERIC"> AND 
				CUST.UNITID = UNITS.UNITID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES'
		ORDER BY	CUST.FULLNAME
	</cfquery>

	<cfquery name="LookupProblemCategories" datasource="#application.type#SERVICEREQUESTS">
		SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME, CATEGORYLETTER || ' ' || CATEGORYNAME AS CATEGORY
		FROM		PROBLEMCATEGORIES
		WHERE	CATEGORYID = <CFQUERYPARAM value="#FORM.PROBLEM_CATEGORYID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	CATEGORYLETTER
	</cfquery>

	<cfquery name="ListProblemSubCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	PSC.SUBCATEGORYID, PSC.SUBCATEGORYLETTERID, PSC.SUBCATEGORYNAME, 
				PC.CATEGORYLETTER || ' ' || PSC.SUBCATEGORYNAME AS SUBCAT
		FROM		PROBLEMSUBCATEGORIES PSC, PROBLEMCATEGORIES PC
		WHERE	PSC.SUBCATEGORYLETTERID = PC.CATEGORYID AND 
				PSC.SUBCATEGORYLETTERID = #val(FORM.PROBLEM_CATEGORYID)#
		ORDER BY	SUBCAT
	</cfquery>

	<cfif IsDefined('FORM.BARCODENUMBER1') AND #FORM.BARCODENUMBER1# NEQ " INVENTORY BARCODE">
		<cfset FORM.BARCODENUMBER = FORM.BARCODENUMBER1>
	<cfelseif IsDefined('FORM.BARCODENUMBER2') AND #LEN(FORM.BARCODENUMBER2)# GT 7>
		<cfset FORM.BARCODENUMBER = FORM.BARCODENUMBER2>
	</cfif>
	<cfif IsDefined("FORM.BARCODENUMBER")>
		<cfquery name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE,
					HI.OWNINGORGID, HI.MODELNAMEID, MNAMEL.MODELNAME, HI.MODELNUMBERID, MNUML.MODELNUMBER, HI.CUSTOMERID, CUST.FULLNAME,
                         HI.EQUIPMENTLOCATIONID, LOC.LOCATIONNAME, HW.WARRANTYEXPIRATIONDATE AS WARDATE, HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER
			FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, LIBSHAREDDATAMGR.ORGCODES OC, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUML,
					LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
			WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.BARCODENUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
					HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
					HI.OWNINGORGID = OC.ORGCODEID AND
					HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
					HI.MODELNUMBERID = MNUML.MODELNUMBERID AND
					HI.CUSTOMERID = CUST.CUSTOMERID AND
					HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
					HI.BARCODENUMBER = HW.BARCODENUMBER
			ORDER BY	HI.BARCODENUMBER
		</cfquery>
          
          <cfif #LookupHardware.RecordCount# EQ 0>
          	<script language="JavaScript">
				<!-- 
					alert("Barcode was Not Found in Hardware Inventory Records");
				--> 
               </script>
               <cfif #Client.SecurityFlag# EQ "Yes">
				<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/choosehwaddorsradd.cfm" />
               <cfelse>
               	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=ADD" />
				<cfexit>
               </cfif>
          </cfif> 
	</cfif>

	<cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(SRID) AS MAX_ID
		FROM		SERVICEREQUESTS
	</cfquery>
	<cfset FORM.SRID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<cfcookie name="SRID" secure="NO" value="#FORM.SRID#">
	<cfquery name="GetMaxFYSeqNum" datasource="#application.type#SERVICEREQUESTS">
		SELECT	FISCALYEARID, FISCALYEARSEQNUMBER AS MAX_FYSEQNUM
		FROM		SERVICEREQUESTS
		WHERE 	FISCALYEARID = <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	FISCALYEARID, MAX_FYSEQNUM DESC
	</cfquery>
	<cfif GetMaxFYSeqNum.RecordCount EQ 0>
		<cfset FORM.FYSEQNUM = 1>
	<cfelse>
		<cfset FORM.FYSEQNUM =  #val(GetMaxFYSeqNum.MAX_FYSEQNUM + 1)#>
	</cfif>
	<cfset FORM.SERVICEREQUESTNUMBER = #ListCurrentFiscalYear.FISCALYEAR_2DIGIT# & #NumberFormat(FORM.FYSEQNUM,  '0009')#>
	<cfset FORM.FISCALYEARID = #ListCurrentFiscalYear.FISCALYEARID#>
	<cfset FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
	<cfset FORM.CREATIONTIME = #TimeFormat(NOW(),'HH:mm:ss')#>

	<cftransaction action="begin">
	<cfquery name="AddServiceRequestsIDInfo" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	SERVICEREQUESTS (SRID, FISCALYEARID, FISCALYEARSEQNUMBER, SERVICEREQUESTNUMBER, CREATIONDATE, CREATIONTIME, REQUESTERID,
					ALTERNATE_CONTACTID, PROBLEM_CATEGORYID)
		VALUES		(#val(Cookie.SRID)#, #val(FORM.FISCALYEARID)#, #val(FORM.FYSEQNUM)#, '#FORM.SERVICEREQUESTNUMBER#', 
					 TO_DATE('#FORM.CREATIONDATE#', 'DD-MON-YYYY'), TO_DATE('#FORM.CREATIONTIME#', 'HH24:MI:SS'), #val(FORM.REQUESTERID)#,
					 #val(FORM.ALTERNATE_CONTACTID)#, #val(FORM.PROBLEM_CATEGORYID)#)
	</cfquery>
     <cftransaction action = "commit"/>
	</cftransaction>

	<table width="100%" align="center" border="0">
		<tr>
			<th align="center">
				<h4>*Red fields marked with asterisks are required!</h4>
			</th>
		</tr>
		<tr>
			<th align="center">
				SR Key &nbsp; = &nbsp; #FORM.SRID#
			</th>
		</tr>
	</table>
	<br clear="left" />

	<table width="100%" align="LEFT" border="0">
		<tr>
<cfform action="/#application.type#apps/servicerequests/processservicerequestinfo.cfm" method="POST">
			<td align="LEFT" colspan="3">
               	<input type="hidden" name="PROCESSSERVICEREQUEST" value="CANCELADD" />
				<input type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><br><br>
			</td>
</cfform>
		</tr>
	</table>
	
<cfform name="SERVICEREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processservicerequestinfo.cfm" method="POST" enablecab="Yes">
	<br /><br />
	<fieldset>
	<legend>Service Request</legend>
	<table width="100%" align="LEFT">
		<tr>
			<th align="left" width="33%">SR</th>
			<th align="left" width="33%">Creation Date</th>
			<th align="left" width="33%">Creation Time</th>
		</tr>
		<tr>
			<td align="left" width="33%">
				<input type="hidden" name="SERVICEREQUESTNUMBER" value="#FORM.SERVICEREQUESTNUMBER#" />
				#FORM.SERVICEREQUESTNUMBER#
			</td>
			<td align="left" width="33%">
				#DateFormat(FORM.CREATIONDATE, "mm/dd/yyyy")#
			</td>
			<td align="left" width="33%">
				#TimeFormat(FORM.CREATIONTIME, "hh:mm:ss tt")#
			</td>
		</tr>
		<tr>
			<th align="left" width="33%">Requester</th>
			<th align="left" width="33%">R Unit</th>
			<th align="left" width="33%">R Phone</th>
		</tr>
		<tr>
			<td align="left" width="33%">#LookupRequesters.FULLNAME#</td>
			<td align="left" width="33%">#LookupRequesters.UNITNAME#</td>
			<td align="left" width="33%">#LookupRequesters.CAMPUSPHONE#</td>
		</tr>
		<tr>
			<th align="left" width="33%">Service Desk Initials</th>
			<th align="left" width="33%">R Room</th>
			<th align="left" width="33%">R E-Mail</th>
		</tr>
		<tr>
			<input type="hidden" name="SERVICEDESKINITIALSID" value="#ListServDeskInitials.CUSTOMERID#" />
			<td>#ListServDeskInitials.INITIALS#</td>
			<td align="left" width="33%">#LookupRequesters.ROOMNUMBER#</td>
			<td align="left" width="33%"><a href="MAILTO:#LookupRequesters.EMAIL#">#LookupRequesters.EMAIL#</a></td>
		</tr>
		<cfif FORM.ALTERNATE_CONTACTID GT 0>
		<tr>
			<th align="left" width="33%">Alt Contact</th>
			<th align="left" width="33%">AC Unit</th>
			<th align="left" width="33%">AC Phone</th>
		</tr>
		<tr>
			<td align="left" width="33%">#LookupAltContacts.FULLNAME#</td>
			<td align="left" width="33%">#LookupAltContacts.UNITNAME#</td>
			<td align="left" width="33%">#LookupAltContacts.CAMPUSPHONE#</td>
		</tr>
		<tr>
			<th align="left" width="33%">&nbsp;&nbsp;</th>
			<th align="left" width="33%">AC Room</th>
			<th align="left" width="33%">AC E-Mail</th>
		</tr>
		<tr>
			<td align="left" width="33%">&nbsp;&nbsp;</td>
			<td align="left" width="33%">#LookupAltContacts.ROOMNUMBER#</td>
			<td align="left" width="33%"><a href="MAILTO:#LookupAltContacts.EMAIL#">#LookupAltContacts.EMAIL#</a></td>
		</tr>
		</cfif>
		<tr>
			<th align="left" width="33%">Problem Category</th>
			<th align="left" width="33%"><h4><label for="PROBLEM_SUBCATEGORYID">*Sub-Category</label></h4></th>
			<th align="left" width="33%"><h4><label for="SERVICETYPEID">*Service Type</label></h4></th>
		</tr>
		<tr>
			<td>
				#LookupProblemCategories.CATEGORY#
			</td>
			<td>
				<select name="PROBLEM_SUBCATEGORYID" id="PROBLEM_SUBCATEGORYID" tabindex="2">
					<option value="0"> SUB-CATEGORY</option>
					<cfloop query="ListProblemSubCategories">
						<option value="#ListProblemSubCategories.SUBCATEGORYID#"> #ListProblemSubCategories.SUBCAT#</option>
					</cfloop>
				</select>
			</td>
			<td>
				<cfselect name="SERVICETYPEID" id="SERVICETYPEID" size="1" query="ListServiceTypes" value="SERVICETYPEID" display="SERVICETYPENAME" selected="0" required="No" tabindex="3"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left" width="33%"><h4><label for="ACTIONID">*Actions</label></h4></th>
			<th align="left" width="33%"><h4><label for="OPERATINGSYSTEMID">*Operating System</label></h4></th>
		<cfif FORM.PROBLEM_CATEGORYID EQ 10>
			<th align="left" width="33%"><h4><label for="OPTIONID">*Option</label></h4></th>
		<cfelse>
			<th align="left" width="33%">&nbsp;&nbsp;</th>
		</cfif>
		</tr>
		<tr>
			<td align="left" width="33%">
				<cfselect name="ACTIONID" id="ACTIONID" size="1" query="ListActions" value="ACTIONID" display="ACTIONNAME" selected="0" required="No" tabindex="4"></cfselect>
			</td>
			<td align="left" width="33%">
				<cfselect name="OPERATINGSYSTEMID" id="OPERATINGSYSTEMID" size="1" query="ListOperatingSystems" value="OPSYSID" display="OPSYSNAME" selected="0" required="No" tabindex="5"></cfselect>
			</td>
 
		<cfif FORM.PROBLEM_CATEGORYID EQ 10>
			<td align="left" width="33%">
				<cfselect name="OPTIONID" id="OPTIONID" size="1" query="ListOptions" value="OPTIONID" display="OPTIONNAME" selected="2" required="No" tabindex="6"></cfselect>
			</td>
		<cfelse>
			<td>&nbsp;&nbsp;</td>
		</cfif>
		</tr>
	</table>
	</fieldset>
	<br />
	<fieldset>
	<legend>Request Assignment</legend>
	<table width="100%" border="0">
		<tr>
			<th align="left" width="33%"><h4><label for="GROUPASSIGNEDID">*Primary Group Assigned</label></h4></th>
			<th align="left" width="33%">&nbsp;&nbsp;</th>
               <th align="left" width="33%"><h4><label for="PRIORITYID">*Priority</label></h4></th>
		</tr>
		<tr>
			<td align="left" width="33%">
               <cfif FORM.PROBLEM_CATEGORYID EQ 2>
				<cfselect name="GROUPASSIGNEDID" id="GROUPASSIGNEDID" size="1" query="ListGroupAssigned" value="GROUPID" display="GROUPNAME" selected="4" required="No" tabindex="7"></cfselect>
			<cfelseif FORM.PROBLEM_CATEGORYID EQ 9>
				<cfselect name="GROUPASSIGNEDID" id="GROUPASSIGNEDID" size="1" query="ListGroupAssigned" value="GROUPID" display="GROUPNAME" selected="11" required="No" tabindex="7"></cfselect>
			<cfelse>
				<cfselect name="GROUPASSIGNEDID" id="GROUPASSIGNEDID" size="1" query="ListGroupAssigned" value="GROUPID" display="GROUPNAME" selected="0" required="No" tabindex="7"></cfselect>
			</cfif>
			</td>
			<td align="left" width="33%">&nbsp;&nbsp;</td>
			<td align="left" width="33%">
				<cfselect name="PRIORITYID" id="PRIORITYID" size="1" query="ListPriority" value="PRIORITYID" display="PRIORITYNAME" selected="3" required="No" tabindex="9"></cfselect>
			</td>
		</tr>
		<tr>
			<th align="left" colspan="3"><h4><label for="PROBLEM_DESCRIPTION">*Problem Description</label></h4></th>
		</tr>
		<tr>
			<td align="left" valign="TOP" colspan="3">
			<cfif #LookupProblemCategories.CATEGORYID# EQ 2>
				<cfset SESSION.PROBDESCTEXT = ("PURCHASE: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "BUDGET TYPE: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "VENDOR: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "FUNDS: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "JUSTIFICATION: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "RUSH JUST: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "DISTRIBUTION: ")>
				<textarea name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="6" cols="100" wrap="PHYSICAL" required tabindex="10">#SESSION.PROBDESCTEXT#</textarea>
			<cfelseif #LookupProblemCategories.CATEGORYID# EQ 9>
				<cfset SESSION.PROBDESCTEXT = ("WORK NEEDED: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "JUSTIFICATION: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CURRENT JACK/PORT: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "NEW JACK/PORT: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "BARCODE:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "MODEL NAME/NUMBER:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "STATE NUMBER:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "SERIAL NUMBER:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "IP ADDRESS:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "MAC ADDRESS:")>
				<textarea name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="9" cols="100" wrap="PHYSICAL" required tabindex="10">#SESSION.PROBDESCTEXT#</textarea>
               <cfelseif #LookupProblemCategories.CATEGORYID# EQ 15>
				<cfset SESSION.PROBDESCTEXT = ("DATE: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "REASON: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CUSTOMER NAME: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CUSTOMER DEPT/UNIT/STATUS: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CUSTOMER LOC: " & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CUSTOMER PHONE:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CUSTOMER GMAIL:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CUSTOMER MAILLISTS:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CUSTOMER REDID:" & #Chr(13)# & #Chr(10)# & #Chr(13)# & #Chr(10)# & "CUSTOMER ACCOUNTS:")>
				<textarea name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="9" cols="100" wrap="PHYSICAL" required tabindex="10">#SESSION.PROBDESCTEXT#</textarea>
			<cfelse>
				<textarea name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="6" cols="100" wrap="PHYSICAL" required tabindex="10"> </textarea>
			</cfif>
			</td>
		</tr>
	</table>
	</fieldset>
	<br />
	<cfif IsDefined('LookupHardware.RecordCount') AND #LookupHardware.RecordCount# GT 0>
     <fieldset>
	<legend>Associated Equipment</legend>
	<table width="100%" align="LEFT">
		<tr>
			<th align="left" width="33%">Bar Code Number</th>
			<th align="left" width="33%">Equipment Type</th>
			<th align="left" width="33%">State/Found Number</th>
		</tr>
		<tr>
			<input type="hidden" name="BARCODENUMBER" value="#LookupHardware.BARCODENUMBER#" />
			<td align="left" width="33%">#LookupHardware.BARCODENUMBER#</td>
			<td align="left" width="33%">#LookupHardware.EQUIPMENTTYPE#</td>
			<td align="left" width="33%">#LookupHardware.STATEFOUNDNUMBER#</td>
		</tr>
		<tr>
			<th align="left" width="33%">Model</th>
			<th align="left" width="33%">Model Number</th>
			<th align="left" width="33%">Division Number</th>
		</tr>
		<tr>
			<td align="left" width="33%">#LookupHardware.MODELNAME#</td>
			<td align="left" width="33%">#LookupHardware.MODELNUMBER#</td>
			<td align="left" width="33%">#LookupHardware.DIVISIONNUMBER#</td>
		</tr>
 		<tr>
			<th align="left" width="33%">Currently Assigned</th>
			<th align="left" width="33%">Location</th>
			<th align="left" width="33%">Serial</th>
		</tr>
		<tr>
			<td align="left" width="33%">#LookupHardware.FULLNAME#</td>
			<td align="left" width="33%">#LookupHardware.LOCATIONNAME#</td>
			<td align="left" width="33%">#LookupHardware.SERIALNUMBER#</td>
		</tr>
         <tr>
			<th align="left" width="33%">Warranty Expiration Date</th>
               <th align="left" width="33%">&nbsp;&nbsp;</th>
               <th align="left" width="33%">&nbsp;&nbsp;</th>
          </tr>     
		<tr>
			<td align="left" width="33%">#DateFormat(LookupHardware.WARDATE, "mm/dd/yyyy")#</td>
               <td align="left" width="33%">&nbsp;&nbsp;</td>
               <td align="left" width="33%">&nbsp;&nbsp;</td>
          </tr>
     </table>
	</fieldset>
	<br />
	</cfif>
	<fieldset>
    	<legend>Record Processing</legend>
	<table width="100%" border="0">
		<tr>
			<td align="left" width="33%">
               	<input type="hidden" name="PROCESSSERVICEREQUEST" value="ADD" />
               	<input type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="11" />
               </td>
		<cfif #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
               <td align="left" width="33%">
               	<input type="image" src="/images/buttonAddStaff.jpg" value="ADD STAFF" alt="Add Staff" onClick="return setAddStaff();" tabindex="12" />
               </td>
          <cfelse>
          	<td align="left" width="33%">&nbsp;&nbsp;</td>
          </cfif>
               <td align="left" width="33%">&nbsp;&nbsp;</td>

		</tr>
     </table>
	</fieldset>
	<br />

</cfform>

	<table width="100%" align="LEFT">
		<tr>
<cfform action="/#application.type#apps/servicerequests/processservicerequestinfo.cfm" method="POST">
			<td align="LEFT" colspan="3">
               	<input type="hidden" name="PROCESSSERVICEREQUEST" value="CANCELADD" />
				<input type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="13" /><br />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</td>
</cfform>
		</tr>
		<tr>
			<td align="CENTER" colspan="3"><cfinclude template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>

<cfelse>

<!--- 
*****************************************************************************
* The following code is the Look Up Process for Modifying Service Requests. *
*****************************************************************************
 --->

	<cfif NOT IsDefined('URL.LOOKUPSR')>
		<table width="100%" align="center" border="3">
			<tr align="center">
				<td align="center"><h1>Modify an Existing SR Lookup</h1></td>
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
<cfform name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPSR=FOUND" method="POST">
			<tr>
				<th align="left" width="30%"><h4><label for="SERVICEREQUESTNUMBER">*SR</label></h4></th>
				<td align="left" width="70%">
					<cfinput type="Text" name="SERVICEREQUESTNUMBER" id="SERVICEREQUESTNUMBER" value="#ListCurrentFiscalYear.FISCALYEAR_2DIGIT#" align="LEFT" required="No" size="9" maxlength="9" tabindex="2">
				</td>
			</tr>
			<tr>
				<th align="left" width="30%"><h4><label for="SRID1">*Or Requester/SR For Current Fiscal Year & CFY+1:</label></h4></th>
				<td align="left" width="70%">
					<cfselect name="SRID1" id="SRID1" size="1" required="No" tabindex="3">
						<cfif #Client.SecurityFlag# EQ "No">
                                   <option value="0">CUSTOMER - Select SR </option>
                              <cfelse>
                                   <option value="0">CUSTOMER - Select SR - Completed?</option>
                              </cfif>
                              <cfloop query="ListServiceRequestsCurrFY">
                              	<option value="#SRID#">#LOOKUPKEY#</option>
                              </cfloop>  
                         </cfselect>
				</td>
			</tr>
               <tr>
				<th align="left" width="30%"><h4><label for="SRID2">*Or Requester/SR For Previous Fiscal Years:</label></h4></th>
				<td align="left" width="70%">
					<cfselect name="SRID2" id="SRID2" size="1" query="ListServiceRequestsPrevFYs" value="SRID" display="LOOKUPKEY" required="No" tabindex="4"></cfselect>
				</td>
			</tr>
			<tr>
				<td align="left" width="33%">&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td align="left" width="33%">
                    	<input type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="5" />
                    </td>
			</tr>
</cfform>
			<tr>

<cfform action="#SESSION.RETURNPGM#" method="POST">
		<td align="LEFT" colspan="2">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
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
******************************************************************
* The following code is the Modify Process for Service Requests. *
******************************************************************
 --->

		<cfif IsDefined('FORM.SRID1') AND IsDefined('FORM.SRID2')>
			<cfif FORM.SRID1 GT 0>
                    <cfset FORM.SRID = #FORM.SRID1#>
               <cfelse>
                    <cfset FORM.SRID = #FORM.SRID2#>
               </cfif>
          </cfif>

		<cfif IsDefined('FORM.SRID')>
			<cfcookie name="SRID" secure="NO" value="#FORM.SRID#">
		</cfif>
		<cfif IsDefined("URL.CONTACTSPROBLEMCHANGED")>
			<cfquery name="MODIFYServiceRequests" datasource="#application.type#SERVICEREQUESTS">
				UPDATE	SERVICEREQUESTS
				SET		SERVICEREQUESTS.REQUESTERID = #val(FORM.REQUESTERID)#,
						SERVICEREQUESTS.ALTERNATE_CONTACTID = #val(FORM.ALTERNATE_CONTACTID)#,
						SERVICEREQUESTS.PROBLEM_CATEGORYID = #val(FORM.PROBLEM_CATEGORYID)#
				WHERE	(SERVICEREQUESTS.SRID = #val(cookie.SRID)#)
			</cfquery>
			<cfset FORM.SRID = #cookie.SRID#>
               
               <cfif IsDefined('FORM.BARCODENUMBER1') AND #FORM.BARCODENUMBER1# NEQ " INVENTORY BARCODE">
				<cfset FORM.BARCODENUMBER = FORM.BARCODENUMBER1>
               <cfelseif IsDefined('FORM.BARCODENUMBER2') AND #LEN(FORM.BARCODENUMBER2)# GT 7>
                    <cfset FORM.BARCODENUMBER = FORM.BARCODENUMBER2>
               <cfelse>
               	<cfset FORM.BARCODENUMBER = "">
               </cfif>
               
			<cfif FORM.BARCODENUMBER IS NOT "">
				<cfquery name="GetServiceRequestNumber" datasource="#application.type#SERVICEREQUESTS">
					SELECT	SERVICEREQUESTNUMBER
					FROM		SERVICEREQUESTS
					WHERE 	SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_NUMERIC">
				</cfquery>
				
				<cfquery name="GetSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
					SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
					FROM		SREQUIPLOOKUP
					WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#GetServiceRequestNumber.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
				</cfquery>

				<cfif GetSREquipLookup.RecordCount EQ 0 >

					<cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
						SELECT	MAX(SREQUIPID) AS MAX_ID
						FROM		SREQUIPLOOKUP
					</cfquery>
					<cfset FORM.SREQUIPID = #val(GetMaxUniqueID.MAX_ID+1)#>
					<cfquery name="AddSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
						INSERT INTO	SREQUIPLOOKUP (SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE)
						VALUES		(#val(FORM.SREQUIPID)#, '#GetServiceRequestNumber.SERVICEREQUESTNUMBER#', '#FORM.BARCODENUMBER#')
					</cfquery>

                    <cfelse>

                    	<cfquery name="ModifySREquipLookup" datasource="#application.type#SERVICEREQUESTS">
						UPDATE	SREQUIPLOOKUP 
						SET		EQUIPMENTBARCODE = '#FORM.BARCODENUMBER#'
						WHERE	SREQUIPLOOKUP.SERVICEREQUESTNUMBER = '#GetServiceRequestNumber.SERVICEREQUESTNUMBER#'
					</cfquery>

				</cfif>
			</cfif>
		</cfif>

		<cfquery name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SRID, FISCALYEARID, FISCALYEARSEQNUMBER, SERVICEREQUESTNUMBER, TO_CHAR(CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE, 
					TO_CHAR(CREATIONTIME, 'HH:MI:SS') AS CREATIONTIME, SERVICEDESKINITIALSID, REQUESTERID, ALTERNATE_CONTACTID,
					PROBLEM_CATEGORYID, PROBLEM_SUBCATEGORYID, PRIORITYID, ASSIGN_PRIORITY, GROUPASSIGNEDID, SERVICETYPEID, ACTIONID, OPTIONID,
					OPERATINGSYSTEMID, PROBLEM_DESCRIPTION, SRCOMPLETED, TO_CHAR(SRCOMPLETEDDATE, 'MM/DD/YYYY') AS SRCOMPLETEDDATE 
			FROM		SERVICEREQUESTS
			WHERE	SRID > 0 AND 
				<CFIF IsDefined('FORM.SERVICEREQUESTNUMBER') AND LEN(#FORM.SERVICEREQUESTNUMBER#) GT 5>
					SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#FORM.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
				<CFELSEIF #FORM.SRID# GT 0>
					SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
				</CFIF>
					FISCALYEARID > 0
			ORDER BY	SRID
		</cfquery>
          
          <cfcookie name="SRID" secure="NO" value="#GetServiceRequests.SRID#">
		
		<cfquery name="GetRequesters" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
					CUST.EMAIL, CUST.ACTIVE
			FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC"> AND
					CUST.UNITID = UNITS.UNITID AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
					CUST.ACTIVE = 'YES'
			ORDER BY	CUST.FULLNAME
		</cfquery>

		<cfquery name="GetAltContacts" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, UNITS.UNITNAME, CUST.CAMPUSPHONE, LOC.ROOMNUMBER,
					CUST.EMAIL, CUST.ACTIVE
			FROM		CUSTOMERS CUST, UNITS, FACILITIESMGR.LOCATIONS LOC
			WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.ALTERNATE_CONTACTID#" cfsqltype="CF_SQL_NUMERIC"> AND 
					CUST.UNITID = UNITS.UNITID AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
					CUST.ACTIVE = 'YES'
			ORDER BY	CUST.FULLNAME
		</cfquery>

		<cfquery name="GetProblemCategories" datasource="#application.type#SERVICEREQUESTS">
			SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME, CATEGORYLETTER || ' ' || CATEGORYNAME AS CATEGORY
			FROM		PROBLEMCATEGORIES
			WHERE	CATEGORYID = <CFQUERYPARAM value="#GetServiceRequests.PROBLEM_CATEGORYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CATEGORYLETTER
		</cfquery>

		<cfquery name="GetProblemSubCategories" datasource="#application.type#SERVICEREQUESTS">
			SELECT	PSC.SUBCATEGORYID, PSC.SUBCATEGORYLETTERID, PSC.SUBCATEGORYNAME, 
					PC.CATEGORYLETTER || ' ' || PSC.SUBCATEGORYNAME AS SUBCAT
			FROM		PROBLEMSUBCATEGORIES PSC, PROBLEMCATEGORIES PC
			WHERE	(PSC.SUBCATEGORYID = 0 OR 
               		PSC.SUBCATEGORYLETTERID = <CFQUERYPARAM value="#GetServiceRequests.PROBLEM_CATEGORYID#" cfsqltype="CF_SQL_NUMERIC">) AND
                         (PSC.SUBCATEGORYLETTERID = PC.CATEGORYID)		
			ORDER BY	SUBCAT
		</cfquery>

		<cfquery name="GetServDeskInitials" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, ACTIVE
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#GetServiceRequests.SERVICEDESKINITIALSID#" cfsqltype="CF_SQL_NUMERIC"> AND
					INITIALS IS NOT NULL AND
					ACTIVE = 'YES'
			ORDER BY	FULLNAME
		</cfquery>

		<cfquery name="GetSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
			FROM		SREQUIPLOOKUP
			WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#GetServiceRequests.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>
		
		<cfif GetSREquipLookup.RecordCount GT 0>
			<cfquery name="GetHardware" datasource="#application.type#HARDWARE">
				SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTTYPEID, 
                    		EQT.EQUIPMENTTYPE, HI.OWNINGORGID, HI.MODELNAMEID, MNAMEL.MODELNAME, HI.MODELNUMBERID, MNUML.MODELNUMBER, HI.CUSTOMERID, CUST.FULLNAME, 
						HI.EQUIPMENTLOCATIONID, LOC.LOCATIONNAME, HW.WARRANTYEXPIRATIONDATE AS WARDATE, HI.REQUISITIONNUMBER, HI.PURCHASEORDERNUMBER
				FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, LIBSHAREDDATAMGR.ORGCODES OC, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUML,
						LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
				WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#GetSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
						HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND
						HI.OWNINGORGID = OC.ORGCODEID AND
						HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
						HI.MODELNUMBERID = MNUML.MODELNUMBERID AND
						HI.CUSTOMERID = CUST.CUSTOMERID AND
						HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
						HI.BARCODENUMBER = HW.BARCODENUMBER
				ORDER BY	HI.BARCODENUMBER
			</cfquery>
               <cfif #GetHardware.RecordCount# EQ 0>
				<script language="JavaScript">
                    <!-- 
                         alert("Barcode was Not Found in Hardware Inventory Records");
                    --> 
                    </script>
                    
				<cfquery name="DeleteSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
					DELETE FROM	SREQUIPLOOKUP 
					WHERE		SERVICEREQUESTNUMBER = '#GetSREquipLookup.SERVICEREQUESTNUMBER#'
				</cfquery>
                    
                    <cfset FORM.BARCODENUMBER = "">                 
               <cfelse>
               	<cfset FORM.BARCODENUMBER = #GetHardware.BARCODENUMBER#>    
               </cfif> 
          <cfelse>
			<cfset FORM.SERVICEREQUESTNUMBER = "">
               <cfset FORM.BARCODENUMBER = "">
		</cfif>

		<table width="100%" align="center" border="3">
			<tr align="center">
				<td  align="center"><h1>Modify Service Requests</h1></td>
			</tr>
		</table>

		<table width="100%" align="center" border="0">
			<tr>
				<th align="center"><h4>*Red fields marked with asterisks are required!</h4></th>
			</tr>
			<tr>
				<th align="center">SR Key &nbsp; = &nbsp; #Cookie.SRID#</th>
			</tr>
		</table>

		<table width="100%" align="left" border="0">
			<tr>
               	<td align="left" width="33%">
<cfform action="/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</cfform>
				</td>
				<td align="left" width="33%">&nbsp;&nbsp;</td>
                    <td align="left" width="33%">
<cfform action="/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=#URL.PROCESS#&CONTACTSPROBLEMCHANGED=YES&REQUESTER=#GetRequesters.CUSTOMERID#&ALTCONTACT=#GetAltContacts.CUSTOMERID#&PROBCAT=#GetServiceRequests.PROBLEM_CATEGORYID#&BARCODE=#FORM.BARCODENUMBER#" method="POST">
					<input type="image" src="/images/buttonEdit_ContactCatHW.jpg" value="Edit Contact/Category/Hardware" alt="SR Change Contacts, Problem Category, and Hardware" tabindex="2" /><br><br>
</cfform>
				</td>
			</tr>
     </table>
     
	<fieldset>
	<legend>Service Request</legend>
<cfform name="SERVICEREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processservicerequestinfo.cfm" method="POST" enablecab="Yes">
	<table width="100%" align="LEFT">
			<tr>
				<th align="left" width="33%">SR</th>
				<th align="left" width="33%">Creation Date</th>
				<th align="left" width="33%">Creation Time</th>
			</tr>
			<tr>
				<td align="left" width="33%">#GetServiceRequests.SERVICEREQUESTNUMBER#</td>
				<input type="hidden" name="SERVICEREQUESTNUMBER" value="#GetServiceRequests.SERVICEREQUESTNUMBER#" />
				<cfcookie name="SRID" secure="NO" value="#GetServiceRequests.SRID#">
				<td align="left" width="33%">#DateFormat(GetServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</td>
				<td align="left" width="33%">#TimeFormat(GetServiceRequests.CREATIONTIME, "hh:mm:ss tt")#</td>
			</tr>
			<tr>
				<th align="left" width="33%">Requester</th>
				<th align="left" width="33%">R Unit</th>
				<th align="left" width="33%">R Phone</th>
			</tr>
			<tr>
				<td align="left" width="33%">#GetRequesters.FULLNAME#</td>
				<td align="left" width="33%">#GetRequesters.UNITNAME#</td>
				<td align="left" width="33%">#GetRequesters.CAMPUSPHONE#</td>
			</tr>
			<tr>
				<th align="left" width="33%">Service Desk Initials</th>
				<th align="left" width="33%">R Room</th>
				<th align="left" width="33%">R E-Mail</th>
			</tr>
			<tr>
				<input type="hidden" name="SERVICEDESKINITIALSID" value="#GetServiceRequests.SERVICEDESKINITIALSID#" />
				<td align="left" width="33%">#GetServDeskInitials.INITIALS#</td>
				<td align="left" width="33%">#GetRequesters.ROOMNUMBER#</td>
				<td align="left" width="33%"><a href="MAILTO:#GetRequesters.EMAIL#">#GetRequesters.EMAIL#</a></td>
			</tr>
		<cfif GetServiceRequests.ALTERNATE_CONTACTID GT 0>
			<tr>
				<th align="left" width="33%">Alt Contact</th>
				<th align="left" width="33%">AC Unit</th>
				<th align="left" width="33%">AC Phone</th>
			</tr>
			<tr>
				<td align="left" width="33%">#GetAltContacts.FULLNAME#</td>
				<td align="left" width="33%">#GetAltContacts.UNITNAME#</td>
				<td align="left" width="33%">#GetAltContacts.CAMPUSPHONE#</td>
			</tr>
			<tr>
				<th align="left" width="33%">&nbsp;&nbsp;</th>
				<th align="left" width="33%">AC Room</th>
				<th align="left" width="33%">AC E-Mail</th>
			</tr>
			<tr>
				<td align="left" width="33%">&nbsp;&nbsp;</td>
				<td align="left" width="33%">#GetAltContacts.ROOMNUMBER#</td>
				<td align="left" width="33%"><a href="MAILTO:#GetAltContacts.EMAIL#">#GetAltContacts.EMAIL#</a></td>
			</tr>
		</cfif>
			<tr>
				<th align="left" width="33%">Problem Category</th>
				<th align="left" width="33%"><h4><label for="PROBLEM_SUBCATEGORYID">*Sub-Category</label></h4></th>
				<th align="left" width="33%"><h4><label for="SERVICETYPEID">*Service Type</label></h4></th>
			</tr>
			<tr>
				<td align="left" width="33%">#GetProblemCategories.CATEGORY#</td>
				<td>
					<cfselect name="PROBLEM_SUBCATEGORYID" id="PROBLEM_SUBCATEGORYID" size="1" query="GetProblemSubCategories" value="SUBCATEGORYID" display="SUBCAT" selected="#GetServiceRequests.PROBLEM_SUBCATEGORYID#" required="No" tabindex="3"></cfselect>
				</td>
				<td align="left" width="33%">
					<cfselect name="SERVICETYPEID" id="SERVICETYPEID" size="1" query="ListServiceTypes" value="SERVICETYPEID" display="SERVICETYPENAME" selected="#GetServiceRequests.SERVICETYPEID#" required="No" tabindex="4"></cfselect>
				</td>
			</tr>
			<tr>
				<th align="left" width="33%"><h4><label for="ACTIONID">*Actions</label></h4></th>
				<th align="left" width="33%"><h4><label for="OPERATINGSYSTEMID">*Operating System</label></h4></th>

			<cfif #GetServiceRequests.PROBLEM_CATEGORYID# EQ 10>
				<th align="left" width="33%"><h4><label for="OPTIONID">*Option</label></h4></th>
			<cfelse>
				<th align="left" width="33%">&nbsp;&nbsp;</th>
			</cfif>
			</tr>
			<tr>
				<td align="left" width="33%">
					<cfselect name="ACTIONID" id="ACTIONID" size="1" query="ListActions" value="ACTIONID" display="ACTIONNAME" selected="#GetServiceRequests.ACTIONID#" required="No" tabindex="5"></cfselect>
				</td>
				<td align="left" width="33%">
					<cfselect name="OPERATINGSYSTEMID" id="OPERATINGSYSTEMID" size="1" query="ListOperatingSystems" value="OPSYSID" display="OPSYSNAME" selected="#GetServiceRequests.OPERATINGSYSTEMID#" required="No" tabindex="6"></cfselect>
				</td>

			<cfif #GetServiceRequests.PROBLEM_CATEGORYID# EQ 10>
                    <td>
                         <cfselect name="OPTIONID" id="OPTIONID" size="1" query="ListOptions" value="OPTIONID" display="OPTIONNAME" selected="#GetServiceRequests.OPTIONID#" required="No" tabindex="7"></cfselect>
                    </td>
			<cfelse>
				<td>&nbsp;&nbsp;</td>
			</cfif>
			</tr>
		<cfif (#Client.SecurityFlag# EQ "Yes") AND (#GetServiceRequests.SRCOMPLETED# EQ "YES" OR #GetServiceRequests.SRCOMPLETED# EQ "VOIDED")>
          	<tr>
				<th align="left" width="33%"><label for="SRCOMPLETED"><font color="MAGENTA"> SR Completed?</font></label></th>
                    <th align="left" width="33%"> SR Completed Date</th>
                    <th align="left" width="33%">&nbsp;&nbsp;</th>
			</tr>
               <tr>
               	<td align="left" width="33%" valign="top">
                    	<input type="hidden" name="SRCOMPLETERESET" value="#GetServiceRequests.SRCOMPLETED#" />
					<cfselect name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="8">
					<cfif #GetServiceRequests.SRCOMPLETED# EQ "YES" OR #GetServiceRequests.SRCOMPLETED# EQ "VOIDED">
						<option value="#GetServiceRequests.SRCOMPLETED#">#GetServiceRequests.SRCOMPLETED#</option>
					</cfif>
						<option value="NO">NO</option>
						<option value="YES">YES</option>
						<option value="VOIDED">VOIDED</option>
					</cfselect>
				</td>
                    <td align="left" width="33%">#DateFormat(GetServiceRequests.SRCOMPLETEDDATE, "mm/dd/yyyy")#</td>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
			</tr>
		</cfif>
          </table>
          </FIELDSET>
          <br />
          <fieldset>
          <legend>Request Assignment</legend>
          <table width="100%" border="0">
			<tr>
				<th align="left" width="33%"><h4><label for="GROUPASSIGNEDID">*Primary Group Assigned</label></h4></th>
				<th align="left" width="33%"><h4><label for="PRIORITYID">*Priority</label></h4></th>
                    <th align="left" width="33%"><label for="ASSIGN_PRIORITY">ASSIGN-P</label></th>
				
			</tr>
			<tr>
				<td align="left" width="33%">
					<cfselect name="GROUPASSIGNEDID" id="GROUPASSIGNEDID" size="1" query="ListGroupAssigned" value="GROUPID" display="GROUPNAME" selected="#GetServiceRequests.GROUPASSIGNEDID#" required="No" tabindex="9"></cfselect>
				</td>
				<td align="left" width="33%">
					<cfselect name="PRIORITYID" id="PRIORITYID" size="1" query="ListPriority" value="PRIORITYID" display="PRIORITYNAME" selected="#GetServiceRequests.PRIORITYID#" required="No" tabindex="10"></cfselect>
				</td>
				<td align="left" width="33%">
                         <cfselect name="ASSIGN_PRIORITY" id="ASSIGN_PRIORITY" size="1" selected="#GetServiceRequests.ASSIGN_PRIORITY#" required="No" tabindex="11">
                              <option selected value="#GetServiceRequests.ASSIGN_PRIORITY#">#GetServiceRequests.ASSIGN_PRIORITY#</option>
                              <cfloop index="Counter" from=1 to=20>
                                   <option value=#Counter#>#Counter#</option>
                              </cfloop>
                         </cfselect>
                    </td>
			</tr>
			<tr>
				<th align="left" colspan="3"><label for="PROBLEM_DESCRIPTION">Problem Description</label></th>
			</tr>
			<tr>
				<td align="left" valign="TOP" colspan="3">
					<textarea name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="6" cols="100" wrap="PHYSICAL" tabindex="12">#GetServiceRequests.PROBLEM_DESCRIPTION#</textarea>
				</td>
			</tr>
 
          </table>
          </fieldset>
          <br />
	<cfif IsDefined('GetHardware.RecordCount') AND #GetHardware.RecordCount# GT 0>
          <fieldset>
          <legend>Associated Equipment</legend>
          <table width="100%" align="LEFT">
			<tr>
				<th align="left" width="33%">Bar Code Number</th>
				<th align="left" width="33%">Equipment Type</th>
				<th align="left" width="33%">State/Found Number</th>
			</tr>
			<tr>
				<input type="hidden" name="BARCODENUMBER" value="#GetHardware.BARCODENUMBER#" />
				<td align="left" width="33%">#GetHardware.BARCODENUMBER#</td>
				<td align="left" width="33%">#GetHardware.EQUIPMENTTYPE#</td>
				<td align="left" width="33%">#GetHardware.STATEFOUNDNUMBER#</td>
			</tr>
			<tr>
                    <th align="left" width="33%">Model</th>
                    <th align="left" width="33%">Model Number</th>
                    <th align="left" width="33%">Division Number</th>
               </tr>
               <tr>
                    <td align="left" width="33%">#GetHardware.MODELNAME#</td>
                    <td align="left" width="33%">#GetHardware.MODELNUMBER#</td>
                    <td align="left" width="33%">#GetHardware.DIVISIONNUMBER#</td>
               </tr>
               <tr>
                    <th align="left" width="33%">Currently Assigned</th>
                    <th align="left" width="33%">Location</th>
                    <th align="left" width="33%">Serial</th>
               </tr>
               <tr>
                    <td align="left" width="33%">#GetHardware.FULLNAME#</td>
                    <td align="left" width="33%">#GetHardware.LOCATIONNAME#</td>
                    <td align="left" width="33%">#GetHardware.SERIALNUMBER#</td>
               </tr>
              <tr>
                    <th align="left" width="33%">Warranty Expiration Date</th>
                    <th align="left" width="33%">&nbsp;&nbsp;</th>
                    <th align="left" width="33%">&nbsp;&nbsp;</th>
               </tr>     
               <tr>
                    <td align="left" width="33%">#DateFormat(GetHardware.WARDATE, "mm/dd/yyyy")#</td>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
               </tr>
          </table>
          </fieldset>
          <br />
	<cfelse>
		<cfset FORM.BARCODENUMBER = "">
	</cfif>
     
          <fieldset>
          <legend>Record Processing</legend>
          <table width="100%" border="0">
			<tr>
				<td align="left" width="33%">
                    	<input type="hidden" name="PROCESSSERVICEREQUEST" value="MODIFY SR" />
                    	<input type="image" src="/images/buttonModSR.jpg" value="MODIFY SR" alt="Modify SR" tabindex="13" />
                    </td>
                    <td align="left" width="33%">
					<input type="image" src="/images/buttonAddNextGrp.jpg" name="AddNextGroup" value="Add Next Group" alt="Add Next Group" onClick="window.open('/#application.type#apps/servicerequests/srnextrefergroupchoice.cfm?SRID=#Cookie.SRID#&PROCESS=ADD&STAFFLOOP=YES',
                                                    'Add Next Group','alwaysRaised=yes,dependent=no,width=800,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                                    tabindex="14" />
                    </td>
               <cfif #Client.SecurityFlag# EQ "Yes">
                    <td align="left" width="33%">
                    	<input type="image" src="/images/buttonVoidSR.jpg" value="Void SR" alt="Void SR" onClick="return setVoidSR();" tabindex="15" />
                    </td>
                <cfelse>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
               </cfif>
			</tr>
			<tr>
			<cfif #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
				<td align="left" width="33%">
                    	<input type="image" src="/images/buttonModSRStaff.jpg" value="MODIFY SR & Assign Staff" alt="Modify SR & Assign Staff" onClick="return setModSRStaff();" tabindex="16" />
                    </td>
				<cfif #GetServiceRequests.PROBLEM_CATEGORYID# EQ 2>
				<td align="left" width="33%">
					<input type="image" src="/images/buttonAddPurch.jpg" value="ADD PURCH" alt="Add Purchase Requisition" 
					onClick="window.open('/#application.type#apps/servicerequests/lookupsrpurchreqinfo.cfm?PROCESS=ADD&SRNUMBER=#GetServiceRequests.SERVICEREQUESTNUMBER#',
					 'Look Up Purchase Requisition','alwaysRaised=yes,dependent=no,width=1200,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
					 tabindex="17" />
				</td>
				<cfelse>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
				</cfif>
               <cfelse>
               	<td align="left" width="33%">&nbsp;&nbsp;</td>
                    <td align="left" width="33%">&nbsp;&nbsp;</td>
               </cfif>

</cfform>
          
<cfform action="/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=#URL.PROCESS#&CONTACTSPROBLEMCHANGED=YES&REQUESTER=#GetRequesters.CUSTOMERID#&ALTCONTACT=#GetAltContacts.CUSTOMERID#&PROBCAT=#GetServiceRequests.PROBLEM_CATEGORYID#&BARCODE=#FORM.BARCODENUMBER#" method="POST">
				<td align="left" width="33%">
                    	<input type="image" src="/images/buttonEdit_ContactCatHW.jpg" value="Edit Contact/Category/Hardware" alt="SR Change Contacts, Problem Category, and Hardware" tabindex="18" />
                    </td>
			
</cfform>
			</TR>
		</TABLE>
		</FIELDSET>
          <br />
          <table width="100%" align="LEFT">
			<tr>
<cfform action="/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<td align="left" colspan="2">
					<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="19" /><br />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</td>
</cfform>
				<td>&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td align="CENTER" colspan="3"><cfinclude template="/include/coldfusion/footer.cfm"></td>
			</tr>
		</table>
	</cfif>
</cfif>

</body>
</cfoutput>
</html>