<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: surplusitemsdisposalservice.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/11/2012 --->
<!--- Date in Production: 02/11/2012 --->
<!--- Module: Facilities - Work Requests - Surplus Items for Disposal Service Submission --->
<!-- Last modified by John R. Pastori on 02/11/2012 using ColdFusion Studio. -->

<CFOUTPUT>
<CFSET SCREENPROGRAMNAME = "surplusitemsdisposalservice.cfm">
<CFSET RESPONSEPROGRAMNAME = "surplusitemsdisposalservice.cfm">
<CFSET REPORTTITLE = "Surplus Items for Disposal Service Submission">
<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/#SCREENPROGRAMNAME#">
<CFSET CONTENT_UPDATED = "February 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">


<HTML xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<HEAD>
	<TITLE>Facilities - Work Requests - #REPORTTITLE#</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!--- <script src="../../javascript/global_functions_level2.js" language="JavaScript" type="text/javascript"></script>
<script src="../../javascript/print_css_level2.js" language="JavaScript" type="text/javascript"></script>
<script src="../../cms/globals/script/global_functions.js" language="JavaScript" type="text/javascript"></script>
<script src="../../javascript/formcheck.js" language="JavaScript" type="text/javascript"></script>	 --->

	<SCRIPT language="JavaScript" type="text/javascript">
			set_variables('department','blank','Requesting Department','');
			set_variables('requestor_first_name','blank','First Name of Requester','');
			set_variables('requestor_last_name','blank','Last Name of Requester','');
			set_variables('requestor_phone1','Minimum Length','Area Code 3 digits','3');
			set_variables('requestor_phone2','Minimum Length','Phone 7 digits','7');
			set_variables('requestor_phone_ext','Minimum Length','Extension 5 digits','5');
			set_variables('requestor_email','Email','Email','');
			set_variables('alternate_requestor_first_name','blank','First Name of Alternate Contact','');
			set_variables('alternate_requestor_last_name','blank','Last Name of Alternate Contact','');
			set_variables('alternate_requestor_phone1','Minimum Length','Area Code 3 digits','3');
			set_variables('alternate_requestor_phone2','Minimum Length','Phone 7 digits','7');
			set_variables('alternate_requestor_phone_ext','Minimum Length','Extension 5 digits','5');
			set_variables('alternate_requestor_email','Email','Alternate Email','');
			set_variables('account_number','','State or Non-State Account Number','');
			set_variables('requestor_state_account_number1','Minimum Length','State Account Number 1','5');
			set_variables('requestor_state_account_number2','Minimum Length','State Account Number 2','3');
			set_variables('requestor_state_account_number3','Minimum Length','State Account Number 3','5');
			set_variables('requestor_state_account_number4','Minimum Length','State Account Number 4','4');
			set_variables('requestor_state_account_number5','Minimum Length','State Account Number 5','4');
			set_variables('requestor_state_account_number6','Minimum Length','State Account Number 6','4');
			set_variables('requestor_state_account_number7','Minimum Length','State Account Number 7','4');
			set_variables('requestor_non_state_account_number','','Non-State Account Number','');
	</SCRIPT>
</HEAD>

