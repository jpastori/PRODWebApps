<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: moverequestinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/20/2012 --->
<!--- Date in Production: 02/20/2012 --->
<!--- Module: Add/Modify/Delete Information in Facilities - Move Requests --->
<!-- Last modified by John R. Pastori on 02/20/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/moverequestinfo.cfm">
<CFSET CONTENT_UPDATED = "February 20, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Move Requests</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Move Requests</TITLE>
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
		if (document.MOVEREQUEST.MOVETYPEID.selectedIndex == "0") {
			alertuser (document.MOVEREQUEST.MOVETYPEID.name +  ",  A Move Type MUST be selected!");
			document.MOVEREQUEST.MOVETYPEID.focus();
			return false;
		}

		if (document.MOVEREQUEST.ITEMDESCRIPTION.value == null || document.MOVEREQUEST.ITEMDESCRIPTION.value == " ") {
			alertuser (document.MOVEREQUEST.ITEMDESCRIPTION.name +  ", A Request Description MUST be entered!");
			document.MOVEREQUEST.ITEMDESCRIPTION.focus();
			return false;
		}

		if (document.MOVEREQUEST.FROMROOMID.selectedIndex == "0") {
			alertuser (document.MOVEREQUEST.FROMROOMID.name +  ",  A From Building/Room Number MUST be selected!");
			document.MOVEREQUEST.FROMROOMID.focus();
			return false;
		}

		if (document.MOVEREQUEST.TOROOMID.selectedIndex == "0") {
			alertuser (document.MOVEREQUEST.TOROOMID.name +  ",  A To Building/Room Number MUST be selected!");
			document.MOVEREQUEST.TOROOMID.focus();
			return false;
		}

		if (document.MOVEREQUEST.FROMJACKNUMBERID) {
			if (document.MOVEREQUEST.FROMJACKNUMBERID.selectedIndex == "0") {
				alertuser (document.MOVEREQUEST.FROMJACKNUMBERID.name +  ", A To Wall Jack Number MUST be selected!");
				document.MOVEREQUEST.FROMJACKNUMBERID.focus();
				return false;
			}
		}

		if (document.MOVEREQUEST.PICKUPDATE) {
			if (document.MOVEREQUEST.PICKUPDATE.value == " " || document.MOVEREQUEST.PICKUPDATE.value == "" 
			 || !document.MOVEREQUEST.PICKUPDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
				alertuser (document.MOVEREQUEST.PICKUPDATE.name +  ", The Pickup Date MUST be Entered in the format MM/DD/YYYY!");
				document.MOVEREQUEST.PICKUPDATE.focus();
				return false;
			}
		}

		if (document.MOVEREQUEST.DELIVERYDATE) {
			if (document.MOVEREQUEST.DELIVERYDATE.value == " " || document.MOVEREQUEST.DELIVERYDATE.value == "" 
			 || !document.MOVEREQUEST.DELIVERYDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
				alertuser (document.MOVEREQUEST.DELIVERYDATE.name +  ", The Delivery Date MUST be Entered in the format MM/DD/YYYY!");
				document.MOVEREQUEST.DELIVERYDATE.focus();
				return false;
			}
		}
	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<BODY onLoad="document.MOVEREQUEST.MOVETYPEID.focus()">
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

<CFQUERY name="ListMoveRequests" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	MOVEREQUESTID, MOVEREQUESTWRID, MOVETYPEID, ITEMDESCRIPTION, STATENUMBER, PICKUPDATE, DELIVERYDATE,
			NUMBEROFBOXES, NUMBEROFCHAIRS, NUMBEROFTABLES, ESTIMATEONLY, FROMROOMID, FROMJACKNUMBERID, TOROOMID,
			TOJACKNUMBERID, CAMPUSPHONE
	FROM		MOVEREQUESTS
	ORDER BY	ITEMDESCRIPTION, MOVETYPEID
</CFQUERY>

