<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workorderapproval.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/28/2011 --->
<!--- Date in Production: 07/28/2011 --->
<!--- Module: Facilities - Work Order Request Approval --->
<!-- Last modified by John R. Pastori on 07/28/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/workorderapproval.cfm">
<CFSET CONTENT_UPDATED = "July 28, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Order Request Approval</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
		if (document.WORKORDER.ACCOUNTNUMBER2 != null && document.WORKORDER.ACCOUNTNUMBER2.value == "0") {
			alertuser (document.WORKORDER.ACCOUNTNUMBER2.name +  ", An Account Number MUST be entered!");
			document.WORKORDER.ACCOUNTNUMBER2.focus();
			return false;
		}

		if (document.WORKORDER.ACCOUNTNUMBER3 != null && document.WORKORDER.ACCOUNTNUMBER3.value == "0") {
			alertuser (document.WORKORDER.ACCOUNTNUMBER3.name +  ", An Account Number MUST be selected!");
			document.WORKORDER.ACCOUNTNUMBER3.focus();
			return false;
		}

		if ((document.WORKORDER.APPROVEDBYSUPID.selectedIndex > "0" && document.WORKORDER.SUPAPPROVALDATE != null) 
		 && (document.WORKORDER.SUPAPPROVALDATE.value == "" || !document.WORKORDER.SUPAPPROVALDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKORDER.SUPAPPROVALDATE.name +  ", The Unit Head Approval Date MUST be entered in the format MM/DD/YYYY when the Unit Head has approved the Request!");
			document.WORKORDER.SUPAPPROVALDATE.focus();
			return false;
		}

		if ((document.WORKORDER.APPROVEDBYMGMTID != null && document.WORKORDER.APPROVEDBYMGMTID.selectedIndex > "0"
		 && document.WORKORDER.MGMTAPPROVALDATE != null) && (document.WORKORDER.MGMTAPPROVALDATE.value == "" || document.WORKORDER.MGMTAPPROVALDATE.value == " " 
		 || !document.WORKORDER.MGMTAPPROVALDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKORDER.MGMTAPPROVALDATE.name +  ", The Management Approval Date MUST be entered in the format MM/DD/YYYY when Management has approved the Request!");
			document.WORKORDER.MGMTAPPROVALDATE.focus();
			return false;
		}
	
		if (document.WORKORDER.STARTDATE.value == "" || document.WORKORDER.STARTDATE.value == " " 
		 || !document.WORKORDER.STARTDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.WORKORDER.STARTDATE.name +  ", The Desired Start Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKORDER.STARTDATE.focus();
			return false;
		}

		if (document.WORKORDER.COMPLETIONDATE.value == "" || document.WORKORDER.COMPLETIONDATE.value == " " 
		 || !document.WORKORDER.COMPLETIONDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.WORKORDER.COMPLETIONDATE.name +  ", The Desired Completion Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKORDER.COMPLETIONDATE.focus();
			return false;
		}

	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF (IsDefined('URL.PROCESS') AND  URL.PROCESS EQ 'CUSTOMER') OR (IsDefined('URL.LOOKUPWORKORDER') AND URL.LOOKUPWORKORDER EQ 'FOUND')>
	<CFSET CURSORFIELD = "document.WORKORDER.REQUESTSTATUSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.LOOKUP.WORKORDERNUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF NOT IsDefined ('session.WORKORDERIDArray')>
	<CFSET session.WORKORDERIDArray = ArrayNew(1)>
</CFIF>
<CFIF IsDefined('URL.APPROVAL') AND #URL.APPROVAL# EQ "SUP">
	<CFSET session.FIELDNAME = "WO.SUPEMAILID">
	<CFSET session.APPROVAL = "SUP">
	<CFSET session.STATUS = "6">
<CFELSE>
	<CFSET session.FIELDNAME = "WO.MGMTEMAILID">
	<CFSET session.APPROVAL = "MGMT">
	<CFSET session.STATUS = "1">
</CFIF>

