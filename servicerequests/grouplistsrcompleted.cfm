<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: grouplistsrcompleted.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/03/2016 --->
<!--- Date in Production: 03/03/2016 --->
<!--- Module: Group List Service Request Completed --->
<!-- Last modified by John R. Pastori on 03/03/2016 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "jpastori@mail.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/grouplistsrcompleted.cfm">
<CFSET CONTENT_UPDATED = "March 03, 2016">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Group List Service Request Completed</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Service Requests Application!";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


	function validateGROUPReqFields() {
		if (document.LOOKUP.GROUPID.VALUE == "0") {
			alertuser ("You must select a Group Name.");
			document.LOOKUP.GROUPID.focus();
			return false;
		}
		
		if (document.LOOKUP.REPORTSORTORDER.selectedIndex == "0") {
			alertuser ("You must select a Sort Order.");
			document.LOOKUP.REPORTSORTORDER.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFIF NOT IsDefined('URL.LOOKUPGROUPID')>
	<CFSET CURSORFIELD = "document.LOOKUP.GROUPID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>

<BODY onLoad="#CURSORFIELD#">

<!--- 
*************************************************************************************************************
* The following code is the Group Assigned Records Lookup Process for Group List Service Request Completed. *
*************************************************************************************************************
 --->
 

<CFIF NOT IsDefined('URL.LOOKUPGROUPID')>

	<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
		SELECT	GROUPID, GROUPNAME
		FROM		GROUPASSIGNED
		ORDER BY	GROUPNAME
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Group List Service Request Completed Lookup</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TD align="center">
               	<H4>
                    	Group ES/LIB is the default group. &nbsp;&nbsp;Group ES/AA will be combined when Group ES/LIB is selected.
                         <br> A different group can be selected from the Group Dropdown.
                    </H4>
               </TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
			<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH align="left" width="33%"><LABEL for="GROUPID">Group</LABEL></TH>
               <TH align="left" width="33%"><LABEL for="DATERANGE">Date Range Completed</LABEL></TH>
               <TH align="left" width="34%"><LABEL for="REPORTSORTORDER"> Sort Order</LABEL></TH>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateGROUPReqFields();" action="/#application.type#apps/servicerequests/grouplistsrcompleted.cfm?LOOKUPGROUPID=FOUND" method="POST">
		<TR>
			<TD align="left" width="33%">
               	<CFSELECT name="GROUPID" id="GROUPID" size="1" required="No" tabindex="2">
                              <OPTION SELECTED value="7">ES/LIB</OPTION>
                              <CFLOOP query="ListGroupAssigned">
                                   <OPTION value="#GROUPID#">#GROUPNAME#</OPTION>
                              </CFLOOP>  
                         </CFSELECT>
               </TD>
               <TD align="left" width="33%">
                   	<CFSELECT name="DATERANGE" id="DATERANGE" size="1" required="No" tabindex="3">
                         <OPTION value="0">Select a Date Range</OPTION>
                         <OPTION value="30">Completed in the Last 30 Days</OPTION>
                         <OPTION value="60">Completed in the Last 60 Days</OPTION>
                         <OPTION value="90">Completed in the Last 90 Days</OPTION>
                    </CFSELECT>
               </TD>
               <TD align="left" width="34%">
                   	<CFSELECT name="REPORTSORTORDER" id="REPORTSORTORDER" size="1" required="No" tabindex="3">
                         <OPTION value="0">Select a Sort Order</OPTION>
                         <OPTION SELECTED value="1">SR Date Completed/Staff Assigned/Requester/SR Number</OPTION>
                         <OPTION value="2">SR Date Completed/Staff Assigned/SR Number</OPTION>
                         <OPTION value="3">Staff Assigned/SR Date Completed/Requester/SR Number</OPTION>
                    </CFSELECT>
               </TD>
          </TR>
          <TR>
               <TD align="left" COLSPAN="3">
				<INPUT type="image" src="/images/buttonSelectGroup.jpg" value="Select Group" alt="Select Group" tabindex="4" />
			</TD>
		</TR>
</CFFORM>
          <TR>
			<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" />
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
********************************************************************************************************
* The following code is the Group Assigned Selection Process for Group List Service Request Completed. *
********************************************************************************************************
 --->

     <CFQUERY name="LookupCompletedServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SR.SRID, SR.GROUPASSIGNEDID, SR.SRCOMPLETED, SR.SRCOMPLETEDDATE, ROUND(TO_NUMBER(SYSDATE - SR.SRCOMPLETEDDATE), 0) as CALCDAYS
		FROM		SERVICEREQUESTS SR
		WHERE	(SR.SRID > 0 AND
			<CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                    SR.GROUPASSIGNEDID IN (7,19) AND
               <CFELSE> 
                    SR.GROUPASSIGNEDID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
               </CFIF>
                    ROUND(TO_NUMBER(SYSDATE - SR.SRCOMPLETEDDATE), 0) <= #FORM.DATERANGE# AND
                    SR.SRCOMPLETED = 'YES')
          ORDER BY	SR.SRID DESC
     </CFQUERY>
     
	<CFIF #LookupCompletedServiceRequests.RecordCount# EQ 0>
          <SCRIPT language="JavaScript">
               <!-- 
                    alert("SR Records for your selected Group were Not Found");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/grouplistsrcompleted.cfm" />
          <CFEXIT>
     </CFIF>
    
     
     <CFQUERY name="LookupCompletedGroupStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	DISTINCT SRSA.SRID, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID, SRSA.STAFF_COMPLETEDSR, SR.SRID, SR.SRCOMPLETED, SR.SRCOMPLETEDDATE
          FROM		SRSTAFFASSIGNMENTS SRSA, SERVICEREQUESTS SR
          WHERE	(SRSA.SRID = SR.SRID AND
                     SR.SRCOMPLETED = 'YES' AND
                     ROUND(TO_NUMBER(SYSDATE - SR.SRCOMPLETEDDATE), 0) <= #FORM.DATERANGE#) AND
                    ((SRSA.SRID IN (#ValueList(LookupCompletedServiceRequests.SRID)#) AND
                      SRSA.NEXT_ASSIGNMENT = 'NO') OR
               <CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
                     (SRSA.NEXT_ASSIGNMENT_GROUPID IN (7,19) AND
               <CFELSE> 
                     (SRSA.NEXT_ASSIGNMENT_GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
               </CFIF>
                      SRSA.NEXT_ASSIGNMENT = 'YES' AND
                      NOT (SRSA.SRID IN (#ValueList(LookupCompletedServiceRequests.SRID)#))))
          ORDER BY	SRSA.SRID DESC
     </CFQUERY>
               
	<CFIF #LookupCompletedGroupStaffAssignments.RecordCount# GT 0>
          <CFSET SESSION.GROUPSRS = #ValueList(LookupCompletedGroupStaffAssignments.SRID)#>
     <CFELSE>
     	<CFSET SESSION.GROUPSRS = #ValueList(LookupCompletedServiceRequests.SRID)#>
     </CFIF>
     
<!---      <BR>SR IDS = #SESSION.GROUPSRS# <BR> --->    
     <CFSET SESSION.LKUPGROUPID = #FORM.GROUPID#>
<!---      <BR>GROUP SRS = #SESSION.GROUPSRS# <BR> --->
     

<!--- 
**************************************************************************************
* The following code is the Report Display for Group List Service Request Completed. *
**************************************************************************************
 --->
 
	<CFSET CLIENT.REPORTCHOICE = 0>
     <CFSET CLIENT.REPORTORDER = 0>
     <CFSET CLIENT.REPORTTILE1 = "">
     <CFSET CLIENT.REPORTTILE2 = "">
     <CFSET SESSION.STAFFNAME = "">
     
     <CFSET CLIENT.REPORTCHOICE = #FORM.REPORTSORTORDER#>
      
     <CFSET SORTORDER = ARRAYNEW(1)>
     <CFSET SORTORDER[1]  = 'SRCOMPLETEDDATE DESC~ STAFF~ REQCUST.FULLNAME~ SR.SERVICEREQUESTNUMBER'>
	<CFSET SORTORDER[2]  = 'SRCOMPLETEDDATE DESC~ STAFF~ SR.SERVICEREQUESTNUMBER'>
     <CFSET SORTORDER[3]  = 'STAFF~ SRCOMPLETEDDATE DESC~ REQCUST.FULLNAME~ SR.SERVICEREQUESTNUMBER'>
     
     <CFSET CLIENT.REPORTORDER = EVALUATE("SORTORDER[#CLIENT.REPORTCHOICE#]")>
     
     <CFIF FIND('~', #CLIENT.REPORTORDER#, 1) NEQ 0>
          <CFSET CLIENT.REPORTORDER = ListChangeDelims(CLIENT.REPORTORDER, ",", "~")>
     </CFIF>	
     
     <CFSET CLIENT.REPORTTITLE1 = "Group List Service Request Completed Report">
     
          
     <CFQUERY name="LookupGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="16">
          SELECT	GROUPID, GROUPNAME
          FROM		GROUPASSIGNED
          WHERE	GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	GROUPNAME
     </CFQUERY>
     
     <CFIF #FORM.GROUPID# EQ 7 OR #FORM.GROUPID# EQ 19>
     	<CFSET CLIENT.REPORTTITLE2 = "For Group: &nbsp;&nbsp;ES/LIB - ES/AA in the Last #FORM.DATERANGE# Days">
     <CFELSE>
     	<CFSET CLIENT.REPORTTITLE2 = "For Group: &nbsp;&nbsp;#LookupGroupAssigned.GROUPNAME# in the Last #FORM.DATERANGE# Days">
     </CFIF>
     
     <CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
         SELECT	SR.SRID, SRSA.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.GROUPASSIGNEDID, IDTGROUP.GROUPNAME,
         			SRSA.NEXT_ASSIGNMENT, SRSA.STAFF_ASSIGNEDID, WGA.GROUPID, STAFFCUST.CUSTOMERID, STAFFCUST.FULLNAME AS STAFF,
				SR.REQUESTERID, REQCUST.FULLNAME AS REQNAME, REQCUST.UNITID, SR.ALTERNATE_CONTACTID, SR.PRIORITYID, P.PRIORITYNAME,
				SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, PROBCAT.CATEGORYLETTER || ' ' || PROBCAT.CATEGORYNAME AS PROBCATEGORY,
				PROBSUBCAT.SUBCATEGORYNAME, SR.PROBLEM_DESCRIPTION, SR.ASSIGN_PRIORITY, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,
				SR.PG_STAFFASSIGNEDCOUNT, SR.NG_STAFFASSIGNEDCOUNT
		FROM		SERVICEREQUESTS SR, SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS STAFFCUST, PROBLEMCATEGORIES PROBCAT, 
          		PROBLEMSUBCATEGORIES PROBSUBCAT, GROUPASSIGNED IDTGROUP, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PRIORITY P
		WHERE	(SR.SRID > 0 AND
          		SR.SRID IN (#SESSION.GROUPSRS#) AND 
          		SR.SRID = SRSA.SRID AND
                    SRSA.STAFF_ASSIGNEDID > 0 AND
                    SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                    SR.GROUPASSIGNEDID = WGA.GROUPID AND
                    WGA.STAFFCUSTOMERID = STAFFCUST.CUSTOMERID  AND         
				SR.PROBLEM_CATEGORYID = PROBCAT.CATEGORYID AND
				SR.PROBLEM_SUBCATEGORYID = PROBSUBCAT.SUBCATEGORYID AND
				SR.GROUPASSIGNEDID = IDTGROUP.GROUPID AND
				SR.REQUESTERID = REQCUST.CUSTOMERID AND
				SR.PRIORITYID = P.PRIORITYID AND
                    SR.SRCOMPLETED = 'YES')
          ORDER BY	#CLIENT.REPORTORDER# DESC
     </CFQUERY>

</CFIF>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center">
			<H1>#CLIENT.REPORTTITLE1#</H1>
			<H2>#CLIENT.REPORTTITLE2#</H2>
		</TD>       
	</TR>
</TABLE>
<BR clear="left" />

<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/servicerequests/grouplistsrcompleted.cfm" method="POST">
		<TD align="left">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER"><H2>#GetServiceRequests.RecordCount# Service Request records were selected.</H2></TH>
	</TR>
</TABLE>


<cfloop query="GetServiceRequests">
     
	<table width="100%" align="left" border="0">
		<tr>     
			<TH align="LEFT" valign="BOTTOM" width="20%">SR</TH>
			<TH align="LEFT" valign="BOTTOM" width="20%">Requester</TH>
			<TH align="LEFT" valign="BOTTOM" width="20%">BarCode</TH>
			<TH align="LEFT" valign="BOTTOM" width="20%">Entered</TH>
			<TH align="LEFT" valign="BOTTOM" width="20%">Completed? - Date</TH>
		</tr>
	     
		<cfquery name="GetSREquipBarcode" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
				SELECT	SREL.SREQUIPID, SREL.SERVICEREQUESTNUMBER, SREL.EQUIPMENTBARCODE, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE
				FROM		SREQUIPLOOKUP SREL, HARDWMGR.HARDWAREINVENTORY HI, HARDWMGR.EQUIPMENTTYPE EQT
				WHERE	SREL.SERVICEREQUESTNUMBER = '#GetServiceRequests.SERVICEREQUESTNUMBER#' AND
						SREL.EQUIPMENTBARCODE = HI.BARCODENUMBER AND
						HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID
		</cfquery>
	
		<tr>
			<td align="LEFT" valign="TOP" width="20%">#GetServiceRequests.SERVICEREQUESTNUMBER#</td>
               <td align="LEFT" valign="TOP" width="20%">#GetServiceRequests.REQNAME#</td>
		<cfif GetSREquipBarcode.RecordCount GT 0>
			<td align="LEFT" valign="TOP" width="20%"><div>#GetSREquipBarcode.EQUIPMENTBARCODE#</div></td>
		<CFELSE>
			<td align="LEFT" valign="TOP" width="20%"><div>&nbsp;&nbsp;</div></td>
		</cfif>
			<td align="LEFT" valign="TOP" width="20%"><div>#DateFormat(GetServiceRequests.CREATIONDATE, 'MM/DD/YYYY')#</div></td>
			<td align="LEFT" valign="TOP" width="20%">
               	<div>
               		<STRONG><FONT COLOR="BLUE"> 
                         	#GetServiceRequests.SRCOMPLETED# - #DateFormat(GetServiceRequests.SRCOMPLETEDDATE, 'MM/DD/YYYY')# <BR>
                              First Primary Staff Assigned: &nbsp;&nbsp;#GetServiceRequests.STAFF#                            
                         </FONT></STRONG>
                    </div>
               </td>
		</tr>
	</table>
     <br>
     <table width="100%" align="left" border="0">
          <tr>
			<TH align="LEFT" valign="TOP" nowrap width="12%">Problem Description:</TH>
			<td align="LEFT" valign="TOP" colspan="4" width="88%"><div>#GetServiceRequests.PROBLEM_DESCRIPTION#</div></td>
		</tr>
          <tr>
			<TH align="LEFT" valign="TOP" nowrap width="12%">Assign-P:</TH>
			<td align="LEFT" valign="TOP" width="8%"><div>#GetServiceRequests.ASSIGN_PRIORITY#</div></td>
		<cfif GetSREquipBarcode.RecordCount GT 0>
               <TH align="LEFT" valign="TOP" nowrap width="20%">Equip Type:</TH>
			<td align="LEFT" valign="TOP" width="20%"><div>#GetSREquipBarcode.EQUIPMENTTYPE#</div></td>
		<CFELSE>
			<td align="LEFT" valign="TOP" width="40%"><div>&nbsp;&nbsp;</div></td>
		</cfif>
			<TH align="left" valign="TOP" width="20%">Problem Cat/Sub-Cat:</TH>
			<td align="left" valign="TOP" width="20%">#GetServiceRequests.PROBCATEGORY# - #GetServiceRequests.SUBCATEGORYNAME#</td>
		</tr>
      </table>    
     
     <br>
     <table width="100%" align="left" border="0">
     	
          <cfquery name="GetSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID AS STAFFSRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, SRSA.STAFF_TIME_WORKED,
               		WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT_GROUPID, WGA.GROUPID, GA.GROUPNAME,  WGA.STAFFCUSTOMERID, 
                         CUST.FULLNAME, SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE, SRSA.STAFF_COMMENTS,  SRSA.STAFF_ASSIGNMENT_ORDER
               FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	SRSA.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         WGA.GROUPID = GA.GROUPID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
               ORDER BY	SRSA.NEXT_ASSIGNMENT_GROUPID
          </cfquery>
              
	<cfloop query="GetSRStaffAssignments">
     	<tr>
          <cfif GetSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID EQ 0>   
			<TH align="LEFT" valign="BOTTOM" width="20%">Primary</TH>
          <CFELSE>    
               <TH align="LEFT" valign="BOTTOM" width="20%">Next</TH>
           </cfif>    
			<TH align="LEFT" valign="BOTTOM" width="10%">Workgroup</TH>
			<TH align="CENTER" valign="BOTTOM" width="10%">Code</TH>
			<TH align="LEFT" valign="BOTTOM" width="40%">Comments</TH>
			<TH align="LEFT" valign="BOTTOM" width="20%">Completed? - Date - Time Worked</TH>
		</tr>
          <tr>
               <td align="LEFT" valign="TOP" width="20%"><div>#GetSRStaffAssignments.FULLNAME#</div></td>
          <cfif GetSRStaffAssignments.NEXT_ASSIGNMENT_GROUPID EQ 0>
               <td align="LEFT" valign="TOP" width="10%"><div>#GetSRStaffAssignments.GROUPNAME#</div></td>
          <CFELSE>
          	<td align="LEFT" valign="TOP" width="10%"><div>#GetSRStaffAssignments.GROUPNAME#</div></td>
          </cfif> 
               <td align="CENTER" valign="TOP" width="10%"><div>#GetSRStaffAssignments.STAFF_ASSIGNMENT_ORDER#</div></td>
               <td align="LEFT" valign="TOP" width="40%"><div>#GetSRStaffAssignments.STAFF_COMMENTS#</div></td>
               <td align="LEFT" valign="TOP" width="20%">
               	<div>
               		#GetSRStaffAssignments.STAFF_COMPLETEDSR# -
                    	#DateFormat(GetSRStaffAssignments.STAFF_COMPLETEDDATE, 'MM/DD/YYYY')#
                    	- #GetSRStaffAssignments.STAFF_TIME_WORKED#
                    </div>
               </td>
          </tr>
	</cfloop>         	
		<tr>
			<td align="left" valign="TOP" colspan="5"><hr></td>
		</tr>
     </table>
     <br>

</cfloop>
<table width="100%" align="center" border="0">
     <tr>
          <td align="left" valign="TOP" colspan="5"><hr></td>
     </tr>
     <tr>
          <TH align="CENTER" colspan="5"><h2>#GetServiceRequests.RecordCount# Service Request records were selected.</h2></TH>
     </tr>

     <tr>
<cfform action="/#application.type#apps/servicerequests/grouplistsrcompleted.cfm" method="POST">
          <td align="left"><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /></td>
</cfform>
	</tr>
     <tr>
          <td align="left" colspan="9">
               <cfinclude template="/include/coldfusion/footer.cfm">
          </td>
     </tr>
</table>

</BODY>
</CFOUTPUT>
</HTML>