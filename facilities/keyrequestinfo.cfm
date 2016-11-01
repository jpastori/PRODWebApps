<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: keyrequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/20/2012 --->
<!--- Date in Production: 02/20/2012 --->
<!--- Module: Add/Modify/Delete Information in Facilities - Key Requests --->
<!-- Last modified by John R. Pastori on 02/20/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/keyrequestinfo.cfm">
<CFSET CONTENT_UPDATED = "February 20, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Key Requests</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Key Requests</TITLE>
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


	function validateReqFields() {
		if (document.KEYREQUEST.KEYTYPEID.selectedIndex == "0") {
			alertuser (document.KEYREQUEST.KEYTYPEID.name +  ",  A Key Type MUST be selected!");
			document.KEYREQUEST.KEYTYPEID.focus();
			return false;
		}

		if (document.KEYREQUEST.DISPOSITION.selectedIndex == "0") {
			alertuser (document.KEYREQUEST.DISPOSITION.name +  ",  A Disposition MUST be selected!");
			document.KEYREQUEST.DISPOSITION.focus();
			return false;
		}

		if (document.KEYREQUEST.DOORSACCESSED.selectedIndex == "0") {
			alertuser (document.KEYREQUEST.DOORSACCESSED.name +  ", At least one Room Number MUST be selected!");
			document.KEYREQUEST.DOORSACCESSED.focus();
			return false;
		}

		if (document.KEYREQUEST.DAYSACCESSED.selectedIndex == "0") {
			alertuser (document.KEYREQUEST.DAYSACCESSED.name +  ", A Days Accessed option MUST be selected!");
			document.KEYREQUEST.DAYSACCESSED.focus();
			return false;
		}	

		if (document.KEYREQUEST.TIMESACCESSED.selectedIndex == "0") {
			alertuser (document.KEYREQUEST.TIMESACCESSED.name +  ",  A Times Accessed option MUST be selected!");
			document.KEYREQUEST.TIMESACCESSED.focus();
			return false;
		}

		if ((document.KEYREQUEST.RECEIVEDBYCUSTOMER != null && document.KEYREQUEST.RECEIVEDBYCUSTOMER.value == "YES")
		 && (document.KEYREQUEST.RECEIVEDBYDATE.value ==  "" || document.KEYREQUEST.RECEIVEDBYDATE.value ==  " " 
		 || !document.KEYREQUEST.RECEIVEDBYDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/))) {
			alertuser (document.KEYREQUEST.RECEIVEDBYDATE.name +  ",  A Received By Date MUST be entered in the format MM/DD/YYYY when Received By Customer is set to YES!");
			document.KEYREQUEST.RECEIVEDBYDATE.focus();
			return false;
		}
	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY onLoad="document.KEYREQUEST.KEYTYPEID.focus()">

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES">
	SELECT	WR.WORKREQUESTID, WR.REQUESTTYPEID, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER, WR.REQUESTDATE,
			WR.REQUESTERID, CUST.FULLNAME, WR.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER, WR.UNITID, U.UNITNAME
	FROM		WORKREQUESTS WR, LOCATIONS LOC, BUILDINGNAMES BN, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U
	WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#Cookie.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
			WR.LOCATIONID = LOC.LOCATIONID AND
			LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			WR.REQUESTERID = CUST.CUSTOMERID AND
			WR.UNITID = U.UNITID
	ORDER BY	WR.WORKREQUESTID
</CFQUERY>

