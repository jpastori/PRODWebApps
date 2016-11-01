 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workorder.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/24/2012 --->
<!--- Date in Production: 01/24/2012 --->
<!--- Module: Add/Modify/Delete Work Order Requests --->
<!-- Last modified by John R. Pastori on 01/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/workorder.cfm">
<CFSET CONTENT_UPDATED = "January 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add WO Request</TITLE>
	<CFELSE>
		<TITLE>Modify WO Request</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
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


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}
	

	function validateReqFields() {
		if (document.WORKORDER.REQUESTTYPEID != null && document.WORKORDER.REQUESTTYPEID.selectedIndex == "0") {
			alertuser (document.WORKORDER.REQUESTTYPEID.name +  ",  A Request Type MUST be selected!");
			document.WORKORDER.REQUESTTYPEID.focus();
			return false;
		}

		if (document.WORKORDER.REQUESTERID.selectedIndex == "0") {
			alertuser (document.WORKORDER.REQUESTERID.name +  ",  A Customer MUST be selected!");
			document.WORKORDER.REQUESTERID.focus();
			return false;
		}

		if (document.WORKORDER.UNITID.selectedIndex == "0") {
			alertuser (document.WORKORDER.UNITID.name +  ",  A Unit Name MUST be selected!");
			document.WORKORDER.UNITID.focus();
			return false;
		}

		if (document.WORKORDER.ACCOUNTNUMBER2 != null && document.WORKORDER.ACCOUNTNUMBER2.value == "0") {
			alertuser (document.WORKORDER.ACCOUNTNUMBER2.name +  ", An Account Number MUST be entered!");
			document.WORKORDER.ACCOUNTNUMBER2.focus();
			return false;
		}

		if ((document.WORKORDER.ACCOUNTNUMBER3 != null) && (document.WORKORDER.ACCOUNTNUMBER3.value == "" || document.WORKORDER.ACCOUNTNUMBER3.selectedIndex == 0 || document.WORKORDER.ACCOUNTNUMBER3.value == "0")) {
			alertuser (document.WORKORDER.ACCOUNTNUMBER3.name +  ", An Account Number MUST be selected!");
			document.WORKORDER.ACCOUNTNUMBER3.focus();
			return false;
		}
		
		if ((document.WORKORDER.INITAPPROVALDATE != null) && (document.WORKORDER.INITAPPROVALDATE.value == "" || document.WORKORDER.INITAPPROVALDATE.value == " " || !document.WORKORDER.INITAPPROVALDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKORDER.INITAPPROVALDATE.name +  ", An Initial Approval Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKORDER.INITAPPROVALDATE.focus();
			return false;
		}

		if ((document.WORKORDER.SUPAPPROVALDATE != null && document.WORKORDER.APPROVEDBYSUPID.selectedIndex > "0") 
		 && (document.WORKORDER.SUPAPPROVALDATE.value == "" || document.WORKORDER.SUPAPPROVALDATE.value == " " || !document.WORKORDER.SUPAPPROVALDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKORDER.SUPAPPROVALDATE.name +  ", A Supervisor Approval Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKORDER.SUPAPPROVALDATE.focus();
			return false;
		}

		if (document.WORKORDER.SUPEMAILID.selectedIndex == "0" && document.WORKORDER.APPROVEDBYSUPID.selectedIndex > "0") {
			alertuser (document.WORKORDER.SUPEMAILID.name +  ",  A Unit Head's E-Mail Address MUST be selected!");
			document.WORKORDER.SUPEMAILID.focus();
			return false;
		}

		if ((document.WORKORDER.JUSTIFICATIONDESCRIPTION != null) && (document.WORKORDER.JUSTIFICATIONDESCRIPTION.value == "" || document.WORKORDER.JUSTIFICATIONDESCRIPTION.value == " " )) {
			alertuser (document.WORKORDER.JUSTIFICATIONDESCRIPTION.name +  ", A Justification Description MUST be entered!");
			document.WORKORDER.JUSTIFICATIONDESCRIPTION.focus();
			return false;
		}

		if ((document.WORKORDER.STARTDATE != null) && (document.WORKORDER.STARTDATE.value == "" || document.WORKORDER.STARTDATE.value == " " || !document.WORKORDER.STARTDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKORDER.STARTDATE.name +  ", The Desired Start Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKORDER.STARTDATE.focus();
			return false;
		}

		if ((document.WORKORDER.COMPLETIONDATE != null) && (document.WORKORDER.COMPLETIONDATE.value == "" || document.WORKORDER.COMPLETIONDATE.value == " " || !document.WORKORDER.COMPLETIONDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKORDER.COMPLETIONDATE.name +  ", The Desired Completion Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKORDER.COMPLETIONDATE.focus();
			return false;
		}

	}

	function validateLookupField() {
		if (document.LOOKUP.WOID.selectedIndex == "0") {
			alertuser ("A Work Order MUST be selected!");
			document.LOOKUP.WOID.focus();
			return false;
		}
	}


//

</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPWOID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.WOID.focus()">
<CFELSEIF URL.PROCESS EQ "ADD">
	<CFSET CURSORFIELD = "document.WORKORDER.REQUESTTYPEID.focus()">
<CFELSEIF URL.PROCESS EQ "MODIFYDELETE" AND #Client.ProcessFlag# EQ "Yes">
	<CFSET CURSORFIELD = "document.WORKORDER.REQUESTSTATUSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.WORKORDER.REQUESTERID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<CFIF IsDefined('URL.WOID')>
	<CFSET FORM.WOID = #URL.WOID#>
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
	SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
	FROM		FISCALYEARS
	WHERE	(CURRENTFISCALYEAR = 'YES')
	ORDER BY	FISCALYEARID
</CFQUERY>

<CFQUERY name="ListRequestersAltContacts" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME,
			CUST.CATEGORYID, CUST.UNITID, U.GROUPID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND
			CUST.UNITID = U.UNITID) OR	
			(CUST.UNITID = U.UNITID AND
			U.GROUPID IN (2,3,4,6) AND
			CUST.ACTIVE = 'YES')	
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
	SELECT	UNITID, UNITNAME, CAMPUSMAILCODEID, GROUPID, DEPARTMENTID, SUPERVISORID
	FROM		UNITS
	WHERE	UNITID = 0 OR
			GROUPID IN (2,3,4,6)
	ORDER BY	UNITNAME
</CFQUERY>

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
			LOC.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION, 
			LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LOC.MODIFIEDBYID, LOC.MODIFIEDDATE, LOC.ARCHIVELOCATION
	FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
	WHERE	(SUBSTR(LOC.ROOMNUMBER, 1, 3) = 'LA-' OR
			SUBSTR(LOC.ROOMNUMBER, 1, 3) = 'LL-') AND
			(LOC.BUILDINGNAMEID IN (10,11) AND
			LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID)
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListSupApprovals" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPEMAIL, CUST.UNITID, U.GROUPID,
			CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND 
			CUST.UNITID = U.UNITID) OR
			(CUST.UNITID = U.UNITID AND
			U.GROUPID IN (2,3,4,6) AND
			CUST.ACTIVE = 'YES' AND 
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
			CUST.ACTIVE = 'YES' AND 
			CUST.DEPTCHAIR = 'YES' AND
			CUST.ALLOWEDTOAPPROVE = 'YES')
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListRequestTypes" datasource="#application.type#FACILITIES" blockfactor="13">
	SELECT	REQUESTTYPEID, REQUESTTYPENAME
	FROM		REQUESTTYPES
	ORDER BY	REQUESTTYPENAME
</CFQUERY>

<CFSET session.MOVEREQUESTCOUNTER = 0>

<!--- 
**********************************************************
* The following code is the ADD Process for Work Orders. *
**********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(WORKORDERID) AS MAX_ID
		FROM		WORKORDERS
	</CFQUERY>
	<CFSET FORM.WOID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="WOID" secure="NO" value="#FORM.WOID#">
	<CFQUERY name="GetMaxFYSeqNum" datasource="#application.type#FACILITIES">
		SELECT	FISCALYEARID, FISCALYEARSEQNUMBER AS MAX_FYSEQNUM
		FROM		WORKORDERS
		WHERE 	WORKORDERID = #val(FORM.WOID)# - 1
	</CFQUERY>
	<CFIF GetMaxFYSeqNum.FISCALYEARID LT ListCurrentFiscalYear.FISCALYEARID>
		<CFSET FORM.FYSEQNUM = 1>
	<CFELSE>
		<CFSET FORM.FYSEQNUM =  #val(GetMaxFYSeqNum.MAX_FYSEQNUM+1)#>
	</CFIF>
	<CFSET FORM.WORKORDERNUMBER = #ListCurrentFiscalYear.FISCALYEAR_2DIGIT# & #NumberFormat(FORM.FYSEQNUM,  '0009')#>
	<CFSET FORM.FISCALYEARID = #ListCurrentFiscalYear.FISCALYEARID#>
	<CFSET FORM.REQUESTDATE = #DateFormat(NOW(), 'dd-mmm-yyyy ')#>
	<CFSET FORM.REQUESTTIME = #TimeFormat(NOW(), 'HH:mm:ss')#>

	<CFQUERY name="AddWorkOrdersID" datasource="#application.type#FACILITIES">
		INSERT INTO	WORKORDERS(WORKORDERID, FISCALYEARID, FISCALYEARSEQNUMBER, WORKORDERNUMBER, REQUESTDATE, REQUESTSTATUSID)
		VALUES		(#val(Cookie.WOID)#, #val(FORM.FISCALYEARID)#, #val(FORM.FYSEQNUM)#, '#FORM.WORKORDERNUMBER#',
					TO_DATE('#FORM.REQUESTDATE# #FORM.REQUESTTIME#', 'DD-MON-YYYY HH24:MI:SS'), 6)
	</CFQUERY>

	<CFQUERY name="GetRequestStatus" datasource="#application.type#FACILITIES">
		SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
		FROM		REQUESTSTATUS
		WHERE	REQUESTSTATUSID = 6
		ORDER BY	REQUESTSTATUSNAME
	</CFQUERY>

	<CFQUERY name="GetRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID,
				CUST.UNITID, UNITS.UNITID, UNITS.SUPERVISORID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.UNITID = UNITS.UNITID
		ORDER BY	FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add WO Request</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="Left" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				WO Key: &nbsp;&nbsp; <H5>#FORM.WOID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(FORM.REQUESTDATE, "mm/dd/yyyy")#</H5>
			</TH>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processworkorderinfo.cfm" method="POST">
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR />
				<INPUT type="submit" name="ProcessWorkOrders" value="CANCELADD" tabindex="1" />
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD align="left">
				<H2>WO Request Number:&nbsp;&nbsp;#FORM.WORKORDERNUMBER#</H2>
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="WORKORDER" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processworkorderinfo.cfm" method="POST" ENABLECAB="Yes">

		<TR>
			<TH align="left" valign ="BOTTOM">
				<H4><LABEL for="REQUESTTYPEID">*Request Type</LABEL></H4>
				<INPUT type="hidden" name="WORKORDERNUMBER" value="#FORM.WORKORDERNUMBER#" />

			</TH>
			<TH align="left" valign ="BOTTOM">Request Status</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" selected="" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left" valign ="TOP">
				<INPUT type="hidden" name="REQUESTSTATUSID" value="#GetRequestStatus.REQUESTSTATUSID#" />
				#GetRequestStatus.REQUESTSTATUSNAME#
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="REQUESTERID">*Requester</LABEL></H4></TH>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="UNITID">*Unit</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequestersAltContacts" value="CUSTOMERID" display="FULLNAME" required="No" selected="#GetRequesters.CUSTOMERID#" tabindex="3"></CFSELECT>
			</TD>
			<TD align="left" valign ="TOP">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" required="No" selected="#GetRequesters.UNITID#" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="LOCATIONID">Location</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><LABEL for="ALTERNATECONTACTID">Alternate Contact</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetRequesters.LOCATIONID#" required="No" tabindex="5"></CFSELECT><BR />
				<COM>(Choose a Room Number the work order will be performed <BR />in, if it is different from the Requester's Room Number.)</COM>
			</TD>
			<TD align="left"  valign ="TOP">
				<CFSELECT name="ALTERNATECONTACTID" id="ALTERNATECONTACTID" size="1" query="ListRequestersAltContacts" value="CUSTOMERID" display="FULLNAME" required="No" selected="#GetRequesters.CUSTOMERID#" tabindex="6"></CFSELECT><BR />
				<COM>(Choose a Alternate Contact name, if it is different <BR />from the Requester's name.)</COM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="SUPEMAILID">*Unit Head's E-Mail</LABEL></H4></TH>
			<TH align="left" valign ="BOTTOM">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="SUPEMAILID" id="SUPEMAILID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="SUPEMAIL" selected="#GetRequesters.SUPERVISORID#" required="No" tabindex="7"></CFSELECT>
			</TD>
			<TD align="left" valign ="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM" colspan="2"> 
				<LABEL for="PROJECTDESCRIPTION">Work Description (and Justification, if work is urgent)</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP" colspan="2">
				<TEXTAREA name="PROJECTDESCRIPTION" id="PROJECTDESCRIPTION" wrap="off" rows="6" cols="100" tabindex="8"></TEXTAREA><BR />
				<COM>(Scope Of Work is for Physical Plant Requests Only)</COM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="URGENCY">Urgency</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="STARTDATE">*Start Date</LABEL></H4></TH>
		</TR>
		<TR>
               <TD align="left" nowrap>
                    <CFSELECT name="URGENCY" id="URGENCY" size="1" tabindex="9">
                         <OPTION selected value="Select an Urgency">Select an Urgency</OPTION>
                         <OPTION value="Power Out/No Lights">Power Out/No Lights</OPTION>
                         <OPTION value="Public Service Affected">Public Service Affected</OPTION>
                    </CFSELECT>
               </TD>     
			<CFSET FORMATSTARTDATE = #DateFormat((NOW() + 14), 'mm/dd/yyyy')#>
			<TD align="left" valign ="TOP">
				<COM>MM/DD/YYYYY </COM><BR>
				<CFINPUT type="Text" name="STARTDATE" id="STARTDATE" value="#FORMATSTARTDATE#" align="LEFT" required="No" size="10" tabindex="10">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'WORKORDER','controlname': 'STARTDATE'});

				</SCRIPT>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<COM>(Select the appropriate ADD button <STRONG>to SUBMIT above info and Continue for these Request Types</STRONG>)</COM><BR />
				<INPUT type="submit" name="ProcessWorkOrders" value="ADD KEY/CARD REQUEST" tabindex="11" />&nbsp;&nbsp;<--(Includes PS Requests)<BR />
				<INPUT type="submit" name="ProcessWorkOrders" value="ADD MOVE REQUEST" tabindex="12" />&nbsp;&nbsp;<--(Includes MM Requests & TNS - Phone Service, Move)<BR />
				<INPUT type="submit" name="ProcessWorkOrders" value="ADD TNS PHONE REQUEST" tabindex="13" />&nbsp;&nbsp;<--(Includes All Other TNS Phone Requests)<BR /><BR />
				<COM>(Select this ADD button <STRONG>to SUBMIT and Complete this Request Type</STRONG>)</COM><BR />
				<INPUT type="submit" name="ProcessWorkOrders" value="ADD OTHER REQUEST" tabindex="14" />&nbsp;&nbsp;<--(Includes PHPL & All Other Requests)<BR />
			</TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processworkorderinfo.cfm" method="POST">
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR />
				<INPUT type="submit" name="ProcessWorkOrders" value="CANCELADD" tabindex="15" />
</CFFORM>
			</TD>
		</TR>
		
		<TR>
			<TD align="LEFT" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
     
     <CFEXIT>

<CFELSE>

<!--- 
*************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Work Orders. *
*************************************************************************************
 --->

	<CFQUERY name="LookupWorkOrders" datasource="#application.type#FACILITIES">
		SELECT	WO.WORKORDERID, WO.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, WO.REQUESTTYPEID, RT.REQUESTTYPENAME, WO.WORKORDERNUMBER,
          		CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WO.WORKORDERNUMBER AS KEYFINDER
		FROM		WORKORDERS WO, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT
		WHERE	WO.REQUESTERID = CUST.CUSTOMERID AND
			<CFIF #Client.ProcessFlag# EQ "NO">
				WO.REQUESTERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
			</CFIF>
				WO.REQUESTTYPEID = RT.REQUESTTYPEID
		ORDER BY	CUST.FULLNAME, RT.REQUESTTYPENAME, WO.WORKORDERNUMBER
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPWOID')>
			<TD align="center"><H1>Modify an Existing WO Lookup</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify WO Request</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>* RED fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>

	<CFIF NOT IsDefined('URL.LOOKUPWOID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
				<TD align="LEFT" colspan="2">
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR />
					<INPUT type="submit" value="Cancel" tabindex="1" />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/workorder.cfm?PROCESS=#URL.PROCESS#&LOOKUPWOID=FOUND" method="POST">
			<TR>
				<TH align="LEFT"><H4><LABEL for="WOID">*Select by Customer - Request Type- WO Request Number:</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT">
					<CFSELECT name="WOID" id="WOID" size="1" query="LookupWorkOrders" value="WORKORDERID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
					<INPUT type="submit" value="GO" tabindex="3" /><BR />
				</TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
				<TD align="LEFT" colspan="2">
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR />
					<INPUT type="submit" value="Cancel" tabindex="4" />
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
*************************************************************************
* The following code is the Modify and Delete Processes for Work Orders.*
*************************************************************************
 --->

		<CFQUERY name="GetWorkOrders" datasource="#application.type#FACILITIES">
			SELECT	WO.WORKORDERID, TO_CHAR(WO.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WO.FISCALYEARID, WO.FISCALYEARSEQNUMBER,
					WO.WORKORDERNUMBER, WO.REQUESTTYPEID, RT.REQUESTTYPENAME, WO.REQUESTSTATUSID, RS.REQUESTSTATUSNAME,
					WO.REQUESTERID, WO.UNITID, WO.LOCATIONID, WO.ACCOUNTNUMBER1, WO.ACCOUNTNUMBER2, WO.ACCOUNTNUMBER3,
					WO.ALTERNATECONTACTID, WO.PROJECTDESCRIPTION, WO.JUSTIFICATIONDESCRIPTION, SUPEMAILID, WO.APPROVEDBYSUPID,
					TO_CHAR(WO.INITAPPROVALDATE, 'MM/DD/YYYY') AS INITAPPROVALDATE, TO_CHAR(WO.SUPAPPROVALDATE, 'MM/DD/YYYY') AS SUPAPPROVALDATE,  
					WO.MGMTEMAILID, WO.APPROVEDBYMGMTID, TO_CHAR(WO.STARTDATE, 'MM/DD/YYYY') AS STARTDATE, TO_CHAR(WO.COMPLETIONDATE, 'MM/DD/YYYY') AS COMPLETIONDATE,
					WO.URGENCY, WO.KEYREQUEST, WO.MOVEREQUEST, WO.TNSREQUEST, WO.STATUS_COMMENTS
			FROM		WORKORDERS WO, REQUESTTYPES RT, REQUESTSTATUS RS
			WHERE	WO.WORKORDERID = <CFQUERYPARAM value="#FORM.WOID#" cfsqltype="CF_SQL_NUMERIC"> AND
					WO.REQUESTTYPEID = RT.REQUESTTYPEID AND
					WO.REQUESTSTATUSID = RS.REQUESTSTATUSID
			ORDER BY	WO.REQUESTERID, RT.REQUESTTYPENAME, WO.WORKORDERNUMBER
		</CFQUERY>

		<CFQUERY name="ListRequestStatus" datasource="#application.type#FACILITIES" blockfactor="8">
			SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
			FROM		REQUESTSTATUS
			ORDER BY	REQUESTSTATUSNAME
		</CFQUERY>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center" colspan="2">
					WO Key: &nbsp;&nbsp; <H5>#GetWorkOrders.WORKORDERID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(GetWorkOrders.REQUESTDATE, 'mm/dd/yyyy')#</H5>
				</TH>
			</TR>
		</TABLE>

		<TABLE width="100%" border="0">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/workorder.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR />
					<INPUT type="submit" name="ProcessWorkOrders" value="Cancel" tabindex="1" />
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left"><H2>WO Request Number:&nbsp;&nbsp;#GetWorkOrders.WORKORDERNUMBER#</H2></TD>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="WORKORDER" onsubmit="return validateReqFields();" action="processworkorderinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left" valign ="BOTTOM">
					<H4><LABEL for="REQUESTTYPEID">*Request Type</LABEL></H4>
					<INPUT type="Hidden" name="WORKORDERNUMBER" value="#GetWorkOrders.WORKORDERNUMBER#" />
					<CFCOOKIE name="WOID" secure="NO" value="#FORM.WOID#">
				</TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="REQUESTSTATUSID">Request Status</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" selected="#GetWorkOrders.REQUESTTYPEID#" tabindex="2"></CFSELECT>
				</TD>
				<TD align="left" valign ="TOP">
			<CFIF #Client.ProcessFlag# EQ "Yes">
					<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="#GetWorkOrders.REQUESTSTATUSID#" tabindex="3"></CFSELECT>
			<CFELSE>
					<INPUT type="hidden" name="REQUESTSTATUSID" value=6 />
					#GetWorkOrders.REQUESTSTATUSNAME#	
			</CFIF>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="REQUESTERID">*Requester</LABEL></H4></TH>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="UNITID">*Unit</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequestersAltContacts" value="CUSTOMERID" display="FULLNAME" selected="#GetWorkOrders.REQUESTERID#" required="No" tabindex="4"></CFSELECT>
				</TD>
				<TD align="left" valign ="TOP">
					<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="#GetWorkOrders.UNITID#" required="No" tabindex="5"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="LOCATIONID">Location</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="ALTERNATECONTACTID">Alternate Contact</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetWorkOrders.LOCATIONID#" required="No"  tabindex="6"></CFSELECT><BR />
					<COM>(Choose a Room Number the work order will be performed in, if it is <BR />different from the Requester's Room Number.)</COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFSELECT name="ALTERNATECONTACTID" id="ALTERNATECONTACTID" size="1" query="ListRequestersAltContacts" value="CUSTOMERID" display="FULLNAME" required="No" selected="#GetWorkOrders.ALTERNATECONTACTID#" tabindex="7"></CFSELECT><BR />
					<COM>(Choose an Alternate Contact name, if it is different <BR />from the Requester's name.)</COM>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
		<CFIF #Client.ProcessFlag# EQ "Yes">
			<TR>
				<TH align="LEFT"><H4><LABEL for="ACCOUNTNUMBER2">*State Account Number</LABEL></H4></TH>
                    <TH align="left" valign ="BOTTOM"><H4><LABEL for="INITAPPROVALDATE">*Initial Approval Date</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					#GetWorkOrders.ACCOUNTNUMBER1#
					&nbsp;<CFINPUT type="Text" name="ACCOUNTNUMBER2" id="ACCOUNTNUMBER2" value="#GetWorkOrders.ACCOUNTNUMBER2#" align="LEFT" required="No" size="4" maxlength="3" tabindex="8">
					<LABEL for="ACCOUNTNUMBER3" class="LABEL_hidden">State Account Number Part 3</LABEL>
					&nbsp;<CFSELECT name="ACCOUNTNUMBER3" id="ACCOUNTNUMBER3" size="1" required="No" tabindex="9">
					<CFIF #GetWorkOrders.ACCOUNTNUMBER3# EQ "">
						<OPTION selected value="SELECT AN ACCOUNT">SELECT AN ACCOUNT</OPTION>
					<CFELSE>
						<OPTION value="SELECT AN ACCOUNT">SELECT AN ACCOUNT</OPTION>
						<OPTION selected value="#GetWorkOrders.ACCOUNTNUMBER3#">#GetWorkOrders.ACCOUNTNUMBER3#</OPTION>
					</CFIF>
						<OPTION value="-66032-1001-1000-1901">-66032-1001-1000-1901</OPTION>
						<OPTION value="-66032-0000-1002-1901">-66032-0000-1002-1901</OPTION>
					</CFSELECT><BR />
					<COM>(Type Activity Number and Select an Account.)</COM>
				</TD>
                    <TD align="left" valign ="TOP">
					<CFIF #GetWorkOrders.INITAPPROVALDATE# EQ "">
                              <CFINPUT type="Text" name="INITAPPROVALDATE" id="INITAPPROVALDATE" value="" align="LEFT" required="No" size="10" maxlength="10" tabindex="10">
                              <SCRIPT language="JavaScript">
                                   new tcal ({'formname': 'WORKORDER','controlname': 'INITAPPROVALDATE'});
     
                              </SCRIPT><BR>
                              <COM>MM/DD/YYYYY </COM>
                         <CFELSE>
                              #DateFormat(GetWorkOrders.INITAPPROVALDATE, 'mm/dd/yyyy')#
                         </CFIF>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="APPROVEDBYSUPID">Approved By Unit Head</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="SUPAPPROVALDATE">Unit Head Approval Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="FULLNAME" selected="#GetWorkOrders.APPROVEDBYSUPID#" required="No" tabindex="11"></CFSELECT>
				</TD>
				<TD align="left" valign ="TOP">
				<CFIF #GetWorkOrders.SUPAPPROVALDATE# EQ "">
					<CFINPUT type="Text" name="SUPAPPROVALDATE" id="SUPAPPROVALDATE" value="" align="LEFT" required="No" size="10" maxlength="10" tabindex="12">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'WORKORDER','controlname': 'SUPAPPROVALDATE'});

					</SCRIPT><BR>
					<COM>MM/DD/YYYYY </COM>
				<CFELSE>
					#DateFormat(GetWorkOrders.SUPAPPROVALDATE, 'mm/dd/yyyy')#
				</CFIF>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
		</CFIF>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="SUPEMAILID">Unit Head's E-Mail</LABEL></TH>
			<CFIF #Client.ProcessFlag# EQ "Yes">
				<TH align="left" valign ="BOTTOM"><LABEL for="MGMTEMAILID">Management's E-Mail</LABEL></TH>
			</CFIF>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="SUPEMAILID" id="SUPEMAILID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="SUPEMAIL" selected="#GetWorkOrders.SUPEMAILID#" required="No" tabindex="13"></CFSELECT>
				</TD>
			<CFIF #Client.ProcessFlag# EQ "Yes">
				<TD align="left" valign ="TOP">
					<CFSELECT name="MGMTEMAILID" id="MGMTEMAILID" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="MGMTEMAIL" selected="#GetWorkOrders.MGMTEMAILID#" required="No" tabindex="14"></CFSELECT>
				</TD>
			</CFIF>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="APPROVEDBYMGMTID">Approved By Management</LABEL></TH>
				<TH align="left" valign ="BOTTOM">&nbsp;&nbsp;</TH>
			</TR>
					<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="APPROVEDBYMGMTID" id="APPROVEDBYMGMTID" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="FULLNAME" selected="#GetWorkOrders.APPROVEDBYMGMTID#" required="No" tabindex="15"></CFSELECT>
				</TD>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="PROJECTDESCRIPTION">Scope Of Work</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="JUSTIFICATIONDESCRIPTION">*Justification Description</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="PROJECTDESCRIPTION" id="PROJECTDESCRIPTION" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="16">#GetWorkOrders.PROJECTDESCRIPTION#</CFTEXTAREA><BR />
					<COM>(Scope Of Work is for Physical Plant Requests Only)</COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="JUSTIFICATIONDESCRIPTION" id="JUSTIFICATIONDESCRIPTION" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="17">#GetWorkOrders.JUSTIFICATIONDESCRIPTION#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM">
                    	<LABEL for="URGENCY">Urgency</LABEL>
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<H4><LABEL for="STARTDATE">*Desired Start Date</LABEL></H4>
                    </TH>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="COMPLETIONDATE">*Desired Completion Date</LABEL></H4></TH>
			</TR>
			<TR>
               	<TD align="left" nowrap>
                         <CFSELECT name="URGENCY" id="URGENCY" size="1" tabindex="18">
                              <OPTION selected value="#GetWorkOrders.URGENCY#">#GetWorkOrders.URGENCY#</OPTION>
                              <OPTION value="Select an Urgency">Select an Urgency</OPTION>
                              <OPTION value="Power Out/No Lights">Power Out/No Lights</OPTION>
                              <OPTION value="Public Service Affected">Public Service Affected</OPTION>
                         </CFSELECT>
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<CFINPUT type="Text" name="STARTDATE" id="STARTDATE" value="#GetWorkOrders.STARTDATE#" align="LEFT" required="No" size="10" maxlength="10" tabindex="19">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'WORKORDER','controlname': 'STARTDATE'});

					</SCRIPT><BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="COMPLETIONDATE" id="COMPLETIONDATE" value="#GetWorkOrders.COMPLETIONDATE#" align="LEFT" required="No" size="10" maxlength="10" tabindex="20">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'WORKORDER','controlname': 'COMPLETIONDATE'});

					</SCRIPT><BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
               <TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="STATUS_COMMENTS">Status Comments</LABEL></TH>
				<TH align="left" valign ="BOTTOM">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="STATUS_COMMENTS" id="STATUS_COMMENTS" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="21">#GetWorkOrders.STATUS_COMMENTS#</CFTEXTAREA>
				</TD>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">
				<CFIF GetWorkOrders.KEYREQUEST EQ 'YES'>
					<INPUT type="submit" name="ProcessWorkOrders" value="MODIFY KEY/CARD REQUEST" tabindex="22" />&nbsp;&nbsp;<COM><--(Modifies info above & moves to 2nd screen.)</COM><BR /><BR /><BR />
				<CFELSEIF GetWorkOrders.MOVEREQUEST EQ 'YES'>
					<INPUT type="submit" name="ProcessWorkOrders" value="MODIFY MOVE REQUEST" tabindex="22" />&nbsp;&nbsp;<COM><--(Modifies info above & moves to 2nd screen.)</COM><BR /><BR /><BR />
				<CFELSEIF GetWorkOrders.MOVEREQUEST EQ 'NO' AND GetWorkOrders.TNSREQUEST EQ 'YES'>
					<INPUT type="submit" name="ProcessWorkOrders" value="MODIFY TNS PHONE REQUEST" tabindex="22" />&nbsp;&nbsp;<COM><--(Modifies info above & moves to 2nd screen.)</COM><BR /><BR /><BR />
				<CFELSE>
					<INPUT type="submit" name="ProcessWorkOrders" value="MODIFY OTHER REQUEST" tabindex="22" />&nbsp;&nbsp;<COM><--(Modifies info above & complete.)</COM><BR /><BR /><BR />
				</CFIF>
				</TD>
			</TR>
<!--- 
          <CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessWorkOrders" value="DELETE" tabindex="23" /></TD>
			</TR>
		</CFIF>
 --->
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/workorder.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR />
					<INPUT type="submit" name="ProcessWorkOrders" value="Cancel" tabindex="24" />
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>