<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	WR.WORKREQUESTID, WR.REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID, MR.MOVEREQUESTWRID, MR.MOVETYPEID,
			MT.MOVETYPENAME, WR.REQUESTSTATUSID, RT.REQUESTTYPENAME, WR.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, WR.UNITID, WR.LOCATIONID,
			WR.ACCOUNTNUMBER1, WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3, WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION,
			WR.SUPEMAILID, WR.APPROVEDBYSUPID, WR.SUPAPPROVALDATE, WR.MGMTEMAILID, WR.APPROVEDBYMGMTID, WR.STARTDATE, WR.COMPLETIONDATE, WR.URGENCY, WR.TNSREQUEST,
			CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER || ' - ' || MT.MOVETYPENAME AS KEYFINDER
	FROM		WORKREQUESTS WR, MOVEREQUESTS MR, LIBSHAREDDATAMGR.CUSTOMERS CUST, MOVETYPES MT, REQUESTTYPES RT
	WHERE	WR.REQUESTSTATUSID IN (1,7) AND
			WR.REQUESTTYPEID = 4 AND
			WR.WORKREQUESTID = MR.MOVEREQUESTWRID AND
			MR.MOVETYPEID = 7 AND
			MR.MOVETYPEID = MT.MOVETYPEID AND
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
				<CFSELECT name="WORKREQUESTID" id="WORKREQUESTID" size="1" query="ListWorkRequests" value="WORKREQUESTID" display="KEYFINDER"required="No" tabindex="2"></CFSELECT>
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
				WR.REQUESTERID, WR.UNITID, WR.LOCATIONID, WR.ACCOUNTNUMBER1, WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3,
				WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION, WR.SUPEMAILID, WR.APPROVEDBYSUPID, 
				TO_CHAR(WR.SUPAPPROVALDATE, 'MM/DD/YYYY') AS SUPAPPROVALDATE, WR.MGMTEMAILID, WR.APPROVEDBYMGMTID,
				TO_CHAR(WR.STARTDATE, 'MM/DD/YYYY') AS STARTDATE, TO_CHAR(WR.COMPLETIONDATE, 'MM/DD/YYYY') AS COMPLETIONDATE,
                    WR.URGENCY, WR.KEYREQUEST, WR.MOVEREQUEST, WR.TNSREQUEST
		FROM		WORKREQUESTS WO, REQUESTTYPES RT, REQUESTSTATUS RS
		WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#FORM.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WR.REQUESTSTATUSID = RS.REQUESTSTATUSID
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

	<CFQUERY name="LookupMoveRequests" datasource="#application.type#FACILITIES">
		SELECT	MR.MOVEREQUESTID, MR.MOVEREQUESTWRID, MR.MOVETYPEID, MT.MOVETYPENAME, MR.ITEMDESCRIPTION, MR.STATENUMBER,
				MR.PICKUPDATE, MR.DELIVERYDATE, MR.NUMBEROFBOXES, MR.NUMBEROFCHAIRS, MR.NUMBEROFTABLES, MR.ESTIMATEONLY,
				MR.FROMROOMID, FROMBN.BUILDINGNAME || ' - ' || FROMLOC.ROOMNUMBER AS CURRENTLOCATION, MR.FROMJACKNUMBERID,
				FROMWJ.WALLDIRECTION || ' - ' || FROMWJ.JACKNUMBER || ' - ' || FROMWJ.PORTNUMBER AS FROMJACK,
				MR.TOROOMID, TOBN.BUILDINGNAME  || ' - ' || TOLOC.ROOMNUMBER AS DESTINATION, MR.TOJACKNUMBERID,
				TOWJ.WALLDIRECTION || ' - ' || TOWJ.JACKNUMBER || ' - ' || TOWJ.PORTNUMBER AS TOJACK
		FROM		MOVEREQUESTS MR, MOVETYPES MT, LOCATIONS FROMLOC, BUILDINGNAMES FROMBN, WALLJACKS FROMWJ, LOCATIONS TOLOC, BUILDINGNAMES TOBN, WALLJACKS TOWJ
		WHERE	MR.MOVEREQUESTWRID = <CFQUERYPARAM value="#LookupWorkRequests.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				MR.MOVETYPEID = MT.MOVETYPEID AND
				MR.FROMROOMID = FROMLOC.LOCATIONID AND
				FROMLOC.BUILDINGNAMEID = FROMBN.BUILDINGNAMEID AND
				MR.FROMJACKNUMBERID = FROMWJ.WALLJACKID AND
				MR.TOROOMID = TOLOC.LOCATIONID AND
				TOLOC.BUILDINGNAMEID = TOBN.BUILDINGNAMEID AND
				MR.TOJACKNUMBERID = TOWJ.WALLJACKID
		ORDER BY	MR.MOVEREQUESTWRID, MR.MOVEREQUESTID
	</CFQUERY>

	<A name="top"></A>
	<!-- BEGIN: MAIN CONTENT TABLE -->
<TABLE width="100%" border="3" cellpadding="0" cellspacing="0">
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
</TABLE>
<TABLE width="100%" border="0">
	<TR>
		<TD  align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/#SCREENPROGRAMNAME#" method="POST">
			<INPUT type="submit" value="Cancel" tabindex="1" />
</CFFORM>
		</TD>
	</TR>