<CFQUERY name="ListKeyRequestInfo" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	KR.KEYREQUESTID, KR.KEYREQUESTWRID, KR.KEYTYPEID, KR.KEYNUMBER, KR.HOOKNUMBER, KR.DOORSACCESSED, KR.DAYSACCESSED, KR.TIMESACCESSED,
			KR.OTHERDAYS, TO_CHAR(KR.OTHERWEEKDAYTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESFROM,
			TO_CHAR(KR.OTHERWEEKDAYTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESTHRU,
			TO_CHAR(KR.OTHERWEEKENDTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKENDTIMESFROM,
			TO_CHAR(KR.OTHERWEEKENDTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKENDTIMESTHRU,
			KR.ACCESSENDDATE, KR.DISPOSITION, KR.NUMBERREPLACED, KR.REPLACEDREASON, KR.RECEIVEDBYCUSTOMER,
			KR.RECEIVEDBYDATE
	FROM		KEYREQUESTS KR
	ORDER BY	KR.KEYREQUESTWRID
</CFQUERY>

<CFQUERY name="ListKeyTypes" datasource="#application.type#FACILITIES" blockfactor="6">
	SELECT	KEYTYPEID, KEYTYPENAME
	FROM		KEYTYPES
	ORDER BY	KEYTYPENAME
</CFQUERY>

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOCATIONID, ROOMNUMBER
	FROM		LOCATIONS
	WHERE	LOCATIONID > 0
	ORDER BY	ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListDaysOfWeek" datasource="#application.type#LIBSHAREDDATA" blockfactor="24">
	SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
	FROM		DAYSOFWEEK
	WHERE	DAYSOFWEEKID > 0
	ORDER BY	DAYSOFWEEKID
</CFQUERY>

<CFQUERY name="ListHours" datasource="#application.type#LIBSHAREDDATA" blockfactor="44">
	SELECT	DISTINCT HOURSTEXT
	FROM		HOURS
	WHERE	SUBSTR(HOURSTEXT,-2,2) = 'AM'
	ORDER BY	HOURSTEXT
</CFQUERY>

<CFIF IsDefined('session.KEYCOUNTER')>
	SESSION KEY COUNTER = #session.KEYCOUNTER#
</CFIF>

<!--- 
*****************************************************************
* The following code is the ADD Process for Key Request Orders. *
*****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(KEYREQUESTID) AS MAX_ID
		FROM		KEYREQUESTS
	</CFQUERY>
	<CFSET FORM.KEYREQUESTID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="KEYREQUESTID" secure="NO" value="#FORM.KEYREQUESTID#">
	<CFQUERY name="AddKeyRequestID" datasource="#application.type#FACILITIES">
		INSERT INTO	KEYREQUESTS (KEYREQUESTID, KEYREQUESTWRID)
		VALUES		(#val(Cookie.KEYREQUESTID)#, #val(Cookie.WORKREQUESTID)#)
	</CFQUERY>
	<CFQUERY name="UpdateWorkRequests" datasource="#application.type#FACILITIES">
		UPDATE	WORKREQUESTS
		SET		WORKREQUESTS.KEYREQUEST = 'YES'
		WHERE	(WORKREQUESTS.WORKREQUESTID = #val(Cookie.WORKREQUESTID)#)
	</CFQUERY>


	<TABLE width="100%" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add Key Requests</H1></TD>
		</TR>
	</TABLE>

	<TABLE align="left" width="100%" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				Key ID:&nbsp;&nbsp; <H5>#FORM.KEYREQUESTID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(ListWorkRequests.REQUESTDATE, "mm/dd/yyyy")#</H5>
			</TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="2">
				Work Request Number:&nbsp;&nbsp;
				<H5>#ListWorkRequests.WORKREQUESTNUMBER#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Requester Name:&nbsp;&nbsp;
				<H5>#ListWorkRequests.FULLNAME#</H5><BR />
				Unit Name:&nbsp;&nbsp;
				<H5>#ListWorkRequests.UNITNAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Building Name:&nbsp;&nbsp;
				<H5>#ListWorkRequests.BUILDINGNAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Room Number:&nbsp;&nbsp;
				<H5>#ListWorkRequests.ROOMNUMBER#</H5>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processkeyrequestinfo.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessKeyRequestInfo" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="KEYREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processkeyrequestinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="KEYTYPEID">*Key/Card Type</LABEL></H4></TH>
			<TH align="left"><LABEL for="KEYNUMBER">Key Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="KEYTYPEID" id="KEYTYPEID" size="1" query="ListKeyTypes" value="KEYTYPEID" display="KEYTYPENAME" required="No" selected="" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="KEYNUMBER" id="KEYNUMBER" value="" align="LEFT" required="No" size="16" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="HOOKNUMBER">Hook Number</LABEL></TH>
			<TH align="left"><H4><LABEL for="DISPOSITION">*Disposition</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="HOOKNUMBER" id="HOOKNUMBER" value="" align="LEFT" required="No" size="10" tabindex="4"></TD>
			<TD align="left">
				<CFSELECT name="DISPOSITION" id="DISPOSITION" size="1" required="No" tabindex="5">
					<OPTION value="0">DISPOSITION</OPTION>
					<OPTION value="NEW">NEW</OPTION>
					<OPTION value="RENEW">RENEW</OPTION>
					<OPTION value="REPLACE">REPLACE</OPTION>
					<OPTION value="REVISION">REVISION</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left">
               	<H4><LABEL for="DOORSACCESSED">
               		*Doors Accessed (Optional Multiple Selections Allowed)  <BR />
                         The maximum number of Room Requests is 5.
                    </LABEL></H4>
               </TH>
			<TH align="left"><LABEL for="NUMBERREPLACED">Key Number Replaced</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="DOORSACCESSED" id="DOORSACCESSED" size="10" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" required="No" multiple="yes" tabindex="6"></CFSELECT><BR />
				<COM>(Hold down the shift key when clicking for a range of doors to be accessed.  <BR />
					Use control key and left mouse click (PC) or command key when clicking (Mac) on specific doors to be accessed.)
				</COM>
			</TD>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="NUMBERREPLACED" id="NUMBERREPLACED" value="" align="LEFT" required="No" size="16" tabindex="7"></TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="DAYSACCESSED">*Days Accessed</LABEL></H4></TH>
			<TH align="left"><LABEL for="REPLACEDREASON">Replaced Reason</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="DAYSACCESSED" id="DAYSACCESSED" size="1" required="No" tabindex="8">
					<OPTION value="0">DAYS ACCESSED</OPTION>
					<OPTION value="ALL DAYS">ALL DAYS</OPTION>
					<OPTION value="WORK DAYS">WORK DAYS</OPTION>
					<OPTION value="NON-WORK DAYS">NON-WORK DAYS</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="REPLACEDREASON" id="REPLACEDREASON" tabindex="10">
					<OPTION value="REASON">REASON</OPTION>
					<OPTION value="LOST">LOST</OPTION>
					<OPTION value="STOLEN">STOLEN</OPTION>
					<OPTION value="DAMAGED">DAMAGED</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="OTHERDAYS">Other Days (Optional Multiple Selections Allowed)</LABEL></TH>
			<TH align="left"><H4><LABEL for="TIMESACCESSED">*Times Accessed</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="OTHERDAYS" id="OTHERDAYS" size="7" query="ListDaysOfWeek" value="DAYSOFWEEKNAME" display="DAYSOFWEEKNAME" required="No" multiple="yes" tabindex="11"></CFSELECT><BR />
				<COM>(If you selected "OTHER" for "Days Accessed" above, hold down the shift key when clicking for a range of days to be accessed.<BR />
					Use control key and left mouse click (PC) or command key when clicking (Mac) on specific days to be accessed.)
				</COM>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="TIMESACCESSED" id="TIMESACCESSED" size="1" required="No" tabindex="9">
					<OPTION value="0">TIMES ACCESSED</OPTION>
					<OPTION value="24-HOUR">24-HOUR</OPTION>
					<OPTION value="OTHER">OTHER</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<COM>(If you selected "OTHER" for "Times Accessed" above, please fill out the appropriate "From" and "Thru" times below.)</COM>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="OTHERWEEKDAYFROMHOURS">Other WeekDay Hours From</LABEL></TH>
			<TH align="left"><LABEL for="OTHERWEEKDAYTHRUHOURS">Other WeekDay Hours Thru</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="OTHERWEEKDAYFROMHOURS" id="OTHERWEEKDAYFROMHOURS" tabindex="12">
					<OPTION value=""> SELECT WEEKDAY HOURS</OPTION>
					<CFLOOP query="ListHours">
						<OPTION value="#TimeFormat(ListHours.HoursText,'hh')#">#TimeFormat(ListHours.HoursText,'hh')#</OPTION>
					</CFLOOP>
				</CFSELECT>
				:
				<LABEL for="OTHERWEEKDAYFROMMINUTES" class="LABEL_hidden">Other Weekday From Minutes</LABEL>
				<CFSELECT name="OTHERWEEKDAYFROMMINUTES" id="OTHERWEEKDAYFROMMINUTES" tabindex="13">
					<OPTION value=""> SELECT WEEKDAY MINUTES</OPTION>
					<OPTION value="00">00</OPTION>
					<OPTION value="15">15</OPTION>
					<OPTION value="30">30</OPTION>
					<OPTION value="45">45</OPTION>
				</CFSELECT>
				&nbsp;&nbsp;
				<LABEL for="OTHERWEEKDAYFROMAMPM" class="LABEL_hidden">Other Weekday From AMPM</LABEL>
				<CFSELECT name="OTHERWEEKDAYFROMAMPM" id="OTHERWEEKDAYFROMAMPM" tabindex="14">
					<OPTION value=""> SELECT WEEKDAY AMPM</OPTION>
					<OPTION value="AM">AM</OPTION>
					<OPTION value="PM">PM</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="OTHERWEEKDAYTHRUHOURS" id="OTHERWEEKDAYTHRUHOURS" tabindex="15">
					<OPTION value=""> SELECT WD THRU HOURS</OPTION>
					<CFLOOP query="ListHours">
						<OPTION value="#TimeFormat(ListHours.HoursText,'hh')#">#TimeFormat(ListHours.HoursText,'hh')#</OPTION>
					</CFLOOP>
				</CFSELECT>
				:
				<LABEL for="OTHERWEEKDAYTHRUMINUTES" class="LABEL_hidden">Other Weekday Thru Minutes</LABEL>
				<CFSELECT name="OTHERWEEKDAYTHRUMINUTES" id="OTHERWEEKDAYTHRUMINUTES" tabindex="16">
					<OPTION value=""> SELECT WD THRU MINUTES</OPTION>
					<OPTION value="00">00</OPTION>
					<OPTION value="15">15</OPTION>
					<OPTION value="30">30</OPTION>
					<OPTION value="45">45</OPTION>
				</CFSELECT>
				&nbsp;&nbsp;
				<LABEL for="OTHERWEEKDAYTHRUAMPM" class="LABEL_hidden">Other Weekday Thru AMPM</LABEL>
				<CFSELECT name="OTHERWEEKDAYTHRUAMPM" id="OTHERWEEKDAYTHRUAMPM" tabindex="17">
					<OPTION value=""> SELECT WD THRU AMPM</OPTION>
					<OPTION value="AM">AM</OPTION>
					<OPTION value="PM">PM</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="OTHERWEEKENDFROMHOURS">Other WeekEnd Hours From</LABEL></TH>
			<TH align="left"><LABEL for="OTHERWEEKENDTHRUHOURS">Other WeekEnd Hours Thru</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="OTHERWEEKENDFROMHOURS" id="OTHERWEEKENDFROMHOURS" tabindex="18">
					<OPTION value=""> SELECT WEEKEND HOURS</OPTION>
					<CFLOOP query="ListHours">
						<OPTION value="#TimeFormat(ListHours.HoursText,'hh')#">#TimeFormat(ListHours.HoursText,'hh')#</OPTION>
					</CFLOOP>
				</CFSELECT>
				:
				<LABEL for="OTHERWEEKENDFROMMINUTES" class="LABEL_hidden">Other Weekend From Minutes</LABEL>
				<CFSELECT name="OTHERWEEKENDFROMMINUTES" id="OTHERWEEKENDFROMMINUTES" tabindex="19">
					<OPTION value=""> SELECT WEEKEND MINUTES</OPTION>
					<OPTION value="00">00</OPTION>
					<OPTION value="15">15</OPTION>
					<OPTION value="30">30</OPTION>
					<OPTION value="45">45</OPTION>
				</CFSELECT>
				&nbsp;&nbsp;
				<LABEL for="OTHERWEEKENDFROMAMPM" class="LABEL_hidden">Other Weekend From AMPM</LABEL>
				<CFSELECT name="OTHERWEEKENDFROMAMPM" id="OTHERWEEKENDFROMAMPM" tabindex="20">
					<OPTION value=""> SELECT WEEKEND AMPM</OPTION>
					<OPTION value="AM">AM</OPTION>
					<OPTION value="PM">PM</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="OTHERWEEKENDTHRUHOURS" id="OTHERWEEKENDTHRUHOURS" tabindex="21">
					<OPTION value=""> SELECT WE THRU HOURS</OPTION>
					<CFLOOP query="ListHours">
						<OPTION value="#TimeFormat(ListHours.HoursText,'hh')#">#TimeFormat(ListHours.HoursText,'hh')#</OPTION>
					</CFLOOP>
				</CFSELECT>
				:
				<LABEL for="OTHERWEEKENDTHRUMINUTES" class="LABEL_hidden">Other Weekend Thru Minutes</LABEL>
				<CFSELECT name="OTHERWEEKENDTHRUMINUTES" id="OTHERWEEKENDTHRUMINUTES" tabindex="22">
					<OPTION value=""> SELECT WE THRU MINUTES</OPTION>
					<OPTION value="00">00</OPTION>
					<OPTION value="15">15</OPTION>
					<OPTION value="30">30</OPTION>
					<OPTION value="45">45</OPTION>
				</CFSELECT>
				&nbsp;&nbsp;
				<LABEL for="OTHERWEEKENDTHRUAMPM" class="LABEL_hidden">Other Weekend Thru AMPM</LABEL>
				<CFSELECT name="OTHERWEEKENDTHRUAMPM" id="OTHERWEEKENDTHRUAMPM" tabindex="23">
					<OPTION value=""> SELECT WE THRU  AMPM</OPTION>
					<OPTION value="AM">AM</OPTION>
					<OPTION value="PM">PM</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ACCESSENDDATE">Access End Date</LABEL></TH>
		<CFIF NOT IsDefined('session.KEYCOUNTER') OR session.KEYCOUNTER LT 2>
			<TH align="left"><LABEL for="NUMKEYSNEEDED">Number Of Keys Needed</LABEL></TH>
		<CFELSE>
			<TH align="left">&nbsp;&nbsp;</TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="ACCESSENDDATE" id="ACCESSENDDATE" size="1" required="No" tabindex="24">
					<OPTION value=#DateFormat("31-DEC-9999", "dd-mmm-yyyy")#>INDEFINITE</OPTION>
					<OPTION value=#DateFormat(NOW()+365, "dd-mmm-yyyy")#>#DateFormat(NOW()+365, "mm/dd/yyyy")#</OPTION>
				</CFSELECT>
			</TD>
		<CFIF NOT IsDefined('session.KEYCOUNTER') OR session.KEYCOUNTER LT 2>
			<TD align="left">
				<CFSELECT name="NUMKEYSNEEDED" id="NUMKEYSNEEDED" size="1" tabindex="25">
					<OPTION value="1">1</OPTION>
					<OPTION value="2">2</OPTION>
					<OPTION value="3">3</OPTION>
					<OPTION value="4">4</OPTION>
					<OPTION value="5">5</OPTION>
					<OPTION value="6">6</OPTION>
				</CFSELECT>
			</TD>
		<CFELSE>
			<TD align="left">&nbsp;&nbsp;</TD>
		</CFIF>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessKeyRequestInfo" value="ADD" tabindex="26" />&nbsp;&nbsp;<COM><--(Adds info above & completes the request.)</COM><BR />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/processkeyrequestinfo.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessKeyRequestInfo" value="CANCELADD" tabindex="27" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
	
<CFELSE>

<!--- 
**************************************************************************
* The following code is the Modify/Delete Process for Key Request Orders.*
**************************************************************************
 --->
	<CFQUERY name="GetWorkRequests" datasource="#application.type#FACILITIES">
		SELECT	WR.WORKREQUESTID, WR.REQUESTTYPEID, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER, WR.REQUESTDATE,
				WR.REQUESTERID, CUST.FULLNAME, WR.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER, WR.UNITID, U.UNITNAME
		FROM		WORKREQUESTS WR, LOCATIONS LOC, BUILDINGNAMES BN, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U
		WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#Cookie.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WR.LOCATIONID = LOC.LOCATIONID AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				WR.REQUESTERID = CUST.CUSTOMERID AND
				WR.UNITID = U.UNITID
		ORDER BY	WR.WORKREQUESTID
	</CFQUERY>

	<CFIF IsDefined ('URL.INITREQ') AND URL.INITREQ EQ "WO">
		<CFQUERY name="LookupKeyRequestInfo" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	KR.KEYREQUESTID, KR.KEYREQUESTWRID, KR.KEYTYPEID, KR.KEYNUMBER, KR.HOOKNUMBER, KR.DOORSACCESSED, KR.DAYSACCESSED,
					KR.TIMESACCESSED, KR.OTHERDAYS, TO_CHAR(KR.OTHERWEEKDAYTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESFROM,
					TO_CHAR(KR.OTHERWEEKDAYTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESTHRU,
					TO_CHAR(KR.OTHERWEEKENDTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKENDTIMESFROM,
					TO_CHAR(KR.OTHERWEEKENDTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKENDTIMESTHRU,
					KR.ACCESSENDDATE, KR.DISPOSITION, KR.NUMBERREPLACED, KR.REPLACEDREASON, KR.RECEIVEDBYCUSTOMER,
					KR.RECEIVEDBYDATE
			FROM		KEYREQUESTS KR
			WHERE	KR.KEYREQUESTWRID = #val(GetWorkRequests.WORKREQUESTID)#
			ORDER BY	KR.KEYREQUESTWRID, KR.KEYREQUESTID
		</CFQUERY>

		<CFIF LookupKeyRequestInfo.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Key Request Records matching this Work Order ID were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/keyrequestinfo.cfm?PROCESS=ADD" />
			<CFEXIT>
		<CFELSE>
			<CFSET session.KEYREQUESTIDArray = ArrayNew(1)>
			<CFSET temp = ArraySet(session.KEYREQUESTIDArray, 1, #LookupKeyRequestInfo.RecordCount#, 0)> 
			<CFSET session.KEYREQUESTIDArray = ListToArray(#ValueList(LookupKeyRequestInfo.KEYREQUESTID)#)>
			<CFSET session.KEYCOUNTER = 1>
			<CFSET session.NUMKEYSNEEDED = #LookupKeyRequestInfo.RecordCount#>
		</CFIF>
	</CFIF>
	<CFQUERY name="GetKeyRequestInfo" datasource="#application.type#FACILITIES">
		SELECT	KR.KEYREQUESTID, KR.KEYREQUESTWRID, KR.KEYTYPEID, KR.KEYNUMBER, KR.HOOKNUMBER, KR.DOORSACCESSED, KR.DAYSACCESSED,
				KR.TIMESACCESSED, KR.OTHERDAYS, TO_CHAR(KR.OTHERWEEKDAYTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESFROM,
				TO_CHAR(KR.OTHERWEEKDAYTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESTHRU,
				TO_CHAR(KR.OTHERWEEKENDTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKENDTIMESFROM,
				TO_CHAR(KR.OTHERWEEKENDTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKENDTIMESTHRU,
				KR.ACCESSENDDATE, KR.DISPOSITION, KR.NUMBERREPLACED, KR.REPLACEDREASON, KR.RECEIVEDBYCUSTOMER,
				KR.RECEIVEDBYDATE
		FROM		KEYREQUESTS KR
		WHERE	KR.KEYREQUESTID = <CFQUERYPARAM value="#session.KEYREQUESTIDArray[session.KEYCOUNTER]#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	KR.KEYREQUESTWRID, KR.KEYREQUESTID
	</CFQUERY>

	<CFCOOKIE name="KEYREQUESTID" secure="NO" value="#GetKeyRequestInfo.KEYREQUESTID#">
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Key Requests</H1></TD>
		</TR>
	</TABLE>

	<TABLE align="left" width="100%" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				Key ID:&nbsp;&nbsp; <H5>#GetKeyRequestInfo.KEYREQUESTID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(GetWorkRequests.REQUESTDATE, "mm/dd/yyyy")#</H5>
			</TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="2">
				Work Request Number:&nbsp;&nbsp;
				<H5>#GetWorkRequests.WORKREQUESTNUMBER#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Requester Name:&nbsp;&nbsp;
				<H5>#GetWorkRequests.FULLNAME#</H5><BR />
				Unit Name:&nbsp;&nbsp;
				<H5>#GetWorkRequests.UNITNAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Building Name:&nbsp;&nbsp;
				<H5>#GetWorkRequests.BUILDINGNAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Room Number:&nbsp;&nbsp;
				<H5>#GetWorkRequests.ROOMNUMBER#</H5>
			</TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFY" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessKeyRequestInfo" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="KEYREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processkeyrequestinfo.cfm" method="POST" ENABLECAB="Yes">

		<TR>
			<TH align="left"><H4><LABEL for="KEYTYPEID">*Key/Card Type</LABEL></H4></TH>
			<TH align="left"><LABEL for="KEYNUMBER">Key Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="KEYTYPEID" id="KEYTYPEID" size="1" query="ListKeyTypes" value="KEYTYPEID" display="KEYTYPENAME" required="No" selected="#GetKeyRequestInfo.KEYTYPEID#" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="KEYNUMBER" id="KEYNUMBER" value="#GetKeyRequestInfo.KEYNUMBER#" align="LEFT" required="No" size="16" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="HOOKNUMBER">Hook Number</LABEL></TH>
			<TH align="left"><H4><LABEL for="DISPOSITION">*Disposition</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="HOOKNUMBER" id="HOOKNUMBER" value="#GetKeyRequestInfo.HOOKNUMBER#" align="LEFT" required="No" size="10" tabindex="4"></TD>
			<TD align="left">
				<CFSELECT name="DISPOSITION" id="DISPOSITION" size="1" required="No" tabindex="5">
					<OPTION value="0">DISPOSITION</OPTION>
					<OPTION selected value="#GetKeyRequestInfo.DISPOSITION#">#GetKeyRequestInfo.DISPOSITION#</OPTION>
					<OPTION value="NEW">NEW</OPTION>
					<OPTION value="RENEW">RENEW</OPTION>
					<OPTION value="REPLACE">REPLACE</OPTION>
					<OPTION value="REVISION">REVISION</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="DOORSACCESSED">*Doors Accessed (Optional Multiple Selections Allowed)</LABEL></H4></TH>
			<TH align="left"><LABEL for="NUMBERREPLACED">Key Number Replaced</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="DOORSACCESSED" id="DOORSACCESSED" size="10" multiple="yes" required="No" tabindex="6">
					<CFLOOP query="ListRoomNumbers">
						<CFIF #LISTFIND(GetKeyRequestInfo.DOORSACCESSED, '#ListRoomNumbers.LOCATIONID#')# NEQ 0>
							<OPTION selected value="#ListRoomNumbers.LOCATIONID#">#ListRoomNumbers.ROOMNUMBER#</OPTION>
						<CFELSE>
							<OPTION value="#ListRoomNumbers.LOCATIONID#">#ListRoomNumbers.ROOMNUMBER#</OPTION>
						</CFIF>
					</CFLOOP>
				</CFSELECT><BR>
				<COM>(Hold down the shift key when clicking for a range of doors to be accessed.  <BR>
					Use control key and left mouse click (PC) or command key when clicking (Mac)  <BR>
					on specific doors to be accessed.)
				</COM>
			</TD>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="NUMBERREPLACED" id="NUMBERREPLACED" value="#GetKeyRequestInfo.NUMBERREPLACED#" align="LEFT" required="No" size="16" tabindex="7">
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="DAYSACCESSED">*Days Accessed</LABEL></H4></TH>
			<TH align="left"><LABEL for="REPLACEDREASON">Replaced Reason</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="DAYSACCESSED" id="DAYSACCESSED" size="1" required="No" tabindex="8">
					<OPTION value="0">DAYS ACCESSED</OPTION>
					<OPTION selected value="#GetKeyRequestInfo.DAYSACCESSED#">#GetKeyRequestInfo.DAYSACCESSED#</OPTION>
					<OPTION value="ALL DAYS">ALL DAYS</OPTION>
					<OPTION value="WORK DAYS">WORK DAYS</OPTION>
					<OPTION value="NON-WORK DAYS">NON-WORK DAYS</OPTION>
					<OPTION value="OTHER">OTHER</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="REPLACEDREASON" id="REPLACEDREASON" tabindex="10">
					<OPTION selected value="#GetKeyRequestInfo.REPLACEDREASON#">#GetKeyRequestInfo.REPLACEDREASON#</OPTION>
					<OPTION value="REASON">REASON</OPTION>
					<OPTION value="LOST">LOST</OPTION>
					<OPTION value="STOLEN">STOLEN</OPTION>
					<OPTION value="DAMAGED">DAMAGED</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="OTHERDAYS">Other Days (Optional Multiple Selections Allowed)</LABEL></TH>
			<TH align="left"><H4><LABEL for="TIMESACCESSED">*Times Accessed</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="OTHERDAYS" id="OTHERDAYS" size="7" query="ListDaysOfWeek" value="DAYSOFWEEKNAME" display="DAYSOFWEEKNAME" selected ="#PreserveSingleQuotes(GetKeyRequestInfo.OTHERDAYS)#" required="No" multiple="yes" tabindex="11"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="TIMESACCESSED" id="TIMESACCESSED" size="1" required="No" tabindex="9">
					<OPTION value="0">SELECT TIMES ACCESSED</OPTION>
					<OPTION selected value="#GetKeyRequestInfo.TIMESACCESSED#">#GetKeyRequestInfo.TIMESACCESSED#</OPTION>
					<OPTION value="24-HOUR">24-HOUR</OPTION>
					<OPTION value="OTHER">OTHER</OPTION>
				</CFSELECT><BR>
				<COM>(If you selected "OTHER" for "Days Accessed" above, hold down the shift key   <BR>
					when clicking for a range of days to be accessed.  <BR>
					Use control key and left mouse click (PC) or command key when clicking (Mac)  <BR>
					on specific days to be accessed.)
				</COM>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<COM>
					(If you selected "OTHER" for "Times Accessed" above, please fill out the appropriate "From" and "Thru" times below.)
				</COM>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="OTHERWEEKDAYFROMHOURS">Other WeekDay Hours From</LABEL></TH>
			<TH align="left" nowrap><LABEL for="OTHERWEEKDAYTHRUHOURS">Other WeekDay Hours Thru</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="OTHERWEEKDAYFROMHOURS" id="OTHERWEEKDAYFROMHOURS" tabindex="12">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESFROM,'hh')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESFROM,'hh')#</OPTION>
					<CFLOOP query="ListHours">
						<OPTION value="#TimeFormat(ListHours.HoursText,'hh')#"> #TimeFormat(ListHours.HoursText,'hh')#</OPTION>
					</CFLOOP>
				</CFSELECT>
				:
				<LABEL for="OTHERWEEKDAYFROMMINUTES" class="LABEL_hidden">Other Weekday From Minutes</LABEL>
				<CFSELECT name="OTHERWEEKDAYFROMMINUTES" id="OTHERWEEKDAYFROMMINUTES" tabindex="13">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESFROM,'mm')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESFROM,'mm')#</OPTION>
					<OPTION value="00">00</OPTION>
					<OPTION value="15">15</OPTION>
					<OPTION value="30">30</OPTION>
					<OPTION value="45">45</OPTION>
				</CFSELECT>
				&nbsp;&nbsp;
				<LABEL for="OTHERWEEKDAYFROMAMPM" class="LABEL_hidden">Other Weekday From AMPM</LABEL>
				<CFSELECT name="OTHERWEEKDAYFROMAMPM" id="OTHERWEEKDAYFROMAMPM" tabindex="14">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESFROM,'tt')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESFROM,'tt')#</OPTION>
					<OPTION value="AM">AM</OPTION>
					<OPTION value="PM">PM</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="OTHERWEEKDAYTHRUHOURS" id="OTHERWEEKDAYTHRUHOURS" tabindex="15">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESTHRU,'hh')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESTHRU,'hh')#</OPTION>
					<CFLOOP query="ListHours">
						<OPTION value="#TimeFormat(ListHours.HoursText,'hh')#">#TimeFormat(ListHours.HoursText,'hh')#</OPTION>
					</CFLOOP>
				</CFSELECT>
				:
				<LABEL for="OTHERWEEKDAYTHRUMINUTES" class="LABEL_hidden">Other Weekday Thru Minutes</LABEL>
				<CFSELECT name="OTHERWEEKDAYTHRUMINUTES" id="OTHERWEEKDAYTHRUMINUTES" tabindex="16">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESTHRU,'mm')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESTHRU,'mm')#</OPTION>
					<OPTION value="00">00</OPTION>
					<OPTION value="15">15</OPTION>
					<OPTION value="30">30</OPTION>
					<OPTION value="45">45</OPTION>
				</CFSELECT>
				&nbsp;&nbsp;
				<LABEL for="OTHERWEEKDAYTHRUAMPM" class="LABEL_hidden">Other Weekday Thru AMPM</LABEL>
				<CFSELECT name="OTHERWEEKDAYTHRUAMPM" id="OTHERWEEKDAYTHRUAMPM" tabindex="17">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESTHRU,'tt')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKDAYTIMESTHRU,'tt')#</OPTION>
					<OPTION value="AM">AM</OPTION>
					<OPTION value="PM">PM</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="OTHERWEEKENDFROMHOURS">Other WeekEnd Hours From</LABEL></TH>
			<TH align="left" nowrap><LABEL for="OTHERWEEKENDTHRUHOURS">Other WeekEnd Hours Thru</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="OTHERWEEKENDFROMHOURS" id="OTHERWEEKENDFROMHOURS" tabindex="18">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESFROM,'hh')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESFROM,'hh')#</OPTION>
					<CFLOOP query="ListHours">
						<OPTION value=#ListHours.HoursText#> #TimeFormat(ListHours.HoursText,'hh')#</OPTION>
					</CFLOOP>
				</CFSELECT>
				:
				<LABEL for="OTHERWEEKENDFROMMINUTES" class="LABEL_hidden">Other Weekend From Minutes</LABEL>
				<CFSELECT name="OTHERWEEKENDFROMMINUTES" id="OTHERWEEKENDFROMMINUTES" tabindex="19">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESFROM,'mm')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESFROM,'mm')#</OPTION>
					<OPTION value="00">00</OPTION>
					<OPTION value="15">15</OPTION>
					<OPTION value="30">30</OPTION>
					<OPTION value="45">45</OPTION>
				</CFSELECT>
				&nbsp;&nbsp;
				<LABEL for="OTHERWEEKENDFROMAMPM" class="LABEL_hidden">Other Weekend From AMPM</LABEL>
				<CFSELECT name="OTHERWEEKENDFROMAMPM" id="OTHERWEEKENDFROMAMPM" tabindex="20">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESFROM,'tt')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESFROM,'tt')#</OPTION>
					<OPTION value="AM">AM</OPTION>
					<OPTION value="PM">PM</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="OTHERWEEKENDTHRUHOURS" id="OTHERWEEKENDTHRUHOURS" tabindex="21">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESTHRU,'hh')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESTHRU,'hh')#</OPTION>
					<CFLOOP query="ListHours">
						<OPTION value=#ListHours.HoursText#>#TimeFormat(ListHours.HoursText,'hh')#</OPTION>
					</CFLOOP>
				</CFSELECT>
				:
				<LABEL for="OTHERWEEKENDTHRUMINUTES" class="LABEL_hidden">Other Weekend Thru Minutes</LABEL>
				<CFSELECT name="OTHERWEEKENDTHRUMINUTES" id="OTHERWEEKENDTHRUMINUTES" tabindex="22">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESTHRU,'mm')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESTHRU,'mm')#</OPTION>
					<OPTION value="00">00</OPTION>
					<OPTION value="15">15</OPTION>
					<OPTION value="30">30</OPTION>
					<OPTION value="45">45</OPTION>
				</CFSELECT>
				&nbsp;&nbsp;
				<LABEL for="OTHERWEEKENDTHRUAMPM" class="LABEL_hidden">Other Weekend Thru AMPM</LABEL>
				<CFSELECT  name="OTHERWEEKENDTHRUAMPM" id="OTHERWEEKENDTHRUAMPM" tabindex="23">
					<OPTION selected value="#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESTHRU,'tt')#">#TimeFormat(GetKeyRequestInfo.OTHERWEEKENDTIMESTHRU,'tt')#</OPTION>
					<OPTION value="AM">AM</OPTION>
					<OPTION value="PM">PM</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ACCESSENDDATE">Access End Date</LABEL></TH>
		<CFIF NOT IsDefined('session.KEYCOUNTER') OR session.KEYCOUNTER LT 2>
			<TH align="left" nowrap><LABEL for="NUMKEYSNEEDED">Number Of Keys Needed</LABEL></TH>
		<CFELSE>
			<TH align="left">&nbsp;&nbsp;</TH>
		</CFIF>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="ACCESSENDDATE" id="ACCESSENDDATE" size="1" required="No" tabindex="24">
					<OPTION selected value="#DateFormat(GetKeyRequestInfo.ACCESSENDDATE, "dd-mmm-yyyy")#">#DateFormat(GetKeyRequestInfo.ACCESSENDDATE, "dd-mmm-yyyy")#</OPTION>
					<OPTION value=#DateFormat("31-DEC-9999", "dd-mmm-yyyy")#>INDEFINITE</OPTION>
					<OPTION value=#DateFormat(NOW()+365, "dd-mmm-yyyy")#>#DateFormat(NOW()+365, "mm/dd/yyyy")#</OPTION>
				</CFSELECT>
			</TD>
		<CFIF NOT IsDefined('session.KEYCOUNTER') OR session.KEYCOUNTER LT 2>
			<TD align="left">
				<CFSELECT name="NUMKEYSNEEDED" id="NUMKEYSNEEDED" size="1" tabindex="25">
					<OPTION value="1">1</OPTION>
					<OPTION value="2">2</OPTION>
					<OPTION value="3">3</OPTION>
					<OPTION value="4">4</OPTION>
					<OPTION value="5">5</OPTION>
					<OPTION value="6">6</OPTION>
				</CFSELECT>
			</TD>
		<CFELSE>
			<TD align="left">&nbsp;&nbsp;</TD>
		</CFIF>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="RECEIVEDBYCUSTOMER">Received By Customer</LABEL></TH>
			<TH align="left"><LABEL for="RECEIVEDBYDATE">Received By Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="RECEIVEDBYCUSTOMER" id="RECEIVEDBYCUSTOMER" size="1" tabindex="26">
					<OPTION selected value="#GetKeyRequestInfo.RECEIVEDBYCUSTOMER#">#GetKeyRequestInfo.RECEIVEDBYCUSTOMER#</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="RECEIVEDBYDATE" id="RECEIVEDBYDATE" value="#DateFormat(GetKeyRequestInfo.RECEIVEDBYDATE,'mm/dd/yyyy')#" align="LEFT" required="No" size="10" maxlength="10" tabindex="27">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'KEYREQUEST','controlname': 'RECEIVEDBYDATE'});

				</SCRIPT><BR />
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessKeyRequestInfo" value="Modify" tabindex="28" />&nbsp;&nbsp;<COM><--(Modifies info above & completes the request.)</COM><BR />
			</TD>
		</TR>
	<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessKeyRequestInfo" value="DELETE" tabindex="29" /></TD>
		</TR>
	</CFIF>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFY" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessKeyRequestInfo" value="Cancel" tabindex="30" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>