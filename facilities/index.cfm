<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/06/2012 --->
<!--- Date in Production: 07/06/2012 --->
<!--- Module: Facilities Application Home Page--->
<!-- Last modified by John R. Pastori on 07/01/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/index.cfm">
<CFSET CONTENT_UPDATED = "July 01, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities Application</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

	<SCRIPT language="JavaScript">
		<!--
			if (window.history.forward(1) != null) {
				window.history.forward(1); 
			}

		//-->
	</SCRIPT>

</HEAD>

<BODY>

<CFOUTPUT>
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/facilities">

<!--- APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "NO">
<CFSET Client.ACCESSINGFACILITIES = "YES">
<CFSET Client.ACCESSINGHARDWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGIDTCHATTER = "NO">
<CFSET Client.ACCESSINGINSTRUCTION = "NO">
<CFSET Client.ACCESSINGLIBQUAL = "NO">
<CFSET Client.ACCESSINGLIBSECURITY = "NO">
<CFSET Client.ACCESSINGLIBSHAREDDATA = "NO">
<CFSET Client.ACCESSINGLIBSTATS = "NO">
<CFSET Client.ACCESSINGPURCHASING = "NO">
<CFSET Client.ACCESSINGSERVICEREQUESTS = "NO">
<CFSET Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<CFSET Client.ACCESSINGWEBREPORTS = "NO">

<CFSET SESSION.ORIGINSERVER = "">
<CFSET SESSION.RETURNPGM = "">

<CFINCLUDE template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<CFCOOKIE name="BUILDINGNAMEID" secure="NO" expires="NOW">
<CFCOOKIE name="CUSTID" secure="NO" expires="NOW">
<CFCOOKIE name="CUSTWRADDID" secure="NO" expires="NOW">
<CFCOOKIE name="EXTERNLSHOPID" secure="NO" expires="NOW">
<CFCOOKIE name="EXTERNLWOID" secure="NO" expires="NOW">
<CFCOOKIE name="JACKID" secure="NO" expires="NOW">
<CFCOOKIE name="JOBID" secure="NO" expires="NOW">
<CFCOOKIE name="KEYREQUESTID" secure="NO" expires="NOW">
<CFCOOKIE name="KEYTYPEID" secure="NO" expires="NOW">
<CFCOOKIE name="LOCATIONDESCRIPTIONID" secure="NO" expires="NOW">
<CFCOOKIE name="LOCID" secure="NO" expires="NOW">
<CFCOOKIE name="MOVEREQUESTID" secure="NO" expires="NOW">
<CFCOOKIE name="MOVETYPEID" secure="NO" expires="NOW">
<CFCOOKIE name="REQUESTSTATUSID" secure="NO" expires="NOW">
<CFCOOKIE name="REQUESTTYPEID" secure="NO" expires="NOW">
<CFCOOKIE name="TNSREQUESTID" secure="NO" expires="NOW">
<CFCOOKIE name="VLANINFOID" secure="NO" expires="NOW">
<CFCOOKIE name="WALLDIRID" secure="NO" expires="NOW">
<CFCOOKIE name="WOID" secure="NO" expires="NOW">


