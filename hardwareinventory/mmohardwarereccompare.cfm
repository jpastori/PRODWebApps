<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: mmohardwarereccompare.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Compare MMO Hardware & Hardware Inventory Records --->
<!-- Last modified by John R. Pastori on 09/25/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/mmohardwarereccompare.cfm">
<CFSET CONTENT_UPDATED = "September 25, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HEAD>
	<META http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<TITLE>Compare MMO Hardware & Hardware Inventory Records</TITLE>
     <LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<!--- Read Oracle MMO Hardware Table. --->

     <CFQUERY name="ReadMMOHardwareRecsTable" datasource="#application.type#HARDWARE" blockfactor="100">
     	SELECT	MMOHW_ID, STATEFOUNDNUMBER, SERIALNUMBER, BUILDINGCODE, ROOMNUMBER, SPACE, PURCHASEORDERNUMBER, ORGCODE,
          		ROOMNUMBER || SPACE As ROOMSPACE
          FROM 	MMOHARDWARE
          WHERE	MMOHW_ID > 0
          ORDER BY	STATEFOUNDNUMBER 
     </CFQUERY>
     

<!--- Display Web Page Headings. --->
     <TABLE width="100%" align="center" border="3">
          <TR align="center">
               <TH align="center"><H1>Compare MMO Hardware & Hardware Inventory Records</H1></TH>
          </TR>
     </TABLE>
     <TABLE width="100%" align="LEFT" border="0">
          <TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
               <TD align="left" colspan="9">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
          </TR>
     <CFSET BldgAbbrevRoomNum = ''>
     <CFSET BuildRoomNumber = ''>
     <CFSET FormRecordCount = 0>
	<CFSET ReadRecordCount = 0>
     <CFSET TabCount = 1>

