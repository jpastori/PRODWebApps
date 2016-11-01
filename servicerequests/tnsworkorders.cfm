<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: tnsworkorders.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/26/2012 --->
<!--- Date in Production: 06/26/2012 --->
<!--- Module: Add, Modify and Delete TNS Work Orders--->
<!-- Last modified by John R. Pastori on 10/22/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/tnsworkorders.cfm">
<CFSET CONTENT_UPDATED = "October 22, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add TNS Work Orders</TITLE>
	<CFELSE>
		<TITLE>Modify TNS Work Orders</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Service Requests";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


	function validateReqFields() {

		if (document.TNSWORKORDER.WORK_DESCRIPTION.value == "" || document.TNSWORKORDER.WORK_DESCRIPTION.value == " ") {
			alertuser (document.TNSWORKORDER.WORK_DESCRIPTION.name +  ",  You must enter a Work Description.");
			document.TNSWORKORDER.WORK_DESCRIPTION.focus();
			return false;
		}

		if ((document.TNSWORKORDER.ACCOUNTNUMBER2 != null) && (document.TNSWORKORDER.ACCOUNTNUMBER2.value == "" || document.TNSWORKORDER.ACCOUNTNUMBER2.value == " ")) {
			alertuser (document.TNSWORKORDER.ACCOUNTNUMBER2.name +  ",  You must enter a 4 digit number.");
			document.TNSWORKORDER.ACCOUNTNUMBER2.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.SRID1.selectedIndex == "0" && document.LOOKUP.SRID2.selectedIndex == "0") {
			alertuser ("A selection must be made from one of the dropdowns.");
			document.LOOKUP.SRID1.focus();
			return false;
		}
		
		if (document.LOOKUP.SRID1.selectedIndex > "0" && document.LOOKUP.SRID2.selectedIndex > "0") {
			alertuser ("BOTH dropdown values can NOT be selected! Choose one or the other.");
			document.LOOKUP.SRID1.focus();
			return false;
		}
		
	}
	
		
	function setModReview() {
		document.TNSWORKORDER.PROCESSTNSWORKORDERS.value = "MODIFY AND REVIEW";
		return true;
	}
	

	function setDelete() {
		document.TNSWORKORDER.PROCESSTNSWORKORDERS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined("URL.LOOKUPWO") AND URL.PROCESS EQ "MODIFY">
	<CFSET CURSORFIELD = "document.LOOKUP.SERVICEREQUESTNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.TNSWORKORDER.WO_TYPE.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<CFIF IsDefined("URL.WO_TYPE")>
	<CFSET FORM.WOTYPE = "#URL.WO_TYPE#">
<CFELSE>
	<CFSET FORM.WOTYPE = "TNS">
</CFIF>

<!--- 
***********************************************************
* The following code is for all TNS Work Order Processes. *
***********************************************************
 --->

<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE,
			HI.OWNINGORGID, HI.MODELNAMEID, MODELNAMELIST.MODELNAME, HI.MODELNUMBERID, MODELNUMBERLIST.MODELNUMBER,
			HI.CUSTOMERID, CUST.FULLNAME, LOC.ROOMNUMBER, HW.WARRANTYEXPIRATIONDATE AS WARDATE,
			HI.BARCODENUMBER || '-' || CUST.FULLNAME ||'-' || EQT.EQUIPMENTTYPE || '-' || MODELNAMELIST.MODELNAME AS LOOKUPBARCODE
	FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST, MODELNUMBERLIST, LIBSHAREDDATAMGR.CUSTOMERS CUST,
			FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
	WHERE	HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND
			HI.MODELNAMEID = MODELNAMELIST.MODELNAMEID AND
			HI.MODELNUMBERID = MODELNUMBERLIST.MODELNUMBERID AND
			HI.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			HI.BARCODENUMBER = HW.BARCODENUMBER
	ORDER BY	HI.BARCODENUMBER, CUST.FULLNAME, EQT.EQUIPMENTTYPE, MODELNAMELIST.MODELNAME
</CFQUERY>

<CFQUERY name="ListLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
			LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
			LOC.MODIFIEDBYID, LOC.MODIFIEDDATE
	FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
	WHERE	LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID AND
               BN.BUILDINGNAMEID IN (0,10,11)
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
</CFQUERY>


<CFQUERY name="ListJackNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.ROOMNUMBER, WJ.WALLDIRID, WD.WALLDIRNAME, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.CUSTOMERID, CUST.FULLNAME,
			LOC.ROOMNUMBER || ' - ' || WD.WALLDIRNAME || ' - ' || WJ.CLOSET || ' - ' || WJ.JACKNUMBER || ' - ' || WJ.PORTLETTER || ' - ' || CUST.FULLNAME AS KEYFINDER
	FROM		WALLJACKS WJ, LOCATIONS LOC, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	WJ.LOCATIONID = LOC.LOCATIONID AND
			WJ.WALLDIRID = WD.WALLDIRID AND
			WJ.CUSTOMERID = CUST.CUSTOMERID
	ORDER BY	LOC.ROOMNUMBER, WD.WALLDIRNAME, WJ.JACKNUMBER, WJ.PORTLETTER
</CFQUERY>

<!--- 
**************************************************************
* The following code is the ADD Process for TNS Work Orders. *
**************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add TNS Work Orders</H1></TD>
		</TR>
	</TABLE>
	
	<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
				SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, LOC.ROOMNUMBER, SR.ALTERNATE_CONTACTID,
				SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID, SR.GROUPASSIGNEDID, IDTGROUP.GROUPID, IDTGROUP.GROUPNAME,
                    SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID, SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
				SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
		FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC, GROUPASSIGNED IDTGROUP
		WHERE	SR.SRID = <CFQUERYPARAM value="#URL.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SR.REQUESTERID = CUST.CUSTOMERID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
                    SR.GROUPASSIGNEDID = IDTGROUP.GROUPID
		ORDER BY	LOOKUPKEY
	</CFQUERY>
     
     <CFQUERY name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.FULLNAME,
                    TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATEASSIGNED, SRSA.NEXT_ASSIGNMENT, SRSA.NEXT_ASSIGNMENT_GROUPID
          FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	SRSA.SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    SRSA.STAFF_COMPLETEDSR = 'NO' AND
                    SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                    WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
                    SRSA.NEXT_ASSIGNMENT = 'NO' AND
                    SRSA.NEXT_ASSIGNMENT_GROUPID = 0
          ORDER BY	SRSA.STAFF_ASSIGNEDID
     </CFQUERY>
     
     <CFQUERY name="LookupSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
          FROM		SREQUIPLOOKUP
          WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#LookupServiceRequests.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
     </CFQUERY>
     
     <CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE">
          SELECT	HI.HARDWAREID, HI.BARCODENUMBER
          FROM		HARDWAREINVENTORY HI
          WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#LookupSREquipLookup.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> 
          ORDER BY	BARCODENUMBER
     </CFQUERY>
     
     <CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
          SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.EBA_111, TNSWO.STAFFID, 
                    CUST.FULLNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.LOCATIONID, LOC.ROOMNUMBER, TNSWO.NEW_LOCATION,
                    TNSWO.CURRENT_JACKNUMBER, TNSWO.NEW_JACKNUMBER,  TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION,
                    TNSWO.ACCOUNTNUMBER1, TNSWO.ACCOUNTNUMBER2, TNSWO.ACCOUNTNUMBER3, TNSWO.JUSTIFICATION_DESCRIPTION,
                    TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER
          FROM		TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC
          WHERE	TNSWO.SRID = <CFQUERYPARAM value="#LookupServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    TNSWO.STAFFID = CUST.CUSTOMERID AND
                    CUST.LOCATIONID = LOC.LOCATIONID AND
                    NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
          ORDER BY	TNSWO.WO_TYPE
     </CFQUERY>

     <CFIF LookupTNSWorkOrders.RecordCount EQ 0>

          <CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
               SELECT	MAX(TNSWO_ID) AS MAX_ID
               FROM		TNSWORKORDERS
          </CFQUERY>
          <CFSET FORM.TNSWO_ID = #val(GetMaxUniqueID.MAX_ID+1)#>
          <CFCOOKIE name="TNSWO_ID" secure="NO" value="#FORM.TNSWO_ID#">
          <CFQUERY name="AddTNSWOIDInfo" datasource="#application.type#SERVICEREQUESTS">
               INSERT INTO	TNSWORKORDERS (TNSWO_ID, SRID)
               VALUES		(#val(FORM.TNSWO_ID)#, #val(URL.SRID)#)
          </CFQUERY>
     
     <CFELSE>
     
     	<SCRIPT language="JavaScript">
			<!-- 
				alert ("This SR already has a TNS Work Order associated with it.");
			-->
		</SCRIPT>
		<CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('client.STAFFLOOP') AND #client.STAFFLOOP# EQ "YES"))>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#URL.SRID#" />
			<CFEXIT>
		<CFELSE>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE&LOOKUPWO=FOUND&SRID=#URL.SRID#" />
			<CFEXIT>
		</CFIF>

	</CFIF>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				TNS Work Order Key &nbsp; = &nbsp; #FORM.TNSWO_ID#<BR />
				TNS Contact Phone: &nbsp;&nbsp;&nbsp;&nbsp;4-3500
			</TH>
		</TR>
	</TABLE>
	<BR clear="left" />
     
     <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES")>
		<CFSET PROGRAMNAME = "processtnsworkorders.cfm?STAFFLOOP=YES">
     <CFELSEIF (IsDefined('URL.SRCALL')AND #URL.SRCALL# EQ "YES")>
          <CFSET PROGRAMNAME = "processtnsworkorders.cfm?SRCALL=YES">
     <CFELSE>
          <CFSET PROGRAMNAME = "processtnsworkorders.cfm">
     </CFIF>
     
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST">
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSTNSWORKORDERS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="TNSWORKORDER" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" valign="TOP">SR</TH>
			<TH align="left" valign="TOP">Requestor</TH>
			<TH align="left" valign="TOP">Group</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				#LookupServiceRequests.SERVICEREQUESTNUMBER#
			</TD>
			<TD align="left" valign ="TOP">
               	#LookupServiceRequests.FULLNAME#
               </TD>
               <TD align="left" valign="TOP">
          		#LookupServiceRequests.GROUPNAME#
         		</TD>
		</TR>
           <TR>
			<TH align="left" valign="TOP">SR Creation Date</TH>
			<TH align="left" valign="TOP">Requestor Location</TH>
			<TH align="left" valign="TOP">Staff Assignment</TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
               	#DateFormat(LookupServiceRequests.CREATIONDATE, 'mm/dd/yyyy')#
               </TD>
			<TD align="left" valign ="TOP">
               	#LookupServiceRequests.ROOMNUMBER#
               </TD>
			<TD align="left" valign="TOP">
				#LookupSRStaffAssignments.FULLNAME#
                    <INPUT type="hidden" name="STAFFID" value="#LookupSRStaffAssignments.STAFFCUSTOMERID#" />
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="WO_DUEDATE">TNS WO Due Date</LABEL></TH>
			<TH align="left"><LABEL for="WO_TYPE">TNS WO Type</LABEL></TH>
			<TH align="left"><LABEL for="WO_STATUS">TNS WO Status</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFINPUT type="Text" name="WO_DUEDATE" id="WO_DUEDATE" value="" align="LEFT" required="No" size="15" tabindex="2">
                    <SCRIPT language="JavaScript">
					new tcal ({'formname': 'TNSWORKORDER','controlname': 'WO_DUEDATE'});

				</SCRIPT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="WO_TYPE" id="WO_TYPE" size="1" tabindex="3">
					<OPTION value="TNS TYPE">TNS TYPE</OPTION>
					<OPTION value="NEW">NEW</OPTION>
					<OPTION value="MOVE">MOVE</OPTION>
					<OPTION value="REPORT">REPORT</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="WO_STATUS" id="WO_STATUS" size="1" tabindex="4">
					<OPTION selected value="PENDING">PENDING</OPTION>
					<OPTION value="COMPLETE">COMPLETE</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
               <TH align="left" valign="TOP"><LABEL for="NEW_LOCATION">New Location</LABEL></TH>
               <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
               <TH align="left" valign="TOP"><LABEL for="EBA_111">Involves EBA-111?</LABEL></TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">
                    <CFSELECT name="NEW_LOCATION" id="NEW_LOCATION" size="1" query="ListLocations" value="LOCATIONID" display="ROOMNUMBER" required="No" tabindex="5"></CFSELECT>
               </TD>
               <TD align="left" valign="TOP">
                    <INPUT type="image" src="/images/buttonAddLoc.jpg" name="AddLocation" value="ADD" alt="Add Location Record" onClick="window.open('/#application.type#apps/facilities/locationinfo.cfm?PROCESS=ADD&SRCALL=YES', 'Add Location Record','alwaysRaised=yes,dependent=no,width=800,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="6" /><BR>
                    <COM>If you have to add a new LOCATION record, click the "CANCEL ADD" button on this screen and open a new Add TNS Work Order Screen.</COM>
               </TD>
               <TD align="left" valign="top">
                    <CFSELECT name="EBA_111" id="EBA_111" size="1" tabindex="7">
                         <OPTION selected value="NO">NO</OPTION>
                         <OPTION value="YES">YES</OPTION>
                    </CFSELECT>
               </TD>
          </TR>
		<TR>
			<TH align="left" valign="TOP" colspan="3"><LABEL for="CURRENT_JACKNUMBER">Current Jack Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3">
				<CFSELECT name="CURRENT_JACKNUMBER" id="CURRENT_JACKNUMBER" size="1" query="ListJackNumbers" value="WALLJACKID" display="KEYFINDER" required="No" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP" colspan="3"><LABEL for="NEW_JACKNUMBER">New Jack Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="NEW_JACKNUMBER" id="NEW_JACKNUMBER" size="1" query="ListJackNumbers" value="WALLJACKID" display="KEYFINDER" required="No" tabindex="9"></CFSELECT>
			</TD>
               <TD align="left" width="33%" valign="TOP">
                    <INPUT type="image" src="/images/buttonAddWJ.jpg" name="AddWallJack" value="ADD" alt="Add Wall Jack Record" onClick="window.open('/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=ADD&SRCALL=YES', 'Add Wall Jack Record','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;" 
                                               tabindex="10" /><BR>
                    <COM>If you have to add a new WALL JACK record, click the "CANCEL ADD" button on this screen and open a new Add TNS Work Order Screen.</COM>
               </TD>
               <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP" colspan="3">Hardware</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3">
               <CFIF LookupSREquipLookup.Recordcount GT 0>
				#LookupSREquipLookup.EQUIPMENTBARCODE#
                    <INPUT type="hidden" name="HW_INVENTORYID" value="#LookupHardware.HARDWAREID#" />
               <CFELSE>
               	Not Selected In SR.
               </CFIF>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP"><H4><LABEL for="WORK_DESCRIPTION">*Work Description</LABEL></H4></TH>
               <TH align="left" valign="TOP"><LABEL for="JUSTIFICATION_DESCRIPTION">Justification Description</LABEL></TH>
               <TH align="left" valign="TOP"><LABEL for="OTHER_DESCRIPTION">Other Description</LABEL></TH>
		</TR>
		<TR>

          	<CFSET SESSION.PROB_DESCR_LENGTH = #LEN(LookupServiceRequests.PROBLEM_DESCRIPTION)#>
          	<CFSET SESSION.WORK_DESCRIPTION = REFind("WORK NEEDED:", LookupServiceRequests.PROBLEM_DESCRIPTION, 1, "True")>
<!--- 
			<CFSET SESSION.JUSTIFICATION_DESCRIPTION = REFind("JUSTIFICATION:", LookupServiceRequests.PROBLEM_DESCRIPTION, 1, "True")>
 --->
               <CFSET SESSION.OTHER_DESCRIPTION = REFind("CURRENT JACK/PORT:", LookupServiceRequests.PROBLEM_DESCRIPTION, 1, "True")>
               <CFSET SESSION.TEXTLEN1 = ((#SESSION.OTHER_DESCRIPTION.pos[1]#) - (#SESSION.WORK_DESCRIPTION.pos[1]#))>
<!--- 
               <CFSET SESSION.TEXTLEN1 = ((#SESSION.JUSTIFICATION_DESCRIPTION.pos[1]#) - (#SESSION.WORK_DESCRIPTION.pos[1]#))>
               <CFSET SESSION.TEXTLEN2 = ((#SESSION.OTHER_DESCRIPTION.pos[1]#) - (#SESSION.JUSTIFICATION_DESCRIPTION.pos[1]#))>
 --->
               <CFSET SESSION.TEXTLEN2 = ((#SESSION.PROB_DESCR_LENGTH# - #SESSION.OTHER_DESCRIPTION.pos[1]#) + 1)>

 			<BR>
<!---               WORK DESCR Position = #SESSION.WORK_DESCRIPTION.pos[1]# &nbsp;&nbsp;&nbsp;&nbsp;WORK DESCR Length = #SESSION.WORK_DESCRIPTION.len[1]#<BR>
          JUST DESCR Position = #SESSION.JUSTIFICATION_DESCRIPTION.pos[1]# &nbsp;&nbsp;&nbsp;&nbsp;JUST DESCR Length = #SESSION.JUSTIFICATION_DESCRIPTION.len[1]#<BR>
			OTHER DESCR Position = #SESSION.OTHER_DESCRIPTION.pos[1]# &nbsp;&nbsp;OTHER DESCR Length = #SESSION.OTHER_DESCRIPTION.len[1]#<BR>
               Text length 1 = #SESSION.TEXTLEN1#<BR>
               Text length 2 = #SESSION.TEXTLEN2#<BR>
               Text length 3 = #SESSION.TEXTLEN3# <BR><BR> --->

			<TD align="left" valign="TOP">
               <CFIF SESSION.WORK_DESCRIPTION.len[1] GT 0>
                    <CFSET SESSION.WORK_DESCRTEXT = MID(LookupServiceRequests.PROBLEM_DESCRIPTION, SESSION.WORK_DESCRIPTION.pos[1], SESSION.TEXTLEN1)>
 				<CFTEXTAREA name="WORK_DESCRIPTION" id="WORK_DESCRIPTION" rows="10" cols="45" wrap="VIRTUAL" required="No" tabindex="11">#SESSION.WORK_DESCRTEXT#</CFTEXTAREA>
			<CFELSE>
				<CFTEXTAREA name="WORK_DESCRIPTION" id="WORK_DESCRIPTION" rows="10" cols="45" wrap="VIRTUAL" required="No" tabindex="11"> </CFTEXTAREA>
               </CFIF>
			</TD>
               <TD align="left" valign="TOP">
				<CFTEXTAREA name="JUSTIFICATION_DESCRIPTION" id="JUSTIFICATION_DESCRIPTION" rows="10" cols="45" wrap="VIRTUAL" required="No" tabindex="12"> </CFTEXTAREA>
			</TD>
               <TD align="left" valign="TOP">
			<CFIF SESSION.OTHER_DESCRIPTION.len[1] GT 0>
                    <CFSET SESSION.OTHER_DESCRTEXT = MID(LookupServiceRequests.PROBLEM_DESCRIPTION, SESSION.OTHER_DESCRIPTION.pos[1], SESSION.TEXTLEN2)>
 				<CFTEXTAREA name="OTHER_DESCRIPTION" id="OTHER_DESCRIPTION" rows="10" cols="45" wrap="VIRTUAL" required="No" tabindex="13">#SESSION.OTHER_DESCRTEXT#</CFTEXTAREA>
			<CFELSE>
				<CFTEXTAREA name="OTHER_DESCRIPTION" id="OTHER_DESCRIPTION" rows="10" cols="45" wrap="VIRTUAL" required="No" tabindex="13"> </CFTEXTAREA>
               </CFIF>
			</TD>
		</TR>
          <TR>
			<TD align="left" valign="TOP" colspan="3">
               	<INPUT type="hidden" name="PROCESSTNSWORKORDERS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="14" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST">
			<TD align="left" valign="TOP" colspan="3">
				<INPUT type="hidden" name="PROCESSTNSWORKORDERS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="15" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
***********************************************************************************
* The following code is the Look Up Process for Modify/Delete of TNS Work Orders. *
***********************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPWO')>

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
               SELECT	SR.SRID, TNSWO.SRID AS WOSRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
                         SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME, SR.SERVICEDESKINITIALSID, 
                         SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID, 
                         SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID, SR.GROUPASSIGNEDID, SR.SERVICETYPEID, 
                         SR.ACTIONID, SR.OPERATINGSYSTEMID, SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
                         SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED, TNSWO.WO_NUMBER, TNSWO.WO_STATUS,
                    <CFIF #Client.SecurityFlag# EQ "No">
                         CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || TNSWO.WO_NUMBER AS LOOKUPKEY
                    <CFELSE>
                         CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || SR.SRCOMPLETED || ' - ' || TNSWO.WO_NUMBER || ' - ' || TNSWO.WO_STATUS AS LOOKUPKEY
                    </CFIF>
               FROM		SERVICEREQUESTS SR, TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	(SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) AND
                         SR.SRID = TNSWO.SRID AND
                         SR.REQUESTERID = CUST.CUSTOMERID) AND
                    <CFIF #Client.SecurityFlag# EQ "No">
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = ' Completed?') AND
                    </CFIF>
                         (SR.FISCALYEARID >= <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) 
               ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
          </CFQUERY>
          
          <CFQUERY name="LookupServiceRequestsPrevFYs" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SR.SRID, TNSWO.SRID AS WOSRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER,
                         SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME, SR.SERVICEDESKINITIALSID, 
                         SR.REQUESTERID, CUST.FULLNAME, SR.ALTERNATE_CONTACTID, SR.PROBLEM_CATEGORYID, 
                         SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID, SR.GROUPASSIGNEDID, SR.SERVICETYPEID, 
                         SR.ACTIONID, SR.OPERATINGSYSTEMID, SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
                         SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED,TNSWO.WO_NUMBER, TNSWO.WO_STATUS,
                    <CFIF #Client.SecurityFlag# EQ "No">
                         CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || TNSWO.WO_NUMBER  AS LOOKUPKEY
                    <CFELSE>
                         CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER  || ' - ' || SR.SRCOMPLETED || ' - ' || TNSWO.WO_NUMBER || ' - ' || TNSWO.WO_STATUS AS LOOKUPKEY
                    </CFIF>
               FROM		SERVICEREQUESTS SR, TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	(SR.SRID IN (#ValueList(LookupTNSWorkOrders.SRID)#) AND
                         SR.SRID = TNSWO.SRID AND
                         SR.REQUESTERID = CUST.CUSTOMERID) AND
                    <CFIF #Client.SecurityFlag# EQ "No">
                         (SR.SRCOMPLETED = 'NO' OR
                          SR.SRCOMPLETED = ' Completed?') AND
                    </CFIF>
                    	(SR.FISCALYEARID < <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">) 
               ORDER BY	CUST.FULLNAME ASC,  SR.SERVICEREQUESTNUMBER DESC
          </CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TD align="center"><H1>Modify/Delete TNS Work Orders Lookup</H1></TD>
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
	
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=#URL.PROCESS#&LOOKUPWO=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="SRID1">*Requester/SR/WO For Current Fiscal Year & CFY+1:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SRID1" id="SRID1" size="1" required="No" tabindex="2">
						<CFIF #Client.SecurityFlag# EQ "No">
                                   <OPTION value="0">CUSTOMER - Select SR - Select WO </OPTION>
                              <CFELSE>
                                   <OPTION value="0">CUSTOMER - Select SR - Completed? - Select WO - WO Status</OPTION>
                              </CFIF>
                              <CFLOOP query="LookupServiceRequestsCurrFY">
                              	<OPTION value="#SRID#">#LOOKUPKEY#</OPTION>
                              </CFLOOP>  
                         </CFSELECT>
				</TD>
			</TR>
               <TR>
				<TH align="left" width="30%"><H4><LABEL for="SRID2">*Or Requester/SR/WO For Previous Fiscal Years:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SRID2" id="SRID2" size="1" required="No" tabindex="3">
                         	<CFIF #Client.SecurityFlag# EQ "No">
                                   <OPTION value="0">CUSTOMER - Select SR - Select WO </OPTION>
                              <CFELSE>
                                   <OPTION value="0">CUSTOMER - Select SR - Completed? - Select WO - WO Status </OPTION>
                              </CFIF>
                              <CFLOOP query="LookupServiceRequestsPrevFYs">
                              	<OPTION value="#SRID#">#LOOKUPKEY#</OPTION>
                              </CFLOOP>
                         </CFSELECT>
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
************************************************************************
* The following code is the Modify/Delete Process for TNS Work Orders. *
************************************************************************
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
		<CFELSEIF IsDefined("URL.SRID")>
			<CFSET FORM.SRID = #val(URL.SRID)#>
			<CFCOOKIE name="SRID" secure="NO" value="#FORM.SRID#">
		</CFIF>

		<CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
			SELECT	SR.SRID, SR.FISCALYEARID, SR.FISCALYEARSEQNUMBER, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.CREATIONTIME,
                         SR.SERVICEDESKINITIALSID, SR.REQUESTERID, CUST.FULLNAME, LOC.ROOMNUMBER, SR.ALTERNATE_CONTACTID,
                         SR.PROBLEM_CATEGORYID, SR.PROBLEM_SUBCATEGORYID, SR.PRIORITYID, SR.GROUPASSIGNEDID, IDTGROUP.GROUPID, IDTGROUP.GROUPNAME,
                         SR.SERVICETYPEID, SR.ACTIONID, SR.OPERATINGSYSTEMID, SR.OPTIONID, SR.PROBLEM_DESCRIPTION, SR.TOTAL_STAFFTIME, 
                         SR.TOTAL_REFERRALTIME, SR.SRCOMPLETEDDATE, SR.SRCOMPLETED, CUST.FULLNAME || ' - ' ||  SR.SERVICEREQUESTNUMBER AS LOOKUPKEY
               FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC, GROUPASSIGNED IDTGROUP
			WHERE	SR.SRID > 0 AND
					SR.SRID = <CFQUERYPARAM value="#FORM.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SR.REQUESTERID = CUST.CUSTOMERID AND
					CUST.LOCATIONID = LOC.LOCATIONID AND
                    	SR.GROUPASSIGNEDID = IDTGROUP.GROUPID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFQUERY name="GetTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
			SELECT	TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.WO_STATUS, TNSWO.EBA_111, TNSWO.STAFFID, 
               		CUST.FULLNAME, CUST.EMAIL, CUST.CAMPUSPHONE, CUST.LOCATIONID, LOC.ROOMNUMBER, TNSWO.NEW_LOCATION,
                         TNSWO.CURRENT_JACKNUMBER, TNSWO.NEW_JACKNUMBER,  TNSWO.HW_INVENTORYID, TNSWO.WORK_DESCRIPTION,
                         TNSWO.ACCOUNTNUMBER1, TNSWO.ACCOUNTNUMBER2, TNSWO.ACCOUNTNUMBER3, TNSWO.JUSTIFICATION_DESCRIPTION,
                         TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE, TNSWO.WO_NUMBER
			FROM		TNSWORKORDERS TNSWO, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC
			WHERE	TNSWO.SRID = <CFQUERYPARAM value="#GetServiceRequests.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
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

  		<CFQUERY name="GetJackNumbers" datasource="#application.type#FACILITIES">
          	SELECT	WJ.WALLJACKID, WJ.LOCATIONID, LOC.ROOMNUMBER, WJ.WALLDIRID, WD.WALLDIRNAME, WJ.CLOSET, WJ.JACKNUMBER, WJ.PORTLETTER, WJ.CUSTOMERID, CUST.FULLNAME,
					LOC.ROOMNUMBER || ' - ' || WD.WALLDIRNAME || ' - ' || WJ.CLOSET || ' - ' || WJ.JACKNUMBER || ' - ' || WJ.PORTLETTER || ' - ' || CUST.FULLNAME AS KEYFINDER
			FROM		WALLJACKS WJ, LOCATIONS LOC, WALLDIRECTION WD, LIBSHAREDDATAMGR.CUSTOMERS CUST
			WHERE	WJ.WALLJACKID = <CFQUERYPARAM value="#GetTNSWorkOrders.NEW_JACKNUMBER#" cfsqltype="CF_SQL_NUMERIC"> AND
          			WJ.LOCATIONID = LOC.LOCATIONID AND
					WJ.WALLDIRID = WD.WALLDIRID AND
					WJ.CUSTOMERID = CUST.CUSTOMERID
               ORDER BY	LOC.ROOMNUMBER, WD.WALLDIRNAME, WJ.JACKNUMBER, WJ.PORTLETTER
		</CFQUERY>

		<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE">
			SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE,
					HI.OWNINGORGID, HI.MODELNAMEID, MODELNAMELIST.MODELNAME, HI.MODELNUMBERID, MODELNUMBERLIST.MODELNUMBER,
					HI.CUSTOMERID, CUST.FULLNAME, LOC.ROOMNUMBER, HW.WARRANTYEXPIRATIONDATE AS WARDATE, HI.IPADDRESS, HI.MACADDRESS,
					HI.BARCODENUMBER || '-' || CUST.FULLNAME ||'-' || EQT.EQUIPMENTTYPE || '-' || MODELNAMELIST.MODELNAME AS LOOKUPBARCODE
			FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST, MODELNUMBERLIST, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					FACILITIESMGR.LOCATIONS LOC, HARDWAREWARRANTY HW
			WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetTNSWorkOrders.HW_INVENTORYID#" cfsqltype="CF_SQL_NUMERIC"> AND
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
				<TD  align="center"><H1>Modify/Delete TNS Work Orders</H1></TD>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align="center">
					TNS Work Order Key &nbsp; = &nbsp; #GetTNSWorkOrders.TNSWO_ID#<BR />
					TNS Contact Phone: &nbsp;&nbsp;&nbsp;&nbsp;4-3500
					<CFCOOKIE name="TNSWO_ID" secure="NO" value="#GetTNSWorkOrders.TNSWO_ID#">
				</TH>
			</TR>
          </TABLE>
          <BR clear="left" />
          
          <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES")>
               <CFSET PROGRAMNAME = "processtnsworkorders.cfm?STAFFLOOP=YES">
          <CFELSEIF (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
               <CFSET PROGRAMNAME = "processtnsworkorders.cfm?SRCALL=YES">
          <CFELSE>
               <CFSET PROGRAMNAME = "processtnsworkorders.cfm">
          </CFIF>
     
		<TABLE width="100%" align="left" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" valign="TOP">
                    <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="11" /><BR />
                    <CFELSE>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    </CFIF>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="TNSWORKORDER" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
			<TR>
                    <TH align="left" valign="TOP">SR</TH>
                    <TH align="left" valign="TOP">Requestor</TH>
                    <TH align="left" valign="TOP">Group</TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP">
                         #GetServiceRequests.SERVICEREQUESTNUMBER#
                    </TD>
                    <TD align="left" valign ="TOP">
                         #GetServiceRequests.FULLNAME#
                    </TD>
                    <TD align="left" valign="TOP">
                         #GetServiceRequests.GROUPNAME#
                    </TD>
               </TR>
                <TR>
                    <TH align="left" valign="TOP">SR Creation Date</TH>
                    <TH align="left" valign="TOP">Requestor Location</TH>
                    <TH align="left" valign="TOP">Staff Assignment</TH>
               </TR>
               <TR>
                    <TD align="left" valign ="TOP">
                         #DateFormat(GetServiceRequests.CREATIONDATE, 'mm/dd/yyyy')#
                    </TD>
                    <TD align="left" valign ="TOP">
                         #GetServiceRequests.ROOMNUMBER#
                    </TD>
                    <TD align="left" valign="TOP">
                         #GetTNSWorkOrders.FULLNAME#
                    </TD>
               </TR>
               <TR>
                    <TH align="left" valign="TOP"><LABEL for="WO_DUEDATE">TNS WO Due Date</LABEL></TH>
                    <TH align="left" valign="TOP"><LABEL for="WO_TYPE">TNS WO Type</LABEL></TH>
				<TH align="left" valign="TOP">Staff Location</TH>
               </TR>
               <TR>
                    <TD align="left" valign ="TOP">
                         <CFINPUT type="Text" name="WO_DUEDATE" id="WO_DUEDATE" value="#DateFormat(GetTNSWorkOrders.WO_DUEDATE, 'mm/dd/yyyy')#" align="LEFT" required="No" size="15" tabindex="2">
                         <SCRIPT language="JavaScript">
                              new tcal ({'formname': 'TNSWORKORDER','controlname': 'WO_DUEDATE'});
     
                         </SCRIPT>
                    </TD>
                    <TD align="left" valign="TOP">
                         <CFSELECT name="WO_TYPE" id="WO_TYPE" size="1" tabindex="3">
                         <CFIF GetTNSWorkOrders.WO_TYPE NEQ "TNS">
                              <OPTION selected value="#GetTNSWorkOrders.WO_TYPE#">#GetTNSWorkOrders.WO_TYPE#</OPTION>
                         </CFIF>
                              <OPTION value="TNS TYPE">TNS TYPE</OPTION>
                              <OPTION value="NEW">NEW</OPTION>
                              <OPTION value="MOVE">MOVE</OPTION>
                              <OPTION value="REPORT">REPORT</OPTION>
                         </CFSELECT>
                    </TD>
                    <TD align="left" valign="TOP">#GetTNSWorkOrders.ROOMNUMBER#</TD>
               </TR>
			<TR>
				<TH align="left" valign="TOP"><LABEL for="WO_NUMBER">TNS WO Number</LABEL></TH>
                   	<TH align="left" valign="TOP"><LABEL for="WO_STATUS">TNS WO Status</LABEL></TH>
				<TH align="left" valign="TOP">Staff Phone</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="WO_NUMBER" id="WO_NUMBER" value="#GetTNSWorkOrders.WO_NUMBER#" align="LEFT" required="No" size="20" tabindex="4">
				</TD>
                    <TD align="left" valign="TOP">
                         <CFSELECT name="WO_STATUS" id="WO_STATUS" size="1" tabindex="5">
                         	<OPTION selected value="#GetTNSWorkOrders.WO_STATUS#">#GetTNSWorkOrders.WO_STATUS#</OPTION>
                              <OPTION value="PENDING">PENDING</OPTION>
                              <OPTION value="COMPLETE">COMPLETE</OPTION>
                         </CFSELECT>
                    </TD>
				<TD align="left" valign="TOP">#GetTNSWorkOrders.CAMPUSPHONE#</TD>
			</TR>
			<TR>
				<TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
                    <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
				<TH align="left" valign="TOP">Staff E-Mail</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
				<TD align="left" valign="TOP">#GetTNSWorkOrders.EMAIL#</TD>
			</TR>
               <TR>
                    <TH align="left" valign="TOP"><LABEL for="NEW_LOCATION">New Location</LABEL></TH>
                    <TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
                    <TH align="left" valign="TOP"><LABEL for="EBA_111">Involves EBA-111?</LABEL></TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP">
                         <CFSELECT name="NEW_LOCATION" id="NEW_LOCATION" size="1" query="ListLocations" value="LOCATIONID" display="ROOMNUMBER" selected="#GetTNSWorkOrders.NEW_LOCATION#" required="No" tabindex="6"></CFSELECT>
                    </TD>
                    <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="left" valign="top">
                    <CFSELECT name="EBA_111" id="EBA_111" size="1" tabindex="7">
                    	<OPTION selected value="#GetTNSWorkOrders.EBA_111#">#GetTNSWorkOrders.EBA_111#</OPTION>
                         <OPTION value="NO">NO</OPTION>
                         <OPTION value="YES">YES</OPTION>
                    </CFSELECT>
               </TD>
			<TR>
				<TH align="left" valign="TOP" colspan="3"><LABEL for="CURRENT_JACKNUMBER">Current Jack Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP" colspan="3">
					<CFSELECT name="CURRENT_JACKNUMBER" id="CURRENT_JACKNUMBER" size="1" query="ListJackNumbers" value="WALLJACKID" display="KEYFINDER" selected="#GetTNSWorkOrders.CURRENT_JACKNUMBER#" required="No" tabindex="8"></CFSELECT>
				</TD>
                    <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign="TOP"><LABEL for="NEW_JACKNUMBER">New Jack Number</LABEL></TH>
				<TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
				<TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="NEW_JACKNUMBER" id="NEW_JACKNUMBER" size="1" query="ListJackNumbers" value="WALLJACKID" display="KEYFINDER" selected="#GetTNSWorkOrders.NEW_JACKNUMBER#" required="No" tabindex="9"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" colspan="2"><LABEL for="HW_INVENTORYID">Hardware</LABEL></TH>
				
			</TR>
			<TR>
			<CFIF #GetTNSWorkOrders.HW_INVENTORYID# EQ 0>
				<TD align="left" valign="TOP" colspan="2">
					<CFSELECT name="HW_INVENTORYID" id="HW_INVENTORYID" size="1" required="No" tabindex="10">
						<OPTION selected value="0"> EQUIPMENT </OPTION>
						<CFLOOP query = "ListHardware">
							<OPTION value="#HARDWAREID#">#LOOKUPBARCODE#</OPTION>
						</CFLOOP>
					</CFSELECT>
				</TD>
			<CFELSE>
				<TD align="left" valign="TOP" colspan="2">
                    	<CFSELECT name="HW_INVENTORYID" id="HW_INVENTORYID" size="1" required="No" tabindex="10">
						<OPTION value="0"> EQUIPMENT </OPTION>
                              <OPTION selected value="#GetHardware.HARDWAREID#"> #GetHardware.LOOKUPBARCODE# </OPTION> 
						<CFLOOP query = "ListHardware">
							<OPTION value="#HARDWAREID#">#LOOKUPBARCODE#</OPTION>
						</CFLOOP>
					</CFSELECT>
					<!--- <CFSELECT name="HW_INVENTORYID" id="HW_INVENTORYID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPBARCODE" selected="#GetTNSWorkOrders.HW_INVENTORYID#" required="No" tabindex="10"></CFSELECT> --->
				</TD>
			</CFIF>
               	<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left" valign="TOP">Model Name / Number</TH>
				<TH align="left" valign="TOP">Property ID</TH>
				<TH align="left" valign="TOP">Serial Number</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					#GetHardware.MODELNAME# / #GetHardware.MODELNUMBER#
				</TD>
				<TD align="left" valign="TOP">
                    	#GetHardware.STATEFOUNDNUMBER#
                    </TD>
				<TD align="left" valign="TOP">
                    	#GetHardware.SERIALNUMBER#
                    </TD>
			</TR>
               <TR>
				<TH align="left" valign="TOP">IP Address</TH>
				<TH align="left" valign="TOP">MAC Address</TH>
				<TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					#GetHardware.IPADDRESS#
				</TD>
				<TD align="left" valign="TOP">
                    	#GetHardware.MACADDRESS#
                    </TD>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
               <TR>
                    <TH align="left" valign="TOP"><H4><LABEL for="WORK_DESCRIPTION">*Work Description</LABEL></H4></TH>
                    <TH align="left" valign="TOP"><LABEL for="JUSTIFICATION_DESCRIPTION">*Justification Description</LABEL></TH>
                    <TH align="left" valign="TOP"><LABEL for="OTHER_DESCRIPTION">Other Description</LABEL></TH>
               </TR>
			<TR>
                    <TD align="left" valign="TOP">
                         <TEXTAREA name="WORK_DESCRIPTION" id="WORK_DESCRIPTION" rows="10" cols="45" wrap="VIRTUAL" required tabindex="11">#GetTNSWorkOrders.WORK_DESCRIPTION# </TEXTAREA>
                    </TD>
                    <TD align="left" valign="TOP">
                         <TEXTAREA name="JUSTIFICATION_DESCRIPTION" id="JUSTIFICATION_DESCRIPTION" rows="10" cols="45" wrap="VIRTUAL" required tabindex="12">#GetTNSWorkOrders.JUSTIFICATION_DESCRIPTION# </TEXTAREA>
                    </TD>
                    <TD align="left" valign="TOP">
                         <TEXTAREA name="OTHER_DESCRIPTION" id="OTHER_DESCRIPTION" rows="10" cols="45" wrap="VIRTUAL" required tabindex="13">#GetTNSWorkOrders.OTHER_DESCRIPTION# </TEXTAREA>
                    </TD>
               </TR>

		<CFIF #GetTNSWorkOrders.WO_TYPE# NEQ 'REPORT'>
			<TR>
				<TH align="left" valign="TOP">Account Number 1</TH>
				<TH align="left" valign="TOP"><H4><LABEL for="ACCOUNTNUMBER2">*Account Number 2</LABEL></H4></TH>
				<TH align="left" valign="TOP">Account Number 3</TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					#GetTNSWorkOrders.ACCOUNTNUMBER1#
				</TD>
                    <TD align="left" valign ="TOP">
                    <CFIF #GetTNSWorkOrders.ACCOUNTNUMBER2# EQ "" OR #GetTNSWorkOrders.ACCOUNTNUMBER2# EQ " ">
                    	<CFINPUT type="Text" name="ACCOUNTNUMBER2" id="ACCOUNTNUMBER2" value="1006" align="LEFT" required="No" size="4" maxlength="4" tabindex="14">
                    <CFELSE>	
					<CFINPUT type="Text" name="ACCOUNTNUMBER2" id="ACCOUNTNUMBER2" value="#GetTNSWorkOrders.ACCOUNTNUMBER2#" align="LEFT" required="No" size="4" maxlength="4" tabindex="14">
                    </CFIF>
				</TD>
				<TD align="left" valign ="TOP">
					#GetTNSWorkOrders.ACCOUNTNUMBER3#
				</TD>
			</TR>
		</CFIF>
			<TR>
				<TD align="left" valign="TOP">
                    	<INPUT type="hidden" name="PROCESSTNSWORKORDERS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="15" />
                    </TD>
				<TD align="left" valign="TOP">
                    	<INPUT type="image" src="/images/buttonMODReview.jpg" value="MODIFY AND REVIEW" alt="Modify & Review" onClick="return setModReview();" tabindex="16" />
                    </TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="17" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" valign="TOP" colspan="2">
                    <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="18" /><BR />
                    <CFELSE>
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="18" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    </CFIF>
				</TD>
</CFFORM>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>