<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center" valign="middle"><H1>Facilities Application</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">
			<H3>FACILITIES REQUEST PROCESSING</H3>
		</TH>
	</CFIF>
		<TH align="LEFT" valign="top">
			<H3>FACILITIES REQUEST REPORTS</H3>
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
          	<BR>
			<A href="/#application.type#apps/facilities/custwradd.cfm">Add </A> Customer Work Request
           </TD>
		<TD align="LEFT" valign="top">
          	<BR />
			<A href="/#application.type#apps/facilities/custqueryreport.cfm">Customer Query</A> Report
          </TD>
	</TR>
     <TR>
		<TD align="LEFT" valign="top" colspan="2"><HR></TD>
	</TR>     
	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Work Request - <A href="/#application.type#apps/facilities/workrequest.cfm?PROCESS=ADD">Add</A> or
			<A href="/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR /><BR />
			<!--- Request - <A href="/#application.type#apps/facilities/workrequestapproval.cfm?PROCESS=APPROVAL&INITREQ=WO&APPROVAL=MGMT">Management Approval</A><BR /> --->
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/facilities/workrequestreports.cfm?PROCESS=REPORT">Work Request </A>Reports<BR />
		</TD>
	</TR>

	<CFIF #Client.ProcessFlag# EQ "Yes">
	<TR>
		<TH align="LEFT" valign="top">
			<H3>EXTERNAL SHOPS DATA SUBMISSION</H3>
		</TH>
		<TH align="LEFT" valign="top">
			<H3>EXTERNAL SHOPS REPORTS </H3>
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/facilities/physicalplantwo.cfm">Physical Plant</A> Work Order<BR /><BR />
          	
			<!--- <A href="/#application.type#apps/facilities/surplusitemsdisposalservice.cfm"> --->TNS Telephone Service  Requests<BR /><BR />
		</TD>
		<TD align="LEFT" valign="top">&nbsp;&nbsp;</TD>
	</TR>
     <TR>
		<TD align="LEFT" valign="top" colspan="2"><HR></TD>
	</TR>
     <TR>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=ADD">Add</A> or
			<A href="/#application.type#apps/facilities/extrnlwoinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete </A> External Shops Provided Info <BR />
               Modify List - <A href="/#application.type#apps/facilities/requestednotcomplkuplist.cfm?LIST_LOOKUP=LOOKUP"> Requested/Not Complete <BR />	
          </TD>
          <TD align="LEFT" valign="top">
			<A href="/#application.type#apps/facilities/extrnlwodbreport.cfm">External Shops</A> Reports<BR />
               Display List - <A href="/#application.type#apps/facilities/requestednotcomplkuplist.cfm?LIST_LOOKUP=LIST""> Requested/Not Complete <BR />	<BR />
         </TD>
	</TR>

	</CFIF>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">
			<H3>SHARED DATA PROCESSING</H3>
		</TH>
	</CFIF>
		<TH align="LEFT" valign="top">
			<H3>SHARED DATA REPORTS</H3>
		</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Location - <A href="/#application.type#apps/facilities/locationinfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/locationinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
		<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
			WallJack Single Record - <A href="/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			WallJack Multiple Record - <A href="/#application.type#apps/facilities/walljacksmultiplemoddel.cfm?PROCESS=MULTMODDEL">Modify/Delete</A> or 
               <A href="/#application.type#apps/facilities/walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP">Modify/Delete Loop</A><BR /><BR />
		</CFIF>
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/facilities/locationdbreport.cfm">Location</A><BR />
			<A href="/#application.type#apps/facilities/walljacksdbreport.cfm?PROCESS=REPORT">Wall Jack</A><BR />
		</TD>
	</TR>

	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
	<TR>
		<TH align="LEFT" valign="top">
			<H3>SUPPORT FILES PROCESSING</H3>
		</TH>
		<TH align="LEFT" valign="top">
			<H3>SUPPORT FILES REPORTS</H3>
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Building Names - <A href="/#application.type#apps/facilities/buildingnames.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/buildingnames.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			External Shops - <A href="/#application.type#apps/facilities/externlshops.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/externlshops.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Key Types - <A href="/#application.type#apps/facilities/keytypes.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/keytypes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Location Description - <A href="/#application.type#apps/facilities/locationdescription.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/locationdescription.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Move Types - <A href="/#application.type#apps/facilities/movetypes.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/movetypes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Request Status - <A href="/#application.type#apps/facilities/requeststatus.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/requeststatus.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Request Types - <A href="/#application.type#apps/facilities/requesttypes.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/requesttypes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			VLan Info - <A href="/#application.type#apps/facilities/vlaninfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/vlaninfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Wall Direction - <A href="/#application.type#apps/facilities/walldirection.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/facilities/walldirection.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
		</TD>

		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/facilities/buildingnamesdbreport.cfm">Building Names</A><BR />
			<A href="/#application.type#apps/facilities/externlshopsdbreport.cfm">External Shops</A><BR />
			<A href="/#application.type#apps/facilities/keytypesdbreport.cfm">Key Types</A><BR />
			<A href="/#application.type#apps/facilities/locationdescriptiondbreport.cfm">Location Description</A><BR />
			<A href="/#application.type#apps/facilities/movetypesdbreport.cfm">Move Types</A><BR />
			<A href="/#application.type#apps/facilities/requeststatusdbreport.cfm">Request Status</A><BR />
			<A href="/#application.type#apps/facilities/requesttypesdbreport.cfm">Request Types</A><BR />
               <A href="/#application.type#apps/facilities/vlaninfodbreport.cfm">VLan Info</A><BR />
			<A href="/#application.type#apps/facilities/walldirectiondbreport.cfm">Wall Direction</A><BR />
		</TD>
	</TR>
	</CFIF>

	<CFINCLUDE template="../IDTApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>