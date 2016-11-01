<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: telephonewossubmit.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/28/2013 --->
<!--- Date in Production: 02/28/2013 --->
<!--- Module: Submit Telephone Work Orders--->
<!-- Last modified by John R. Pastori on 02/28/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/telephonewossubmit.cfm">
<CFSET CONTENT_UPDATED = "February 28, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Submit Telephone Work Orders</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Service Requests";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined("URL.LOOKUPWO")>
	<CFSET CURSORFIELD = "document.LOOKUP.SRID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
***************************************************************************************************
* The following code is the Look Up Process for Display of Telephone Work Orders to be Submitted. *
***************************************************************************************************
 --->

<CFIF NOT IsDefined("URL.LOOKUPWO")>

	<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<CFQUERY name="LookupTelephoneWOs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	TNSWO_ID, SRID, WO_TYPE, WO_STATUS, STAFFID, CURRENT_JACKNUMBER, NEW_JACKNUMBER, HW_INVENTORYID, 
				ACCOUNTNUMBER1, ACCOUNTNUMBER2, ACCOUNTNUMBER3, WORK_DESCRIPTION, JUSTIFICATION_DESCRIPTION,
                    OTHER_DESCRIPTION, WO_DUEDATE, WO_NUMBER, EBA_111, NEW_LOCATION
		FROM		TNSWORKORDERS
		WHERE	TNSWO_ID > 0 AND
          		WO_TYPE LIKE ('%PHONE%') AND
				WO_STATUS = 'PENDING'
		ORDER BY	WO_TYPE
	</CFQUERY>

	<CFIF LookupTelephoneWOs.RecordCount EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert ("There are NO Telephone Work Orders on file.");
			-->
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
		<CFEXIT>
	</CFIF>

	<CFQUERY name="LookupServiceRequestsCurrFY" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
                    SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
                    SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID,
                    SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID,
                    SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
                    SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
                    SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,
               <CFIF #Client.SecurityFlag# EQ "No">
                    CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
               <CFELSE>
                    CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || SR.SRCOMPLETED AS LOOKUPKEY
               </CFIF>
          FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	(SR.SRID = 0 OR 
				SR.SRID IN (#ValueList(LookupTelephoneWOs.SRID)#)) AND
                    (SR.REQUESTERID = CUST.CUSTOMERID AND
               <CFIF #Client.SecurityFlag# EQ "No">
                    (SR.SRCOMPLETED = 'NO' OR
                     SR.SRCOMPLETED = ' Completed?') AND
               </CFIF>
                    SR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) 
          ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
     </CFQUERY>
     
     <CFQUERY name="LookupServiceRequestsPrevFYs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
                    SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
                    SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID,
                    SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID,
                    SR.GROUPASSIGNEDID, SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID,
                    SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
                    SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,
               <CFIF #Client.SecurityFlag# EQ "No">
                    CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
               <CFELSE>
                    CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || SR.SRCOMPLETED AS LOOKUPKEY
               </CFIF>
          FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	(SR.SRID = 0 OR 
				SR.SRID IN (#ValueList(LookupTelephoneWOs.SRID)#)) AND
                    (SR.REQUESTERID = CUST.CUSTOMERID AND
               <CFIF #Client.SecurityFlag# EQ "No">
                    (SR.SRCOMPLETED = 'NO' OR
                     SR.SRCOMPLETED = ' Completed?') AND
               </CFIF>
               SR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) 
          ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
     </CFQUERY>

     <TABLE width="100%" align="center" border="3">
          <TR align="center">
               <TD align="center"><H1>Submit Telephone Work Orders Lookup</H1></TD>
          </TR>
     </TABLE>
     <TABLE width="100%" align="center" border="0">
          <TR>
               <TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
          </TR>
     </TABLE>
     <BR clear="left" />

     <TABLE width="100%" align="LEFT" border="0">
          <TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
               <TD align="left" colspan="2">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>

</CFFORM>
          </TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=#URL.PROCESS#&LOOKUPWO=FOUND" method="POST">
          <TR>
               <TH align="left" width="30%"><H4><LABEL for="SRID1">*Requester/SR For Current Fiscal Year & CFY+1:</LABEL></H4></TH>
               <TD align="left" width="70%">
                    <CFSELECT name="SRID1" id="SRID1" size="1" required="No" tabindex="2">
                         <CFIF #Client.SecurityFlag# EQ "No">
                              <OPTION value="0">CUSTOMER - Select SR </OPTION>
                         <CFELSE>
                              <OPTION value="0">CUSTOMER - Select SR - Completed?</OPTION>
                         </CFIF>
                         <CFLOOP query="LookupServiceRequestsCurrFY">
                              <OPTION value="#SRID#">#LOOKUPKEY#</OPTION>
                         </CFLOOP>  
                    </CFSELECT>
               </TD>
          </TR>
          <TR>
               <TH align="left" width="30%"><H4><LABEL for="SRID2">*Or Requester/SR For Previous Fiscal Years:</LABEL></H4></TH>
               <TD align="left" width="70%">
                    <CFSELECT name="SRID2" id="SRID2" size="1" query="LookupServiceRequestsPrevFYs" value="SRID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
               </TD>
          </TR>
          <TR>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TD align="left" width="33%">
                    <INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
               </TD>
          </TR>
</CFFORM>
          <TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
               <TD align="left" colspan="2">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
</CFFORM>
          </TR>
          <TR>
               <TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
          </TR>
     </TABLE>

	<CFEXIT>
<CFELSE>

<!--- 
*********************************************************************
* The following code displays Telephone Work Order to be Submitted. *
*********************************************************************
 --->

	<CFIF IsDefined('FORM.SRID')>
		<CFCOOKIE name="SRID" secure="NO" value="#FORM.SRID#">
	<CFELSEIF IsDefined('URL.SRID')>
		<CFSET FORM.SRID = #val(URL.SRID)#>
		<CFCOOKIE name="SRID" secure="NO" value="#FORM.SRID#">
	</CFIF>

	<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
				SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, CUST.FIRSTNAME, CUST.LASTNAME,CUST.LOCATIONID, LOC.ROOMNUMBER,  
                    CUST.CAMPUSPHONE, CUST.EMAIL, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID,SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID,  
				SR.GROUPASSIGNEDID, SR.SERVICETYPEID,SR.ACTIONID, SR.OPERATINGSYSTEMID,SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME,  
				SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC
		WHERE	SR.SRID > 0 AND
				SR.SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SR.REQUESTERID = CUST.CUSTOMERID AND
				CUST.LOCATIONID = LOC.LOCATIONID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFQUERY name="GetTelephoneWOs" datasource="#application.type#SERVICEREQUESTS">
          SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.STAFFID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.FULLNAME, 
          		CUST.EMAIL, CUST.CAMPUSPHONE, CUST.LOCATIONID, STAFFLOC.ROOMNUMBER AS STAFFROOM, TNSWO.NEW_LOCATION, JACKLOC.ROOMNUMBER AS JACKROOM, 
                    TNSWO.WORK_DESCRIPTION, TNSWO.ACCOUNTNUMBER1, TNSWO.ACCOUNTNUMBER2, TNSWO.ACCOUNTNUMBER3, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER,
                    TNSWO.PHONE_CURRENT_JACKNUMBER, TNSWO.PHONE_NEW_JACKNUMBER
          FROM		TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS STAFFLOC, FACILITIESMGR.LOCATIONS JACKLOC
          WHERE	TNSWO.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    TNSWO.STAFFID = CUST.CUSTOMERID AND
                    CUST.LOCATIONID = STAFFLOC.LOCATIONID AND
                    TNSWO.NEW_LOCATION = JACKLOC.LOCATIONID AND
          		TNSWO.WO_TYPE LIKE ('%PHONE%')
          ORDER BY	TNSWO.WO_TYPE
     </CFQUERY>

	<CFIF GetTelephoneWOs.RecordCount EQ 0>
          <SCRIPT language="JavaScript">
               <!-- 
                    alert ("This SR is NOT Associated with a Telephone Work Order.");
               -->
          </SCRIPT>
          <CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ 'YES') OR (IsDefined('client.STAFFLOOP') AND #client.STAFFLOOP# EQ 'YES'))>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#" />
               <CFEXIT>
          <CFELSE>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=ADD&SRID=#FORM.SRID#" />
               <CFEXIT>
          </CFIF>
     </CFIF>

    	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Submit Telephone Work Orders Display</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				SR Number &nbsp;= &nbsp;#GetServiceRequests.SERVICEREQUESTNUMBER# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Requestor &nbsp;= &nbsp; #GetServiceRequests.FULLNAME#<BR />
				Telephone Work Order Key &nbsp; = &nbsp; #GetTelephoneWOs.TNSWO_ID#<BR />
				Telephone Contact Phone: &nbsp;&nbsp;&nbsp;&nbsp;4-3500
				<CFCOOKIE name="TNSWO_ID" secure="NO" value="#GetTelephoneWOs.TNSWO_ID#">
			</TH>
		</TR>
          <TR>
			<TH align="center">
               	WO Type
				<CFIF FIND('NEW', #GetTelephoneWOs.WO_TYPE#, 1) NEQ 0>
					<CFSET FORM.WOType = 'NEW PHONE REQUEST'>
				<CFELSEIF FIND('MOVE', #GetTelephoneWOs.WO_TYPE#, 1) NEQ 0>
					<CFSET FORM.WOType = 'MOVE PHONE CONNECTION'>
				<CFELSE>
					<CFSET FORM.WOType = 'DISCONNECT PHONE SERVICE'>
				</CFIF>
				= #FORM.WOTYPE#
			</Th>
		</TR>
	</TABLE>
     
     <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES")>
		<CFSET PROGRAMNAME = "processtelephonewos.cfm?STAFFLOOP=YES">
     <CFELSEIF (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
          <CFSET PROGRAMNAME = "processtelephonewos.cfm?SRCALL=YES">
     <CFELSE>
          <CFSET PROGRAMNAME = "processtelephonewos.cfm">
      </CFIF>

	<TABLE width="100%" align="left" border="0">
		<TR>
			<TD align="LEFT" colspan="2">
               <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			<CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=SUBMIT" method="POST">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
               </CFIF>
			</TD>
		</TR>
	</TABLE>
<BR><BR><BR><BR><BR><BR>
     <DIV class="blkindent">					
	<TABLE border="1" cellpadding="2" cellspacing="0" bgcolor="##FFFFF6" summary="Layout table for service request form">
         <THEAD>
			<TR class="tabletitle">
				<TH align="left" colspan="4"> Telephone Service Request Form</TH>
			</TR>
		</THEAD>
		<TBODY>
<CFFORM name="TELEPHONEWOSUBMIT" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="post">
			<TR class="smalltext" valign="top">
				<TH align="left" colspan="4">
                    	<INPUT type="hidden" name="WO_Type" value="#FORM.WOType#" />
                    	<H4>*&nbsp;</H4>
                         Select a type of request you are making:  A, B or C: (option &quot;A&quot; requires selection of telephone style).
                    </TH>
			</TR>
               <TR class="smalltext" valign="top">
               	<TH align="left" ROWSPAN="3">&nbsp;&nbsp;&nbsp;&nbsp;Request Type: </TH>
				<TD align="left">
                    	<LABEL for="NewPhoneRadio">A. <CFINPUT type="radio" name="Type_of_Request" id="NewPhoneRadio" value="New_Telephone" checked tabindex="2">New telephone request </LABEL>
                    </TD>
				<TD align="left" colspan="2"><LABEL for="SelectPhoneType"></LABEL>Which type?
					<CFSELECT name="Select_Telephone_Type" id="SelectPhoneType" tabindex="3">
						<OPTION title="Select_Style" ALT="Select_Style">Select a style</OPTION>
						<OPTION selected title="Analog" ALT="Analog">Analog -> Only analog lines can support fax machines.</OPTION>
						<OPTION title="Digital" ALT="Digital">Digital -> Only digital sets can display name.</OPTION>
					</CFSELECT>
                         <BR>
                         <BR>
                        	If digital and you want a name displayed, enter first and last name to be displayed:
                      	<CFINPUT type="text" alt="enter name you want displayed on digital phone" name="Displayed_Name" id="Displayed_Name" size="40" tabindex="4">
				</TD>
               </TR>
			<TR class="smalltext" valign="top">
				<TD align="left" colspan="3">
                    	<LABEL for="MovePhoneRadio">B. <CFINPUT type="radio" name="Type_of_Request" value="Move_Telephone" id="MovePhoneRadio" tabindex="5">Move a telephone connection</LABEL>&nbsp;		
				</TD>
               </TR>
               <TR class="smalltext" valign="top">
                    <TD align="left" colspan="3">
                    	<LABEL for="DisconnectPhoneRadio">C. <CFINPUT type="radio" name="Type_of_Request" value="Disconnect_Telephone" id="DisconnectPhoneRadio" tabindex="6">Disconnect telephone service</LABEL>&nbsp;
                    </TD>                       
               </TR>     
               <TR class="smalltext" valign="top">
				<TH align="left">
                    	<H4>*&nbsp;</H4>
                    	<LABEL for="Description"><SPAN class="textemphasis">Please provide a brief description of the work needed:</SPAN></LABEL>
                    </TH>
				<TD align="left" colspan="3">
                    	<LABEL for="Description"><TEXTAREA name="Description" id="Description" cols="80" rows="10" tabindex="7">#GetTelephoneWOs.WORK_DESCRIPTION#</TEXTAREA></LABEL>
                    </TD>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="User_First_Name">User First Name:</LABEL>
                    </TH>
                    <TD align="left" colspan="3"><CFINPUT type="text" name="User_First_Name" id="User_First_Name" size="30" value="#GetTelephoneWOs.FIRSTNAME#" tabindex="8"></TD>
               </TR>
               <TR>
                    <TH align="left"><LABEL for="User_Middle_Name">&nbsp;&nbsp;&nbsp;&nbsp;User Middle Name:</LABEL></TH>
                    <TD align="left" colspan="3"><CFINPUT type="text" name="User_Middle_Name" id="User_Middle_Name" size="30" value="" tabindex="9"></TD>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="User_Last_Name">User Last Name:</LABEL>
                    </TH>
                    <TD align="left" colspan="3"><CFINPUT type="text" name="User_Last_Name" id="User_Last_Name" size="30" value="#GetTelephoneWOs.LASTNAME#" tabindex="10"></TD>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="User_Category" id="User_Category">User Category:</LABEL>
                    </TH>
                    <TD align="left"><CFINPUT type="radio" alt="user category faculty" name="User_Category" value="Faculty" id="Faculty" tabindex="11"> Faculty</TD>
                    <TD align="left"><CFINPUT type="radio" alt="user category staff" name="User_Category" value="Staff" id="Staff" checked tabindex="12">  Staff</TD>
                    <TD align="left"><CFINPUT type="radio" alt="user category student" name="User_Category" value="Student" id="Student" tabindex="13"> Student</TD>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="Department">Department:</LABEL>
                    </TH>
                    <TD align="left" colspan="3">
                         <CFINPUT type="text" name="Department" id="Department" value="Library and Information Access" size="30" tabindex="14" >
                    </TD>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="User_Email">User&rsquo;s E-mail Address::</LABEL>
                    </TH>
                    <TD align="left" colspan="3"><CFINPUT type="text" id="User_Email" name="User_Email" size="30" value="#GetTelephoneWOs.EMAIL#" tabindex="15"></TD>
               </TR>
			<TR class="smalltext" valign="top">
				<TH align="left" colspan="4">
                    	Please enter a telephone number for contacting the user, including the area code if necessary. If the number is a campus number, then enter the 5 digit extension.
                    </TH>
               </TR>
			<TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="User_Phone">User Phone Number:</LABEL>
                    </TH>
                    <TD align="left" colspan="3">
                    	<CFINPUT type="text" id="User_Phone" name="User_Phone" value="#GetTelephoneWOs.CAMPUSPHONE#" tabindex="16">
                    </TD>
               </TR>
			<TR>
                    <TH align="left">
                         &nbsp;&nbsp;&nbsp;&nbsp;If we have questions about your request,  <BR>
                         &nbsp;&nbsp;&nbsp;&nbsp;do you prefer we contact you by phone or  <BR>
                         &nbsp;&nbsp;&nbsp;&nbsp;e-mail?
                    </TH>
                    <TD align="left"> <LABEL for="EmailMeRadio">
                         <CFINPUT type="radio" name="Contact_By" value="Email" id="EmailMeRadio" checked tabindex="17"> E-mail</LABEL></TD>
                    <TD align="left" colspan="2">	<LABEL for="PhoneMeRadio">
                         <CFINPUT type="radio" name="Contact_By" value="Phone" id="PhoneMeRadio" tabindex="18"> Phone</LABEL>
                    </TD>
               </TR>
			<TR class="smalltext" valign="top">
				<TH align="left">
					<SPAN class="textemphasis">For new telephone connection,</SPAN>&nbsp;telephone should have the following dialing level:
                    </TH>
                    <TD align="left">
                 		<LABEL for="CampusOnlyRadio"><CFINPUT type="radio" name="Dialing" value="Campus_only" id="CampusOnlyRadio" checked tabindex="19"> &nbsp;&nbsp;Campus only</LABEL>&nbsp;<SPAN class="smallertext">(dialing level 1)</SPAN>
                    </TD>
                    <TD align="left">
					<LABEL for="CampusLocalRadio"><CFINPUT type="radio" name="Dialing" value="Campus_local" id="CampusLocalRadio" tabindex="20">&nbsp;&nbsp;Campus + local</LABEL>&nbsp;<SPAN class="smallertext">(dialing level 2)</SPAN>
                    </TD>
                    <TD align="left">
                    	<LABEL for="CampusCountyRadio"><CFINPUT type="radio" name="Dialing" value="Campus_county" id="CampusCountyRadio" tabindex="21">Campus + local + S.D. county</LABEL>&nbsp;<SPAN class="smallertext">(dialing level 3)</SPAN>
                    </TD>
			</TR>
			<TR class="smalltext" valign="top">
				<TH align="left">
                    	<SPAN class="textemphasis">For new telephone,</SPAN>&nbsp;I will need voice mail:
                    </TH>
                  	<TD align="left">
					<LABEL for="YesVMRadio"><CFINPUT type="radio" name="Voice_Mail_Need" id="YesVMRadio" value="Yes_Voice_Mail" tabindex="22">Yes</LABEL>
                    </TD>
                    <TD align="left" colspan="2">
					<LABEL for="NoVMRadio"><CFINPUT type="radio" name="Voice_Mail_Need" value="No_Voice_Mail" id="NoVMRadio" checked tabindex="23">No</LABEL>
                    </TD>
			</TR>
			<TR class="smalltext" valign="top">
				<TH align="left">
					<SPAN class="textemphasis">For new telephone connection,</SPAN>&nbsp;telephone should have the following:
				</TH>
                    <TD align="left">
                  		<LABEL for="ListNumRadio"><CFINPUT type="radio" name="Listing_Type" value="Listed_number" id="ListNumRadio" tabindex="24">Listed number</LABEL>
				</TD>
                    <TD align="left" colspan="2">
                  		<LABEL for="UnlistNumRadio"><CFINPUT type="radio" name="Listing_Type" value="Unlisted_number" id="UnlistNumRadio" checked tabindex="25">Unlisted number </LABEL>
				</TD>
			</TR>
			<TR class="smalltext" valign="top">
				<TH align="left" colspan="4">
					<SPAN class="textemphasis">Note: </SPAN>1) an unlisted number will not be given to the public. It is used for emergencies only; 2) a listed number will be available to the public in both published and online versions of the SDSU telephone directory.
				</TH>
			</TR>
			<TR class="smalltext" valign="top">
				<TH align="left" colspan="4">
                    	Please enter the jack number associated with this connection. The format for this number is 9.9.999
                    </TH>
               </TR>
			<TR>
                    <TH align="left">
                  		<H4>*&nbsp;</H4>
                         <LABEL for="Jack_Curr">Current Jack Number:</LABEL>
                    </TH>
                    <TD align="left" colspan="3">
                         <CFINPUT type="text" id="Jack_Curr" name="Jack_Curr" value="#GetTelephoneWOs.PHONE_CURRENT_JACKNUMBER#" size="30" tabindex="26">
                    </TD>
			</TR>
			<TR class="smalltext" valign="top">
				<TH align="left" colspan="4">
					<SPAN class="textemphasis">For telephone adds, moves, or changes,</SPAN> enter the new jack number.
                    </TH>
               </TR>
			<TR>
                    <TH align="left">
					<H4>*&nbsp;</H4>
                         <LABEL for="Jack_New">New Jack Number:</LABEL>
                    </TH>
                    <TD align="left" colspan="3">
                         <CFINPUT type="text" id="Jack_New" name="Jack_New" size="30" value="#GetTelephoneWOs.PHONE_NEW_JACKNUMBER#" tabindex="27">
                    </TD>
 			</TR>
			<TR class="smalltext" valign="top">
				<TH align="left" colspan="4">
                    	Please enter the building and room number where the user is presently located.
                    </TH>
               </TR>
			<TR>
                    <TH align="left">
                  		<H4>*&nbsp;</H4>
                         <LABEL for="Building_Room_Curr">Bldg/Rm:</LABEL>
                    </TH>
                    <TD align="left" colspan="3">
                    	<CFINPUT type="text" id="Building_Room_Curr" name="Building_Room_Curr" value="N/A" size="30" tabindex="28">
                    </TD>
			</TR>
			<TR class="smalltext" valign="top">
				<TH align="left" colspan="4">
                    	<SPAN class="textemphasis">For telephone adds, moves, or changes,</SPAN> please enter the new building and room number location.
                    </TH>
               </TR>
			<TR>
                    <TH align="left">
                  		<H4>*&nbsp;</H4>
                         <LABEL for="Building_Room_New">New Bldg/Rm:</LABEL>
                    </TH>
                    <TD align="left" colspan="3">
                    <CFIF GetTelephoneWOs.NEW_LOCATION EQ 0>
					<CFSET FORM.Building_Room_New = "N/A">
                    <CFELSE>
                         <CFSET FORM.Building_Room_New = "#GetTelephoneWOs.JACKROOM#">
                    </CFIF>
                         <CFINPUT type="text" id="Building_Room_New" name="Building_Room_New"  value="#FORM.Building_Room_New#" size="30" tabindex="29">
                    </TD>
			</TR>
               <TR>
                    <TH align="left" colspan="5">
                         <EM>Charge Account Information:</EM><BR>
                         Please enter the name of the account administrator for the account.&nbsp;&nbsp;
                         We will clear all charges with this person prior to processing chargeback requests.&nbsp;&nbsp; 
                         Disregard this field for state-owned equipment.<BR>
                    </TH>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="Acct_FName">Acct. Admin. First Name </LABEL>
                    </TH>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Acct_FName" name="Acct_FName" size="30" value="MARK" tabindex="30" ></TD>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="Acct_LName">Acct. Admin. Last Name</LABEL>
                    </TH>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Acct_LName" name="Acct_LName" size="30" value="FIGUEROA"  tabindex="31"></TD>
               </TR>
               <TR>
                    <TH align="left" colspan="5">
                         Enter your account number using one of the following formats:<BR>
                         &nbsp;&nbsp;1.&nbsp;&nbsp;SDSU Oracle accounts: 99999.999.99999.9999.9999.9999.0000<BR>
                         &nbsp;&nbsp;2.&nbsp;&nbsp;[Oracle accounts are 35 characters long (with dots)]<BR>
                         &nbsp;&nbsp;3.&nbsp;&nbsp;Foundation accounts: 999999 99999<BR>
                         &nbsp;&nbsp;4.&nbsp;&nbsp;Associated Students accounts: 9-99-999-9999
                    </TH>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="Acct_Num">Account Number:</LABEL>
                    </TH>
                    <CFSET FORM.ACCT_NUMBER = '#GetTelephoneWOs.ACCOUNTNUMBER1#' & '#GetTelephoneWOs.ACCOUNTNUMBER2#' & '#GetTelephoneWOs.ACCOUNTNUMBER3#'>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Acct_Num" name="Acct_Num" size="45" value="#FORM.ACCT_NUMBER#"  tabindex="32"></TD>
               </TR>
               <TR>
                    <TH align="left" colspan="5">Please enter the campus phone number of the signatory given above. &nbsp;&nbsp;Disregard this field for state-owned equipment.</TH>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="Acct_Phone">Acct. Admin. Phone:</LABEL>
                    </TH>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Acct_Phone" name="Acct_Phone" size="30" value="42945" tabindex="33" >&nbsp;Format: 49999</TD>
               </TR>
               <TR>
                    <TH align="left" colspan="5"><SPAN class="textemphasis">
                         Primary Contact Information:</SPAN><BR>
                         You may specify a primary contact.&nbsp;&nbsp; 
                         If you choose one, please notify them that they will be called upon to assist us.&nbsp;&nbsp;
                         Please choose someone in the proximity of the equipment that needs service;&nbsp;&nbsp;
                         someone who can give us key access to the room.&nbsp;&nbsp;
                         Providing a contact will help to speed the completion of your work request.
                   </TH>
               </TR>
               <TR>
                    <TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Contact_FName">Contact First Name:</LABEL></TH>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Contact_FName" name="Contact_FName" size="30" value="#GetTelephoneWOs.FIRSTNAME#" tabindex="34"  ></TD>
               </TR>
               <TR>
                    <TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Contact_LName">Contact Last Name:</LABEL></TH>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Contact_LName" name="Contact_LName" size="30" value="#GetTelephoneWOs.LASTNAME#" tabindex="35" ></TD>
               </TR>
               <TR>
                    <TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Contact_BldgRm">Contact Bldg/Rm:</LABEL></TH>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Contact_BldgRm" name="Contact_BldgRm" size="30" value="#GetTelephoneWOs.STAFFROOM#" tabindex="36"></TD>
               </TR>
               <TR>
                    <TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Contact_Phone">Contact Phone:</LABEL></TH>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Contact_Phone" name="Contact_Phone" size="30" value="#GetTelephoneWOs.CAMPUSPHONE#" tabindex="37" ></TD>
               </TR>
               <TR>
                    <TH align="left">
                         <H4>*&nbsp;</H4>
                         <LABEL for="Contact_Email">Contact E-mail:</LABEL>
                    </TH>
                    <TD align="left" colspan="4"><CFINPUT type="text" id="Contact_Email" name="Contact_Email" size="30" value="#GetTelephoneWOs.EMAIL#" tabindex="38" ></TD>
               </TR>
               <TR>
                    <TD align="left" colspan="5" align="center">  
                         <INPUT type="hidden" name="PROCESSTELEPHONEWOS" value="SUBMIT" />   
                         <INPUT type="image" src="/images/buttonSubmitPhoneRequest.jpg" value="SUBMIT PHONE REQUEST" alt="Submit Phone Request" tabindex="39">
                    </TD> 
               </TR>
</CFFORM>
          </TBODY>
     </TABLE>
     </DIV>
	<BR><BR>		
     <TABLE width="100%" align="left" border="0">
          <TR>
               <TD align="LEFT" colspan="5">
               	<BR><BR>
               <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
<CFFORM action="/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE&SRID=#val(Cookie.SRID)#&LOOKUPWO=FOUND&STAFFLOOP=YES" method="POST">
                    <INPUT type="image" src="/images/buttonModPhoneRequest.jpg" value="MODIFY PHONE REQUEST" alt="Modify Phone Request" tabindex="40" />
</CFFORM>
               <CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE&SRID=#val(Cookie.SRID)#&LOOKUPWO=FOUND" method="POST">
                    <INPUT type="image" src="/images/buttonModPhoneRequest.jpg" value="MODIFY PHONE REQUEST" alt="Modify Phone Request" tabindex="40" />
</CFFORM>
			</CFIF>
               </TD>
          </TR>
          <TR>
               <TD align="LEFT" colspan="5">
               <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="41" /><BR />
			<CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=SUBMIT" method="POST">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="41" /><BR />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
               </CFIF>
               </TD>
          </TR>
			
		<TR>
			<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>