<CFFORM name="MMOHARDWUPDATE" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processmmohardwupdate.cfm" method="POST" ENABLECAB="Yes">
          <TR align="center">
               <TH align="center" colspan="9"><HR></TH>
          </TR> 
  		<TR>
               <TD align="left" colspan="9">
                    <CFSET TabCount = #TabCount# + 1>	
              		<INPUT type="image" src="/images/buttonUpdateInventory.jpg" value="UPDATEINVENTORY" alt="Update Inventory" tabindex="#val(TabCount)#" />
               </TD>
          </TR>
          <TR>
			<TD align="center" colspan="9">           
                   <H2> Records Compared Count = #ReadMMOHardwareRecsTable.RecordCount# </H2>
               </TD>
          </TR>
          <TR> 
               <TH align="center" colspan="9"><HR></TH>
          </TR>
        	<TR>
               <TH align="center" valign="BOTTOM">Record Name</TH>
               <TH align="center" valign="BOTTOM">Last Mod Date</TH>
               <TH align="center" valign="BOTTOM">State Found No.</TH>
               <TH align="center" valign="BOTTOM">Serial No.</TH>
               <TH align="center" valign="BOTTOM">P.O. No.</TH>
               <TH align="center" valign="BOTTOM">FY of <BR>Hardware</TH>
               <TH align="center" valign="BOTTOM">Building Code</TH>
               <TH align="center" valign="BOTTOM">Room No.</TH>
               <TH align="center" valign="BOTTOM">Org Code</TH>
           </TR>
           <TR align="center">
               <TH align="center" colspan="9"><HR></TH>
          </TR>


     
     <CFLOOP query="ReadMMOHardwareRecsTable">
     
     	<CFSET ChangeDataCount = 0> 
     	
          <CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	HI.HARDWAREID, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID, LOC.ROOMNUMBER, 
               		LOC.BUILDINGNAMEID, BN.BUILDINGNAME, BN.BUILDINGCODE, HI.PURCHASEORDERNUMBER, HI.FISCALYEARID, FY.FISCALYEAR_4DIGIT,
                         HI.OWNINGORGID, OC.ORGCODEID, OC.ORGCODE, HI.DATECHECKED
			FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC, FACILITIESMGR.BUILDINGNAMES BN, LIBSHAREDDATAMGR.ORGCODES OC,
               		LIBSHAREDDATAMGR.FISCALYEARS FY
			WHERE	HI.STATEFOUNDNUMBER = <CFQUERYPARAM value="#ReadMMOHardwareRecsTable.STATEFOUNDNUMBER#" cfsqltype="CF_SQL_VARCHAR"> AND
               		HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
                         LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
                         HI.OWNINGORGID = OC.ORGCODEID AND
                         HI.FISCALYEARID = FY.FISCALYEARID
			ORDER BY	HI.STATEFOUNDNUMBER
		</CFQUERY>
          
          <CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
               SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGABBREV
               FROM		BUILDINGNAMES
               WHERE	BUILDINGCODE = <CFQUERYPARAM value="#ReadMMOHardwareRecsTable.BUILDINGCODE#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	BUILDINGNAME
          </CFQUERY>
          
          <CFQUERY name="LookupOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
               SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION
               FROM		ORGCODES
               WHERE	ORGCODE = <CFQUERYPARAM value="#ReadMMOHardwareRecsTable.ORGCODE#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	ORGCODE
          </CFQUERY>
          
          <CFSET ReadRecordCount = #ReadRecordCount# + 1>

		<CFIF LEFT(#ReadMMOHardwareRecsTable.ROOMSPACE#,1) EQ 0>
			<CFSET BuildRoomNumber = MID(#ReadMMOHardwareRecsTable.ROOMSPACE#, 2, LEN(#ReadMMOHardwareRecsTable.ROOMSPACE#))>
		<CFELSE>
			<CFSET BuildRoomNumber = #ReadMMOHardwareRecsTable.ROOMSPACE#>
		</CFIF>
		<CFSET BldgAbbrevRoomNum = #LookupBuildings.BUILDINGABBREV# & #BUILDROOMNUMBER#>
          <CFIF LookupHardware.Recordcount GT 0> 
          
          	 <TR>
                    <TD align="LEFT" valign="TOP">Hardware Inventory Record</TD>
                    <TD align="center" valign="TOP"><DIV>#DateFormat(LookupHardware.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
                    <TD align="LEFT" valign="TOP"><DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LookupHardware.STATEFOUNDNUMBER#</DIV></TD>
                    <TD align="LEFT" valign="TOP"><DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LookupHardware.SERIALNUMBER#</DIV></TD>
                    <TD align="LEFT" valign="TOP"><DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LookupHardware.PURCHASEORDERNUMBER#</DIV></TD>
                    <TD align="center" valign="TOP" nowrap><DIV>#LookupHardware.FISCALYEAR_4DIGIT#</DIV></TD>
                    <TD align="center" valign="TOP" nowrap><DIV>#LookupHardware.BUILDINGCODE#</DIV></TD>
				<TD align="LEFT" valign="TOP" nowrap><DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#LookupHardware.ROOMNUMBER#</DIV></TD>
                    <TD align="LEFT" valign="TOP" nowrap><DIV>&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp;#LookupHardware.ORGCODE#</DIV></TD>
                </TR>
                <TR>
                    <TD align="center" colspan="7">&nbsp;&nbsp;</TD>
                </TR>
			<CFSET FormRecordCount = #FormRecordCount# + 1>
          	<CFSET TabCount = #TabCount# + 1>
           
          	 <TR>
                    <TD align="LEFT" valign="TOP">MMO Hardware Record</TD>
                    <TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="LEFT" valign="TOP">
                    	<CFINPUT type="CheckBox" name="MMOHARDWREC#FormRecordCount#" id="MMOHARDWREC#FormRecordCount#" value="#ReadMMOHardwareRecsTable.STATEFOUNDNUMBER#" align="LEFT" required="No" tabindex="#val(TabCount)#">
                    	<DIV>#ReadMMOHardwareRecsTable.STATEFOUNDNUMBER#</DIV>
                    </TD>
                    <TD align="LEFT" valign="TOP">
                    	<CFINPUT type="CheckBox" name="MMOHARDWREC#FormRecordCount#" id="MMOHARDWREC#FormRecordCount#" value="1" align="LEFT" required="No" tabindex="#val(TabCount)#">
                    	<DIV>#ReadMMOHardwareRecsTable.SERIALNUMBER#</DIV>
                    </TD>
                    <TD align="LEFT" valign="TOP">
                    	<CFINPUT type="CheckBox" name="MMOHARDWREC#FormRecordCount#" id="MMOHARDWREC#FormRecordCount#" value="2" align="LEFT" required="No" tabindex="#val(TabCount)#">
                    	<DIV>#ReadMMOHardwareRecsTable.PURCHASEORDERNUMBER#</DIV>
                    </TD>
                    <TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="center" valign="TOP" nowrap>
                    	<DIV>#ReadMMOHardwareRecsTable.BUILDINGCODE#</DIV>
                    </TD>
				<TD align="LEFT" valign="TOP" nowrap>
                    	<CFINPUT type="CheckBox" name="MMOHARDWREC#FormRecordCount#" id="MMOHARDWREC#FormRecordCount#" value="3" align="LEFT" required="No" tabindex="#val(TabCount)#">
                    	<DIV>#BldgAbbrevRoomNum#</DIV>
                    </TD>
                    <TD align="LEFT" valign="TOP" nowrap>
                    	<CFINPUT type="CheckBox" name="MMOHARDWREC#FormRecordCount#" id="MMOHARDWREC#FormRecordCount#" value="4" align="LEFT" required="No" tabindex="#val(TabCount)#">
                    	<DIV>#ReadMMOHardwareRecsTable.ORGCODE#</DIV>
                    </TD>
               </TR>
         
          <CFELSE>
         
         		<TR>
                    <TD align="LEFT" valign="TOP">MMO Hardware Record</TD>
                    <TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="center" valign="TOP"><DIV>#ReadMMOHardwareRecsTable.STATEFOUNDNUMBER#</DIV></TD>
                    <TD align="center" valign="TOP"><DIV>#ReadMMOHardwareRecsTable.SERIALNUMBER#</DIV></TD>
                    <TD align="center" valign="TOP"><DIV>#ReadMMOHardwareRecsTable.PURCHASEORDERNUMBER#</DIV></TD>
                    <TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
                    <TD align="center" valign="TOP" nowrap><DIV>#ReadMMOHardwareRecsTable.BUILDINGCODE#</DIV></TD>
				<TD align="center" valign="TOP" nowrap><DIV>#BldgAbbrevRoomNum#</DIV></TD>
                    <TD align="center" valign="TOP" nowrap><DIV>#ReadMMOHardwareRecsTable.ORGCODE#</DIV></TD>
               </TR> 
               
          </CFIF> 
                
          <CFIF LookupHardware.Recordcount GT 0>       

          	<TR>
                    <TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
			<CFIF (LookupHardware.SERIALNUMBER EQ "") AND NOT (ReadMMOHardwareRecsTable.SERIALNUMBER EQ "")>
<!---
               	<CFQUERY name="ModifyHardwareSN" datasource="#application.type#HARDWARE">
                         UPDATE	HARDWAREINVENTORY
                         SET		SERIALNUMBER = '#ReadMMOHardwareRecsTable.SERIALNUMBER#'
                         WHERE	HARDWAREID = #LookupHardware.HARDWAREID#
                    </CFQUERY>
--->
                
                    <TD align="center" valign="TOP">Serial Number Changed</TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 

              <CFELSEIF LookupHardware.SERIALNUMBER NEQ ReadMMOHardwareRecsTable.SERIALNUMBER>
 
                    <TD align="center" valign="TOP"><DIV>Serial Numbers <BR>DO NOT MATCH!</DIV></TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 
                    
              <CFELSE>
              		<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
                   
              </CFIF>
               
              <CFIF (LookupHardware.PURCHASEORDERNUMBER EQ "" OR LookupHardware.PURCHASEORDERNUMBER EQ "0") AND NOT (ReadMMOHardwareRecsTable.PURCHASEORDERNUMBER EQ "")>
<!---                
				<CFQUERY name="ModifyHardwarePO" datasource="#application.type#HARDWARE">
                         UPDATE	HARDWAREINVENTORY
                         SET		PURCHASEORDERNUMBER = '#ReadMMOHardwareRecsTable.PURCHASEORDERNUMBER#'
                         WHERE	HARDWAREID = #LookupHardware.HARDWAREID#
                    </CFQUERY>
 --->
                    <TD align="center" valign="TOP"><DIV>Purchase Order Number Changed</DIV></TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 

		    <CFELSEIF LookupHardware.PURCHASEORDERNUMBER NEQ ReadMMOHardwareRecsTable.PURCHASEORDERNUMBER>
                    
                    <TD align="center" valign="TOP"><DIV>Purchase Order Numbers <BR>DO NOT MATCH!</DIV></TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 
      
              <CFELSE>
              		<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
                     
              </CFIF>
              
              		<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
               
              <CFIF LookupHardware.BUILDINGCODE NEQ ReadMMOHardwareRecsTable.BUILDINGCODE>

                    <TD align="center" valign="TOP"><DIV>Building Codes <BR>DO NOT MATCH!</DIV></TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 
      
              <CFELSE>
                    <TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>

              </CFIF>

                                           
              <CFQUERY name="LookupRoomNumber" datasource="#application.type#FACILITIES" blockfactor="100">
                    SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, LOC.BUILDINGNAMEID, BN.BUILDINGCODE, BN.BUILDINGNAME
                    FROM		LOCATIONS LOC, BUILDINGNAMES BN
                    WHERE	LOC.LOCATIONID > 0 AND
                              LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
                              BN.BUILDINGCODE = <CFQUERYPARAM value="#ReadMMOHardwareRecsTable.BUILDINGCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
                         	LOC.ROOMNUMBER = <CFQUERYPARAM value="#BldgAbbrevRoomNum#" cfsqltype="CF_SQL_VARCHAR">
              </CFQUERY>
              
              <CFIF (LookupHardware.EQUIPMENTLOCATIONID EQ 0) AND (ReadMMOHardwareRecsTable.ROOMNUMBER GT "1")>
               
               	<CFQUERY name="ModifyEquipLocID" datasource="#application.type#HARDWARE">
                         UPDATE	HARDWAREINVENTORY
                         SET		EQUIPMENTLOCATIONID = '#LookupRoomNumber.LOCATIONID#'
                         WHERE	HARDWAREID = #LookupHardware.HARDWAREID#
                    </CFQUERY>
                    
                    <TD align="center" valign="TOP"><DIV>Room Number Changed</DIV></TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 
               
                <CFELSEIF #LookupHardware.ROOMNUMBER# NEQ #BldgAbbrevRoomNum#>
                    <TD align="center" valign="TOP"><DIV>Room Numbers <BR>DO NOT MATCH!</DIV></TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 
      
              <CFELSE>
              		<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>

              </CFIF>
              
              <CFIF (LookupHardware.ORGCODE EQ "") AND NOT (ReadMMOHardwareRecsTable.ORGCODE EQ "")>
               
               	<CFQUERY name="ModifyHardwareOC" datasource="#application.type#HARDWARE">
                         UPDATE	HARDWAREINVENTORY
                         SET		OWNINGORGID = '#LookupOrgCodes.ORGCODEID#'
                         WHERE	HARDWAREID = #LookupHardware.HARDWAREID#
                    </CFQUERY>
 
                
                    <TD align="center" valign="TOP">Org Code Changed</TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 

              <CFELSEIF LookupHardware.ORGCODE NEQ ReadMMOHardwareRecsTable.ORGCODE>
 
                    <TD align="center" valign="TOP"><DIV>Org Codes <BR>DO NOT MATCH!</DIV></TD>
                    <CFSET ChangeDataCount = #ChangeDataCount# + 1> 
                    
              <CFELSE>
              		<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
                   
              </CFIF>
              </TR> 
              <CFIF #ChangeDataCount# EQ 0>
               <TR>
                    <TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
                    <TD align="center" valign="TOP" colspan="3">ALL FIELDS MATCHED</TD>
                    <TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
               </TR>
		    </CFIF>
          <CFELSE>
          	<TR>
                    <TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
                    <TD align="center" valign="TOP"colspan="3">NO MATCHING HARDWARE INVENTORY RECORD FOUND!</TD>
                    <TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
               </TR>
          </CFIF>
          	<TR align="center">
                    <TH align="center" colspan="9"><HR></TH>
               </TR> 
     </CFLOOP>
     		<TR>
				<TD align="left" colspan="9">
                    	<CFSET TabCount = #TabCount# + 1>
               		<INPUT type="image" src="/images/buttonUpdateInventory.jpg" value="UPDATEINVENTORY" alt="Update Inventory" tabindex="#val(TabCount)#" />	
				</TD>
			</TR>
</CFFORM>
          <TR>
			<TD align="center" colspan="7">
                   
                   <H2> Records Compared Count = #ReadRecordCount# </H2>
               </TD>
          </TR>
          <TR align="center">
               <TH align="center" colspan="9"><HR></TH>
          </TR>
          <TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="7">
               	<CFSET TabCount = #TabCount# + 1>	
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="#val(TabCount)#" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="9">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
     
</CFOUTPUT>
</BODY>
</HTML>