<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: tnsrequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/17/2012 --->
<!--- Date in Production: 06/17/2012 --->
<!--- Module: Add/Modify/Delete Information in Facilities - TNS Requests --->
<!-- Last modified by John R. Pastori on 06/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/tnsrequestinfo.cfm">
<CFSET CONTENT_UPDATED = "June 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add TNS Requests</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete TNS Requests</TITLE>
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
		if (document.TNSREQUEST.ROOMID.selectedIndex == "0") {
			alertuser (document.TNSREQUEST.ROOMID.name +  ",  A Building/Room Number MUST be selected!");
			document.TNSREQUEST.FROMROOMID.focus();
			return false;
		}

		if (document.TNSREQUEST.JACKNUMBERID) {
			if (document.TNSREQUEST.JACKNUMBERID.selectedIndex == "0") {
				alertuser (document.TNSREQUEST.JACKNUMBERID.name +  ", A Wall Jack Number MUST be selected!");
				document.TNSREQUEST.JACKNUMBERID.focus();
				return false;
			}
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<BODY onLoad="document.TNSREQUEST.ROOMID.focus()">
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES">
	SELECT	WR.WORKREQUESTID, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER,
			TO_CHAR(WR.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WR.REQUESTERID, CUST.FULLNAME, WR.LOCATIONID,
			BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER, WR.UNITID, CUST.FULLNAME, U.UNITNAME, TNSREQUEST
	FROM		WORKREQUESTS WR, LOCATIONS LOC, BUILDINGNAMES BN, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, REQUESTTYPES RT
	WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#Cookie.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
			WR.LOCATIONID = LOC.LOCATIONID AND
			LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			WR.REQUESTERID = CUST.CUSTOMERID AND
			WR.UNITID = U.UNITID AND
			WR.REQUESTTYPEID = RT.REQUESTTYPEID
	ORDER BY	WR.WORKREQUESTNUMBER
</CFQUERY>

<CFQUERY name="ListTNSRequests" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	TNSREQUESTID, TNSREQUESTWRID, ROOMID, JACKNUMBERID, CAMPUSPHONE, DIALINGCAPABILITY, LONGDISTAUTHCODE, NUMBERLISTED, ESTIMATEONLY 
	FROM		TNSREQUESTS
	ORDER BY	TNSREQUESTWRID, ROOMID
</CFQUERY>

<CFQUERY name="ListMoveTypes" datasource="#application.type#FACILITIES" blockfactor="8">
	SELECT	MOVETYPEID, MOVETYPENAME
	FROM		MOVETYPES
	ORDER BY	MOVETYPENAME
</CFQUERY>

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
			LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION, 
               LOC.MODIFIEDBYID, LOC.MODIFIEDDATE, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
	FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
	WHERE	LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListJackNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	WJ.WALLJACKID, LOC.ROOMNUMBER, WJ.WALLDIRID, WD.WALLDIRNAME, WJ.PORTLETTER, BN.BUILDINGNAMEID, BN.BUILDINGNAME,  
     		LOC.ROOMNUMBER || '-' || WD.WALLDIRNAME || '-' || WJ.JACKNUMBER || '-' || WJ.PORTLETTER AS JACK
	FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD
	WHERE	WJ.LOCATIONID = LOC.LOCATIONID AND
			LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
     		WJ.WALLDIRID = WD.WALLDIRID 
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER, WD.WALLDIRNAME
</CFQUERY>

<CFQUERY name="GetRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.UNITID, CUST.LOCATIONID, WJ.LOCATIONID, WJ.CUSTOMERID, WJ.WALLJACKID, CUST.CAMPUSPHONE, CUST.SECONDCAMPUSPHONE,
			CUST.FAX, CUST.FULLNAME, CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE, CUST.NUMBERLISTED 
	FROM		CUSTOMERS CUST, FACILITIESMGR.WALLJACKS WJ
	WHERE	CUST.CUSTOMERID = #val(ListWorkRequests.REQUESTERID)# AND 
			CUST.LOCATIONID = WJ.LOCATIONID(+) AND 
			CUST.CUSTOMERID = WJ.CUSTOMERID(+) 
	ORDER BY	CUST.CUSTOMERID, WJ.WALLJACKID
</CFQUERY>

<!--- 
***********************************************************
* The following code is the ADD Process for TNS Requests. *
***********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(TNSREQUESTID) AS MAX_ID
		FROM		TNSREQUESTS
	</CFQUERY>
	<CFSET FORM.TNSREQUESTID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="TNSREQUESTID" secure="NO" value="#FORM.TNSREQUESTID#">
	<CFQUERY name="AddTNSRequest" datasource="#application.type#FACILITIES">
		INSERT INTO	TNSREQUESTS (TNSREQUESTID, TNSREQUESTWRID)
		VALUES		(#val(Cookie.TNSREQUESTID)#, #val(Cookie.WORKREQUESTID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add TNS Requests</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				TNS Request ID:&nbsp;&nbsp; <H5>#FORM.TNSREQUESTID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(ListWorkRequests.REQUESTDATE, "mm/dd/yyyy")#</H5>
			</TH>
		</TR>
	</TABLE>

	<TABLE align="left" width="100%" border="0">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="2">
				Work Request Number:&nbsp;&nbsp;
				<H5>#ListWorkRequests.WORKREQUESTNUMBER#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Request Type:&nbsp;&nbsp;
				<H5>#ListWorkRequests.REQUESTTYPENAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Requester's Name:&nbsp;&nbsp;
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
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processtnsrequestinfo.cfm" method="POST">
				<INPUT type="submit" name="ProcessTNSRequest" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="TNSREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processtnsrequestinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="ROOMID">*Building/Room</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="JACKNUMBERID">*Jack Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="Hidden" name="REQUESTTYPENAME" value="#ListWorkRequests.REQUESTTYPENAME#" />
				<CFSELECT name="ROOMID" id="ROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#ListWorkRequests.LOCATIONID#" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="JACKNUMBERID" id="JACKNUMBERID" size="1" query="ListJackNumbers" value="WALLJACKID" display="JACK" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="CAMPUSPHONE">Campus Phone Number</LABEL></TH>
			<TH align="left"><LABEL for="ESTIMATEONLY">Estimate Only</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="Hidden" name="REQUESTERID" value="#GetRequesters.CUSTOMERID#" />
				<CFINPUT type="Text" name="CAMPUSPHONE" id="CAMPUSPHONE" value="" align="LEFT" required="No" size="12" tabindex="4">
			</TD>
			<TD align="left">
				<CFSELECT name="ESTIMATEONLY" id="ESTIMATEONLY" size="1" tabindex="5">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	<CFIF FIND('NEW', #ListWorkRequests.REQUESTTYPENAME#, 1) NEQ 0>
		<TR>
			<TH align="left"><LABEL for="DIALINGCAPABILITY">Dialing Capability</LABEL></TH>
			<TH align="left"><LABEL for="LONGDISTAUTHCODE">Long Distance Authorization Code?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="DIALINGCAPABILITY" id="DIALINGCAPABILITY" size="1" tabindex="6">
					<OPTION value="CAMPUS">CAMPUS</OPTION>
					<OPTION value="CAMPUS AND LOCAL">CAMPUS AND LOCAL</OPTION>
					<OPTION selected value="CAMPUS, LOCAL AND SD COUNTY">CAMPUS, LOCAL AND SD COUNTY</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="LONGDISTAUTHCODE" id="LONGDISTAUTHCODE" size="1" tabindex="7">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="NUMBERLISTED">Number Listed?</LABEL></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="NUMBERLISTED" id="NUMBERLISTED" size="1" tabindex="8">
					<OPTION selected value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
	</CFIF>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessTNSRequest" value="ADD" tabindex="9" />&nbsp;&nbsp;<COM><--(Adds info above & completes the request.)</COM><BR />
			</TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processtnsrequestinfo.cfm" method="POST">
				<INPUT type="submit" name="ProcessTNSRequest" value="CANCELADD" tabindex="10" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
***************************************************************
* The following code is the Modify Processes for TNS Requests.*
***************************************************************
 --->

	<CFQUERY name="GetWorkRequests" datasource="#application.type#FACILITIES">
		SELECT	WR.WORKREQUESTID, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER,
				TO_CHAR(WR.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WR.REQUESTERID, CUST.FULLNAME, WR.LOCATIONID,
				BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER, WR.UNITID, CUST.FULLNAME, U.UNITNAME, TNSREQUEST
		FROM		WORKREQUESTS WR, LOCATIONS LOC, BUILDINGNAMES BN, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U, REQUESTTYPES RT
		WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#Cookie.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WR.LOCATIONID = LOC.LOCATIONID AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				WR.REQUESTERID = CUST.CUSTOMERID AND
				WR.UNITID = U.UNITID AND
				WR.REQUESTTYPEID = RT.REQUESTTYPEID
		ORDER BY	WR.WORKREQUESTNUMBER
	</CFQUERY>

	<CFQUERY name="GetTNSRequestInfo" datasource="#application.type#FACILITIES">
		SELECT	TNSREQUESTID, TNSREQUESTWRID, ROOMID, JACKNUMBERID, CAMPUSPHONE, DIALINGCAPABILITY, LONGDISTAUTHCODE, NUMBERLISTED, ESTIMATEONLY 
		FROM		TNSREQUESTS
		WHERE	TNSREQUESTWRID = <CFQUERYPARAM value="#GetWorkRequests.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	TNSREQUESTWRID, ROOMID
	</CFQUERY>

	<CFIF GetTNSRequestInfo.RecordCount EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("TNS Request Records matching this Work Order ID were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/tnsrequestinfo.cfm?PROCESS=ADD" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="GetRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.UNITID, CUST.LOCATIONID, WJ.LOCATIONID, WJ.WALLJACKID, CUST.CAMPUSPHONE, 
				CUST.SECONDCAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE,
				CUST.NUMBERLISTED
		FROM		CUSTOMERS CUST, FACILITIESMGR.WALLJACKS WJ
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#GetWorkRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				CUST.LOCATIONID = WJ.LOCATIONID
		ORDER BY	CUST.CUSTOMERID, WJ.WALLJACKID
	</CFQUERY>

	<CFQUERY name="GetJackNumbers" datasource="#application.type#FACILITIES">
		SELECT	WJ.WALLJACKID, WJ.WALLDIRID, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.CUSTOMERID, WJ.COMMENTS,
				WJ.MODIFIEDBYID, WJ.MODIFIEDDATE, LOC.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER,
				LOC.ROOMNUMBER || '-' || WD.WALLDIRNAME || '-' || WJ.JACKNUMBER || '-' || WJ.PORTLETTER AS JACK
		FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN, WALLDIRECTION WD
		WHERE	WJ.WALLJACKID = <CFQUERYPARAM value="#GetTNSRequestInfo.JACKNUMBERID#" cfsqltype="CF_SQL_NUMERIC"> AND
				WJ.LOCATIONID = LOC.LOCATIONID(+) AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
     			WJ.WALLDIRID = WD.WALLDIRID  
		ORDER BY	LOC.ROOMNUMBER, WJ.JACKNUMBER, WJ.PORTLETTER
	</CFQUERY>

	<CFQUERY name="ListRequestStatus" datasource="#application.type#FACILITIES" blockfactor="8">
		SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
		FROM		REQUESTSTATUS
		ORDER BY	REQUESTSTATUSNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Modify/Delete TNS Requests</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align="center">TNS Request ID:&nbsp;&nbsp; <H5>#GetTNSRequestInfo.TNSREQUESTID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(GetWorkRequests.REQUESTDATE, "mm/dd/yyyy")#</H5></TH>
			<CFCOOKIE name="TNSREQUESTID" secure="NO" value="#GetTNSrequestInfo.TNSREQUESTID#">
		</TR>
	</TABLE>

	<TABLE align="left" width="100%" border="0">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="2">
				Work Request Number:&nbsp;&nbsp;
				<H5>#GetWorkRequests.WORKREQUESTNUMBER#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Request Type:&nbsp;&nbsp;
				<H5>#GetWorkRequests.REQUESTTYPENAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Customer Name:&nbsp;&nbsp;
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
				<INPUT type="submit" name="ProcessTNSRequest" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="TNSREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processtnsrequestinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="ROOMID">*Location</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="JACKNUMBERID">*Jack Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="Hidden" name="REQUESTTYPENAME" value="#ListWorkRequests.REQUESTTYPENAME#" />
				<CFSELECT name="ROOMID" id="ROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetTNSrequestInfo.ROOMID#" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="JACKNUMBERID" id="JACKNUMBERID" size="1" query="ListJackNumbers" value="WALLJACKID" display="JACK" selected="#GetTNSrequestInfo.JACKNUMBERID#" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="CAMPUSPHONE">Campus Phone Number</LABEL></TH>
			<TH align="left"><LABEL for="ESTIMATEONLY">Estimate Only</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="Hidden" name="REQUESTERID" value="#GetRequesters.CUSTOMERID#" />
				<CFINPUT type="Text" name="CAMPUSPHONE" id="CAMPUSPHONE" value="#GetTNSrequestInfo.CAMPUSPHONE#" align="LEFT" required="No" size="12" tabindex="4">
			</TD>
			<TD align="left">
				<CFSELECT name="ESTIMATEONLY" id="ESTIMATEONLY" size="1" tabindex="5">
					<OPTION selected value="#GetTNSrequestInfo.ESTIMATEONLY#">#GetTNSrequestInfo.ESTIMATEONLY#</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	<CFIF FIND('NEW', #ListWorkRequests.REQUESTTYPENAME#, 1) NEQ 0>
		<TR>
			<TH align="left"><LABEL for="DIALINGCAPABILITY">Dialing Capability</LABEL></TH>
			<TH align="left"><LABEL for="LONGDISTAUTHCODE">Long Distance Authorization Code?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="DIALINGCAPABILITY" id="DIALINGCAPABILITY" size="1" tabindex="6">
					<OPTION selected value="#GetTNSrequestInfo.DIALINGCAPABILITY#">#GetTNSrequestInfo.DIALINGCAPABILITY#</OPTION>
					<OPTION value="CAMPUS">CAMPUS</OPTION>
					<OPTION value="CAMPUS AND LOCAL">CAMPUS AND LOCAL</OPTION>
					<OPTION value="CAMPUS, LOCAL AND SD COUNTY">CAMPUS, LOCAL AND SD COUNTY</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="LONGDISTAUTHCODE" id="LONGDISTAUTHCODE" size="1" tabindex="7">
					<OPTION selected value="#GetTNSrequestInfo.LONGDISTAUTHCODE#">#GetTNSrequestInfo.LONGDISTAUTHCODE#</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="NUMBERLISTED">Number Listed?</LABEL></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="NUMBERLISTED" id="NUMBERLISTED" size="1" tabindex="8">
					<OPTION selected value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
	</CFIF>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessTNSRequest" value="Modify" tabindex="9" />&nbsp;&nbsp;<COM><--(Modifies info above & completes the request.)</COM><BR />
			</TD>
		</TR>
	<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessTNSRequest" value="DELETE" tabindex="10" /></TD>
		</TR>
	</CFIF>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFY" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessTNSRequest" value="Cancel" tabindex="11" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>