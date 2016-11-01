<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/05/2012 --->
<!--- Date in Production: 07/05/2012 --->
<!--- Module: Library IDT Purchasing Database Home Page--->
<!-- Last modified by John R. Pastori on 07/05/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/index.cfm">
<CFSET CONTENT_UPDATED = "July 05, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchasing Application</TITLE>
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
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/purchasing">

<!--- APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "NO">
<CFSET Client.ACCESSINGFACILITIES = "NO">
<CFSET Client.ACCESSINGHARDWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGIDTCHATTER = "NO">
<CFSET Client.ACCESSINGINSTRUCTION = "NO">
<CFSET Client.ACCESSINGLIBQUAL = "NO">
<CFSET Client.ACCESSINGLIBSECURITY = "NO">
<CFSET Client.ACCESSINGLIBSHAREDDATA = "NO">
<CFSET Client.ACCESSINGLIBSTATS = "NO">
<CFSET Client.ACCESSINGPURCHASING = "YES">
<CFSET Client.ACCESSINGSERVICEREQUESTS = "NO">
<CFSET Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<CFSET Client.ACCESSINGWEBREPORTS = "NO">

<CFSET SESSION.ORIGINSERVER = "">
<CFSET SESSION.PRLModLoop = "NO">
<CFSET SESSION.RETURNPGM = "">

<CFINCLUDE template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<CFCOOKIE name="BUDGETTYPEID" secure="NO" expires="NOW">
<CFCOOKIE name="FUNDACCTID" secure="NO" expires="NOW">
<CFCOOKIE name="LICENSESTATUSID" secure="NO" expires="NOW">
<CFCOOKIE name="ORGCODEID" secure="NO" expires="NOW">
<CFCOOKIE name="PURCHREQID" secure="NO" expires="NOW">
<CFCOOKIE name="PURCHREQLINEID" secure="NO" expires="NOW">
<CFCOOKIE name="PRLSWSERIALNUMID" secure="NO" expires="NOW">
<CFCOOKIE name="STATEID" secure="NO" expires="NOW">
<CFCOOKIE name="VENDORID" secure="NO" expires="NOW">
<CFCOOKIE name="VENDORCONTACTID" secure="NO" expires="NOW">

<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center"><H1>IDT Purchasing Application</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../IDTApplicationLinks.cfm">

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">PURCHASING PROCESSING</TH>
	</CFIF>
		<TH align="LEFT" valign="top">PURCHASING REPORTS</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=Add"> Add</A> New Purch Req<BR />
			<A href="/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A> an Existing Purch Req<BR /><BR />
			<A href="/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A> an Existing or Legacy Purch Req Line<BR />
			<A href="/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A> an Existing Purch Req Line Serial Number<BR /><BR />
			<A href="/#application.type#apps/purchasing/purchreqaddlegacy.cfm?PROCESS=Add"> Add</A> Legacy Purch Req<BR />
			<A href="/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE&LEGACY=YES"> Modify/Delete</A> a Legacy Purch Req<BR />
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			Purch Req <A href="/#application.type#apps/purchasing/purchreqforms.cfm"> Forms</A> or 
					  <A href="/#application.type#apps/purchasing/reqstatusreport.cfm"> Status</A><BR />
			Purch Req <A href="/#application.type#apps/purchasing/reqlogreport.cfm"> Log</A> or 
					  <A href="/#application.type#apps/purchasing/reqlinelogreport.cfm"> Line Log</A><BR /><BR />
			<A href="/#application.type#apps/purchasing/reqlookupreport.cfm"> Req Lookup</A><BR />
			<A href="/#application.type#apps/purchasing/reqlinelookupreport.cfm"> Line Lookup</A><BR /><BR />
			<A href="/#application.type#apps/purchasing/purchcountreports.cfm"> Purch Count Reports</A><BR />
			
		</TD>
	</TR>

	<TR>
     	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
		<TH align="LEFT" valign="top">SUPPORT FILE PROCESSING</TH>
          </CFIF>
		<TH align="LEFT" valign="top">SUPPORT FILE REPORTS</TH>
	</TR>

	<TR>
     	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
          	Budget Types - <A href="/#application.type#apps/purchasing/budgettypes.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/purchasing/budgettypes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Fund Accounts - <A href="/#application.type#apps/purchasing/fundaccts.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/purchasing/fundaccts.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			License Status - <A href="/#application.type#apps/purchasing/licensestatus.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/purchasing/licensestatus.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Owning Org Codes - <A href="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			States - <A href="/#application.type#apps/libshareddata/states.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/states.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Unit Of Measure - <A href="/#application.type#apps/purchasing/unitofmeasure.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/purchasing/unitofmeasure.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Vendor - <A href="/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/purchasing/vendorinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Vendor Contacts - <A href="/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/purchasing/vendorcontactsinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR /><BR />
		</TD>
          </CFIF>
		<TD align="LEFT" valign="top">
          	<A href="/#application.type#apps/purchasing/budgettypesdbreport.cfm">Budget Types</A><BR />
			<A href="/#application.type#apps/purchasing/fundacctsdbreport.cfm">Fund Accounts</A><BR />
			<A href="/#application.type#apps/purchasing/licensestatusdbreport.cfm">License Status</A><BR />
			<A href="/#application.type#apps/libshareddata/orgcodesdbreport.cfm">Owning Org Codes</A><BR />
			<A href="/#application.type#apps/libshareddata/statesdbreport.cfm">States</A><BR />
			<A href="/#application.type#apps/purchasing/unitofmeasuredbreport.cfm">Unit Of Measure</A><BR />
			<A href="/#application.type#apps/purchasing/vendordbreport.cfm">Vendor</A><BR />
			<A href="/#application.type#apps/purchasing/vendorcontactsdbreport.cfm">Vendor Contacts</A><BR /><BR />
		</TD>
	</TR>

	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>