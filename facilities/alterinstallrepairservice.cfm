<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: alterinstallrepairservice.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/11/2012 --->
<!--- Date in Production: 02/11/2012 --->
<!--- Module: Facilities - Work Requests - Alteration, Installation, and Repair Service Submission --->
<!-- Last modified by John R. Pastori on 02/11/2012 using ColdFusion Studio. -->

<CFOUTPUT>
<CFSET SCREENPROGRAMNAME = "alterinstallrepairservice.cfm">
<CFSET RESPONSEPROGRAMNAME = "alterinstallrepairservice.cfm">
<CFSET REPORTTITLE = "Alteration, Installation, and Repair Service Submission">
<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/#SCREENPROGRAMNAME#">
<CFSET CONTENT_UPDATED = "February 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">


<HTML>
<HEAD>
	<TITLE>Facilities - Work Requests - #REPORTTITLE#</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	WR.WORKREQUESTID, WR.REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID,
			WR.REQUESTSTATUSID, RT.REQUESTTYPENAME, WR.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, WR.UNITID, WR.LOCATIONID, WR.ACCOUNTNUMBER1,
			WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3, WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION,
			WR.SUPEMAILID, WR.APPROVEDBYSUPID, WR.SUPAPPROVALDATE, WR.MGMTEMAILID, WR.APPROVEDBYMGMTID, WR.STARTDATE, WR.COMPLETIONDATE, WR.URGENCY, WR.TNSREQUEST,
			CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER AS KEYFINDER
	FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT
	WHERE	WR.REQUESTSTATUSID IN (1,7) AND
			WR.REQUESTTYPEID = 6 AND
			WR.REQUESTERID = CUST.CUSTOMERID AND
			WR.REQUESTTYPEID = RT.REQUESTTYPEID
	ORDER BY	CUST.FULLNAME, RT.REQUESTTYPENAME
</CFQUERY>

<CFIF NOT IsDefined('URL.LOOKUPWORKREQUESTID')>
	<CFSET CURSORFIELD = "document.LOOKUP.WORKREQUESTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.WORKREQUEST.department.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFIF NOT IsDefined("URL.LOOKUPWORKREQUESTID")>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Approved Work Request Lookup For <br> #REPORTTITLE#</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="LEFT">
	<CFIF ListWorkRequests.RecordCount IS "0">
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				<H4><u>No Approved Records were FOUND!</u></H4>
			</TH>
		</TR>
	</CFIF>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/index.cfm" method="POST">
				<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/facilities/#SCREENPROGRAMNAME#?LOOKUPWORKREQUESTID=FOUND" method="POST">
		<TR>
			<TH align="LEFT" nowrap><H4><LABEL for="WORKREQUESTID">*Approved Work Request Service Job:</LABEL></H4></TH>
			<TD>
				<CFSELECT name="WORKREQUESTID" id="WORKREQUESTID" size="1" query="ListWorkRequests" value="WORKREQUESTID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<INPUT type="submit" value="GO" tabindex="3" />
			</TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/index.cfm" method="POST">
				<INPUT type="submit" value="Cancel" tabindex="4" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
