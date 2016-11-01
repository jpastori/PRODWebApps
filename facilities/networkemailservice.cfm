<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: networkemailservice.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/12/2012 --->
<!--- Date in Production: 02/12/2012 --->
<!--- Module: Facilities - Work Requests - Network & E-Mail Service Report --->
<!-- Last modified by John R. Pastori on 02/12/2012 using ColdFusion Studio. -->

<CFOUTPUT>
<CFSET SCREENPROGRAMNAME = "networkemailservice.cfm">
<CFSET RESPONSEPROGRAMNAME = "networkemailservice.cfm">
<CFSET REPORTTITLE = "Network &amp; E-Mail Service">
<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/#SCREENPROGRAMNAME#">
<CFSET CONTENT_UPDATED = "February 12, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">


<HTML xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<HEAD>
	<TITLE>Facilities - Work Requests - #REPORTTITLE#</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">

<!--- <script src="../../javascript/global_functions_level2.js" language="JavaScript" type="text/javascript"></script>
<script src="../../javascript/print_css_level2.js" language="JavaScript" type="text/javascript"></script>
<script src="../../cms/globals/script/global_functions.js" language="JavaScript" type="text/javascript"></script>
<script src="../../javascript/formcheck.js" language="JavaScript" type="text/javascript"></script>	 --->

	<SCRIPT language="JavaScript" type="text/javascript">
			set_variables('department','blank','Department','');
			set_variables('building_name','blank','Building Name','');
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
	</SCRIPT>
</HEAD>

<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES" dbtype="ORACLE80">
	SELECT	WR.WORKREQUESTID, WR.REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID,
			WR.REQUESTSTATUSID, RT.REQUESTTYPENAME, WR.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, WR.UNITID, WR.LOCATIONID, WR.ACCOUNTNUMBER1,
			WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3, WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION,
			WR.SUPEMAILID, WR.APPROVEDBYSUPID, WR.SUPAPPROVALDATE, WR.MGMTEMAILID, WR.APPROVEDBYMGMTID, WR.STARTDATE, WR.COMPLETIONDATE, WR.URGENCY, WR.TNSREQUEST,
			CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER AS KEYFINDER
	FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT
	WHERE	WR.REQUESTSTATUSID = 1 AND
			WR.REQUESTERID = CUST.CUSTOMERID AND
			WR.REQUESTTYPEID = RT.REQUESTTYPEID
	ORDER BY	CUST.FULLNAME, RT.REQUESTTYPENAME
</CFQUERY>

<CFIF NOT IsDefined("URL.LOOKUPWORKREQUESTID")>
	<BODY onLoad="document.LOOKUP.WORKREQUESTID.focus()">
<CFELSE>
	<BODY onLoad="document.WORKREQUEST.department.focus()">
</CFIF> 

<CFIF NOT IsDefined("URL.LOOKUPWORKREQUESTID")>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Approved Work Request Lookup For <BR> #REPORTTITLE# </H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/facilities/#SCREENPROGRAMNAME#?LOOKUPWORKREQUESTID=FOUND" method="POST">
			<TH align="LEFT" nowrap><H4><LABEL for="WORKREQUESTID">*Approved Work Request Service Job:</LABEL></H4></TH>
			<TD>
				<CFSELECT name="WORKREQUESTID" id="WORKREQUESTID" size="1" query="ListWorkRequests" value="WORKREQUESTID" display="KEYFINDER"required="No" tabindex="1"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
			<TD align="LEFT">
				<INPUT type="submit" value="GO" tabindex="2"><BR>
</CFFORM>
<CFFORM action="/#application.type#apps/facilities/index.cfm" method="POST">
				<INPUT type="submit" value="Cancel" tabindex="3">
			</TD>
</CFFORM>
		</TR>
		</tr>
		<TR>
			<TD colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
