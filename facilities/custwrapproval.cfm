<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custwrapproval.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Facilities - Customer Work Request Approval --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/custwrapproval.cfm">
<CFSET CONTENT_UPDATED = "February 10, 2012">

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Customer Work Request Approval</TITLE>

	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Library Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.CUSTWRAPPROVAL.REQUESTTYPEID != null && document.CUSTWRAPPROVAL.REQUESTTYPEID.selectedIndex == "0") {
			alertuser (document.CUSTWRAPPROVAL.REQUESTTYPEID.name +  ",  A Request Type MUST be selected!");
			document.CUSTWRAPPROVAL.REQUESTTYPEID.focus();
			return false;
		}
				
		if (document.CUSTWRAPPROVAL.PROBLEM_DESCRIPTION.value == "" || document.CUSTWRAPPROVAL.PROBLEM_DESCRIPTION.value == " ") {
			alertuser (document.CUSTWRAPPROVAL.PROBLEM_DESCRIPTION.name +  ",  You must enter a Problem Description.");
			document.CUSTWRAPPROVAL.PROBLEM_DESCRIPTION.focus();
			return false;
		}
		
		if (document.CUSTWRAPPROVAL.PROBLEM_LOCATIONID.selectedIndex == "0") {
			alertuser (document.CUSTWRAPPROVAL.PROBLEM_LOCATIONID.name +  ",  You must select a Problem Location!");
			document.CUSTWRAPPROVAL.PROBLEM_LOCATIONID.focus();
			return false;
		}
		
		if (document.CUSTWRAPPROVAL.PROBLEM_DATE.value == "" || document.CUSTWRAPPROVAL.PROBLEM_DATE.value == " " 
		 || !document.CUSTWRAPPROVAL.PROBLEM_DATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.CUSTWRAPPROVAL.PROBLEM_DATE.name +  ", The Date that the Problem first occurred MUST be entered in the format MM/DD/YYYY!");
			document.CUSTWRAPPROVAL.PROBLEM_DATE.focus();
			return false;
		}


	}

//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFSET CURSORFIELD = "document.CUSTWRAPPROVAL.REQUESTTYPEID.focus()">
<BODY onLoad="#CURSORFIELD#">


<CFSET FORM.CUSTADDREQUEST = #URL.CUSTADDREQUEST#>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">


<!--- 
*****************************************************************
* The following code is for all Customer WR Approval Processes. *
*****************************************************************
 --->
 
<CFQUERY name="ListRequestTypes" datasource="#application.type#FACILITIES" blockfactor="13">
	SELECT	REQUESTTYPEID, REQUESTTYPENAME
	FROM		REQUESTTYPES
	ORDER BY	REQUESTTYPENAME
</CFQUERY>


<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID,CUST.EMAIL, CUST.FAX, CUST.FULLNAME, CUST.UNITID, U.GROUPID, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND
			CUST.UNITID = U.UNITID) OR	
			(CUST.CATEGORYID IN (1,5,8,14,15) AND
               CUST.UNITID = U.UNITID AND
			U.GROUPID IN (2,3,4,6) AND
			CUST.ACTIVE = 'YES')	
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
			LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
			LOC.MODIFIEDBYID, LOC.MODIFIEDDATE
	FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
	WHERE	LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
</CFQUERY>

<CFQUERY name="LookupCustomerWRAdds" datasource="#application.type#FACILITIES" blockfactor="15">
	SELECT	CWRA.CUSTWRADDID, CWRA.REQUESTERID, CUST.CUSTOMERID, CUST.FULLNAME, CWRA.ALTERNATE_CONTACTID,
     		CWRA.PROBLEM_DESCRIPTION, CWRA.PROBLEM_LOCATIONID, CWRA.PROBLEM_DATE, CWRA.URGENCY
	FROM		CUSTWRADD CWRA, LIBSHAREDDATAMGR.CUSTOMERS CUST
     WHERE	CWRA.CUSTWRADDID = #FORM.CUSTADDREQUEST# AND
     		CWRA.REQUESTERID =  CUST.CUSTOMERID AND
     		CUST.ACTIVE = 'YES'
     ORDER BY  CUST.FULLNAME
</CFQUERY>

<!--- 
***********************************************************
* The following code is the Customer WR Approval Process. *
***********************************************************
 --->


<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Customer Work Request Approval</H1></TD>
	</TR>
</TABLE>

<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center">
			<H4>*Red fields marked with asterisks are required!</H4>
		</TH>
	</TR>
</TABLE>
<BR clear="left" />

<TABLE width="100%" align="LEFT" border="0">
	<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm" method="POST">
		<TD align="LEFT" colspan="2">
			<INPUT type="submit" value="CANCEL" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
