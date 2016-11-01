<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: LFOLKS Forms Home Page--->
<!-- Last modified by John R. Pastori on 03/28/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/forms/index.cfm">
<CFSET CONTENT_UPDATED = "March 28, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/forms">

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE, FAX, FULLNAME,
               DIALINGCAPABILITY, LONGDISTAUTHCODE, UNITID, LOCATIONID, UNITHEAD, DEPTCHAIR, ALLOWEDTOAPPROVE, CONTACTBY,
               SECURITYLEVELID, PASSWORD, BIBLIOGRAPHER, COMMENTS, AA_COMMENTS, ACTIVE
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = #Client.CUSTOMERID#
	ORDER BY	CUSTOMERS.FULLNAME
</CFQUERY>

<HTML>
<HEAD>
	<TITLE>LFOLKS Forms</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">

	<SCRIPT language="JavaScript">
		<!--
			if (window.history.forward(1) != null) {
				window.history.forward(1); 
			}

		//-->
	</SCRIPT>

</HEAD>

<BODY>
<CFINCLUDE template="/include/coldfusion/header.cfm">
<CFOUTPUT>

<TABLE width="100%" border="3" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center" valign="middle"><H1>Forms</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
     <TR>
          <TD align="left" valign="BOTTOM">&nbsp;&nbsp;</TD>
     </TR>
