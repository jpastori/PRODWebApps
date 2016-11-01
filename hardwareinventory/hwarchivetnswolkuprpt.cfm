<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hwarchivetnswolkuprpt.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/24/2015 --->
<!--- Date in Production: 09/24/2015 --->
<!--- Module: Hardware Inventory - SR TNS Work Order Lookup Report --->
<!-- Last modified by John R. Pastori on 09/24/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/hwarchivetnswolkuprpt.cfm">
<CFSET CONTENT_UPDATED = "September 24, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Hardware Inventory - SR TNS Work Order Lookup Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Hardware Inventory - SR TNS Work Order Lookup Report";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}
	
//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<BODY>

<!--- 
**********************************************************************************************************
* The following code is the IDT Hardware Inventory - SR TNS Work Order Lookup Report Generation Process. *
**********************************************************************************************************
 --->
          
<CFQUERY name="LookupTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
    SELECT		TNSWO.TNSWO_ID, TNSWO.SRID, TNSWO.WO_TYPE, TNSWO.HW_INVENTORYID, TNSWO.WO_STATUS, TNSWO.STAFFID, TNSWO.CURRENT_JACKNUMBER, 
    			TNSWO.NEW_JACKNUMBER, TNSWO.WORK_DESCRIPTION, TNSWO.JUSTIFICATION_DESCRIPTION, TNSWO.OTHER_DESCRIPTION, TNSWO.WO_DUEDATE,
                TNSWO.WO_NUMBER, TNSWO.EBA_111, TNSWO.NEW_LOCATION
    FROM		TNSWORKORDERS TNSWO
    WHERE		TNSWO.TNSWO_ID IN (#URL.TNSWO_ID#) AND
                NOT TNSWO.WO_TYPE LIKE ('%PHONE%')
    ORDER BY	TNSWO.WO_TYPE
</CFQUERY>


<CFIF LookupTNSWorkOrders.RecordCount EQ 0>
    <SCRIPT language="JavaScript">
        <!-- 
            alert ("There are no matching SR TNS Work Order records.");
        -->
    </SCRIPT>
  <!---   <META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" /> --->
    <CFEXIT>
</CFIF>

<TABLE width="100%" align="center" border="3">
<TR align="center">
    <TH align="center">
        <H1>Hardware Inventory - SR TNS Work Order Lookup Report </H1>
       </TH>
</TR>
</TABLE>
<BR />
<TABLE border="0">
    <TR>
        <TD align="left">
           <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="1" />
        </TD>
    </TR>
    <TR>
        <TH align="center" valign="bottom">SR</TH>
        <TH align="center" valign="bottom">Creation <BR> Date</TH>
        <TH align="center" valign="bottom">WO <BR> Type</TH>
        <TH align="center" valign="bottom">WO <BR> Status</TH>
        <TH align="center" valign="bottom">WO <BR> Number</TH>
        <TH align="center" valign="bottom">WO <BR> Due Date</TH>
        <TH align="center">Current <BR> Jack</TH>
        <TH align="center" valign="bottom">New <BR> Jack</TH>
        <TH align="center" valign="bottom">Staff <BR> Assigned</TH>
    </TR>
      
<CFLOOP query="LookupTNSWorkOrders">
       	
    <CFSET RECORDCOUNT = RECORDCOUNT + 1> 
      
    <CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
        SELECT		SR.SRID, SR.SERVICEREQUESTNUMBER, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATIONDATE,
                	TO_CHAR(SR.CREATIONTIME, 'HH:MI:SS AM') AS CREATIONTIME, TNSWO.SRID, TNSWO.STAFFID,
                	SRSA.STAFF_ASSIGNEDID, WGA.STAFFCUSTOMERID, SR.REQUESTERID, CUST.FULLNAME
        FROM		SERVICEREQUESTS SR, TNSWORKORDERS TNSWO, SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST
        WHERE		(SR.SRID = #LookupTNSWorkOrders.SRID# AND
                	SR.SRID = TNSWO.SRID AND
                	TNSWO.SRID = SRSA.SRID AND
                    SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                    WGA.STAFFCUSTOMERID = CUST.CUSTOMERID) AND
                    (SR.SRCOMPLETED = 'NO' OR
                    SR.SRCOMPLETED = 'YES' OR
                    SR.SRCOMPLETED = ' Completed?')
        ORDER BY	SR.SERVICEREQUESTNUMBER
    </CFQUERY>
           
    <CFQUERY name="LookupCurrentWalljacks" datasource="#application.type#FACILITIES" blockfactor="100">
        SELECT		CURRWJ.WALLJACKID, CURRWJ.HARDWAREID, CURRWJ.JACKNUMBER, CURRWJ.CLOSET || ' - ' || CURRWJ.JACKNUMBER || ' - ' || CURRWJ.PORTLETTER AS CURRENTJACK
        FROM		WALLJACKS CURRWJ
        WHERE		CURRWJ.WALLJACKID = #LookupTNSWorkOrders.CURRENT_JACKNUMBER#
        ORDER BY	CURRWJ.WALLJACKID
    </CFQUERY>
    
    <CFQUERY name="LookupNewWalljacks" datasource="#application.type#FACILITIES" blockfactor="100">
        SELECT		NEWWJ.WALLJACKID, NEWWJ.HARDWAREID, NEWWJ.CLOSET || ' - ' || NEWWJ.JACKNUMBER || ' - ' || NEWWJ.PORTLETTER AS NEWJACK
        FROM		WALLJACKS NEWWJ
        WHERE		NEWWJ.WALLJACKID = #LookupTNSWorkOrders.NEW_JACKNUMBER#
        ORDER BY	NEWWJ.WALLJACKID
    </CFQUERY>

    <CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE">
        SELECT		HI.HARDWAREID, HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE,
                	HI.OWNINGORGID, HI.MODELNAMEID, MODELNAMELIST.MODELNAME, HI.MODELNUMBERID, MODELNUMBERLIST.MODELNUMBER
        FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST, MODELNUMBERLIST
        WHERE		HI.HARDWAREID = <CFQUERYPARAM value="#LookupTNSWorkOrders.HW_INVENTORYID#" cfsqltype="CF_SQL_NUMERIC"> AND
                	HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND
                	HI.MODELNAMEID = MODELNAMELIST.MODELNAMEID AND
                	HI.MODELNUMBERID = MODELNUMBERLIST.MODELNUMBERID
        ORDER BY	HI.BARCODENUMBER, EQT.EQUIPMENTTYPE, MODELNAMELIST.MODELNAME
    </CFQUERY>

    <TR>
        <TD align="center" valign="TOP"><DIV>#LookupServiceRequests.SERVICEREQUESTNUMBER#</DIV></TD>
        <TD align="center" valign="TOP"><DIV>#DateFormat(LookupServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</DIV></TD>
        <TD align="center" valign="TOP"><DIV>#LookupTNSWorkOrders.WO_TYPE#</DIV></TD>
        <TD align="center" valign="TOP"><DIV>#LookupTNSWorkOrders.WO_STATUS#</DIV></TD>
        <TD align="center" valign="TOP"><DIV>#LookupTNSWorkOrders.WO_NUMBER#</DIV></TD>
        <TD align="center" valign="TOP"><DIV>#DateFormat(LookupTNSWorkOrders.WO_DUEDATE, "mm/dd/yyyy")#</DIV></TD>
        <TD align="center" valign="TOP"><DIV>#LookupCurrentWalljacks.CURRENTJACK#</DIV></TD>
        <TD align="center" valign="TOP"><DIV>#LookupNewWalljacks.NEWJACK#</DIV></TD>
        <TD align="center" valign="TOP"><DIV>#LookupServiceRequests.FULLNAME#</DIV></TD>
    </TR>
    <TR>
        <TH align="LEFT" valign="TOP">Work Description:</TH>
        <TD align="LEFT" valign="TOP" colspan="2">
            <DIV>&nbsp;&nbsp;#LookupTNSWorkOrders.WORK_DESCRIPTION#</DIV>
           </TD>
        <TH align="LEFT" valign="TOP">Justification Description:</TH>
        <TD align="LEFT" valign="TOP" colspan="2">
            <DIV>&nbsp;&nbsp;#LookupTNSWorkOrders.JUSTIFICATION_DESCRIPTION#</DIV>
           </TD>
        <TH align="LEFT" valign="TOP">Other Description:</TH>
        <TD align="LEFT" valign="TOP" colspan="2">
            <DIV>&nbsp;&nbsp;#LookupTNSWorkOrders.OTHER_DESCRIPTION#</DIV>
           </TD>
    </TR>
      <TR>
        <TD align="left" >&nbsp;&nbsp;</TD>
    </TR>
      <TR>
         <TH align="left" valign="TOP">Hardware Barcode:</TH>
           <TD align="left" valign="TOP">
                <DIV>&nbsp;&nbsp;#LookupHardware.BARCODENUMBER#</DIV>
           </TD>
           <TH align="left" valign="TOP">Model Name / Number:</TH>
           <TD align="left" valign="TOP" colspan="2">
                <DIV>&nbsp;&nbsp;#LookupHardware.MODELNAME# / #LookupHardware.MODELNUMBER#</DIV>
           </TD>
           <TH align="left" valign="TOP">Property ID:</TH>
           <TD align="left" valign="TOP">
                <DIV>&nbsp;&nbsp;#LookupHardware.STATEFOUNDNUMBER#</DIV>
           </TD>
           <TH align="left" valign="TOP">Serial Number:</TH>
           <TD align="left" valign="TOP">
                <DIV>&nbsp;&nbsp;#LookupHardware.SERIALNUMBER#</DIV>
           </TD>
      </TR>
      <TR>
        <TD align="left" valign="TOP" colspan="9"><HR></TD>
    </TR>
</CFLOOP>
    <TR>
        <TH align="CENTER" colspan="10">
           <CFIF RECORDCOUNT GT 0>
            <CFSET RECORDCOUNT = RECORDCOUNT - 1>
           </CFIF>
            <H2>#RECORDCOUNT# TNS Work Order records were selected.
        </H2></TH>
    </TR>
    <TR>
		<TD align="left">
           <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" onClick="window.close();" tabindex="2" />
        </TD>
    </TR>
    <TR>
        <TD colspan="10">
            <CFINCLUDE template="/include/coldfusion/footer.cfm">
        </TD>
    </TR>
</TABLE>


</BODY>
</CFOUTPUT>
</HTML>