<CFIF ((IsDefined('URL.PROCESS') AND URL.PROCESS EQ 'APPROVAL') OR (session.PROCESS EQ 'APPROVAL'))>
<!--- 
****************************************************************************************************************
* The following code is the Work Order Approval Generation Process from the Facilities Application Index Page. *
****************************************************************************************************************
 --->
	<CFINCLUDE template = "lookupworkorderinfo.cfm">
<CFELSEIF FIND('/forms/', CGI.HTTP_REFERER, 1) NEQ 0>
	<CFSET session.PROCESS = 'CUSTOMER'>
	<CFSET SCREENTITLE = 'Facilities - Approved Work Order Look Up'>
	<CFSET temp = ArraySet(session.WORKORDERIDArray, 1, 1, 0)>
	<CFSET session.ArrayCounter = 0>
	<CFSET session.WORKORDERSSELECTED = 0>
<!--- 
********************************************************************************************
* The following code is the Work Order Approval Generation Process from Lfolks Forms Page. *
********************************************************************************************
 --->
	
	<CFIF IsDefined ('URL.INITREQ') AND URL.INITREQ EQ "WO">

		<CFQUERY name="LookupApprover" datasource="#application.type#FACILITIES">
			SELECT	WO.WORKORDERID, TO_CHAR(WO.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WO.FISCALYEARID, WO.FISCALYEARSEQNUMBER,
					WO.WORKORDERNUMBER, WO.REQUESTTYPEID, RT.REQUESTTYPENAME, WO.REQUESTSTATUSID, RS.REQUESTSTATUSNAME,
					WO.REQUESTERID, WO.UNITID, WO.LOCATIONID, WO.ACCOUNTNUMBER1, WO.ACCOUNTNUMBER2, WO.ACCOUNTNUMBER3,
					WO.ALTERNATECONTACTID, WO.PROJECTDESCRIPTION, WO.JUSTIFICATIONDESCRIPTION, SUPEMAILID, WO.APPROVEDBYSUPID,
					TO_CHAR(WO.SUPAPPROVALDATE, 'MM/DD/YYYY') AS SUPAPPROVALDATE, WO.MGMTEMAILID, WO.APPROVEDBYMGMTID, 
					TO_CHAR(WO.MGMTAPPROVALDATE, 'MM/DD/YYYY') AS MGMTAPPROVALDATE, TO_CHAR(WO.STARTDATE, 'MM/DD/YYYY') AS STARTDATE,
					TO_CHAR(WO.COMPLETIONDATE, 'MM/DD/YYYY') AS COMPLETIONDATE, WO.URGENCY, WO.KEYREQUEST, WO.MOVEREQUEST, WO.TNSREQUEST
			FROM		WORKORDERS WO, REQUESTTYPES RT, REQUESTSTATUS RS
			WHERE	WO.WORKORDERID > 0 AND
					#session.FIELDNAME# = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
					WO.REQUESTTYPEID = RT.REQUESTTYPEID AND
					WO.REQUESTSTATUSID = RS.REQUESTSTATUSID AND 
					WO.REQUESTSTATUSID = #session.STATUS#
			ORDER BY	#session.FIELDNAME#, RT.REQUESTTYPENAME, WO.WORKORDERNUMBER
		</CFQUERY>
		
		<CFQUERY name="LookupMgmtName" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, CAMPUSPHONE, FAX, FULLNAME, CATEGORYID, UNITID,
					LOCATIONID, DEPTCHAIR, ALLOWEDTOAPPROVE
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>
		
		<CFIF LookupApprover.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records matching your Customer ID were Not Found");
				--> 
			</SCRIPT>
			<CFIF session.PROCESS EQ 'CUSTOMER'>
				<META http-equiv="Refresh" content="1; URL=/forms/index.cfm?logout=No" />
			<CFELSE>
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/index.cfm?logout=No" />
			</CFIF>
			<CFEXIT>
		<CFELSE>
			<CFSET session.MGMTNAME = "#LookupMgmtName.FULLNAME#">
			<CFSET temp = ArraySet(session.WORKORDERIDArray, 1, #LookupApprover.RecordCount#, 0)> 
			<CFSET session.WORKORDERIDArray = ListToArray(#ValueList(LookupApprover.WORKORDERID)#)>
			<CFSET session.ArrayCounter = 1>
			<CFSET session.WORKORDERSSELECTED = #LookupApprover.RecordCount#>
			WORKORDER ID's = #ValueList(LookupApprover.WORKORDERID)#
		</CFIF>
	</CFIF>
</CFIF>
<!--- 
*******************************************************
* The following code is the Work Order Approval Form. *
*******************************************************
 --->
<CFIF session.WORKORDERIDArray[1] EQ 0>
	<CFEXIT>
<CFELSE>
	<CFQUERY name="GetWorkOrders" datasource="#application.type#FACILITIES">
		SELECT	WO.WORKORDERID, TO_CHAR(WO.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WO.FISCALYEARID, WO.FISCALYEARSEQNUMBER,
				WO.WORKORDERNUMBER, WO.REQUESTTYPEID, RT.REQUESTTYPENAME, WO.REQUESTSTATUSID, RS.REQUESTSTATUSNAME,
				WO.REQUESTERID, WO.UNITID, WO.LOCATIONID, WO.ACCOUNTNUMBER1, WO.ACCOUNTNUMBER2, WO.ACCOUNTNUMBER3,
				WO.ALTERNATECONTACTID, WO.PROJECTDESCRIPTION, WO.JUSTIFICATIONDESCRIPTION, WO.SUPEMAILID, WO.APPROVEDBYSUPID, 
				TO_CHAR(WO.SUPAPPROVALDATE, 'MM/DD/YYYY') AS SUPAPPROVALDATE, WO.MGMTEMAILID, WO.APPROVEDBYMGMTID,
				TO_CHAR(WO.MGMTAPPROVALDATE, 'MM/DD/YYYY') AS MGMTAPPROVALDATE, TO_CHAR(WO.STARTDATE, 'MM/DD/YYYY') AS STARTDATE,
				TO_CHAR(WO.COMPLETIONDATE, 'MM/DD/YYYY') AS COMPLETIONDATE, WO.URGENCY, WO.KEYREQUEST, WO.MOVEREQUEST, WO.TNSREQUEST
		FROM		WORKORDERS WO, REQUESTTYPES RT, REQUESTSTATUS RS
		WHERE	WO.WORKORDERID = <CFQUERYPARAM value="#session.WORKORDERIDArray[session.ArrayCounter]#" cfsqltype="CF_SQL_NUMERIC"> AND
				WO.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WO.REQUESTSTATUSID = RS.REQUESTSTATUSID
		ORDER BY	#session.FIELDNAME#, RT.REQUESTTYPENAME, WO.WORKORDERNUMBER
	</CFQUERY>

	<CFQUERY name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, CAMPUSPHONE, FAX, FULLNAME, CATEGORYID, UNITID,
				LOCATIONID, DEPTCHAIR, ALLOWEDTOAPPROVE
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#GetWorkOrders.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA">
		SELECT	UNITS.UNITID, UNITS.UNITNAME, UNITS.CAMPUSMAILCODEID, UNITS.GROUPID, UNITS.DEPARTMENTID,
				UNITS.SUPERVISORID, GROUPS.GROUPID, GROUPS.GROUPNAME, GROUPS.MANAGEMENTID  
		FROM		UNITS, GROUPS
		WHERE	UNITS.UNITID = <CFQUERYPARAM value="#GetWorkOrders.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
				UNITS.GROUPID = GROUPS.GROUPID
		ORDER BY	UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
				LOC.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION, 
				LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LOC.MODIFIEDBYID, LOC.MODIFIEDDATE, LOC.ARCHIVELOCATION
		FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
		WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#GetWorkOrders.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
		ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
	</CFQUERY>
	
	<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		WHERE	(CURRENTFISCALYEAR = 'YES')
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="ListAlternateContacts" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME,
				CUST.CATEGORYID, CUST.UNITID, U.GROUPID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = U.UNITID) OR
				(CUST.UNITID = U.UNITID AND
				U.GROUPID IN (2,3,4,6))
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListSupApprovals" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPEMAIL, CUST.UNITID, U.GROUPID,
				CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = U.UNITID) OR
				(CUST.UNITID = U.UNITID AND
				U.GROUPID IN (2,3,4,6) AND 
				CUST.UNITHEAD = 'YES' AND
				CUST.ALLOWEDTOAPPROVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListMgmtApprovals" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL,  CUST.FULLNAME || '-' || CUST.EMAIL AS MGMTEMAIL, CUST.UNITID, U.GROUPID,
				CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = U.UNITID) OR
				(CUST.UNITID = U.UNITID AND
				U.GROUPID IN (2,3,4,6) AND 
				CUST.DEPTCHAIR = 'YES' AND
				CUST.ALLOWEDTOAPPROVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListRequestStatus" datasource="#application.type#FACILITIES" blockfactor="8">
		SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
		FROM		REQUESTSTATUS
		ORDER BY	REQUESTSTATUSNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<TD align="center"><H1>Facilities - Work Order Request Approval</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align="center"><H5>#session.MGMTNAME# </H5>currently has <H5>#ArrayLen(session.WORKORDERIDArray)#</H5> Facilities Work Order Requests to Approve.</TH>
		</TR>
		<TR>
			<TH align="center">WO Key: &nbsp;&nbsp;<H5>#GetWorkOrders.WORKORDERID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(GetWorkOrders.REQUESTDATE, 'mm/dd/yyyy')#</H5></TH>
		</TR>
	</TABLE>

	<TABLE align="left" width="100%" border="0">
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR />
				<INPUT type="submit" value="Cancel" tabindex="1" />
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD align="left"><H2>WO Request Number:&nbsp;&nbsp;#GetWorkOrders.WORKORDERNUMBER#</H2></TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="WORKORDER" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processworkorderinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" valign ="BOTTOM">
				Request Type
				<CFCOOKIE name="WOID" secure="NO" value="#GetWorkOrders.WORKORDERID#">
				<INPUT type="hidden" name="WORKORDERNUMBER" value="#GetWorkOrders.WORKORDERNUMBER#" />
			</TH>
			<TH align="left" valign ="BOTTOM">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="REQUESTSTATUSID">1. Request Status</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<INPUT type="hidden" name="REQUESTTYPEID" value="#GetWorkOrders.REQUESTTYPEID#" />
				#GetWorkOrders.REQUESTTYPENAME#
			</TD>
			<TD align="left" valign ="TOP">
				<COM>Change Status to "Cancelled" to Cancel this workorder.</COM><BR />
			<CFIF #session.APPROVAL# EQ "SUP">
				<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="1" tabindex="2"></CFSELECT>
			<CFELSE>
				<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="7" tabindex="2"></CFSELECT>
			</CFIF>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM">Requester</TH>
			<TH align="left" valign ="BOTTOM">Unit</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<INPUT type="hidden" name="REQUESTERID" value="#LookupRequesters.CUSTOMERID#" />
				#LookupRequesters.FULLNAME#
			</TD>
			<TD align="left" valign ="TOP">
				#LookupUnits.UNITNAME#
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM">Location</TH>
			<TH align="left" valign ="BOTTOM">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="ALTERNATECONTACTID">2. Alternate Contact</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				#LookupRoomNumbers.ROOMNUMBER#
			</TD>
			<TD align="left" valign ="TOP">
				<COM>(Choose a Contact name, if it is different <BR />from the Requester's name.)</COM><BR />
				<CFSELECT name="ALTERNATECONTACTID" id="ALTERNATECONTACTID" size="1" query="ListAlternateContacts" value="CUSTOMERID" display="FULLNAME" required="No" selected="#GetWorkOrders.ALTERNATECONTACTID#" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	<CFIF #session.APPROVAL# EQ "MGMT">
		<TR>
			<TH align="left" valign ="BOTTOM" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<H4><LABEL for="ACCOUNTNUMBER2">*3. State Account Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP" colspan="2">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<COM>(Type Activity Number and Select an Account.)</COM><BR />
				#GetWorkOrders.ACCOUNTNUMBER1# &nbsp;
				&nbsp;<CFINPUT type="Text" name="ACCOUNTNUMBER2" id="ACCOUNTNUMBER2" value="#GetWorkOrders.ACCOUNTNUMBER2#" align="LEFT" required="No" size="4" maxlength="5" tabindex="4">
				<LABEL for="ACCOUNTNUMBER3" class="LABEL_hidden">State Account Number Part 3</LABEL>
				&nbsp;<CFSELECT name="ACCOUNTNUMBER3" id="ACCOUNTNUMBER3" size="1" required="No" tabindex="5">
				<CFIF #GetWorkOrders.ACCOUNTNUMBER3# EQ 0>
					<OPTION selected value="0"> SELECT AN ACCOUNT</OPTION>
				<CFELSE>
					<OPTION selected value="#GetWorkOrders.ACCOUNTNUMBER3#">#GetWorkOrders.ACCOUNTNUMBER3#</OPTION>
				</CFIF>
					<OPTION value="-66032-1001-1000-1901">-66032-1001-1000-1901</OPTION>
					<OPTION value="-66032-0000-1002-1901">-66032-0000-1002-1901</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	</CFIF>
		<TR>
			<TH align="left" valign ="BOTTOM">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="PROJECTDESCRIPTION">4. Scope Of Work</LABEL></TH>
			<TH align="left" valign ="BOTTOM">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="JUSTIFICATIONDESCRIPTION">5. Justification Description</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<TEXTAREA name="PROJECTDESCRIPTION" id="PROJECTDESCRIPTION" wrap="VIRTUAL" REQUIRED="No"  rows="5" cols="60" tabindex="6">#GetWorkOrders.PROJECTDESCRIPTION#</TEXTAREA><BR />
				<COM>(Scope Of Work is for Physical Plant Requests Only)</COM>
			</TD>
			<TD align="left" valign ="TOP">
				<TEXTAREA name="JUSTIFICATIONDESCRIPTION" id="JUSTIFICATIONDESCRIPTION" wrap="VIRTUAL" REQUIRED="No"  rows="5" cols="60" tabindex="7">#GetWorkOrders.JUSTIFICATIONDESCRIPTION#</TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="APPROVEDBYSUPID">6. Approved By Unit Head</LABEL></TH>
		<CFIF #GetWorkOrders.SUPAPPROVALDATE# EQ "">
			<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<H4><LABEL for="SUPAPPROVALDATE">*7. Unit Head Approval Date</LABEL></H4></TH>
		<CFELSE>
			<TH align="left">Unit Head Approval Date</TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
			<CFIF session.PROCESS EQ 'CUSTOMER'>
				<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="FULLNAME" selected="#val(Client.CUSTOMERID)#" required="No" tabindex="8"></CFSELECT>
			<CFELSEIF #GetWorkOrders.APPROVEDBYSUPID# EQ 0>
				<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="FULLNAME" selected="#LookupUnits.SUPERVISORID#" required="No" tabindex="8"></CFSELECT>
			<CFELSE>
				<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="FULLNAME" selected="#GetWorkOrders.APPROVEDBYSUPID#" required="No" tabindex="8"></CFSELECT>
			</CFIF>
			</TD>
			<TD align="left" valign ="TOP">
			<CFIF #GetWorkOrders.SUPAPPROVALDATE# EQ "">
				<COM>MM/DD/YYYYY </COM><BR>
				<CFINPUT type="Text" name="SUPAPPROVALDATE" id="SUPAPPROVALDATE" value="#DateFormat(NOW(), 'mm/dd/yyyy')#" align="LEFT" required="No" size="10" tabindex="9">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'WORKORDER','controlname': 'SUPAPPROVALDATE'});

				</SCRIPT>
			<CFELSE>
				#DateFormat(GetWorkOrders.SUPAPPROVALDATE, 'mm/dd/yyyy')#
			</CFIF>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="SUPEMAILID">8. Unit Head's E-Mail</LABEL></TH>
			<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="MGMTEMAILID">9. Management's E-Mail</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="SUPEMAILID" id="SUPEMAILID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="SUPEMAIL" selected="#GetWorkOrders.SUPEMAILID#" required="No" tabindex="10"></CFSELECT>
			</TD>
			<TD align="left" valign ="TOP">
			<CFIF #GetWorkOrders.MGMTEMAILID# EQ 0>
				<CFSELECT name="MGMTEMAILID" id="MGMTEMAILID" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="MGMTEMAIL" selected="#LookupUnits.MANAGEMENTID#" required="No" tabindex="11"></CFSELECT>
			<CFELSE>
				<CFSELECT name="MGMTEMAILID" id="MGMTEMAILID" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="MGMTEMAIL" selected="#GetWorkOrders.MGMTEMAILID#" required="No" tabindex="11"></CFSELECT>
			</CFIF>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	<CFIF #session.APPROVAL# EQ "MGMT">
		<TR>
			<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="APPROVEDBYMGMTID">10. Approved By Management</LABEL></TH>
		<CFIF #GetWorkOrders.MGMTAPPROVALDATE# EQ "">
			<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<H4><LABEL for="MGMTAPPROVALDATE">*11. Management Approval Date</LABEL></H4></TH>
		<CFELSE>
			<TH align="left">Management Approval Date</TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
			<CFIF session.PROCESS EQ 'CUSTOMER'>
				<CFSELECT name="APPROVEDBYMGMTID" id="APPROVEDBYMGMTIDD" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="FULLNAME" selected="#val(Client.CUSTOMERID)#" required="No" tabindex="12"></CFSELECT>
			<CFELSEIF #GetWorkOrders.APPROVEDBYMGMTID# EQ 0>
				<CFSELECT name="APPROVEDBYMGMTID" id="APPROVEDBYMGMTID" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="FULLNAME" selected="#LookupUnits.MANAGEMENTID#" required="No" tabindex="12"></CFSELECT>
			<CFELSE>
				<CFSELECT name="APPROVEDBYMGMTID" id="APPROVEDBYMGMTID" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="FULLNAME" selected="#GetWorkOrders.APPROVEDBYMGMTID#" required="No" tabindex="12"></CFSELECT>
			</CFIF>
			</TD>
			<TD align="left" valign ="TOP">
			<CFIF #GetWorkOrders.MGMTAPPROVALDATE# EQ "">
				<COM>MM/DD/YYYYY </COM><BR>
				<CFINPUT type="Text" name="MGMTAPPROVALDATE" id="MGMTAPPROVALDATE" value="" align="LEFT" required="No" size="10" tabindex="13">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'WORKORDER','controlname': 'MGMTAPPROVALDATE'});

				</SCRIPT>
			<CFELSE>
				#DateFormat(GetWorkOrders.MGMTAPPROVALDATE, 'mm/dd/yyyy')#
			</CFIF>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	</CFIF>
		<TR>
			<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="STARTDATE">12. Desired Start Date</LABEL></TH>
			<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="COMPLETIONDATE">13. Desired Completion Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<COM>MM/DD/YYYYY </COM><BR>
				<CFINPUT type="Text" name="STARTDATE" id="STARTDATE" value="#GetWorkOrders.STARTDATE#" align="LEFT" required="No" size="10" tabindex="14">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'WORKORDER','controlname': 'STARTDATE'});

				</SCRIPT>
			</TD>
			<TD align="left" valign ="TOP">
				<COM>MM/DD/YYYYY </COM><BR>
				<CFINPUT type="Text" name="COMPLETIONDATE" id="COMPLETIONDATE" value="#GetWorkOrders.COMPLETIONDATE#" align="LEFT" required="No" size="10" tabindex="15">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'WORKORDER','controlname': 'COMPLETIONDATE'});

				</SCRIPT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<INPUT type="submit" name="ProcessWorkOrders" value="Approve/Cancel Request" tabindex="16" />
			</TD>
		</TR>
</CFFORM>
<CFFORM action="/#application.type#apps/facilities/processworkorderinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TD align="left" colspan="2">
				<BR /><COM>(No change including Modified Date Field.)</COM><BR />
				<INPUT type="submit" name="ProcessWorkOrders" value="Request Next Record" tabindex="17" />
			</TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<BR /><COM>(Please DO NOT use the Browser's Back Button.)</COM><BR />
				<INPUT type="submit" value="Cancel" tabindex="18" />
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>