<CFQUERY name="ListMoveTypes" datasource="#application.type#FACILITIES" blockfactor="8">
	SELECT	MOVETYPEID, MOVETYPENAME
	FROM		MOVETYPES
	ORDER BY	MOVETYPENAME
</CFQUERY>

<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
			LOC.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION, 
			LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LOC.MODIFIEDBYID, LOC.MODIFIEDDATE, LOC.ARCHIVELOCATION,
			BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
	FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
	WHERE	(LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID) AND
			((LOC.BUILDINGNAMEID >= 10 AND
			LOC.BUILDINGNAMEID <= 12) OR
			
			(LOC.LOCATIONID = 0))
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListJackNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	WJ.WALLJACKID, LOC.ROOMNUMBER, WJ.WALLDIRID, WD.WALLDIRNAME, WJ.PORTNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME,  
     		LOC.ROOMNUMBER || '-' || WD.WALLDIRNAME || '-' || WJ.JACKNUMBER || '-' || WJ.PORTNUMBER AS JACK
	FROM		WALLJACKS WJ, LOCATIONS LOC, WALLDIRECTION WD, BUILDINGNAMES BN
	WHERE	WJ.LOCATIONID = LOC.LOCATIONID AND
     		WJ.WALLDIRID = WD.WALLDIRID AND
			LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER, WD.WALLDIRNAME
</CFQUERY>