<CFFORM name="CUSTWRAPPROVAL" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processcustwradd.cfm" method="POST" ENABLECAB="Yes">
	<TR>
          <TH align="left" valign ="BOTTOM">
               <H4><LABEL for="REQUESTTYPEID">*Request Type</LABEL></H4>
          </TH>
          <TH align="left" nowrap>Requestor</TH>
     </TR>
     <TR>
          <TD align="left" valign ="TOP">
               <CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="ListRequestTypes" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" selected="" tabindex="2"></CFSELECT>
          </TD>
		<TD align="left" valign="TOP">
          	<CFCOOKIE name="CUSTADDREQUEST" secure="NO" value="#FORM.CUSTADDREQUEST#">
               <INPUT type="hidden" name="REQUESTERID" value="#LookupCustomerWRAdds.REQUESTERID#" />
			#LookupCustomerWRAdds.FULLNAME#
		</TD>
     </TR>
     <TR>
		<TH align="left"><LABEL for="ALTERNATE_CONTACTID">Alternate Contact</LABEL></TH>
    		<TH align="left" nowrap><H4><LABEL for="PROBLEM_LOCATIONID">*Select by Problem Location</LABEL></H4></TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP">
			<CFSELECT name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListRequesters" value="CUSTOMERID" display="FULLNAME" selected="#LookupCustomerWRAdds.ALTERNATE_CONTACTID#" required="No" tabindex="3"></CFSELECT><BR>
               <COM>(Make selection only if the request involves a public workstation or printer.)</COM>
		</TD>
          <TD align="left" valign="TOP">
               <CFSELECT name="PROBLEM_LOCATIONID" id="PROBLEM_LOCATIONID" size="1" query="ListLocations" value="LOCATIONID" display="LOCATIONNAME" selected="#LookupCustomerWRAdds.PROBLEM_LOCATIONID#" required="No" tabindex="4"></CFSELECT>
          </TD>
	</TR>
	<TR>
		<TH align="left" valign="TOP" colspan="2"><H4><LABEL for="PROBLEM_DESCRIPTION">*Problem Description</LABEL></H4></TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP" colspan="2">
			<TEXTAREA name="PROBLEM_DESCRIPTION" id="PROBLEM_DESCRIPTION" rows="6" cols="100" wrap="VIRTUAL" REQUIRED="No" tabindex="5">#LookupCustomerWRAdds.PROBLEM_DESCRIPTION#</TEXTAREA><BR>
               <COM> (Please be as specific as possible. </COM>
          </TD>
     </TR>
     <TR>
     	<TD align="left" COLSPAN="2">&nbsp;&nbsp;</TD>
	</TR>       
     <TR>
          <TH align="left" valign="TOP">
               <H4><LABEL for="PROBLEM_DATE">*Date Problem First Occurred</LABEL></H4>
          </TH>
          <TH align="left" valign="TOP">
          	<LABEL for="URGENCY">Urgency</LABEL>
          </TH>
          
     </TR>
     <TR>
          
          <TD align="left" valign="TOP">
               <CFINPUT type="Text" name="PROBLEM_DATE" id="PROBLEM_DATE" value="#DateFormat(LookupCustomerWRAdds.PROBLEM_DATE, "MM/DD/YYYY")#" align="LEFT" required="No" size="15" tabindex="6">
			<SCRIPT language="JavaScript">
                    new tcal ({'formname': 'CUSTWRADD','controlname': 'PROBLEM_DATE'});

               </SCRIPT>
               <BR>
               <COM>MM/DD/YYYYY </COM>   
          </TD>
          <TD align="left" nowrap>
               <CFSELECT name="URGENCY" id="URGENCY" size="1" tabindex="7">
               	<OPTION selected value="#LookupCustomerWRAdds.URGENCY#">#LookupCustomerWRAdds.URGENCY#</OPTION>
                    <OPTION value="Select an Urgency">Select an Urgency</OPTION>
                    <OPTION value="Power Out/No Lights">Power Out/No Lights</OPTION>
                    <OPTION value="Public Service Affected">Public Service Affected</OPTION>
               </CFSELECT>
          </TD>     
     </TR>
     <TR>
		<TD align="LEFT" colspan="2"><INPUT type="submit" name="PROCESSCUSTWRADD" value="APPROVE" tabindex="8" /></TD>
	</TR>
</CFFORM>
	<TR>
<CFFORM action="/#application.type#apps/facilities/index.cfm" method="POST">
		<TD align="LEFT" colspan="2">
			<INPUT type="submit" value="CANCEL" tabindex="9" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>

</BODY>
</CFOUTPUT>
</HTML>