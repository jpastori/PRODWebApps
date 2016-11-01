<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: tnsworkorderssubmit.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/08/2012 --->
<!--- Date in Production: 08/08/2012 --->
<!--- Module: Submit TNS Work Orders--->
<!-- Last modified by John R. Pastori on 09/04/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm">
<CFSET CONTENT_UPDATED = "September 04, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Submit TNS Work Orders</TITLE>
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
*********************************************************************************************
* The following code is the Look Up Process for Display of TNS Work Orders to be Submitted. *
*********************************************************************************************
 --->

<CFIF NOT IsDefined("URL.LOOKUPWO")>

	<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	TNSWO_ID, SRID, WO_TYPE, WO_STATUS, STAFFID, CURRENT_JACKNUMBER, NEW_JACKNUMBER, HW_INVENTORYID, 
				ACCOUNTNUMBER1, ACCOUNTNUMBER2, ACCOUNTNUMBER3, WORK_DESCRIPTION, JUSTIFICATION_DESCRIPTION, 
                    OTHER_DESCRIPTION, WO_DUEDATE, WO_NUMBER
		FROM		TNSWORKORDERS
		WHERE	TNSWO_ID > 0 AND
          		NOT WO_TYPE LIKE ('%PHONE%')
		ORDER BY	WO_TYPE
	</CFQUERY>

	<CFIF LookupTNSWorkOrders.RecordCount EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert ("There are NO TNS Work Orders on file.");
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
				SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#)) AND
                    (SR.REQUESTERID = CUST.CUSTOMERID AND
                    (SR.SRCOMPLETED = 'NO' OR
                     SR.SRCOMPLETED = ' Completed?') AND
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
				SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#)) AND
                    (SR.REQUESTERID = CUST.CUSTOMERID AND
                    (SR.SRCOMPLETED = 'NO' OR
                     SR.SRCOMPLETED = ' Completed?') AND
               SR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) 
          ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
     </CFQUERY>

     <TABLE width="100%" align="center" border="3">
          <TR align="center">
               <TD align="center"><H1>Submit TNS Work Orders Lookup</H1></TD>
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=#URL.PROCESS#&LOOKUPWO=FOUND" method="POST">
          <TR>
               <TH align="left" width="30%"><H4><LABEL for="SRID1">*Requester/SR For Current Fiscal Year & CFY+1:</LABEL></H4></TH>
               <TD align="left" width="70%">
                    <CFSELECT name="SRID1" id="SRID1" size="1" required="No" tabindex="3">
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
                    <CFSELECT name="SRID2" id="SRID2" size="1" query="LookupServiceRequestsPrevFYs" value="SRID" display="LOOKUPKEY" required="No" tabindex="4"></CFSELECT>
               </TD>
          </TR>
          <TR>
               <TD align="left" width="33%">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
               <TD align="left" width="33%">
                    <INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="5" />
               </TD>
          </TR>
</CFFORM>
          <TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
               <TD align="left" colspan="2">
                    <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
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
***************************************************************
* The following code displays TNS Work Order to be Submitted. *
***************************************************************
 --->

	<CFIF IsDefined('FORM.SRID1') AND IsDefined('FORM.SRID2')>
          <CFIF FORM.SRID1 GT 0>
               <CFSET FORM.SRID = #FORM.SRID1#>
          <CFELSE>
               <CFSET FORM.SRID = #FORM.SRID2#>
          </CFIF>
     </CFIF>

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

	<CFQUERY name="GetTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
          SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.EBA_111, TNSWO.STAFFID, 
                    CUST.FIRSTNAME, CUST.LASTNAME, CUST.FULLNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.LOCATIONID, LOC.ROOMNUMBER,
                    TNSWO.NEW_LOCATION, TNSWO.CURRENT_JACKNUMBER, TNSWO.NEW_JACKNUMBER,  TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION,
                    TNSWO.ACCOUNTNUMBER1, TNSWO.ACCOUNTNUMBER2, TNSWO.ACCOUNTNUMBER3, TNSWO.JUSTIFICATION_DESCRIPTION,
                    TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER
          FROM		TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC
          WHERE	TNSWO.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    TNSWO.STAFFID = CUST.CUSTOMERID AND
                    CUST.LOCATIONID = LOC.LOCATIONID AND
          		NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
          ORDER BY	TNSWO.WO_TYPE
     </CFQUERY>

	<CFIF GetTNSWorkOrders.RecordCount EQ 0>
          <SCRIPT language="JavaScript">
               <!-- 
                    alert ("This SR is NOT Associated with a TNS Work Order.");
               -->
          </SCRIPT>
          <CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ 'YES') OR (IsDefined('client.STAFFLOOP') AND #client.STAFFLOOP# EQ 'YES'))>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=ADD&STAFFLOOP=YES&SRID=#FORM.SRID#" />
               <CFEXIT>
          <CFELSE>
               <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=ADD&SRID=#FORM.SRID#" />
               <CFEXIT>
          </CFIF>
     </CFIF>

	<CFQUERY name="CurrentJackNumbers" datasource="#application.type#FACILITIES">
     	SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.LOCATIONNAME, WJ.WALLDIRID, WD.WALLDIRNAME, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.CUSTOMERID, CUST.FULLNAME,
				WJ.CLOSET || '.' || WJ.JACKNUMBER || '.' || WJ.PORTLETTER AS KEYFINDER
		FROM		WALLJACKS WJ, LOCATIONS LOC, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WJ.WALLJACKID = <CFQUERYPARAM value="#GetTNSWorkOrders.CURRENT_JACKNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
          		WJ.LOCATIONID = LOC.LOCATIONID AND
				WJ.WALLDIRID = WD.WALLDIRID AND
				WJ.CUSTOMERID = CUST.CUSTOMERID
		ORDER BY	LOC.ROOMNUMBER, WD.WALLDIRNAME, WJ.JACKNUMBER, WJ.PORTLETTER
	</CFQUERY>

	<CFQUERY name="NewJackNumbers" datasource="#application.type#FACILITIES">
     	SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.ROOMNUMBER, WJ.WALLDIRID, WD.WALLDIRNAME, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.CUSTOMERID, CUST.FULLNAME,
				WJ.CLOSET || '.' || WJ.JACKNUMBER || '.' || WJ.PORTLETTER AS KEYFINDER
		FROM		WALLJACKS WJ, LOCATIONS LOC, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	WJ.WALLJACKID = <CFQUERYPARAM value="#GetTNSWorkOrders.NEW_JACKNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
          		WJ.LOCATIONID = LOC.LOCATIONID AND
				WJ.WALLDIRID = WD.WALLDIRID AND
				WJ.CUSTOMERID = CUST.CUSTOMERID
		ORDER BY	LOC.ROOMNUMBER, WD.WALLDIRNAME, WJ.JACKNUMBER, WJ.PORTLETTER
	</CFQUERY>

	<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE,
				HI.OWNINGORGID, HI.MODELNAMEID, MODELNAMELIST.MODELNAME, HI.MODELNUMBERID, MODELNUMBERLIST.MODELNUMBER,
				HI.CUSTOMERID, CUST.FULLNAME, LOC.ROOMNUMBER, HW.WARRANTYEXPIRATIONDATE AS WARDATE, HI.IPADDRESS, HI.MACADDRESS,
				HI.BARCODENUMBER || '-' || CUST.FULLNAME ||'-' || EQT.EQUIPMENTTYPE || '-' || MODELNAMELIST.MODELNAME  AS LOOKUPBARCODE
		FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST, MODELNUMBERLIST, LIBSHAREDDATAMGR.CUSTOMERS CUST,
				FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
		WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetTNSWorkOrders.HW_INVENTORYID#" cfsqltype="CF_SQL_VARCHAR"> AND
				HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND
				HI.MODELNAMEID = MODELNAMELIST.MODELNAMEID AND
				HI.MODELNUMBERID = MODELNUMBERLIST.MODELNUMBERID AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				HI.BARCODENUMBER = HW.BARCODENUMBER
		ORDER BY	HI.BARCODENUMBER, CUST.FULLNAME, EQT.EQUIPMENTTYPE, MODELNAMELIST.MODELNAME
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Submit TNS Work Orders Display</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				SR Number &nbsp;= &nbsp;#GetServiceRequests.SERVICEREQUESTNUMBER# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Requestor &nbsp;= &nbsp; #GetServiceRequests.FULLNAME#<BR />
				TNS Work Order Key &nbsp; = &nbsp; #GetTNSWorkOrders.TNSWO_ID#<BR />
				TNS Contact Phone: &nbsp;&nbsp;&nbsp;&nbsp;4-3500
				<CFCOOKIE name="TNSWO_ID" secure="NO" value="#GetTNSWorkOrders.TNSWO_ID#">
			</TH>
		</TR>
          <TR>
			<TH align="center">
               	WO Type
				<CFIF #GetTNSWorkOrders.WO_TYPE# EQ 'NEW'>
					<CFSET FORM.WOType = 'NEW NETWORK CONNECTION'>
				<CFELSEIF #GetTNSWorkOrders.WO_TYPE# EQ 'MOVE'>
					<CFSET FORM.WOType = 'MOVE NETWORK CONNECTION'>
				<CFELSE>
					<CFSET FORM.WOType = 'REPORT NETWORK PROBLEM'>
				</CFIF>
				= #FORM.WOTYPE#
			</Th>
		</TR>
	</TABLE>
     
      <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES")>
		<CFSET PROGRAMNAME = "processtnsworkorders.cfm?STAFFLOOP=YES">
     <CFELSEIF (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
          <CFSET PROGRAMNAME = "processtnsworkorders.cfm?SRCALL=YES">
     <CFELSE>
          <CFSET PROGRAMNAME = "processtnsworkorders.cfm">
     </CFIF>

	<TABLE width="100%" align="left" border="0">
		<TR>
			<TD align="LEFT" colspan="2">
				<CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    <CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=SUBMIT" method="POST">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
                    </CFIF>
			</TD>
		</TR>
	</TABLE>
<BR><BR>
	<TABLE width="100%" align="left" border="0">
		<TR >
			<TD class="black-divider" bgcolor="##d2c694" width="40" height="90"><A name="top"></A>&nbsp;</TD>
			<TD align="LEFT">
				<TABLE border="1" cellpadding="2" cellspacing="0" bgcolor="##FFFFF6" summary="Network service request form, layout table">
					<THEAD>
						<TR class="tabletitle">
							<TD colspan="5">NETWORK SERVICE REQUEST</TD>
						</TR>
                         </THEAD>
<CFFORM name="TNSWORKORDERSUBMIT" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="post">
					<TBODY>
						<TR>
							<TH align="left">
                                   	<INPUT type="hidden" name="WO_Type" value="#FORM.WOType#" />
                                   	<H4>*&nbsp;</H4>
								<LABEL for="User_First_Name">User First Name:</LABEL>
                                   </TH>
							<TD align="left" colspan="4"><CFINPUT type="text" name="User_First_Name" id="User_First_Name" size="30" value="#GetTNSWorkOrders.FIRSTNAME#" tabindex="2"></TD>
						</TR>
						<TR>
							<TH align="left"><LABEL for="User_Middle_Name">&nbsp;&nbsp;&nbsp;&nbsp;User Middle Name:</LABEL></TH>
							<TD align="left" colspan="4"><CFINPUT type="text" name="User_Middle_Name" id="User_Middle_Name" size="30" value="" tabindex="3"></TD>
						</TR>
						<TR>
							<TH align="left">
                                   	<H4>*&nbsp;</H4>
   								<LABEL for="User_Last_Name">User Last Name:</LABEL>
                                   </TH>
							<TD align="left" colspan="4"><CFINPUT type="text" name="User_Last_Name" id="User_Last_Name" size="30" value="#GetTNSWorkOrders.LASTNAME#" tabindex="4"></TD>
						</TR>
						<TR>
							<TH align="left">
                                   	<H4>*&nbsp;</H4>
    								<LABEL for="User_Category" id="User_Category">User Category:</LABEL>
                                   </TH>
							<TD align="left"><CFINPUT type="radio" alt="user category faculty" name="User_Category" value="Faculty" id="Faculty" tabindex="5"> Faculty</TD>
							<TD align="left"><CFINPUT type="radio" alt="user category staff" name="User_Category" value="Staff" id="Staff" checked tabindex="6">  Staff</TD>
							<TD align="left"><CFINPUT type="radio" alt="user category student" name="User_Category" value="Student" id="Student" tabindex="7"> Student</TD>
          					<TD align="left">&nbsp;</TD>
						</TR>
						<TR>
							<TH align="left">
                                   	<H4>*&nbsp;</H4>
    								<LABEL for="Department">Department:</LABEL>
                                   </TH>
							<TD align="left colspan="4"">
     							<CFINPUT type="text" name="Department" id="Department" value="Library and Information Access" size="30" tabindex="8" >
   							</TD>
						</TR>
						<TR>
							<TH align="left" colspan="4">Please enter the building and room number where the user is located.</TH>
                              </TR>
						<TR>
							<TH align="left">
                                   	<H4>*&nbsp;</H4>
    								<LABEL for="User_BldgRm">User Location Bldg/Rm:</LABEL>
                                   </TH>
							<TD align="left" colspan="4"><CFINPUT type="text" id="User_BldgRm" name="User_BldgRm" size="30" value="#GetTNSWorkOrders.ROOMNUMBER#" tabindex="9"></TD>
						</TR>
                              <TR>
                              	<TH align="left">
                                   	<H4>*&nbsp;</H4>
                                   	<LABEL for="Work_involves_EBA111_Data_Center">Work involves EBA-111 Data Center:</LABEL>
                                   </TH>
						    <TD align="left" colspan="2">
								<CFINPUT type="radio" alt="data center involved yes" name="Work_Involves_EBA111_Data_Center" 
                                        		value="Yes" id="Yes" tabindex="10"> <LABEL for="Yes">Yes</LABEL>
                                   </TD>
							<TD align="left" colspan="2">
                                   	<CFINPUT name="Work_Involves_EBA111_Data_Center" type="radio" id="No" value="No" checked alt="data center involved no" tabindex="11"><LABEL for="No">No</LABEL>
                                	</TD>
                              </TR>
						<TR>
							<TH align="left">
                                   	<H4>*&nbsp;</H4>
                                   	<LABEL for="Contact_Email_Address">Contact E-mail Address:</LABEL>
                                   </TH>
							<TD align="left" colspan="4"><CFINPUT type="text" id="Contact_Email_Address" name="Contact_Email_Address" size="30" value="#GetTNSWorkOrders.EMAIL#" tabindex="12"></TD>
						</TR>
						<TR>
							<TH align="left" colspan="5">
                                   	Please enter a telephone number for contacting the user, including the area code if necessary. If the number is a campus number, then enter the 5 digit extension.
                                   </TH>
                              </TR>
						<TR>
							<TH align="left">
                                   	<H4>*&nbsp;</H4>
    								<LABEL for="User_Phone_Number">User Phone Number:</LABEL>
                                   </TH>
							<TD align="left" colspan="4"><CFINPUT type="text" id="User_Phone_Number" name="User_Phone_Number" value="#GetTNSWorkOrders.CAMPUSPHONE#" tabindex="13"></TD>
						</TR>
						<TR>
							<TH align="left">
                                   	&nbsp;&nbsp;&nbsp;&nbsp;If we have questions about your request,  <BR>
                                   	&nbsp;&nbsp;&nbsp;&nbsp;do you prefer we contact you by phone or  <BR>
                                   	&nbsp;&nbsp;&nbsp;&nbsp;e-mail?
                                   </TH>
							<TD align="left"> <LABEL for="Email">
  								<CFINPUT type="radio" name="Contact_User_By" value="Email" id="Email" checked tabindex="14"> E-mail</LABEL></TD>
							<TD align="left" colspan="3">	<LABEL for="Phone">
  								<CFINPUT type="radio" name="Contact_User_By" value="Phone" id="Phone" tabindex="15"> Phone</LABEL>
                             	 	</TD>
						</TR>
						<TR>
							<TH align="left" VALIGN="TOP">&nbsp;&nbsp;&nbsp;&nbsp;<EM>Which type of connection are you making?</EM></TH>
							<TD align="left" VALIGN="TOP"> <LABEL for="New_connection">
                                   <CFIF GetTNSWorkOrders.WO_TYPE EQ "NEW">
  								<CFINPUT type="radio" name="WO_Type" value="New_connection" id="New_connection" checked tabindex="16"> New network connection</LABEL>
                                   <CFELSE>
                                        <CFINPUT type="radio" name="WO_Type" value="New_connection" id="New_connection" tabindex="16"> New network connection</LABEL>
                                   </CFIF>
                                   </TD>
							<TD align="left" VALIGN="TOP"> <LABEL for="Move_connection">
                                   <CFIF GetTNSWorkOrders.WO_TYPE EQ "MOVE">
                                   	<CFINPUT type="radio" name="WO_Type" value="Move_connection" id="Move_connection" checked tabindex="17"> Move network connection</LABEL>
                                   <CFELSE>
  								<CFINPUT type="radio" name="WO_Type" value="Move_connection" id="Move_connection" tabindex="17"> Move network connection</LABEL>
                                   </CFIF>
                                   </TD>
							<TD align="left" VALIGN="TOP"> <LABEL for="Static_IP">
         							<CFINPUT type="radio" name="WO_Type" value="Static_IP" id="Static_IP" tabindex="18"> Request static <ACRONYM title="Internet Protocol">IP</ACRONYM> address</LABEL>
                                   </TD>
							<TD align="left" VALIGN="TOP"> <LABEL for="Problem_connection">
                                   <CFIF GetTNSWorkOrders.WO_TYPE EQ "REPORT">
                                   	<CFINPUT type="radio" name="WO_Type" value="Problem_connection" id="Problem_connection" checked tabindex="19"> Report network problem <BR>
                                   <CFELSE>
  								<CFINPUT type="radio" name="WO_Type" value="Problem_connection" id="Problem_connection" tabindex="19"> Report network problem <BR>
                                        * <STRONG> Must include IP and/or MAC address for each connection. </STRONG></LABEL>
                                   </CFIF>
                                   </TD>
						</TR>
						<TR>
							<TH align="left" colspan="5">
                                   	<EM>If new, move, or problem network connection</EM>, please enter the jack number associated with this connection. 
                                        The format for this number is 9.9.999
                                   </TH>
                              </TR>
						<TR>
							<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Jack_Curr">Current Jack Number:</LABEL></TH>
							<TD align="left" colspan="4"><CFINPUT type="text" id="Jack_Curr" name="Jack_Curr" size="50" value="#CurrentJackNumbers.KEYFINDER#" tabindex="20"></TD>
						</TR>
						<TR>
							<TH align="left" colspan="5">
                                   	<EM>If move network connection</EM>,	please enter the jack number associated with the new location.
                                   </TH>
                              </TR>
						<TR>
							<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Jack_New">New Jack Number:</LABEL></TH>
							<TD align="left" colspan="4">
                                   <CFIF GetTNSWorkOrders.NEW_JACKNUMBER EQ 0>
								<CFSET FORM.Jack_New = "N/A">
                                   <CFELSE>
                                   	<CFSET FORM.Jack_New = "#NewJackNumbers.KEYFINDER#">
                                   </CFIF>
                                   	<CFINPUT type="text" id="Jack_New" name="Jack_New" size="50" value="#FORM.Jack_New#" tabindex="21">
                                   </TD>
						</TR>
						<TR>
							<TH align="left" colspan="5">
                                   	<EM>If move network connection</EM>, please enter the new location 
                                   	(i.e., location to which the equipment will be moved, not the  &ldquo;User Location&rdquo; you entered above).
                                   </TH>
                              </TR>
						<TR>
							<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="New_BldgRm">New Location Bldg/Rm:</LABEL></TH>
							<TD align="left" colspan="4">
                                   <CFIF GetTNSWorkOrders.NEW_JACKNUMBER EQ 0>
								<CFSET FORM.New_BldgRm = "N/A">
                                   <CFELSE>
                                   	<CFSET FORM.New_BldgRm = "#NewJackNumbers.ROOMNUMBER#">
                                   </CFIF>
                                   	<CFINPUT type="text" id="New_BldgRm" name="New_BldgRm" size="50" value="#FORM.New_BldgRm#" tabindex="22">
                                   </TD>
						</TR>
      					<TR>
							<TH align="left" colspan="5">
  								<EM><STRONG>If IP request,</STRONG></EM> to which subnet should  the IP address belong (e.g. for the IP address 146.244.132.0, the subnet is 132)?&nbsp;&nbsp;&nbsp;&nbsp;
                                        What is the subnet mask (e.g. 255.255.255.0)? Contact your department's Technical Contact if you do not have this information. 
                                   </TH>
                              </TR>
      					<TR>
          					<TH align="left" VALIGN="TOP"> 
                                   	&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="IP_Request">IP Address:&nbsp;(e.g.:&nbsp;146.244.132.0)</LABEL>   
                                   </TH>
              					<TD align="left" VALIGN="TOP">
                                       	<CFINPUT type="text" id="IP_Request" alt="what is IP address for this request?" name="IP_Request" size="30" value="" tabindex="23"><BR>
          						<BR>
                                   </TD>
        						<TH align="left" VALIGN="TOP"><LABEL for="Subnet_Mask">Subnet&nbsp;Mask: <BR>(e.g.: 255.255.255.0)</LABEL></TH>
       						<TD align="left" VALIGN="TOP">
                                   	<CFINPUT type="text" id="Subnet_Mask" alt="what subnet mask address should this IP address belong to?" name="Subnet_Mask" size="30" value="255.255.255.0" tabindex="24">
                                   </TD>
                              </TR>
      					<TR>
                                   <TH align="left" VALIGN="TOP">
           						&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Justify_static_IP" id="Justify_static_IP">Justification: (e.g. We need a static <BR>
                                        &nbsp;&nbsp;&nbsp;&nbsp; IP address for a printer that will be <BR>
                                        &nbsp;&nbsp;&nbsp;&nbsp; part of the Library and Information <BR>
                                        &nbsp;&nbsp;&nbsp;&nbsp; Access network.)</LABEL></TH>
       						<TD align="left" VALIGN="TOP" colspan="4">
           						<TEXTAREA name="Justify_static_IP" cols="80" rows="10" tabindex="25">#GetTNSWorkOrders.JUSTIFICATION_DESCRIPTION# </TEXTAREA>
                                   </TD> 
						</TR>
						<TR>
							<TH align="left" colspan="5">
                                   	<H4>*&nbsp;</H4>
  								<LABEL for="IP_MAC_Address" id="IP_MAC_Address">For network requests, please include both the IP and MAC addresses.</LABEL>
  							</TH>
                             	</TR>
						<TR>
          					<TH align="left">
  								&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="IP_Address">IP Address:</LABEL>
  							</TH>
                                   <TD align="left">
                                    	<CFINPUT type="text" name="IP_Address" SIZE="30" id="IP_Address" value="#GetHardware.IPADDRESS#" tabindex="26">
							<TH align="left">
  								&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="MAC_Address">MAC Address:</LABEL>
                                   </TH>
                                   <TD align="left" colspan="2">
                                   	<CFINPUT type="text" name="MAC_Address" SIZE="30" id="MAC_Address" value="#GetHardware.MACADDRESS#" tabindex="27">
                                   </TD>
						</TR>
						<TR>
							<TH align="left" VALIGN="TOP">
                                   	<H4>*&nbsp;</H4> 
                                        <LABEL for="Problem" id="Problem">Please provide a brief description of the <BR>
                                        &nbsp;&nbsp;&nbsp;&nbsp; work or problem:</LABEL>
                                   </TH>
							<TD align="left" colspan="4" TABINDEX="1"><TEXTAREA name="Problem" id="Problem" cols="80" rows="10" tabindex="28">#GetTNSWorkOrders.WORK_DESCRIPTION#</TEXTAREA></TD>
						</TR>
						<TR>
							<TH align="left" colspan="5">
                                   	<STRONG><EM>Equipment Information:</EM></STRONG>  The following information refers to the equipment for which this service is being requested.
                                   </TH>
						</TR>
						<TR>
							<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Equip_MakeModel">Equip. Make and Model:</LABEL></TH>
                                   <CFSET FORM.Equip_Make_And_Model = '#GetHardware.EQUIPMENTTYPE#' & ' ' & '#GetHardware.MODELNAME#' & ' ' & '#GetHardware.MODELNUMBER#'>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Equip_MakeModel" name="Equip_MakeModel" size="30" value="#FORM.Equip_Make_And_Model#" tabindex="29"></TD>
                              </TR>
                              <TR>
                              	<TH align="left" colspan="5">Please enter the building and room number of the equipment if other than &ldquo;User Location&rdquo; specified above.</TH>
                              </TR>
						<TR>
                              	<TH align="left" >&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Equip_BldgRm">Equip. Location Bldg/Rm:</LABEL></TH>
                              	<TD colspan="4"><CFINPUT type="text" id="Equip_BldgRm" name="Equip_BldgRm" size="30" value="#GetHardware.ROOMNUMBER#" tabindex="30"></TD>
                              </TR>
                              <TR>
                              	<TH align="left" colspan="5">
                                   	Please enter the property ID number. &nbsp;&nbsp;The format for state ID numbers is &ldquo;E999999.&rdquo; or &ldquo;C999999&rdquo;. 
                                   	&nbsp;&nbsp;Foundation ID numbers have the format &ldquo;999999&rdquo;. &nbsp;&nbsp;AS numbers have the format &ldquo;9999.&rdquo; &nbsp;&nbsp;Note that leading zeros are significant.
                               	</TH>
                              </TR>
                              <TR>
                              	<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Equip_ID">Equip. Property ID:</LABEL></TH>
                             		<TD align="left" colspan="4"><CFINPUT type="text" id="Equip_ID" name="Equip_ID" size="30" value="#GetHardware.STATEFOUNDNUMBER#" tabindex="31"></TD>
                              </TR>
                              <TR>
                              	<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp; Equip. Tag Type:</TH>
                              	<TD align="left"><LABEL for="SDSU">
                                		<CFINPUT type="radio" name="Equip_Tag" value="SDSU" id="SDSU" checked tabindex="32"> SDSU</LABEL>
                               	</TD>
                              	<TD align="left"><LABEL for="Foundation">
                                		<CFINPUT type="radio" name="Equip_Tag" value="Foundation" id="Foundation" tabindex="33"> Foundation</LABEL>
                                   </TD>
                              	<TD align="left" COLSPAN="2"><LABEL for="Assoc_Students">
                                		<CFINPUT type="radio" name="Equip_Tag" value="Assoc_Students" id="Assoc_Students" tabindex="34"> Assoc. Students</LABEL>
                                   </TD>
                              </TR>
                              <TR>
                              	<TH align="left">
                                   	&nbsp;&nbsp;&nbsp;&nbsp; Please enter the serial number <BR>
                                        &nbsp;&nbsp;&nbsp;&nbsp; of your machine.
                              	<LABEL for="Equip_SNum">Equip. Serial Number:</LABEL></TH>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Equip_SNum" name="Equip_SNum" size="30" value="#GetHardware.SERIALNUMBER#" tabindex="35"></TD>
                              </TR>
                              <TR>
                              	<TH align="left"><SPAN class="textemphasis">
                                   	&nbsp;&nbsp;&nbsp;&nbsp; What type of connection do you want?</SPAN><BR>
                                		&nbsp;&nbsp;&nbsp;&nbsp; Connect To:
                                   </TH>
                              	<TD align="left"><LABEL for="Ethernet">
                                		<CFINPUT type="radio" alt="option to select ethernet connection" name="Connect_Type" value="Ethernet" id="Ethernet" checked tabindex="36"> Ethernet</LABEL>
                                   </TD>
                              	<TD align="left" colspan="3"><LABEL for="Other">
                                		<CFINPUT type="radio" alt="option to select other type of connection" name="Connect_Type" value="Other" id="Other" tabindex="37"> Other</LABEL>
                                   </TD>
                              </TR>
                              <TR>
                              	<TH align="left" VALIGN="TOP"><SPAN class="textemphasis">
                                   	&nbsp;&nbsp;&nbsp;&nbsp; If you selected &ldquo;Other,&rdquo;  (non-Ethernet  <BR>
                                		&nbsp;&nbsp;&nbsp;&nbsp; connection)</SPAN> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;specify type:
                                   </TH>
                              	<TD align="left"><LABEL for="Other_NIC">
                                		<CFINPUT type="radio" alt="other non-ethernet type of connection" name="Other_NIC" value="Other_NIC" id="Other_NIC" tabindex="38"> Other</LABEL>
                                   </TD>
                              	<TD align="left"><LABEL for="ITT_to_IBM">
                                		<CFINPUT type="radio" alt="ITT to IBM non-ethernet type of connection" name="Other_NIC" value="ITT_to_IBM" id="ITT_to_IBM" tabindex="39"> ITT terminal to IBM controller</LABEL>
                                   </TD>
                              	<TD align="left" colspan="2"><LABEL for="Term_to_Serv">
                                		<CFINPUT type="radio" name="Other_NIC" value="Term_to_Serv" id="Term_to_Serv" tabindex="40"> Terminal to terminal server</LABEL>
                                   </TD>
                              </TR>
                              <TR>
                              	<TH align="left" VALIGN="TOP">
                                   	&nbsp;&nbsp;&nbsp;&nbsp; If you selected &ldquo;Other,&rdquo; (non-Ethernet <BR>
                                		&nbsp;&nbsp;&nbsp;&nbsp; connection) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;please describe the <BR>
                                		&nbsp;&nbsp;&nbsp;&nbsp; connection you want in more detail:
                                   </TH>
                              	<TD align="left" colspan="4"><LABEL for="Other_NIC_Descr" id="Other_NIC_Descr">
                                   	<TEXTAREA name="Other_NIC_Descr" id="Other_NIC_Descr" cols="80" rows="10" tabindex="41"> </TEXTAREA></LABEL>
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
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Acct_FName" name="Acct_FName" size="30" value="MARK" tabindex="42" ></TD>
                              </TR>
                              <TR>
                              	<TH align="left">
                                   	<H4>*&nbsp;</H4>
                                        <LABEL for="Acct_LName">Acct. Admin. Last Name</LABEL>
                                   </TH>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Acct_LName" name="Acct_LName" size="30" value="FIGUEROA"  tabindex="43"></TD>
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
                                   <CFSET FORM.ACCT_NUMBER = '#GetTNSWorkOrders.ACCOUNTNUMBER1#' & '#GetTNSWorkOrders.ACCOUNTNUMBER2#' & '#GetTNSWorkOrders.ACCOUNTNUMBER3#'>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Acct_Num" name="Acct_Num" size="45" value="#FORM.ACCT_NUMBER#"  tabindex="44"></TD>
                              </TR>
                              <TR>
                              	<TH align="left" colspan="5">Please enter the campus phone number of the signatory given above. &nbsp;&nbsp;Disregard this field for state-owned equipment.</TH>
                              </TR>
                              <TR>
                              	<TH align="left">
                                   	<H4>*&nbsp;</H4>
                                        <LABEL for="Acct_Phone">Acct. Admin. Phone:</LABEL>
                                   </TH>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Acct_Phone" name="Acct_Phone" size="30" value="42945" tabindex="45" >&nbsp;Format: 49999</TD>
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
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Contact_FName" name="Contact_FName" size="30" value="#GetTNSWorkOrders.FIRSTNAME#" tabindex="46"  ></TD>
                              </TR>
                              <TR>
                              	<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Contact_LName">Contact Last Name:</LABEL></TH>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Contact_LName" name="Contact_LName" size="30" value="#GetTNSWorkOrders.LASTNAME#" tabindex="47" ></TD>
                              </TR>
                              <TR>
                              	<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Contact_BldgRm">Contact Bldg/Rm:</LABEL></TH>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Contact_BldgRm" name="Contact_BldgRm" size="30" value="#GetTNSWorkOrders.ROOMNUMBER#" tabindex="48"></TD>
                              </TR>
                              <TR>
                              	<TH align="left">&nbsp;&nbsp;&nbsp;&nbsp;<LABEL for="Contact_Phone">Contact Phone:</LABEL></TH>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Contact_Phone" name="Contact_Phone" size="30" value="#GetTNSWorkOrders.CAMPUSPHONE#" tabindex="49" ></TD>
                              </TR>
                              <TR>
                              	<TH align="left">
                                   	<H4>*&nbsp;</H4>
                                        <LABEL for="Contact_Email">Contact E-mail:</LABEL>
                                   </TH>
                              	<TD align="left" colspan="4"><CFINPUT type="text" id="Contact_Email" name="Contact_Email" size="30" value="#GetTNSWorkOrders.EMAIL#" tabindex="50" ></TD>
                              </TR>
                              <TR>
                              	<TD align="left" colspan="5" align="center"> 
                                   	<INPUT type="hidden" name="PROCESSTNSWORKORDERS" value="SUBMIT" />   
                                   	<INPUT type="image" src="/images/buttonSubmitTNSRequest.jpg" value="SUBMIT TNS REQUEST" alt="Submit TNS Request" tabindex="51">
                                   </TD>
                              </TR>
</CFFORM>
					</TBODY>
				</TABLE>
                    </DIV>
			</TD>  
		</TR>
     </TABLE>
	<BR><BR>		
     <TABLE width="100%" align="left" border="0">
          <TR>
               <TD align="LEFT" colspan="5">
               	<BR><BR>
			<CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
<CFFORM action="/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE&SRID=#val(Cookie.SRID)#&LOOKUPWO=FOUND&STAFFLOOP=YES" method="POST">
                    <INPUT type="image" src="/images/buttonModifyTNSRequest.jpg" value="MODIFY TNS REQUEST" alt="Modify TNS Request" tabindex="52" />
</CFFORM>
               <CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE&SRID=#val(Cookie.SRID)#&LOOKUPWO=FOUND" method="POST">
                    <INPUT type="image" src="/images/buttonModifyTNSRequest.jpg" value="MODIFY TNS REQUEST" alt="Modify TNS Request" tabindex="52" />
</CFFORM>
			</CFIF>
               </TD>
          </TR>
          <TR>
               <TD align="LEFT" colspan="5">
				<CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="53" /><BR />
                    <CFELSE>
<CFFORM action="/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=SUBMIT" method="POST">
                    	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="53" /><BR />
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