</TABLE>
<TABLE align="center" width="100%" border="3" cellspacing="0" cellpadding="0">
	<TR>
     	<TD align="left" valign="TOP">
               <TABLE align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
                    <TR>
                         <TD align="left" valign="BOTTOM" >
                              <BR>
                              &nbsp;&nbsp;<STRONG>Absence Requests</STRONG>
                              <UL>
                                   <A href="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=ADD"> Add</A><BR>
                                   <A href="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR>
                                   <A href="/#application.type#apps/webreports/absencerequestreportbyreq.cfm"> Report By Requester</A><BR>
                         <CFIF (ListCustomers.UNITHEAD EQ 'YES' OR ListCustomers.DEPTCHAIR EQ 'YES') AND ListCustomers.ALLOWEDTOAPPROVE EQ 'YES'>
                              <CFSET session.ABSENCEREQUESTSSELECTED = 0>
                                   <A href="/#application.type#apps/webreports/absencerequestapproval.cfm"> Approval</A><BR>
                         </CFIF>
                         	<BR>
                              </UL>
                         </TD>
                    </TR>
                    <TR>
                         <TD align="left" valign="BOTTOM">   
                              &nbsp;&nbsp;<STRONG>Collection Development</STRONG>
                              <UL>
                                   <A href="http://library.sdsu.edu/sites/default/files/gik_form.pdf" target="_blank">Gift-in-Kind Donation Form</A><BR><BR>
                              </UL>
                          </TD>
                    </TR>
                    <TR>
                         <TD align="left" valign="BOTTOM">       
                              &nbsp;&nbsp;<STRONG>Facilities</STRONG>
                              <UL>
                                   Please email <A href="mailto:facility@rohan.sdsu.edu">facility@rohan.sdsu.edu</A>, your non-urgent Facility Requests.<BR><BR>
                                   <STRONG>Please call Work Control (44754) for All URGENT</STRONG> (potentially hazardous) <BR>
                                   Facility Requests and then email <A href="mailto:facility@rohan.sdsu.edu">facility@rohan.sdsu.edu</A> with the current status.<BR><BR>
                                   <FONT color="RED">** Under Development ** </FONT> <BR>
                                   <!--- <A href="/#application.type#apps/facilities/workorder.cfm?PROCESS=Add" target="_blank"> --->New Request<!--- </A> ---><BR>
                                   <!--- <A href="/#application.type#apps/facilities/workorderreports.cfm?PROCESS=REPORT" target="_blank"> --->Work Order Reports<!--- </A> ---><BR><BR>
                              </UL>
                         </TD>
                    </TR>
                    <TR>
                         <TD align="left" valign="BOTTOM">   
                              &nbsp;&nbsp;<STRONG>Instructional Services</STRONG>
                              <UL>
                                   <A href="/#application.type#apps/instruction/orientstats.cfm?PROCESS=Add">Add</A><BR>
                                   <A href="/#application.type#apps/instruction/orientstats.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR>
                                   <A href="/#application.type#apps/instruction/orientstatscountrpts.cfm">Count Reports</A><BR>
                                   <A href="/#application.type#apps/instruction/orientstatsdbreport.cfm">Instructor Reports</A><BR><BR>
                              </UL>
                        </TD>
                    </TR>
                    <TR>
                         <TD align="left" valign="BOTTOM">
                              &nbsp;&nbsp;<A href="http://lfolkswiki.sdsu.edu/index.php/IDT"><STRONG>LIT &amp; DI/IDT</STRONG></A>
                              <UL>
                                   <STRONG>Accounts</STRONG><BR>
                                   <A href="https://arwen.sdsu.edu/share/pacsup/PACUser_Authorization_Request_form.doc" target="_blank"> PACUser Authorization Request </A> (.doc)<BR>
                                   <A href="http://www-rohan.sdsu.edu/acct.shtml">ROHAN and Moria Account Forms</A> (.pdf)<BR><BR>
                                   
                                   <STRONG>Hardware/Software</STRONG><BR>
                                   <A href="/#application.type#apps/hardwareinventory/hardwareinventorydbreports.cfm?PROCESS=REPORT">Hardware Reports</A><BR><BR>
                                   <FONT color="RED">** Under Development ** </FONT><BR>
                                   Software Reports<BR><BR>
                                   
                                   <STRONG>Service Requests</STRONG><BR>
                                   Add <A href="/#application.type#apps/servicerequests/custsradd.cfm"> Customer SR</A> <BR>
                                   <A href="/#application.type#apps/servicerequests/custqueryreport.cfm"> Customer SR Query </A>Report<BR>
                                   <A href="/#application.type#apps/servicerequests/srunitcustreport.cfm">Unit Liaison Query</A> Report<BR>
                                   Customer <A href="/#application.type#apps/servicerequests/custnetworkvoiceworeport.cfm?PROCESS=NETWORK">Network Work Order</A> Report<BR> 
               				Customer <A href="/#application.type#apps/servicerequests/custnetworkvoiceworeport.cfm?PROCESS=VOICE">Voice Work Order</A> Report<BR><BR>  
                              </UL>			
                         </TD>
                    </TR>
                    <TR>
                         <TD align="left" valign="BOTTOM">
                              &nbsp;&nbsp;<STRONG>Other Library Forms</STRONG>
                              <UL>
                                   <A href="http://infodome.sdsu.edu/forms/room.shtml" target="_blank">Library Presentation Room Request</A><BR>
                                   <A href="http://hr.sdsu.edu/pdf/Employment/SDSUVolunteerForm_approved(5-6-11).doc" target="_blank">Library (SDSU) Volunteer Form (.doc)</A><BR><BR>
                              </UL>
                    </TR>
               </TABLE>
		</TD>
		<TD align="left" valign="TOP">
			<TABLE align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
               	<TR>
					<TD align="left" valign="BOTTOM">
                         	<BR>
                              &nbsp;&nbsp;<A href="http://www.sdsu.edu/cbo/eforms"><STRONG>Other SDSU/Foundation Forms</STRONG></A>
                              <UL>
                                   Fee Waiver - <A href="http://hr.sdsu.edu/pdf/Benefit/EmplFeeWaiver.pdf" target="_blank">Employee</A> (.pdf)<BR>
                                   Fee Waiver - <A href="http://hr.sdsu.edu/pdf/Benefit/DepenFeeWaiver.pdf" target="_blank">Faculty/Staff Dependant</A> (.pdf) <BR>
                                   <A href="http://hr.sdsu.edu/pdf/Payroll/AttendanceSum.xls" target="_blank">HR Attendance Summary </A> (.xls)<BR>
                                   <A href="http://www.sdsu.edu/cbo/eforms/" target="_blank"> More Electronic Forms</A><BR><BR>
                              </UL>	
					</TD>
				</TR>
               	<TR>
					<TD align="left" valign="BOTTOM">
						&nbsp;&nbsp;<STRONG>Procurement Forms</STRONG>
                              <UL>
                    			<A href="/#application.type#apps/forms/foundationreimbursementform.xls" target="_blank">Foundation Reimbursement</A> (.xls)<BR>
                   				Library <A href="/#application.type#apps/forms/liborderform10.xls" target="_blank">Requisition &amp; Order </A>Form (.xls)<BR>
                     			Office Depot Direct Web <A href="/#application.type#apps/forms/officedepotdir.doc" target="_blank">Account Application</A> (.doc)<BR>
                     			<A href="/#application.type#apps/forms/smalldollar.xls" target="_blank">SDSU Small Dollar Reimbursement</A> (.xls)<BR><BR>
                    			<FONT color="RED">** Under Development ** </FONT> <BR>
                             <!--- <a href="/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=Add"> --->Purchase Request - Hardware/Software<!--- </a> ---><BR><BR>
                              </UL>	
					</TD>
				</TR>
				<TR>
					<TD align="left" valign="BOTTOM">
						&nbsp;&nbsp;<STRONG><A href="https://arwen.sdsu.edu/share/Sasuper/">SA Supervisor</A></STRONG>
                              <UL>
                                  	New <A href="https://arwen.sdsu.edu/share/Sasuper/New%20Student%20Employee%20Letter%20Spring%202011.pdf" target="_blank">Student Employee Letter</A> Spring 2011(.pdf)<BR>
                                   <A href="https://arwen.sdsu.edu/share/Sasuper/SA%20EvaluationForm.doc" target="_blank">SA Evaluation Form</A> (.doc)<BR>
                                   <A href="https://arwen.sdsu.edu/share/Sasuper/SA%20Increase%20Form.doc" target="_blank"> SA Increase Form</A> (.doc)
                                   <COM>(**Must also complete: appropriate SEA form below.)</COM><BR>
                                   <A href="https://arwen.sdsu.edu/share/Sasuper/SA%20Termination%20Form.doc" target="_blank">SA Termination Form</A> (.doc)<BR>
                                   SEA 1868 Non Resident Alien (NRA)<A href="https://arwen.sdsu.edu/share/SASUPER/SEA_1868_NRA_Sp11.pdf" target="_blank"> Student Employment Authorization</A> Form (.pdf)<BR>
                                   SEA 1870 SA <A href="https://arwen.sdsu.edu/share/Sasuper/SEA_1870_State_Sp11.pdf" target="_blank">  Student Employment Authorization</A> Form (.pdf)<BR>
                                   SEA 1871 Federal Work Study (FWS) <A href="https://arwen.sdsu.edu/share/Sasuper/SEA_1871_FWS_Sp11.pdf" target="_blank"> Student Employment Authorization</A> Form(.pdf)<BR>
                                   <A href="https://arwen.sdsu.edu/share/Sasuper/SocialSecurityChecklistforNRA1868.doc" target="_blank">Social Security Checklist</A> for NRA 1868 (.doc)<BR><BR>
                              </UL>
					</TD>
				</TR>
				<TR>
					<TD align="left" valign="BOTTOM">
						&nbsp;&nbsp;<STRONG>Travel</STRONG>
                              <UL>
                              	Authorization For <A href="http://www.dps.sdsu.edu/pdf/authdmvinfo.pdf" target="_blank">Release of Driver Record</A> Information (.pdf)<BR>
                                   Authorization To <A href="http://www.police.sdsu.edu/pdf/AuthDriveOfficialBusForm.pdf" target="_blank">Drive on Official University Business</A> (.pdf)<BR>
                   				Authorization To <A href="http://www.dps.sdsu.edu/pdf/std261.pdf" target="_blank">Use Private Vehicle</A>(.pdf)<BR>
							CSU <A href="https://centralstationu.skillport.com/skillportfe/login.action" target="_blank">Online Defensive Driving Course</A> (Login)<BR>
                   				<A href="http://riskmgmt.sdsu.edu/pdf/ForeignTravInsr.pdf" target="_blank">Foreign Travel Insurance</A> (.pdf)<BR>
                                   Professional <A href="/#application.type#apps/forms/fundingreq.pdf" target="_blank">Travel and Funding</A> Request (.pdf)<BR>
                   				Request For <A href="http://www.dps.sdsu.edu/pdf/Waiver_Pull_Request.pdf" target="_blank">Temporary Waiver </A> of Defensive Driving(.pdf)<BR>
                                   <A href="http://bfa.sdsu.edu/ap/pdf/t2.xls" target="_blank">SDSU Form T2</A> (.xls)<BR>
                   				State Of California <A href="http://bfa.sdsu.edu/ap/pdf/travelexpense03.xls" target="_blank">Travel Expense Claim</A><BR><BR>
                              </UL>
					</TD>
				</TR>
				<TR>
					<TD align="left" valign="BOTTOM">
						&nbsp;&nbsp;<STRONG>Workers Compensation</STRONG>
                              <UL>
                              	<A href="http://hr.sdsu.edu/pdf/Work%20Comp/WCClaimFormInstr.pdf" target="_blank">Employee Claim</A> (.pdf)<BR>
                    			<A href="http://hr.sdsu.edu/pdf/Work%20Comp/SupvReport.pdf" target="_blank">Supervisor's Report</A> (.pdf)<BR>
                                   <A href="http://bfa.sdsu.edu/~person/pdf/Work%20Comp/SupvChkLst.pdf" target="_blank"> Supervisor's Responsibility</A> (.pdf)<BR>
                                   What To Do If There is <A href="http://bfa.sdsu.edu/%7Eperson/workerscomp/workinjury.htm">An Injury At Work</A><BR>
                    			<A href="http://bfa.sdsu.edu/%7Eperson/workerscomp/index.htm" target="_blank">Workers' Compensation</A>
                              </UL>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<P>&nbsp;&nbsp;</P>
<TABLE width="100%" border="0" cellspacing="0" cellpadding="2" align="CENTER">
	<TR>
		<TD align="LEFT">
			<A href="/PRODapps/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES">Home</A>
		</TD>
	</TR>
</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">

</CFOUTPUT>
</BODY>
</HTML>