<CFFORM name="WORKREQUEST" action="/#application.type#apps/facilities/#RESPONSEPROGRAMNAME#" method="post" onsubmit="return check_form(this);">
	<TR>
		<TH align="LEFT" colspan="2">
			<H2>Requester Information</H2>
		</TH>
	</TR>
	<TR>
		<TD align="LEFT"><FONT color="Red">*</FONT> Requesting Department:</TD>
		<TD align="LEFT">
			<CFSELECT name="department" class="form" tabindex="2">
				<OPTION value="0">Please Select a Department</OPTION>
				<OPTION selected value="604">Library and Information Access</OPTION>
				<OPTION value="605">Library Development</OPTION>
			</CFSELECT>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top">&nbsp;&nbsp; Are you the account manager<BR />&nbsp;&nbsp; for this department?</TD>
		<TD align="LEFT" valign="top">
		<CFIF LookupRequesters.UNITHEAD EQ 'YES' OR LookupRequesters.DEPTCHAIR EQ 'YES'>
			<CFINPUT type="radio" name="account_manager" checked="Yes" value="yes" tabindex="3">&nbsp;Yes&nbsp;&nbsp;
			<CFINPUT type="radio" name="account_manager" value="no" tabindex="4">&nbsp;No
		<CFELSE>
			<CFINPUT type="radio" name="account_manager" value="yes" tabindex="3">&nbsp;Yes&nbsp;&nbsp;
			<CFINPUT type="radio" name="account_manager" checked="Yes" value="no" tabindex="4">&nbsp;No
		</CFIF>
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Requester's First Name:</TD>
		<TD align="LEFT">
			<CFINPUT type="text" name="requestor_first_name" value="#LookupRequesters.FIRSTNAME#" size="25" maxlength="30" tabindex="5">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Requester's Last Name:</TD>
		<TD align="LEFT">
			<CFINPUT type="text" name="requestor_last_name" value="#LookupRequesters.LASTNAME#" size="25" maxlength="30" tabindex="6">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Phone Number:</TD>
		<TD align="LEFT">
			<CFINPUT type="text" name="requestor_phone1" value="" size="3" maxlength="3" class="form" tabindex="7"
				onKeyPress="return numbersOnly(this, event)" title="Area Code contains only digits"
				onClick="unset_variables('requestor_phone_ext',document.forms[1]);
				reset_variables('requestor_phone1',document.forms[1],'Minimum Length','Area Code 3 digits','3');
				reset_variables('requestor_phone2',document.forms[1],'Minimum Length','Phone 7 digits','7');">
		
			<CFINPUT type="text" name="requestor_phone2" value="" size="8" maxlength="8" class="form" tabindex="8"
				onKeyPress="return numbersOnly(this, event)" title="Phone Number contains only digits"
				onClick="unset_variables('requestor_phone_ext',document.forms[1]);
				reset_variables('requestor_phone1',document.forms[1],'Minimum Length','Area Code 3 digits','3');
				reset_variables('requestor_phone2',document.forms[1],'Minimum Length','Phone 7 digits','7');">
		
			<CFINPUT type="text" name="requestor_phone_ext" value="#LookupRequesters.CAMPUSPHONE#" size="5" maxlength="5" class="form" tabindex="9"
				onKeyPress="return numbersOnly(this, event)" title="Extension contains only digits" 
				onClick="unset_variables('requestor_phone1',document.forms[1]); 
				unset_variables('requestor_phone2',document.forms[1]); 
				reset_variables('requestor_phone_ext',document.forms[1],'Minimum Length','Extension 5 digits','5');">
			<BR /><COM>Please input telephone number or extension</COM>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Email:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="requestor_email" value="#LookupRequesters.EMAIL#" size="25" maxlength="30" tabindex="10">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top">&nbsp;&nbsp; Mail Code:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="requestor_mail_code" value="#LookupUnits.CAMPUSMAILCODE#" size="25" maxlength="30" tabindex="11">
		</TD>
	</TR>
	<TR>
		<TH align="LEFT" valign="top" colspan="2">
			<H2>Alternate Contact<H2> 
		</H2></H2></TH>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Contact's First Name:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="alternate_requestor_first_name" value="#LookupAlternateContacts.FIRSTNAME#" size="25" maxlength="30" tabindex="12">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Contact's Last Name:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="alternate_requestor_last_name" value="#LookupAlternateContacts.LASTNAME#" size="25" maxlength="30" tabindex="13">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Phone Number:</TD>
		<TD align="LEFT" >
			(
			<CFINPUT type="text" name="alternate_requestor_phone1" value="" size="3" maxlength="3" class="form" tabindex="14" 
				onKeyPress="return numbersOnly(this, event)" title="Area Code contains only digits" 
				onClick="unset_variables('alternate_requestor_phone_ext',document.forms[1]); 
				reset_variables('alternate_requestor_phone1',document.forms[1],'Minimum Length','Area Code 3 digits','3'); 
				reset_variables('alternate_requestor_phone2',document.forms[1],'Minimum Length','Phone 7 digits','7');">
			)
			<CFINPUT type="text" name="alternate_requestor_phone2" value="" size="8" maxlength="8" class="form" tabindex="15"
				onKeyPress="return numbersOnly(this, event)" title="Phone Number contains only digits" 
				onClick="unset_variables('alternate_requestor_phone_ext',document.forms[1]); 
				reset_variables('alternate_requestor_phone1',document.forms[1],'Minimum Length','Area Code 3 digits','3'); 
				reset_variables('alternate_requestor_phone2',document.forms[1],'Minimum Length','Phone 7 digits','7');">
			<CFINPUT type="text" name="alternate_requestor_phone_ext" value="#LookupAlternateContacts.CAMPUSPHONE#" size="5" maxlength="5" class="form" tabindex="16"
				onKeyPress="return numbersOnly(this, event)" title="Extension contains only digits" 
				onClick="unset_variables('alternate_requestor_phone1',document.forms[1]); 
				unset_variables('alternate_requestor_phone2',document.forms[1]); 
				reset_variables('alternate_requestor_phone_ext',document.forms[1],'Minimum Length','Extension 5 digits','5');">
			<BR /><COM>Please input telephone number or extension</COM>
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Email:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="alternate_requestor_email" value="#LookupAlternateContacts.EMAIL#" size="25" maxlength="30" tabindex="17">
		</TD>
	</TR>
	<TR>
		<TH align="LEFT" valign="top" colspan="2">
			<H2>Billing Information</H2>
		</TH>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" colspan="2">
			<I><COM>An account number is required. If you are not the account manager, please obtain the account number and his/her approval prior to submitting your request.</I></COM>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top">&nbsp;&nbsp; Choose type of<BR />&nbsp;&nbsp; account number:</TD>
		<TD align="LEFT" >
			<CFINPUT type="radio" name="account_number" id="account_number" checked tabindex="18" value="state" onClick="
				step3.requestor_non_state_account_number.disabled=true;
				step3.requestor_state_account_number1.disabled=false;
				step3.requestor_state_account_number2.disabled=false;
				step3.requestor_state_account_number3.disabled=false;
				step3.requestor_state_account_number4.disabled=false;
				step3.requestor_state_account_number5.disabled=false;
				step3.requestor_state_account_number6.disabled=false;
				step3.requestor_state_account_number7.disabled=false;

				unset_variables('requestor_non_state_account_number',document.forms[1]);
				reset_variables('requestor_state_account_number1',document.forms[1],'Minimum Length','State Account Number 1','5');
				reset_variables('requestor_state_account_number2',document.forms[1],'Minimum Length','State Account Number 2','3');
				reset_variables('requestor_state_account_number3',document.forms[1],'Minimum Length','State Account Number 3','5');
				reset_variables('requestor_state_account_number4',document.forms[1],'Minimum Length','State Account Number 4','4');
				reset_variables('requestor_state_account_number5',document.forms[1],'Minimum Length','State Account Number 5','4');
				reset_variables('requestor_state_account_number6',document.forms[1],'Minimum Length','State Account Number 6','4');
				reset_variables('requestor_state_account_number7',document.forms[1],'Minimum Length','State Account Number 7','4');
			">

			State
			<CFINPUT type="radio" name="account_number" id="account_number" tabindex="19" value="non-state" onClick="
				step3.requestor_state_account_number1.disabled=true;
				step3.requestor_state_account_number2.disabled=true;
				step3.requestor_state_account_number3.disabled=true;
				step3.requestor_state_account_number4.disabled=true;
				step3.requestor_state_account_number5.disabled=true;
				step3.requestor_state_account_number6.disabled=true;
				step3.requestor_state_account_number7.disabled=true;
				step3.requestor_non_state_account_number.disabled=false;

				unset_variables('requestor_state_account_number1',document.forms[1]);
				unset_variables('requestor_state_account_number2',document.forms[1]);
				unset_variables('requestor_state_account_number3',document.forms[1]);
				unset_variables('requestor_state_account_number4',document.forms[1]);
				unset_variables('requestor_state_account_number5',document.forms[1]);
				unset_variables('requestor_state_account_number6',document.forms[1]);
				unset_variables('requestor_state_account_number7',document.forms[1]);
				reset_variables('requestor_non_state_account_number',document.forms[1],'','Non State Account Number','');
			">
			Non-State<BR />
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" colspan="2"><FONT color="Red">*</FONT> State Account Number:</TD>
	</TR><TR>	
		<TD align="LEFT" valign="bottom" colspan="2">
			&nbsp;&nbsp;&nbsp;ORG
			&nbsp;&nbsp;&nbsp;ACTY
			&nbsp;&nbsp;&nbsp;NACCT
			&nbsp;&nbsp;&nbsp;ENDVR
			&nbsp;&nbsp;&nbsp;FUND
			&nbsp;&nbsp;&nbsp;FUNC
			&nbsp;&nbsp;&nbsp;UNUSED
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2">
			&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number1" value="#Left(LookupWorkRequests.ACCOUNTNUMBER1, 5)#" class="form" size="5" maxlength="5" onKeyPress="return numbersOnly(this, event)" tabindex="20">
			&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number2" value="#LookupWorkRequests.ACCOUNTNUMBER2#" class="form" size="3" maxlength="3" onKeyPress="return numbersOnly(this, event)" tabindex="21">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number3" value="#Mid(LookupWorkRequests.ACCOUNTNUMBER3, 2,5)#" class="form" size="5" maxlength="5" onKeyPress="return numbersOnly(this, event)" tabindex="22">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number4" value="#Mid(LookupWorkRequests.ACCOUNTNUMBER3, 8, 4)#" class="form" size="4" maxlength="4" onKeyPress="return numbersOnly(this, event)" tabindex="23">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number5" value="#Mid(LookupWorkRequests.ACCOUNTNUMBER3, 13, 4)#" class="form" size="4" maxlength="4" onKeyPress="return numbersOnly(this, event)" tabindex="24">
			&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number6" value="#Right(LookupWorkRequests.ACCOUNTNUMBER3, 4)#" class="form" size="4" maxlength="4" onKeyPress="return numbersOnly(this, event)" tabindex="25">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<CFINPUT type="text" name="requestor_state_account_number7" value="0000" class="form" size="4" maxlength="4" onKeyPress="return numbersOnly(this, event)" tabindex="26">
		</TD>
	</TR>	
	<TR>
		<TH align="LEFT" valign="top" colspan="2">or</TH>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Non-State Account Number:</TD>
		<TD align="LEFT">
			<CFINPUT type="text" name="requestor_non_state_account_number" value="" size="40" maxlength="40" onKeyPress="return numbersOnly(this, event)" tabindex="27">
		</TD>
	</TR>
	<TR>
		<TH align="LEFT" colspan="2">
			<H2>Dispose of Item</H2>
		</TH>
	</TR>
	<TR>
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Item:</TD>
		<TD align="LEFT" valign="top">
			<CFINPUT type="text" name="item" size="50" value="#LookupMoveRequests.MOVETYPENAME#" tabindex="28">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Current Location:</TD>
		<TD align="LEFT" valign="top">
			<CFINPUT type="text" name="location" size="50" value="#LookupMoveRequests.CURRENTLOCATION#" tabindex="29">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top">State ID:</TD>
		<TD align="LEFT" valign="top"><CFINPUT type="text" name="state_id" size="20" value="#LookupMoveRequests.STATENUMBER#" tabindex="30"></TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Destination:</TD>
		<TD align="LEFT" valign="top">
			<CFINPUT type="text" name="destination" size="50" value="#LookupMoveRequests.DESTINATION#" tabindex="31">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Request Description:</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top" colspan="2">
			<TEXTAREA name="description" cols="30" rows="6" tabindex="32">#LookupMoveRequests.ITEMDESCRIPTION#</TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2">
			<INPUT type="Submit" name="Submit" value="Submit" class="button" tabindex="33" /> &nbsp;&nbsp;<BR /> 
</CFFORM>
<CFFORM action="/#application.type#apps/facilities/#SCREENPROGRAMNAME#" method="POST">
			<INPUT type="Submit" value="Cancel" tabindex="34" />
		</TD>
</CFFORM>
	</TR>
</TABLE>
<!-- END: MAIN CONTENT TABLE -->
</CFIF>

</BODY>
</HTML>
</CFOUTPUT>