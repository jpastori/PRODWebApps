<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: configmgmtdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: IDT Configuration Management - Requests Report --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/configmgmt/configmgmtdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 24 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Configuration Management - Requests Report</TITLE>

	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Configuration Management";
	
	
	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFIF NOT IsDefined('URL.LOOKUPCMRID')>
	<CFSET CURSORFIELD = "document.LOOKUP.FISCALYEARID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*************************************************************************************************
* The following code is the Look Up Process for IDT Configuration Management - Requests Report. *
*************************************************************************************************
 --->
<CFIF NOT IsDefined('URL.LOOKUPCMRID')>

	<CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		WHERE	FISCALYEARID = 0 OR 
				FISCALYEARID > 23
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="ListRequstrsNotifirsImplmntrs" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME,
				CUST.CATEGORYID, CUST.UNITID, U.GROUPID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND
				CUST.UNITID = U.UNITID) OR	
				(CUST.UNITID = U.UNITID AND
				U.GROUPID = 4 AND
				CUST.ACTIVE = 'YES')	
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListAuthorizers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.UNITID, U.GROUPID, CUST.CAMPUSPHONE,
				CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = U.UNITID) OR
				(CUST.UNITID = U.UNITID AND
				U.GROUPID = 4 AND
				CUST.ACTIVE = 'YES' AND 
				(CUST.UNITHEAD = 'YES' OR
				CUST.DEPTCHAIR = 'YES') AND
				CUST.ALLOWEDTOAPPROVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 1300 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 30
		ORDER BY	CUST.FULLNAME
	</CFQUERY>


	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Configuration Management - Requests Report Selection Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
					Checking an adjacent checkbox will Negate the selection or data entered.
				</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
	</TABLE>
	
     <FIELDSET>
     <LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" action="/#application.type#apps/configmgmt/configmgmtdbreport.cfm?LOOKUPCMRID=FOUND" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFISCALYEARID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FISCALYEARID">Fiscal Year</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECHANGENUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CHANGENUMBER">Enter (1) a partial Change Number or (2) a series of Change Numbers </LABEL><BR />
				&nbsp;separated by commas,NO spaces.
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFISCALYEARID" id="NEGATEFISCALYEARID" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECHANGENUMBER" id="NEGATECHANGENUMBER" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CHANGENUMBER" id="CHANGENUMBER" value="" align="LEFT" required="No" size="50" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESYSTEM">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SYSTEM">System</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTERID">Requester</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESYSTEM" id="NEGATESYSTEM" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="SYSTEM" id="SYSTEM" value="" align="LEFT" required="No" size="50" tabindex="7">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTERID" id="NEGATEREQUESTERID" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="ListRequstrsNotifirsImplmntrs" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="9"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTDATE">Enter (1) a single Request Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
			<TH align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" valign="BOTTOM" width="45%">
				<LABEL for="CHANGESCHEDULED">Change Scheduled?</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTDATE" id="NEGATEREQUESTDATE" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="REQUESTDATE" id="REQUESTDATE" value="" required="No" size="50" tabindex="11">
			</TD>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="CHANGESCHEDULED" id="CHANGESCHEDULED" size="1" tabindex="12">
					<OPTION value="Make a Selection">Make a Selection</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECHANGEDESCRIPTION">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CHANGEDESCRIPTION">Change Description</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECHANGEJUSTIFICATION">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CHANGEJUSTIFICATION">Change Justification</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECHANGEDESCRIPTION" id="NEGATECHANGEDESCRIPTION" value="" align="LEFT" required="No" tabindex="13">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CHANGEDESCRIPTION" id="CHANGEDESCRIPTION" value="" required="No" size="20" maxlength="50" tabindex="14">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECHANGEJUSTIFICATION" id="NEGATECHANGEJUSTIFICATION" value="" align="LEFT" required="No" tabindex="15">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CHANGEJUSTIFICATION" id="CHANGEJUSTIFICATION" value="" required="No" size="20" maxlength="50" tabindex="16">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAUTHORIZERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="AUTHORIZERID">Authorizer</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAUTHORIZATIONDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="AUTHORIZATIONDATE">Enter (1) a single Authorization Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAUTHORIZERID" id="NEGATEAUTHORIZERID" value="" align="LEFT" required="No" tabindex="17">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="AUTHORIZERID" id="AUTHORIZERID" size="1" query="ListAuthorizers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="18"></CFSELECT>
			</TD>
			<TD align="LEFT">
				<CFINPUT type="CheckBox" name="NEGATEAUTHORIZATIONDATE" id="NEGATEAUTHORIZATIONDATE" value="" align="LEFT" required="No" tabindex="19">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="AUTHORIZATIONDATE" id="AUTHORIZATIONDATE" value="" align="LEFT" required="No" size="50" tabindex="20">
			</TD>
			
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESERVERADMCOMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SERVERADMCOMMENTS">Server Adminstrator's Comments</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATENOTIFICATIONDESCRIPTION">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="NOTIFICATIONDESCRIPTION">Notification Description</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESERVERADMCOMMENTS" id="NEGATESERVERADMCOMMENTS" value="" align="LEFT" required="No" tabindex="21">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="SERVERADMCOMMENTS" id="SERVERADMCOMMENTS" value="" required="No" size="20" maxlength="50" tabindex="22">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATENOTIFICATIONDESCRIPTION" id="NEGATENOTIFICATIONDESCRIPTION" value="" align="LEFT" required="No" tabindex="23">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="NOTIFICATIONDESCRIPTION" id="NOTIFICATIONDESCRIPTION" value="" required="No" size="20" maxlength="50" tabindex="24">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATENOTIFIERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="NOTIFIERID">Notifier</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATENOTIFICATIONDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="NOTIFICATIONDATE">Enter (1) a single Notification Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATENOTIFIERID" id="NEGATENOTIFIERID" value="" align="LEFT" required="No" tabindex="25">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="NOTIFIERID" id="NOTIFIERID" size="1" query="ListRequstrsNotifirsImplmntrs" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="26"></CFSELECT>
			</TD>
			<TD align="LEFT">
				<CFINPUT type="CheckBox" name="NEGATENOTIFICATIONDATE" id="NEGATENOTIFICATIONDATE" value="" align="LEFT" required="No" tabindex="27">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="NOTIFICATIONDATE" id="NOTIFICATIONDATE" value="" align="LEFT" required="No" size="50" tabindex="28">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFOLLOWUPDESCR_1ST">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FOLLOWUPDESCRIPTION_1ST">1st Follow-up Description</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFOLLOWUPDESCR_2ND">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FOLLOWUPDESCRIPTION_2ND">2nd Follow-up Description</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFOLLOWUPDESCR_1ST" id="NEGATEFOLLOWUPDESCR_1ST" value="" align="LEFT" required="No" tabindex="29">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="FOLLOWUPDESCRIPTION_1ST" id="FOLLOWUPDESCRIPTION_1ST" value="" required="No" size="20" maxlength="50" tabindex="30">
			</TD>
			<TD align="LEFT">
				<CFINPUT type="CheckBox" name="NEGATEFOLLOWUPDESCR_2ND" id="NEGATEFOLLOWUPDESCR_2ND" value="" align="LEFT" required="No" tabindex="31">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="FOLLOWUPDESCRIPTION_2ND" id="FOLLOWUPDESCRIPTION_2ND" value="" align="LEFT" required="No" size="50" tabindex="32">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFOLLOWUPNOTIFIERID_1ST">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FOLLOWUPNOTIFIERID_1ST">1st Follow-up Notifier</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFOLLOWUPDATE_1ST">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FOLLOWUPDATE_1ST">Enter (1) a single 1st Follow-up Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFOLLOWUPNOTIFIERID_1ST" id="NEGATEFOLLOWUPNOTIFIERID_1ST" value="" align="LEFT" required="No" tabindex="33">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="FOLLOWUPNOTIFIERID_1ST" id="FOLLOWUPNOTIFIERID_1ST" size="1" query="ListRequstrsNotifirsImplmntrs" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="34"></CFSELECT>
			</TD>
			<TD align="LEFT">
				<CFINPUT type="CheckBox" name="NEGATEFOLLOWUPDATE_1ST" id="NEGATEFOLLOWUPDATE_1ST" value="" align="LEFT" required="No" tabindex="35">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="FOLLOWUPDATE_1ST" id="FOLLOWUPDATE_1ST" value="" align="LEFT" required="No" size="50" tabindex="36">
			</TD>
			
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFOLLOWUPNOTIFIERID_2ND">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FOLLOWUPNOTIFIERID_2ND">2nd Follow-up Notifier</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFOLLOWUPDATE_2ND">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FOLLOWUPDATE_2ND">Enter (1) a single 2nd Follow-up Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFOLLOWUPNOTIFIERID_2ND" id="NEGATEFOLLOWUPNOTIFIERID_2ND" value="" align="LEFT" required="No" tabindex="37">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="FOLLOWUPNOTIFIERID_2ND" id="FOLLOWUPNOTIFIERID_2ND" size="1" query="ListRequstrsNotifirsImplmntrs" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="38"></CFSELECT>
			</TD>
			<TD align="LEFT">
				<CFINPUT type="CheckBox" name="NEGATEFOLLOWUPDATE_2ND" id="NEGATEFOLLOWUPDATE_2ND" value="" align="LEFT" required="No" tabindex="39">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="FOLLOWUPDATE_2ND" id="FOLLOWUPDATE_2ND" value="" align="LEFT" required="No" size="50" tabindex="40">
			</TD>
			
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBACKUPDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BACKUPDATE">Enter (1) a single Backup Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEIMPLEMENTERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="IMPLEMENTERID">Implementer</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBACKUPDATE" id="NEGATEBACKUPDATE" value="" align="LEFT" required="No" tabindex="41">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="BACKUPDATE" id="BACKUPDATE" value="" required="No" size="50" tabindex="42">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEIMPLEMENTERID" id="NEGATEIMPLEMENTERID" value="" align="LEFT" required="No" tabindex="43">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="IMPLEMENTERID" id="IMPLEMENTERID" size="1" query="ListRequstrsNotifirsImplmntrs" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="44"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECHANGEDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CHANGEDATE">Enter (1) a single Change Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
			<TH align="LEFT" width="5%">&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECHANGEDATE" id="NEGATECHANGEDATE" value="" align="LEFT" required="No" tabindex="45">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CHANGEDATE" id="CHANGEDATE" value="" required="No" size="50" tabindex="46">
			</TD>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" width="45%">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEIMPLEMENTATIONDESCR">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="IMPLEMENTATIONDESCRIPTION">Implementation Description</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATETESTINGMONITORDESCR">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="TESTINGMONITORDESCRIPTION">Testing/Monitor Description</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEIMPLEMENTATIONDESCR" id="NEGATEIMPLEMENTATIONDESCR" value="" align="LEFT" required="No" tabindex="47">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="IMPLEMENTATIONDESCRIPTION" id="IMPLEMENTATIONDESCRIPTION" value="" required="No" size="20" maxlength="50" tabindex="48">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATETESTINGMONITORDESCR" id="NEGATETESTINGMONITORDESCR" value="" align="LEFT" required="No" tabindex="49">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="TESTINGMONITORDESCRIPTION" id="TESTINGMONITORDESCRIPTION" value="" required="No" size="20" maxlength="50" tabindex="50">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECHANGESTATUS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CHANGESTATUS">Change Status</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAVAILABILITYDESCR">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="AVAILABILITY"description>Availability Description</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECHANGESTATUS" id="NEGATECHANGESTATUS" value="" align="LEFT" required="No" tabindex="51">
			</TD>
			<TD align="left" valign ="TOP">
				<CFSELECT name="CHANGESTATUS" id="CHANGESTATUS" size="1" tabindex="52">
					<OPTION value=" Make a Selection"> Make a Selection</OPTION>
					<OPTION value="GOOD">GOOD</OPTION>
					<OPTION value="BAD">BAD</OPTION>
					<OPTION value="ROLLBACK NEEDED">ROLLBACK NEEDED</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAVAILABILITYDESCR" id="NEGATEAVAILABILITYDESCR" value="" align="LEFT" required="No" tabindex="53">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="AVAILABILITYDESCRIPTION" id="AVAILABILITYDESCRIPTION" value="" required="No" size="20" maxlength="50" tabindex="54">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAVAILABILITYNOTIFIERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="AVAILABILITYNOTIFIERID">Availability Notifier</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEAVAILABILITYDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="AVAILABILITYDATE">Enter (1) a single Availability Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEAVAILABILITYNOTIFIERID" id="NEGATEAVAILABILITYNOTIFIERID" value="" align="LEFT" required="No" tabindex="55">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="AVAILABILITYNOTIFIERID" id="AVAILABILITYNOTIFIERID" size="1" query="ListRequstrsNotifirsImplmntrs" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="56"></CFSELECT>
			</TD>
			<TD align="LEFT">
				<CFINPUT type="CheckBox" name="NEGATEAVAILABILITYDATE" id="NEGATEAVAILABILITYDATE" value="" align="LEFT" required="No" tabindex="57">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="AVAILABILITYDATE" id="AVAILABILITYDATE" value="" align="LEFT" required="No" size="50" tabindex="58">
			</TD>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified By</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDDATE">Enter (1) a single Modified Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="59">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="60">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="61">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="62">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Report Selection</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TH colspan="4"><H2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
               <TD align="LEFT" colspan="4">
                    <INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
                    <BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="63" />
               </TD>
          </TR>
          <TR>
               <TD align="LEFT" colspan="4">
                    <INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="64" />
               </TD>
          </TR>
     </TABLE>
</CFFORM>
     
     </FIELDSET>
     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="65" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFEXIT>

<CFELSE>

<!--- 
************************************************************************************************
* The following code is the IDT Configuration Management - Requests Report Generation Process. *
************************************************************************************************
 --->

	<CFIF #FORM.CHANGENUMBER# NEQ "">
		<CFSET CHANGENUMLIST = "NO">
		<CFIF FIND(',', #FORM.CHANGENUMBER#, 1) NEQ 0>
			<CFSET CHANGENUMLIST = "YES">
			<CFSET FORM.CHANGENUMBER = UCASE(#FORM.CHANGENUMBER#)>
			<CFSET FORM.CHANGENUMBER = ListQualify(FORM.CHANGENUMBER,"'",",","CHAR")>
			<CFIF FIND('SYS', #FORM.CHANGENUMBER#, 1) EQ 0>
				<SCRIPT language="JavaScript">
				<!-- 
					alert("The CHANGENUMBER field values must be fully entered when multiple entries are typed.");
				--> 
				</SCRIPT>
				<META http-equiv="Refresh" content="0; URL=/#application.type#apps/configmgmt/configmgmtdbreport.cfm" />
				<CFEXIT>
			</CFIF>
			<!--- CHANGENUMBER FIELD = #FORM.CHANGENUMBER#<BR><BR> --->
		</CFIF>
	</CFIF>

	<CFIF "#FORM.REQUESTDATE#" NEQ ''>
		<CFSET REQUESTDATELIST = "NO">
		<CFSET REQUESTDATERANGE = "NO">
		<CFIF FIND(',', #FORM.REQUESTDATE#, 1) EQ 0 AND FIND(';', #FORM.REQUESTDATE#, 1) EQ 0>
			<CFSET FORM.REQUESTDATE = DateFormat(FORM.REQUESTDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.REQUESTDATE#, 1) NEQ 0>
				<CFSET REQUESTDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.REQUESTDATE#, 1) NEQ 0>
				<CFSET REQUESTDATERANGE = "YES">
				<CFSET FORM.REQUESTDATE = #REPLACE(FORM.REQUESTDATE, ";", ",")#>
			</CFIF>
			<CFSET REQUESTDATEARRAY = ListToArray(FORM.REQUESTDATE)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(REQUESTDATEARRAY)# >
				REQUESTDATE FIELD = #REQUESTDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF REQUESTDATERANGE EQ "YES">
			<CFSET BEGINREQUESTDATE = DateFormat(#REQUESTDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDREQUESTDATE = DateFormat(#REQUESTDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- REQUESTDATELIST = #REQUESTDATELIST#<BR><BR>
		REQUESTDATERANGE = #REQUESTDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF "#FORM.AUTHORIZATIONDATE#" NEQ ''>
		<CFSET AUTHORIZATIONDATELIST = "NO">
		<CFSET AUTHORIZATIONDATERANGE = "NO">
		<CFIF FIND(',', #FORM.AUTHORIZATIONDATE#, 1) EQ 0 AND FIND(';', #FORM.AUTHORIZATIONDATE#, 1) EQ 0>
			<CFSET FORM.AUTHORIZATIONDATE = DateFormat(FORM.AUTHORIZATIONDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.AUTHORIZATIONDATE#, 1) NEQ 0>
				<CFSET AUTHORIZATIONDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.AUTHORIZATIONDATE#, 1) NEQ 0>
				<CFSET AUTHORIZATIONDATERANGE = "YES">
				<CFSET FORM.AUTHORIZATIONDATE = #REPLACE(FORM.AUTHORIZATIONDATE, ";", ",")#>
			</CFIF>
			<CFSET AUTHORIZATIONDATEARRAY = ListToArray(FORM.AUTHORIZATIONDATE)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(AUTHORIZATIONDATEARRAY)# >
				AUTHORIZATIONDATE FIELD = #AUTHORIZATIONDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF AUTHORIZATIONDATERANGE EQ "YES">
			<CFSET BEGINAUTHORIZATIONDATE = DateFormat(#AUTHORIZATIONDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDAUTHORIZATIONDATE = DateFormat(#AUTHORIZATIONDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- AUTHORIZATIONDATELIST = #AUTHORIZATIONDATELIST#<BR><BR>
		AUTHORIZATIONDATERANGE = #AUTHORIZATIONDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF "#FORM.NOTIFICATIONDATE#" NEQ ''>
		<CFSET NOTIFICATIONDATELIST = "NO">
		<CFSET NOTIFICATIONDATERANGE = "NO">
		<CFIF FIND(',', #FORM.NOTIFICATIONDATE#, 1) EQ 0 AND FIND(';', #FORM.NOTIFICATIONDATE#, 1) EQ 0>
			<CFSET FORM.NOTIFICATIONDATE = DateFormat(FORM.NOTIFICATIONDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.NOTIFICATIONDATE#, 1) NEQ 0>
				<CFSET NOTIFICATIONDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.NOTIFICATIONDATE#, 1) NEQ 0>
				<CFSET NOTIFICATIONDATERANGE = "YES">
				<CFSET FORM.NOTIFICATIONDATE = #REPLACE(FORM.NOTIFICATIONDATE, ";", ",")#>
			</CFIF>
			<CFSET NOTIFICATIONDATEARRAY = ListToArray(FORM.NOTIFICATIONDATE)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(NOTIFICATIONDATEARRAY)# >
				NOTIFICATIONDATE FIELD = #NOTIFICATIONDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF NOTIFICATIONDATERANGE EQ "YES">
			<CFSET BEGINNOTIFICATIONDATE = DateFormat(#NOTIFICATIONDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDNOTIFICATIONDATE = DateFormat(#NOTIFICATIONDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- NOTIFICATIONDATELIST = #NOTIFICATIONDATELIST#<BR><BR>
		NOTIFICATIONDATERANGE = #NOTIFICATIONDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF "#FORM.FOLLOWUPDATE_1ST#" NEQ ''>
		<CFSET FOLLOWUPDATE_1ST_LIST = "NO">
		<CFSET FOLLOWUPDATE_1ST_RANGE = "NO">
		<CFIF FIND(',', #FORM.FOLLOWUPDATE_1ST#, 1) EQ 0 AND FIND(';', #FORM.FOLLOWUPDATE_1ST#, 1) EQ 0>
			<CFSET FORM.FOLLOWUPDATE_1ST = DateFormat(FORM.FOLLOWUPDATE_1ST, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.FOLLOWUPDATE_1ST#, 1) NEQ 0>
				<CFSET FOLLOWUPDATE_1ST_LIST = "YES">
			<CFELSEIF FIND(';', #FORM.FOLLOWUPDATE_1ST#, 1) NEQ 0>
				<CFSET FOLLOWUPDATE_1ST_RANGE = "YES">
				<CFSET FORM.FOLLOWUPDATE_1ST = #REPLACE(FORM.FOLLOWUPDATE_1ST, ";", ",")#>
			</CFIF>
			<CFSET FOLLOWUPDATE_1ST_ARRAY = ListToArray(FORM.FOLLOWUPDATE_1ST)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(FOLLOWUPDATE_1ST_ARRAY)# >
				FOLLOWUPDATE_1ST FIELD = #FOLLOWUPDATE_1ST_ARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF FOLLOWUPDATE_1ST_RANGE EQ "YES">
			<CFSET BEGINFOLLOWUPDATE_1ST = DateFormat(#FOLLOWUPDATE_1ST_ARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDFOLLOWUPDATE_1ST = DateFormat(#FOLLOWUPDATE_1ST_ARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- FOLLOWUPDATE_1ST_LIST = #FOLLOWUPDATE_1ST_LIST#<BR><BR>
		FOLLOWUPDATE_1ST_RANGE = #FOLLOWUPDATE_1ST_RANGE#<BR><BR> --->
	</CFIF>

	<CFIF "#FORM.FOLLOWUPDATE_2ND#" NEQ ''>
		<CFSET FOLLOWUPDATE_2ND_LIST = "NO">
		<CFSET FOLLOWUPDATE_2ND_RANGE = "NO">
		<CFIF FIND(',', #FORM.FOLLOWUPDATE_2ND#, 1) EQ 0 AND FIND(';', #FORM.FOLLOWUPDATE_2ND#, 1) EQ 0>
			<CFSET FORM.FOLLOWUPDATE_2ND = DateFormat(FORM.FOLLOWUPDATE_2ND, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.FOLLOWUPDATE_2ND#, 1) NEQ 0>
				<CFSET FOLLOWUPDATE_2ND_LIST = "YES">
			<CFELSEIF FIND(';', #FORM.FOLLOWUPDATE_2ND#, 1) NEQ 0>
				<CFSET FOLLOWUPDATE_2ND_RANGE = "YES">
				<CFSET FORM.FOLLOWUPDATE_2ND = #REPLACE(FORM.FOLLOWUPDATE_2ND, ";", ",")#>
			</CFIF>
			<CFSET FOLLOWUPDATE_2ND_ARRAY = ListToArray(FORM.FOLLOWUPDATE_2ND)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(FOLLOWUPDATE_2ND_ARRAY)# >
				FOLLOWUPDATE_2ND FIELD = #FOLLOWUPDATE_2ND_ARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF FOLLOWUPDATE_2ND_RANGE EQ "YES">
			<CFSET BEGINFOLLOWUPDATE_2ND = DateFormat(#FOLLOWUPDATE_2ND_ARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDFOLLOWUPDATE_2ND = DateFormat(#FOLLOWUPDATE_2ND_ARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- FOLLOWUPDATE_2ND_LIST = #FOLLOWUPDATE_2ND_LIST#<BR><BR>
		FOLLOWUPDATE_2ND_RANGE = #FOLLOWUPDATE_2ND_RANGE#<BR><BR> --->
	</CFIF>

	<CFIF "#FORM.BACKUPDATE#" NEQ ''>
		<CFSET BACKUPDATELIST = "NO">
		<CFSET BACKUPDATERANGE = "NO">
		<CFIF FIND(',', #FORM.BACKUPDATE#, 1) EQ 0 AND FIND(';', #FORM.BACKUPDATE#, 1) EQ 0>
			<CFSET FORM.BACKUPDATE = DateFormat(FORM.BACKUPDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.BACKUPDATE#, 1) NEQ 0>
				<CFSET BACKUPDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.BACKUPDATE#, 1) NEQ 0>
				<CFSET BACKUPDATERANGE = "YES">
				<CFSET FORM.BACKUPDATE = #REPLACE(FORM.BACKUPDATE, ";", ",")#>
			</CFIF>
			<CFSET BACKUPDATEARRAY = ListToArray(FORM.BACKUPDATE)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(BACKUPDATEARRAY)# >
				BACKUPDATE FIELD = #BACKUPDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF BACKUPDATERANGE EQ "YES">
			<CFSET BEGINBACKUPDATE = DateFormat(#BACKUPDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDBACKUPDATE = DateFormat(#BACKUPDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- BACKUPDATELIST = #BACKUPDATELIST#<BR><BR>
		BACKUPDATERANGE = #BACKUPDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF "#FORM.CHANGEDATE#" NEQ ''>
		<CFSET CHANGEDATELIST = "NO">
		<CFSET CHANGEDATERANGE = "NO">
		<CFIF FIND(',', #FORM.CHANGEDATE#, 1) EQ 0 AND FIND(';', #FORM.CHANGEDATE#, 1) EQ 0>
			<CFSET FORM.CHANGEDATE = DateFormat(FORM.CHANGEDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.CHANGEDATE#, 1) NEQ 0>
				<CFSET CHANGEDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.CHANGEDATE#, 1) NEQ 0>
				<CFSET CHANGEDATERANGE = "YES">
				<CFSET FORM.CHANGEDATE = #REPLACE(FORM.CHANGEDATE, ";", ",")#>
			</CFIF>
			<CFSET CHANGEDATEARRAY = ListToArray(FORM.CHANGEDATE)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(CHANGEDATEARRAY)# >
				CHANGEDATE FIELD = #CHANGEDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF CHANGEDATERANGE EQ "YES">
			<CFSET BEGINCHANGEDATE = DateFormat(#CHANGEDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDCHANGEDATE = DateFormat(#CHANGEDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- CHANGEDATELIST = #CHANGEDATELIST#<BR><BR>
		CHANGEDATERANGE = #CHANGEDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF "#FORM.AVAILABILITYDATE#" NEQ ''>
		<CFSET AVAILABILITYDATELIST = "NO">
		<CFSET AVAILABILITYDATERANGE = "NO">
		<CFIF FIND(',', #FORM.AVAILABILITYDATE#, 1) EQ 0 AND FIND(';', #FORM.AVAILABILITYDATE#, 1) EQ 0>
			<CFSET FORM.AVAILABILITYDATE = DateFormat(FORM.AVAILABILITYDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.AVAILABILITYDATE#, 1) NEQ 0>
				<CFSET AVAILABILITYDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.AVAILABILITYDATE#, 1) NEQ 0>
				<CFSET AVAILABILITYDATERANGE = "YES">
				<CFSET FORM.AVAILABILITYDATE = #REPLACE(FORM.AVAILABILITYDATE, ";", ",")#>
			</CFIF>
			<CFSET AVAILABILITYDATEARRAY = ListToArray(FORM.AVAILABILITYDATE)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(AVAILABILITYDATEARRAY)# >
				AVAILABILITYDATE FIELD = #AVAILABILITYDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF AVAILABILITYDATERANGE EQ "YES">
			<CFSET BEGINAVAILABILITYDATE = DateFormat(#AVAILABILITYDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDAVAILABILITYDATE = DateFormat(#AVAILABILITYDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- AVAILABILITYDATELIST = #AVAILABILITYDATELIST#<BR><BR>
		AVAILABILITYDATERANGE = #AVAILABILITYDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
		<CFSET MODIFIEDDATELIST = "NO">
		<CFSET MODIFIEDDATERANGE = "NO">
		<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) EQ 0 AND FIND(';', #FORM.MODIFIEDDATE#, 1) EQ 0>
			<CFSET FORM.MODIFIEDDATE = DateFormat(FORM.MODIFIEDDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATERANGE = "YES">
				<CFSET FORM.MODIFIEDDATE = #REPLACE(FORM.MODIFIEDDATE, ";", ",")#>
			</CFIF>
			<CFSET MODIFIEDDATEARRAY = ListToArray(FORM.MODIFIEDDATE)>
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(MODIFIEDDATEARRAY)# >
				MODIFIEDDATE FIELD = #MODIFIEDDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- MODIFIEDDATELIST = #MODIFIEDDATELIST#<BR><BR>
		MODIFIEDDATERANGE = #MODIFIEDDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="LookupCMRequests" datasource="#application.type#CONFIGMGMT" blockfactor="100">
		SELECT	CMR.CONFIGMGMTREQUESTID, CMR.FISCALYEARID, FY.FISCALYEAR_4DIGIT, CMR.CHANGENUMBER, CMR.SYSTEM , CMR.REQUESTERID,
				REQCUST.CUSTOMERID, REQCUST.FULLNAME AS CUSTREQNAME, CMR.REQUESTDATE, CMR.CHANGEDESCRIPTION, CMR.CHANGEJUSTIFICATION,
				CMR.AUTHORIZERID, AUTHCUST.FULLNAME AS AUTHCUSTNAME, CMR.AUTHORIZATIONDATE, CMR.SERVERADMCOMMENTS,
				CMR.CHANGESCHEDULED, CMR.NOTIFICATIONDESCRIPTION, CMR.NOTIFIERID, NOTIFCUST.FULLNAME AS NOTIFCUSTNAME,
				CMR.NOTIFICATIONDATE, CMR.FOLLOWUPDESCRIPTION_1ST, CMR.FOLLOWUPNOTIFIERID_1ST, FOLLNOTIFCUST_1ST.FULLNAME AS FOLLNOTIFCUSTNAME_1ST,
				CMR.FOLLOWUPDATE_1ST, CMR.FOLLOWUPDESCRIPTION_2ND, CMR.FOLLOWUPNOTIFIERID_2ND, FOLLNOTIFCUST_2ND.FULLNAME AS FOLLNOTIFCUSTNAME_2ND,
				CMR.FOLLOWUPDATE_2ND, CMR.BACKUPDATE, CMR.IMPLEMENTERID, IMPLCUST.FULLNAME AS IMPLCUSTNAME, CMR.CHANGEDATE, CMR.CHANGETIME,
				CMR.IMPLEMENTATIONDESCRIPTION, CMR.TESTINGMONITORDESCRIPTION, CMR.CHANGESTATUS, CMR.AVAILABILITYDESCRIPTION,
				CMR.AVAILABILITYNOTIFIERID, AVAILCUST.FULLNAME AS AVAILCUSTNAME, CMR.AVAILABILITYDATE, CMR.MODIFIEDBYID, MODCUST.FULLNAME AS MODCUSTNAME,
				CMR.MODIFIEDDATE, CMR.CHANGENUMBER || ' - ' || CMR.SYSTEM || ' - ' || REQCUST.FULLNAME || ' - ' || CMR.REQUESTDATE AS KEYFINDER
		FROM		CONFIGMGMTREQUESTS CMR, LIBSHAREDDATAMGR.FISCALYEARS FY, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, LIBSHAREDDATAMGR.CUSTOMERS AUTHCUST,
				LIBSHAREDDATAMGR.CUSTOMERS NOTIFCUST, LIBSHAREDDATAMGR.CUSTOMERS FOLLNOTIFCUST_1ST, LIBSHAREDDATAMGR.CUSTOMERS FOLLNOTIFCUST_2ND,
				LIBSHAREDDATAMGR.CUSTOMERS IMPLCUST, LIBSHAREDDATAMGR.CUSTOMERS AVAILCUST, LIBSHAREDDATAMGR.CUSTOMERS MODCUST
		WHERE	(CMR.CONFIGMGMTREQUESTID > 0 AND
				CMR.REQUESTERID = REQCUST.CUSTOMERID AND
				CMR.FISCALYEARID = FY.FISCALYEARID AND
				CMR.AUTHORIZERID = AUTHCUST.CUSTOMERID AND
				CMR.NOTIFIERID = NOTIFCUST.CUSTOMERID AND
				CMR.FOLLOWUPNOTIFIERID_1ST = FOLLNOTIFCUST_1ST.CUSTOMERID AND
				CMR.FOLLOWUPNOTIFIERID_2ND = FOLLNOTIFCUST_2ND.CUSTOMERID AND
				CMR.IMPLEMENTERID = IMPLCUST.CUSTOMERID AND
				CMR.AVAILABILITYNOTIFIERID = AVAILCUST.CUSTOMERID AND
				CMR.MODIFIEDBYID = MODCUST.CUSTOMERID) AND (
			<CFIF #FORM.FISCALYEARID# GT 0>
				<CFIF IsDefined("FORM.NEGATEFISCALYEARID")>
					NOT CMR.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
				<CFELSE>
					CMR.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.CHANGENUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATECHANGENUMBER")>
					<CFIF CHANGENUMLIST EQ "YES">
						NOT CMR.CHANGENUMBER IN (#PreserveSingleQuotes(FORM.CHANGENUMBER)#) #LOGICANDOR#
					<CFELSE>
						NOT CMR.CHANGENUMBER LIKE UPPER('%#FORM.CHANGENUMBER#%') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF CHANGENUMLIST EQ "YES">
						CMR.CHANGENUMBER IN (#PreserveSingleQuotes(FORM.CHANGENUMBER)#) #LOGICANDOR#
					<CFELSE>
						CMR.CHANGENUMBER LIKE UPPER('%#FORM.CHANGENUMBER#%') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>
			
			<CFIF #FORM.SYSTEM# NEQ "">
				<CFIF IsDefined("FORM.NEGATESYSTEM")>
					NOT CMR.SYSTEM LIKE UPPER('%#FORM.SYSTEM#%') #LOGICANDOR#
				<CFELSE>
					CMR.SYSTEM LIKE UPPER('%#FORM.SYSTEM#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.REQUESTERID# GT 0>
				<CFIF IsDefined("FORM.NEGATEREQUESTERID")>
					NOT CMR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
				<CFELSE>
					CMR.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.REQUESTDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEREQUESTDATE")>
					<CFIF REQUESTDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(REQUESTDATEARRAY)#>
							<CFSET FORMATREQUESTDATE =  DateFormat(#REQUESTDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF REQUESTDATERANGE EQ "YES">
						NOT (CMR.REQUESTDATE BETWEEN TO_DATE('#BEGINREQUESTDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.REQUESTDATE LIKE TO_DATE('#FORM.REQUESTDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF REQUESTDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(REQUESTDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATREQUESTDATE = DateFormat(#REQUESTDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATREQUESTDATE = DateFormat(#REQUESTDATEARRAY[ArrayLen(REQUESTDATEARRAY)]#, 'DD-MMM-YYYY')>
						CMR.REQUESTDATE = TO_DATE('#FORMATREQUESTDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF REQUESTDATERANGE EQ "YES">
							(CMR.REQUESTDATE BETWEEN TO_DATE('#BEGINREQUESTDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.REQUESTDATE LIKE TO_DATE('#FORM.REQUESTDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.CHANGEDESCRIPTION# NEQ "">
				<CFIF IsDefined("FORM.NEGATECHANGEDESCRIPTION")>
					NOT CMR.CHANGEDESCRIPTION LIKE UPPER('%#FORM.CHANGEDESCRIPTION#%') #LOGICANDOR#
				<CFELSE>
					CMR.CHANGEDESCRIPTION LIKE UPPER('%#FORM.CHANGEDESCRIPTION#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.CHANGEJUSTIFICATION# NEQ "">
				<CFIF IsDefined("FORM.NEGATECHANGEJUSTIFICATION")>
					NOT CMR.CHANGEJUSTIFICATION LIKE UPPER('%#FORM.CHANGEJUSTIFICATION#%') #LOGICANDOR#
				<CFELSE>
					CMR.CHANGEJUSTIFICATION LIKE UPPER('%#FORM.CHANGEJUSTIFICATION#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.AUTHORIZERID# GT 0>
				<CFIF IsDefined("FORM.NEGATEAUTHORIZERID")>
					NOT CMR.AUTHORIZERID = #val(FORM.AUTHORIZERID)# #LOGICANDOR#
				<CFELSE>
					CMR.AUTHORIZERID = #val(FORM.AUTHORIZERID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.AUTHORIZATIONDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEAUTHORIZATIONDATE")>
					<CFIF AUTHORIZATIONDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(AUTHORIZATIONDATEARRAY)#>
							<CFSET FORMATAUTHORIZATIONDATE =  DateFormat(#AUTHORIZATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.AUTHORIZATIONDATE = TO_DATE('#FORMATAUTHORIZATIONDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF AUTHORIZATIONDATERANGE EQ "YES">
						NOT (CMR.AUTHORIZATIONDATE BETWEEN TO_DATE('#BEGINAUTHORIZATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDAUTHORIZATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.AUTHORIZATIONDATE LIKE TO_DATE('#FORM.AUTHORIZATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF AUTHORIZATIONDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(AUTHORIZATIONDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATAUTHORIZATIONDATE = DateFormat(#AUTHORIZATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.AUTHORIZATIONDATE = TO_DATE('#FORMATAUTHORIZATIONDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATAUTHORIZATIONDATE = DateFormat(#AUTHORIZATIONDATEARRAY[ArrayLen(AUTHORIZATIONDATEARRAY)]#, 'DD-MMM-YYYY')>
						CMR.AUTHORIZATIONDATE = TO_DATE('#FORMATAUTHORIZATIONDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF AUTHORIZATIONDATERANGE EQ "YES">
							(CMR.AUTHORIZATIONDATE BETWEEN TO_DATE('#BEGINAUTHORIZATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDAUTHORIZATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.AUTHORIZATIONDATE LIKE TO_DATE('#FORM.AUTHORIZATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.SERVERADMCOMMENTS# NEQ "">
				<CFIF IsDefined("FORM.NEGATESERVERADMCOMMENTS")>
					NOT CMR.SERVERADMCOMMENTS LIKE UPPER('%#FORM.SERVERADMCOMMENTS#%') #LOGICANDOR#
				<CFELSE>
					CMR.SERVERADMCOMMENTS LIKE UPPER('%#FORM.SERVERADMCOMMENTS#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.CHANGESCHEDULED# NEQ "Make a Selection">
					CMR.CHANGESCHEDULED = UPPER('#FORM.CHANGESCHEDULED#') #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.NOTIFICATIONDESCRIPTION# NEQ "">
				<CFIF IsDefined("FORM.NEGATENOTIFICATIONDESCRIPTION")>
					NOT CMR.NOTIFICATIONDESCRIPTION LIKE UPPER('%#FORM.NOTIFICATIONDESCRIPTION#%') #LOGICANDOR#
				<CFELSE>
					CMR.NOTIFICATIONDESCRIPTION LIKE UPPER('%#FORM.NOTIFICATIONDESCRIPTION#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.NOTIFIERID# GT 0>
				<CFIF IsDefined("FORM.NEGATENOTIFIERID")>
					NOT CMR.NOTIFIERID = #val(FORM.NOTIFIERID)# #LOGICANDOR#
				<CFELSE>
					CMR.NOTIFIERID = #val(FORM.NOTIFIERID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.NOTIFICATIONDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATENOTIFICATIONDATE")>
					<CFIF NOTIFICATIONDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(NOTIFICATIONDATEARRAY)#>
							<CFSET FORMATNOTIFICATIONDATE =  DateFormat(#NOTIFICATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.NOTIFICATIONDATE = TO_DATE('#FORMATNOTIFICATIONDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF NOTIFICATIONDATERANGE EQ "YES">
						NOT (CMR.NOTIFICATIONDATE BETWEEN TO_DATE('#BEGINNOTIFICATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDNOTIFICATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.NOTIFICATIONDATE LIKE TO_DATE('#FORM.NOTIFICATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF NOTIFICATIONDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(NOTIFICATIONDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATNOTIFICATIONDATE = DateFormat(#NOTIFICATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.NOTIFICATIONDATE = TO_DATE('#FORMATNOTIFICATIONDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATNOTIFICATIONDATE = DateFormat(#NOTIFICATIONDATEARRAY[ArrayLen(NOTIFICATIONDATEARRAY)]#, 'DD-MMM-YYYY')>
						CMR.NOTIFICATIONDATE = TO_DATE('#FORMATNOTIFICATIONDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF NOTIFICATIONDATERANGE EQ "YES">
							(CMR.NOTIFICATIONDATE BETWEEN TO_DATE('#BEGINNOTIFICATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDNOTIFICATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.NOTIFICATIONDATE LIKE TO_DATE('#FORM.NOTIFICATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.FOLLOWUPDESCRIPTION_1ST# NEQ "">
				<CFIF IsDefined("FORM.NEGATEFOLLOWUPDESCR_1ST")>
					NOT CMR.FOLLOWUPDESCRIPTION_1ST LIKE UPPER('%#FORM.FOLLOWUPDESCRIPTION_1ST#%') #LOGICANDOR#
				<CFELSE>
					CMR.FOLLOWUPDESCRIPTION_1ST LIKE UPPER('%#FORM.FOLLOWUPDESCRIPTION_1ST#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.FOLLOWUPNOTIFIERID_1ST# GT 0>
				<CFIF IsDefined("FORM.NEGATEFOLLOWUPNOTIFIERID_1ST")>
					NOT CMR.FOLLOWUPNOTIFIERID_1ST = #val(FORM.FOLLOWUPNOTIFIERID_1ST)# #LOGICANDOR#
				<CFELSE>
					CMR.FOLLOWUPNOTIFIERID_1ST = #val(FORM.FOLLOWUPNOTIFIERID_1ST)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.FOLLOWUPDATE_1ST#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEFOLLOWUPDATE_1ST")>
					<CFIF FOLLOWUPDATE_1ST_LIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(FOLLOWUPDATE_1ST_ARRAY)#>
							<CFSET FORMATFOLLOWUPDATE_1ST =  DateFormat(#FOLLOWUPDATE_1ST_ARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.FOLLOWUPDATE_1ST = TO_DATE('#FORMATFOLLOWUPDATE_1ST#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF FOLLOWUPDATE_1ST_RANGE EQ "YES">
						NOT (CMR.FOLLOWUPDATE_1ST BETWEEN TO_DATE('#BEGINFOLLOWUPDATE_1ST#', 'DD-MON-YYYY') AND TO_DATE('#ENDFOLLOWUPDATE_1ST#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.FOLLOWUPDATE_1ST LIKE TO_DATE('#FORM.FOLLOWUPDATE_1ST#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF FOLLOWUPDATE_1ST_LIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(FOLLOWUPDATE_1ST_ARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATFOLLOWUPDATE_1ST = DateFormat(#FOLLOWUPDATE_1ST_ARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.FOLLOWUPDATE_1ST = TO_DATE('#FORMATFOLLOWUPDATE_1ST#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATFOLLOWUPDATE_1ST = DateFormat(#FOLLOWUPDATE_1ST_ARRAY[ArrayLen(FOLLOWUPDATE_1ST_ARRAY)]#, 'DD-MMM-YYYY')>
						CMR.FOLLOWUPDATE_1ST = TO_DATE('#FORMATFOLLOWUPDATE_1ST#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF FOLLOWUPDATE_1ST_RANGE EQ "YES">
							(CMR.FOLLOWUPDATE_1ST BETWEEN TO_DATE('#BEGINFOLLOWUPDATE_1ST#', 'DD-MON-YYYY') AND TO_DATE('#ENDFOLLOWUPDATE_1ST#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.FOLLOWUPDATE_1ST LIKE TO_DATE('#FORM.FOLLOWUPDATE_1ST#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.FOLLOWUPDESCRIPTION_2ND# NEQ "">
				<CFIF IsDefined("FORM.NEGATEFOLLOWUPDESCR_2ND")>
					NOT CMR.FOLLOWUPDESCRIPTION_2ND LIKE UPPER('%#FORM.FOLLOWUPDESCRIPTION_2ND#%') #LOGICANDOR#
				<CFELSE>
					CMR.FOLLOWUPDESCRIPTION_2ND LIKE UPPER('%#FORM.FOLLOWUPDESCRIPTION_2ND#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.FOLLOWUPNOTIFIERID_2ND# GT 0>
				<CFIF IsDefined("FORM.NEGATEFOLLOWUPNOTIFIERID_2ND")>
					NOT CMR.FOLLOWUPNOTIFIERID_2ND = #val(FORM.FOLLOWUPNOTIFIERID_2ND)# #LOGICANDOR#
				<CFELSE>
					CMR.FOLLOWUPNOTIFIERID_2ND = #val(FORM.FOLLOWUPNOTIFIERID_2ND)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.FOLLOWUPDATE_2ND#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEFOLLOWUPDATE_2ND")>
					<CFIF FOLLOWUPDATE_2ND_LIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(FOLLOWUPDATE_2ND_ARRAY)#>
							<CFSET FORMATFOLLOWUPDATE_2ND =  DateFormat(#FOLLOWUPDATE_2ND_ARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.FOLLOWUPDATE_2ND = TO_DATE('#FORMATFOLLOWUPDATE_2ND#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF FOLLOWUPDATE_2ND_RANGE EQ "YES">
						NOT (CMR.FOLLOWUPDATE_2ND BETWEEN TO_DATE('#BEGINFOLLOWUPDATE_2ND#', 'DD-MON-YYYY') AND TO_DATE('#ENDFOLLOWUPDATE_2ND#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.FOLLOWUPDATE_2ND LIKE TO_DATE('#FORM.FOLLOWUPDATE_2ND#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF FOLLOWUPDATE_2ND_LIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(FOLLOWUPDATE_2ND_ARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATFOLLOWUPDATE_2ND = DateFormat(#FOLLOWUPDATE_2ND_ARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.FOLLOWUPDATE_2ND = TO_DATE('#FORMATFOLLOWUPDATE_2ND#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATFOLLOWUPDATE_2ND = DateFormat(#FOLLOWUPDATE_2ND_ARRAY[ArrayLen(FOLLOWUPDATE_2ND_ARRAY)]#, 'DD-MMM-YYYY')>
						CMR.FOLLOWUPDATE_2ND = TO_DATE('#FORMATFOLLOWUPDATE_2ND#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF FOLLOWUPDATE_2ND_RANGE EQ "YES">
							(CMR.FOLLOWUPDATE_2ND BETWEEN TO_DATE('#BEGINFOLLOWUPDATE_2ND#', 'DD-MON-YYYY') AND TO_DATE('#ENDFOLLOWUPDATE_2ND#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.FOLLOWUPDATE_2ND LIKE TO_DATE('#FORM.FOLLOWUPDATE_2ND#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF "#FORM.BACKUPDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEBACKUPDATE")>
					<CFIF BACKUPDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(BACKUPDATEARRAY)#>
							<CFSET FORMATBACKUPDATE =  DateFormat(#BACKUPDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.BACKUPDATE = TO_DATE('#FORMATBACKUPDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF BACKUPDATERANGE EQ "YES">
						NOT (CMR.BACKUPDATE BETWEEN TO_DATE('#BEGINBACKUPDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDBACKUPDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.BACKUPDATE LIKE TO_DATE('#FORM.BACKUPDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF BACKUPDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(BACKUPDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATBACKUPDATE = DateFormat(#BACKUPDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.BACKUPDATE = TO_DATE('#FORMATBACKUPDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATBACKUPDATE = DateFormat(#BACKUPDATEARRAY[ArrayLen(BACKUPDATEARRAY)]#, 'DD-MMM-YYYY')>
						CMR.BACKUPDATE = TO_DATE('#FORMATBACKUPDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF BACKUPDATERANGE EQ "YES">
							(CMR.BACKUPDATE BETWEEN TO_DATE('#BEGINBACKUPDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDBACKUPDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.BACKUPDATE LIKE TO_DATE('#FORM.BACKUPDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.IMPLEMENTERID# GT 0>
				<CFIF IsDefined("FORM.NEGATEIMPLEMENTERID")>
					NOT CMR.IMPLEMENTERID = #val(FORM.IMPLEMENTERID)# #LOGICANDOR#
				<CFELSE>
					CMR.IMPLEMENTERID = #val(FORM.IMPLEMENTERID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.CHANGEDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATECHANGEDATE")>
					<CFIF CHANGEDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(CHANGEDATEARRAY)#>
							<CFSET FORMATCHANGEDATE =  DateFormat(#CHANGEDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.CHANGEDATE = TO_DATE('#FORMATCHANGEDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF CHANGEDATERANGE EQ "YES">
						NOT (CMR.CHANGEDATE BETWEEN TO_DATE('#BEGINCHANGEDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCHANGEDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.CHANGEDATE LIKE TO_DATE('#FORM.CHANGEDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF CHANGEDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(CHANGEDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATCHANGEDATE = DateFormat(#CHANGEDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.CHANGEDATE = TO_DATE('#FORMATCHANGEDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATCHANGEDATE = DateFormat(#CHANGEDATEARRAY[ArrayLen(CHANGEDATEARRAY)]#, 'DD-MMM-YYYY')>
						CMR.CHANGEDATE = TO_DATE('#FORMATCHANGEDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF CHANGEDATERANGE EQ "YES">
							(CMR.CHANGEDATE BETWEEN TO_DATE('#BEGINCHANGEDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCHANGEDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.CHANGEDATE LIKE TO_DATE('#FORM.CHANGEDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.IMPLEMENTATIONDESCRIPTION# NEQ "">
				<CFIF IsDefined("FORM.NEGATEIMPLEMENTATIONDESCRIPTION")>
					NOT CMR.IMPLEMENTATIONDESCRIPTION LIKE UPPER('%#FORM.IMPLEMENTATIONDESCRIPTION#%') #LOGICANDOR#
				<CFELSE>
					CMR.IMPLEMENTATIONDESCRIPTION LIKE UPPER('%#FORM.IMPLEMENTATIONDESCRIPTION#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.TESTINGMONITORDESCRIPTION# NEQ "">
				<CFIF IsDefined("FORM.NEGATETESTINGMONITORDESCRIPTION")>
					NOT CMR.TESTINGMONITORDESCRIPTION LIKE UPPER('%#FORM.TESTINGMONITORDESCRIPTION#%') #LOGICANDOR#
				<CFELSE>
					CMR.TESTINGMONITORDESCRIPTION LIKE UPPER('%#FORM.TESTINGMONITORDESCRIPTION#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.CHANGESTATUS# NEQ " Make a Selection">
				<CFIF IsDefined("FORM.NEGATECHANGESTATUS")>
					NOT CMR.CHANGESTATUS = UPPER('#FORM.CHANGESTATUS#') #LOGICANDOR#
				<CFELSE>
					CMR.CHANGESTATUS = UPPER('#FORM.CHANGESTATUS#') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.AVAILABILITYDESCRIPTION# NEQ "">
				<CFIF IsDefined("FORM.NEGATEAVAILABILITYDESCRIPTION")>
					NOT CMR.AVAILABILITYDESCRIPTION LIKE UPPER('%#FORM.AVAILABILITYDESCRIPTION#%') #LOGICANDOR#
				<CFELSE>
					CMR.AVAILABILITYDESCRIPTION LIKE UPPER('%#FORM.AVAILABILITYDESCRIPTION#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.AVAILABILITYNOTIFIERID# GT 0>
				<CFIF IsDefined("FORM.NEGATEAVAILABILITYNOTIFIERID")>
					NOT CMR.AVAILABILITYNOTIFIERID = #val(FORM.AVAILABILITYNOTIFIERID)# #LOGICANDOR#
				<CFELSE>
					CMR.AVAILABILITYNOTIFIERID = #val(FORM.AVAILABILITYNOTIFIERID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.AVAILABILITYDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEAVAILABILITYDATE")>
					<CFIF AVAILABILITYDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(AVAILABILITYDATEARRAY)#>
							<CFSET FORMATAVAILABILITYDATE =  DateFormat(#AVAILABILITYDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.AVAILABILITYDATE = TO_DATE('#FORMATAVAILABILITYDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF AVAILABILITYDATERANGE EQ "YES">
						NOT (CMR.AVAILABILITYDATE BETWEEN TO_DATE('#BEGINAVAILABILITYDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDAVAILABILITYDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.AVAILABILITYDATE LIKE TO_DATE('#FORM.AVAILABILITYDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF AVAILABILITYDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(AVAILABILITYDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATAVAILABILITYDATE = DateFormat(#AVAILABILITYDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.AVAILABILITYDATE = TO_DATE('#FORMATAVAILABILITYDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATAVAILABILITYDATE = DateFormat(#AVAILABILITYDATEARRAY[ArrayLen(AVAILABILITYDATEARRAY)]#, 'DD-MMM-YYYY')>
						CMR.AVAILABILITYDATE = TO_DATE('#FORMATAVAILABILITYDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF AVAILABILITYDATERANGE EQ "YES">
							(CMR.AVAILABILITYDATE BETWEEN TO_DATE('#BEGINAVAILABILITYDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDAVAILABILITYDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.AVAILABILITYDATE LIKE TO_DATE('#FORM.AVAILABILITYDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODIFIEDBYID# GT 0>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
					NOT CMR.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				<CFELSE>
					CMR.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
					<CFIF MODIFIEDDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
							<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT CMR.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						NOT (CMR.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT CMR.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF MODIFIEDDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							CMR.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
						CMR.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF MODIFIEDDATERANGE EQ "YES">
							(CMR.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						CMR.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

				CMR.MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	KEYFINDER
	</CFQUERY>

	<CFIF #LookupCMRequests.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Configuration Management Request Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/configmgmt/configmgmtdbreport.cfm" />
		<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
				<H1>IDT Configuration Management - Requests Report</H1>
			</TH>
		</TR>
	</TABLE>
	<TABLE align="left" border="0">
		<TR>
<CFFORM action="/#application.type#apps/configmgmt/configmgmtdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
               </TD>
</CFFORM>
		</TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
			<TH align="CENTER" colspan="7"><H2>#LookupCMRequests.RecordCount# Configuration Management Request records were selected.</H2></TH>
		</TR>

	<CFLOOP query="LookupCMRequests">

		
		<TR>
			<TH align="CENTER" valign="BOTTOM">CM Request Change Number</TH>
			<TH align="CENTER" valign="BOTTOM">System</TH>
			<TH align="CENTER" valign="BOTTOM">Requester&nbsp;&nbsp;- &nbsp;&nbsp;Request Date</TH>
			<TH align="CENTER" valign="BOTTOM">Change Description</TH>
			<TH align="CENTER" valign="BOTTOM">Change Justification</TH>
			<TH align="CENTER" valign="BOTTOM">Authorizer</TH>
			<TH align="CENTER" valign="BOTTOM">Authorization Date</TH>
		</TR>
		<TR>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.CHANGENUMBER#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.SYSTEM#</DIV></TD>
			<TD align="CENTER" valign="TOP" nowrap><DIV>#LookupCMRequests.CUSTREQNAME#&nbsp;&nbsp;- &nbsp;&nbsp;#DateFormat(LookupCMRequests.REQUESTDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#LookupCMRequests.CHANGEDESCRIPTION#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#LookupCMRequests.CHANGEJUSTIFICATION#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.AUTHCUSTNAME#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#DateFormat(LookupCMRequests.AUTHORIZATIONDATE, "MM/DD/YYYY")#</DIV></TD>
		</TR>
		<TR>
			<TH align="CENTER" valign="BOTTOM">Server Adminstrator's Comments</TH>
			<TH align="CENTER" valign="BOTTOM">Notification Description</TH>
			<TH align="CENTER" valign="BOTTOM">Notifier</TH>
			<TH align="CENTER" valign="BOTTOM">Notification Date</TH>
			<TH align="CENTER" valign="BOTTOM">1st Follow-up Description</TH>
			<TH align="CENTER" valign="BOTTOM">1st Follow-up Notifier</TH>
			<TH align="CENTER" valign="BOTTOM">1st Follow-up Date</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP"><DIV>#LookupCMRequests.SERVERADMCOMMENTS#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#LookupCMRequests.NOTIFICATIONDESCRIPTION#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.NOTIFCUSTNAME#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#DateFormat(LookupCMRequests.NOTIFICATIONDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#LookupCMRequests.FOLLOWUPDESCRIPTION_1ST#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.FOLLNOTIFCUSTNAME_1ST#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#DateFormat(LookupCMRequests.FOLLOWUPDATE_1ST, "MM/DD/YYYY")#</DIV></TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="5">2nd Follow-up Description</TH>
			<TH align="CENTER" valign="BOTTOM">2nd Follow-up Notifier</TH>
			<TH align="CENTER" valign="BOTTOM">2nd Follow-up Date</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="5"><DIV>#LookupCMRequests.FOLLOWUPDESCRIPTION_2ND#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.FOLLNOTIFCUSTNAME_2ND#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#DateFormat(LookupCMRequests.FOLLOWUPDATE_2ND, "MM/DD/YYYY")#</DIV></TD>
		</TR>
		<TR>
			<TH align="CENTER" valign="BOTTOM">Backup Date</TH>
			<TH align="LEFT" valign="BOTTOM">Implementer</TH>
			<TH align="CENTER" valign="BOTTOM">Change Scheduled?</TH>
			<TH align="CENTER" valign="BOTTOM">Change Date</TH>
			<TH align="CENTER" valign="BOTTOM">Change Time</TH>
			<TH align="CENTER" valign="BOTTOM">Implementation Description</TH>
			<TH align="CENTER" valign="BOTTOM">Testing/Monitor Description</TH>
		</TR>
		<TR>
			<TD align="CENTER" valign="TOP"><DIV>#DateFormat(LookupCMRequests.BACKUPDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.IMPLCUSTNAME#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.CHANGESCHEDULED#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#DateFormat(LookupCMRequests.CHANGEDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#TimeFormat(LookupCMRequests.CHANGETIME, "hh:mm:ss tt")#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#LookupCMRequests.IMPLEMENTATIONDESCRIPTION#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#LookupCMRequests.TESTINGMONITORDESCRIPTION#</DIV></TD>
		</TR>
		<TR>
			<TH align="CENTER" valign="BOTTOM">Change Status</TH>
			<TH align="CENTER" valign="BOTTOM">Availability Description</TH>
			<TH align="CENTER" valign="BOTTOM">Availability Notifier</TH>
			<TH align="CENTER" valign="BOTTOM">Availability Date</TH>
			<TH align="CENTER" valign="BOTTOM">Fiscal Year</TH>
			<TH align="CENTER" valign="BOTTOM">Modified By</TH>
			<TH align="CENTER" valign="BOTTOM">Modified Date</TH>
		</TR>
		<TR>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.CHANGESTATUS#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#LookupCMRequests.AVAILABILITYDESCRIPTION#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.AVAILCUSTNAME#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#DateFormat(LookupCMRequests.AVAILABILITYDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.FISCALYEAR_4DIGIT#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#LookupCMRequests.MODCUSTNAME#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#DateFormat(LookupCMRequests.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
		<TR>
			<TD colspan="7"><HR width="100%" size="5" noshade /></TD>
		</TR>
	</CFLOOP>
	<BR />
		<TR>
			<TH align="CENTER" colspan="7"><H2>#LookupCMRequests.RecordCount# Configuration Management Request records were selected.</H2></TH>
		</TR>
           <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
<CFFORM action="/#application.type#apps/configmgmt/configmgmtdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="7"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>