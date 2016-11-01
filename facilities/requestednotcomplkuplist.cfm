<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: requestednotcomplkuplist.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/20/2012 --->
<!--- Date in Production: 02/20/2012 --->
<!--- Module: Facilities Requested/Not Completed Lookup/List Report --->
<!-- Last modified by John R. Pastori on 02/20/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/requestednotcomplkuplist.cfm">
<CFSET CONTENT_UPDATED = "February 20, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities Requested/Not Completed Lookup/List Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Facilities Application!";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


	function validateREQTYPEReqFields() {
		if (document.LOOKUP1.REQUESTTYPEID.selectedIndex == "0") {
			alertuser ("You must select a Request Type.");
			document.LOOKUP1.REQUESTTYPEID.focus();
			return false;
		}
	}

	function validateREQSTATReqFields() {
		if (document.LOOKUP2.REQUESTSTATUSID.selectedIndex == "0") {
			alertuser ("You must select a Request Status.");
			document.LOOKUP2.REQUESTSTATUSID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPREQUESTTYPEID') AND NOT IsDefined('URL.LOOKUPREQUESTSTATUSID')>
	<CFSET CURSORFIELD = "document.LOOKUP1.REQUESTTYPEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*****************************************************************************************************************************
* The following code is the Request Type and Request Status Records Lookup Process for Requested/Not Completed List/Modify. *
*****************************************************************************************************************************
 --->
 

<CFIF IsDefined('URL.LIST_LOOKUP')>
	<CFSET CLIENT.LIST_LOOKUP = "#URL.LIST_LOOKUP#">
</CFIF>


<CFIF NOT IsDefined('URL.LOOKUPREQUESTTYPEID') AND NOT IsDefined('URL.LOOKUPREQUESTSTATUSID')>

     <CFSET CLIENT.REPORTTITLE = ''>

	<CFQUERY name="ListRequestTypes" datasource="#application.type#FACILITIES" blockfactor="13">
          SELECT	REQUESTTYPEID, REQUESTTYPENAME
          FROM		REQUESTTYPES
          ORDER BY	REQUESTTYPENAME
     </CFQUERY>
	
	<CFQUERY name="ListRequestStatus" datasource="#application.type#FACILITIES">
		SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
		FROM		REQUESTSTATUS
		ORDER BY	REQUESTSTATUSNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
          <CFIF CLIENT.LIST_LOOKUP EQ "LIST">
			<TD align="center"><H1>Requested/Not Completed List Lookup</H1></TD>
          <CFELSE>
          	<TD align="center"><H1>Requested/Not Completed Modify Lookup</H1></TD>
          </CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TD align="center"><H4>One of the Lookup Fields MUST be chosen!</H4></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="left" width="50%"><LABEL for="REQUESTTYPEID">Request Type</LABEL></TH>
               <TH align="left" width="50%"><LABEL for="REPORTSORTORDER1">Request Type Report Sort Order</LABEL></TH>
		</TR>
<CFFORM name="LOOKUP1" onsubmit="return validateREQTYPEReqFields();" action="/#application.type#apps/facilities/requestednotcomplkuplist.cfm?LOOKUPREQUESTTYPEID=FOUND&LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" selected ="0" display="REQUESTTYPENAME" required="No" tabindex="2"></CFSELECT>
               </TD>
               <TD align="left" width="50%">
                   	<CFSELECT name="REPORTSORTORDER1" id="REPORTSORTORDERD1" size="1" required="No" tabindex="3">
                         <OPTION value="0">Select a Sort Order</OPTION>
                    	<OPTION value="1">Shops WO Number</OPTION>
                         <OPTION value="2">Work Request Number</OPTION>
                         <OPTION value="3">Requester, Work Request Number</OPTION>
                         <OPTION value="4">Requester, Shops WO Number</OPTION>
                    </CFSELECT>
               </TD>
          </TR>
          <TR>
               <TD align="left" COLSPAN="2">
				<INPUT type="submit" value="Select Request Type" tabindex="4" />
			</TD>
		</TR>
</CFFORM>
		<TR>
               <TD align="left" COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left" width="50%"><LABEL for="STAFF_ASSIGNEDID">Request Status</LABEL></TH>
               <TH align="left" width="50%"><LABEL for="REPORTSORTORDER2">Request Status Report Sort Order</LABEL></TH>
		</TR>
<CFFORM name="LOOKUP2" onsubmit="return validateREQSTATReqFields();" action="/#application.type#apps/facilities/requestednotcomplkuplist.cfm?LOOKUPREQUESTSTATUSID=FOUND&LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">
		<TR>
			<TD align="left" width="50%">
				<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="ListRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" tabindex="5"></CFSELECT>
               </TD>
               <TD align="left" width="50%">
                   	<CFSELECT name="REPORTSORTORDER2" id="REPORTSORTORDER2" size="1" required="No" tabindex="6">
                         <OPTION value="0">Select a Sort Order</OPTION>
                    	<OPTION value="1">Shops WO Number</OPTION>
                         <OPTION value="2">Work Request Number</OPTION>
                         <OPTION value="3">Requester, Work Request Number</OPTION>
                         <OPTION value="4">Requester, Shops WO Number</OPTION>
                    </CFSELECT>
			</TD>
          </TR>
          <TR>
               <TD align="left" COLSPAN="2">
				<INPUT type="submit" value="Select Request Status" tabindex="7" />
			</TD>
		</TR>
</CFFORM>
		</TR>
          <TR>
			<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="8" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	<CFEXIT>
     
<CFELSE>

<!--- 
*******************************************************************************************************************************
* The following code is the Request Type or Request Status Records Selection Process for Requested/Not Completed List/Modify. *
*******************************************************************************************************************************
 --->
     
     <CFIF IsDefined('URL.REQUESTTYPEID')>
		<CFSET FORM.REQUESTTYPEID = "#URL.REQUESTTYPEID#">
 	<CFELSEIF IsDefined('URL.REQUESTSTATUSID')>
		<CFSET FORM.REQUESTSTATUSID = "#URL.REQUESTSTATUSID#">
     </CFIF>
 
	<CFSET CLIENT.REPORTCHOICE = 0>
     <CFSET CLIENT.REPORTORDER = 0>
     <CFIF IsDefined('FORM.REPORTSORTORDER1') AND #FORM.REPORTSORTORDER1# GT 0>
          <CFSET CLIENT.REPORTCHOICE = #FORM.REPORTSORTORDER1#>
     <CFELSEIF IsDefined('FORM.REPORTSORTORDER2') AND #FORM.REPORTSORTORDER2# GT 0>
          <CFSET CLIENT.REPORTCHOICE = #FORM.REPORTSORTORDER2#>
     <CFELSE>
          <CFSET CLIENT.REPORTCHOICE = 1>
     </CFIF>
      
     <CFSET SORTORDER = ARRAYNEW(1)>
     <CFSET SORTORDER[1]  = 'EWOI.SHOPSWONUM'>
     <CFSET SORTORDER[2]  = 'WR.WORKREQUESTNUMBER'>
     <CFSET SORTORDER[3]  = 'REQCUST.FULLNAME~ WR.WORKREQUESTNUMBER'>
     <CFSET SORTORDER[4]  = 'REQCUST.FULLNAME~ EWOI.SHOPSWONUM'>
     
     <CFSET CLIENT.REPORTORDER = EVALUATE("SORTORDER[#CLIENT.REPORTCHOICE#]")>
     
     <CFIF FIND('~', #CLIENT.REPORTORDER#, 1) NEQ 0>
          <CFSET CLIENT.REPORTORDER = ListChangeDelims(CLIENT.REPORTORDER, ",", "~")>
     </CFIF>
     REPORT ORDER = #CLIENT.REPORTORDER#<BR><BR>
      
     <CFIF #CLIENT.REPORTCHOICE# NEQ 1>
     
          <CFQUERY name="GetWorkRequests_ShopsWO" datasource="#application.type#FACILITIES">
               SELECT	WR.WORKREQUESTID, WR.WORKREQUESTNUMBER, EWOI.EXTERNLWOID, EWOI.WORKREQUESTID, EWOI.SHOPSWONUM, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, 
                         WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION,  WR.LOCATIONID, LOC.ROOMNUMBER, WR.REQUESTERID, REQCUST.FULLNAME, 
                         WR.REQUESTSTATUSID, RS.REQUESTSTATUSNAME, EWOI.EXTERNLSHOPID, ES.EXTERNLSHOPNAME
               FROM		WORKREQUESTS WR, EXTERNLWOINFO EWOI, REQUESTTYPES RT, LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, REQUESTSTATUS RS, EXTERNLSHOPS ES
               WHERE	WR.WORKREQUESTID = EWOI.WORKREQUESTID AND
               		WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
                         WR.LOCATIONID = LOC.LOCATIONID AND
                         WR.REQUESTERID = REQCUST.CUSTOMERID AND
                         WR.REQUESTSTATUSID = RS.REQUESTSTATUSID AND
 					EWOI.EXTERNLSHOPID = ES.EXTERNLSHOPID AND
                   <CFIF IsDefined('FORM.REQUESTTYPEID')>
                         WR.REQUESTTYPEID = <CFQUERYPARAM value="#FORM.REQUESTTYPEID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    </CFIF>
                    <CFIF IsDefined('FORM.REQUESTSTATUSID')>
                         WR.REQUESTSTATUSID = <CFQUERYPARAM value="#FORM.REQUESTSTATUSID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    </CFIF>
                         WR.WORKREQUESTID > 0
               ORDER BY	#CLIENT.REPORTORDER#
          </CFQUERY>

     
	<CFELSE>

		<CFQUERY name="GetWorkRequests_ShopsWO" datasource="#application.type#FACILITIES">
               SELECT	EWOI.EXTERNLWOID, EWOI.WORKREQUESTID, EWOI.SHOPSWONUM, WR.WORKREQUESTID, WR.WORKREQUESTNUMBER, WR.REQUESTTYPEID, RT.REQUESTTYPENAME, 
                         WR.PROBLEMDESCRIPTION, WR.JUSTIFICATIONDESCRIPTION,  WR.LOCATIONID, LOC.ROOMNUMBER, WR.REQUESTERID, REQCUST.FULLNAME, 
                         WR.REQUESTSTATUSID, RS.REQUESTSTATUSNAME, EWOI.EXTERNLSHOPID, ES.EXTERNLSHOPNAME
               FROM		EXTERNLWOINFO EWOI, WORKREQUESTS WR, REQUESTTYPES RT, LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, REQUESTSTATUS RS, EXTERNLSHOPS ES
               WHERE	EWOI.WORKREQUESTID = WR.WORKREQUESTID AND
               		WR.REQUESTTYPEID = RT.REQUESTTYPEID AND
                         WR.LOCATIONID = LOC.LOCATIONID AND
                         WR.REQUESTERID = REQCUST.CUSTOMERID AND
                         WR.REQUESTSTATUSID = RS.REQUESTSTATUSID AND
 					EWOI.EXTERNLSHOPID = ES.EXTERNLSHOPID AND
                   <CFIF IsDefined('FORM.REQUESTTYPEID')>
                         WR.REQUESTTYPEID = <CFQUERYPARAM value="#FORM.REQUESTTYPEID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    </CFIF>
                    <CFIF IsDefined('FORM.REQUESTSTATUSID')>
                         WR.REQUESTSTATUSID = <CFQUERYPARAM value="#FORM.REQUESTSTATUSID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    </CFIF>
                         EWOI.EXTERNLWOID > 0
               ORDER BY	#CLIENT.REPORTORDER#
          </CFQUERY>
     
     </CFIF> 
</CFIF>

<CFSET CLIENT.REPORTTILE1 = "Requested/Not Completed ">
<CFIF IsDefined('FORM.REQUESTTYPEID')>

	<CFIF CLIENT.LIST_LOOKUP EQ "LIST">
		<CFSET CLIENT.REPORTTILE2 = "List By Request Type">
	<CFELSE>
		<CFSET CLIENT.REPORTTILE2 = "Lookup By Request Type">
	</CFIF>
     
	<CFSET CLIENT.REPORTTILE3 = "For Request Type: &nbsp;&nbsp;#GetWorkRequests_ShopsWO.REQUESTTYPENAME#">

<CFELSE>

	<CFIF CLIENT.LIST_LOOKUP EQ "LIST">
		<CFSET CLIENT.REPORTTILE2 = "List By Request Status">
	<CFELSE>
		<CFSET CLIENT.REPORTTILE2 = "Lookup By Request Status">
	</CFIF>

	<CFSET CLIENT.REPORTTILE3 = "For Request Status: &nbsp;&nbsp;#GetWorkRequests_ShopsWO.REQUESTSTATUSNAME#">

</CFIF>


<!--- 
******************************************************************************************************************************
* The following code is the Display form for Request Type or Request Status Records for Requested/Not Completed List/Modify. *
******************************************************************************************************************************
 --->

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center">
			<H1>#CLIENT.REPORTTILE1##CLIENT.REPORTTILE2#</H1>
			<H2>#CLIENT.REPORTTILE3#</H2>
		</TD>       
	</TR>
</TABLE>
<BR clear="left" />

<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/facilities/requestednotcomplkuplist.cfm?LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">
		<TD align="left">
			<INPUT type="submit" name="SUBMIT_BUTTON" value="CANCEL" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER"><H2>#GetWorkRequests_ShopsWO.RecordCount# Work Request/Shop WO records were selected.</H2></TH>
	</TR>
</TABLE>
<CFIF CLIENT.LIST_LOOKUP EQ "LOOKUP"> 
<CFFORM action="/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFYDELETE&LOOKUPWORKREQUESTID=FOUND&LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">

     <TABLE width="100%" border="1">
          <TR>
               <TD align="left" colspan="9" valign="TOP">
                    <cfinput type="Submit"  name="SUBMIT" value="Go">
               </TD>
          </TR>
          <TR> 
               <TH align="center">&nbsp;&nbsp;</TH>
               <TH align="center">Work Request Number</TH>
               <TH align="center">Shops WO Number</TH>
               <TH align="center">Request Type</TH>
               <TH align="center">Problem/Justification Description</TH>
               <TH align="center">Location</TH>
               <TH align="center">Requester</TH>
               <TH align="center">Request Status</TH>
               <TH align="center">Ext Shops</TH>
          </TR>
     
 	<CFLOOP query="GetWorkRequests_ShopsWO">
     
          <TR>
               <TD align="center" valign="TOP">
                    <cfinput type="radio" name="WORKREQUESTID" value="#GetWorkRequests_ShopsWO.WORKREQUESTID#">
               </TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.WORKREQUESTNUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.SHOPSWONUM#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.REQUESTTYPENAME#</DIV></TD>
               <TD align="left" valign="TOP">
                    <DIV>
                         #LEFT(GetWorkRequests_ShopsWO.PROBLEMDESCRIPTION, 100)#<BR>
                         #LEFT(GetWorkRequests_ShopsWO.JUSTIFICATIONDESCRIPTION, 100)#
                    </DIV>
               </TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.ROOMNUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.FULLNAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.REQUESTSTATUSNAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.EXTERNLSHOPNAME#</DIV></TD>
          </TR>
     
     </CFLOOP>
          <TR>
               <TD align="left" colspan="9" valign="TOP">
                    <cfinput type="Submit"  name="SUBMIT" value="Go">
               </TD>
          </TR>
     </TABLE>

</CFFORM>
     
<CFELSE>

     <TABLE width="100%" border="1">
          <TR> 
               <TH align="center">Work Request Number</TH>
               <TH align="center">Shops WO Number</TH>
               <TH align="center">Request Type</TH>
               <TH align="center">Problem/Justification Description</TH>
               <TH align="center">Location</TH>
               <TH align="center">Requester</TH>
               <TH align="center">Request Status</TH>
               <TH align="center">Ext Shops</TH>
          </TR>
     
     <CFLOOP query="GetWorkRequests_ShopsWO">
     
          <TR>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.WORKREQUESTNUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.SHOPSWONUM#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.REQUESTTYPENAME#</DIV></TD>
               <TD align="left" valign="TOP">
                    <DIV>
                         #LEFT(GetWorkRequests_ShopsWO.PROBLEMDESCRIPTION, 100)#<BR>
                         #LEFT(GetWorkRequests_ShopsWO.JUSTIFICATIONDESCRIPTION, 100)#
                    </DIV>
               </TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.ROOMNUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.FULLNAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.REQUESTSTATUSNAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#GetWorkRequests_ShopsWO.EXTERNLSHOPNAME#</DIV></TD>
          </TR>
          
     </CFLOOP>
			
</CFIF>
</TABLE>
<TABLE width="100%" border="0">
	<TR>
		<TH align="CENTER" colspan="9"><H2>#GetWorkRequests_ShopsWO.RecordCount# Work Request/Shop WO records were selected.</H2></TH>
	</TR>

	<TR>
<CFFORM action="/#application.type#apps/facilities/requestednotcomplkuplist.cfm?LIST_LOOKUP=#CLIENT.LIST_LOOKUP#" method="POST">
		<TD align="left" colspan="9"><INPUT type="submit" value="Cancel" tabindex="2" /></TD>
</CFFORM>
</TR>
	<TR>
		<TD colspan="9">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>


</BODY>
</CFOUTPUT>
</HTML>