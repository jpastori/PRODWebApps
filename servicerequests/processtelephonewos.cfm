<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processtelephonewos.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/01/2013 --->
<!--- Date in Production: 03/01/2013 --->
<!--- Module: Process Information to IDT Service Requests - Telephone Work Orders --->
<!-- Last modified by John R. Pastori on 02/11/2016 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Telephone Work Orders</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FIND('CANCEL', #FORM.PROCESSTELEPHONEWOS#, 1) EQ 0>
	<CFIF IsDefined('FORM.WO_DUEDATE') AND #FORM.WO_DUEDATE# NEQ ''>
		<CFSET FORM.WO_DUEDATE = #DateFormat(FORM.WO_DUEDATE, 'dd-mmm-yyyy')#>
	</CFIF>
</CFIF>

<CFIF (FIND('ADD', #FORM.PROCESSTELEPHONEWOS#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSTELEPHONEWOS#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSTELEPHONEWOS#, 1) EQ 0)>

	<CFQUERY name="ModifyTelephoneWOItems" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	TNSWORKORDERS
		SET		WO_TYPE = '#FORM.WO_TYPE#',
				WO_STATUS = '#FORM.WO_STATUS#',
               <CFIF IsDefined('FORM.STAFFID')>
				STAFFID = #val(FORM.STAFFID)#,
               </CFIF>
			<CFIF IsDefined('FORM.WO_DUEDATE') AND #FORM.WO_DUEDATE# NEQ ''>
				WO_DUEDATE = TO_DATE('#FORM.WO_DUEDATE#', 'DD-MON-YYYY'),
			</CFIF>
			<CFIF IsDefined('FORM.WO_NUMBER') AND #FORM.WO_NUMBER# NEQ ''>
				WO_NUMBER = UPPER('#FORM.WO_NUMBER#'),
			</CFIF>
				WORK_DESCRIPTION = UPPER('#FORM.WORK_DESCRIPTION#'),                 
               <CFIF IsDefined('FORM.PHONE_CURRENT_JACKNUMBER') AND #FORM.PHONE_CURRENT_JACKNUMBER# NEQ ''>
                    PHONE_CURRENT_JACKNUMBER = '#FORM.PHONE_CURRENT_JACKNUMBER#',
               </CFIF>
               <CFIF IsDefined('FORM.PHONE_NEW_JACKNUMBER') AND #FORM.PHONE_NEW_JACKNUMBER# NEQ ''>
                    PHONE_NEW_JACKNUMBER = '#FORM.PHONE_NEW_JACKNUMBER#',
               </CFIF>
               	 NEW_LOCATION = #val(FORM.NEW_LOCATION)#
		WHERE	(TNSWO_ID = #val(Cookie.TNSWO_ID)#)
	</CFQUERY>
     
     <CFQUERY name="ModifyRequesterPhoneInfo" datasource="#application.type#LIBSHAREDDATA">
		UPDATE	CUSTOMERS
		SET		DIALINGCAPABILITY = UPPER('#FORM.DIALINGCAPABILITY#'),
				PHONEBOOKLISTING = UPPER('#FORM.PHONEBOOKLISTING#'),
                    VOICEMAIL = UPPER('#FORM.VOICEMAIL#')
		WHERE	(CUSTOMERID = #val(FORM.REQUESTERID)#)
	</CFQUERY>
     
	<CFIF FIND('ADD', #FORM.PROCESSTELEPHONEWOS#, 1) NEQ 0>
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
				window.open("/#application.type#apps/servicerequests/srstaffassigninfo.cfm?PROCESS=ADD&SRID=#val(Cookie.SRID)#","Add New Staff Assignment for Telephone Work Order", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
			-->
		</SCRIPT>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm?PROCESS=ADD" />
	<CFELSEIF FIND('MODIFY', #FORM.PROCESSTELEPHONEWOS#, 1) NEQ 0>
		<H1>Data MODIFIED!</H1>
		<CFIF #FORM.PROCESSTELEPHONEWOS# EQ 'MODIFY AND REVIEW'>
          	<CFIF (IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ "YES") OR (IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES")>
               	<SCRIPT language="JavaScript">
					<!-- 
						window.open("/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=SUBMIT&LOOKUPWO=FOUND&STAFFLOOP=YES&SRID=#val(Cookie.SRID)#",
                          				  "Submit TNS Requests","alwaysRaised=yes,dependent=no,width=1290,height=950,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25"); window.close();
					-->
				</SCRIPT>
                    <CFEXIT>
                    <CFEXIT>
               <CFELSE>	
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=SUBMIT&SRID=#val(Cookie.SRID)#&LOOKUPWO=FOUND" />
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
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE" />
		</CFIF>
	</CFIF>
</CFIF>

</CFOUTPUT>
<CFIF FIND('SUBMIT', FORM.PROCESSTELEPHONEWOS, 1) NEQ 0> 
	<CFOUTPUT>
	<H1>Data Submitted!</H1>
     </CFOUTPUT>

	<CFMAIL type="HTML" 
		to="voicewo@mail.sdsu.edu" 
		from="libinfosys@mail.sdsu.edu"
		subject="Telephone Work Order"
		cc="#FORM.Contact_Email#"
 	>

<TABLE width="55%" align="LEFT"> 
      <TR>
          <TD align="left" width="10%" valign="TOP">Acct_FName:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Acct_FName#</TD>
     </TR> 
     <TR>
          <TD align="left" width="10%" valign="TOP">Acct_LName:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Acct_LName#</TD>
     </TR>
     <TR>
          <TD align="left" width="10%" valign="TOP">Acct_Num:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Acct_Num#</TD>
     </TR>
     <TR>
          <TD align="left" width="10%" valign="TOP">Acct_Phone:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Acct_Phone#</TD>
     </TR>
     <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
     </TR>
     <TR>
          <TD align="left" width="10%" valign="TOP">Building_Room_Curr:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Building_Room_Curr#</TD>
    </TR>
    <TR>
          <TD align="left" width="10%" valign="TOP">Building_Room_New:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Building_Room_New#</TD>
    </TR>
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>
    <TR>
          <TD align="left" width="10%" valign="TOP">Contact_BldgRm:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Contact_BldgRm#</TD>
    </TR>
    <TR>
          <TD align="left" width="10%" valign="TOP">Contact_By:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Contact_By#</TD>
    </TR>        
    <TR>
          <TD align="left" width="10%" valign="TOP">Contact_Email:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Contact_Email#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">Contact_FName:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Contact_FName#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">Contact_LName:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Contact_LName#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">Contact_Phone:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Contact_Phone#</TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>    
    <TR>
          <TD align="left" width="10%" valign="TOP">Department:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Department#</TD>
    </TR>   
    <TR>
          <TD align="left" width="10%" valign="TOP">Description:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Description#</TD>
    </TR>       
    <TR>
          <TD align="left" width="10%" valign="TOP">Dialing:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Dialing#</TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>
    <TR>
          <TD align="left" width="10%" valign="TOP">Jack_Curr:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Jack_Curr#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">Jack_New:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Jack_New#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">Listing_Type:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Listing_Type#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">Select_Telephone_Type:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Select_Telephone_Type#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">Submit:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;Submit</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">Type_of_Request:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Type_of_Request#</TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR>
    <TR>
          <TD align="left" width="10%" valign="TOP">User_Category:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.User_Category#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">User_Email:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.User_Email#</TD>
    </TR>                
    <TR>
          <TD align="left" width="10%" valign="TOP">User_First_Name:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.User_First_Name#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">User_Last_Name:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.User_Last_Name#</TD>
    </TR>      
    <TR>
          <TD align="left" width="10%" valign="TOP">User_Phone:</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.User_Phone#</TD>
    </TR>      
    <TR align="left">
          <TD align="center">&nbsp;&nbsp;</TD>
    </TR> 
    <TR>
          <TD align="left" width="10%" valign="TOP">Voice_Mail_Need</TD>
          <TD align="left" width="45%" valign="TOP">&nbsp;&nbsp;#FORM.Voice_Mail_Need#</TD>
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
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/telephonewossubmit.cfm?PROCESS=SUBMIT" />
     <CFEXIT>
</CFOUTPUT>
</CFIF> 

<CFOUTPUT>
<CFIF FIND('DELETE', #FORM.PROCESSTELEPHONEWOS#, 1) NEQ 0 OR #FORM.PROCESSTELEPHONEWOS# EQ "CANCELADD">
	<CFQUERY name="DeleteTelephoneWOs" datasource="#application.type#SERVICEREQUESTS">
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
	<CFIF FIND('DELETE', #FORM.PROCESSTELEPHONEWOS#, 1) NEQ 0>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/telephonewos.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>