<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: univpolicekeycardrequest.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/14/2012 --->
<!--- Date in Production: 02/14/2012 --->
<!--- Module: Facilities Application - University Police Key/Card Request --->
<!-- Last modified by John R. Pastori on 02/14/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/univpolicekeycardrequest.cfm">
<CFSET CONTENT_UPDATED = "February 14, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities Application - Physical Plant Work Order</TITLE>
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

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>
<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPWORKREQUESTID')>
	<CFSET CURSORFIELD = "document.LOOKUP.WORKREQUESTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "<!--- document.WORKREQUEST.building_name.focus() --->">
</CFIF>

<BODY onLoad="#CURSORFIELD#">


<!--- 
************************************************************************
* The following code sends the Key/Card Request to University Police . *
************************************************************************
 --->
 
</CFOUTPUT>
<CFIF IsDefined("FORM.ProcessUPKCR")>
	<CFOUTPUT>
	<CFQUERY name="LookupWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
          SELECT	WR.WORKREQUESTID, WR.REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID,
                    WR.REQUESTSTATUSID, RT.REQUESTTYPENAME, WR.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, WR.UNITID, WR.LOCATIONID, WR.ACCOUNTNUMBER1,
                    WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3, WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION,
                    WR.SUPEMAILID, WR.APPROVEDBYSUPID, WR.SUPAPPROVALDATE, WR.MGMTEMAILID, WR.APPROVEDBYMGMTID, WR.STARTDATE, WR.COMPLETIONDATE, WR.URGENCY, WR.TNSREQUEST,
                    CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER AS KEYFINDER
          FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT
          WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#URL.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    WR.REQUESTERID = CUST.CUSTOMERID AND
                    WR.REQUESTTYPEID = RT.REQUESTTYPEID
          ORDER BY	CUST.FULLNAME, RT.REQUESTTYPENAME
     </CFQUERY>
     
	<CFSET FORM.WORKREQUESTNUMBER = ListChangeDelims(LookupWorkRequests.WORKREQUESTNUMBER, "-", "/")>
	<CFSET PDF.OutPPWOContent = "/home/www/lfolkstestcf/htdocs/DEVapps/datafiles/UPKeyCardRequest#FORM.WORKREQUESTNUMBER#.pdf">
     
     <CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES">
		SELECT	LOC.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER
		FROM		LOCATIONS LOC, BUILDINGNAMES BN
		WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#LookupWorkRequests.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID
		ORDER BY	LOC.ROOMNUMBER
	</CFQUERY>   

	</CFOUTPUT>
     <!--- wcontrol@mail.sdsu.edu--->
     <CFMAIL query = "LookupWorkRequests"
          to="pastori@rohan.sdsu.edu" 
          from="facilities@libint.sdsu.edu"
          subject="Request for Physical Plant Service"
          <!--- cc="#ListRequesters.EMAIL#,mdotson@rohan.sdsu.edu" --->
          mimeattach = "#PDF.OutPPWOContent#"
     >

	#LookupWorkRequests.FULLNAME# has requested #LookupWorkRequests.REQUESTTYPENAME# be done in Building #LookupRoomNumbers.BUILDINGNAME# - Room #LookupRoomNumbers.ROOMNUMBER#.
     See the attached Physical Plant Work Order Document for details.
     </CFMAIL>
	<CFOUTPUT>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/physicalplantwo.cfm" />
     </CFOUTPUT>
     <CFEXIT>
</CFIF>

<CFOUTPUT>
<CFQUERY name="ListWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	WR.WORKREQUESTID, WR.REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID,
			WR.REQUESTSTATUSID, RT.REQUESTTYPENAME, WR.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, WR.UNITID, WR.LOCATIONID, WR.ACCOUNTNUMBER1,
			WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3, WR.ALTERNATECONTACTID, WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION,
			WR.SUPEMAILID, WR.APPROVEDBYSUPID, WR.SUPAPPROVALDATE, WR.MGMTEMAILID, WR.APPROVEDBYMGMTID, WR.STARTDATE, WR.COMPLETIONDATE, WR.URGENCY, WR.TNSREQUEST,
			CUST.FULLNAME || ' - ' || RT.REQUESTTYPENAME || ' - ' || WR.WORKREQUESTNUMBER AS KEYFINDER
	FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT
	WHERE	WR.REQUESTSTATUSID IN (1,7) AND
			WR.REQUESTTYPEID = 2 AND
			WR.REQUESTERID = CUST.CUSTOMERID AND
			WR.REQUESTTYPEID = RT.REQUESTTYPEID
	ORDER BY	CUST.FULLNAME, RT.REQUESTTYPENAME
