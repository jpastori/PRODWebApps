 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workrequest.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/13/2012 --->
<!--- Date in Production: 02/13/2012 --->
<!--- Module: Add/Modify/Delete Work Requests --->
<!-- Last modified by John R. Pastori on 02/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/workrequest.cfm">
<CFSET CONTENT_UPDATED = "February 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Work Request</TITLE>
	<CFELSE>
		<TITLE>Modify Work Request</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Facilities";
	var KeyCardRequest = false;
	var MoveRequest = false;
	var TNSPhoneRequest = false;
	var OtherRequest = false;

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
		if (document.WORKREQUEST.REQUESTTYPEID != null && document.WORKREQUEST.REQUESTTYPEID.selectedIndex == "0") {
			alertuser (document.WORKREQUEST.REQUESTTYPEID.name +  ",  A Request Type MUST be selected!");
			document.WORKREQUEST.REQUESTTYPEID.focus();
			return false;
		}

		if (document.WORKREQUEST.REQUESTERID.selectedIndex == "0") {
			alertuser (document.WORKREQUEST.REQUESTERID.name +  ",  A Customer MUST be selected!");
			document.WORKREQUEST.REQUESTERID.focus();
			return false;
		}

		if (document.WORKREQUEST.UNITID.selectedIndex == "0") {
			alertuser (document.WORKREQUEST.UNITID.name +  ",  A Unit Name MUST be selected!");
			document.WORKREQUEST.UNITID.focus();
			return false;
		}


//		if ((document.WORKREQUEST.SUPAPPROVALDATE != null && document.WORKREQUEST.APPROVEDBYSUPID.selectedIndex > "0") 
//		 && (document.WORKREQUEST.SUPAPPROVALDATE.value == "" || document.WORKREQUEST.SUPAPPROVALDATE.value == " " || !document.WORKREQUEST.SUPAPPROVALDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
//			alertuser (document.WORKREQUEST.SUPAPPROVALDATE.name +  ", A Supervisor Approval Date MUST be entered in the format MM/DD/YYYY!");
//			document.WORKREQUEST.SUPAPPROVALDATE.focus();
//			return false;
//		}

