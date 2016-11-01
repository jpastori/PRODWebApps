<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: physicalplantwo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/14/2012 --->
<!--- Date in Production: 02/14/2012 --->
<!--- Module: Facilities Application - Physical Plant Work Order --->
<!-- Last modified by John R. Pastori on 02/14/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/physicalplantwo.cfm">
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
***************************************************************************
* The following code sends the Physical Plant Work Order to Work Control. *
***************************************************************************
 --->
 
</CFOUTPUT>
<CFIF IsDefined("FORM.ProcessPPWO")>
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
	<CFSET PDF.OutPPWOContent = "/home/www/lfolkstestcf/htdocs/DEVapps/datafiles/PPWorkOrderForm#FORM.WORKREQUESTNUMBER#.pdf">
     
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
			WR.REQUESTTYPEID IN (4,6,9,10,13,14) AND
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
<CFFORM name="LOOKUP" action="/#application.type#apps/facilities/physicalplantwo.cfm?LOOKUPWORKREQUESTID=FOUND" method="POST">
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
**********************************************************************************
* The following code generates the Facilities - Physical Plant Work Order Screen.*
**********************************************************************************
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

	<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES">
		SELECT	LOC.LOCATIONID, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.ROOMNUMBER
		FROM		LOCATIONS LOC, BUILDINGNAMES BN
		WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#LookupWorkRequests.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID
		ORDER BY	LOC.ROOMNUMBER
	</CFQUERY>

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
<CFFORM action="/#application.type#apps/facilities/physicalplantwo.cfm" method="POST">
                    <INPUT type="submit" value="Cancel" tabindex="1" />
</CFFORM>
               </TD>
          </TR>
     </TABLE>

<CFFORM action="/#application.type#apps/facilities/physicalplantwo.cfm?WORKREQUESTID=#FORM.WORKREQUESTID#" method="POST">
     <TABLE width="100%" border="0">
          <TR>
               <TD align="LEFT">
                    <INPUT type="submit" name="ProcessPPWO" value="Email Form" tabindex="2" />
               </TD>
          </TR>
          <TR>
               <TD align="center">    
     <CFSET PDF.InpPPWOContent = "/home/www/lfolkstestcf/htdocs/DEVapps/facilities/PPWorkOrderForm.pdf">
     <CFSET PDF.OutPPWOContent = "/home/www/lfolkstestcf/htdocs/DEVapps/datafiles/PPWorkOrderForm#FORM.WORKREQUESTNUMBER#.pdf">
     
<!--- 
     <cfpdfform source="#PDF.InpPPWOContent#" action="read" result="fields2"/>
     <cfdump var="#fields2#" output="browser" format="html" label="Physical Plant Work Order Input Templete" expand="yes">
 --->
     
     <CFSET FORM.WOCREATEDATE = #DateFormat(now(), 'mm-dd-yyyy')#>
     <CFSET FORM.AUTHSIGNATURE = 'Maureen Dotson'>
     <CFSET FORM.SIGNATUREDATE = #DateFormat(now(), 'mm-dd-yyyy')#>
     
     <cfdocument format="pdf" filename="#PDF.OutPPWOContent#" overwrite="yes">
          <cfpdfform action="populate" source="#PDF.InpPPWOContent#">
          	<cfdocumentsection name="PhysicalPlantWO"> 
                  <H3>Physical Plant Work Order</H3>  
               </cfdocumentsection>
               <cfpdfformparam name="DEPTUNIT" value="#LookupUnits.DEPTUNIT#">
               <cfpdfformparam name="REQUESTER" value="#LookupRequesters.FULLNAME#">
               <cfpdfformparam name="WOCREATEDATE" value="#FORM.WOCREATEDATE#">
               <cfpdfformparam name="REQUESTEREMAIL" value="#LookupRequesters.EMAIL#">
               <cfpdfformparam name="MAILCODE" value="#LookupUnits.CAMPUSMAILCODE#">
               <cfpdfformparam name="REQUESTERPHONE" value="#LookupRequesters.CAMPUSPHONE#">
               <cfpdfformparam name="ALTERNATECONTACT" value="#LookupAlternateContacts.FULLNAME#">
               <cfpdfformparam name="ALTCONTPHONE" value="#LookupAlternateContacts.CAMPUSPHONE#">
               <cfpdfformparam name="BUILDINGNAME" value="#LookupRoomNumbers.BUILDINGNAME#">
               <cfpdfformparam name="ROOMNUMBER" value="#LookupRoomNumbers.ROOMNUMBER#">
               <cfpdfformparam name="DATENEEDED" value="#LookupWorkRequests.STARTDATE#">
               <cfpdfformparam name="PROBLEMDESCRIPTION" value="#LookupWorkRequests.PROBLEMDESCRIPTION#">
               <cfpdfformparam name="JUSTIFICATIONDESCRIPTION" value="#LookupWorkRequests.JUSTIFICATIONDESCRIPTION#">
               <cfpdfformparam name="AUTHSIGNATURE" value="#FORM.AUTHSIGNATURE#">
               <cfpdfformparam name="SIGNATUREDATE" value="#FORM.SIGNATUREDATE#">
               <cfpdfformparam name="BILLINGACCOUNTNUMBER" value="#LookupWorkRequests.ACCOUNTNUMBER#">
          </cfpdfform>

	</cfdocument>
     
     <BR><BR>  
    <cfpdfform source="#PDF.OutPPWOContent#" action="read" result="PPWOContent"/>
    <cfdump var="#PPWOContent#" output="browser" format="html" label="Physical Plant Work Order Output Form for Work Request #FORM.WORKREQUESTNUMBER#" expand="yes">
    <BR><BR>
    			</TD>
          </TR>
          <TR>
               <TD align="LEFT">
                    <INPUT type="submit"  name="ProcessPPWO" value="Email Form" tabindex="3" />
               </TD>
          </TR>
     </TABLE>
</cfform>

     <TABLE width="100%" border="0">
          <TR>
               <TD align="LEFT">
<CFFORM action="/#application.type#apps/facilities/physicalplantwo.cfm" method="POST">
                    <INPUT type="submit" value="Cancel" tabindex="4" />
</CFFORM>
               </TD>
          </TR>
     </TABLE> 

</CFIF>


</BODY>
</CFOUTPUT>
</HTML>