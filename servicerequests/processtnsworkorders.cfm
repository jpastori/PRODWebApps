<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processtnsworkorders.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: Process Information to IDT Service Requests - TNS Work Orders --->
<!-- Last modified by John R. Pastori on 02/11/2016 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML> 
<HEAD>
	<TITLE>Process Information to IDT Service Requests - TNS Work Orders</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FIND('CANCEL', #FORM.PROCESSTNSWORKORDERS#, 1) EQ 0>
	<CFIF IsDefined('FORM.WO_DUEDATE') AND #FORM.WO_DUEDATE# NEQ ''>
		<CFSET FORM.WO_DUEDATE = #DateFormat(FORM.WO_DUEDATE, 'dd-mmm-yyyy')#>
	</CFIF>
</CFIF>

<CFIF (FIND('ADD', #FORM.PROCESSTNSWORKORDERS#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSTNSWORKORDERS#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSTNSWORKORDERS#, 1) EQ 0)>
	<CFQUERY name="ModifyTNSWorkOrderItems" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	TNSWORKORDERS
		SET		WO_TYPE = '#FORM.WO_TYPE#',
				WO_STATUS = '#FORM.WO_STATUS#',
               <CFIF IsDefined('FORM.STAFFID')>
				STAFFID = #val(FORM.STAFFID)#,
               </CFIF>
				CURRENT_JACKNUMBER = #val(FORM.CURRENT_JACKNUMBER)#,
				NEW_JACKNUMBER = #val(FORM.NEW_JACKNUMBER)#,
               <CFIF IsDefined('FORM.HW_INVENTORYID')>
				HW_INVENTORYID = #val(FORM.HW_INVENTORYID)#,
               </CFIF>
			<CFIF IsDefined('FORM.ACCOUNTNUMBER2')>
				ACCOUNTNUMBER2 = '#FORM.ACCOUNTNUMBER2#',
			</CFIF>
			<CFIF IsDefined('FORM.WO_DUEDATE') AND #FORM.WO_DUEDATE# NEQ "">
				WO_DUEDATE = TO_DATE('#FORM.WO_DUEDATE#', 'DD-MON-YYYY'),
			</CFIF>
			<CFIF IsDefined('FORM.WO_NUMBER') AND #FORM.WO_NUMBER# NEQ "">
				WO_NUMBER = UPPER('#FORM.WO_NUMBER#'),
			</CFIF>
				WORK_DESCRIPTION = UPPER('#FORM.WORK_DESCRIPTION#'),
                    JUSTIFICATION_DESCRIPTION = UPPER('#FORM.JUSTIFICATION_DESCRIPTION#'),
                    OTHER_DESCRIPTION = UPPER('#FORM.OTHER_DESCRIPTION#'),
                    NEW_LOCATION = #val(FORM.NEW_LOCATION)#,
                    EBA_111 = UPPER('#FORM.EBA_111#')
		WHERE	(TNSWO_ID = #val(Cookie.TNSWO_ID)#)
	</CFQUERY>
	<CFIF FIND('ADD', #FORM.PROCESSTNSWORKORDERS#, 1) NEQ 0>
		<H1>Data ADDED!</H1>
          <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
			<SCRIPT language="JavaScript">
                    <!-- 
					alert("Data Added!");
                         window.close();
                    -->
               </SCRIPT>
               <CFEXIT>
          </CFIF>
		<SCRIPT language="JavaScript">
			<!-- 
				window.open("/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=ADD&SRID=#val(Cookie.SRID)#","Add New Staff Assignment for TNS Work Order", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25"); window.close();
			-->
		</SCRIPT>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=ADD" />
          <CFEXIT>
	<CFELSEIF FIND('MODIFY', #FORM.PROCESSTNSWORKORDERS#, 1) NEQ 0>
		<H1>Data MODIFIED!</H1>
		<CFIF #FORM.PROCESSTNSWORKORDERS# EQ "MODIFY AND REVIEW">
          	<CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
               	<SCRIPT language="JavaScript">
					<!-- 
						window.open("/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=SUBMIT&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#val(Cookie.SRID)#",
                          				  "Submit TNS Requests","alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25"); window.close();
					-->
				</SCRIPT>
                    <CFEXIT>
               <CFELSE>	
				<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=SUBMIT&SRID=#val(Cookie.SRID)#&LOOKUPWO=FOUND" />
                    <CFEXIT>
               </CFIF>
		<CFELSE>
          	<CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
				<SCRIPT language="JavaScript">
                         <!-- 
                              alert("Data Modified!");
                              window.close();
                         -->
                    </SCRIPT>
                    <CFEXIT>
               </CFIF>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE" />
		</CFIF>
	</CFIF>
</CFIF>

</CFOUTPUT>

<CFIF IsDefined('FORM.WO_STATUS') AND FORM.WO_STATUS EQ "COMPLETE"> 
	
     <CFQUERY name="GetServiceRequests" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, CUST.FULLNAME, CUST.EMAIL
          FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	SR.SRID > 0 AND
                    SR.SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    SR.REQUESTERID = CUST.CUSTOMERID
          ORDER BY	SR.SERVICEREQUESTNUMBER DESC
     </CFQUERY>
	
	<CFMAIL type="HTML" 
		to="#GetServiceRequests.EMAIL#" 
		from="libinfosys@mail.sdsu.edu"
		subject="TNS Network Work Order is COMPLETE"
 	>
     
The TNS Work Order Number #UCase(FORM.WO_NUMBER)# associated with SR Number #GetServiceRequests.SERVICEREQUESTNUMBER# is COMPLETE.      
     
     </CFMAIL> 

</CFIF>
     
<CFIF FIND('SUBMIT', FORM.PROCESSTNSWORKORDERS, 1) NEQ 0> 
	<CFOUTPUT>
	<H1>Data Submitted!</H1>
     </CFOUTPUT>
	
	<CFMAIL type="HTML" 
		to="network-wo@mail.sdsu.edu" 
		from="libinfosys@mail.sdsu.edu"
		subject="TNS Network Work Order"
          cc="#FORM.Contact_Email#"
 	>

<TABLE width="55%" align="LEFT"> 
     <TR>
          <TD align="left" width="25%" valign="TOP"> WO Type</TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.WO_Type# </TD>
     </TR>
     <TR>
          <TD align="left" width="25%" valign="TOP"> Acct Admin First Name </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Acct_FName# </TD>
     </TR> 
     <TR>
          <TD align="left" width="25%" valign="TOP"> Acct Admin Last Name</TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Acct_LName# </TD>
     </TR>
     <TR>
          <TD align="left" width="25%" valign="TOP"> Acct Admin Phone Number </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Acct_Phone# </TD>
     </TR>
     <TR>
          <TD align="left" width="25%" valign="TOP"> Acct Account Number </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Acct_Num# </TD>
     </TR>
     <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
     </TR>
     <TR>
          <TD align="left" width="25%" valign="TOP"> Equip Connection Type </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Connect_Type# </TD>
     </TR>
     <TR>
          <TD align="left" width="25%" valign="TOP"> Equip IP Address </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.IP_Address#</TD>
     </TR>
     <TR>
          <TD align="left" width="25%" valign="TOP"> Equip Location </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Equip_BldgRm# </TD>
     </TR>                  
     <TR>
          <TD align="left" width="25%" valign="TOP"> Equip MAC Address </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.MAC_Address# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP">Equip Make and Model </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Equip_MakeModel# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Equip Serial Number </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Equip_SNum# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Equip Property ID </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Equip_ID# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Equip Tag </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Equip_Tag# </TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>
    <TR>
          <TD align="left" width="25%" valign="TOP"> IP Request </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.IP_Request# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> IP Subnet Mask</TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Subnet_Mask# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Jack Number Current </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Jack_Curr# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Jack Number New </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Jack_New# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Justify Static IP </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Justify_static_IP# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> New Equipment Location </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.New_BldgRm# </TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>
    <TR>
          <TD align="left" width="25%"> Other Connection </TD>
          <TD align="left" width="30%">
          <CFIF IsDefined('FORM.Other_NIC')>
          	= &nbsp;&nbsp;#FORM.Other_NIC#
          <CFELSE>
          	= &nbsp;&nbsp;N/A
          </CFIF>
          </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Other NIC Description </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Other_NIC_Descr# </TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>
    <TR>
          <TD align="left" width="25%" valign="TOP"> Primary Contact Build Room Location </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Contact_BldgRm# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Primary Contact Email Address </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Contact_Email# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Primary Contact First Name </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Contact_FName# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Primary Contact Last Name </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Contact_LName# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Primary Contact Phone Number </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Contact_Phone# </TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>
    <TR>
          <TD align="left" width="25%" valign="TOP"> User Bldg Room </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.User_BldgRm# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> User Category </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.User_Category# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> User Contact By </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Contact_User_By# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> User Contact Email Address </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Contact_Email_Address# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> User Contact Phone Number </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.User_Phone_Number# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> User Department </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Department# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> User First Name </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.User_First_Name# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> User Last Name </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.User_Last_Name# </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> User Middle Name </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.User_Middle_Name# </TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>
    <TR>
          <TD align="left" width="25%" valign="TOP"> Work Involves EBA-111 Data Center </TD>
          <TD align="left" width="30%" valign="TOP">
          	= &nbsp;&nbsp;#FORM.Work_involves_EBA111_Data_Center#
          <CFIF  #FORM.Work_involves_EBA111_Data_Center# EQ "YES">
               &nbsp;&nbsp;(forward work order to ehodge@mail.sdsu.edu and ok@mail.sdsu.edu ASAP)
          </CFIF>
          </TD>
    </TR>      
    <TR>
          <TD align="left" width="25%" valign="TOP"> Work/Problem Description </TD>
          <TD align="left" width="30%" valign="TOP"> = &nbsp;&nbsp;#FORM.Problem# </TD>
    </TR>      
</TABLE>
         
	</CFMAIL> 

<CFOUTPUT>
	<CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
		<SCRIPT language="JavaScript">
               <!-- 
                    alert("Data Submitted!");
                    window.close();
               -->
          </SCRIPT>
          <CFEXIT>
     </CFIF>	
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/tnsworkorderssubmit.cfm?PROCESS=SUBMIT" />
     <CFEXIT>
</CFOUTPUT>
</CFIF> 

<CFOUTPUT>
<CFIF FIND('DELETE', #FORM.PROCESSTNSWORKORDERS#, 1) NEQ 0 OR #FORM.PROCESSTNSWORKORDERS# EQ "CANCELADD">
	<CFQUERY name="DeleteTNSWorkOrders" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	TNSWORKORDERS
		WHERE		TNSWO_ID = #val(Cookie.TNSWO_ID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
     <CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data Deleted!");
				window.close();
			 -->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
	<CFIF FIND('DELETE', #FORM.PROCESSTNSWORKORDERS#, 1) NEQ 0>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/tnsworkorders.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>