//		if (document.WORKREQUEST.SUPEMAILID.selectedIndex == "0" && document.WORKREQUEST.APPROVEDBYSUPID.selectedIndex > "0") {
//			alertuser (document.WORKREQUEST.SUPEMAILID.name +  ",  A Unit Head's E-Mail Address MUST be selected!");
//			document.WORKREQUEST.SUPEMAILID.focus();
//			return false;
//		}

		if ((document.WORKREQUEST.JUSTIFICATIONDESCRIPTION != null) && (document.WORKREQUEST.JUSTIFICATIONDESCRIPTION.value == "" || document.WORKREQUEST.JUSTIFICATIONDESCRIPTION.value == " " )) {
			alertuser (document.WORKREQUEST.JUSTIFICATIONDESCRIPTION.name +  ", A Justification Description MUST be entered!");
			document.WORKREQUEST.JUSTIFICATIONDESCRIPTION.focus();
			return false;
		}

		if ((document.WORKREQUEST.STARTDATE != null) && (document.WORKREQUEST.STARTDATE.value == "" || document.WORKREQUEST.STARTDATE.value == " " || !document.WORKREQUEST.STARTDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKREQUEST.STARTDATE.name +  ", The Desired Start Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKREQUEST.STARTDATE.focus();
			return false;
		}

		if ((document.WORKREQUEST.COMPLETIONDATE != null) && (document.WORKREQUEST.COMPLETIONDATE.value == "" || document.WORKREQUEST.COMPLETIONDATE.value == " " || !document.WORKREQUEST.COMPLETIONDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKREQUEST.COMPLETIONDATE.name +  ", The Desired Completion Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKREQUEST.COMPLETIONDATE.focus();
			return false;
		}
		
		if (document.WORKREQUEST.ACCOUNTNUMBER2 != null && document.WORKREQUEST.ACCOUNTNUMBER2.value == "0") {
			alertuser (document.WORKREQUEST.ACCOUNTNUMBER2.name +  ", An Account Number MUST be entered!");
			document.WORKREQUEST.ACCOUNTNUMBER2.focus();
			return false;
		}

		if ((document.WORKREQUEST.ACCOUNTNUMBER3 != null) && (document.WORKREQUEST.ACCOUNTNUMBER3.value == "" || document.WORKREQUEST.ACCOUNTNUMBER3.selectedIndex == 0 || document.WORKREQUEST.ACCOUNTNUMBER3.value == "0")) {
			alertuser (document.WORKREQUEST.ACCOUNTNUMBER3.name +  ", An Account Number MUST be selected!");
			document.WORKREQUEST.ACCOUNTNUMBER3.focus();
			return false;
		}
		
		if ((document.WORKREQUEST.INITAPPROVALDATE != null) && (document.WORKREQUEST.INITAPPROVALDATE.value == "" || document.WORKREQUEST.INITAPPROVALDATE.value == " " || !document.WORKREQUEST.INITAPPROVALDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.WORKREQUEST.INITAPPROVALDATE.name +  ", An Initial Approval Date MUST be entered in the format MM/DD/YYYY!");
			document.WORKREQUEST.INITAPPROVALDATE.focus();
			return false;
		}

		
		if (KeyCardRequest==true) {	
//			var message = "Key Card Request = ";
//			document.write (message);
//			document.write (KeyCardRequest);
//			var message = "Move Request = ";
//			document.write (message);
//			document.write (MoveRequest);	
//			var message = "TNS Phone Request = ";
//			document.write (message);
//			document.write (TNSPhoneRequest); 
//			var message = "Other Request = ";
//			document.write (message);
//			document.write (OtherRequest);
//			document.write (document.WORKREQUEST.REQUESTTYPEID.selectedIndex);
			if (document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "4" ) {
				alertuser (document.WORKREQUEST.REQUESTTYPEID.name +  ",  The Key/Card Request Type was not selected!");
				document.WORKREQUEST.REQUESTTYPEID.focus();
				KeyCardRequest=false;
				return false;
			}
			KeyCardRequest=false;
		}
		
		
		if  (MoveRequest==true) {
			var message = "Key Card Request = ";
//			document.write (message);
//			document.write (KeyCardRequest);
//			var message = "Move Request = ";
//			document.write (message);
//			document.write (MoveRequest);	
//			var message = "TNS Phone Request = ";
//			document.write (message);
//			document.write (TNSPhoneRequest); 
//			var message = "Other Request = ";
//			document.write (message);
//			document.write (OtherRequest);
//			document.write (document.WORKREQUEST.REQUESTTYPEID.selectedIndex);
			if (document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "6" ) {
				alertuser (document.WORKREQUEST.REQUESTTYPEID.name +  ",  The Move Request Type was not selected!");
				document.WORKREQUEST.REQUESTTYPEID.focus();
				MoveRequest=false;
				return false;
			}
			MoveRequest=false;
		}

		
		if  (TNSPhoneRequest==true) {
//			var message = "Key Card Request = ";
//			document.write (message);
//			document.write (KeyCardRequest);
//			var message = "Move Request = ";
//			document.write (message);
//			document.write (MoveRequest);	
//			var message = "TNS Phone Request = ";
//			document.write (message);
//			document.write (TNSPhoneRequest); 
//			var message = "Other Request = ";
//			document.write (message);
//			document.write (OtherRequest);
//			document.write (document.WORKREQUEST.REQUESTTYPEID.selectedIndex);
			if (document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "2"   && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "3"
			 && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "5"   && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "7"
			 && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "8"   && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "10"
			 && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "14") {
				alertuser (document.WORKREQUEST.REQUESTTYPEID.name +  ",  A TNS Phone Request Type was not selected!");
				document.WORKREQUEST.REQUESTTYPEID.focus();
				TNSPhoneRequest=false;
				return false;
			}
			TNSPhoneRequest=false;
		}

		
		if  (OtherRequest==true) {
//			var message = "Key Card Request = ";
//			document.write (message);
//			document.write (KeyCardRequest);
//			var message = "Move Request = ";
//			document.write (message);
//			document.write (MoveRequest);	
//			var message = "TNS Phone Request = ";
//			document.write (message);
//			document.write (TNSPhoneRequest); 
//			var message = "Other Request = ";
//			document.write (message);
//			document.write (OtherRequest);
//			document.write (document.WORKREQUEST.REQUESTTYPEID.selectedIndex);
			 if (document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "1"  && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "9"
			  && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "11" && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "12"
			  && document.WORKREQUEST.REQUESTTYPEID.selectedIndex != "13") {
				alertuser (document.WORKREQUEST.REQUESTTYPEID.name +  ",  An Other Request Type was not selected!");
				document.WORKREQUEST.REQUESTTYPEID.focus();
				OtherRequest=false;
				return false;
			}
			OtherRequest=false;
		}

	}
	

	function validateLookupField() {
		if (document.LOOKUP.WorkID1.selectedIndex == "0"  && document.LOOKUP.WorkID2joh.selectedIndex == "0") {
			alertuser ("At least one dropdown field must be selected!");
			document.LOOKUP.WorkID1.focus();
			return false;
		}

		if (document.LOOKUP.WorkID1.selectedIndex > "0" && document.LOOKUP.WorkID2.selectedIndex > "0"){
			 alertuser ("Only One dropdown field can be selected");
			 document.LOOKUP.WorkID1.focus();
			 return false;
		}
	}


//

</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPWORKREQUESTID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.WORKREQUESTID1.focus()">
<CFELSEIF URL.PROCESS EQ "ADD">
	<CFSET CURSORFIELD = "document.WORKREQUEST.REQUESTTYPEID.focus()">
<CFELSEIF URL.PROCESS EQ "MODIFYDELETE" AND #Client.ProcessFlag# EQ "Yes">
	<CFSET CURSORFIELD = "document.WORKREQUEST.REQUESTSTATUSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.WORKREQUEST.REQUESTERID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<CFIF IsDefined('URL.WORKREQUESTID')>
	<CFSET FORM.WORKREQUESTID = #URL.WORKREQUESTID#>
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
	SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPERVEMAIL, CUST.UNITID, U.GROUPID,
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

<!--- 
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
 --->
 
<CFQUERY name="ListRequestTypes" datasource="#application.type#FACILITIES" blockfactor="13">
	SELECT	REQUESTTYPEID, REQUESTTYPENAME
	FROM		REQUESTTYPES
	ORDER BY	REQUESTTYPENAME
</CFQUERY>

<CFSET session.MOVEREQUESTCOUNTER = 0>

<!--- 
************************************************************
* The following code is the ADD Process for Work Requests. *
************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(WORKREQUESTID) AS MAX_ID
		FROM		WORKREQUESTS
	</CFQUERY>
	<CFSET FORM.WORKREQUESTID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="WORKREQUESTID" secure="NO" value="#FORM.WORKREQUESTID#">
	<CFQUERY name="GetMaxFYSeqNum" datasource="#application.type#FACILITIES">
		SELECT	FISCALYEARID, FISCALYEARSEQNUMBER AS MAX_FYSEQNUM
		FROM		WORKREQUESTS
		WHERE 	WORKREQUESTID = #val(FORM.WORKREQUESTID)# - 1
	</CFQUERY>
	<CFIF GetMaxFYSeqNum.FISCALYEARID LT ListCurrentFiscalYear.FISCALYEARID>
		<CFSET FORM.FYSEQNUM = 1>
	<CFELSE>
		<CFSET FORM.FYSEQNUM =  #val(GetMaxFYSeqNum.MAX_FYSEQNUM+1)#>
	</CFIF>
	<CFSET FORM.WORKREQUESTNUMBER = #ListCurrentFiscalYear.FISCALYEAR_2DIGIT# & #NumberFormat(FORM.FYSEQNUM,  '0009')#>
	<CFSET FORM.FISCALYEARID = #ListCurrentFiscalYear.FISCALYEARID#>
	<CFSET FORM.REQUESTDATE = #DateFormat(NOW(), 'dd-mmm-yyyy ')#>
	<CFSET FORM.REQUESTTIME = '00:00:00'>

	<CFQUERY name="AddWorkRequestsID" datasource="#application.type#FACILITIES">
		INSERT INTO	WORKREQUESTS(WORKREQUESTID, FISCALYEARID, FISCALYEARSEQNUMBER, WORKREQUESTNUMBER, REQUESTDATE, REQUESTSTATUSID)
		VALUES		(#val(Cookie.WORKREQUESTID)#, #val(FORM.FISCALYEARID)#, #val(FORM.FYSEQNUM)#, '#FORM.WORKREQUESTNUMBER#',
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
				CUST.UNITID, U.UNITID, U.SUPERVISORID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.UNITID = U.UNITID
		ORDER BY	FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add Work Request</H1></TD>
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
				Work Request Key: &nbsp;&nbsp; <H5>#FORM.WORKREQUESTID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(FORM.REQUESTDATE, "mm/dd/yyyy")#</H5>
			</TH>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processworkrequestinfo.cfm" method="POST">
				<INPUT type="submit" name="ProcessWorkRequests" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
<CFFORM name="WORKREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processworkrequestinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">
				<H2>Work Request Number</H2>
			</TH>
			<TH align="left" valign ="BOTTOM">
				<H4><LABEL for="REQUESTTYPEID">*Request Type</LABEL></H4>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT">
               	<STRONG>#FORM.WORKREQUESTNUMBER#</STRONG>
				<INPUT type="hidden" name="WORKREQUESTNUMBER" value="#FORM.WORKREQUESTNUMBER#" />
               </TD>
			<TD align="left" valign ="TOP">
				<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" selected="" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="REQUESTERID">*Requester</LABEL></H4></TH>
			<TH align="left" valign ="BOTTOM">Request Status</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequestersAltContacts" value="CUSTOMERID" display="FULLNAME" required="No" selected="#GetRequesters.CUSTOMERID#" tabindex="3"></CFSELECT>
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
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="UNITID">*Unit</LABEL></H4></TH>
               <TH align="left" valign ="BOTTOM"><H4><LABEL for="SUPEMAILID">*Unit Head's E-Mail</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" required="No" selected="#GetRequesters.UNITID#" tabindex="4"></CFSELECT>
			</TD>
               <TD align="left" valign ="TOP">
				<CFSELECT name="SUPEMAILID" id="SUPEMAILID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="SUPERVEMAIL" selected="#GetRequesters.SUPERVISORID#" required="No" tabindex="7"></CFSELECT>
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
				<COM>(Choose a Room Number the work request will be performed <BR />in, if it is different from the Requester's Room Number.)</COM>
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
			<TH align="left" valign ="BOTTOM" colspan="2"> 
				<LABEL for="PROBLEMDESCRIPTION">Problem/Justification Description</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP" colspan="2">
				<CFTEXTAREA name="PROBLEMDESCRIPTION" id="PROBLEMDESCRIPTION" wrap="off" rows="6" cols="100" tabindex="8"></CFTEXTAREA><BR />
				<COM> (Please be as specific as possible.) </COM>
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
				<CFINPUT type="Text" name="STARTDATE" id="STARTDATE" value="#FORMATSTARTDATE#" align="LEFT" required="No" size="10" tabindex="10">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'WORKREQUEST','controlname': 'STARTDATE'});

				</SCRIPT><BR>
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<COM>(Select the appropriate ADD button <STRONG>to SUBMIT above info and Continue for these Request Types</STRONG>)</COM><BR />
				<INPUT type="submit" name="ProcessWorkRequests" value="ADD KEY/CARD REQUEST" onClick="KeyCardRequest=true" tabindex="11" />&nbsp;&nbsp;<--(Includes PS Requests)<BR />
				<INPUT type="submit" name="ProcessWorkRequests" value="ADD MOVE REQUEST" onClick="MoveRequest=true" tabindex="12" />&nbsp;&nbsp;<--(Includes MM Requests & TNS - Phone Service, Move)<BR />
				<INPUT type="submit" name="ProcessWorkRequests" value="ADD TNS PHONE REQUEST" onClick="TNSPhoneRequest=true" tabindex="13" />&nbsp;&nbsp;<--(Includes All Other TNS Phone Requests)<BR /><BR />
				<COM>(Select this ADD button <STRONG>to SUBMIT and Complete this Request Type</STRONG>)</COM><BR />
				<INPUT type="submit" name="ProcessWorkRequests" value="ADD OTHER REQUEST" onClick="OtherRequest=true" tabindex="14" />&nbsp;&nbsp;<--(Includes PHPL & All Other Requests)<BR />
			</TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processworkrequestinfo.cfm" method="POST">
				<INPUT type="submit" name="ProcessWorkRequests" value="CANCELADD" tabindex="15" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
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
***************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Work Requests. *
***************************************************************************************
 --->

	<CFQUERY name="LookupCurrYrWorkRequests" datasource="#application.type#FACILITIES">
		SELECT	WR.WORKREQUESTID, WR.REQUESTERID, WR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, CUST.CUSTOMERID, CUST.FULLNAME, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.WORKREQUESTNUMBER,
          		CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT AS KEYFINDER
		FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(WR.REQUESTERID = CUST.CUSTOMERID AND
			<CFIF #Client.ProcessFlag# EQ "NO">
				WR.REQUESTERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
			</CFIF>
				WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WR.FISCALYEARID = FY.FISCALYEARID) AND 
                    ((WR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) OR
                    (WR.WORKREQUESTID = 0))
		ORDER BY	CUST.FULLNAME, RT.REQUESTTYPENAME, WR.WORKREQUESTNUMBER, FY.FISCALYEAR_2DIGIT
	</CFQUERY>
     
     <CFQUERY name="LookupPrevYrWorkRequests" datasource="#application.type#FACILITIES">
		SELECT	WR.WORKREQUESTID, WR.REQUESTERID, WR.FISCALYEARID, FY.FISCALYEAR_2DIGIT, CUST.CUSTOMERID, CUST.FULLNAME, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.WORKREQUESTNUMBER,
          		CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER || ' - ' || FY.FISCALYEAR_2DIGIT AS KEYFINDER
		FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(WR.REQUESTERID = CUST.CUSTOMERID AND
			<CFIF #Client.ProcessFlag# EQ "NO">
				WR.REQUESTERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
			</CFIF>
				WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WR.FISCALYEARID = FY.FISCALYEARID) AND 
                    ((WR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) OR
                    (WR.WORKREQUESTID = 0))
		ORDER BY	CUST.FULLNAME, RT.REQUESTTYPENAME, WR.WORKREQUESTNUMBER, FY.FISCALYEAR_2DIGIT
	</CFQUERY>


	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPWORKREQUESTID')>
			<TD align="center"><H1>Modify an Existing Work Request Lookup</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify an Existing Work Request</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
               	<H4>* RED fields marked with asterisks are required!</H4><BR>
                   Select only one of the two dropdown fields and click the GO button. 
		</TH>
		</TR>
	</TABLE>

	<CFIF NOT IsDefined('URL.LOOKUPWORKREQUESTID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=#URL.PROCESS#&LOOKUPWORKREQUESTID=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="40%"><LABEL for="WORKREQUESTID1">Select by Customer - Request Type - Work Request Number For Current Fiscal Year & CFY+1:</LABEL></TH>
				<TD align="LEFT" width="60%">
					<CFSELECT name="WORKREQUESTID1" id="WORKREQUESTID1" size="1" query="LookupCurrYrWorkRequests" value="WORKREQUESTID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="LEFT" width="40%"><LABEL for="WORKREQUESTID2">Or Select by Customer - Request Type - Work Request Number For Previous Fiscal Years:</LABEL></TH>
				<TD align="LEFT" width="60%">
					<CFSELECT name="WORKREQUESTID2" id="WORKREQUESTID2" size="1" query="LookupPrevYrWorkRequests" value="WORKREQUESTID" display="KEYFINDER" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
					<INPUT type="submit" value="GO" tabindex="4" /><BR />
				</TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
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
***************************************************************************
* The following code is the Modify and Delete Processes for Work Requests.*
***************************************************************************
 --->
 
 		<CFIF IsDefined('FORM.WORKREQUESTID1') AND #FORM.WORKREQUESTID1# GT 0>
			<CFSET FORM.WORKREQUESTID = FORM.WORKREQUESTID1>
          <CFELSEIF IsDefined('FORM.WORKREQUESTID2') AND FORM.WORKREQUESTID2 GT 0>
               <CFSET FORM.WORKREQUESTID = FORM.WORKREQUESTID2>
          </CFIF>

		<CFQUERY name="GetWorkRequests" datasource="#application.type#FACILITIES">
			SELECT	WR.WORKREQUESTID, TO_CHAR(WR.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER,
					WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.REQUESTSTATUSID, RS.REQUESTSTATUSNAME,
					WR.REQUESTERID, WR.UNITID, WR.LOCATIONID, WR.ACCOUNTNUMBER1, WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3,
					WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION, TO_CHAR(WR.STARTDATE, 'MM/DD/YYYY') AS STARTDATE, 
                         TO_CHAR(WR.COMPLETIONDATE, 'MM/DD/YYYY') AS COMPLETIONDATE, WR.URGENCY, WR.KEYREQUEST, WR.MOVEREQUEST, WR.TNSREQUEST,
                         WR.STATUS_COMMENTS, TO_CHAR(WR.INITAPPROVALDATE, 'MM/DD/YYYY') AS INITAPPROVALDATE
			FROM		WORKREQUESTS WR, REQUESTTYPES RT, REQUESTSTATUS RS
			WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#FORM.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
					WR.REQUESTSTATUSID = RS.REQUESTSTATUSID
			ORDER BY	WR.REQUESTERID, RT.REQUESTTYPENAME, WR.WORKREQUESTNUMBER
		</CFQUERY>

		<CFQUERY name="ListRequestStatus" datasource="#application.type#FACILITIES" blockfactor="8">
			SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
			FROM		REQUESTSTATUS
			ORDER BY	REQUESTSTATUSNAME
		</CFQUERY>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center" colspan="2">
					Work Request Key: &nbsp;&nbsp; <H5>#GetWorkRequests.WORKREQUESTID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(GetWorkRequests.REQUESTDATE, 'mm/dd/yyyy')#</H5>
				</TH>
			</TR>
		</TABLE>

		<TABLE width="100%" border="0">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessWorkRequests" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left"><H2>Work Request Number:&nbsp;&nbsp;#GetWorkRequests.WORKREQUESTNUMBER#</H2></TD>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="WORKREQUEST" onsubmit="return validateReqFields();" action="processworkrequestinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left" valign ="BOTTOM">
					<H4><LABEL for="REQUESTTYPEID">*Request Type</LABEL></H4>
					<INPUT type="Hidden" name="WORKREQUESTNUMBER" value="#GetWorkRequests.WORKREQUESTNUMBER#" />
					<CFCOOKIE name="WORKREQUESTID" secure="NO" value="#FORM.WORKREQUESTID#">
				</TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="REQUESTSTATUSID">Request Status</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" selected="#GetWorkRequests.REQUESTTYPEID#" tabindex="2"></CFSELECT>
				</TD>
				<TD align="left" valign ="TOP">
			<CFIF #Client.ProcessFlag# EQ "Yes">
					<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="#GetWorkRequests.REQUESTSTATUSID#" tabindex="3"></CFSELECT>
			<CFELSE>
					<INPUT type="hidden" name="REQUESTSTATUSID" value=6 />
					#GetWorkRequests.REQUESTSTATUSNAME#	
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
					<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequestersAltContacts" value="CUSTOMERID" display="FULLNAME" selected="#GetWorkRequests.REQUESTERID#" required="No" tabindex="4"></CFSELECT>
				</TD>
				<TD align="left" valign ="TOP">
					<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="#GetWorkRequests.UNITID#" required="No" tabindex="5"></CFSELECT>
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
					<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetWorkRequests.LOCATIONID#" required="No"  tabindex="6"></CFSELECT><BR />
					<COM>(Choose a Room Number the work request will be performed in, if it is <BR />different from the Requester's Room Number.)</COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFSELECT name="ALTERNATECONTACTID" id="ALTERNATECONTACTID" size="1" query="ListRequestersAltContacts" value="CUSTOMERID" display="FULLNAME" required="No" selected="#GetWorkRequests.ALTERNATECONTACTID#" tabindex="7"></CFSELECT><BR />
					<COM>(Choose an Alternate Contact name, if it is different <BR />from the Requester's name.)</COM>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
               <TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="PROBLEMDESCRIPTION">Problem Description</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><H4><LABEL for="JUSTIFICATIONDESCRIPTION">*Justification Description</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="PROBLEMDESCRIPTION" id="PROBLEMDESCRIPTION" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="8">#GetWorkRequests.PROBLEMDESCRIPTION#</CFTEXTAREA><BR />
					<COM> (Please be as specific as possible.) </COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFTEXTAREA name="JUSTIFICATIONDESCRIPTION" id="JUSTIFICATIONDESCRIPTION" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="9">#GetWorkRequests.JUSTIFICATIONDESCRIPTION#</CFTEXTAREA>
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
                         <CFSELECT name="URGENCY" id="URGENCY" size="1" tabindex="10">
                              <OPTION selected value="#GetWorkRequests.URGENCY#">#GetWorkRequests.URGENCY#</OPTION>
                              <OPTION value="Select an Urgency">Select an Urgency</OPTION>
                              <OPTION value="Power Out/No Lights">Power Out/No Lights</OPTION>
                              <OPTION value="Public Service Affected">Public Service Affected</OPTION>
                         </CFSELECT>
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<CFINPUT type="Text" name="STARTDATE" id="STARTDATE" value="#GetWorkRequests.STARTDATE#" align="LEFT" required="No" size="10" maxlength="10" tabindex="11">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'WORKREQUEST','controlname': 'STARTDATE'});

					</SCRIPT><BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left" valign ="TOP">
					<CFINPUT type="Text" name="COMPLETIONDATE" id="COMPLETIONDATE" value="#GetWorkRequests.COMPLETIONDATE#" align="LEFT" required="No" size="10" maxlength="10" tabindex="12">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'WORKREQUEST','controlname': 'COMPLETIONDATE'});

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
					<CFTEXTAREA name="STATUS_COMMENTS" id="STATUS_COMMENTS" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="13">#GetWorkRequests.STATUS_COMMENTS#</CFTEXTAREA>
				</TD>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
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
					#GetWorkRequests.ACCOUNTNUMBER1#
					&nbsp;<CFINPUT type="Text" name="ACCOUNTNUMBER2" id="ACCOUNTNUMBER2" value="#GetWorkRequests.ACCOUNTNUMBER2#" align="LEFT" required="No" size="4" maxlength="3" tabindex="14">
					<LABEL for="ACCOUNTNUMBER3" class="LABEL_hidden">State Account Number Part 3</LABEL>
					&nbsp;<CFSELECT name="ACCOUNTNUMBER3" id="ACCOUNTNUMBER3" size="1" required="No" tabindex="15">
					<CFIF #GetWorkRequests.ACCOUNTNUMBER3# EQ "">
						<OPTION selected value="SELECT AN ACCOUNT">SELECT AN ACCOUNT</OPTION>
					<CFELSE>
						<OPTION value="SELECT AN ACCOUNT">SELECT AN ACCOUNT</OPTION>
						<OPTION selected value="#GetWorkRequests.ACCOUNTNUMBER3#">#GetWorkRequests.ACCOUNTNUMBER3#</OPTION>
					</CFIF>
						<OPTION value="-66032-1001-1000-1901">-66032-1001-1000-1901</OPTION>
						<OPTION value="-66032-0000-1002-1901">-66032-0000-1002-1901</OPTION>
					</CFSELECT><BR />
					<COM>(Type Activity Number and Select an Account.)</COM>
				</TD>
                    <TD align="left" valign ="TOP">
					<CFIF #GetWorkRequests.INITAPPROVALDATE# EQ "">
                              <CFINPUT type="Text" name="INITAPPROVALDATE" id="INITAPPROVALDATE" value="" align="LEFT" required="No" size="10" maxlength="10" tabindex="16">
                              <SCRIPT language="JavaScript">
                                   new tcal ({'formname': 'WORKREQUEST','controlname': 'INITAPPROVALDATE'});
     
                              </SCRIPT><BR>
                              <COM>MM/DD/YYYYY </COM>
                         <CFELSE>
                              #DateFormat(GetWorkRequests.INITAPPROVALDATE, 'mm/dd/yyyy')#
                         </CFIF>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
<!--- 			
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="APPROVEDBYSUPID">Approved By Unit Head</LABEL></TH>
				<TH align="left" valign ="BOTTOM"><LABEL for="SUPAPPROVALDATE">Unit Head Approval Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="APPROVEDBYSUPID" id="APPROVEDBYSUPID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="FULLNAME" selected="#GetWorkRequests.APPROVEDBYSUPID#" required="No" tabindex="17"></CFSELECT>
				</TD>
				<TD align="left" valign ="TOP">
				<CFIF #GetWorkRequests.SUPAPPROVALDATE# EQ "">
					<CFINPUT type="Text" name="SUPAPPROVALDATE" id="SUPAPPROVALDATE" value="" align="LEFT" required="No" size="10" maxlength="10" tabindex="18">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'WORKREQUEST','controlname': 'SUPAPPROVALDATE'});

					</SCRIPT><BR>
					<COM>MM/DD/YYYYY </COM>
				<CFELSE>
					#DateFormat(GetWorkRequests.SUPAPPROVALDATE, 'mm/dd/yyyy')#
				</CFIF>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign ="BOTTOM"><LABEL for="SUPEMAILID">Unit Head's E-Mail</LABEL></TH>
			<CFIF #Client.ProcessFlag# EQ "Yes">
				<TH align="left" valign ="BOTTOM"><LABEL for="MGMTEMAILID">Management's E-Mail</LABEL></TH>
			</CFIF>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="SUPEMAILID" id="SUPEMAILID" size="1" query="ListSupApprovals" value="CUSTOMERID" display="SUPEMAIL" selected="#GetWorkRequests.SUPEMAILID#" required="No" tabindex="19"></CFSELECT>
				</TD>
			<CFIF #Client.ProcessFlag# EQ "Yes">
				<TD align="left" valign ="TOP">
					<CFSELECT name="MGMTEMAILID" id="MGMTEMAILID" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="MGMTEMAIL" selected="#GetWorkRequests.MGMTEMAILID#" required="No" tabindex="20"></CFSELECT>
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
					<CFSELECT name="APPROVEDBYMGMTID" id="APPROVEDBYMGMTID" size="1" query="ListMgmtApprovals" value="CUSTOMERID" display="FULLNAME" selected="#GetWorkRequests.APPROVEDBYMGMTID#" required="No" tabindex="21"></CFSELECT>
				</TD>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			
			<TR>
				<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
 --->
		</CFIF>
			<TR>
				<TD align="LEFT" colspan="2">
				<CFIF GetWorkRequests.KEYREQUEST EQ 'YES'>
					<INPUT type="submit" name="ProcessWorkRequests" value="MODIFY KEY/CARD REQUEST" tabindex="22" />&nbsp;&nbsp;<COM><--(Modifies info above & moves to 2nd screen.)</COM><BR /><BR /><BR />
				<CFELSEIF GetWorkRequests.MOVEREQUEST EQ 'YES'>
					<INPUT type="submit" name="ProcessWorkRequests" value="MODIFY MOVE REQUEST" tabindex="22" />&nbsp;&nbsp;<COM><--(Modifies info above & moves to 2nd screen.)</COM><BR /><BR /><BR />
				<CFELSEIF GetWorkRequests.MOVEREQUEST EQ 'NO' AND GetWorkRequests.TNSREQUEST EQ 'YES'>
					<INPUT type="submit" name="ProcessWorkRequests" value="MODIFY TNS PHONE REQUEST" tabindex="22" />&nbsp;&nbsp;<COM><--(Modifies info above & moves to 2nd screen.)</COM><BR /><BR /><BR />
				<CFELSE>
					<INPUT type="submit" name="ProcessWorkRequests" value="MODIFY OTHER REQUEST" tabindex="22" />&nbsp;&nbsp;<COM><--(Modifies info above & complete.)</COM><BR /><BR /><BR />
				</CFIF>
				</TD>
 
          <CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessWorkRequests" value="DELETE" tabindex="23" /></TD>
			</TR>
		</CFIF>

</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessWorkRequests" value="Cancel" tabindex="24" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
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