<CFELSE>
<!--- 
*********************************************************************************************
* The following code generates the Facilities - Work Requests - #REPORTTITLE# Report Screen.*
*********************************************************************************************
 --->

	<CFQUERY name="LookupWorkRequests" datasource="#application.type#FACILITIES" dbtype="ORACLE80">
		SELECT	WR.WORKREQUESTID, TO_CHAR(WR.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER,
				WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.REQUESTSTATUSID, RS.REQUESTSTATUSNAME,
				WR.REQUESTERID, WR.UNITID, WR.LOCATIONID, WR.ACCOUNTNUMBER1, WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3,
				WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION, WR.SUPEMAILID, WR.APPROVEDBYSUPID, 
				TO_CHAR(WR.SUPAPPROVALDATE, 'MM/DD/YYYY') AS SUPAPPROVALDATE, WR.MGMTEMAILID, WR.APPROVEDBYMGMTID,
				TO_CHAR(WR.STARTDATE, 'MM/DD/YYYY') AS STARTDATE, TO_CHAR(WR.COMPLETIONDATE, 'MM/DD/YYYY') AS COMPLETIONDATE,
                    WR.URGENCY, WR.KEYREQUEST, WR.MOVEREQUEST, WR.TNSREQUEST
		FROM		WORKREQUESTS WR, REQUESTTYPES RT, REQUESTSTATUS RS
		WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#FORM.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
				WR.REQUESTSTATUSID = RS.REQUESTSTATUSID
		ORDER BY	WR.REQUESTERID, RT.REQUESTTYPENAME
	</CFQUERY>

	<CFQUERY name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA" dbtype="ORACLE80">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.UNITID, CUST.LOCATIONID, CUST.EMAIL, CUST.CAMPUSPHONE, 
				CUST.SECONDCAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE, CUST.NUMBERLISTED,
				CUST.UNITHEAD, CUST.DEPTCHAIR
		FROM		CUSTOMERS CUST
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#LookupWorkRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" dbtype="ORACLE80">
		SELECT	UNITS.UNITID, UNITS.UNITNAME, CAMPUSMAILCODES.CAMPUSMAILCODE, GROUPS.GROUPNAME, 
				DEPARTMENTS.DEPARTMENTNAME, UNITS.UNITNAME || ' - ' || GROUPS.GROUPNAME AS UNITGROUP
		FROM		UNITS, CAMPUSMAILCODES, GROUPS, DEPARTMENTS
		WHERE	UNITS.UNITID = <CFQUERYPARAM value="#LookupRequesters.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
				UNITS.CAMPUSMAILCODEID = CAMPUSMAILCODES.CAMPUSMAILCODEID AND
				UNITS.GROUPID = GROUPS.GROUPID AND
				UNITS.DEPARTMENTID = DEPARTMENTS.DEPARTMENTID
		ORDER BY	UNITS.UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupAlternateContacts" datasource="#application.type#LIBSHAREDDATA" dbtype="ORACLE80">
		SELECT	CUSTOMERID, EMAIL, LASTNAME, FIRSTNAME, FULLNAME, EMAIL, CAMPUSPHONE, UNITHEAD, DEPTCHAIR
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupWorkRequests.ALTERNATECONTACTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" dbtype="ORACLE80">
		SELECT	LOC.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER
		FROM		LOCATIONS LOC, BUILDINGNAMES BN
		WHERE	LOC.LOCATIONID = #val(LookupWorkRequests.LOCATIONID)# AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID
		ORDER BY	LOC.ROOMNUMBER
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
			<INPUT type="submit" value="Cancel" tabindex="1">
</CFFORM>
		</TD>
	</TR>
<CFFORM name="WORKREQUEST" action="/#application.type#apps/facilities/#RESPONSEPROGRAMNAME#" method="post" onsubmit="return check_form(this);">	
	<TR>
		<TH align="LEFT" colspan="2">
			<H2>Service Request Information</H2>
		</TH>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2"><COM>This information pertains to the where the service is to be performed.</COM></TD>
	</TR>
	<TR>
		<TD align="LEFT" ><FONT color="Red">*</FONT> Department:</TD>
		<TD align="LEFT" >
			<CFSELECT name="department" class="form" tabindex="2">
				<OPTION value="">Please Select a Department</OPTION>
				<OPTION selected value="604">Library and Information Access</OPTION>
				<OPTION value="605">Library Development</OPTION>
			</CFSELECT>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT"><FONT color="Red">*</FONT> Building Name or Location:</TD>
		<TD align="LEFT">
			<INPUT class="form" maxlength="30" size="25" name="building_name" value="#LookupRoomNumbers.BUILDINGNAME#" tabindex="3">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT">&nbsp;&nbsp; Room Number:</TD>
		<TD align="LEFT">
			<INPUT class="form" maxlength="30" size="25" name="room_number" value="#LookupRoomNumbers.ROOMNUMBER#" tabindex="4">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="TOP" colspan="2">
			<FONT color="Red">*</FONT> Request:<BR>
			<COM>Please select the type of service you are requesting.</COM>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2">
		<CFIF LookupWorkRequests.REQUESTTYPEID EQ 7>
			<INPUT tabindex="5" type="checkbox" checked value="New Connection" name="service_type1">Install a new network connection<BR>
		<CFELSE>
			<INPUT tabindex="5" type="checkbox" value="New Connection" name="service_type1">Install a new network connection<BR>
		</CFIF>
		<CFIF LookupWorkRequests.REQUESTTYPEID EQ 4>
			<INPUT tabindex="6" type="checkbox" checked value="Move Connection" name="service_type2">Move an existing network connection<BR>
		<CFELSE>
			<INPUT tabindex="6" type="checkbox" value="Move Connection" name="service_type2">Move an existing network connection<BR>
		</CFIF>
		<CFIF LookupWorkRequests.REQUESTTYPEID EQ 19>
			<INPUT tabindex="7" type="checkbox" checked value="Network Problem" name="service_type3">Report a network-related problem<BR>
		<CFELSE>
			<INPUT tabindex="7" type="checkbox" value="Network Problem" name="service_type3">Report a network-related problem<BR>
		</CFIF>
		<CFIF LookupWorkRequests.REQUESTTYPEID EQ 18>
			<INPUT tabindex="8" type="checkbox" checked value="Email Problem" name="service_type4">Report an email related problem<BR>
		<CFELSE>
			<INPUT tabindex="8" type="checkbox" value="Email Problem" name="service_type4">Report an email related problem<BR>
		</CFIF>
		<CFIF LookupWorkRequests.REQUESTTYPEID EQ 14>
			<INPUT tabindex="9" type="checkbox" checked value="Apply Email" name="service_type5">Apply for an email account<BR>
		<CFELSE>
			<INPUT tabindex="9" type="checkbox" value="Apply Email" name="service_type5">Apply for an email account<BR>
		</CFIF>
		<CFIF LookupWorkRequests.REQUESTTYPEID EQ 1 OR ListWorkRequests.REQUESTTYPEID EQ 17>
			<INPUT tabindex="10" type="checkbox" checked value="Other" name="service_type6">Other (please specify below)<BR>
		<CFELSE>
			<INPUT tabindex="10" type="checkbox" value="Other" name="service_type6">Other (please specify below)<BR>
		</CFIF>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="TOP">&nbsp;&nbsp;&nbsp; Additional information about the Request:</TD>
		<TD align="LEFT">
			<TEXTAREA class="form" tabindex="11" name="request" rows="5" cols="40">#LookupWorkRequests.PROJECTDESCRIPTION#</TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="LEFT" colspan="2">
			<H2>Requester Information</H2>
		</TH>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Requester's First Name:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="requestor_first_name" value="#LookupRequesters.FIRSTNAME#" size="25" maxlength="30" tabindex="12">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Requester's Last Name:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="requestor_last_name" value="#LookupRequesters.LASTNAME#" size="25" maxlength="30" tabindex="13">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Phone Number:</TD>
		<TD align="LEFT" ">
			<CFINPUT type="text" name="requestor_phone1" value="" size="3" maxlength="3" class="form" tabindex="14"
				onKeyPress="return numbersOnly(this, event)" title="Area Code contains only digits"
				onClick="unset_variables('requestor_phone_ext',document.forms[1]);
				reset_variables('requestor_phone1',document.forms[1],'Minimum Length','Area Code 3 digits','3');
				reset_variables('requestor_phone2',document.forms[1],'Minimum Length','Phone 7 digits','7');"
			>
		
			<CFINPUT type="text" name="requestor_phone2" value="" size="8" maxlength="8" class="form" tabindex="15"
				onKeyPress="return numbersOnly(this, event)" title="Phone Number contains only digits"
				onClick="unset_variables('requestor_phone_ext',document.forms[1]);
				reset_variables('requestor_phone1',document.forms[1],'Minimum Length','Area Code 3 digits','3');
				reset_variables('requestor_phone2',document.forms[1],'Minimum Length','Phone 7 digits','7');"
			>
		
			<CFINPUT type="text" name="requestor_phone_ext" value="#LookupRequesters.CAMPUSPHONE#" size="5" maxlength="5" class="form" tabindex="16"
				onKeyPress="return numbersOnly(this, event)" title="Extension contains only digits" 
				onClick="unset_variables('requestor_phone1',document.forms[1]); 
				unset_variables('requestor_phone2',document.forms[1]); 
				reset_variables('requestor_phone_ext',document.forms[1],'Minimum Length','Extension 5 digits','5');"
			>
			<BR><COM>Please input telephone number or extension</COM>
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Email:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="requestor_email" value="#LookupRequesters.EMAIL#" size="25" maxlength="30" tabindex="17">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top">&nbsp;&nbsp; Mail Code:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="requestor_mail_code" value="#LookupUnits.CAMPUSMAILCODE#" size="25" maxlength="30" tabindex="18">
		</TD>
	</TR>
	<TR>
		<TH align="LEFT" valign="top" colspan="2">
			<H2>Alternate Contact</H2> 
		</TH>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Contact's First Name:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="alternate_requestor_first_name" value="#LookupAlternateContacts.FIRSTNAME#" size="25" maxlength="30" tabindex="19">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Contact's Last Name:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="alternate_requestor_last_name" value="#LookupAlternateContacts.LASTNAME#" size="25" maxlength="30" tabindex="20">
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Phone Number:</TD>
		<TD align="LEFT" >
			(
			<CFINPUT type="text" name="alternate_requestor_phone1" value="" size="3" maxlength="3" class="form" tabindex="21" 
				onKeyPress="return numbersOnly(this, event)" title="Area Code contains only digits" 
				onClick="unset_variables('alternate_requestor_phone_ext',document.forms[1]); 
				reset_variables('alternate_requestor_phone1',document.forms[1],'Minimum Length','Area Code 3 digits','3'); 
				reset_variables('alternate_requestor_phone2',document.forms[1],'Minimum Length','Phone 7 digits','7');" 
			>
			)
			<CFINPUT type="text" name="alternate_requestor_phone2" value="" size="8" maxlength="8" class="form" tabindex="22"
				onKeyPress="return numbersOnly(this, event)" title="Phone Number contains only digits" 
				onClick="unset_variables('alternate_requestor_phone_ext',document.forms[1]); 
				reset_variables('alternate_requestor_phone1',document.forms[1],'Minimum Length','Area Code 3 digits','3'); 
				reset_variables('alternate_requestor_phone2',document.forms[1],'Minimum Length','Phone 7 digits','7');" 
			>
			<CFINPUT type="text" name="alternate_requestor_phone_ext" value="#LookupAlternateContacts.CAMPUSPHONE#" size="5" maxlength="5" class="form" tabindex="23"
				onKeyPress="return numbersOnly(this, event)" title="Extension contains only digits" 
				onClick="unset_variables('alternate_requestor_phone1',document.forms[1]); 
				unset_variables('alternate_requestor_phone2',document.forms[1]); 
				reset_variables('alternate_requestor_phone_ext',document.forms[1],'Minimum Length','Extension 5 digits','5');" 
			>
			<BR><COM>Please input telephone number or extension</font></COM>
		</TD>
	</TR>
	<TR>	
		<TD align="LEFT" valign="top"><FONT color="Red">*</FONT> Email:</TD>
		<TD align="LEFT" >
			<CFINPUT type="text" name="alternate_requestor_email" value="#LookupAlternateContacts.EMAIL#" size="25" maxlength="30" tabindex="24">
		</TD>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2">
			<INPUT type="Submit" name="Submit" value="Submit" class="button" tabindex="25"> &nbsp;&nbsp;<BR> 
</CFFORM>
<CFFORM action="/#application.type#apps/facilities/#SCREENPROGRAMNAME#" method="POST">
			<INPUT type="Submit" value="Cancel" tabindex="26">
		</TD>
</CFFORM>		
	</TR>

</TABLE>
<!-- END: MAIN CONTENT TABLE -->
</CFIF>
</BODY></HTML></CFOUTPUT>