<CFELSE>
<!--- 
**************************************************************************************
* The following code generates the Facilities - Work Requests - #REPORTTITLE# Screen.*
**************************************************************************************
 --->

	<CFQUERY name="LookupWorkRequests" datasource="#application.type#FACILITIES">
		SELECT	WR.WORKREQUESTID, TO_CHAR(WR.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER,
				WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.REQUESTSTATUSID, RS.REQUESTSTATUSNAME,
				WR.REQUESTERID, WR.UNITID, WR.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER, WR.ACCOUNTNUMBER1, WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3,
				WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION, WR.SUPEMAILID, WR.APPROVEDBYSUPID, 
				TO_CHAR(WR.SUPAPPROVALDATE, 'MM/DD/YYYY') AS SUPAPPROVALDATE, WR.MGMTEMAILID, WR.APPROVEDBYMGMTID,
				TO_CHAR(WR.STARTDATE, 'MM/DD/YYYY') AS STARTDATE, TO_CHAR(WR.COMPLETIONDATE, 'MM/DD/YYYY') AS COMPLETIONDATE,
                    WR.URGENCY, WR.KEYREQUEST, WR.MOVEREQUEST, WR.TNSREQUEST
		FROM		WORKREQUESTS WR, REQUESTTYPES RT, REQUESTSTATUS RS, LOCATIONS LOC, BUILDINGNAMES BN
		WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#FORM.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WR.REQUESTSTATUSID = RS.REQUESTSTATUSID AND
				WR.LOCATIONID = LOC.LOCATIONID AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID
		ORDER BY	WR.REQUESTERID, RT.REQUESTTYPENAME
	</CFQUERY>

	<CFQUERY name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.UNITID, CUST.LOCATIONID, CUST.EMAIL, CUST.CAMPUSPHONE, 
				CUST.SECONDCAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE, CUST.NUMBERLISTED,
				CUST.UNITHEAD, CUST.DEPTCHAIR
		FROM		CUSTOMERS CUST
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#LookupWorkRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA">
		SELECT	UNITS.UNITID, UNITS.UNITNAME, CAMPUSMAILCODES.CAMPUSMAILCODE, GROUPS.GROUPNAME, 
				DEPARTMENTS.DEPARTMENTNAME, UNITS.UNITNAME || ' - ' || GROUPS.GROUPNAME AS UNITGROUP
		FROM		UNITS, CAMPUSMAILCODES, GROUPS, DEPARTMENTS
		WHERE	UNITS.UNITID = <CFQUERYPARAM value="#LookupRequesters.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
				UNITS.CAMPUSMAILCODEID = CAMPUSMAILCODES.CAMPUSMAILCODEID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				UNITS.DEPARTMENTID = DEPARTMENTS.DEPARTMENTID
		ORDER BY	UNITS.UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupAlternateContacts" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, EMAIL, LASTNAME, FIRSTNAME, FULLNAME, EMAIL, CAMPUSPHONE, UNITHEAD, DEPTCHAIR
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupWorkRequests.ALTERNATECONTACTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>
	
	<CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
		SELECT	BUILDINGNAMEID, BUILDINGNAME
		FROM		BUILDINGNAMES
		ORDER BY	BUILDINGNAME
	</CFQUERY>

	<A name="top"></A>
	<!-- BEGIN: MAIN CONTENT TABLE -->
<TABLE width="100%" align="center" border="3" cellpadding="0" cellspacing="0">
	<TR>
		<TH align="CENTER" colspan="2">
			<H1>#REPORTTITLE#</H1>
		</TH>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center"><H4>Red * fields are required!</H4></TH>
	</TR>
	<TR>
		<TH align="center">Work Request Sequence Number: &nbsp;&nbsp; #LookupWorkRequests.WORKREQUESTNUMBER# &nbsp;&nbsp;Request Date:&nbsp;&nbsp;#DateFormat(LookupWorkRequests.REQUESTDATE, "mm/dd/yyyy")#</TH>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/#SCREENPROGRAMNAME#">
			<INPUT type="submit" value="Cancel" tabindex="1" />
</CFFORM>
		</TD>
	</TR>
</TABLE>

<CFFORM name="WORKREQUEST" action="/#application.type#apps/facilities/#RESPONSEPROGRAMNAME#" method="post">
	<FIELDSET>
	<LEGEND>Requester Information</LEGEND>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
		<TD align="LEFT" WIDTH="50%"><FONT color="Red">*</FONT><LABEL for="department"> Requesting Department:</LABEL></TD>
		<TD align="LEFT" WIDTH="50%">
			<CFSELECT name="department" id="department" tabindex="2">
				<OPTION value="">Please Select a Department</OPTION>
				<OPTION selected value="604">Library and Information Access</OPTION>
				<OPTION value="605">Library Development</OPTION>
			</CFSELECT>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;&nbsp;&nbsp;Are you the account manager for this department?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
		<CFIF LookupRequesters.UNITHEAD EQ 'YES' OR LookupRequesters.DEPTCHAIR EQ 'YES'>
			<LABEL for="account_manager1" class="LABEL_hidden">Yes, I am the Account Manger</LABEL>
			<CFINPUT type="radio" name="account_manager" id="account_manager1" checked="Yes" value="yes" tabindex="3">&nbsp;Yes&nbsp;&nbsp;
			<LABEL for="account_manager2" class="LABEL_hidden">No, I am not the Account Manger</LABEL>
			<CFINPUT type="radio" name="account_manager" id="account_manager2" value="no" tabindex="4">&nbsp;No
		<CFELSE>
			<LABEL for="account_manager1" class="LABEL_hidden">Yes, I am the Account Manger</LABEL>
			<CFINPUT type="radio" name="account_manager" id="account_manager1" value="yes" tabindex="3">&nbsp;Yes&nbsp;&nbsp;
			<LABEL for="account_manager2" class="LABEL_hidden">No, I am not the Account Manger</LABEL>
			<CFINPUT type="radio" name="account_manager" id="account_manager2" checked="Yes" value="no" tabindex="4">&nbsp;No
		</CFIF>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT><LABEL for="requestor_first_name"> Requester's First Name:</LABEL></TD>
		<TD align="LEFT" WIDTH="50%">
			<CFINPUT type="text" name="requestor_first_name" id="requestor_first_name" value="#LookupRequesters.FIRSTNAME#" size="25" maxlength="30" tabindex="5">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT> <LABEL for="requestor_last_name">Requester's Last Name:</LABEL></TD>
		<TD align="LEFT" WIDTH="50%">
			<CFINPUT type="text" name="requestor_last_name" id="requestor_last_name" value="#LookupRequesters.LASTNAME#" size="25" maxlength="30" tabindex="6">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT> Phone Number:</TD>
		<TD align="LEFT" WIDTH="50%">
			<LABEL for="requestor_phone1" class="LABEL_hidden">Requester Phone Number 1</LABEL>
			<CFINPUT type="text" name="requestor_phone1" id="requestor_phone1" value="" size="3" maxlength="3" tabindex="7">
			<LABEL for="requestor_phone2" class="LABEL_hidden">Requester Phone Number 2</LABEL>
			<CFINPUT type="text" name="requestor_phone2" id="requestor_phone2" value="" size="8" maxlength="8" tabindex="8">
			<LABEL for="requestor_phone_ext" class="LABEL_hidden">Requester Phone Extension</LABEL>
			<CFINPUT type="text" name="requestor_phone_ext" id="requestor_phone_ext" value="#LookupRequesters.CAMPUSPHONE#" size="5" maxlength="5" tabindex="9"><BR />
			<COM>Please INPUT telephone number or extension</COM>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT><LABEL for="requestor_email"> Email:</LABEL></TD>
		<TD align="LEFT"  WIDTH="50%">
			<CFINPUT type="text" name="requestor_email" id="requestor_email" value="#LookupRequesters.EMAIL#" size="25" maxlength="30" tabindex="10">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;&nbsp;<LABEL for="requestor_mail_code"> Mail Code:</LABEL></TD>
		<TD align="LEFT" WIDTH="50%">
			<CFINPUT type="text" name="requestor_mail_code" id="requestor_mail_code" value="#LookupUnits.CAMPUSMAILCODE#" size="25" maxlength="30" tabindex="11">
		</TD>
	</TR>
</TABLE>
	</FIELDSET>
	<FIELDSET>
	<LEGEND>Alternate Contact</LEGEND>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT> <LABEL for="alternate_requestor_first_name">Contact's First Name:</LABEL></TD>
		<TD align="LEFT" WIDTH="50%">
			<CFINPUT type="text" name="alternate_requestor_first_name" id="alternate_requestor_first_name" value="#LookupAlternateContacts.FIRSTNAME#" size="25" maxlength="30" tabindex="12">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT> <LABEL for="alternate_requestor_last_name">Contact's Last Name:</LABEL></TD>
		<TD align="LEFT" WIDTH="50%">
			<CFINPUT type="text" name="alternate_requestor_last_name" id="alternate_requestor_last_name" value="#LookupAlternateContacts.LASTNAME#" size="25" maxlength="30" tabindex="13">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT> Phone Number:</TD>
		<TD align="LEFT" WIDTH="50%">
			<LABEL for="alternate_requestor_phone1" class="LABEL_hidden">Alternate Phone Number 1</LABEL>
			(
			<CFINPUT type="text" name="alternate_requestor_phone1" id="alternate_requestor_phone1" value="" size="3" maxlength="3" class="form" tabindex="14">
			)
			<LABEL for="alternate_requestor_phone2" class="LABEL_hidden">Alternate Phone Number 2</LABEL>
			<CFINPUT type="text" name="alternate_requestor_phone2"id="alternate_requestor_phone2"  value="" size="8" maxlength="8" class="form" tabindex="15">
			<LABEL for="alternate_requestor_phone_ext" class="LABEL_hidden">Alternate Phone Extension</LABEL>
			<CFINPUT type="text" name="alternate_requestor_phone_ext" id="alternate_requestor_phone_ext" value="#LookupAlternateContacts.CAMPUSPHONE#" size="5" maxlength="5" class="form" tabindex="16"><BR />
			<COM>Please INPUT telephone number or extension</COM>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT><LABEL for="alternate_requestor_email"> Email:</LABEL></TD>
		<TD align="LEFT" WIDTH="50%">
			<CFINPUT type="text" name="alternate_requestor_email" id="alternate_requestor_email" value="#LookupAlternateContacts.EMAIL#" size="25" maxlength="30" tabindex="17">
		</TD>
	</TR>
</TABLE>
	</FIELDSET>
	<FIELDSET>
	<LEGEND>Billing Information</LEGEND>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
		<TD align="LEFT" valign="top" colspan="2">
			<COM><I>An account number is required. If you are not the account manager, please obtain the account number and his/her approval prior to submitting your request.</I></COM>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;&nbsp; Choose type of account number:</TD>
		<TD align="LEFT" WIDTH="50%">
			<CFINPUT type="radio" name="account_number" id="stateaccount" checked tabindex="18" value="state">

			<LABEL for="stateaccount">State</LABEL>
			<CFINPUT type="radio" name="account_number" id="nonstateaccount" tabindex="19" value="non-state">
			<LABEL for="nonstateaccount">Non-State</LABEL><BR />
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" colspan="2"><FONT color="Red">*</FONT> State Account Number:</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="bottom" colspan="2">
			&nbsp;&nbsp;&nbsp;<LABEL for="requestor_state_account_number1">ORG</LABEL>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="requestor_state_account_number2">ACTY</LABEL>
			&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="requestor_state_account_number3">NACCT</LABEL>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="requestor_state_account_number4">ENDVR</LABEL>
			&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="requestor_state_account_number5">FUND</LABEL>
			&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="requestor_state_account_number6">FUNC</LABEL>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="requestor_state_account_number7">UNUSED</LABEL>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2">
			&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number1" id="requestor_state_account_number1" value="#Left(LookupWorkRequests.ACCOUNTNUMBER1, 5)#" size="5" maxlength="5" tabindex="20">
			&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number2" id="requestor_state_account_number2" value="#LookupWorkRequests.ACCOUNTNUMBER2#" size="3" maxlength="3" tabindex="21">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number3" id="requestor_state_account_number3" value="#Mid(LookupWorkRequests.ACCOUNTNUMBER3, 2,5)#" size="5" maxlength="5" tabindex="22">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number4" id="requestor_state_account_number4" value="#Mid(LookupWorkRequests.ACCOUNTNUMBER3, 8, 4)#" size="4" maxlength="4" tabindex="23">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number5" id="requestor_state_account_number5" value="#Mid(LookupWorkRequests.ACCOUNTNUMBER3, 13, 4)#" size="4" maxlength="4" tabindex="24">
			&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number6" id="requestor_state_account_number6" value="#Right(LookupWorkRequests.ACCOUNTNUMBER3, 4)#" size="4" maxlength="4" tabindex="25">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number7" id="requestor_state_account_number7" value="0000" size="4" maxlength="4" tabindex="26">
		</TD>
	</TR>
	<TR>
		<TH align="LEFT" valign="top" colspan="2">or</TH>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT><LABEL for="ROOMNUMBER"> Non-State Account Number:</LABEL></TD>
		<TD align="LEFT" WIDTH="50%">
			<CFINPUT type="text" name="requestor_non_state_account_number" id="SUPERVISOREMAILID" value="" size="40" maxlength="40" tabindex="27">
		</TD>
	</TR>
</TABLE>
	</FIELDSET>
	<FIELDSET>
	<LEGEND>General Service Request Information</LEGEND>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%"><FONT color="Red">*</FONT><LABEL for="building_name_location">Building Name or Location:</LABEL></TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
			<CFINPUT type="text" name="building_name_location" id="building_name_location" value="#LookupWorkRequests.BUILDINGNAME#" size="25" maxlength="30" tabindex="28">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%"><LABEL for="building_room_number">Room Number:</LABEL></TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
			<CFINPUT type="text" name="building_room_number" id="building_room_number" value="#LookupWorkRequests.ROOMNUMBER#" size="25" maxlength="30" tabindex="29">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Desired Start Date<BR />&nbsp;<COM>(Subject to worker availability):</COM></TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
			<LABEL for="start_date_month" class="LABEL_hidden">Desired Start Date Month</LABEL>
			<LABEL for="start_date_day" class="LABEL_hidden">Desired Start Date Day</LABEL>
			<LABEL for="start_date_year" class="LABEL_hidden">Desired Start Date Year</LABEL>
			<CFINPUT type="text" name="start_date_month" id="start_date_month" value="#DateFormat(LookupWorkRequests.STARTDATE, "MM")#" size="2" maxlength="2" tabindex="30">
			/
			<CFINPUT type="text" name="start_date_day" id="start_date_day" value="#DateFormat(LookupWorkRequests.STARTDATE, "DD")#" size="2" maxlength="2" tabindex="31">
			/
			<CFINPUT type="text" name="start_date_year" id="start_date_year" value="#DateFormat(LookupWorkRequests.STARTDATE, "YYYY")#"  size="4" maxlength="4" tabindex="32">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Desired Completion Date<BR />&nbsp;<COM>(Subject to worker availability):</COM></TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
			<LABEL for="completion_date_month" class="LABEL_hidden">Desired Completion Date Month</LABEL>
			<LABEL for="completion_date_day" class="LABEL_hidden">Desired Completion Date Day</LABEL>
			<LABEL for="completion_date_year" class="LABEL_hidden">Desired Completion Date Year</LABEL>
			<CFINPUT type="text" name="completion_date_month" id="completion_date_month" value="#DateFormat(LookupWorkRequests.COMPLETIONDATE, "MM")#" size="2" maxlength="2" tabindex="33">
			/	
			<CFINPUT type="text" name="completion_date_day" id="completion_date_day" value="#DateFormat(LookupWorkRequests.COMPLETIONDATE, "DD")#"  size="2" maxlength="2" tabindex="34">
			/	
			<CFINPUT type="text" name="completion_date_year" id="completion_date_year" value="#DateFormat(LookupWorkRequests.COMPLETIONDATE, "YYYY")#" size="4" maxlength="4" tabindex="35">
		</TD>
	</TR>
	<TR>
		<TD  align="LEFT" valign="top" colspan="2"><LABEL for="completion_date_month">&nbsp;Please specify any restrictions on hours of work:</LABEL></TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" colspan="2">
			<TEXTAREA name="restrictions" id="completion_date_month" cols="40" rows="5" tabindex="36"> </TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will departmental operations require that work be <BR>&nbsp;accomplished while space is fully occupied?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
			<LABEL for="space_occupied1" class="LABEL_hidden">Will departmental operations require that work be accomplished while space is fully occupied? - YES</LABEL>
			<CFINPUT type="radio" name="space_occupied" id="space_occupied1" value="yes" tabindex="37">&nbsp;Yes &nbsp;&nbsp;
			<LABEL for="space_occupied2" class="LABEL_hidden">Will departmental operations require that work be accomplished while space is fully occupied? - NO</LABEL>
			<CFINPUT type="radio" name="space_occupied" id="space_occupied2" value="no" checked tabindex="38">&nbsp;No
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" colspan="2"><FONT color="Red">*</FONT> <LABEL for="work_scope">Scope of Work (as much detail as possible)</LABEL></TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" colspan="2">
		<TEXTAREA name="work_scope" id="work_scope" cols="40" rows="5" tabindex="39">#LookupWorkRequests.PROBLEMDESCRIPTION#</TEXTAREA>
	</TD>
	</TR>
</TABLE>
	</FIELDSET>
	<FIELDSET>
	<LEGEND>Detailed Service Request Information</LEGEND>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will space use be changing?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="space_use_changing1" class="LABEL_hidden">Will space use be changing? - YES</LABEL>
				<CFINPUT type="radio" name="space_use_changing" id="space_use_changing1" value="yes" tabindex="40">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="space_use_changing2" class="LABEL_hidden">Will space use be changing? - NO</LABEL>
				<CFINPUT type="radio" name="space_use_changing" id="space_use_changing2" value="no" checked tabindex="41">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="space_use_changing3" class="LABEL_hidden">Will space use be changing? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="space_use_changing" id="space_use_changing3" value="don't know" tabindex="42">&nbsp;Do not know
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will special equipment be installed?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="special_equipment_installed1" class="LABEL_hidden">Will special equipment be installed? - YES</LABEL>
				<CFINPUT type="radio" name="special_equipment_installed" id="special_equipment_installed1" value="yes" tabindex="43">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="special_equipment_installed2" class="LABEL_hidden">Will special equipment be installed? - NO</LABEL>
				<CFINPUT type="radio" name="special_equipment_installed" id="special_equipment_installed2" value="no" checked tabindex="44">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="special_equipment_installed3" class="LABEL_hidden">Will special equipment be installed? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="special_equipment_installed" id="special_equipment_installed3" value="don't know" tabindex="45">&nbsp;Do not know
		</TD>
	</TR>
	<TR>

		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will moving of furniture be required?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="move_furniture_required1" class="LABEL_hidden">Will moving of furniture be required? - YES</LABEL>
				<CFINPUT type="radio" name="move_furniture_required" id="move_furniture_required1" value="yes" tabindex="46">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="move_furniture_required2" class="LABEL_hidden">Will moving of furniture be required? - NO</LABEL>
				<CFINPUT type="radio" name="move_furniture_required" id="move_furniture_required2" value="no" checked tabindex="47">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="move_furniture_required3" class="LABEL_hidden">Will moving of furniture be required? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="move_furniture_required" id="move_furniture_required3" value="don't know" tabindex="48">&nbsp;Do not know
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will built-in furnishings be required?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="built_in_furnishings1" class="LABEL_hidden">Will built-in furnishings be required? - YES</LABEL>
				<CFINPUT type="radio" name="built_in_furnishings" id="built_in_furnishings1" value="yes" tabindex="49">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="built_in_furnishings2" class="LABEL_hidden">Will built-in furnishings be required? - NO</LABEL>
				<CFINPUT type="radio" name="built_in_furnishings" id="built_in_furnishings2" value="no" checked tabindex="50">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="built_in_furnishings3" class="LABEL_hidden">Will built-in furnishings be required? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="built_in_furnishings" id="built_in_furnishings3" value="don't know" tabindex="51">&nbsp;Do not know
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will carpet or special finishes be required?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="carpet_or_finishes1" class="LABEL_hidden">Will carpet or special finishes be required? - YES</LABEL>
				<CFINPUT type="radio" name="carpet_or_finishes" id="carpet_or_finishes1" value="yes" tabindex="52">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="carpet_or_finishes2" class="LABEL_hidden">Will carpet or special finishes be required? - NO</LABEL>
				<CFINPUT type="radio" name="carpet_or_finishes" id="carpet_or_finishes2" value="no" checked tabindex="53">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="carpet_or_finishes2" class="LABEL_hidden">Will carpet or special finishes be required? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="carpet_or_finishes" id="carpet_or_finishes3" value="don't know" tabindex="54">&nbsp;Do not know
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will you need installation of telephones, <BR>&nbsp;data, network, fax machine, or copier?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="phone_installation1" class="LABEL_hidden">Will you need installation of telephones, data, network, fax machine, or copier? - YES</LABEL>
				<CFINPUT type="radio" name="phone_installation" id="phone_installation1" value="yes" tabindex="55">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="phone_installation2" class="LABEL_hidden">Will you need installation of telephones, data, network, fax machine, or copier? - NO</LABEL>
				<CFINPUT type="radio" name="phone_installation" id="phone_installation2" value="no" checked tabindex="56">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="phone_installation3" class="LABEL_hidden">Will you need installation of telephones, data, network, fax machine, or copier? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="phone_installation" id="phone_installation3" value="don't know" tabindex="57">&nbsp;Do not know
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will card access or alarms be required?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="card_access1" class="LABEL_hidden">Will card access or alarms be required? - YES</LABEL>
				<CFINPUT type="radio" name="card_access" id="card_access1" value="yes" tabindex="58">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="card_access2" class="LABEL_hidden">Will card access or alarms be required? - NO</LABEL>
				<CFINPUT type="radio" name="card_access" id="card_access2" value="no" checked tabindex="59">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="card_access3" class="LABEL_hidden">Will card access or alarms be required? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="card_access" id="card_access3" value="don't know" tabindex="60">&nbsp;Do not know
		</TD>
	</TR>
		<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Do special temperature requirements exist?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="special_temperature1" class="LABEL_hidden">Do special temperature requirements exist? - YES</LABEL>
				<CFINPUT type="radio" name="special_temperature" id="special_temperature1" value="yes" tabindex="61">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="special_temperature2" class="LABEL_hidden">Do special temperature requirements exist? - NO</LABEL>
				<CFINPUT type="radio" name="special_temperature" id="special_temperature2" value="no" checked tabindex="62">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="special_temperature3" class="LABEL_hidden">Do special temperature requirements exist? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="special_temperature" id="special_temperature3" value="don't know" tabindex="63">&nbsp;Do not know
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Will special plumbing/electrical work be required?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="special_plumbing1" class="LABEL_hidden">Will special plumbing/electrical work be required? - YES</LABEL>
				<CFINPUT type="radio" name="special_plumbing" id="special_plumbing1" value="yes" tabindex="64">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="special_plumbing2" class="LABEL_hidden">Will special plumbing/electrical work be required? - NO</LABEL>
				<CFINPUT type="radio" name="special_plumbing" id="special_plumbing2" value="no" checked tabindex="65">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="special_plumbing3" class="LABEL_hidden">Will special plumbing/electrical work be required? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="special_plumbing" id="special_plumbing3" value="don't know" tabindex="66">&nbsp;Do not know
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" WIDTH="50%">&nbsp;Are there any ADA issues?</TD>
		<TD align="LEFT" valign="top" WIDTH="50%">
				<LABEL for="ada_issues1" class="LABEL_hidden">Are there any ADA issues? - YES</LABEL>
				<CFINPUT type="radio" name="ada_issues" id="ada_issues1" value="yes" tabindex="67">&nbsp;Yes &nbsp;&nbsp;
				<LABEL for="ada_issues2" class="LABEL_hidden">Are there any ADA issues? - NO</LABEL>
				<CFINPUT type="radio" name="ada_issues" id="ada_issues2" value="no" checked tabindex="68">&nbsp;No &nbsp;&nbsp;<BR />
				<LABEL for="ada_issues3" class="LABEL_hidden">Are there any ADA issues? - DO NOT KNOW</LABEL>
				<CFINPUT type="radio" name="ada_issues" id="ada_issues3" value="don't know" tabindex="69">&nbsp;Do not know
		</TD>
	</TR>
</TABLE>
	</FIELDSET>
	<FIELDSET>
	<LEGEND>Attach Specifications</LEGEND>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
		<TD align="LEFT" valign="top" colspan="2">
			<LABEL for="upload_file">
			Please attach documents detailing specific needs (i.e. drawings, graphics, and equipment specifications). We accept documents in the following formats .xls, .doc, .pdf, .txt, jpeg, and gif. Click browse to choose and add a file from your local hard drive.<BR /></LABEL>
			<INPUT type="file" name="upload_file" id="upload_file" size="50" tabindex="70" />
		</TD>
	</TR>
</TABLE>
	</FIELDSET>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
		<TD align="LEFT" valign="top" colspan="2">
			<INPUT type="submit" name="Submit" value="Submit" tabindex="71" />
		</TD>
	</TR>
</TABLE>
</CFFORM>
<TABLE width="100%" align="LEFT" border="0">
	<TR>
		<TD align="LEFT" valign="top" colspan="2">
<CFFORM action="/#application.type#apps/facilities/#SCREENPROGRAMNAME#">
			<INPUT type="submit" value="Cancel" tabindex="72" />
</CFFORM>
		</TD>
	</TR>
</TABLE>
<!-- END: MAIN CONTENT TABLE -->
</CFIF>

</BODY>
</HTML>
</CFOUTPUT>