</CFQUERY>


<CFIF NOT IsDefined("URL.LOOKUPWORKREQUESTID")> 
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Approved Work Request Lookup For <BR>Physical Plant Work Order</H1></TH>
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
<CFFORM name="LOOKUP" action="/#application.type#apps/facilities/univpolicekeycardrequest.cfm?LOOKUPWORKREQUESTID=FOUND" method="POST">
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
     
     <CFEXIT>
     
<CFELSE>
<!--- 
*******************************************************************************************
* The following code generates the Facilities - University Police Key/Card Request Screen.*
*******************************************************************************************
 --->

	<CFQUERY name="LookupWorkRequests" datasource="#application.type#FACILITIES">
		SELECT	WR.WORKREQUESTID, TO_CHAR(WR.REQUESTDATE, 'MM/DD/YYYY') AS REQUESTDATE, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER,
				WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, WR.REQUESTSTATUSID, RS.REQUESTSTATUSNAME,
				WR.REQUESTERID, WR.UNITID, WR.LOCATIONID, WR.ACCOUNTNUMBER1, WR.ACCOUNTNUMBER2, WR.ACCOUNTNUMBER3,
                    WR.ACCOUNTNUMBER1 || ' - ' || WR.ACCOUNTNUMBER2 || ' - ' || WR.ACCOUNTNUMBER3 AS ACCOUNTNUMBER,
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
     
     <CFSET FORM.WORKREQUESTNUMBER = ListChangeDelims(LookupWorkRequests.WORKREQUESTNUMBER, "-", "/")>
     
	<CFQUERY name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FIRSTNAME, CUST.UNITID, CUST.LOCATIONID, CUST.EMAIL, CUST.CAMPUSPHONE, 
				CUST.SECONDCAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.DIALINGCAPABILITY, CUST.LONGDISTAUTHCODE, CUST.NUMBERLISTED,
				CUST.UNITHEAD, CUST.DEPTCHAIR
		FROM		CUSTOMERS CUST
		WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#LookupWorkRequests.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA">
		SELECT	U.UNITID, U.UNITNAME, CMC.CAMPUSMAILCODE, G.GROUPNAME, D.DEPARTMENTNAME, D.DEPARTMENTNAME || ' - ' || U.UNITNAME AS DEPTUNIT
		FROM		UNITS U , CAMPUSMAILCODES CMC, GROUPS G, DEPARTMENTS D
		WHERE	U.UNITID = <CFQUERYPARAM value="#LookupRequesters.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
				U.CAMPUSMAILCODEID = CMC.CAMPUSMAILCODEID AND
				U.GROUPID = G.GROUPID AND
				U.DEPARTMENTID = D.DEPARTMENTID
		ORDER BY	U.UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupAlternateContacts" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, EMAIL, LASTNAME, FIRSTNAME, FULLNAME, EMAIL, CAMPUSPHONE, UNITHEAD, DEPTCHAIR
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#LookupWorkRequests.ALTERNATECONTACTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

     <CFQUERY name="LookupKeyRequestInfo" datasource="#application.type#FACILITIES" blockfactor="100">
          SELECT	KR.KEYREQUESTID, KR.KEYREQUESTWRID, KR.KEYTYPEID, KR.KEYNUMBER, KR.HOOKNUMBER, KR.DOORSACCESSED, KR.DAYSACCESSED, KR.TIMESACCESSED,
                    KR.OTHERDAYS, TO_CHAR(KR.OTHERWEEKDAYTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESFROM,
                    TO_CHAR(KR.OTHERWEEKDAYTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKDAYTIMESTHRU,
                    TO_CHAR(KR.OTHERWEEKENDTIMESFROM, 'HH24:MI:SS') AS OTHERWEEKENDTIMESFROM,
                    TO_CHAR(KR.OTHERWEEKENDTIMESTHRU, 'HH24:MI:SS') AS OTHERWEEKENDTIMESTHRU,
                    KR.ACCESSENDDATE, KR.DISPOSITION, KR.NUMBERREPLACED, KR.REPLACEDREASON, KR.RECEIVEDBYCUSTOMER,
                    KR.RECEIVEDBYDATE
          FROM		KEYREQUESTS KR
          WHERE	KR.KEYREQUESTWRID = <CFQUERYPARAM value="#FORM.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	KR.KEYREQUESTWRID
     </CFQUERY>
     
     <CFSET session.ROOMCOUNT = LISTLEN(#LookupKeyRequestInfo.DOORSACCESSED#)>
     <CFSET temp = ArraySet(session.DOORSACCESSEDARRAY, 1, LISTLEN(#LookupKeyRequestInfo.DOORSACCESSED#), 0)> 
	<CFSET session.DOORSACCESSEDARRAY = ListToArray(#LookupKeyRequestInfo.DOORSACCESSED#)>
     <CFSET BUILDINGNAME1 = "">
	<CFSET BUILDINGNAME2 = "">
	<CFSET BUILDINGNAME3 = "">
	<CFSET BUILDINGNAME4 = "">
	<CFSET BUILDINGNAME5 = "">
	<CFSET DOORSACCESSED1 = "">
	<CFSET DOORSACCESSED2 = "">
	<CFSET DOORSACCESSED3 = "">
	<CFSET DOORSACCESSED4 = "">
	<CFSET DOORSACCESSED5 = "">
     
	<CFLOOP index="Counter" from=1 to=#session.ROOMCOUNT#>
     
          <CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES">
               SELECT	LOC.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER
               FROM		LOCATIONS LOC, BUILDINGNAMES BN
               WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#session.DOORSACCESSEDARRAY[Counter]#" cfsqltype="CF_SQL_NUMERIC"> AND 
                         LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID
               ORDER BY	LOC.ROOMNUMBER
          </CFQUERY>
          
          <CFIF #Counter# EQ 1>
          	<CFSET BUILDINGNAME1  = "#LookupRoomNumbers.BUILDINGNAME#">
          	<CFSET DOORSACCESSED1 = "#LookupRoomNumbers.ROOMNUMBER#">
          <CFELSEIF #Counter# EQ 2>
          	<CFSET BUILDINGNAME2  = "#LookupRoomNumbers.BUILDINGNAME#">
          	<CFSET DOORSACCESSED2 = "#LookupRoomNumbers.ROOMNUMBER#">
          <CFELSEIF #Counter# EQ 3>
          	<CFSET BUILDINGNAME3  = "#LookupRoomNumbers.BUILDINGNAME#">
          	<CFSET DOORSACCESSED3 = "#LookupRoomNumbers.ROOMNUMBER#">
          <CFELSEIF #Counter# EQ 4>
          	<CFSET BUILDINGNAME4  = "#LookupRoomNumbers.BUILDINGNAME#">
          	<CFSET DOORSACCESSED4 = "#LookupRoomNumbers.ROOMNUMBER#">
          <CFELSEIF #Counter# EQ 5>
          	<CFSET BUILDINGNAME5  = "#LookupRoomNumbers.BUILDINGNAME#">
          	<CFSET DOORSACCESSED5 = "#LookupRoomNumbers.ROOMNUMBER#">
          </CFIF>

	</CFLOOP>

     <TABLE width="100%" border="3" cellpadding="0" cellspacing="0">
          <TR>
               <TH align="CENTER" colspan="2">
                    <H1>Physical Plant Work Order</H1>
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
               <TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/facilities/univpolicekeycardrequest.cfm" method="POST">
                    <INPUT type="submit" value="Cancel" tabindex="1" />
</CFFORM>
               </TD>
          </TR>
     </TABLE>

<CFFORM action="/#application.type#apps/facilities/univpolicekeycardrequest.cfm?WORKREQUESTID=#FORM.WORKREQUESTID#" method="POST">
     <TABLE width="100%" border="0">
          <TR>
               <TD align="LEFT">
                    <INPUT type="submit" name="ProcessPPWO" value="Email Form" tabindex="2" />
               </TD>
          </TR>
          <TR>
               <TD align="center">    
     <CFSET PDF.InpKeyCardContent = "/home/www/lfolkstestcf/htdocs/DEVapps/facilities/Authorized_Signature_KeyCard.pdf">
     <CFSET PDF.OutKeyCardContent = "/home/www/lfolkstestcf/htdocs/DEVapps/datafiles/UPKeyCardRequest#FORM.WORKREQUESTNUMBER#.pdf">
 
<!---      
	<cfpdfform source="#PDF.InpKeyCardContent#" action="read" result="KeyCardContent"/>
     <cfdump var="#KeyCardContent#" output="browser" format="html" label="University Police Key/Card Request Output Form for Work Request #FORM.WORKREQUESTNUMBER#" expand="yes">
 --->      
     <CFSET FORM.REQUESTDATE = #DateFormat(now(), 'mm-dd-yyyy')#>
     <CFSET FORM.DEANNAME = 'Gale Etschmaier'>
     <CFSET FORM.DEANSIGNATURE = 'Gale Etschmaier'>
     <CFSET FORM.AUTHNAME = 'Maureen Dotson'>
     <CFSET FORM.AUTHSIGNATURE = 'Maureen Dotson'>
     
     <cfdocument format="pdf" filename="#PDF.OutKeyCardContent#" overwrite="yes">
          <cfpdfform action="populate" source="#PDF.InpKeyCardContent#">
          	<cfdocumentsection name="UPKeyCardRequest"> 
                  <h3>University Police Key/Card Request</h3>  
               </cfdocumentsection>
               <cfpdfformparam name="REQUESTDATE" value="#FORM.REQUESTDATE#">
               <cfpdfformparam name="REQUESTER" value="#LookupRequesters.FULLNAME#">
               <cfpdfformparam name="MAILCODE" value="#LookupUnits.CAMPUSMAILCODE#">
               <cfpdfformparam name="REQUESTEREMAIL" value="#LookupRequesters.EMAIL#">
               <cfpdfformparam name="REQUESTERPHONE" value="#LookupRequesters.CAMPUSPHONE#"> 
               <cfpdfformparam name="DEPTUNIT" value="#LookupUnits.DEPTUNIT#"> 
               <cfpdfformparam name="BUILDINGNAME1" value="#BUILDINGNAME1#">
               <cfpdfformparam name="DOORSACCESSED1" value="#DOORSACCESSED1#">
               <cfpdfformparam name="BUILDINGNAME2" value="#BUILDINGNAME2#">
               <cfpdfformparam name="DOORSACCESSED2" value="#DOORSACCESSED2#">
               <cfpdfformparam name="BUILDINGNAME3" value="#BUILDINGNAME3#">
               <cfpdfformparam name="DOORSACCESSED3" value="#DOORSACCESSED3#">
               <cfpdfformparam name="BUILDINGNAME4" value="#BUILDINGNAME4#">
               <cfpdfformparam name="DOORSACCESSED4" value="#DOORSACCESSED4#">
               <cfpdfformparam name="BUILDINGNAME5" value="#BUILDINGNAME5#">
               <cfpdfformparam name="DOORSACCESSED5" value="#DOORSACCESSED5#">
               <cfpdfformparam name="DEANNAME" value="#FORM.DEANNAME#">
               <cfpdfformparam name="DEANSIGNATURE" value="#FORM.DEANSIGNATURE#">
               <cfpdfformparam name="AUTHNAME" value="#FORM.AUTHNAME#"> 
               <cfpdfformparam name="AUTHSIGNATURE" value="#FORM.AUTHSIGNATURE#"> 
           </cfpdfform>

	</cfdocument>
     
     <BR><BR>  
    <cfpdfform source="#PDF.OutKeyCardContent#" action="read" result="KeyCardContent"/> 
    <cfdump var="#KeyCardContent#" output="browser" format="html" label="University Police Key/Card Request Output Form for Work Request #FORM.WORKREQUESTNUMBER#" expand="yes"> 
    <BR><BR>
    			</TD>
          </TR>
          <TR>
               <TD align="LEFT">
                    <INPUT type="submit"  name="ProcessUPKCR" value="Email Form" tabindex="3" />
               </TD>
          </TR>
     </TABLE>
</cfform>

     <TABLE width="100%" border="0">
          <TR>
               <TD align="LEFT">
<CFFORM action="/#application.type#apps/facilities/univpolicekeycardrequest.cfm" method="POST">
                    <INPUT type="submit" value="Cancel" tabindex="4" />
</CFFORM>
               </TD>
          </TR>
     </TABLE> 

</CFIF>


</BODY>
</CFOUTPUT>
</HTML>