<CFIF FIND('TNS', #ListWorkRequests.REQUESTTYPENAME#, 1) NEQ 0>
	<CFQUERY name="GetRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.UNITID, CUST.LOCATIONID, WJ.LOCATIONID, WJ.CUSTOMERID, WJ.WALLJACKID, CUST.CAMPUSPHONE, CUST.SECONDCAMPUSPHONE,
				CUST.FAX, CUST.FULLNAME, CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE, CUST.NUMBERLISTED 
		FROM		CUSTOMERS CUST, FACILITIESMGR.WALLJACKS WJ
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#ListWorkRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC"> AND 
				CUST.LOCATIONID = WJ.LOCATIONID(+) AND 
				CUST.CUSTOMERID = WJ.CUSTOMERID(+) 
		ORDER BY	CUST.CUSTOMERID, WJ.WALLJACKID
	</CFQUERY>
</CFIF>

<!--- 
************************************************************
* The following code is the ADD Process for Move Requests. *
************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(MOVEREQUESTID) AS MAX_ID
		FROM		MOVEREQUESTS
	</CFQUERY>
	<CFSET FORM.MOVEREQUESTID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="MOVEREQUESTID" secure="NO" value="#FORM.MOVEREQUESTID#">
	<CFQUERY name="AddMoveRequest" datasource="#application.type#FACILITIES">
		INSERT INTO	MOVEREQUESTS (MOVEREQUESTID, MOVEREQUESTWRID)
		VALUES		(#val(Cookie.MOVEREQUESTID)#, #val(Cookie.WORKREQUESTID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add Move Requests</H1></TD>
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
				Move Request ID:&nbsp;&nbsp; <H5>#FORM.MOVEREQUESTID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(ListWorkRequests.REQUESTDATE, "mm/dd/yyyy")#</H5>
			</TH>
		</TR>
	</TABLE>

	<TABLE width="100%" border="0">
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
				<H5>#ListWorkRequests.ROOMNUMBER#</H5></H2>
			</TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processmoverequestinfo.cfm" method="POST">
				<INPUT type="submit" name="ProcessMoveRequest" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
               </TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="MOVEREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processmoverequestinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="MOVETYPEID">*Move Type</LABEL></H4></TH>
			<TH align="left"><LABEL for="NUMMOVESNEEDED">Number Of Items To Move</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="Hidden" name="REQUESTTYPENAME" value="#ListWorkRequests.REQUESTTYPENAME#" />
			<CFIF IsDefined('URL.MOVETYPEID')>
				<CFSELECT name="MOVETYPEID" id="MOVETYPEID" size="1" query="ListMoveTypes" value="MOVETYPEID" display="MOVETYPENAME" required="No" selected="#val(URL.MOVETYPEID)#" tabindex="2"></CFSELECT>
			<CFELSE>
				<CFSELECT name="MOVETYPEID" id="MOVETYPEID" size="1" query="ListMoveTypes" value="MOVETYPEID" display="MOVETYPENAME" required="No" selected="0" tabindex="2"></CFSELECT>
			</CFIF>
			</TD>
		<CFIF NOT IsDefined('session.MOVEREQUESTCOUNTER') OR session.MOVEREQUESTCOUNTER LT 2>
			<TD align="left">
				<CFSELECT name="NUMMOVESNEEDED" id="NUMMOVESNEEDED" size="1" tabindex="3">
					<OPTION value="1">1</OPTION>
					<OPTION value="2">2</OPTION>
					<OPTION value="3">3</OPTION>
					<OPTION value="4">4</OPTION>
					<OPTION value="5">5</OPTION>
					<OPTION value="6">6</OPTION>
				</CFSELECT>
			</TD>
		<CFELSE>
			<TD align="left">#session.MOVEREQUESTCOUNTER#</TD>
		</CFIF>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<H4><LABEL for="ITEMDESCRIPTION">*3. Move Request Description</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFTEXTAREA name="ITEMDESCRIPTION" id="ITEMDESCRIPTION" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="60" tabindex="4"></CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	<CFIF FIND('TNS', #ListWorkRequests.REQUESTTYPENAME#, 1) NEQ 0>
		<TR>
			<TH align="left"><H4><LABEL for="FROMROOMID">*From Building/Room</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TOROOMID">*To Building/Room</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="FROMROOMID" id="FROMROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#ListWorkRequests.LOCATIONID#" required="No" tabindex="5"></CFSELECT>
			</TD>
			<TD>
				<CFSELECT name="TOROOMID" id="TOROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="FROMJACKNUMBERID">*From Jack Number</LABEL></H4></TH>
			<TH align="left"><LABEL for="TOJACKNUMBERID">To Jack Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="FROMJACKNUMBERID" id="FROMJACKNUMBERID" size="1" query="ListJackNumbers" value="WALLJACKID" display="JACK" selected="#GetRequesters.WALLJACKID#" required="No" tabindex="7"></CFSELECT>
			</TD>
			<TD>
				<CFSELECT name="TOJACKNUMBERID" id="TOJACKNUMBERID" size="1" query="ListJackNumbers" value="WALLJACKID" display="JACK" selected="0" required="No" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="CAMPUSPHONE">Phone To Move</LABEL></TH>
			<TH align="left"><LABEL for="ESTIMATEONLY">Estimate Only</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="Hidden" name="REQUESTERID" value="#GetRequesters.CUSTOMERID#" />
				<CFINPUT type="Text" name="CAMPUSPHONE" id="CAMPUSPHONE" value="#GetRequesters.CAMPUSPHONE#" align="LEFT" required="No" size="12" tabindex="9">
			</TD>
			<TD align="left">
				<CFSELECT name="ESTIMATEONLY" id="ESTIMATEONLY" size="1" tabindex="10">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
	<CFELSE>
		<TR>
			<TH align="left"><H4><LABEL for="FROMROOMID">*Current Location</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TOROOMID">*Destination Location</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="FROMROOMID" id="FROMROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#ListWorkRequests.LOCATIONID#" required="No" tabindex="5"></CFSELECT>
			</TD>
			<TD>
				<CFSELECT name="TOROOMID" id="TOROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PICKUPDATE">*Pickup Date</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="DELIVERYDATE">*Delivery Date</LABEL></H4></TH>
		</TR>
		<TR>
		<CFIF IsDefined('URL.PICKUPDATE')>
			<TD align="left">
				<CFINPUT type="Text" name="PICKUPDATE" id="PICKUPDATE" value="#URL.PICKUPDATE#" align="LEFT" required="No" size="10" tabindex="7">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'MOVEREQUEST','controlname': 'PICKUPDATE'});

				</SCRIPT><BR />
				<COM>MM/DD/YYYYY </COM>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="DELIVERYDATE" id="DELIVERYDATE" value="#URL.DELIVERYDATE#" align="LEFT" required="No" size="10" tabindex="8">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'MOVEREQUEST','controlname': 'DELIVERYDATE'});

				</SCRIPT><BR />
				<COM>MM/DD/YYYYY </COM>
			</TD>
		<CFELSE>
			<TD align="left">
				<COM>MM/DD/YYYYY </COM><BR />
				<CFINPUT type="Text" name="PICKUPDATE" id="PICKUPDATE" value="" align="LEFT" required="No" size="10" tabindex="7">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'MOVEREQUEST','controlname': 'PICKUPDATE'});

				</SCRIPT>
			</TD>
			<TD align="left">
				<COM>MM/DD/YYYYY </COM><BR />
				<CFINPUT type="Text" name="DELIVERYDATE" id="DELIVERYDATE" value="" align="LEFT" required="No" size="10" tabindex="8">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'MOVEREQUEST','controlname': 'DELIVERYDATE'});

				</SCRIPT>
			</TD>
		</CFIF>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="NUMBEROFBOXES">Number Of Boxes</LABEL></TH>
			<TH align="left"><LABEL for="NUMBEROFCHAIRS">Number Of Chairs</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="NUMBEROFBOXES" id="NUMBEROFBOXES" value="0" align="LEFT" required="No" size="6" tabindex="9">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="NUMBEROFCHAIRS" id="NUMBEROFCHAIRS" value="0" align="LEFT" required="No" size="6" tabindex="10">
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="NUMBEROFTABLES">Number Of Tables</LABEL></TH>
			<TH align="left"><LABEL for="STATENUMBER">State/Foundation Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="NUMBEROFTABLES" id="NUMBEROFTABLES" value="0" align="LEFT" required="No" size="6" tabindex="11">
			</TD>
			<TD align="left">
				<COM>(Enter State/Foundation Number, N/A or See Fax)</COM><BR />
				<CFINPUT type="Text" name="STATENUMBER" id="STATENUMBER" value="" align="LEFT" required="No" size="8" tabindex="12">
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ESTIMATEONLY">Estimate Only</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<COM>(If other than Surplus, YES may be selected.)</COM><BR />
				<CFSELECT name="ESTIMATEONLY" id="ESTIMATEONLY" size="1" tabindex="13">
					<OPTION selected value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
	</CFIF>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" name="ProcessMoveRequest" value="ADD" tabindex="14" />&nbsp;&nbsp;<COM><--(Adds info above & completes the request.)</COM><BR />
			</TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/processmoverequestinfo.cfm" method="POST">
				<INPUT type="submit" name="ProcessMoveRequest" value="CANCELADD" tabindex="15" /><BR />
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
****************************************************************
* The following code is the Modify Processes for Move Requests.*
****************************************************************
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

	<CFIF IsDefined ('URL.INITREQ') AND URL.INITREQ EQ "WO">
		<CFQUERY name="LookupMoveRequestInfo" datasource="#application.type#FACILITIES">
			SELECT	MR.MOVEREQUESTID, MR.MOVEREQUESTWRID, MR.MOVETYPEID, MT.MOVETYPENAME, MR.ITEMDESCRIPTION,
					MR.STATENUMBER, MR.PICKUPDATE, MR.DELIVERYDATE, MR.NUMBEROFBOXES, MR.NUMBEROFCHAIRS, MR.NUMBEROFTABLES,
					MR.ESTIMATEONLY, MR.FROMROOMID, MR.FROMJACKNUMBERID, MR.TOROOMID, MR.TOJACKNUMBERID, MR.CAMPUSPHONE
			FROM		MOVEREQUESTS MR, MOVETYPES MT
			WHERE	MR.MOVEREQUESTWRID = <CFQUERYPARAM value="#GetWorkRequests.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					MR.MOVETYPEID = MT.MOVETYPEID
			ORDER BY	MR.MOVEREQUESTWRID, MR.MOVEREQUESTID
		</CFQUERY>

		<CFIF #GetWorkRequests.TNSREQUEST# EQ 'YES'>

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
				SELECT	WJ.WALLJACKID, WJ.WALLDIRECTION, WJ.CIRCUITNUMBER, WJ.JACKNUMBER,
						WJ.PORTNUMBER, WJ.PHONE_IPNUMBER, WJ.CUSTOMERID, WJ.COMMENTS,
						WJ.MODIFIEDBYID, WJ.MODIFIEDDATE, LOC.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER,
						LOC.ROOMNUMBER || '-' || WJ.WALLDIRECTION || '-' || WJ.JACKNUMBER || '-' || WJ.PORTNUMBER AS JACK
				FROM		WALLJACKS WJ, LOCATIONS LOC, BUILDINGNAMES BN
				WHERE	WJ.CUSTOMERID = <CFQUERYPARAM value="#GetRequesters.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC"> AND
						WJ.LOCATIONID = LOC.LOCATIONID(+) AND
						LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID 
				ORDER BY	LOC.ROOMNUMBER, WJ.JACKNUMBER, WJ.PORTNUMBER
			</CFQUERY>

		</CFIF>

		<CFIF LookupMoveRequestInfo.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Move Request Records matching this Work Order ID were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/moverequestinfo.cfm?PROCESS=ADD" />
			<CFEXIT>
		<CFELSE>
			<CFSET session.MOVEREQUESTIDArray = ArrayNew(1)>
			<CFSET temp = ArraySet(session.MOVEREQUESTIDArray, 1, #LookupMoveRequestInfo.RecordCount#, 0)>
			<CFSET session.MOVEREQUESTIDArray = ListToArray(#ValueList(LookupMoveRequestInfo.MOVEREQUESTID)#)>
			<CFSET session.MOVEREQUESTCOUNTER = 1>
			<CFSET session.NUMMOVESNEEDED = #LookupMoveRequestInfo.RecordCount#>
		</CFIF>
	</CFIF>
	
	<CFQUERY name="GetMoveRequestInfo" datasource="#application.type#FACILITIES">
		SELECT	MR.MOVEREQUESTID, MR.MOVEREQUESTWRID, MR.MOVETYPEID, MT.MOVETYPENAME, MR.ITEMDESCRIPTION, 
				MR.STATENUMBER, MR.PICKUPDATE, MR.DELIVERYDATE, MR.NUMBEROFBOXES, MR.NUMBEROFCHAIRS, MR.NUMBEROFTABLES, MR.ESTIMATEONLY,
				MR.FROMROOMID, MR.FROMJACKNUMBERID, MR.TOROOMID, MR.TOJACKNUMBERID, MR.CAMPUSPHONE
		FROM		MOVEREQUESTS MR, MOVETYPES MT
		WHERE	MR.MOVEREQUESTID = <CFQUERYPARAM value="#session.MOVEREQUESTIDArray[session.MOVEREQUESTCOUNTER]#" cfsqltype="CF_SQL_NUMERIC"> AND
				MR.MOVETYPEID = MT.MOVETYPEID
		ORDER BY	MR.MOVEREQUESTWRID, MR.MOVEREQUESTID
	</CFQUERY>

	<CFQUERY name="ListRequestStatus" datasource="#application.type#FACILITIES">
		SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
		FROM		REQUESTSTATUS
		ORDER BY	REQUESTSTATUSNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Modify/Delete Move Requests</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!&nbsp;&nbsp;&nbsp;&nbsp;</H4></TH>
		</TR>
		<TR>
			<TH align="center">Move Request ID:&nbsp;&nbsp; <H5>#GetMoverequestInfo.MOVEREQUESTID#</H5> &nbsp;&nbsp;Request Date:&nbsp;&nbsp;<H5>#DateFormat(GetWorkRequests.REQUESTDATE, "mm/dd/yyyy")#</H5></TH>
			<CFCOOKIE name="MOVEREQUESTID" secure="NO" value="#GetMoverequestInfo.MOVEREQUESTID#">
		</TR>
	</TABLE>

	<TABLE align="left" width="100%" border="0">
		<TR>
			<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				Work Request Number:&nbsp;&nbsp;<H5>#GetWorkRequests.WORKREQUESTNUMBER#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Request Type:&nbsp;&nbsp;<H5>#GetWorkRequests.REQUESTTYPENAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Customer Name:&nbsp;&nbsp;<H5>#GetWorkRequests.FULLNAME#</H5><BR />
				Unit Name:&nbsp;&nbsp;<H5>#GetWorkRequests.UNITNAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Building Name:&nbsp;&nbsp;<H5>#GetWorkRequests.BUILDINGNAME#</H5>&nbsp;&nbsp;&nbsp;&nbsp;
				Room Number:&nbsp;&nbsp;<H5>#GetWorkRequests.ROOMNUMBER#</H5>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFY" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMoveRequest" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="MOVEREQUEST" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processmoverequestinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="MOVETYPEID">*Move Type</LABEL></H4></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="Hidden" name="REQUESTTYPENAME" value="#ListWorkRequests.REQUESTTYPENAME#" />
				<CFSELECT name="MOVETYPEID" id="MOVETYPEID" size="1" query="ListMoveTypes" value="MOVETYPEID" display="MOVETYPENAME" selected="#GetMoveRequestInfo.MOVETYPEID#" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2"><H4><LABEL for="ITEMDESCRIPTION">*Move Request Description</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFTEXTAREA name="ITEMDESCRIPTION" id="ITEMDESCRIPTION" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="60" tabindex="3">#GetMoveRequestInfo.ITEMDESCRIPTION#</CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	<CFIF FIND('TNS', #ListWorkRequests.REQUESTTYPENAME#, 1) NEQ 0>
		<TR>
			<TH align="left"><H4><LABEL for="FROMROOMID">*From Building/Room</LABEL></H4></TH>
			<TH align="left"><LABEL for="TOROOMID">To Building/Room</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="FROMROOMID" id="FROMROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetMoveRequestInfo.FROMROOMID#" required="No" tabindex="4"></CFSELECT>
			</TD>
			<TD>
				<CFSELECT name="TOROOMID" id="TOROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetMoveRequestInfo.TOROOMID#" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="FROMJACKNUMBERID">*From Jack Number</LABEL></H4></TH>
			<TH align="left"><LABEL for="TOJACKNUMBERID">To Jack Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="FROMJACKNUMBERID" id="FROMJACKNUMBERID" size="1" query="ListJackNumbers" value="WALLJACKID" display="JACK" selected="#GetMoveRequestInfo.FROMJACKNUMBERID#" required="No" tabindex="6"></CFSELECT>
			</TD>
			<TD>
				<CFSELECT name="TOJACKNUMBERID" id="TOJACKNUMBERID" size="1" query="ListJackNumbers" value="WALLJACKID" display="JACK" selected="#GetMoveRequestInfo.TOJACKNUMBERID#" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="CAMPUSPHONE">Phone To Move</LABEL></TH>
			<TH align="left"><LABEL for="ESTIMATEONLY">Estimate Only</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="Hidden" name="REQUESTERID" value="#GetRequesters.CUSTOMERID#" />
				<CFINPUT type="Text" name="CAMPUSPHONE" id="CAMPUSPHONE" value="#GetMoveRequestInfo.CAMPUSPHONE#" align="LEFT" required="No" size="12" tabindex="8"></TD>
			<TD align="left">
				<CFSELECT name="ESTIMATEONLY" id="ESTIMATEONLY" size="1" tabindex="9">
					<OPTION selected value="#GetMoveRequestInfo.ESTIMATEONLY#">#GetMoverequestInfo.ESTIMATEONLY#</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
	<CFELSE>
		<TR>
			<TH align="left"><H4><LABEL for="FROMROOMID">*Current Location</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="TOROOMID">*Destination</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="FROMROOMID" id="FROMROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetMoveRequestInfo.FROMROOMID#" required="No" tabindex="4"></CFSELECT>
			</TD>
			<TD>
				<CFSELECT name="TOROOMID" id="TOROOMID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="#GetMoveRequestInfo.TOROOMID#" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PICKUPDATE">*Pickup Date</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="DELIVERYDATE">*Delivery Date</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="PICKUPDATE" id="PICKUPDATE" value="#DateFormat(GetMoveRequestInfo.PICKUPDATE,'mm/dd/yyyy')#" align="LEFT" required="No" size="10" tabindex="6">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'MOVEREQUEST','controlname': 'PICKUPDATE'});

				</SCRIPT><BR />
				<COM>MM/DD/YYYYY </COM>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="DELIVERYDATE" id="DELIVERYDATE" value="#DateFormat(GetMoveRequestInfo.DELIVERYDATE,'mm/dd/yyyy')#" align="LEFT" required="No" size="10" tabindex="7">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'MOVEREQUEST','controlname': 'DELIVERYDATE'});

				</SCRIPT><BR />
				<COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="NUMBEROFBOXES">Number Of Boxes</LABEL></TH>
			<TH align="left"><LABEL for="NUMBEROFCHAIRS">Number Of Chairs</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="NUMBEROFBOXES" id="NUMBEROFBOXES" value="#GetMoveRequestInfo.NUMBEROFBOXES#" align="LEFT" required="No" size="6" tabindex="8">
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="NUMBEROFCHAIRS" id="NUMBEROFCHAIRS" value="#GetMoveRequestInfo.NUMBEROFCHAIRS#" align="LEFT" required="No" size="6" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="NUMBEROFTABLES">Number Of Tables</LABEL></TH>
			<TH align="left"><LABEL for="STATENUMBER">State/Foundation Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFINPUT type="Text" name="NUMBEROFTABLES" id="NUMBEROFTABLES" value="#GetMoveRequestInfo.NUMBEROFTABLES#" align="LEFT" required="No" size="6" tabindex="10">
			</TD>
			<TD align="left">
				<COM>(Enter State/Foundation Number, N/A or See Fax)</COM><BR />
				<CFINPUT type="Text" name="STATENUMBER" id="STATENUMBER" value="#GetMoveRequestInfo.STATENUMBER#" align="LEFT" required="No" size="8" tabindex="11">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ESTIMATEONLY">Estimate Only?</LABEL></TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">
				<COM>(If other than Surplus, YES may be selected.)</COM><BR />
				<CFSELECT name="ESTIMATEONLY" id="ESTIMATEONLY" size="1" tabindex="12">
					<OPTION selected value="#GetMoveRequestInfo.ESTIMATEONLY#">#GetMoverequestInfo.ESTIMATEONLY#</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
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
				<INPUT type="submit" name="ProcessMoveRequest" value="Modify" tabindex="13" />&nbsp;&nbsp;<COM><--(Modifies info above & completes the request.)</COM><BR />
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
			<TD align="left"><INPUT type="submit" name="ProcessMoveRequest" value="DELETE" tabindex="14" /></TD>
		</TR>
	</CFIF>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFY" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMoveRequest" value="Cancel" tabindex="15" /><BR />
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